// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/upbound/provider-gcp/apis/storage/v1beta1

package v1beta1

import (
	"github.com/crossplane/crossplane-runtime/apis/common/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

#BucketAccessControlInitParameters: {
	// The name of the bucket.
	// +crossplane:generate:reference:type=github.com/upbound/provider-gcp/apis/storage/v1beta2.Bucket
	bucket?: null | string @go(Bucket,*string)

	// Reference to a Bucket in storage to populate bucket.
	// +kubebuilder:validation:Optional
	bucketRef?: null | v1.#Reference @go(BucketRef,*v1.Reference)

	// Selector for a Bucket in storage to populate bucket.
	// +kubebuilder:validation:Optional
	bucketSelector?: null | v1.#Selector @go(BucketSelector,*v1.Selector)

	// The entity holding the permission, in one of the following forms:
	// user-userId
	// user-email
	// group-groupId
	// group-email
	// domain-domain
	// project-team-projectId
	// allUsers
	// allAuthenticatedUsers
	// Examples:
	// The user liz@example.com would be user-liz@example.com.
	// The group example@googlegroups.com would be
	// group-example@googlegroups.com.
	// To refer to all members of the Google Apps for Business domain
	// example.com, the entity would be domain-example.com.
	entity?: null | string @go(Entity,*string)

	// The access permission for the entity.
	// Possible values are: OWNER, READER, WRITER.
	role?: null | string @go(Role,*string)
}

#BucketAccessControlObservation: {
	// The name of the bucket.
	bucket?: null | string @go(Bucket,*string)

	// The domain associated with the entity.
	domain?: null | string @go(Domain,*string)

	// The email address associated with the entity.
	email?: null | string @go(Email,*string)

	// The entity holding the permission, in one of the following forms:
	// user-userId
	// user-email
	// group-groupId
	// group-email
	// domain-domain
	// project-team-projectId
	// allUsers
	// allAuthenticatedUsers
	// Examples:
	// The user liz@example.com would be user-liz@example.com.
	// The group example@googlegroups.com would be
	// group-example@googlegroups.com.
	// To refer to all members of the Google Apps for Business domain
	// example.com, the entity would be domain-example.com.
	entity?: null | string @go(Entity,*string)

	// an identifier for the resource with format {{bucket}}/{{entity}}
	id?: null | string @go(ID,*string)

	// The access permission for the entity.
	// Possible values are: OWNER, READER, WRITER.
	role?: null | string @go(Role,*string)
}

#BucketAccessControlParameters: {
	// The name of the bucket.
	// +crossplane:generate:reference:type=github.com/upbound/provider-gcp/apis/storage/v1beta2.Bucket
	// +kubebuilder:validation:Optional
	bucket?: null | string @go(Bucket,*string)

	// Reference to a Bucket in storage to populate bucket.
	// +kubebuilder:validation:Optional
	bucketRef?: null | v1.#Reference @go(BucketRef,*v1.Reference)

	// Selector for a Bucket in storage to populate bucket.
	// +kubebuilder:validation:Optional
	bucketSelector?: null | v1.#Selector @go(BucketSelector,*v1.Selector)

	// The entity holding the permission, in one of the following forms:
	// user-userId
	// user-email
	// group-groupId
	// group-email
	// domain-domain
	// project-team-projectId
	// allUsers
	// allAuthenticatedUsers
	// Examples:
	// The user liz@example.com would be user-liz@example.com.
	// The group example@googlegroups.com would be
	// group-example@googlegroups.com.
	// To refer to all members of the Google Apps for Business domain
	// example.com, the entity would be domain-example.com.
	// +kubebuilder:validation:Optional
	entity?: null | string @go(Entity,*string)

	// The access permission for the entity.
	// Possible values are: OWNER, READER, WRITER.
	// +kubebuilder:validation:Optional
	role?: null | string @go(Role,*string)
}

// BucketAccessControlSpec defines the desired state of BucketAccessControl
#BucketAccessControlSpec: {
	v1.#ResourceSpec
	forProvider: #BucketAccessControlParameters @go(ForProvider)

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
	initProvider?: #BucketAccessControlInitParameters @go(InitProvider)
}

// BucketAccessControlStatus defines the observed state of BucketAccessControl.
#BucketAccessControlStatus: {
	v1.#ResourceStatus
	atProvider?: #BucketAccessControlObservation @go(AtProvider)
}

// BucketAccessControl is the Schema for the BucketAccessControls API. Bucket ACLs can be managed authoritatively using the [
// +kubebuilder:printcolumn:name="SYNCED",type="string",JSONPath=".status.conditions[?(@.type=='Synced')].status"
// +kubebuilder:printcolumn:name="READY",type="string",JSONPath=".status.conditions[?(@.type=='Ready')].status"
// +kubebuilder:printcolumn:name="EXTERNAL-NAME",type="string",JSONPath=".metadata.annotations.crossplane\\.io/external-name"
// +kubebuilder:printcolumn:name="AGE",type="date",JSONPath=".metadata.creationTimestamp"
// +kubebuilder:resource:scope=Cluster,categories={crossplane,managed,gcp}
#BucketAccessControl: {
	metav1.#TypeMeta
	metadata?: metav1.#ObjectMeta @go(ObjectMeta)

	// +kubebuilder:validation:XValidation:rule="!('*' in self.managementPolicies || 'Create' in self.managementPolicies || 'Update' in self.managementPolicies) || has(self.forProvider.entity) || (has(self.initProvider) && has(self.initProvider.entity))",message="spec.forProvider.entity is a required parameter"
	spec:    #BucketAccessControlSpec   @go(Spec)
	status?: #BucketAccessControlStatus @go(Status)
}

// BucketAccessControlList contains a list of BucketAccessControls
#BucketAccessControlList: {
	metav1.#TypeMeta
	metadata?: metav1.#ListMeta @go(ListMeta)
	items: [...#BucketAccessControl] @go(Items,[]BucketAccessControl)
}
