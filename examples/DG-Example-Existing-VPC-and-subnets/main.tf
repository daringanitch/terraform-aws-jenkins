

provider "aws" {
  region = "us-west-2"
  profile = "default"
}


data "aws_availability_zones" "available" {}

module "jenkins" {
  source      = "git::https://github.com/daringanitch/terraform-aws-jenkins.git?ref=master"
  namespace   = "${var.namespace}"
  name        = "${var.name}"
  stage       = "${var.stage}"
  description = "${var.description}"

  aws_account_id               = "${var.aws_account_id}"
  aws_region                   = "${var.region}"
  availability_zones           = ["${data.aws_availability_zones.available.names}"]
  solution_stack_name          = "${var.solution_stack_name}"
  vpc_id                       = "${var.vpc_id}"
  zone_id                      = "${var.zone_id}"
  delimiter                    = "${var.delimiter}"
  public_subnets               = ["${var.public_subnets}"]
  private_subnets              = ["${var.private_subnets}"]
  healthcheck_url              = "${var.healthcheck_url}"
  loadbalancer_type            = "${var.loadbalancer_type}"
  ssh_key_pair                 = "spe_dev_jenkins_key"
  loadbalancer_certificate_arn = "your aws certificate manager certificate arn"

  github_oauth_token  = "${var.github_oauth_token}"
  github_organization = "${var.github_organization}"
  github_repo_name    = "${var.github_repo_name}"
  github_branch       = "${var.github_branch}"

  build_image        = "${var.build_image}"
  build_compute_type = "${var.build_compute_type}"
  image_tag          = "${var.image_tag}"
  stage              = "${var.stage}"

  datapipeline_config = {
    instance_type = "t2.small"
    email         = "your email"
    period        = "6 hours"
    timeout       = "60 Minutes"
  }

  env_vars = {
    # Jenkins master instance config
    JENKINS_AUTHORIZATION_STRATEGY = "Matrix"
    JENKINS_USER                   = "admin"
    JENKINS_PASS                   = "Create a jenkins password , put here"
    JENKINS_NUM_EXECUTORS          = "4"
    IMAGE_REPO_NAME                = "jenkins"
    STAGE                          = "prod"

    # EC2 plugin config (to launch slaves on demand)
    JENKINS_SLAVE_CLOUD_NAME               = "${var.namespace}.${var.stage}.${var.name}.slave"
    JENKINS_SLAVE_REGION                   = "${var.region}"
    JENKINS_SLAVE_INSTANCE_CAP             = "50"
    JENKINS_SLAVE_AMI_ID                   = "${data.aws_ami.slave_ami.id}"
    JENKINS_SLAVE_SUBNET_ID                = "Aws subnet where slaves will build"
    JENKINS_SLAVE_INSTANCE_PROFILE_ARN     = ""
    JENKINS_SLAVE_INSTANCE_TYPE            = "t2.small"
    JENKINS_SLAVE_NUM_EXECUTORS            = "4"
    JENKINS_SLAVE_INIT_SCRIPT              = ""
    JENKINS_SLAVE_USER_DATA                = ""
    JENKINS_SLAVE_REMOTE_ADMIN             = "root"
    JENKINS_SLAVE_IDLE_TERMINATION_MINUTES = "20"
    JENKINS_SLAVE_LAUNCH_TIMEOUT_SECONDS   = "300"
    JENKINS_SLAVE_STOP_ON_IDLE_TIMEOUT     = "true"
  }
}

# Find AMI with Java installed
# https://www.terraform.io/docs/providers/aws/d/ami.html
# http://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html
# NOTE: AMIs are region specific
data "aws_ami" "slave_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["aws-elasticbeanstalk-amzn*x86_64-java8-hvm*"]
  }
}
