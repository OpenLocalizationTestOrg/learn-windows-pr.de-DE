param (
    [parameter(mandatory=$true)]
    [hashtable]$ParameterDictionary
)

$errorActionPreference = 'Stop'

$currentDir = $($MyInvocation.MyCommand.Definition) | Split-Path
$exeFilePath = Join-Path $currentDir "TripleCrownValidation.exe"

$repositoryRoot = $ParameterDictionary.environment.repositoryRoot
$logFilePath = $ParameterDictionary.environment.logFile
$dependencyFilePath = $ParameterDictionary.environment.fullDependentListFilePath
$docsetFolder = Split-Path -Path $ParameterDictionary.docset.docfxConfigFile

$buildOutputSubfolderFullPath = JoinPath($ParameterDictionary.environment.outputFolder) @($ParameterDictionary.docset.buildOutputSubfolder)
$originalManifestJsonFilePath = JoinPath($buildOutputSubfolderFullPath) @(".manifest.json")
$xrefQueryTags = 'internal'
$xrefEndpoint = $ParameterDictionary.docset.systemMetadata._op_xrefServiceEndpoint
$branch = "master"
$locale = $ParameterDictionary.docset.docsetInfo.locale
$tripleCrownEndpoint = "https://docslearning-ppe.azurewebsites.net"
$fallbackFolders = $ParameterDictionary.environment.RepositoryFallbackFolders
$continueWithError = $ParameterDictionary.environment.publishConfigContent.continue_with_document_error
$skipPublishFilePath = $ParameterDictionary.environment.skipPublishFilePath
$logOutputFolder = $ParameterDictionary.environment.logOutputFolder

if ([string]::IsNullOrEmpty($skipPublishFilePath))
{
    $skipPublishFilePath = Join-Path $logOutputFolder "skip-publish-file-path.json"
}

if($xrefEndpoint -eq "https://xref.docs.microsoft.com")
{
    $tripleCrownEndpoint = "https://docslearning.azurewebsites.net"
}

pushd $repositoryRoot
& git branch | foreach {
    if ($_ -match "^\* (.*)") {
        $publicBranch = $matches[1]
        $branch = $publicBranch
        if ($publicBranch -eq "live")
        {
            $xrefQueryTags = "public"
        }
    }
}
popd

$myConfig = $ParameterDictionary.docset.docsetInfo.TripleCrownValidation
if ($myConfig)
{
    if ($myConfig.quizTag)
    {
        $xrefQueryTags = "$xrefQueryTags,$($myConfig.quizTag)"
    }
}
# $escapedXrefQueryTags = [System.Uri]::EscapeDataString($xrefQueryTags)
# $xrefServiceUrl = "$xrefEndpoint/query?uid={uid}&tags=$escapedXrefQueryTags"

$allArgs = @("-log", "$logFilePath", "-originalManifest", "$originalManifestJsonFilePath", "-repoRootPath", "$repositoryRoot", "-xrefTags", "$xrefQueryTags", "-locale", "$locale", "-branch", "$branch", "-tripleCrownEndpoint", "$tripleCrownEndpoint", "-docsetFolder", "$docsetFolder", "-skipPublishFilePath", "$skipPublishFilePath");

$isServerBuild = $ParameterDictionary.environment.isServerBuild

if ($xrefEndpoint)
{
    $allArgs += "-xrefEndpoint"
    $allArgs += $xrefEndpoint
}

if ($dependencyFilePath)
{
    $allArgs += "-dependencyFilePath"
    $allArgs += $dependencyFilePath
}

if ($fallbackFolders)
{
    $allArgs += "-fallbackFolders"
    $allArgs += $fallbackFolders
}

if ($continueWithError)
{
    $allArgs += "-continueWithError"
}

if($isServerBuild)
{
    echo "Run validation for Server Build." | timestamp
    $allArgs += "-isServerBuild"
}
else
{
    echo "Run validation for Local Build." | timestamp
}

$printAllArgs = [System.String]::Join(' ', $allArgs)
echo "Executing $exeFilePath $printAllArgs" | timestamp

& $exeFilePath $allArgs

exit 0