
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

oxr = option("params").oxr # observed composite resource
_ocds = option("params").ocds # observed composed resources
_dxr = option("params").dxr # desired composite resource
dcds = option("params").dcds # desired composed resources

_metadata = lambda name: str -> any {
    { annotations = { "krm.kcl.dev/composition-resource-name" = name }}
}

# Example to retrieve variables from "xr"; update as needed
# _region = "us-east-1"
# if oxr.spec?.parameters?.region:
#     _region = oxr.spec.parameters.region

_items = [
# Example S3 Bucket managed resource configuration; update as needed
# s3v1beta2.Bucket{
#     metadata: _metadata("my-bucket")
#     spec: {
#         forProvider: {
#             region: _region
#         }
#     }
# }
]
items = _items
