
import models.com.yurikrupnik.v1alpha1 as yurikrupnikv1alpha1
import models.io.upbound.aws.s3.v1beta1 as s3v1beta1
import models.io.upbound.aws.s3.v1beta2 as s3v1beta2
import models.io.upbound.aws.v1alpha1 as awsv1alpha1
import models.io.upbound.aws.v1beta1 as awsv1beta1
import models.io.upbound.gcp.storage.v1beta1 as storagev1beta1
import models.io.upbound.gcp.storage.v1beta2 as storagev1beta2
import models.io.upbound.gcp.v1alpha1 as gcpv1alpha1
import models.io.upbound.gcp.v1beta1 as gcpv1beta1
import models.k8s.apimachinery.pkg.apis.meta.v1 as metav1
import test as t
# import my_package.be.config as config

#lol = config.config.kind
#oxr = option("params").oxr # observed composite resource
#_ocds = option("params").ocds # observed composed resources
#_dxr = option("params").dxr # desired composite resource
#dcds = option("params").dcds # desired composed resources

_metadata = lambda name: str -> any {
    { annotations = { "krm.kcl.dev/composition-resource-name" = name }}
}

# Example to retrieve variables from "xr"; update as needed
_region = "us-east-1"
#if oxr.spec?.parameters?.region:
 # _region = oxr.spec.parameters.region

isShit = option("test",  required = True).isShit
iss = option("das", "int", required=True, help="das is a bool")
_storages = option("storages")

_dataLoop7 = [
  storagev1beta1.Bucket {
    metadata = _metadata(name)
    spec.forProvider.location = _region
  } for name in _storages
]


#storage.gcp.upbound.io/v1beta1
_items = [
  storagev1beta1.Bucket {
    metadata: _metadata("Bucket")
    spec.forProvider = {
      location = _region
      storageClass = "STANDARD"
    }
  },
  t.tset if isShit == True else Undefined,
  "lol" if isShit == True else Undefined,
  if isShit: t.tset,
  #k for k, _ in _storages,
  #*_dataLoop7,
  *[
    storagev1beta1.Bucket {
      metadata = _metadata(name)
      spec.forProvider.location = name
    } for name in _storages
  ]
  *[
    t.tset {
      metadata: {
        "name" =  name
        labels: {
          "aris" = name
        }
      }
    } for name in _storages
  ],
  s3v1beta1.Bucket {
    metadata: _metadata("Bucket")
    spec.forProvider = {
      forceDestroy = True
      region = _region
    }
  },
]
items = _items
