# Command Line

## Create Resource Group
az group create -l WestEurope -n az-k8s-btq2-rg

## Deploy template with in-line parameters
az deployment group create -g az-k8s-btq2-rg  --template-uri https://github.com/Azure/AKS-Construction/releases/download/0.9.6/main.json --parameters \
	resourceName=az-k8s-btq2 \
	upgradeChannel=stable \
	agentCountMax=20 \
	enable_aad=true \
	AksDisableLocalAccounts=true \
	enableAzureRBAC=true \
	adminPrincipalId=$(az ad signed-in-user show --query id --out tsv) \
	registries_sku=Premium \
	acrPushRolePrincipalId=$(az ad signed-in-user show --query id --out tsv) \
	omsagent=true \
	retentionInDays=30 \
	networkPolicy=azure \
	azurepolicy=audit \
	availabilityZones="[\"1\",\"2\",\"3\"]" \
	authorizedIPRanges="[\"108.168.124.134/32\"]" \
	keyVaultAksCSI=true \
	keyVaultCreate=true \
	keyVaultOfficerRolePrincipalId=$(az ad signed-in-user show --query id --out tsv) \
	fluxGitOpsAddon=true \
	acrUntaggedRetentionPolicyEnabled=true \
	aksOutboundTrafficType=managedNATGateway \
	oidcIssuer=true \
	workloadIdentity=true

## Get credentials for your new AKS cluster & login (interactive)
az aks get-credentials -g az-k8s-btq2-rg -n aks-az-k8s-btq2
kubectl get nodes

## Deploy charts into cluster
curl -sL https://github.com/Azure/AKS-Construction/releases/download/0.9.6/postdeploy.sh  | bash -s -- -r https://github.com/Azure/AKS-Construction/releases/download/0.9.6 \
	-p denydefaultNetworkPolicy=true \
	-p ingress=traefik