output "runtimes" {
    value = "${
        merge(
            map("dotnetcore","dotnetcore2.1"),
            map("nodejs","nodejs8.10"))}"
}


output "deployment_package_s3_bucket_name" {
    value = "gc-deployments"
}