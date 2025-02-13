import my_package.be.config as config
import my_package.be.functions as f
import k8s.api.apps.v1 as apps


_deployment = apps.Deployment {
    metadata.name = "my-app"
    metadata.labels = {
        app = "${metadata.name}"
        team = "my-team"
    }
    spec = {
        replicas = 3
        selector.matchLabels = {
            app = "${metadata.name}"
        }
        template.metadata.labels = {
            app = "${metadata.name}"
        }
        template.spec.containers = [
            {
                name = "my-app"
                image = "my-app:latest"
                ports = [
                    {
                        containerPort = 8080
                    }
                ]
            }
        ]
    }
}
_dam = config.config.kind
_da = f.pluralize(_dam)
out=[_deployment, _dam, _da]
