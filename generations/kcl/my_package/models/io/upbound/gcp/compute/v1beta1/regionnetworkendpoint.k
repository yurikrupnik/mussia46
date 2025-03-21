"""
This file was generated by the KCL auto-gen tool. DO NOT EDIT.
Editing this file might prove futile when you re-run the KCL auto-gen generate command.
"""
import k8s.apimachinery.pkg.apis.meta.v1


schema RegionNetworkEndpoint:
    r"""
    RegionNetworkEndpoint is the Schema for the RegionNetworkEndpoints API. A Region network endpoint represents a IP address/FQDN and port combination that is part of a specific network endpoint group (NEG).

    Attributes
    ----------
    apiVersion : str, default is "compute.gcp.upbound.io/v1beta1", required
        APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
    kind : str, default is "RegionNetworkEndpoint", required
        Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    metadata : v1.ObjectMeta, default is Undefined, optional
        metadata
    spec : ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpec, default is Undefined, required
        spec
    status : ComputeGcpUpboundIoV1beta1RegionNetworkEndpointStatus, default is Undefined, optional
        status
    """


    apiVersion: "compute.gcp.upbound.io/v1beta1" = "compute.gcp.upbound.io/v1beta1"

    kind: "RegionNetworkEndpoint" = "RegionNetworkEndpoint"

    metadata?: v1.ObjectMeta

    spec: ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpec

    status?: ComputeGcpUpboundIoV1beta1RegionNetworkEndpointStatus


schema ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpec:
    r"""
    RegionNetworkEndpointSpec defines the desired state of RegionNetworkEndpoint

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
    forProvider : ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecForProvider, default is Undefined, required
        for provider
    initProvider : ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecInitProvider, default is Undefined, optional
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
    providerConfigRef : ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecProviderConfigRef, default is Undefined, optional
        provider config ref
    publishConnectionDetailsTo : ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecPublishConnectionDetailsTo, default is Undefined, optional
        publish connection details to
    writeConnectionSecretToRef : ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecWriteConnectionSecretToRef, default is Undefined, optional
        write connection secret to ref
    """


    deletionPolicy?: "Orphan" | "Delete" = "Delete"

    forProvider: ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecForProvider

    initProvider?: ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecInitProvider

    managementPolicies?: [str] = ["*"]

    providerConfigRef?: ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecProviderConfigRef

    publishConnectionDetailsTo?: ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecPublishConnectionDetailsTo

    writeConnectionSecretToRef?: ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecWriteConnectionSecretToRef


schema ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecForProvider:
    r"""
    compute gcp upbound io v1beta1 region network endpoint spec for provider

    Attributes
    ----------
    fqdn : str, default is Undefined, optional
        Fully qualified domain name of network endpoint.
        This can only be specified when network_endpoint_type of the NEG is INTERNET_FQDN_PORT.
    ipAddress : str, default is Undefined, optional
        IPv4 address external endpoint.
        This can only be specified when network_endpoint_type of the NEG is INTERNET_IP_PORT.
    port : float, default is Undefined, optional
        Port number of network endpoint.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs.
        If it is not provided, the provider project is used.
    region : str, default is Undefined, optional
        Region where the containing network endpoint group is located.
    regionNetworkEndpointGroup : str, default is Undefined, optional
        The network endpoint group this endpoint is part of.
    regionNetworkEndpointGroupRef : ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecForProviderRegionNetworkEndpointGroupRef, default is Undefined, optional
        region network endpoint group ref
    regionNetworkEndpointGroupSelector : ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecForProviderRegionNetworkEndpointGroupSelector, default is Undefined, optional
        region network endpoint group selector
    """


    fqdn?: str

    ipAddress?: str

    port?: float

    project?: str

    region?: str

    regionNetworkEndpointGroup?: str

    regionNetworkEndpointGroupRef?: ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecForProviderRegionNetworkEndpointGroupRef

    regionNetworkEndpointGroupSelector?: ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecForProviderRegionNetworkEndpointGroupSelector


schema ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecForProviderRegionNetworkEndpointGroupRef:
    r"""
    Reference to a RegionNetworkEndpointGroup in compute to populate regionNetworkEndpointGroup.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecForProviderRegionNetworkEndpointGroupRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecForProviderRegionNetworkEndpointGroupRefPolicy


schema ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecForProviderRegionNetworkEndpointGroupRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecForProviderRegionNetworkEndpointGroupSelector:
    r"""
    Selector for a RegionNetworkEndpointGroup in compute to populate regionNetworkEndpointGroup.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecForProviderRegionNetworkEndpointGroupSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecForProviderRegionNetworkEndpointGroupSelectorPolicy


schema ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecForProviderRegionNetworkEndpointGroupSelectorPolicy:
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


schema ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecInitProvider:
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
    fqdn : str, default is Undefined, optional
        Fully qualified domain name of network endpoint.
        This can only be specified when network_endpoint_type of the NEG is INTERNET_FQDN_PORT.
    ipAddress : str, default is Undefined, optional
        IPv4 address external endpoint.
        This can only be specified when network_endpoint_type of the NEG is INTERNET_IP_PORT.
    port : float, default is Undefined, optional
        Port number of network endpoint.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs.
        If it is not provided, the provider project is used.
    region : str, default is Undefined, optional
        Region where the containing network endpoint group is located.
    regionNetworkEndpointGroup : str, default is Undefined, optional
        The network endpoint group this endpoint is part of.
    regionNetworkEndpointGroupRef : ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecInitProviderRegionNetworkEndpointGroupRef, default is Undefined, optional
        region network endpoint group ref
    regionNetworkEndpointGroupSelector : ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecInitProviderRegionNetworkEndpointGroupSelector, default is Undefined, optional
        region network endpoint group selector
    """


    fqdn?: str

    ipAddress?: str

    port?: float

    project?: str

    region?: str

    regionNetworkEndpointGroup?: str

    regionNetworkEndpointGroupRef?: ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecInitProviderRegionNetworkEndpointGroupRef

    regionNetworkEndpointGroupSelector?: ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecInitProviderRegionNetworkEndpointGroupSelector


schema ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecInitProviderRegionNetworkEndpointGroupRef:
    r"""
    Reference to a RegionNetworkEndpointGroup in compute to populate regionNetworkEndpointGroup.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecInitProviderRegionNetworkEndpointGroupRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecInitProviderRegionNetworkEndpointGroupRefPolicy


schema ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecInitProviderRegionNetworkEndpointGroupRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecInitProviderRegionNetworkEndpointGroupSelector:
    r"""
    Selector for a RegionNetworkEndpointGroup in compute to populate regionNetworkEndpointGroup.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecInitProviderRegionNetworkEndpointGroupSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecInitProviderRegionNetworkEndpointGroupSelectorPolicy


schema ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecInitProviderRegionNetworkEndpointGroupSelectorPolicy:
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


schema ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecProviderConfigRef:
    r"""
    ProviderConfigReference specifies how the provider that will be used to
    create, observe, update, and delete this managed resource should be
    configured.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecProviderConfigRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecProviderConfigRefPolicy


schema ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecProviderConfigRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecPublishConnectionDetailsTo:
    r"""
    PublishConnectionDetailsTo specifies the connection secret config which
    contains a name, metadata and a reference to secret store config to
    which any connection details for this managed resource should be written.
    Connection details frequently include the endpoint, username,
    and password required to connect to the managed resource.

    Attributes
    ----------
    configRef : ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecPublishConnectionDetailsToConfigRef, default is Undefined, optional
        config ref
    metadata : ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecPublishConnectionDetailsToMetadata, default is Undefined, optional
        metadata
    name : str, default is Undefined, required
        Name is the name of the connection secret.
    """


    configRef?: ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecPublishConnectionDetailsToConfigRef

    metadata?: ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecPublishConnectionDetailsToMetadata

    name: str


schema ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecPublishConnectionDetailsToConfigRef:
    r"""
    SecretStoreConfigRef specifies which secret store config should be used
    for this ConnectionSecret.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecPublishConnectionDetailsToConfigRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecPublishConnectionDetailsToConfigRefPolicy


schema ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecPublishConnectionDetailsToConfigRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecPublishConnectionDetailsToMetadata:
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


schema ComputeGcpUpboundIoV1beta1RegionNetworkEndpointSpecWriteConnectionSecretToRef:
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


schema ComputeGcpUpboundIoV1beta1RegionNetworkEndpointStatus:
    r"""
    RegionNetworkEndpointStatus defines the observed state of RegionNetworkEndpoint.

    Attributes
    ----------
    atProvider : ComputeGcpUpboundIoV1beta1RegionNetworkEndpointStatusAtProvider, default is Undefined, optional
        at provider
    conditions : [ComputeGcpUpboundIoV1beta1RegionNetworkEndpointStatusConditionsItems0], default is Undefined, optional
        Conditions of the resource.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration is the latest metadata.generation
        which resulted in either a ready state, or stalled due to error
        it can not recover from without human intervention.
    """


    atProvider?: ComputeGcpUpboundIoV1beta1RegionNetworkEndpointStatusAtProvider

    conditions?: [ComputeGcpUpboundIoV1beta1RegionNetworkEndpointStatusConditionsItems0]

    observedGeneration?: int


schema ComputeGcpUpboundIoV1beta1RegionNetworkEndpointStatusAtProvider:
    r"""
    compute gcp upbound io v1beta1 region network endpoint status at provider

    Attributes
    ----------
    fqdn : str, default is Undefined, optional
        Fully qualified domain name of network endpoint.
        This can only be specified when network_endpoint_type of the NEG is INTERNET_FQDN_PORT.
    id : str, default is Undefined, optional
        an identifier for the resource with format {{project}}/{{region}}/{{region_network_endpoint_group}}/{{ip_address}}/{{fqdn}}/{{port}}
    ipAddress : str, default is Undefined, optional
        IPv4 address external endpoint.
        This can only be specified when network_endpoint_type of the NEG is INTERNET_IP_PORT.
    port : float, default is Undefined, optional
        Port number of network endpoint.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs.
        If it is not provided, the provider project is used.
    region : str, default is Undefined, optional
        Region where the containing network endpoint group is located.
    regionNetworkEndpointGroup : str, default is Undefined, optional
        The network endpoint group this endpoint is part of.
    """


    fqdn?: str

    id?: str

    ipAddress?: str

    port?: float

    project?: str

    region?: str

    regionNetworkEndpointGroup?: str


schema ComputeGcpUpboundIoV1beta1RegionNetworkEndpointStatusConditionsItems0:
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


