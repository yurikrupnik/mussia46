import http from 'k6/http';
import {check} from 'k6';
import {Trend} from 'k6/metrics';

const myTrend = new Trend('waiting_time');

export const options = {
  iterations: 100,
};

// const ENV_VARIABLE =  process.env.ENV_VARIABLE || undefined;
// const url = "http://operators-orc.default.svc.cluster.local:8080/api/todo"; // k8s
// const url = "http://localhost:5201/api/todo"; // local tilt
const baseUrl = "http://localhost:8080"; // local cargo
const url = "http://localhost:8080/api/todo"; // local cargo

function endpointCrudTest(endpointUrl) {
  const url = `${baseUrl}${endpointUrl}`;
  const res = http.get(url);
  // const ress = http.post(url);
  myTrend.add(res.timings.waiting);
  console.log(myTrend.name); // waiting_time
  // vus.
  check(res, {
    'is status 200': (r) => r.status === 200,
    // 'body size is 11,105 bytes': (r) => r.body.length < 11105,
  });
  const payload = JSON.stringify({
    text: 'dam',
  });

  const params = {
    headers: {
      'Content-Type': 'application/json',
    },
  };

  const createdItem = http.post(url, payload, params);

  check(createdItem, {
    'is status 201': (r) => r.status === 201,
    // 'body size is 11,105 bytes': (r) => r.body.length < 11105,
  });

  const createdItemId = createdItem.json().id; // Extract the ID of the created item

  // Update the created item
  const updatePayload = JSON.stringify({
    completed: true,
  });


  const updateUrl = `${url}/${createdItemId}`; // Append the ID to the URL for the update request


  const updateIdem = http.put(updateUrl, updatePayload, params);
  console.log(updateIdem.body);

  check(updateIdem, {
    'is status 200': (r) => r.status === 200,
    // 'body size is 11,105 bytes': (r) => r.body.length < 11105,
  });

  const deletedId = updateIdem.json().id; // Extract the ID of the created item
  const deleteUrl = `${url}/${deletedId}`; // Append the ID to the URL for the update request
  const deleteIdem = http.del(deleteUrl, params);

  check(deleteIdem, {
    'is status 200': (r) => r.status === 200,
    // 'body size is 11,105 bytes': (r) => r.body.length < 11105,
  });
}

export default function () {
  endpointCrudTest("/api/todo");
  // endpointCrudTest("/api/book");
  // const res = http.get(url);
  // myTrend.add(res.timings.waiting);
  // console.log(myTrend.name); // waiting_time
  // // vus.
  // check(res, {
  //   'is status 200': (r) => r.status === 200,
  //   // 'body size is 11,105 bytes': (r) => r.body.length < 11105,
  // });

  // const payload = JSON.stringify({
  //   text: 'dam',
  // });
  //
  // const params = {
  //   headers: {
  //     'Content-Type': 'application/json',
  //   },
  // };
  //
  // const createdItem = http.post(url, payload, params);
  //
  // check(createdItem, {
  //   'is status 201': (r) => r.status === 201,
  //   // 'body size is 11,105 bytes': (r) => r.body.length < 11105,
  // });
  //
  // const createdItemId = createdItem.json().id; // Extract the ID of the created item
  //
  // // Update the created item
  // const updatePayload = JSON.stringify({
  //   completed: true,
  // });
  //
  // const updateUrl = `${url}/${createdItemId}`; // Append the ID to the URL for the update request
  //
  //
  // const updateIdem = http.put(updateUrl, updatePayload, params);
  // console.log(updateIdem.body);
  //
  // check(updateIdem, {
  //   'is status 200': (r) => r.status === 200,
  //   // 'body size is 11,105 bytes': (r) => r.body.length < 11105,
  // });
  //
  // const deletedId = updateIdem.json().id; // Extract the ID of the created item
  // const deleteUrl = `${url}/${deletedId}`; // Append the ID to the URL for the update request
  // const deleteIdem = http.del(deleteUrl, params);
  //
  // check(deleteIdem, {
  //   'is status 200': (r) => r.status === 200,
  //   // 'body size is 11,105 bytes': (r) => r.body.length < 11105,
  // });
}
