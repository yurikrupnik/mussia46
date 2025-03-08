[package]
name = "gcp"
version = "0.0.1"

[dependencies]
models = { path = "./model" }
my_package = { oci = "oci://docker.io/yurikrupnik/exist_kcl_package", tag = "0.0.1", version = "0.0.1" }
