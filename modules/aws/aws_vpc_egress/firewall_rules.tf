data "aws_region" "current" {}
locals {
  region = data.aws_region.current.name
  # https://docs.cloudera.com/cdp-public-cloud/cloud/requirements-aws/topics/mc-outbound_access_requirements.html
  fw_cdp_ep = [
    # Cloudera CCMv2
    ## US Based Control Plane
    ".v2.us-west-1.ccm.cdp.cloudera.com",
    ## EU Based Control plane
    ".v2.ccm.eu-1.cdp.cloudera.com",
    ## AP Based control plane
    ".v2.ccm.ap-1.cdp.cloudera.com",

    # Cloudera Databus
    ## US Based Control Plane
    "dbusapi.us-west-1.sigma.altus.cloudera.com",
    "cloudera-dbus-prod.s3.amazonaws.com",
    ## EU Based Control Plane
    "api.eu-1.cdp.cloudera.com",
    "mow-prod-eu-central-1-sigmadbus-dbus.s3.eu-central-1.amazonaws.com",
    "mow-prod-eu-central-1-sigmadbus-dbus.s3.amazonaws.com",
    ## AP Based Control Plane
    "api.ap-1.cdp.cloudera.com",
    "mow-prod-ap-southeast-2-sigmadbus-dbus.s3.ap-southeast-2.amazonaws.com",
    "mow-prod-ap-southeast-2-sigmadbus-dbus.s3.amazonaws.com",

    # Cloudera Manager parcels
    "archive.cloudera.com",

    # Control Plane API
    ## US Based Control Plane
    "api.us-west-1.cdp.cloudera.com",
    ## EU Based Control Plane
    "api.eu-1.cdp.cloudera.com",
    ## AP Based Control Plane
    "api.ap-1.cdp.cloudera.com",

    # Cloudera Observability Metrics
    ## US-based Control Plane:
    ".api.monitoring.us-west-1.cdp.cloudera.com",
    ## EU-based Control Plane:
    ".api.monitoring.eu-1.cdp.cloudera.com",
    ## AP-based Control Plane:
    ".api.monitoring.ap-1.cdp.cloudera.com",

    # RPMs
    "cloudera-service-delivery-cache.s3.amazonaws.com",
    # Docker Images
    "container.repository.cloudera.com",
    // "docker.repository.cloudera.com",
    "container.repo.cloudera.com",
    ## US Based control plane
    "prod-us-west-2-starport-layer-bucket.s3.us-west-2.amazonaws.com",
    "prod-us-west-2-starport-layer-bucket.s3.amazonaws.com",
    "s3-r-w.us-west-2.amazonaws.com",
    ".execute-api.us-west-2.amazonaws.com",
    ## AWS Source IP based - US-EAST:
    "prod-us-east-1-starport-layer-bucket.s3.us-east-1.amazonaws.com",
    "prod-us-east-1-starport-layer-bucket.s3.amazonaws.com",
    "s3-r-w.us-east-1.amazonaws.com",
    ".execute-api.us-east-1.amazonaws.com",
    ## EU Based control plane
    "prod-eu-west-1-starport-layer-bucket.s3.eu-west-1.amazonaws.com",
    "prod-eu-west-1-starport-layer-bucket.s3.amazonaws.com",
    "s3-r-w.eu-west-1.amazonaws.com",
    ".execute-api.eu-west-1.amazonaws.com",
    
    ## AP Based control plane
    "prod-ap-southeast-1-starport-layer-bucket.s3.ap-southeast-1.amazonaws.com",
    "prod-ap-southeast-1-starport-layer-bucket.s3.amazonaws.com",
    "s3-r-w.ap-southeast-1.amazonaws.com",
    ".execute-api.ap-southeast-1.amazonaws.com",

    ## AWS Source IP based - EU-Central-1:
    "prod-eu-central-1-starport-layer-bucket.s3.eu-central-1.amazonaws.com",
    "prod-eu-central-1-starport-layer-bucket.s3.amazonaws.com",
    "s3-r-w.eu-central-1.amazonaws.com",
    ".execute-api.eu-central-1.amazonaws.com",

    ## Default - Based on Geo Location - ASIAPAC:
    "prod-ap-southeast-1-starport-layer-bucket.s3.ap-southeast-1.amazonaws.com",
    "prod-ap-southeast-1-starport-layer-bucket.s3.amazonaws.com",
    "s3-r-w.ap-southeast-1.amazonaws.com",
    ".execute-api.ap-southeast-1.amazonaws.com",

    # global endpoint
    "raw.githubusercontent.com",
    "github.com",
    ".s3.amazonaws.com",
    "archive.cloudera.com",
    "auth.docker.io",
    "cloudera-docker-dev.jfrog.io",
    "docker-images-prod.s3.amazonaws.com",
    "gcr.io",
    "k8s.gcr.io",
    "quay-registry.s3.amazonaws.com",
    "quay.io",
    "quayio-production-s3.s3.amazonaws.com",
    "docker.io",
    "production.cloudflare.docker.com",
    "storage.googleapis.com",
    "consoleauth.us-west-1.core.altus.cloudera.com",
    "consoleauth.altus.cloudera.com",
    "pypi.org",
    "download.postgresql.org",
    # regional endpoint
    # US
    ".s3.us-west-1.amazonaws.com",
    ".s3.eu-central-1.amazonaws.com",
    ".s3.ap-southeast-2.amazonaws.com",
  
    ".cdp.cloudera.com",
    ".v2.ccm.cdp.cloudera.com",
    ".v2.us-west-1.ccm.cdp.cloudera.com",
    "dbusapi.us-west-1.altus.cloudera.com",            //new added 05/19/2026
    "dbusapi.us-west-1.sigma.altus.cloudera.com",
    "api.us-west-1.cdp.cloudera.com",
    ".s3.us-west-2.amazonaws.com",
    # EU
    "api.eu-1.cdp.cloudera.com",
    ".s3.eu-west-1.amazonaws.com",
    # AP
    "api.ap-1.cdp.cloudera.com",
    ".s3.ap-southeast-1.amazonaws.com",


    # Public Signing Key Retrieval for Data Engineering DataFlow
    "console.us-west-1.cdp.cloudera.com",
    "console.eu-1.cdp.cloudera.com",
    "console.ap-1.cdp.cloudera.com",

    # AWS STS
    "sts.amazonaws.com",
    ".rds.amazonaws.com",  
    # Public domains
    ".google.com",
    "cloudera.okta.com",
    # aws cli
    "awscli.amazonaws.com",
    # k8s
    "dl.k8s.io",
    "cdn.dl.k8s.io",
    "pkgs.k8s.io",
    "prod-cdn.packages.k8s.io",

    # Flow Definition storage for DF
    # "s3.us-west-2.amazonaws.com",
    "dfx-flow-artifacts.mow-prod.mow-prod.cloudera.com",
    "cldr-mow-prod-eu-central-1-dfx-flow-artifacts.s3.eu-central-1.amazonaws.com",
    "cldr-mow-prod-ap-southeast-2-dfx-flow-artifacts.s3.ap-southeast-2.amazonaws.com",

    # Missing endpoints
    "iamapi.us-west-1.altus.cloudera.com",  # DSE-34294
    "registry-1.docker.io", // added for troubleshooting image
    ".cloudflarestorage.com", // added for troubleshooting image

    # For NIFI Operator
    "get.helm.sh",
    ".docker.com",
    ".github.io",
    ".githubusercontent.com",
    "api.github.com"
  ]

  fw_aws_ep = [
    # https://docs.cloudera.com/cdp-public-cloud/cloud/requirements-aws/topics/mc-outbound_access_requirements.html#pnavId2
    # these are AWS regional service endpoint. Can be converted to VPC enpoints. 
    # these are not required when creating environment and datalake and datahub. They are required for EKS based data services.
    "sts.${local.region}.amazonaws.com", 
    # ".s3.${var.region}.amazonaws.com",                # Not required as gateway endpoint is recommended .
    "api.ecr.${local.region}.amazonaws.com",              # Firewall rule is recommended .
    ".dkr.ecr.${local.region}.amazonaws.com",             # Firewall rule is recommended .
    "ec2.${local.region}.amazonaws.com",                  # Firewall rule is recommended
    "eks.${local.region}.amazonaws.com",                  # Firewall rule is recommended
    # "UNIQUEID.*.eks.amazonaws.com",                   # This is on document for DW, but actually not required.
    "cloudformation.${local.region}.amazonaws.com",       # Cloudformation is seldom used, a firewall rule should be okay.
    "autoscaling.${local.region}.amazonaws.com",          # why autoscaling need a private endpoint?
    "elasticfilesystem.${local.region}.amazonaws.com",    # Firewall rule is recommended
    "elasticloadbalancing.${local.region}.amazonaws.com", # Firewall rule is recommended
    # "rds.${var.region}.amazonaws.com",                # not necessary. Testing result
    # "servicequotas.${var.region}.amazonaws.com",        # Firewall rule is recommended, not required base on testing result.
    # "pricing.${var.region}.amazonaws.com",              # Firewall rule is recommended, not required base on testing result.
  ]
  fw_https_ep = concat(local.fw_cdp_ep, local.fw_aws_ep, var.custom_fw_https_endpoints)
  fw_http_ep = concat(var.custom_fw_http_endpoints , [     
    # Ubuntu update
    "security.ubuntu.com",
    ".ec2.archive.ubuntu.com",
    ".archive.canonical.com" ])
}
