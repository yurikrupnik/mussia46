import crossplane.v1 as corev1
# import be.functions as functions
import be.config as config
import models.io.upbound.aws.s3.v1beta1 as s3v1beta1
import models.io.upbound.gcp.storage.v1beta1 as storagev1beta1
import manifests

_compositeRegistry = lambda config: config.CrossplaneConfig -> corev1.CompositeResourceDefinition {
  corev1.CompositeResourceDefinition {
      metadata = {
          labels = {
              team = "platform"
              "app.kubernetes.io/part-of" = "iac"
          }
          annotations = {
              "app.kubernetes.io/owner": config.owner
          }
          name = config.plural.lower() + "." + config.group
      }
      spec = {
          group = config.group
          claimNames.kind = config.claimNamesKind
          claimNames.plural = config.claimNamesPlural
          names = {
              kind = config.kind
              plural = config.plural
          }
          defaultCompositionRef.name = "gcp-" + config.kind.lower()
          versions = [
              {
                  name = "v1alpha1"
                  served = True
                  referenceable = True
                  additionalPrinterColumns = [
                      {
                          name = "url"
                          $type = "string"
                          jsonPath = ".status.url"
                      }
                      {
                          name = "id"
                          $type = "string"
                          jsonPath = ".status.id"
                      }
                      {
                          name = "cloud-url"
                          $type = "string"
                          jsonPath = ".status.cloud-url"
                      }
                  ]
                  $schema.openAPIV3Schema = {
                      $type = "object"
                      properties = {
                          spec = {
                              $type = "object"
                              required = ["id", "parameters"]
                              properties = {
                                  id = {
                                      $type = "string"
                                      description: "ID of the resource that other objects will use to refer to it."
                                  }
                                  parameters = {
                                      $type: "object"
                                      required = ["location"]
                                      properties = {
                                          location = {
                                              $type = "string"
                                              description = "Location where the bucket should be created."
                                              examples: ["europe-west1 (GCP)", "eu-west-1 (AWS)"]
                                          }
                                          description = {
                                            $type = "string"
                                            description: "Description of the network in the cloud"
                                          }
                                          production = {
                                            $type = "boolean"
                                            description = "Choose to create production config"
                                            default = False
                                          }
                                          subnetworks = {
                                            $type = "array"
                                            items = {
                                              $type = "object"
                                              properties = {
                                                name.$type = "string"
                                                region.$type = "string"
                                                cidrRange.$type = "string"
                                                description.$type = "string"
                                              }
                                            }
                                          }
                                      }
                                  }
                              }
                          }
                          status = {
                              $type = "object"
                              properties = {
                                  url.$type = "string"
                                  id.$type = "string"
                                  "cloud-url" = {$type = "string"}
                              }
                          }
                      }
                  }
              }
          ]
      }
  }
}

_awsRegistry = corev1.Composition {
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

_das = corev1.ApiextensionsCrossplaneIoV1CompositionSpecPipelineItems0 {
  step = "normal"
  functionRef.name = "kcl-function"
  input = {
    apiVersion: "krm.kcl.dev/v1alpha1"
    kind: "KCLInput"
    metadata.name = "basic"
    spec.source = ""
  }
}

_functionOFInout = lambda dsa: str {
  {
    oxr = option("params").oxr
    ocds = option("params").ocds
    _metadata = lambda suffix: str, kind: str -> any {
        {
            if suffix == "":
                name = oxr.spec.id
            else:
                name = oxr.spec.id + "-" + suffix
            annotations = {
                "krm.kcl.dev/composition-resource-name" = oxr.spec.id + "-" + kind + "-" + suffix
            }
        }
    }
    network = {
      apiVersion = "compute.gcp.upbound.io/v1beta1"
      kind: "Network"
      metadata = _metadata("", "omg")
      spec.forProvider = {
        autoCreateSubnetworks = False
        routingMode = "REGIONAL"
        description = oxr.spec.parameters.description
      }
    }
    subnetworks = [
      {
        apiVersion = "compute.gcp.upbound.io/v1beta1"
        kind = "Subnetwork"
        metadata = _metadata(subnetwork.name, "omg")
        spec.forProvider = {
          region = subnetwork.region
          ipCidrRange = subnetwork.cidrRange
          description = subnetwork.description
          privateIpGoogleAccess = True
          networkSelector.matchControllerRef = True
        }
      } for subnetwork in oxr.spec.parameters.subnetworks
    ]

    customNetwork = {
      apiVersion = "compute.gcp.upbound.io/v1beta1"
      kind = "Subnetwork"
      metadata = _metadata("my-network", "omg")
      spec.forProvider = {
        region = "us-west2"
        ipCidrRange = "10.148.0.0/20"
        description = "some shit desc"
        privateIpGoogleAccess = True
        network = "crossplane-ares"
      }
    }

    customNetwork1 = {
      apiVersion = "compute.gcp.upbound.io/v1beta1"
      kind = "Subnetwork"
      metadata = _metadata("my-network1", "omg")
      spec.forProvider = {
        region = "us-west2"
        ipCidrRange = "10.128.0.0/20"
        description = "some shit desc"
        privateIpGoogleAccess = True
        networkRef.name = "crossplane-ares"
      }
    }

    redis = {
      apiVersion = "redis.gcp.upbound.io/v1beta1"
      kind = "Instance"
      metadata = _metadata("redis", "omg")
      spec.forProvider = {
        tier = "STANDARD_HA" if oxr.spec.parameters.production else "BASIC"
        memorySizeGb = 3
        authorizedNetwork = "crossplane-ares"
        locationId = "us-west2-a"
        redisVersion = "REDIS_7_0"
        region = oxr.spec.parameters.subnetworks[0].region
        labels.environment = "prod" if oxr.spec.parameters.production else "dev"
        authEnabled = True if oxr.spec.parameters.production else False
        replicaCount = 1 if oxr.spec.parameters.production else 0
        connectMode = "PRIVATE_SERVICE_ACCESS" if oxr.spec.parameters.production else "DIRECT_PEERING"
        persistenceConfig = {
          persistenceMode = "RDB"
          rdbSnapshotPeriod = "ONE_HOUR"
        } if oxr.spec.parameters.production else { persistenceMode = "DISABLED" }
        readReplicasMode = "READ_REPLICAS_ENABLED" if oxr.spec.parameters.production else "READ_REPLICAS_DISABLED"
      }
      spec.writeConnectionSecretToRef = {
        name = "example-redis-instance-secret"
        namespace = "crossplane-system"
      }
    }

    dxr = {
        **option("params").dxr
    }

    items = [
      network
      customNetwork
      customNetwork1
      *subnetworks
      redis
      dxr
    ]
  }
}


_gcpRegistry = corev1.Composition {
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
            _kclFunctionGCPNetwork
            config.functionReady
        ]
        writeConnectionSecretsToNamespace = "crossplane-system"
    }
}

_awsBucket = {
    name: "aws-bucket"
    base = s3v1beta1.Bucket {
        spec = {
            forProvider = {
                region = "eu-west-1"
                forceDestroy = True
            }
        }
    }
    patches = [
        {
            fromFieldPath = "spec.parameters.location"
            toFieldPath = "spec.forProvider.region"
        }
        {
            $type = "ToCompositeFieldPath"
            fromFieldPath = "status.atProvider.id"
            toFieldPath = "status.id"
        }
        {
            $type = "ToCompositeFieldPath"
            fromFieldPath = "status.atProvider.bucketRegionalDomainName"
            toFieldPath = "status.url"
            transforms = [
                {
                    string = {
                        fmt = "https://%s"
                        $type = "Format"
                    }
                    $type: "string"
                }
            ]
        }
        {
            $type = "ToCompositeFieldPath"
            fromFieldPath = "status.atProvider.id"
            toFieldPath = "status.cloud-url"
            transforms = [
                {
                    string = {
                        fmt = "s3://%s"
                        $type = "Format"
                    }
                    $type: "string"
                }
            ]
        }
    ]
}

_gcpBucket = {
    name: "gcp-bucket"
    base = storagev1beta1.Bucket {
        spec = {
            forProvider = {
                location = "europe-west1"
                uniformBucketLevelAccess = True
                storageClass = "STANDARD"
            }
        }
    }
    patches = [
        {
            fromFieldPath = "spec.parameters.location"
            toFieldPath = "spec.forProvider.location"
        }
        {
            $type = "ToCompositeFieldPath"
            fromFieldPath = "status.atProvider.id"
            toFieldPath = "status.id"
        }
        {
            $type = "ToCompositeFieldPath"
            fromFieldPath = "status.atProvider.selfLink"
            toFieldPath = "status.url"
        }
        {
            $type = "ToCompositeFieldPath"
            fromFieldPath = "status.atProvider.url"
            toFieldPath = "status.cloud-url"
        }
    ]
}

_kclFunctionGCPNetwork = {
  step = "normal1"
  functionRef.name = "kcl-function"
  input = {
    apiVersion: "krm.kcl.dev/v1alpha1"
    kind: "KCLInput"
    metadata.name = "basic"
    spec.source = """
oxr = option("params").oxr
ocds = option("params").ocds
_metadata = lambda suffix: str, kind: str -> any {
    {
        if suffix == "":
            name = oxr.spec.id
        else:
            name = oxr.spec.id + "-" + suffix
        annotations = {
            "krm.kcl.dev/composition-resource-name" = oxr.spec.id + "-" + kind + "-" + suffix
        }
    }
}
network = {
  apiVersion = "compute.gcp.upbound.io/v1beta1"
  kind: "Network"
  metadata = _metadata("", "omg")
  spec.forProvider = {
    autoCreateSubnetworks = False
    routingMode = "REGIONAL"
    description = oxr.spec.parameters.description
  }
}
subnetworks = [
  {
    apiVersion = "compute.gcp.upbound.io/v1beta1"
    kind = "Subnetwork"
    metadata = _metadata(subnetwork.name, "omg")
    spec.forProvider = {
      region = subnetwork.region
      ipCidrRange = subnetwork.cidrRange
      description = subnetwork.description
      privateIpGoogleAccess = True
      networkSelector.matchControllerRef = True
    }
  } for subnetwork in oxr.spec.parameters.subnetworks
]

customNetwork = {
  apiVersion = "compute.gcp.upbound.io/v1beta1"
  kind = "Subnetwork"
  metadata = _metadata("my-network", "omg")
  spec.forProvider = {
    region = "us-west2"
    ipCidrRange = "10.148.0.0/20"
    description = "some shit desc"
    privateIpGoogleAccess = True
    network = "crossplane-ares"
  }
}

customNetwork1 = {
  apiVersion = "compute.gcp.upbound.io/v1beta1"
  kind = "Subnetwork"
  metadata = _metadata("my-network1", "omg")
  spec.forProvider = {
    region = "us-west2"
    ipCidrRange = "10.128.0.0/20"
    description = "some shit desc"
    privateIpGoogleAccess = True
    networkRef.name = "crossplane-ares"
  }
}

redis = {
  apiVersion = "redis.gcp.upbound.io/v1beta1"
  kind = "Instance"
  metadata = _metadata("redis", "omg")
  spec.forProvider = {
    tier = "STANDARD_HA" if oxr.spec.parameters.production else "BASIC"
    memorySizeGb = 3
    authorizedNetwork = "crossplane-ares"
    locationId = "us-west2-a"
    redisVersion = "REDIS_7_0"
    region = oxr.spec.parameters.subnetworks[0].region
    labels.environment = "prod" if oxr.spec.parameters.production else "dev"
    authEnabled = True if oxr.spec.parameters.production else False
    replicaCount = 1 if oxr.spec.parameters.production else 0
    connectMode = "PRIVATE_SERVICE_ACCESS" if oxr.spec.parameters.production else "DIRECT_PEERING"
    persistenceConfig = {
      persistenceMode = "RDB"
      rdbSnapshotPeriod = "ONE_HOUR"
    } if oxr.spec.parameters.production else { persistenceMode = "DISABLED" }
    readReplicasMode = "READ_REPLICAS_ENABLED" if oxr.spec.parameters.production else "READ_REPLICAS_DISABLED"
  }
  spec.writeConnectionSecretToRef = {
    name = "example-redis-instance-secret"
    namespace = "crossplane-system"
  }
}

dxr = {
    **option("params").dxr
}

items = [
  network
  customNetwork
  customNetwork1
  *subnetworks
  redis
  dxr
]
"""
  }
}

_functionStorage = corev1.ApiextensionsCrossplaneIoV1CompositionSpecPipelineItems0 {
  step = "normal1"
  functionRef.name = "kcl-function"
  input: {
    apiVersion: "krm.kcl.dev/v1alpha1"
    kind: "KCLInput"
    metadata.name = "basic"
    spec.source = """
oxr = option("params").oxr
ocds = option("params").ocds
_metadata = lambda suffix: str, kind: str -> any {
    {
        if suffix == "":
            name = oxr.spec.id
        else:
            name = oxr.spec.id + "-" + suffix
        annotations = {
            "krm.kcl.dev/composition-resource-name" = oxr.spec.id + "-" + kind + "-" + suffix
        }
    }
}
storage = {
  apiVersion = "s3.aws.upbound.io/v1beta1"
  kind: "Bucket"
  metadata = _metadata("", "omg")
  spec.forProvider = {
    region = oxr.spec.parameters.location
    tags.Name = oxr.spec.id
  }
}

dxr = {
    **option("params").dxr
}

items = [
  storage
  dxr
]
"""
  }
}

_registry = [
  _compositeRegistry
  _awsRegistry
  _gcpRegistry
]

_resources = [
    *_registry
]
manifests.yaml_stream(_resources)
