#Remove-AppPackage (Get-AppxPackage | Select-String -Pattern 'spah-cmd')
Remove-Item -Path priconfig.xml
Remove-Item -Path resources.scale-200.pri
Remove-Item -Path resources.pri
Remove-Item -Path spah.appx
MSBuild.exe .\SecurePrintAtHomeWin11.csproj /p:Configuration=Debug /p:Platform=x64 /t:rebuild
makepri.exe createconfig /o /cf priconfig.xml /dq en-US /pv 10.0.0
makepri.exe new /o /pr . /cf .\priconfig.xml /in .\Package.appxmanifest
makeappx.exe pack /o /v /h sha256 /f filemap.map.txt /m Package.appxmanifest /p spah.appx
signtool.exe sign /fd sha256 /sha1 6584ff1496e82159987864f8c5c461d416fb018b /t http://timestamp.digicert.com .\spah.appx
Add-AppPackage -AllowUnsigned -Path .\spah.appx