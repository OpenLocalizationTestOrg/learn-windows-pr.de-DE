param (
    [parameter(mandatory = $true)]
    [hashtable]$ParameterDictionary
)

$errorActionPreference = 'Stop'

$currentDir = $($MyInvocation.MyCommand.Definition) | Split-Path
$source = $ParameterDictionary.docset.docsetInfo.build_source_folder
if ($source -eq ".") {
	$docsetRoot = $ParameterDictionary.environment.repositoryRoot
} else {
	$docsetRoot = Join-Path $ParameterDictionary.environment.repositoryRoot $source
}

$restructureExeName = "PowerShellReference.exe"
$restructureExePath = Join-Path $currentDir $restructureExeName
$logFilePath = $ParameterDictionary.environment.logFile
$contributeBranch = $ParameterDictionary.docset.docsetInfo.git_repository_branch_open_to_public_contributors;
if (!$contributeBranch) {
    $contributeBranch = $ParameterDictionary.environment.publishConfigContent.git_repository_branch_open_to_public_contributors;
}

$monikerPath = $ParameterDictionary.docset.docsetInfo.monikerPath
if (!$monikerPath) {
	$monikerPath = $ParameterDictionary.environment.publishConfigContent.monikerPath
}

if (!$monikerPath) {
    Write-Host "monikerPath in openpublish.config.json can't be found.";
    exit 1;
}

function Run {
    param($monikerPath)
	$allArgs = @("--monikerMapPath", "$monikerPath", "--docsetRoot", "$docsetRoot", "--logFile", "$logFilePath");
	if ($contributeBranch) {
		$allArgs += "--contributeBranch";
		$allArgs += "$contributeBranch";
	}

	$args = [System.String]::Join(' ', $allArgs)
	Write-Output "Executing $restructureExePath $args" | timestamp
	& "$restructureExePath" $allArgs
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}

if ($monikerPath -is [System.Array]) {
    foreach ($singlePath in $monikerPath) {
        $singlePath = Join-Path $docsetRoot $singlePath
        Run($singlePath)
    }
}
else {
    $monikerPath = Join-Path $docsetRoot $monikerPath
    Run($monikerPath)
}