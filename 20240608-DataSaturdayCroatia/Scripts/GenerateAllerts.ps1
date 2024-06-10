# When using MMA, you could use this one... but when you Arc enabled your server, 
# this will not work anymore, but you can try
get-command -Module sqladvancedthreadprotectionshell

# But there is a work around :)
# Change to the folder where the new stuff is.
# Please find this location on your testmachine first... There is a version number...
set-location C:\Packages\Plugins\Microsoft.Azure.AzureDefenderForSQL.AdvancedThreatProtection.Windows\2.0.2703.209\bin

# You must create a SQL Login with a password before. Also change your Security to mixed authentication
# add your account below
$User = ""
#add your password below
$saPasswordEncrypted =  ""  

# First test is a SQL Injection
Write-Host "Executing SQL injection"
.\Microsoft.SQL.ADS.DefenderForSQL.exe simulate --Attack SqlInjection --UserName $user --Password $saPasswordEncrypted # High risk


# Run brute  force test to generate alerts
Write-Host "Executing brute force attack"
.\Microsoft.SQL.ADS.DefenderForSQL.exe simulate --Attack BruteForce # High risk

# Run shell obfuscation test
Write-Host "Executing SQL shell obfuscation"
.\Microsoft.SQL.ADS.DefenderForSQL.exe simulate --Attack ShellObfuscation --UserName $User --Password $saPasswordEncrypted # Medium risk

# Login with a suspicious app...
Write-host "Executing a login from a suspicious app"
.\Microsoft.SQL.ADS.DefenderForSQL.exe simulate --Attack LoginSuspiciousApp --UserName $User --Password $saPasswordEncrypted 

# Using a anomaly principal
Write-host "Login on a unusual way"
.\Microsoft.SQL.ADS.DefenderForSQL.exe simulate --Attack PrincipalAnomaly --UserName $User --Password $saPasswordEncrypted 

# Use an external Source for shelling...
Write-Host "Simalate a login from an unusual external Source "
.\Microsoft.SQL.ADS.DefenderForSQL.exe simulate --Attack ShellExternalSourceAnomaly --UserName $User --Password $saPasswordEncrypted 

# Retrieve some data from an unexisting database... so it wil generate a few thingies.
Write-host "Simulate downloading data from a (generated) test database"
 .\Microsoft.SQL.ADS.DefenderForSQL.exe simulate --Attack DataExfiltration --UserName $User --Password $saPasswordEncrypted 