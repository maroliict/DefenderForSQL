# Multi server Arc Enabling
#
# 1) a file with the managed identities and secret is created. Content:
#    $ServicePrincipalId=3bfc889f-1014-41b4-b843-BlaBlaBlaBallal
#    $ServicePrincipalClientSecret=xXu8Q~PO9H7oq-YoUtHoughTthatIGaveThis
#
# 2) Run the below file on multiple servers..

try {
    $ServicePrincipalId="<Service Principal ID Here>";
    $ServicePrincipalClientSecret="<ENTER SECRET HERE>";

    $env:SUBSCRIPTION_ID = "<Your Subscription ID>";
    $env:RESOURCE_GROUP = "<Name of the Resource Group>";
    $env:TENANT_ID = "<Your Tenant ID>";
    $env:LOCATION = "<Name of the region>";
    $env:AUTH_TYPE = "principal";  # This line differs from Single Server and enables the service principal stuff.
    $env:CORRELATION_ID = "<Correlation ID (Dont know where this gets from :) )>";
    $env:CLOUD = "AzureCloud";
    

    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 3072;
    Invoke-WebRequest -UseBasicParsing -Uri "https://aka.ms/azcmagent-windows" -TimeoutSec 30 -OutFile "$env:TEMP\install_windows_azcmagent.ps1";
    & "$env:TEMP\install_windows_azcmagent.ps1";
    if ($LASTEXITCODE -ne 0) { exit 1; }
    # below there is another change.. again the service principal stuff...
    & "$env:ProgramW6432\AzureConnectedMachineAgent\azcmagent.exe" connect --service-principal-id "$ServicePrincipalId" --service-principal-secret "$ServicePrincipalClientSecret" --resource-group "$env:RESOURCE_GROUP" --tenant-id "$env:TENANT_ID" --location "$env:LOCATION" --subscription-id "$env:SUBSCRIPTION_ID" --cloud "$env:CLOUD" --correlation-id "$env:CORRELATION_ID";
}
catch {
    $logBody = @{subscriptionId="$env:SUBSCRIPTION_ID";resourceGroup="$env:RESOURCE_GROUP";tenantId="$env:TENANT_ID";location="$env:LOCATION";correlationId="$env:CORRELATION_ID";authType="$env:AUTH_TYPE";operation="onboarding";messageType=$_.FullyQualifiedErrorId;message="$_";};
    Invoke-WebRequest -UseBasicParsing -Uri "https://gbl.his.arc.azure.com/log" -Method "PUT" -Body ($logBody | ConvertTo-Json) | out-null;
    Write-Host  -ForegroundColor red $_.Exception;
}
