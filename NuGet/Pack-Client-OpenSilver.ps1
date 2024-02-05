param(
    [string]$Path = ".",
	[string[]]$Include =  @("OpenSilver.OpenRiaServices.Client.Core.nuspec", "OpenSilver.OpenRiaServices.Client.nuspec", "OpenSilver.OpenRiaServices.DomainDataSource.nuspec", "OpenSilver.OpenRiaServices.Data.DomainServices.nuspec"),
	[string]$Version = "2.1.0",
	[string]$OpenSilverDependencyVersion = "2.1.0",
	[string]$RepositoryUrl = "https://github.com/OpenSilver/OpenRiaServices",
	[string]$NuGetPath
)

$scriptPath = (Split-Path -Parent $PSCommandPath)
Push-Location $scriptPath

$outputDir = "bin/opensilver"
if (-not (Test-Path $outputDir)) {
    mkdir $outputDir
}

# If NuGet path is not specified then check one folder above git repo, or hope for it to be in the path
if ([string]::IsNullOrEmpty($NuGetPath))
{
	if (Test-Path ..\..\NuGet.exe) { $NuGetPath = "..\..\NuGet.exe"}
	else { $NuGetPath = "nuget.exe"}
}

foreach($nuspec in (dir $Path -Recurse -Include $Include))
{
        echo "Building $nuspec"
        & $NuGetPath pack ($nuspec) -OutputDirectory $outputDir -Properties "PackageVersion=$Version;OpenSilverDependencyVersion=$OpenSilverDependencyVersion;RepositoryUrl=$RepositoryUrl;"
}

Pop-Location
