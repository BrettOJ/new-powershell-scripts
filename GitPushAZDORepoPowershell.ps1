#https://dev.to/omiossec/getting-started-with-azure-devops-api-with-powershell-59nn


$repoFolder = "c:\repos\merlionOptimized"
$path = Split-Path -Parent $MyInvocation.MyCommand.Definition
$newpath = Join-Path -Path $path -ChildPath "merlion.csv"

if (Test-Path -Path $newpath) {
	$csv = Import-Csv -Path $newpath
} else {
	Write-Error "CSV file not found at path: $newpath"
	exit
}
$encodedPat = ""
$OrganizationName = "ggavanade"
$ProjectName = "Merlion"
$AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($encodedPat)")) }
$projUri = "https://dev.azure.com/$($OrganizationName)/$($ProjectName)/"


foreach ($item in $csv) {

$reponame = $item.repoName
$uriGetRepo = $projUri + "/_apis/git/repositories/$($reponame)?api-version=6.1-preview.1"

$repo = Invoke-WebRequest -method GET -Headers $AzureDevOpsAuthenicationHeader -Uri $uriGetRepo -ContentType "application/json" -UseBasicParsing | ConvertFrom-Json
$repoName = $repo.name
$GitUrl =  "https://ggavanade@dev.azure.com/ggavanade/Merlion/_git/$($repoName)"

#need to change folder first
$workingDir =  "C:\repos\merlionOptimized\$($reponame)"

#cp "C:\repos\IRAS-tfmodules\$($reponame)\*.*" "C:\repos\merlionOptimized\$($reponame)"

cd $workingDir

git add --all

git commit -m "initial commit"

git push $GitUrl

}

