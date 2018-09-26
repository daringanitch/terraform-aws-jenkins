variable "region" {
  type    = "string"
  default = "Your AWS Region"
}

variable "namespace" {
  type    = "string"
  default = "jenkins"
}

variable "name" {
  type    = "string"
  default = "app"
}

variable "public_subnets" {
  type    = "list"
  default = ["subnet-XXXXXXXX", "subnet-XXXXXXXXXXX", "subnet-XXXXXXXXXX"]
}

variable "private_subnets" {
  type    = "list"
  default = ["subnet-XXXXXXXXXXX", "subnet-XXXXXXXXXXX", "subnet-XXXXXXXXXXXX"]
}

variable "description" {
  type        = "string"
  default     = "Jenkins server as Docker container running on Elastic Benastalk"
  description = "Will be used as Elastic Beanstalk application description"
}

variable "solution_stack_name" {
  type    = "string"
  default = "64bit Amazon Linux 2017.09 v2.8.4 running Docker 17.09.1-ce"
}

variable "vpc_id" {
  type    = "string"
  default = "Your AWS VPC ID"
}

variable "zone_id" {
  type    = "string"
  default = "Your Route 53 DNS Zone ID"
}

variable "healthcheck_url" {
  type    = "string"
  default = "/login"
}

variable "loadbalancer_type" {
  type        = "string"
  default     = "application"
  description = "Load Balancer type, e.g. 'application' or 'classic'"
}

variable "env_default_key" {
  type        = "string"
  default     = "DEFAULT_ENV_%d"
  description = "Default ENV variable key for Elastic Beanstalk `aws:elasticbeanstalk:application:environment` setting"
}

variable "use_efs_ip_address" {
  default = "false"
}

variable "env_default_value" {
  type        = "string"
  default     = "UNSET"
  description = "Default ENV variable value for Elastic Beanstalk `aws:elasticbeanstalk:application:environment` setting"
}

variable "noncurrent_version_expiration_days" {
  type        = "string"
  default     = "35"
  description = "Backup S3 bucket noncurrent version expiration days"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
}

# CI/CD - CodePipeline/CodeBuild
variable "github_oauth_token" {
  type    = "string"
  default = "Your github token"
}

variable "github_organization" {
  type    = "string"
  default = "your github repo"
}

variable "github_repo_name" {
  type    = "string"
  default = "jenkins"
}

variable "github_branch" {
  type    = "string"
  default = "master"
}

# http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html#build-env-ref-available
variable "build_image" {
  type    = "string"
  default = "aws/codebuild/docker:1.12.1"
}

# http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html#build-env-ref-compute-types
variable "build_compute_type" {
  type    = "string"
  default = "BUILD_GENERAL1_SMALL"
}

variable "aws_account_id" {
  type        = "string"
  description = "AWS Account ID. Used as CodeBuild ENV variable when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html"
  default     = "your aws account id"
}

variable "image_repo_name" {
  type        = "string"
  description = "Docker image_repo_name"
  default     = "jenkins"
}

variable "stage" {
  type    = "string"
  default = "prod"
}

variable "image_tag" {
  type        = "string"
  description = "Docker image tag in the ECR repository, e.g. 'latest'. Used as CodeBuild ENV variable when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html"
  default     = "latest"
}

variable "ssh_public_key_path" {
  description = "Directory to store SSH key pair"
  default     = "secrets"
}
