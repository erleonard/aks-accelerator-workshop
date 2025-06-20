#variables.tf

variable resourceGroupName {
  type=string
  default="az-k8s-btq2-rg"
}
variable location {
  type=string
  default="WestEurope"
} 
variable resourceName {
  type=string
  default="az-k8s-btq2"
} 
variable upgradeChannel {
  type=string
  default="stable"
} 
variable agentCountMax {
  type=number
  default=20
} 
variable enable_aad {
  type=bool
  default=true
} 
variable AksDisableLocalAccounts {
  type=bool
  default=true
} 
variable enableAzureRBAC {
  type=bool
  default=true
} 
variable registries_sku {
  type=string
  default="Premium"
} 
variable omsagent {
  type=bool
  default=true
} 
variable retentionInDays {
  type=number
  default=30
} 
variable networkPolicy {
  type=string
  default="azure"
} 
variable azurepolicy {
  type=string
  default="audit"
} 
variable availabilityZones {
  default=["1","2","3"]
} 
variable authorizedIPRanges {
  default=["108.168.124.134/32"]
} 
variable keyVaultAksCSI {
  type=bool
  default=true
} 
variable keyVaultCreate {
  type=bool
  default=true
} 
variable fluxGitOpsAddon {
  type=bool
  default=true
} 
variable acrUntaggedRetentionPolicyEnabled {
  type=bool
  default=true
} 
variable aksOutboundTrafficType {
  type=string
  default="managedNATGateway"
} 
variable oidcIssuer {
  type=bool
  default=true
} 
variable workloadIdentity {
  type=bool
  default=true
}