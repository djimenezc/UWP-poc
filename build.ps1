
$extention="appx"

Remove-AppPackage (Get-AppxPackage | Select-String -Pattern 'spah-cmd')
Remove-Item -Path priconfig.xml
Remove-Item -Path *.pri
Remove-Item -Path spah.appx
Remove-Item -Path spah.msix
Remove-Item -Recurse -Force -Path bin\x64\debug

$ErrorActionPreference = "Stop"

MSBuild.exe .\SecurePrintAtHomeWin11.csproj /p:Configuration=Debug /p:Platform=x64 /t:rebuild

makepri.exe createconfig /o /cf priconfig.xml /dq en-US /pv 10.0.0
makepri.exe new /o /pr . /cf .\priconfig.xml /in .\Package.appxmanifest

makeappx.exe pack /o /v /h sha256 /f filemap.map.txt /m Package.appxmanifest /p spah.$extention

signtool.exe sign /fd sha256 /sha1 6584ff1496e82159987864f8c5c461d416fb018b /t http://timestamp.digicert.com .\spah.$extention

#Add-AppPackage -AllowUnsigned -Path .\spah.$extention
Add-AppPackage -AllowUnsigned -Path .\bin\x64\debug\SecurePrintAtHomeWin11_1.0.5.1_x64_Debug.msix

makeappx.exe unpack /p .\bin\x64\debug\SecurePrintAtHomeWin11_1.0.5.1_x64_Debug.msix /d .\bin\x64\debug\output-msix /o /l
makeappx.exe unpack /p spah.$extention /d output-msix /o