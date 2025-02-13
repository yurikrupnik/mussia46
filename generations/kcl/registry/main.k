import crossplane.v1 as corev1
# import be.functions as functions
import be.config as config
import models.io.upbound.aws.ecr.v1beta1 as ecr
import models.io.upbound.gcp.artifact.v1beta1 as artifact
import manifests

_composite = corev1.CompositeResourceDefinition {
    metadata = {
        labels = {
            team = "platform"
            "app.kubernetes.io/part-of" = "iac"
        }
        annotations = {
            "app.kubernetes.io/owner": config.config.owner
        }
        name = config.config.plural.lower() + "." + config.config.group
    }
    spec = {
        group = config.config.group
        claimNames.kind = config.config.claimNamesKind
        claimNames.plural = config.config.claimNamesPlural
        names = {
            kind = config.config.kind
            plural = config.config.plural
        }
        defaultCompositionRef.name = "gcp-" + config.config.kind.lower()
        versions = [
            {
                name = "v1alpha1"
                served = True
                referenceable = True
                # does not work
                # TODO add back with registry params
                additionalPrinterColumns = [
                   {
                      name = "url"
                      $type = "string"
                      jsonPath = ".status.url"
                   }
                ]
                $schema.openAPIV3Schema = {
                    $type = "object"
                    properties = {
                        spec = {
                            $type = "object"
                            required = []
                            properties = {
                                location = {
                                  $type = "string"
                                  description = "Location where the registry should be created."
                                  examples: ["europe-west1 (GCP)", "eu-west-1 (AWS)"]
                                }
                            }
                        }
                        # TODO add back with registry params
                        status = {
                          $type = "object"
                          properties = {
                            url.$type = "string"
                          }
                        }
                    }
                }
            }
        ]
    }
}

_aws = corev1.Composition {
    metadata = {
        labels = {provider = "aws"}
        #labels = {provider = config.config._providersArray[1]}
        name: "aws-" + config.config.kind.lower()
    }
    spec = {
        compositeTypeRef = {
            apiVersion: config.config.group + "/v1alpha1"
            kind: config.config.kind
        }
        mode = "Pipeline"
        pipeline = [
            {
                step = "patch-and-transform"
                functionRef.name = "function-patch-and-transform"
                input: {
                    apiVersion: "pt.fn.crossplane.io/v1beta1"
                    kind: "Resources"
                    resources: [
                        _awsBucket
                    ]
                }
            }
            config.functionReady
        ]
        writeConnectionSecretsToNamespace = "crossplane-system"
    }
}

_gcp = corev1.Composition {
    metadata = {
        labels = {provider = "gcp"}
        name: "gcp-" + config.config.kind.lower()
    }
    spec = {
        compositeTypeRef = {
            apiVersion: config.config.group + "/v1alpha1"
            kind: config.config.kind
        }
        mode: "Pipeline"
        pipeline: [
            {
                step: "patch-and-transform"
                functionRef.name = "function-patch-and-transform"
                input: {
                    apiVersion: "pt.fn.crossplane.io/v1beta1"
                    kind: "Resources"
                    resources: [
                        _gcpBucket
                    ]
                }
            }
            config.functionReady
        ]
        writeConnectionSecretsToNamespace = "crossplane-system"
    }
}

_awsBucket = {
    name: "aws-registry"
    base = ecr.Repository {
        #metadata.name = "crossplane-lol"
        #metadata.generateName = ""
        metadata.annotations.lol = "shit"
        metadata.labels = {
          "composite" = "crossplane-stam"
          "omg" = "lolsss"
          #"testing.upbound.io/example-name" = "lolsss"
        }
        spec = {
            forProvider = {
                region = "eu-west-1"
                imageTagMutability = "IMMUTABLE"
                tags = {iac = "crossplane"}
            }
        }
    }
    patches = [
        {
            fromFieldPath = "spec.location"
            toFieldPath = "spec.forProvider.region"
        }
        {
            fromFieldPath = "spec.providerConfigRef"
            toFieldPath = "spec.providerConfigRef"
        }
        #{
         #   fromFieldPath = "metadata.name"
          #  toFieldPath = "metadata.name"
        #}
        #{
         #   fromFieldPath = "metadata.name"
          #  toFieldPath = "metadata.annotations[crossplane.io/external-name]"
        #}
        {
            fromFieldPath = "metadata.name"
            toFieldPath = "metadata.annotations[lol]"
        }
        {
            $type = "ToCompositeFieldPath"
            fromFieldPath = "status.atProvider.repositoryUrl"
            toFieldPath = "status.url"
        }
    ]
}
_gcpBucket = {
    name: "gcp-registry"
    base = artifact.RegistryRepository {
        metadata.name = "default-gcp-name"
        metadata.annotations = {
          "crossplane.io/external-name" = "default-gcp-name"
        }
        spec = {
            forProvider = {
                location = "europe-west1"
                description = "example docker repository by crossplane"
                format = "DOCKER"
                labels.iac = "crossplane"
            }
        }
    }
    patches = [
        {
            fromFieldPath = "spec.location"
            toFieldPath = "spec.forProvider.location"
        }
        {
            fromFieldPath = "spec.providerConfigRef"
            toFieldPath = "spec.providerConfigRef"
        }
        {
            fromFieldPath = "metadata.name"
            toFieldPath = "metadata.name"
        }
        {
            fromFieldPath = "metadata.name"
            toFieldPath = "metadata.annotations[crossplane.io/external-name]"
        }
        {
            $type = "CombineToComposite"
            combine = {
              variables = [
                {fromFieldPath = "status.atProvider.location"}
                {fromFieldPath = "status.atProvider.project"}
                {fromFieldPath = "status.atProvider.name"}
              ]
              strategy = "string"
              string = {
                fmt = "%s-docker.pkg.dev/%s/%s"
              }
            }
            toFieldPath = "status.url"
        }
    ]
}

_registry = []

_resources = [
    _composite
    _aws
    _gcp
]
manifests.yaml_stream(_resources)
