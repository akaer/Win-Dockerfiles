# escape=`
#
# Docker image for
#
# Selenium with Google Chrome on Windows
#
# Source: https://github.com/akaer/Win-Dockerfiles/tree/main/Selenium-Chrome
#
# Create:
#
# docker build --rm -t akaer/win-selenium-chrome .
#
# Run:
#
# docker run -it --rm --name win-selenium-chrome1 --hostname win-selenium-chrome1 -v "$(pwd)\data:c:\data" -p 9222:9222 akaer/win-selenium-chrome
#

FROM mcr.microsoft.com/windows/servercore:ltsc2019
LABEL maintainer "André Raabe <andre.raabe@gmail.com>"

ENV POWERSHELL_TELEMETRY_OPTOUT=1

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

COPY files\\Fonts.zip c:\\windows\\temp
COPY files\\register-fonts.ps1 c:\\windows\\temp

RUN Expand-Archive c:\windows\temp\Fonts.zip -DestinationPath c:\windows ; `
	c:\windows\temp\register-fonts.ps1 ; `
	Remove-Item C:\Windows\Temp\Fonts.zip ; `
	Remove-Item C:\Windows\Temp\register-fonts.ps1 ; `
	Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force ; `
	Install-Module Pester -SkipPublisherCheck -Force ; `
	Install-Module Selenium,PSScriptAnalyzer -Force ; `
	Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

RUN choco install googlechrome -y -q ; `
	Invoke-WebRequest -Uri "https://chromedriver.storage.googleapis.com/94.0.4606.61/chromedriver_win32.zip" -OutFile "c:\windows\temp\chromedriver_win32.zip" ; `
	Expand-Archive "c:\windows\temp\chromedriver_win32.zip" -DestinationPath "c:\windows" ; `
	Remove-Item "c:\windows\temp\chromedriver_win32.zip" ; `
	Copy-Item 'C:\Windows\chromedriver.exe' -Destination 'C:\Program Files\WindowsPowerShell\Modules\Selenium\3.0.1\assemblies' -Force ; `
	New-Item -Path 'c:\' -Name 'data' -ItemType 'directory' > $NULL ; `
	$oldpath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name 'Path').Path ; `
	$chromePath = 'C:\Program Files\Google\Chrome\Application' ; `
	$newpath = "${oldpath};${chromePath}" ; `
	Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name 'Path' -Value "${newPath}"

VOLUME [ "c:\\data" ]
WORKDIR c:\\data

EXPOSE 9222

ENTRYPOINT [ "powershell" ]
