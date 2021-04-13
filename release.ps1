if ($IsMacOS) {
    $msbuild = "msbuild"
} else {
    $vswhere = 'C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe'
    $msbuild = & $vswhere -latest -products * -requires Microsoft.Component.MSBuild -property installationPath
    $msbuild = join-path $msbuild 'MSBuild\Current\Bin\MSBuild.exe'
}

#####################
#Build release config
$version="2.2.30"
$versionSuffix="-pre1"
$nugetVersion="$version$versionSuffix"
#$versionSuffix=".$env:BUILD_NUMBER" 

& $msBuild obfuscar.sln /p:Configuration=Release /p:Version="$version" /p:VersionSuffix="$versionSuffix" --% /t:Clean;Build
if ($lastexitcode -ne 0) { exit $lastexitcode; }

nuget pack "Obfuscar.nuspec" -Version $nugetVersion
