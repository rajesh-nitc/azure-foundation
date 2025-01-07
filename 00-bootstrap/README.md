# 00-bootstrap

- Manually create ```mg-root``` under Root Management Group
- Manually create ```mg-bootstrap``` under ```mg-root```
- Manually move default pay as you go subscription ```sub-bootstrap-tfstate``` under ```mg-bootstrap```
- Comment out ```backend.tf```
- ```az login```
- terraform init/plan/apply
- Manually grant admin consent for ```terraform_service_principal```
- Uncomment and update ```backend.tf```
- ```terraform init```
- ```az logout```
- Set env vars to use ```terraform_service_principal```:
```
export ARM_CLIENT_ID=""
export ARM_CLIENT_SECRET=""
export ARM_SUBSCRIPTION_ID=""
export ARM_TENANT_ID=""
```
