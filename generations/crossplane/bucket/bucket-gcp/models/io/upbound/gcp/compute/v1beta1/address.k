"""
This file was generated by the KCL auto-gen tool. DO NOT EDIT.
Editing this file might prove futile when you re-run the KCL auto-gen generate command.
"""
import k8s.apimachinery.pkg.apis.meta.v1


schema Address:
    r"""
    Address is the Schema for the Addresss API. Represents an Address resource.

    Attributes
    ----------
    apiVersion : str, default is "compute.gcp.upbound.io/v1beta1", required
        APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
    kind : str, default is "Address", required
        Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    metadata : v1.ObjectMeta, default is Undefined, optional
        metadata
    spec : ComputeGcpUpboundIoV1beta1AddressSpec, default is Undefined, required
        spec
    status : ComputeGcpUpboundIoV1beta1AddressStatus, default is Undefined, optional
        status
    """


    apiVersion: "compute.gcp.upbound.io/v1beta1" = "compute.gcp.upbound.io/v1beta1"

    kind: "Address" = "Address"

    metadata?: v1.ObjectMeta

    spec: ComputeGcpUpboundIoV1beta1AddressSpec

    status?: ComputeGcpUpboundIoV1beta1AddressStatus


schema ComputeGcpUpboundIoV1beta1AddressSpec:
    r"""
    AddressSpec defines the desired state of Address

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
    forProvider : ComputeGcpUpboundIoV1beta1AddressSpecForProvider, default is Undefined, required
        for provider
    initProvider : ComputeGcpUpboundIoV1beta1AddressSpecInitProvider, default is Undefined, optional
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
    providerConfigRef : ComputeGcpUpboundIoV1beta1AddressSpecProviderConfigRef, default is Undefined, optional
        provider config ref
    publishConnectionDetailsTo : ComputeGcpUpboundIoV1beta1AddressSpecPublishConnectionDetailsTo, default is Undefined, optional
        publish connection details to
    writeConnectionSecretToRef : ComputeGcpUpboundIoV1beta1AddressSpecWriteConnectionSecretToRef, default is Undefined, optional
        write connection secret to ref
    """


    deletionPolicy?: "Orphan" | "Delete" = "Delete"

    forProvider: ComputeGcpUpboundIoV1beta1AddressSpecForProvider

    initProvider?: ComputeGcpUpboundIoV1beta1AddressSpecInitProvider

    managementPolicies?: [str] = ["*"]

    providerConfigRef?: ComputeGcpUpboundIoV1beta1AddressSpecProviderConfigRef

    publishConnectionDetailsTo?: ComputeGcpUpboundIoV1beta1AddressSpecPublishConnectionDetailsTo

    writeConnectionSecretToRef?: ComputeGcpUpboundIoV1beta1AddressSpecWriteConnectionSecretToRef


schema ComputeGcpUpboundIoV1beta1AddressSpecForProvider:
    r"""
    compute gcp upbound io v1beta1 address spec for provider

    Attributes
    ----------
    address : str, default is Undefined, optional
        The static external IP address represented by this resource.
        The IP address must be inside the specified subnetwork,
        if any. Set by the API if undefined.
    addressType : str, default is Undefined, optional
        The type of address to reserve.
        Note: if you set this argument's value as INTERNAL you need to leave the network_tier argument unset in that resource block.
        Default value is EXTERNAL.
        Possible values are: INTERNAL, EXTERNAL.
    description : str, default is Undefined, optional
        An optional description of this resource.
    ipVersion : str, default is Undefined, optional
        The IP Version that will be used by this address. The default value is IPV4.
        Possible values are: IPV4, IPV6.
    ipv6EndpointType : str, default is Undefined, optional
        The endpoint type of this address, which should be VM or NETLB. This is
        used for deciding which type of endpoint this address can be used after
        the external IPv6 address reservation.
        Possible values are: VM, NETLB.
    labels : {str:str}, default is Undefined, optional
        Labels to apply to this address.  A list of key->value pairs.
    network : str, default is Undefined, optional
        The URL of the network in which to reserve the address. This field
        can only be used with INTERNAL type with the VPC_PEERING and
        IPSEC_INTERCONNECT purposes.
    networkRef : ComputeGcpUpboundIoV1beta1AddressSpecForProviderNetworkRef, default is Undefined, optional
        network ref
    networkSelector : ComputeGcpUpboundIoV1beta1AddressSpecForProviderNetworkSelector, default is Undefined, optional
        network selector
    networkTier : str, default is Undefined, optional
        The networking tier used for configuring this address. If this field is not
        specified, it is assumed to be PREMIUM.
        This argument should not be used when configuring Internal addresses, because network tier cannot be set for internal traffic; it's always Premium.
        Possible values are: PREMIUM, STANDARD.
    prefixLength : float, default is Undefined, optional
        The prefix length if the resource represents an IP range.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs.
        If it is not provided, the provider project is used.
    purpose : str, default is Undefined, optional
        The purpose of this resource, which can be one of the following values.
    region : str, default is Undefined, required
        The Region in which the created address should reside.
        If it is not provided, the provider region is used.
    subnetwork : str, default is Undefined, optional
        The URL of the subnetwork in which to reserve the address. If an IP
        address is specified, it must be within the subnetwork's IP range.
        This field can only be used with INTERNAL type with
        GCE_ENDPOINT/DNS_RESOLVER purposes.
    subnetworkRef : ComputeGcpUpboundIoV1beta1AddressSpecForProviderSubnetworkRef, default is Undefined, optional
        subnetwork ref
    subnetworkSelector : ComputeGcpUpboundIoV1beta1AddressSpecForProviderSubnetworkSelector, default is Undefined, optional
        subnetwork selector
    """


    address?: str

    addressType?: str

    description?: str

    ipVersion?: str

    ipv6EndpointType?: str

    labels?: {str:str}

    network?: str

    networkRef?: ComputeGcpUpboundIoV1beta1AddressSpecForProviderNetworkRef

    networkSelector?: ComputeGcpUpboundIoV1beta1AddressSpecForProviderNetworkSelector

    networkTier?: str

    prefixLength?: float

    project?: str

    purpose?: str

    region: str

    subnetwork?: str

    subnetworkRef?: ComputeGcpUpboundIoV1beta1AddressSpecForProviderSubnetworkRef

    subnetworkSelector?: ComputeGcpUpboundIoV1beta1AddressSpecForProviderSubnetworkSelector


schema ComputeGcpUpboundIoV1beta1AddressSpecForProviderNetworkRef:
    r"""
    Reference to a Network in compute to populate network.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1AddressSpecForProviderNetworkRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1AddressSpecForProviderNetworkRefPolicy


schema ComputeGcpUpboundIoV1beta1AddressSpecForProviderNetworkRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1AddressSpecForProviderNetworkSelector:
    r"""
    Selector for a Network in compute to populate network.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : ComputeGcpUpboundIoV1beta1AddressSpecForProviderNetworkSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: ComputeGcpUpboundIoV1beta1AddressSpecForProviderNetworkSelectorPolicy


schema ComputeGcpUpboundIoV1beta1AddressSpecForProviderNetworkSelectorPolicy:
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


schema ComputeGcpUpboundIoV1beta1AddressSpecForProviderSubnetworkRef:
    r"""
    Reference to a Subnetwork in compute to populate subnetwork.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1AddressSpecForProviderSubnetworkRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1AddressSpecForProviderSubnetworkRefPolicy


schema ComputeGcpUpboundIoV1beta1AddressSpecForProviderSubnetworkRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1AddressSpecForProviderSubnetworkSelector:
    r"""
    Selector for a Subnetwork in compute to populate subnetwork.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : ComputeGcpUpboundIoV1beta1AddressSpecForProviderSubnetworkSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: ComputeGcpUpboundIoV1beta1AddressSpecForProviderSubnetworkSelectorPolicy


schema ComputeGcpUpboundIoV1beta1AddressSpecForProviderSubnetworkSelectorPolicy:
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


schema ComputeGcpUpboundIoV1beta1AddressSpecInitProvider:
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
    address : str, default is Undefined, optional
        The static external IP address represented by this resource.
        The IP address must be inside the specified subnetwork,
        if any. Set by the API if undefined.
    addressType : str, default is Undefined, optional
        The type of address to reserve.
        Note: if you set this argument's value as INTERNAL you need to leave the network_tier argument unset in that resource block.
        Default value is EXTERNAL.
        Possible values are: INTERNAL, EXTERNAL.
    description : str, default is Undefined, optional
        An optional description of this resource.
    ipVersion : str, default is Undefined, optional
        The IP Version that will be used by this address. The default value is IPV4.
        Possible values are: IPV4, IPV6.
    ipv6EndpointType : str, default is Undefined, optional
        The endpoint type of this address, which should be VM or NETLB. This is
        used for deciding which type of endpoint this address can be used after
        the external IPv6 address reservation.
        Possible values are: VM, NETLB.
    labels : {str:str}, default is Undefined, optional
        Labels to apply to this address.  A list of key->value pairs.
    network : str, default is Undefined, optional
        The URL of the network in which to reserve the address. This field
        can only be used with INTERNAL type with the VPC_PEERING and
        IPSEC_INTERCONNECT purposes.
    networkRef : ComputeGcpUpboundIoV1beta1AddressSpecInitProviderNetworkRef, default is Undefined, optional
        network ref
    networkSelector : ComputeGcpUpboundIoV1beta1AddressSpecInitProviderNetworkSelector, default is Undefined, optional
        network selector
    networkTier : str, default is Undefined, optional
        The networking tier used for configuring this address. If this field is not
        specified, it is assumed to be PREMIUM.
        This argument should not be used when configuring Internal addresses, because network tier cannot be set for internal traffic; it's always Premium.
        Possible values are: PREMIUM, STANDARD.
    prefixLength : float, default is Undefined, optional
        The prefix length if the resource represents an IP range.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs.
        If it is not provided, the provider project is used.
    purpose : str, default is Undefined, optional
        The purpose of this resource, which can be one of the following values.
    subnetwork : str, default is Undefined, optional
        The URL of the subnetwork in which to reserve the address. If an IP
        address is specified, it must be within the subnetwork's IP range.
        This field can only be used with INTERNAL type with
        GCE_ENDPOINT/DNS_RESOLVER purposes.
    subnetworkRef : ComputeGcpUpboundIoV1beta1AddressSpecInitProviderSubnetworkRef, default is Undefined, optional
        subnetwork ref
    subnetworkSelector : ComputeGcpUpboundIoV1beta1AddressSpecInitProviderSubnetworkSelector, default is Undefined, optional
        subnetwork selector
    """


    address?: str

    addressType?: str

    description?: str

    ipVersion?: str

    ipv6EndpointType?: str

    labels?: {str:str}

    network?: str

    networkRef?: ComputeGcpUpboundIoV1beta1AddressSpecInitProviderNetworkRef

    networkSelector?: ComputeGcpUpboundIoV1beta1AddressSpecInitProviderNetworkSelector

    networkTier?: str

    prefixLength?: float

    project?: str

    purpose?: str

    subnetwork?: str

    subnetworkRef?: ComputeGcpUpboundIoV1beta1AddressSpecInitProviderSubnetworkRef

    subnetworkSelector?: ComputeGcpUpboundIoV1beta1AddressSpecInitProviderSubnetworkSelector


schema ComputeGcpUpboundIoV1beta1AddressSpecInitProviderNetworkRef:
    r"""
    Reference to a Network in compute to populate network.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1AddressSpecInitProviderNetworkRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1AddressSpecInitProviderNetworkRefPolicy


schema ComputeGcpUpboundIoV1beta1AddressSpecInitProviderNetworkRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1AddressSpecInitProviderNetworkSelector:
    r"""
    Selector for a Network in compute to populate network.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : ComputeGcpUpboundIoV1beta1AddressSpecInitProviderNetworkSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: ComputeGcpUpboundIoV1beta1AddressSpecInitProviderNetworkSelectorPolicy


schema ComputeGcpUpboundIoV1beta1AddressSpecInitProviderNetworkSelectorPolicy:
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


schema ComputeGcpUpboundIoV1beta1AddressSpecInitProviderSubnetworkRef:
    r"""
    Reference to a Subnetwork in compute to populate subnetwork.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1AddressSpecInitProviderSubnetworkRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1AddressSpecInitProviderSubnetworkRefPolicy


schema ComputeGcpUpboundIoV1beta1AddressSpecInitProviderSubnetworkRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1AddressSpecInitProviderSubnetworkSelector:
    r"""
    Selector for a Subnetwork in compute to populate subnetwork.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : ComputeGcpUpboundIoV1beta1AddressSpecInitProviderSubnetworkSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: ComputeGcpUpboundIoV1beta1AddressSpecInitProviderSubnetworkSelectorPolicy


schema ComputeGcpUpboundIoV1beta1AddressSpecInitProviderSubnetworkSelectorPolicy:
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


schema ComputeGcpUpboundIoV1beta1AddressSpecProviderConfigRef:
    r"""
    ProviderConfigReference specifies how the provider that will be used to
    create, observe, update, and delete this managed resource should be
    configured.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1AddressSpecProviderConfigRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1AddressSpecProviderConfigRefPolicy


schema ComputeGcpUpboundIoV1beta1AddressSpecProviderConfigRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1AddressSpecPublishConnectionDetailsTo:
    r"""
    PublishConnectionDetailsTo specifies the connection secret config which
    contains a name, metadata and a reference to secret store config to
    which any connection details for this managed resource should be written.
    Connection details frequently include the endpoint, username,
    and password required to connect to the managed resource.

    Attributes
    ----------
    configRef : ComputeGcpUpboundIoV1beta1AddressSpecPublishConnectionDetailsToConfigRef, default is Undefined, optional
        config ref
    metadata : ComputeGcpUpboundIoV1beta1AddressSpecPublishConnectionDetailsToMetadata, default is Undefined, optional
        metadata
    name : str, default is Undefined, required
        Name is the name of the connection secret.
    """


    configRef?: ComputeGcpUpboundIoV1beta1AddressSpecPublishConnectionDetailsToConfigRef

    metadata?: ComputeGcpUpboundIoV1beta1AddressSpecPublishConnectionDetailsToMetadata

    name: str


schema ComputeGcpUpboundIoV1beta1AddressSpecPublishConnectionDetailsToConfigRef:
    r"""
    SecretStoreConfigRef specifies which secret store config should be used
    for this ConnectionSecret.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1AddressSpecPublishConnectionDetailsToConfigRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1AddressSpecPublishConnectionDetailsToConfigRefPolicy


schema ComputeGcpUpboundIoV1beta1AddressSpecPublishConnectionDetailsToConfigRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1AddressSpecPublishConnectionDetailsToMetadata:
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


schema ComputeGcpUpboundIoV1beta1AddressSpecWriteConnectionSecretToRef:
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


schema ComputeGcpUpboundIoV1beta1AddressStatus:
    r"""
    AddressStatus defines the observed state of Address.

    Attributes
    ----------
    atProvider : ComputeGcpUpboundIoV1beta1AddressStatusAtProvider, default is Undefined, optional
        at provider
    conditions : [ComputeGcpUpboundIoV1beta1AddressStatusConditionsItems0], default is Undefined, optional
        Conditions of the resource.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration is the latest metadata.generation
        which resulted in either a ready state, or stalled due to error
        it can not recover from without human intervention.
    """


    atProvider?: ComputeGcpUpboundIoV1beta1AddressStatusAtProvider

    conditions?: [ComputeGcpUpboundIoV1beta1AddressStatusConditionsItems0]

    observedGeneration?: int


schema ComputeGcpUpboundIoV1beta1AddressStatusAtProvider:
    r"""
    compute gcp upbound io v1beta1 address status at provider

    Attributes
    ----------
    address : str, default is Undefined, optional
        The static external IP address represented by this resource.
        The IP address must be inside the specified subnetwork,
        if any. Set by the API if undefined.
    addressType : str, default is Undefined, optional
        The type of address to reserve.
        Note: if you set this argument's value as INTERNAL you need to leave the network_tier argument unset in that resource block.
        Default value is EXTERNAL.
        Possible values are: INTERNAL, EXTERNAL.
    creationTimestamp : str, default is Undefined, optional
        Creation timestamp in RFC3339 text format.
    description : str, default is Undefined, optional
        An optional description of this resource.
    effectiveLabels : {str:str}, default is Undefined, optional
        for all of the labels present on the resource.
    id : str, default is Undefined, optional
        an identifier for the resource with format projects/{{project}}/regions/{{region}}/addresses/{{name}}
    ipVersion : str, default is Undefined, optional
        The IP Version that will be used by this address. The default value is IPV4.
        Possible values are: IPV4, IPV6.
    ipv6EndpointType : str, default is Undefined, optional
        The endpoint type of this address, which should be VM or NETLB. This is
        used for deciding which type of endpoint this address can be used after
        the external IPv6 address reservation.
        Possible values are: VM, NETLB.
    labelFingerprint : str, default is Undefined, optional
        The fingerprint used for optimistic locking of this resource.  Used
        internally during updates.
    labels : {str:str}, default is Undefined, optional
        Labels to apply to this address.  A list of key->value pairs.
    network : str, default is Undefined, optional
        The URL of the network in which to reserve the address. This field
        can only be used with INTERNAL type with the VPC_PEERING and
        IPSEC_INTERCONNECT purposes.
    networkTier : str, default is Undefined, optional
        The networking tier used for configuring this address. If this field is not
        specified, it is assumed to be PREMIUM.
        This argument should not be used when configuring Internal addresses, because network tier cannot be set for internal traffic; it's always Premium.
        Possible values are: PREMIUM, STANDARD.
    prefixLength : float, default is Undefined, optional
        The prefix length if the resource represents an IP range.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs.
        If it is not provided, the provider project is used.
    purpose : str, default is Undefined, optional
        The purpose of this resource, which can be one of the following values.
    region : str, default is Undefined, optional
        The Region in which the created address should reside.
        If it is not provided, the provider region is used.
    selfLink : str, default is Undefined, optional
        The URI of the created resource.
    subnetwork : str, default is Undefined, optional
        The URL of the subnetwork in which to reserve the address. If an IP
        address is specified, it must be within the subnetwork's IP range.
        This field can only be used with INTERNAL type with
        GCE_ENDPOINT/DNS_RESOLVER purposes.
    terraformLabels : {str:str}, default is Undefined, optional
        The combination of labels configured directly on the resource
        and default labels configured on the provider.
    users : [str], default is Undefined, optional
        The URLs of the resources that are using this address.
    """


    address?: str

    addressType?: str

    creationTimestamp?: str

    description?: str

    effectiveLabels?: {str:str}

    id?: str

    ipVersion?: str

    ipv6EndpointType?: str

    labelFingerprint?: str

    labels?: {str:str}

    network?: str

    networkTier?: str

    prefixLength?: float

    project?: str

    purpose?: str

    region?: str

    selfLink?: str

    subnetwork?: str

    terraformLabels?: {str:str}

    users?: [str]


schema ComputeGcpUpboundIoV1beta1AddressStatusConditionsItems0:
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


