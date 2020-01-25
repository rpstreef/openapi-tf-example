
# -----------------------------------------------------------------------------
# Variables: General
# -----------------------------------------------------------------------------

variable "namespace" {
  description = "AWS resource namespace/prefix"
}

variable "region" {
  description = "AWS region"
}

variable "resource_tag_name" {
  description = "Resource tag name for cost tracking"
}

# -----------------------------------------------------------------------------
# Variables: lambda layer required
# -----------------------------------------------------------------------------

variable "name" {
  description = "Name of the lambda layer, prefixed with namespace and resource tag name"
}

variable "zip_name" {
  description = "Zip file name, bundle"
}


variable "description" {
  description = "What kind of dependencies are in this layer"
}

variable "dist_file_path" {
  description = "Distribution file path, where is the ZIP file stored"
}
