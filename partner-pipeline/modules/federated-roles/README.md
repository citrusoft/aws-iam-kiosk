# aws-iam-kiosk/modules/federated-roles

+ Pre-requisites: +
* bash, python3, aws cli2 installed
* aws credentials and valid STS token

This module encapsulates the creation of two roles per partner-role specification.
1. *Partner Role* with attached inline and/or managed policies trusting the saml-role of the master account.
2. *SAML Role* with inline policy allowing Partner Role assumption trusting the PingFed SAML auth provider.
It is founded on Hashicorp's AWS Provider.  
## Usage
module "aws_iam_role" {
  source = "./modules/federated-roles"
}

## Input
See variables.tf

## Output

See output.tf
