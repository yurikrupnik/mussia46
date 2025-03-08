
# k8s_yaml(kustomize('manifests/dbs'))
k8s_yaml(kustomize('manifests/kustomize/overlays/dev'))

include('./apps/playground/api/Tiltfile')

#k8s_resource("redis-deployment", port_forwards="6379:6379")
#k8s_resource("postgres-deployment", port_forwards="5432:5432")
#k8s_resource("mongodb-deployment", port_forwards="27017:27017")
# k8s_resource("prometheus-grafana", port_forwards="2332:3000")
