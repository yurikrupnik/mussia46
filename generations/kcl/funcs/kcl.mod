[package]
name = "funcs"
edition = "v0.11.0"
version = "0.0.1"

[dependencies]
k8s = "1.31.2"
my_package = { oci = "oci://europe-central2-docker.pkg.dev/sdp-demo-388112/container-repo/exist_kcl_package", tag = "0.0.1", version = "0.0.1" }
