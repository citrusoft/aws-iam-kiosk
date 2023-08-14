# aws-iam-kiosk

+ Pre-requisites: +
* bash, python3, aws cli2 installed
* aws credentials and valid STS token.


## Usage
```
terraform init
terraform validate
terraform apply -auto-approve
```

## Output

### yamlint-feedback
Reports the exitcode of yamllint evaluation(s) of the given yaml. Reports either valid or invalid.

### null_resource.validate_policy.findings
This is the json output of AWS' validate-policy API; it's feedback on errors in the json.

### filenames
The filenames discovered which are to be processed.
