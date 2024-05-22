param (
    [string]$RESOURCE_GROUP,
    [string]$CLUSTER_NAME,
    [string]$NODE_POOL_NAME
)

# Get the VMSS names for the specific node pool
$vmssNames = az vmss list --resource-group $RESOURCE_GROUP --query "[?contains(name, '$NODE_POOL_NAME')].name" -o tsv

# Split the VMSS names into an array
$vmssNamesArray = $vmssNames -split "`n"

# Initialize an array to store identity objects
$identities = @()

# Enable system-assigned managed identity on the specific VMSS and get identity details
foreach ($vmssName in $vmssNamesArray) {
    if ($vmssName) {
        az vmss identity assign --resource-group $RESOURCE_GROUP --name $vmssName
        $vmssIdentity = az vmss show --resource-group $RESOURCE_GROUP --name $vmssName --query "identity" | ConvertFrom-Json
        $identityObject = @{
            "clientId" = $vmssIdentity.systemAssignedIdentity
            "tenantId" = $vmssIdentity.userAssignedIdentities[$vmssIdentity.systemAssignedIdentity].clientId
        }
        $identities += $identityObject
    } else {
        Write-Output "No VMSS found for node pool: $NODE_POOL_NAME"
    }
}

# Convert the identities array to JSON
$identitiesJson = $identities | ConvertTo-Json

# Output the JSON string
Write-Output $identitiesJson
