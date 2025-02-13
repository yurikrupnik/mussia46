import crossplane.v1 as corev1
import be.config as config
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
                #additionalPrinterColumns = [
                #    {
                #        name = "url"
                #        $type = "string"
                 #       jsonPath = ".status.url"
                 #   }
                #]
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
                        #status = {
                        #    $type = "object"
                         #   properties = {
                         #       url.$type = "string"
                         #       id.$type = "string"
                          #      "cloud-url" = {$type = "string"}
                          #  }
                        #}
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
        mode: "Pipeline"
        pipeline: [
            {
                step: "patch-and-transform"
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
    name: "aws-combined-registry"
    base = {
       apiVersion = "yurikrupnik.com/v1alpha1"
       kind = "Registry"
       metadata.name = "some-name" # TODO check if needed
       spec = {
           location = "eu-west-1"
       }
    }
    patches = [
        {
            fromFieldPath = "spec.location"
            toFieldPath = "spec.location"
        }
        # required for multi compositions
        {
            fromFieldPath = "spec.compositionSelector"
            toFieldPath = "spec.compositionSelector"
        }
        # TODO TEST
        {
            fromFieldPath = "spec.providerConfigRef"
            toFieldPath = "spec.providerConfigRef"
        }
        {
            fromFieldPath = "metadata.name"
            toFieldPath = "metadata.name"
        }
    ]
}
_gcpBucket = {
    name = "gcp-combined-registry"
    base =  {
        apiVersion = "yurikrupnik.com/v1alpha1"
        kind = "Registry"
        metadata.name = "some-name" # TODO check if needed
        spec = {
            location = "europe-west1"
        }
    }
    patches = [
        {
            fromFieldPath = "spec.location"
            toFieldPath = "spec.location"
        }
        # required for multi compositions
        {
            fromFieldPath = "spec.compositionSelector"
            toFieldPath = "spec.compositionSelector"
        }
         # TODO TEST
        {
            fromFieldPath = "spec.providerConfigRef"
            toFieldPath = "spec.providerConfigRef"
        }
        {
            fromFieldPath = "metadata.name"
            toFieldPath = "metadata.name"
        }
    ]
}

_resources = [
    _composite
    _aws
    _gcp
]

manifests.yaml_stream(_resources)
