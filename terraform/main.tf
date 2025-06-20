#main.tf

data "http" "aksc_release" {
  url = "https://github.com/Azure/AKS-Construction/releases/download/0.9.6/main.json"
  request_headers = {
    Accept = "application/json"
    User-Agent = "request module"
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name = var.resourceGroupName
  location = var.location
}

resource "azurerm_resource_group_template_deployment" "aksc_deploy" {
  name = "AKS-C"
  resource_group_name = azurerm_resource_group.rg.name
  deployment_mode = "Incremental"
  template_content = data.http.aksc_release.body
  parameters_content = jsonencode({
    resourceName = {value=var.resourceName}
    upgradeChannel = {value=var.upgradeChannel}
    agentCountMax = {value=var.agentCountMax}
    enable_aad = {value=var.enable_aad}
    AksDisableLocalAccounts = {value=var.AksDisableLocalAccounts}
    enableAzureRBAC = {value=var.enableAzureRBAC}
    adminPrincipalId = {value=data.azurerm_client_config.current.client_id}
    registries_sku = {value=var.registries_sku}
    acrPushRolePrincipalId = {value=data.azurerm_client_config.current.client_id}
    omsagent = {value=var.omsagent}
    retentionInDays = {value=var.retentionInDays}
    networkPolicy = {value=var.networkPolicy}
    azurepolicy = {value=var.azurepolicy}
    availabilityZones = {value=var.availabilityZones}
    authorizedIPRanges = {value=var.authorizedIPRanges}
    keyVaultAksCSI = {value=var.keyVaultAksCSI}
    keyVaultCreate = {value=var.keyVaultCreate}
    keyVaultOfficerRolePrincipalId = {value=data.azurerm_client_config.current.client_id}
    fluxGitOpsAddon = {value=var.fluxGitOpsAddon}
    acrUntaggedRetentionPolicyEnabled = {value=var.acrUntaggedRetentionPolicyEnabled}
    aksOutboundTrafficType = {value=var.aksOutboundTrafficType}
    oidcIssuer = {value=var.oidcIssuer}
    workloadIdentity = {value=var.workloadIdentity}
  })
}

nimda@erleonardoutlook.onmicrosoft.com