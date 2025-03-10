"""
This file was generated by the KCL auto-gen tool. DO NOT EDIT.
Editing this file might prove futile when you re-run the KCL auto-gen generate command.
"""
import k8s.apimachinery.pkg.apis.meta.v1

schema BucketOwnershipControls:
    r"""
    BucketOwnershipControls is the Schema for the BucketOwnershipControlss API. Manages S3 Bucket Ownership Controls.

    Attributes
    ----------
    apiVersion : str, default is "s3.aws.upbound.io/v1beta2", required
        APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
    kind : str, default is "BucketOwnershipControls", required
        Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    metadata : v1.ObjectMeta, default is Undefined, optional
        metadata
    spec : S3AwsUpboundIoV1beta2BucketOwnershipControlsSpec, default is Undefined, required
        spec
    status : S3AwsUpboundIoV1beta2BucketOwnershipControlsStatus, default is Undefined, optional
        status
    """
    apiVersion: "s3.aws.upbound.io/v1beta2" = "s3.aws.upbound.io/v1beta2"

    kind: "BucketOwnershipControls" = "BucketOwnershipControls"

    metadata?: v1.ObjectMeta
    spec: S3AwsUpboundIoV1beta2BucketOwnershipControlsSpec

    status?: S3AwsUpboundIoV1beta2BucketOwnershipControlsStatus

schema S3AwsUpboundIoV1beta2BucketOwnershipControlsSpec:
    r"""
    BucketOwnershipControlsSpec defines the desired state of BucketOwnershipControls

    Attributes
    ----------
    deletionPolicy : str, default is "Delete", optional
        DeletionPolicy specifies what will happen to the underlying external
        when this managed resource is deleted - either "Delete" or "Orphan" the
        external resource.
        This field is planned to be deprecated in favor of the ManagementPolicies
        field in a future release. Currently, both could be set independently and
        non-default values would be honored if the feature flag is enabled.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
    forProvider : S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecForProvider, default is Undefined, required
        for provider
    initProvider : S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecInitProvider, default is Undefined, optional
        init provider
    managementPolicies : [str], default is ["*"], optional
        THIS IS A BETA FIELD. It is on by default but can be opted out
        through a Crossplane feature flag.
        ManagementPolicies specify the array of actions Crossplane is allowed to
        take on the managed and external resources.
        This field is planned to replace the DeletionPolicy field in a future
        release. Currently, both could be set independently and non-default
        values would be honored if the feature flag is enabled. If both are
        custom, the DeletionPolicy field will be ignored.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
        and this one: https://github.com/crossplane/crossplane/blob/444267e84783136daa93568b364a5f01228cacbe/design/one-pager-ignore-changes.md
    providerConfigRef : S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecProviderConfigRef, default is Undefined, optional
        provider config ref
    publishConnectionDetailsTo : S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecPublishConnectionDetailsTo, default is Undefined, optional
        publish connection details to
    writeConnectionSecretToRef : S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecWriteConnectionSecretToRef, default is Undefined, optional
        write connection secret to ref
    """
    deletionPolicy?: "Orphan" | "Delete" = "Delete"
    forProvider: S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecForProvider

    initProvider?: S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecInitProvider
    managementPolicies?: [str] = ["*"]
    providerConfigRef?: S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecProviderConfigRef
    publishConnectionDetailsTo?: S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecPublishConnectionDetailsTo
    writeConnectionSecretToRef?: S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecWriteConnectionSecretToRef

schema S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecForProvider:
    r"""
    s3 aws upbound io v1beta2 bucket ownership controls spec for provider

    Attributes
    ----------
    bucket : str, default is Undefined, optional
        Name of the bucket that you want to associate this access point with.
    bucketRef : S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecForProviderBucketRef, default is Undefined, optional
        bucket ref
    bucketSelector : S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecForProviderBucketSelector, default is Undefined, optional
        bucket selector
    region : str, default is Undefined, required
        Region is the region you'd like your resource to be created in.
    $rule : S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecForProviderRule, default is Undefined, optional
        rule
    """
    bucket?: str
    bucketRef?: S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecForProviderBucketRef
    bucketSelector?: S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecForProviderBucketSelector
    region: str

    $rule?: S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecForProviderRule

schema S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecForProviderBucketRef:
    r"""
    Reference to a Bucket in s3 to populate bucket.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecForProviderBucketRefPolicy, default is Undefined, optional
        policy
    """
    name: str

    policy?: S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecForProviderBucketRefPolicy

schema S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecForProviderBucketRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """
    resolution?: "Required" | "Optional" = "Required"
    resolve?: "Always" | "IfNotPresent"

schema S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecForProviderBucketSelector:
    r"""
    Selector for a Bucket in s3 to populate bucket.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecForProviderBucketSelectorPolicy, default is Undefined, optional
        policy
    """
    matchControllerRef?: bool
    matchLabels?: {str:str}
    policy?: S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecForProviderBucketSelectorPolicy

schema S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecForProviderBucketSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """
    resolution?: "Required" | "Optional" = "Required"
    resolve?: "Always" | "IfNotPresent"

schema S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecForProviderRule:
    r"""
    Configuration block(s) with Ownership Controls rules. Detailed below.

    Attributes
    ----------
    objectOwnership : str, default is Undefined, optional
        Object ownership. Valid values: BucketOwnerPreferred, ObjectWriter or BucketOwnerEnforced
    """
    objectOwnership?: str

schema S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecInitProvider:
    r"""
    THIS IS A BETA FIELD. It will be honored
    unless the Management Policies feature flag is disabled.
    InitProvider holds the same fields as ForProvider, with the exception
    of Identifier and other resource reference fields. The fields that are
    in InitProvider are merged into ForProvider when the resource is created.
    The same fields are also added to the terraform ignore_changes hook, to
    avoid updating them after creation. This is useful for fields that are
    required on creation, but we do not desire to update them after creation,
    for example because of an external controller is managing them, like an
    autoscaler.

    Attributes
    ----------
    bucket : str, default is Undefined, optional
        Name of the bucket that you want to associate this access point with.
    bucketRef : S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecInitProviderBucketRef, default is Undefined, optional
        bucket ref
    bucketSelector : S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecInitProviderBucketSelector, default is Undefined, optional
        bucket selector
    $rule : S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecInitProviderRule, default is Undefined, optional
        rule
    """
    bucket?: str
    bucketRef?: S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecInitProviderBucketRef
    bucketSelector?: S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecInitProviderBucketSelector
    $rule?: S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecInitProviderRule

schema S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecInitProviderBucketRef:
    r"""
    Reference to a Bucket in s3 to populate bucket.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecInitProviderBucketRefPolicy, default is Undefined, optional
        policy
    """
    name: str

    policy?: S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecInitProviderBucketRefPolicy

schema S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecInitProviderBucketRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """
    resolution?: "Required" | "Optional" = "Required"
    resolve?: "Always" | "IfNotPresent"

schema S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecInitProviderBucketSelector:
    r"""
    Selector for a Bucket in s3 to populate bucket.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecInitProviderBucketSelectorPolicy, default is Undefined, optional
        policy
    """
    matchControllerRef?: bool
    matchLabels?: {str:str}
    policy?: S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecInitProviderBucketSelectorPolicy

schema S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecInitProviderBucketSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """
    resolution?: "Required" | "Optional" = "Required"
    resolve?: "Always" | "IfNotPresent"

schema S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecInitProviderRule:
    r"""
    Configuration block(s) with Ownership Controls rules. Detailed below.

    Attributes
    ----------
    objectOwnership : str, default is Undefined, optional
        Object ownership. Valid values: BucketOwnerPreferred, ObjectWriter or BucketOwnerEnforced
    """
    objectOwnership?: str

schema S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecProviderConfigRef:
    r"""
    ProviderConfigReference specifies how the provider that will be used to
    create, observe, update, and delete this managed resource should be
    configured.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecProviderConfigRefPolicy, default is Undefined, optional
        policy
    """
    name: str

    policy?: S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecProviderConfigRefPolicy

schema S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecProviderConfigRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """
    resolution?: "Required" | "Optional" = "Required"
    resolve?: "Always" | "IfNotPresent"

schema S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecPublishConnectionDetailsTo:
    r"""
    PublishConnectionDetailsTo specifies the connection secret config which
    contains a name, metadata and a reference to secret store config to
    which any connection details for this managed resource should be written.
    Connection details frequently include the endpoint, username,
    and password required to connect to the managed resource.

    Attributes
    ----------
    configRef : S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecPublishConnectionDetailsToConfigRef, default is Undefined, optional
        config ref
    metadata : S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecPublishConnectionDetailsToMetadata, default is Undefined, optional
        metadata
    name : str, default is Undefined, required
        Name is the name of the connection secret.
    """
    configRef?: S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecPublishConnectionDetailsToConfigRef
    metadata?: S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecPublishConnectionDetailsToMetadata
    name: str

schema S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecPublishConnectionDetailsToConfigRef:
    r"""
    SecretStoreConfigRef specifies which secret store config should be used
    for this ConnectionSecret.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecPublishConnectionDetailsToConfigRefPolicy, default is Undefined, optional
        policy
    """
    name: str

    policy?: S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecPublishConnectionDetailsToConfigRefPolicy

schema S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecPublishConnectionDetailsToConfigRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """
    resolution?: "Required" | "Optional" = "Required"
    resolve?: "Always" | "IfNotPresent"

schema S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecPublishConnectionDetailsToMetadata:
    r"""
    Metadata is the metadata for connection secret.

    Attributes
    ----------
    annotations : {str:str}, default is Undefined, optional
        Annotations are the annotations to be added to connection secret.
        - For Kubernetes secrets, this will be used as "metadata.annotations".
        - It is up to Secret Store implementation for others store types.
    labels : {str:str}, default is Undefined, optional
        Labels are the labels/tags to be added to connection secret.
        - For Kubernetes secrets, this will be used as "metadata.labels".
        - It is up to Secret Store implementation for others store types.
    $type : str, default is Undefined, optional
        Type is the SecretType for the connection secret.
        - Only valid for Kubernetes Secret Stores.
    """
    annotations?: {str:str}
    labels?: {str:str}
    $type?: str

schema S3AwsUpboundIoV1beta2BucketOwnershipControlsSpecWriteConnectionSecretToRef:
    r"""
    WriteConnectionSecretToReference specifies the namespace and name of a
    Secret to which any connection details for this managed resource should
    be written. Connection details frequently include the endpoint, username,
    and password required to connect to the managed resource.
    This field is planned to be replaced in a future release in favor of
    PublishConnectionDetailsTo. Currently, both could be set independently
    and connection details would be published to both without affecting
    each other.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the secret.
    namespace : str, default is Undefined, required
        Namespace of the secret.
    """
    name: str

    namespace: str

schema S3AwsUpboundIoV1beta2BucketOwnershipControlsStatus:
    r"""
    BucketOwnershipControlsStatus defines the observed state of BucketOwnershipControls.

    Attributes
    ----------
    atProvider : S3AwsUpboundIoV1beta2BucketOwnershipControlsStatusAtProvider, default is Undefined, optional
        at provider
    conditions : [S3AwsUpboundIoV1beta2BucketOwnershipControlsStatusConditionsItems0], default is Undefined, optional
        Conditions of the resource.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration is the latest metadata.generation
        which resulted in either a ready state, or stalled due to error
        it can not recover from without human intervention.
    """
    atProvider?: S3AwsUpboundIoV1beta2BucketOwnershipControlsStatusAtProvider
    conditions?: [S3AwsUpboundIoV1beta2BucketOwnershipControlsStatusConditionsItems0]
    observedGeneration?: int

schema S3AwsUpboundIoV1beta2BucketOwnershipControlsStatusAtProvider:
    r"""
    s3 aws upbound io v1beta2 bucket ownership controls status at provider

    Attributes
    ----------
    bucket : str, default is Undefined, optional
        Name of the bucket that you want to associate this access point with.
    id : str, default is Undefined, optional
        S3 Bucket name.
    $rule : S3AwsUpboundIoV1beta2BucketOwnershipControlsStatusAtProviderRule, default is Undefined, optional
        rule
    """
    bucket?: str
    id?: str
    $rule?: S3AwsUpboundIoV1beta2BucketOwnershipControlsStatusAtProviderRule

schema S3AwsUpboundIoV1beta2BucketOwnershipControlsStatusAtProviderRule:
    r"""
    Configuration block(s) with Ownership Controls rules. Detailed below.

    Attributes
    ----------
    objectOwnership : str, default is Undefined, optional
        Object ownership. Valid values: BucketOwnerPreferred, ObjectWriter or BucketOwnerEnforced
    """
    objectOwnership?: str

schema S3AwsUpboundIoV1beta2BucketOwnershipControlsStatusConditionsItems0:
    r"""
    A Condition that may apply to a resource.

    Attributes
    ----------
    lastTransitionTime : str, default is Undefined, required
        LastTransitionTime is the last time this condition transitioned from one
        status to another.
    message : str, default is Undefined, optional
        A Message containing details about this condition's last transition from
        one status to another, if any.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration represents the .metadata.generation that the condition was set based upon.
        For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date
        with respect to the current state of the instance.
    reason : str, default is Undefined, required
        A Reason for this condition's last transition from one status to another.
    status : str, default is Undefined, required
        Status of this condition; is it currently True, False, or Unknown?
    $type : str, default is Undefined, required
        Type of this condition. At most one of each condition type may apply to
        a resource at any point in time.
    """
    lastTransitionTime: str

    message?: str
    observedGeneration?: int
    reason: str

    status: str

    $type: str

