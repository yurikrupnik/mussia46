#include "manifests/justfile"
#import 'manifests/justfile'

default:
    echo "Creating a local cluster for local development."
    just _local
    tilt up

#    helm install my-kubeshark kubeshark-helm-charts/kubeshark --version 52.3.69
#    helm repo add kubeshark-helm-charts https://helm.kubeshark.co/

lint:
    popeye -A -s cm
    kubent -o json
    kubescape scan framework nsa --exclude-namespaces kube-system # mitre
    pnpm nx run-many -t lint --parallel --max-parallel=12
    kube-linter lint manifests/kustomize/base/deployment.yml manifests/kustomize/base/service-account.yaml manifests/kustomize/base/service.yml manifests/kustomize/base/network-policy.yaml manifests/kustomize/base/scale.yaml

#    -kubectl create secret generic secret-puller --from-file=creds=./tmp/secret-puller.json
#    -kubectl create configmap k6-load-test --from-file=tss.js
#    -kubectl create secret docker-registry docker-registry-secret --docker-server=me-west1-docker.pkg.dev  --docker-username=_json_key --docker-password="$(cat ./tmp/container-puller.json)" --docker-email=container-puller-sa@devops-386509.iam.gserviceaccount.com

# kubectl apply --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
_local:
    -kind create cluster --config ./scripts/cluster.yaml
    sleep 20
    kubectl apply -f manifests/configs/stage.yaml
    -kubectl create namespace argocd
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    timoni bundle apply -f manifests/bundle.cue -r manifests/runtime.cue --runtime-from-env

#    kubectl apply -k
#    timoni bundle build -f manifests/bundle.cue -r manifests/runtime.cue --runtime-from-env

# kubectl annotate node --all kwasm.sh/kwasm-node=true # Annonate the nodes to support wasm runtime
_eho:
    echo hello

kdash:
    kdash

_istio:
    -kind create cluster --config ./scripts/cluster.yaml
    sleep 20
    istioctl install --set profile=demo --yes
    kubectl label namespace default istio-injection=enabled
    kubectl apply -f manifests/configs/stage.yaml
    -kubectl create secret generic secret-puller --from-file=creds=./tmp/secret-puller.json
    -kubectl create configmap k6-load-test --from-file=tss.js
    -kubectl create secret docker-registry docker-registry-secret --docker-server=me-west1-docker.pkg.dev  --docker-username=_json_key --docker-password="$(cat ./tmp/container-puller.json)" --docker-email=container-puller-sa@devops-386509.iam.gserviceaccount.com
    timoni bundle apply -f manifests/bundle.cue -r manifests/runtime.cue --runtime-from-env

kustomize:
    kustomize build manifests/kustomize/overlays/prod -o output.yaml

migrations:
    sqlx migrate run --database-url=postgres://myuser:mypassword@localhost/mydatabase --source apps/web/playground/migrations/
    sqlx migrate run --database-url=postgres://myuser:mypassword@postgres-service.dbs.svc.cluster.local --source apps/web/playground/migrations/
    redis-cli XGROUP CREATE tasks_stream mygroup $ MKSTREAM
    redis-cli XGROUP CREATE users_stream mygroup $ MKSTREAM

buf:
    #buf init first
    #   add paths for proto files
    buf lint
    buf build
    buf generate

frame:
    cargo update
    cargo flamegraph
    cargo audit
    cross test --target mips64-unknown-linux-gnuabi64

bacon:
    bacon clippy
    bacon test
