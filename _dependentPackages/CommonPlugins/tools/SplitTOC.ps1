param (
    [parameter(mandatory = $true)]
    [hashtable]$ParameterDictionary
)

$errorActionPreference = 'Stop'

$currentDir = $($MyInvocation.MyCommand.Definition) | Split-Path
$repositoryRoot = $ParameterDictionary.environment.repositoryRoot
$splitTocExeName = "SplitToc.exe"
$splitTocExePath = Join-Path $currentDir $splitTocExeName
$docsetPath = Join-Path $repositoryRoot $ParameterDictionary.docset.docsetInfo.build_source_folder
$tocPath = $ParameterDictionary.docset.docsetInfo.SplitTOC
$onDocsetLevel = $true
if (!$tocPath)
{
	$tocPath = $ParameterDictionary.environment.publishConfigContent.SplitTOC
	$onDocsetLevel = $false
}
if (!$tocPath) {
    Write-Host "Can't find SplitTOC config in openpublish.config.json, exiting...";
    exit 1;
}

function SplitToc {
    param($tocPath)
	$tocAbsolutePath = Join-Path $repositoryRoot $tocPath
	if ($onDocsetLevel) {
		$tocAbsolutePathviaDocset = Join-Path $docsetPath $tocPath
		if ((Test-Path $tocAbsolutePathviaDocset))
		{
			$tocAbsolutePath = $tocAbsolutePathviaDocset
		}
	}
    Write-Host "Executing $splitTocExePath $tocAbsolutePath" | timestamp
    & "$splitTocExePath" $tocAbsolutePath
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}

if ($tocPath -is [System.Array]) {
    foreach ($singlePath in $tocPath) {
        SplitToc($singlePath)
    }
}
else {
    SplitToc($tocPath)
}