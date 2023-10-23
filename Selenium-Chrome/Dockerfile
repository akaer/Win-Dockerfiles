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
# docker run -it --rm --name win-selenium-chrome1 --hostname win-selenium-chrome1 -v ".\data:c:\data" -p 9222:9222 akaer/win-selenium-chrome Invoke-Pester -Output Detailed
#
# HINTS:
# Google Chrome(driver) is taken from
# https://googlechromelabs.github.io/chrome-for-testing/#stable
#

FROM mcr.microsoft.com/windows/servercore:ltsc2022
LABEL maintainer "André Raabe <andre.raabe@gmail.com>"

ENV POWERSHELL_TELEMETRY_OPTOUT=1

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

COPY files\\Fonts.zip c:\\windows\\temp
COPY files\\register-fonts.ps1 c:\\windows\\temp

RUN Expand-Archive c:\windows\temp\Fonts.zip -DestinationPath c:\windows ; `
	c:\windows\temp\register-fonts.ps1 ; `
	Remove-Item C:\windows\temp\Fonts.zip ; `
	Remove-Item C:\windows\temp\register-fonts.ps1 ; `
	Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force ; `
	Install-Module Pester -SkipPublisherCheck -Force ; `
	Install-Module Selenium,PSScriptAnalyzer -Force

RUN $ChromeVersionFile = 'c:\chromeversion.txt' ; `
	Invoke-WebRequest -Uri "https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_STABLE" -OutFile $ChromeVersionFile ; `
	$ChromeVersion = Get-Content -Path $ChromeVersionFile ; `
	Invoke-WebRequest -Uri "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/$ChromeVersion/win32/chromedriver-win32.zip" -OutFile 'c:\windows\temp\chromedriver_win32.zip' ; `
	Invoke-WebRequest -Uri "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/$ChromeVersion/win32/chrome-win32.zip" -OutFile 'c:\windows\temp\chrome_win32.zip' ; `
	Expand-Archive 'c:\windows\temp\chromedriver_win32.zip' -DestinationPath 'c:\windows' ; `
	Expand-Archive 'c:\windows\temp\chrome_win32.zip' -DestinationPath 'c:\windows' ; `
	Remove-Item 'c:\windows\temp\chromedriver_win32.zip' ; `
	Remove-Item 'c:\windows\temp\chrome_win32.zip' ; `
	Copy-Item 'c:\windows\chromedriver-win32\chromedriver.exe' -Destination 'c:\Program Files\WindowsPowerShell\Modules\Selenium\3.0.1\assemblies' -Force ; `
	New-Item -Path 'c:\' -Name 'data' -ItemType 'directory' > $NULL ; `
	[Environment]::SetEnvironmentVariable('Path', 'c:\windows\chrome-win32;' + $env:Path, 'Machine')

VOLUME [ "c:\\data" ]
WORKDIR "c:\\data"

EXPOSE 9222

ENTRYPOINT [ "powershell" ]
