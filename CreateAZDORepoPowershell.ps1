#https://dev.to/omiossec/getting-started-with-azure-devops-api-with-powershell-59nn


$repoFolder = "c:\repos\merlionOptimized"
$path = Split-Path -parent $MyInvocation.MyCommand.Definition
$newpath = $path + "\merlion.csv"
$csv = @()
$csv = Import-Csv -Path $newpath
$encodedPat = ""
$OrganizationName = "ggavanade"
$ProjectName = "Merlion"
$action = 2
$AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($encodedPat)")) }
$projUri = "https://dev.azure.com/$($OrganizationName)/$($ProjectName)/"
$uriRepos = $projUri + "/_apis/git/repositories?api-version=6.1-preview.1"

foreach ($item in $csv) {

$reponame = $item.repoName
$uriGetRepo = $projUri + "/_apis/git/repositories/$($reponame)?api-version=6.1-preview.1"

#This code to create repos 
$repoBody = @{
     "name" = $reponame
  }  | ConvertTo-Json


#Invoke-WebRequest -method Post -Headers $AzureDevOpsAuthenicationHeader -body $repoBody -Uri $uriRepos -ContentType "application/json" -UseBasicParsing

#This code to git clone the repo 

$repo = Invoke-WebRequest -method GET -Headers $AzureDevOpsAuthenicationHeader -Uri $uriGetRepo -ContentType "application/json" -UseBasicParsing | ConvertFrom-Json
$repoName = $repo.name
$GitUrl =  "https://ggavanade@dev.azure.com/ggavanade/Merlion/_git/$($repoName)"

git clone $GitUrl

}

