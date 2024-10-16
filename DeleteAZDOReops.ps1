#https://dev.to/omiossec/getting-started-with-azure-devops-api-with-powershell-59nn


$repoFolder = "c:\repos\merlionOptimized"
$path = Split-Path -parent $MyInvocation.MyCommand.Definition
$newpath = $path + "\reposFull.csv"
$csv = @()
$csv = Import-Csv -Path $newpath
$encodedPat = ""
$OrganizationName = "Brett-OJ"
$ProjectName = "Merlion-Optimized"
$action = 2
$AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($encodedPat)")) }
$projUri = "https://dev.azure.com/$($OrganizationName)/$($ProjectName)/"
$uriRepos = $projUri + "/_apis/git/repositories?api-version=6.1-preview.1"

foreach ($item in $csv) {

$reponame = $item.repoName
$uriGetRepo = $projUri + "/_apis/git/repositories/$($reponame)?api-version=6.1-preview.1"

#this code to delete the repos
$repo = Invoke-WebRequest -method GET -Headers $AzureDevOpsAuthenicationHeader -Uri $uriGetRepo -ContentType "application/json" -UseBasicParsing | ConvertFrom-Json
$repoID = $repo.id
$uriDeleteRepo = $projUri + "/_apis/git/repositories/$($repoID)?api-version=6.1-preview.1"
Invoke-WebRequest -method DELETE -Headers $AzureDevOpsAuthenicationHeader -Uri $uriDeleteRepo -ContentType "application/json" -UseBasicParsing 

    }

