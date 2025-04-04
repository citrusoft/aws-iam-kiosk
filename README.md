# aws-iam-kiosk

## Folders
* cli-solution - implements stacksets with local files and terraform open-source
* orchestration - implements the creation and configuration of TFC workspaces, 1 per account.
* resources - YAML specifications by AWS Account number.
* partner-pipeline - implements the IAM pipeline for partner accounts.
* saml-pipeline - implements the SAML shared-service account for federated-roles.
## Deploy IAM Objects (federated-roles & service-account, aka users)
This automation consumes the YAML specifications in the resources directory to create or correct drift of  federated-roles & service-account.


### Pre-reqs
* aws cli
* aws credentials
* terraform cli
* terraform cloud account & organizaton

### Steps
1. login to terraform from the command-line. This is optional, if you have a valid token configured.
```
terraform login
```
If you are beginning with a "blank slate" then you'll need to create a TFC workspace for your infrastructure deployment.
That infrastructure-workspace  uses the directory names in resources folder to configure the "pipelines" aka workspaces, 1 per account.
Projects are not mandatory but I prefer to isolate this solution into its own TFC project.
```
export TFE_TOKEN=
export TFE_ORG=citrusoft
export TFE_PROJECT_NAME=aws-iam-kiosk
cat <<EOF > payload.json
{
  "data": {
    "attributes": {
      "name": "${TFE_PROJECT_NAME}"
    },
    "type": "projects"
  }
}
EOF
curl \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data @payload.json \
  ${TFE_ADDR}/api/v2/organizations/${TFE_ORG}/projects | jq -r .

export TFE_PROJECT_ID=$(curl -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  https://app.terraform.io/api/v2/organizations/${TFE_ORG}/projects | \
  jq -r ".data[] | select (.attributes.name==\"${TFE_PROJECT_NAME}\") | .id")

cat <<EOF > payload.json
{
  "data": {
    "attributes": {
      "name": "${TFE_WORKSPACE_NAME}",
      "auto-apply": true
    },
    "relationships": {
      "project": {
        "data": {
          "type": "projects",
          "id": "${TFE_PROJECT_ID}"
        }
      }
    },
    "type": "workspaces"
  }
}
EOF
curl -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data @payload.json \
  ${TFE_ADDR}/api/v2/organizations/${TFE_ORG}/workspaces | jq -r .
export TFE_WORKSPACE_NAME=orchestration
export WORKSPACE_ID=$(curl -s \
  --header "Authorization: Bearer $TFE_ORG_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  ${TFE_ADDR}/api/v2/organizations/${TFE_ORG}/workspaces | \
  jq -r ".data[] | select (.attributes.name==\"${TFE_WORKSPACE_NAME}\") | .id")
```
2. Set AWS variables...
```
export AWS_PROFILE=
```
Or...
```
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
```
3. Test AWS CLI configuration
```
aws sts get-caller-identity
```
4. Test your terraform credentials and confirm the state of orchestration is what you desire.
```
cd orchestration
terraform state list
```
5. Create an Organization variable-set named, *TFC*, add env var TFE_TOKEN; populate it with your user-token.  Apply this variable set to your workspace, ie orchestration.
6. Create an Organization variable-set named, *Github*, with HCL variable named, oauth_token_id.  Apply it to your project, ie aws-iam-kiosk.
..* If Github integration exists then, see https://app.terraform.io/app/citrusoft/settings/version-control
..* Or, you may have to setup Github integration, see https://developer.hashicorp.com/terraform/tutorials/cloud/github-oauth
7. Create an Organization variable-set named *Tags*, populate it with default values.  Apply it to your project, ie aws-iam-kiosk.
..* Tags/AppID, Compliance, CRIS, DataClassification, Environment, Notify, Owner
* For each file in resources/*/*.tfvars, use the file contents to create an organizational variable set named, "account#-vars", ie 123133550781-vars.
..* set environment variables: AWS_ACCESS_KEY_ID,  AWS_SECRET_ACCESS_KEY
..* set the terraform variables
..* optionally, override tag, env variables per account
7. Set your local terraform variables for aws, git and terraform environments.
..*TFC organization, project
..*github org, repo and branch name
..*aws saml_account_num
The remaining vars do not require changing.
```
cd orchestration
vim terraform.auto.tfvars
```
resource_folder   = "/resources"
resource_path     = "../resources"
organization      = "citrusoft"
saml_account_num  = "SECRET12digits"
github_repo       = "https://github.com/citrusoft/aws-iam-kiosk"
project_name      = "aws-iam-kiosk"
config_auto_apply = "false"
github_org        = "citrusoft"
branch            = "xxdemo"
oauth_token_id    = "SECRETot-"
drift_detection   = "false"

8. Enable Terrraform Cloud to access this Github reposoitpry.

9. Deploy the orchestration.
```
terraform init
terraform apply -auto-approve
```
This will create the workspace "orchestration" within the TFC organization.project that you specified.
That workspace will in-turn trigger the creation of 1 workspace per account.
Most workspaces will invoke the partner-pipeline whereas the SAML account's workspace invokes the saml-pipeline.
