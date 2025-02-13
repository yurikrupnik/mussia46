// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/upbound/provider-gcp/apis/storage/v1beta1

package v1beta1

import (
	"github.com/crossplane/crossplane-runtime/apis/common/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

#BucketACLInitParameters: {
	// The name of the bucket it applies to.
	// +crossplane:generate:reference:type=github.com/upbound/provider-gcp/apis/storage/v1beta2.Bucket
	bucket?: null | string @go(Bucket,*string)

	// Reference to a Bucket in storage to populate bucket.
	// +kubebuilder:validation:Optional
	bucketRef?: null | v1.#Reference @go(BucketRef,*v1.Reference)

	// Selector for a Bucket in storage to populate bucket.
	// +kubebuilder:validation:Optional
	bucketSelector?: null | v1.#Selector @go(BucketSelector,*v1.Selector)

	// Configure this ACL to be the default ACL.
	defaultAcl?: null | string @go(DefaultACL,*string)

	// The canned GCS ACL to apply. Must be set if role_entity is not.
	predefinedAcl?: null | string @go(PredefinedACL,*string)

	// List of role/entity pairs in the form ROLE:entity. See GCS Bucket ACL documentation  for more details. Must be set if predefined_acl is not.
	roleEntity?: [...null | string] @go(RoleEntity,[]*string)
}

#BucketACLObservation: {
	// The name of the bucket it applies to.
	bucket?: null | string @go(Bucket,*string)

	// Configure this ACL to be the default ACL.
	defaultAcl?: null | string @go(DefaultACL,*string)
	id?:         null | string @go(ID,*string)

	// The canned GCS ACL to apply. Must be set if role_entity is not.
	predefinedAcl?: null | string @go(PredefinedACL,*string)

	// List of role/entity pairs in the form ROLE:entity. See GCS Bucket ACL documentation  for more details. Must be set if predefined_acl is not.
	roleEntity?: [...null | string] @go(RoleEntity,[]*string)
}

#BucketACLParameters: {
	// The name of the bucket it applies to.
	// +crossplane:generate:reference:type=github.com/upbound/provider-gcp/apis/storage/v1beta2.Bucket
	// +kubebuilder:validation:Optional
	bucket?: null | string @go(Bucket,*string)

	// Reference to a Bucket in storage to populate bucket.
	// +kubebuilder:validation:Optional
	bucketRef?: null | v1.#Reference @go(BucketRef,*v1.Reference)

	// Selector for a Bucket in storage to populate bucket.
	// +kubebuilder:validation:Optional
	bucketSelector?: null | v1.#Selector @go(BucketSelector,*v1.Selector)

	// Configure this ACL to be the default ACL.
	// +kubebuilder:validation:Optional
	defaultAcl?: null | string @go(DefaultACL,*string)

	// The canned GCS ACL to apply. Must be set if role_entity is not.
	// +kubebuilder:validation:Optional
	predefinedAcl?: null | string @go(PredefinedACL,*string)

	// List of role/entity pairs in the form ROLE:entity. See GCS Bucket ACL documentation  for more details. Must be set if predefined_acl is not.
	// +kubebuilder:validation:Optional
	roleEntity?: [...null | string] @go(RoleEntity,[]*string)
}

// BucketACLSpec defines the desired state of BucketACL
#BucketACLSpec: {
	v1.#ResourceSpec
	forProvider: #BucketACLParameters @go(ForProvider)

	// THIS IS A BETA FIELD. It will be honored
	// unless the Management Policies feature flag is disabled.
	// InitProvider holds the same fields as ForProvider, with the exception
	// of Identifier and other resource reference fields. The fields that are
	// in InitProvider are merged into ForProvider when the resource is created.
	// The same fields are also added to the terraform ignore_changes hook, to
	// avoid updating them after creation. This is useful for fields that are
	// required on creation, but we do not desire to update them after creation,
	// for example because of an external controller is managing them, like an
	// autoscaler.
	initProvider?: #BucketACLInitParameters @go(InitProvider)
}

// BucketACLStatus defines the observed state of BucketACL.
#BucketACLStatus: {
	v1.#ResourceStatus
	atProvider?: #BucketACLObservation @go(AtProvider)
}

// BucketACL is the Schema for the BucketACLs API. Creates a new bucket ACL in Google Cloud Storage.
// +kubebuilder:printcolumn:name="SYNCED",type="string",JSONPath=".status.conditions[?(@.type=='Synced')].status"
// +kubebuilder:printcolumn:name="READY",type="string",JSONPath=".status.conditions[?(@.type=='Ready')].status"
// +kubebuilder:printcolumn:name="EXTERNAL-NAME",type="string",JSONPath=".metadata.annotations.crossplane\\.io/external-name"
// +kubebuilder:printcolumn:name="AGE",type="date",JSONPath=".metadata.creationTimestamp"
// +kubebuilder:resource:scope=Cluster,categories={crossplane,managed,gcp}
#BucketACL: {
	metav1.#TypeMeta
	metadata?: metav1.#ObjectMeta @go(ObjectMeta)
	spec:      #BucketACLSpec     @go(Spec)
	status?:   #BucketACLStatus   @go(Status)
}

// BucketACLList contains a list of BucketACLs
#BucketACLList: {
	metav1.#TypeMeta
	metadata?: metav1.#ListMeta @go(ListMeta)
	items: [...#BucketACL] @go(Items,[]BucketACL)
}
