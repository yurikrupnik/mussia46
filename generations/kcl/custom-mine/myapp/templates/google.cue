package templates

import (
	gcp_storage "github.com/upbound/provider-gcp/apis/storage/v1beta1"
)

#GoogleBucket: gcp_storage.#Bucket & {
			#config:    #Config
			apiVersion: "storage.gcp.upbound.io/v1beta1"
			kind:       "Bucket"
			metadata:   #config.metadata
			spec: {
				forProvider: {
					location: "me-west1"
					uniformBucketLevelAccess: true
					storageClass: "STANDARD"
//					sjhit: "a"
				}
			}
	}
