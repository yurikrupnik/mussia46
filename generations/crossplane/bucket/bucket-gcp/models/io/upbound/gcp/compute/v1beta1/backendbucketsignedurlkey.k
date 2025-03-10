"""
This file was generated by the KCL auto-gen tool. DO NOT EDIT.
Editing this file might prove futile when you re-run the KCL auto-gen generate command.
"""
import k8s.apimachinery.pkg.apis.meta.v1


schema BackendBucketSignedURLKey:
    r"""
    BackendBucketSignedURLKey is the Schema for the BackendBucketSignedURLKeys API. A key for signing Cloud CDN signed URLs for BackendBuckets.

    Attributes
    ----------
    apiVersion : str, default is "compute.gcp.upbound.io/v1beta1", required
        APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
    kind : str, default is "BackendBucketSignedURLKey", required
        Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    metadata : v1.ObjectMeta, default is Undefined, optional
        metadata
    spec : ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpec, default is Undefined, required
        spec
    status : ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeyStatus, default is Undefined, optional
        status
    """


    apiVersion: "compute.gcp.upbound.io/v1beta1" = "compute.gcp.upbound.io/v1beta1"

    kind: "BackendBucketSignedURLKey" = "BackendBucketSignedURLKey"

    metadata?: v1.ObjectMeta

    spec: ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpec

    status?: ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeyStatus


schema ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpec:
    r"""
    BackendBucketSignedURLKeySpec defines the desired state of BackendBucketSignedURLKey

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
    forProvider : ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecForProvider, default is Undefined, required
        for provider
    initProvider : ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecInitProvider, default is Undefined, optional
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
    providerConfigRef : ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecProviderConfigRef, default is Undefined, optional
        provider config ref
    publishConnectionDetailsTo : ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecPublishConnectionDetailsTo, default is Undefined, optional
        publish connection details to
    writeConnectionSecretToRef : ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecWriteConnectionSecretToRef, default is Undefined, optional
        write connection secret to ref
    """


    deletionPolicy?: "Orphan" | "Delete" = "Delete"

    forProvider: ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecForProvider

    initProvider?: ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecInitProvider

    managementPolicies?: [str] = ["*"]

    providerConfigRef?: ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecProviderConfigRef

    publishConnectionDetailsTo?: ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecPublishConnectionDetailsTo

    writeConnectionSecretToRef?: ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecWriteConnectionSecretToRef


schema ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecForProvider:
    r"""
    compute gcp upbound io v1beta1 backend bucket signed URL key spec for provider

    Attributes
    ----------
    backendBucket : str, default is Undefined, optional
        The backend bucket this signed URL key belongs.
    backendBucketRef : ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecForProviderBackendBucketRef, default is Undefined, optional
        backend bucket ref
    backendBucketSelector : ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecForProviderBackendBucketSelector, default is Undefined, optional
        backend bucket selector
    keyValueSecretRef : ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecForProviderKeyValueSecretRef, default is Undefined, optional
        key value secret ref
    name : str, default is Undefined, optional
        Name of the signed URL key.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs.
        If it is not provided, the provider project is used.
    """


    backendBucket?: str

    backendBucketRef?: ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecForProviderBackendBucketRef

    backendBucketSelector?: ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecForProviderBackendBucketSelector

    keyValueSecretRef?: ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecForProviderKeyValueSecretRef

    name?: str

    project?: str


schema ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecForProviderBackendBucketRef:
    r"""
    Reference to a BackendBucket in compute to populate backendBucket.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecForProviderBackendBucketRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecForProviderBackendBucketRefPolicy


schema ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecForProviderBackendBucketRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecForProviderBackendBucketSelector:
    r"""
    Selector for a BackendBucket in compute to populate backendBucket.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecForProviderBackendBucketSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecForProviderBackendBucketSelectorPolicy


schema ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecForProviderBackendBucketSelectorPolicy:
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


schema ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecForProviderKeyValueSecretRef:
    r"""
    128-bit key value used for signing the URL. The key value must be a
    valid RFC 4648 Section 5 base64url encoded string.
    Note: This property is sensitive and will not be displayed in the plan.

    Attributes
    ----------
    key : str, default is Undefined, required
        The key to select.
    name : str, default is Undefined, required
        Name of the secret.
    namespace : str, default is Undefined, required
        Namespace of the secret.
    """


    key: str

    name: str

    namespace: str


schema ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecInitProvider:
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
    backendBucket : str, default is Undefined, optional
        The backend bucket this signed URL key belongs.
    backendBucketRef : ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecInitProviderBackendBucketRef, default is Undefined, optional
        backend bucket ref
    backendBucketSelector : ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecInitProviderBackendBucketSelector, default is Undefined, optional
        backend bucket selector
    keyValueSecretRef : ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecInitProviderKeyValueSecretRef, default is Undefined, required
        key value secret ref
    name : str, default is Undefined, optional
        Name of the signed URL key.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs.
        If it is not provided, the provider project is used.
    """


    backendBucket?: str

    backendBucketRef?: ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecInitProviderBackendBucketRef

    backendBucketSelector?: ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecInitProviderBackendBucketSelector

    keyValueSecretRef: ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecInitProviderKeyValueSecretRef

    name?: str

    project?: str


schema ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecInitProviderBackendBucketRef:
    r"""
    Reference to a BackendBucket in compute to populate backendBucket.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecInitProviderBackendBucketRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecInitProviderBackendBucketRefPolicy


schema ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecInitProviderBackendBucketRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecInitProviderBackendBucketSelector:
    r"""
    Selector for a BackendBucket in compute to populate backendBucket.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecInitProviderBackendBucketSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecInitProviderBackendBucketSelectorPolicy


schema ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecInitProviderBackendBucketSelectorPolicy:
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


schema ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecInitProviderKeyValueSecretRef:
    r"""
    128-bit key value used for signing the URL. The key value must be a
    valid RFC 4648 Section 5 base64url encoded string.
    Note: This property is sensitive and will not be displayed in the plan.

    Attributes
    ----------
    key : str, default is Undefined, required
        The key to select.
    name : str, default is Undefined, required
        Name of the secret.
    namespace : str, default is Undefined, required
        Namespace of the secret.
    """


    key: str

    name: str

    namespace: str


schema ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecProviderConfigRef:
    r"""
    ProviderConfigReference specifies how the provider that will be used to
    create, observe, update, and delete this managed resource should be
    configured.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecProviderConfigRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecProviderConfigRefPolicy


schema ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecProviderConfigRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecPublishConnectionDetailsTo:
    r"""
    PublishConnectionDetailsTo specifies the connection secret config which
    contains a name, metadata and a reference to secret store config to
    which any connection details for this managed resource should be written.
    Connection details frequently include the endpoint, username,
    and password required to connect to the managed resource.

    Attributes
    ----------
    configRef : ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecPublishConnectionDetailsToConfigRef, default is Undefined, optional
        config ref
    metadata : ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecPublishConnectionDetailsToMetadata, default is Undefined, optional
        metadata
    name : str, default is Undefined, required
        Name is the name of the connection secret.
    """


    configRef?: ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecPublishConnectionDetailsToConfigRef

    metadata?: ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecPublishConnectionDetailsToMetadata

    name: str


schema ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecPublishConnectionDetailsToConfigRef:
    r"""
    SecretStoreConfigRef specifies which secret store config should be used
    for this ConnectionSecret.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecPublishConnectionDetailsToConfigRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecPublishConnectionDetailsToConfigRefPolicy


schema ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecPublishConnectionDetailsToConfigRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecPublishConnectionDetailsToMetadata:
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


schema ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeySpecWriteConnectionSecretToRef:
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


schema ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeyStatus:
    r"""
    BackendBucketSignedURLKeyStatus defines the observed state of BackendBucketSignedURLKey.

    Attributes
    ----------
    atProvider : ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeyStatusAtProvider, default is Undefined, optional
        at provider
    conditions : [ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeyStatusConditionsItems0], default is Undefined, optional
        Conditions of the resource.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration is the latest metadata.generation
        which resulted in either a ready state, or stalled due to error
        it can not recover from without human intervention.
    """


    atProvider?: ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeyStatusAtProvider

    conditions?: [ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeyStatusConditionsItems0]

    observedGeneration?: int


schema ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeyStatusAtProvider:
    r"""
    compute gcp upbound io v1beta1 backend bucket signed URL key status at provider

    Attributes
    ----------
    backendBucket : str, default is Undefined, optional
        The backend bucket this signed URL key belongs.
    id : str, default is Undefined, optional
        an identifier for the resource with format projects/{{project}}/global/backendBuckets/{{backend_bucket}}
    name : str, default is Undefined, optional
        Name of the signed URL key.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs.
        If it is not provided, the provider project is used.
    """


    backendBucket?: str

    id?: str

    name?: str

    project?: str


schema ComputeGcpUpboundIoV1beta1BackendBucketSignedURLKeyStatusConditionsItems0:
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


