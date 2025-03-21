"""
This file was generated by the KCL auto-gen tool. DO NOT EDIT.
Editing this file might prove futile when you re-run the KCL auto-gen generate command.
"""
import k8s.apimachinery.pkg.apis.meta.v1


schema Image:
    r"""
    Image is the Schema for the Images API. Represents an Image resource.

    Attributes
    ----------
    apiVersion : str, default is "compute.gcp.upbound.io/v1beta1", required
        APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
    kind : str, default is "Image", required
        Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    metadata : v1.ObjectMeta, default is Undefined, optional
        metadata
    spec : ComputeGcpUpboundIoV1beta1ImageSpec, default is Undefined, required
        spec
    status : ComputeGcpUpboundIoV1beta1ImageStatus, default is Undefined, optional
        status
    """


    apiVersion: "compute.gcp.upbound.io/v1beta1" = "compute.gcp.upbound.io/v1beta1"

    kind: "Image" = "Image"

    metadata?: v1.ObjectMeta

    spec: ComputeGcpUpboundIoV1beta1ImageSpec

    status?: ComputeGcpUpboundIoV1beta1ImageStatus


schema ComputeGcpUpboundIoV1beta1ImageSpec:
    r"""
    ImageSpec defines the desired state of Image

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
    forProvider : ComputeGcpUpboundIoV1beta1ImageSpecForProvider, default is Undefined, required
        for provider
    initProvider : ComputeGcpUpboundIoV1beta1ImageSpecInitProvider, default is Undefined, optional
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
    providerConfigRef : ComputeGcpUpboundIoV1beta1ImageSpecProviderConfigRef, default is Undefined, optional
        provider config ref
    publishConnectionDetailsTo : ComputeGcpUpboundIoV1beta1ImageSpecPublishConnectionDetailsTo, default is Undefined, optional
        publish connection details to
    writeConnectionSecretToRef : ComputeGcpUpboundIoV1beta1ImageSpecWriteConnectionSecretToRef, default is Undefined, optional
        write connection secret to ref
    """


    deletionPolicy?: "Orphan" | "Delete" = "Delete"

    forProvider: ComputeGcpUpboundIoV1beta1ImageSpecForProvider

    initProvider?: ComputeGcpUpboundIoV1beta1ImageSpecInitProvider

    managementPolicies?: [str] = ["*"]

    providerConfigRef?: ComputeGcpUpboundIoV1beta1ImageSpecProviderConfigRef

    publishConnectionDetailsTo?: ComputeGcpUpboundIoV1beta1ImageSpecPublishConnectionDetailsTo

    writeConnectionSecretToRef?: ComputeGcpUpboundIoV1beta1ImageSpecWriteConnectionSecretToRef


schema ComputeGcpUpboundIoV1beta1ImageSpecForProvider:
    r"""
    compute gcp upbound io v1beta1 image spec for provider

    Attributes
    ----------
    description : str, default is Undefined, optional
        An optional description of this resource. Provide this property when
        you create the resource.
    diskSizeGb : float, default is Undefined, optional
        Size of the image when restored onto a persistent disk (in GB).
    family : str, default is Undefined, optional
        The name of the image family to which this image belongs. You can
        create disks by specifying an image family instead of a specific
        image name. The image family always returns its latest image that is
        not deprecated. The name of the image family must comply with
        RFC1035.
    guestOsFeatures : [ComputeGcpUpboundIoV1beta1ImageSpecForProviderGuestOsFeaturesItems0], default is Undefined, optional
        A list of features to enable on the guest operating system.
        Applicable only for bootable images.
        Structure is documented below.
    imageEncryptionKey : [ComputeGcpUpboundIoV1beta1ImageSpecForProviderImageEncryptionKeyItems0], default is Undefined, optional
        Encrypts the image using a customer-supplied encryption key.
        After you encrypt an image with a customer-supplied key, you must
        provide the same key if you use the image later (e.g. to create a
        disk from the image)
        Structure is documented below.
    labels : {str:str}, default is Undefined, optional
        Labels to apply to this Image.
        Note: This field is non-authoritative, and will only manage the labels present in your configuration.
        Please refer to the field effective_labels for all of the labels present on the resource.
    licenses : [str], default is Undefined, optional
        Any applicable license URI.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs.
        If it is not provided, the provider project is used.
    rawDisk : [ComputeGcpUpboundIoV1beta1ImageSpecForProviderRawDiskItems0], default is Undefined, optional
        The parameters of the raw disk image.
        Structure is documented below.
    sourceDisk : str, default is Undefined, optional
        The source disk to create this image based on.
        You must provide either this property or the
        rawDisk.source property but not both to create an image.
    sourceImage : str, default is Undefined, optional
        URL of the source image used to create this image. In order to create an image, you must provide the full or partial
        URL of one of the following:
    sourceSnapshot : str, default is Undefined, optional
        URL of the source snapshot used to create this image.
        In order to create an image, you must provide the full or partial URL of one of the following:
    storageLocations : [str], default is Undefined, optional
        Cloud Storage bucket storage location of the image
        (regional or multi-regional).
        Reference link: https://cloud.google.com/compute/docs/reference/rest/v1/images
    """


    description?: str

    diskSizeGb?: float

    family?: str

    guestOsFeatures?: [ComputeGcpUpboundIoV1beta1ImageSpecForProviderGuestOsFeaturesItems0]

    imageEncryptionKey?: [ComputeGcpUpboundIoV1beta1ImageSpecForProviderImageEncryptionKeyItems0]

    labels?: {str:str}

    licenses?: [str]

    project?: str

    rawDisk?: [ComputeGcpUpboundIoV1beta1ImageSpecForProviderRawDiskItems0]

    sourceDisk?: str

    sourceImage?: str

    sourceSnapshot?: str

    storageLocations?: [str]


schema ComputeGcpUpboundIoV1beta1ImageSpecForProviderGuestOsFeaturesItems0:
    r"""
    compute gcp upbound io v1beta1 image spec for provider guest os features items0

    Attributes
    ----------
    $type : str, default is Undefined, optional
        The type of supported feature. Read Enabling guest operating system features to see a list of available options.
        Possible values are: MULTI_IP_SUBNET, SECURE_BOOT, SEV_CAPABLE, UEFI_COMPATIBLE, VIRTIO_SCSI_MULTIQUEUE, WINDOWS, GVNIC, SEV_LIVE_MIGRATABLE, SEV_SNP_CAPABLE, SUSPEND_RESUME_COMPATIBLE, TDX_CAPABLE, SEV_LIVE_MIGRATABLE_V2.
    """


    $type?: str


schema ComputeGcpUpboundIoV1beta1ImageSpecForProviderImageEncryptionKeyItems0:
    r"""
    compute gcp upbound io v1beta1 image spec for provider image encryption key items0

    Attributes
    ----------
    kmsKeySelfLink : str, default is Undefined, optional
        The self link of the encryption key that is stored in Google Cloud
        KMS.
    kmsKeyServiceAccount : str, default is Undefined, optional
        The service account being used for the encryption request for the
        given KMS key. If absent, the Compute Engine default service
        account is used.
    """


    kmsKeySelfLink?: str

    kmsKeyServiceAccount?: str


schema ComputeGcpUpboundIoV1beta1ImageSpecForProviderRawDiskItems0:
    r"""
    compute gcp upbound io v1beta1 image spec for provider raw disk items0

    Attributes
    ----------
    containerType : str, default is Undefined, optional
        The format used to encode and transmit the block device, which
        should be TAR. This is just a container and transmission format
        and not a runtime format. Provided by the client when the disk
        image is created.
        Default value is TAR.
        Possible values are: TAR.
    sha1 : str, default is Undefined, optional
        An optional SHA1 checksum of the disk image before unpackaging.
        This is provided by the client when the disk image is created.
    source : str, default is Undefined, optional
        The full Google Cloud Storage URL where disk storage is stored
        You must provide either this property or the sourceDisk property
        but not both.
    """


    containerType?: str

    sha1?: str

    source?: str


schema ComputeGcpUpboundIoV1beta1ImageSpecInitProvider:
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
    description : str, default is Undefined, optional
        An optional description of this resource. Provide this property when
        you create the resource.
    diskSizeGb : float, default is Undefined, optional
        Size of the image when restored onto a persistent disk (in GB).
    family : str, default is Undefined, optional
        The name of the image family to which this image belongs. You can
        create disks by specifying an image family instead of a specific
        image name. The image family always returns its latest image that is
        not deprecated. The name of the image family must comply with
        RFC1035.
    guestOsFeatures : [ComputeGcpUpboundIoV1beta1ImageSpecInitProviderGuestOsFeaturesItems0], default is Undefined, optional
        A list of features to enable on the guest operating system.
        Applicable only for bootable images.
        Structure is documented below.
    imageEncryptionKey : [ComputeGcpUpboundIoV1beta1ImageSpecInitProviderImageEncryptionKeyItems0], default is Undefined, optional
        Encrypts the image using a customer-supplied encryption key.
        After you encrypt an image with a customer-supplied key, you must
        provide the same key if you use the image later (e.g. to create a
        disk from the image)
        Structure is documented below.
    labels : {str:str}, default is Undefined, optional
        Labels to apply to this Image.
        Note: This field is non-authoritative, and will only manage the labels present in your configuration.
        Please refer to the field effective_labels for all of the labels present on the resource.
    licenses : [str], default is Undefined, optional
        Any applicable license URI.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs.
        If it is not provided, the provider project is used.
    rawDisk : [ComputeGcpUpboundIoV1beta1ImageSpecInitProviderRawDiskItems0], default is Undefined, optional
        The parameters of the raw disk image.
        Structure is documented below.
    sourceDisk : str, default is Undefined, optional
        The source disk to create this image based on.
        You must provide either this property or the
        rawDisk.source property but not both to create an image.
    sourceImage : str, default is Undefined, optional
        URL of the source image used to create this image. In order to create an image, you must provide the full or partial
        URL of one of the following:
    sourceSnapshot : str, default is Undefined, optional
        URL of the source snapshot used to create this image.
        In order to create an image, you must provide the full or partial URL of one of the following:
    storageLocations : [str], default is Undefined, optional
        Cloud Storage bucket storage location of the image
        (regional or multi-regional).
        Reference link: https://cloud.google.com/compute/docs/reference/rest/v1/images
    """


    description?: str

    diskSizeGb?: float

    family?: str

    guestOsFeatures?: [ComputeGcpUpboundIoV1beta1ImageSpecInitProviderGuestOsFeaturesItems0]

    imageEncryptionKey?: [ComputeGcpUpboundIoV1beta1ImageSpecInitProviderImageEncryptionKeyItems0]

    labels?: {str:str}

    licenses?: [str]

    project?: str

    rawDisk?: [ComputeGcpUpboundIoV1beta1ImageSpecInitProviderRawDiskItems0]

    sourceDisk?: str

    sourceImage?: str

    sourceSnapshot?: str

    storageLocations?: [str]


schema ComputeGcpUpboundIoV1beta1ImageSpecInitProviderGuestOsFeaturesItems0:
    r"""
    compute gcp upbound io v1beta1 image spec init provider guest os features items0

    Attributes
    ----------
    $type : str, default is Undefined, optional
        The type of supported feature. Read Enabling guest operating system features to see a list of available options.
        Possible values are: MULTI_IP_SUBNET, SECURE_BOOT, SEV_CAPABLE, UEFI_COMPATIBLE, VIRTIO_SCSI_MULTIQUEUE, WINDOWS, GVNIC, SEV_LIVE_MIGRATABLE, SEV_SNP_CAPABLE, SUSPEND_RESUME_COMPATIBLE, TDX_CAPABLE, SEV_LIVE_MIGRATABLE_V2.
    """


    $type?: str


schema ComputeGcpUpboundIoV1beta1ImageSpecInitProviderImageEncryptionKeyItems0:
    r"""
    compute gcp upbound io v1beta1 image spec init provider image encryption key items0

    Attributes
    ----------
    kmsKeySelfLink : str, default is Undefined, optional
        The self link of the encryption key that is stored in Google Cloud
        KMS.
    kmsKeyServiceAccount : str, default is Undefined, optional
        The service account being used for the encryption request for the
        given KMS key. If absent, the Compute Engine default service
        account is used.
    """


    kmsKeySelfLink?: str

    kmsKeyServiceAccount?: str


schema ComputeGcpUpboundIoV1beta1ImageSpecInitProviderRawDiskItems0:
    r"""
    compute gcp upbound io v1beta1 image spec init provider raw disk items0

    Attributes
    ----------
    containerType : str, default is Undefined, optional
        The format used to encode and transmit the block device, which
        should be TAR. This is just a container and transmission format
        and not a runtime format. Provided by the client when the disk
        image is created.
        Default value is TAR.
        Possible values are: TAR.
    sha1 : str, default is Undefined, optional
        An optional SHA1 checksum of the disk image before unpackaging.
        This is provided by the client when the disk image is created.
    source : str, default is Undefined, optional
        The full Google Cloud Storage URL where disk storage is stored
        You must provide either this property or the sourceDisk property
        but not both.
    """


    containerType?: str

    sha1?: str

    source?: str


schema ComputeGcpUpboundIoV1beta1ImageSpecProviderConfigRef:
    r"""
    ProviderConfigReference specifies how the provider that will be used to
    create, observe, update, and delete this managed resource should be
    configured.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1ImageSpecProviderConfigRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1ImageSpecProviderConfigRefPolicy


schema ComputeGcpUpboundIoV1beta1ImageSpecProviderConfigRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1ImageSpecPublishConnectionDetailsTo:
    r"""
    PublishConnectionDetailsTo specifies the connection secret config which
    contains a name, metadata and a reference to secret store config to
    which any connection details for this managed resource should be written.
    Connection details frequently include the endpoint, username,
    and password required to connect to the managed resource.

    Attributes
    ----------
    configRef : ComputeGcpUpboundIoV1beta1ImageSpecPublishConnectionDetailsToConfigRef, default is Undefined, optional
        config ref
    metadata : ComputeGcpUpboundIoV1beta1ImageSpecPublishConnectionDetailsToMetadata, default is Undefined, optional
        metadata
    name : str, default is Undefined, required
        Name is the name of the connection secret.
    """


    configRef?: ComputeGcpUpboundIoV1beta1ImageSpecPublishConnectionDetailsToConfigRef

    metadata?: ComputeGcpUpboundIoV1beta1ImageSpecPublishConnectionDetailsToMetadata

    name: str


schema ComputeGcpUpboundIoV1beta1ImageSpecPublishConnectionDetailsToConfigRef:
    r"""
    SecretStoreConfigRef specifies which secret store config should be used
    for this ConnectionSecret.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1ImageSpecPublishConnectionDetailsToConfigRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1ImageSpecPublishConnectionDetailsToConfigRefPolicy


schema ComputeGcpUpboundIoV1beta1ImageSpecPublishConnectionDetailsToConfigRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1ImageSpecPublishConnectionDetailsToMetadata:
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


schema ComputeGcpUpboundIoV1beta1ImageSpecWriteConnectionSecretToRef:
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


schema ComputeGcpUpboundIoV1beta1ImageStatus:
    r"""
    ImageStatus defines the observed state of Image.

    Attributes
    ----------
    atProvider : ComputeGcpUpboundIoV1beta1ImageStatusAtProvider, default is Undefined, optional
        at provider
    conditions : [ComputeGcpUpboundIoV1beta1ImageStatusConditionsItems0], default is Undefined, optional
        Conditions of the resource.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration is the latest metadata.generation
        which resulted in either a ready state, or stalled due to error
        it can not recover from without human intervention.
    """


    atProvider?: ComputeGcpUpboundIoV1beta1ImageStatusAtProvider

    conditions?: [ComputeGcpUpboundIoV1beta1ImageStatusConditionsItems0]

    observedGeneration?: int


schema ComputeGcpUpboundIoV1beta1ImageStatusAtProvider:
    r"""
    compute gcp upbound io v1beta1 image status at provider

    Attributes
    ----------
    archiveSizeBytes : float, default is Undefined, optional
        Size of the image tar.gz archive stored in Google Cloud Storage (in
        bytes).
    creationTimestamp : str, default is Undefined, optional
        Creation timestamp in RFC3339 text format.
    description : str, default is Undefined, optional
        An optional description of this resource. Provide this property when
        you create the resource.
    diskSizeGb : float, default is Undefined, optional
        Size of the image when restored onto a persistent disk (in GB).
    effectiveLabels : {str:str}, default is Undefined, optional
        effective labels
    family : str, default is Undefined, optional
        The name of the image family to which this image belongs. You can
        create disks by specifying an image family instead of a specific
        image name. The image family always returns its latest image that is
        not deprecated. The name of the image family must comply with
        RFC1035.
    guestOsFeatures : [ComputeGcpUpboundIoV1beta1ImageStatusAtProviderGuestOsFeaturesItems0], default is Undefined, optional
        A list of features to enable on the guest operating system.
        Applicable only for bootable images.
        Structure is documented below.
    id : str, default is Undefined, optional
        an identifier for the resource with format projects/{{project}}/global/images/{{name}}
    imageEncryptionKey : [ComputeGcpUpboundIoV1beta1ImageStatusAtProviderImageEncryptionKeyItems0], default is Undefined, optional
        Encrypts the image using a customer-supplied encryption key.
        After you encrypt an image with a customer-supplied key, you must
        provide the same key if you use the image later (e.g. to create a
        disk from the image)
        Structure is documented below.
    labelFingerprint : str, default is Undefined, optional
        The fingerprint used for optimistic locking of this resource. Used
        internally during updates.
    labels : {str:str}, default is Undefined, optional
        Labels to apply to this Image.
        Note: This field is non-authoritative, and will only manage the labels present in your configuration.
        Please refer to the field effective_labels for all of the labels present on the resource.
    licenses : [str], default is Undefined, optional
        Any applicable license URI.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs.
        If it is not provided, the provider project is used.
    rawDisk : [ComputeGcpUpboundIoV1beta1ImageStatusAtProviderRawDiskItems0], default is Undefined, optional
        The parameters of the raw disk image.
        Structure is documented below.
    selfLink : str, default is Undefined, optional
        The URI of the created resource.
    sourceDisk : str, default is Undefined, optional
        The source disk to create this image based on.
        You must provide either this property or the
        rawDisk.source property but not both to create an image.
    sourceImage : str, default is Undefined, optional
        URL of the source image used to create this image. In order to create an image, you must provide the full or partial
        URL of one of the following:
    sourceSnapshot : str, default is Undefined, optional
        URL of the source snapshot used to create this image.
        In order to create an image, you must provide the full or partial URL of one of the following:
    storageLocations : [str], default is Undefined, optional
        Cloud Storage bucket storage location of the image
        (regional or multi-regional).
        Reference link: https://cloud.google.com/compute/docs/reference/rest/v1/images
    terraformLabels : {str:str}, default is Undefined, optional
        The combination of labels configured directly on the resource
        and default labels configured on the provider.
    """


    archiveSizeBytes?: float

    creationTimestamp?: str

    description?: str

    diskSizeGb?: float

    effectiveLabels?: {str:str}

    family?: str

    guestOsFeatures?: [ComputeGcpUpboundIoV1beta1ImageStatusAtProviderGuestOsFeaturesItems0]

    id?: str

    imageEncryptionKey?: [ComputeGcpUpboundIoV1beta1ImageStatusAtProviderImageEncryptionKeyItems0]

    labelFingerprint?: str

    labels?: {str:str}

    licenses?: [str]

    project?: str

    rawDisk?: [ComputeGcpUpboundIoV1beta1ImageStatusAtProviderRawDiskItems0]

    selfLink?: str

    sourceDisk?: str

    sourceImage?: str

    sourceSnapshot?: str

    storageLocations?: [str]

    terraformLabels?: {str:str}


schema ComputeGcpUpboundIoV1beta1ImageStatusAtProviderGuestOsFeaturesItems0:
    r"""
    compute gcp upbound io v1beta1 image status at provider guest os features items0

    Attributes
    ----------
    $type : str, default is Undefined, optional
        The type of supported feature. Read Enabling guest operating system features to see a list of available options.
        Possible values are: MULTI_IP_SUBNET, SECURE_BOOT, SEV_CAPABLE, UEFI_COMPATIBLE, VIRTIO_SCSI_MULTIQUEUE, WINDOWS, GVNIC, SEV_LIVE_MIGRATABLE, SEV_SNP_CAPABLE, SUSPEND_RESUME_COMPATIBLE, TDX_CAPABLE, SEV_LIVE_MIGRATABLE_V2.
    """


    $type?: str


schema ComputeGcpUpboundIoV1beta1ImageStatusAtProviderImageEncryptionKeyItems0:
    r"""
    compute gcp upbound io v1beta1 image status at provider image encryption key items0

    Attributes
    ----------
    kmsKeySelfLink : str, default is Undefined, optional
        The self link of the encryption key that is stored in Google Cloud
        KMS.
    kmsKeyServiceAccount : str, default is Undefined, optional
        The service account being used for the encryption request for the
        given KMS key. If absent, the Compute Engine default service
        account is used.
    """


    kmsKeySelfLink?: str

    kmsKeyServiceAccount?: str


schema ComputeGcpUpboundIoV1beta1ImageStatusAtProviderRawDiskItems0:
    r"""
    compute gcp upbound io v1beta1 image status at provider raw disk items0

    Attributes
    ----------
    containerType : str, default is Undefined, optional
        The format used to encode and transmit the block device, which
        should be TAR. This is just a container and transmission format
        and not a runtime format. Provided by the client when the disk
        image is created.
        Default value is TAR.
        Possible values are: TAR.
    sha1 : str, default is Undefined, optional
        An optional SHA1 checksum of the disk image before unpackaging.
        This is provided by the client when the disk image is created.
    source : str, default is Undefined, optional
        The full Google Cloud Storage URL where disk storage is stored
        You must provide either this property or the sourceDisk property
        but not both.
    """


    containerType?: str

    sha1?: str

    source?: str


schema ComputeGcpUpboundIoV1beta1ImageStatusConditionsItems0:
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


