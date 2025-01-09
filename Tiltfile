local_resource('bun', cmd='bun install', deps=['package.json'], labels=['bun'])

k8s_yaml(kustomize('manifests/dbs'))
k8s_yaml(kustomize('manifests/kustomize/overlays/dev'))
