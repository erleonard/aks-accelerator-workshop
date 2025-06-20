# Github Actions

## Create resource group, and an identity with contributor access that github can federate
az group create -l WestEurope -n az-k8s-btq2-rg

app=($(az ad app create --display-name aks-accelerator-workshop --query "[appId,id]" -o tsv | tr ' ' "\n"))
spId=$(az ad sp create --id ${app[0]} --query id -o tsv )
subId=$(az account show --query id -o tsv)

az role assignment create --role owner --assignee-object-id  $spId --assignee-principal-type ServicePrincipal --scope /subscriptions/$subId/resourceGroups/az-k8s-btq2-rg


## Create a new federated identity credential
az rest --method POST --uri "https://graph.microsoft.com/beta/applications/${app[1]}/federatedIdentityCredentials" --body "{\"name\":\"aks-accelerator-workshop-main-gh\",\"issuer\":\"https://token.actions.githubusercontent.com\",\"subject\":\"repo:erleonard/aks-accelerator-workshop:ref:refs/heads/main\",\"description\":\"Access to branch main\",\"audiences\":[\"api://AzureADTokenExchange\"]}"

## Set Secrets
gh secret set --repo https://github.com/erleonard/aks-accelerator-workshop AZURE_CLIENT_ID -b ${app[0]}
gh secret set --repo https://github.com/erleonard/aks-accelerator-workshop AZURE_TENANT_ID -b $(az account show --query tenantId -o tsv)
gh secret set --repo https://github.com/erleonard/aks-accelerator-workshop AZURE_SUBSCRIPTION_ID -b $subId
gh secret set --repo https://github.com/erleonard/aks-accelerator-workshop USER_OBJECT_ID -b $spId

# Github Actions File Yaml

name: Deploy AKS-Construction

on:
  workflow_dispatch:

jobs:
  reusable_workflow_job:
    uses: Azure/AKS-Construction/.github/workflows/AKSC_Deploy.yml@0.9.6
    with:
      templateVersion: 0.9.6
      rg: az-k8s-btq2-rg
      resourceName: az-k8s-btq2
      templateParams: resourceName=az-k8s-btq2 upgradeChannel=stable agentCountMax=20 enable_aad=true AksDisableLocalAccounts=true enableAzureRBAC=true adminPrincipalId=_USER_OBJECT_ID_ registries_sku=Premium acrPushRolePrincipalId=_USER_OBJECT_ID_ omsagent=true retentionInDays=30 networkPolicy=azure azurepolicy=audit availabilityZones=["1","2","3"] authorizedIPRanges=["108.168.124.134/32"] keyVaultAksCSI=true keyVaultCreate=true keyVaultOfficerRolePrincipalId=_USER_OBJECT_ID_ fluxGitOpsAddon=true acrUntaggedRetentionPolicyEnabled=true aksOutboundTrafficType=managedNATGateway oidcIssuer=true workloadIdentity=true
      postScriptParams: "denydefaultNetworkPolicy=true,ingress=traefik"
    secrets:
      AZURE_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
      AZURE_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
      AZURE_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
      USER_OBJECT_ID: ${{ secrets.USER_OBJECT_ID }}

# Cleanuo

rmId=($(az ad app list --display-name aks-accelerator-workshop --query '[[0].appId,[0].id]' -o tsv))
az rest -m DELETE  -u "https://graph.microsoft.com/beta/applications/${rmId[1]}/federatedIdentityCredentials/$(az rest -m GET -u https://graph.microsoft.com/beta/applications/${rmId[1]}/federatedIdentityCredentials --query value[0].id -o tsv)"
az ad sp delete --id $(az ad sp show --id ${rmId[0]} --query id -o tsv)
