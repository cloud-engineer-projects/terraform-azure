param (
  [string]$RESOURCE_GROUP,
  [string]$CLUSTER_NAME,
  [string]$NODE_POOL_NAME
)

# Debugging: print the variables
Write-Host "RESOURCE_GROUP: $RESOURCE_GROUP"
Write-Host "CLUSTER_NAME: $CLUSTER_NAME"
Write-Host "NODE_POOL_NAME: $NODE_POOL_NAME"

# Get the VMSS name for the specific node pool
$vmssNames = az vmss list --resource-group MC_app-grp_app-aks_southindia --query "[?contains(name, 'apppool')].name" -o tsv
Write-Output "$vmssNames"
# Split the VMSS names into an array
$vmssNamesArray = $vmssNames -split "`n"

# Enable system-assigned managed identity on the specific VMSS
foreach ($vmssName in $vmssNamesArray) {
  if ($vmssName) {
    Write-Output "Enabling system-assigned managed identity on VMSS: $vmssName"
    az vmss identity assign --resource-group MC_app-grp_app-aks_southindia --name $vmssName
  } else {
    Write-Output "No VMSS found for node pool: $NODE_POOL_NAME"
  }
}
