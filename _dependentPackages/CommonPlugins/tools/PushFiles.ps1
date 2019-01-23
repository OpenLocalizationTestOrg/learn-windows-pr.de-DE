param (
    [parameter(mandatory=$true)]
    [hashtable]$ParameterDictionary
)

$errorActionPreference = 'Stop'
$currentDir = $($MyInvocation.MyCommand.Definition) | Split-Path
. (Join-Path $currentDir "PluginsCommon.ps1")

$repositoryRoot = $ParameterDictionary.environment.repositoryRoot
$tempFolderBase = Join-Path $repositoryRoot "PushFiles.temp"
$targetRepoFolderBase = Join-Path $repositoryRoot "PushFiles.targetRepo"

pushd $repositoryRoot
$repoGitUrl = & git config --get remote.origin.url
if ($repoGitUrl.EndsWith(".git"))
{
    $repoGitUrl = $repoGitUrl.Substring(0, $repoGitUrl.Length - 4)
}
$branch = 'master'
& git branch | foreach {
    if ($_ -match "^\* (.*)") {
        $branch = $matches[1]
    }
}
popd

$jobs = $ParameterDictionary.docset.docsetInfo.PushFiles
if (!$jobs)
{
	$jobs = $ParameterDictionary.environment.publishConfigContent.PushFiles
}
if ($jobs -isnot [system.array])
{
    $jobs = @($jobs)
}
$id = 1
foreach($job in $jobs)
{
    $branchFilter = $job.branchFilter
    if ($branchFilter -isnot [system.array])
    {
        $branchFilter = @($branchFilter)
    }
    if ($branchFilter -notcontains $branch)
    {
        continue
    }
    $tempFolder = $tempFolderBase + $id
    $targetRepoFolder = $targetRepoFolderBase + $id
    $id += 1
    
    $targetRepoWithToken = $job.targetRepo
    $_op_accessToken = $ParameterDictionary.environment._op_accessToken
    if ($_op_accessToken)
    {
        $targetRepoWithToken = $targetRepoWithToken -replace "//github.com","//$_op_accessToken`:x-oauth-basic@github.com"
    }
	$checkBr = & git ls-remote --heads $targetRepoWithToken $branch
    if (-Not [string]::IsNullOrEmpty($checkBr))
    {
		Write-Host "target branch exists, cloning with --branch $branch"
        Invoke-Git clone $targetRepoWithToken $targetRepoFolder --depth 1 --shallow-submodules --branch $branch
    }
    else
    {
		Write-Host "target branch does not exist, cloning..."
        Invoke-Git clone $targetRepoWithToken $targetRepoFolder --depth 1 --shallow-submodules --no-single-branch
        Push-Location $targetRepoFolder
		Write-Host "creating branch $branch..."
        Invoke-Git checkout -b $branch
        Pop-Location
    }
    Push-Location $targetRepoFolder
	& git config user.name "OpenPublishBuild"
    & git config user.email "vscopbld@microsoft.com"
    Pop-Location
    $pattern = $job.files
    $src = Join-Path $repositoryRoot $job.src
    $dest = Join-Path $targetRepoFolder $job.dest
	$allArgs = @("$src")
	if ($job.dest.ToLower().EndsWith(".zip"))
	{
		$allArgs += "$tempFolder";
	}
	else
	{
		$allArgs += "$dest";
	}
	$allArgs += $pattern.split(" ");
	$allArgs += @("/s", "/NFL", "/NDL", "/NP", "/XD", ".git");
	if ($job.purge)
    {
        $allArgs += "/purge";
    }
	& robocopy $allArgs
    if ($LASTEXITCODE -le 0)
    {
		Write-Host "Robocopy error code $LASTEXITCODE, skipping this push job..."
        continue
    }
    if ($job.dest.ToLower().EndsWith(".zip"))
    {      
		If (Test-Path $dest){
			Write-Host "target zip exists, deleting..."
	        Remove-Item $dest
        }
		Write-Host "compressing to $dest..."
        Add-Type -Assembly "System.IO.Compression.FileSystem"
        [System.IO.Compression.ZipFile]::CreateFromDirectory("$tempFolder", "$dest", [System.IO.Compression.CompressionLevel]::Fastest, $false)
    }
    $commitMsg = $job.commitMessage
    if ([string]::IsNullOrEmpty($commitMsg))
    {
        $commitMsg = "CI Update from " + $repoGitUrl
    }
    Push-Location $targetRepoFolder
    Invoke-Git add --all
    Invoke-Git commit -m """$commitMsg"""
    Invoke-Git push --set-upstream origin $branch
    Pop-Location
}
exit 0