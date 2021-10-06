# Dockerfile for Maihog (https://github.com/mailhog/MailHog)
# Source: https://github.com/akaer/Win-MailHog
#
# docker build -t akaer/win-mailhog .
#
# mkdir data
# docker run -it --rm -p 1025:1025 -p 8025:8025 -v $PWD/data:C:/data --name win-mailhog akaer/win-mailhog

FROM mcr.microsoft.com/windows/servercore:ltsc2019

ENV MAILHOG_VERSION v1.0.1
ENV MH_STORAGE maildir
ENV MH_MAILDIRPATH c:/data

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Invoke-WebRequest https://github.com/mailhog/MailHog/releases/download/${env:MAILHOG_VERSION}/MailHog_windows_amd64.exe -OutFile c:/MailHog_windows_amd64.exe

RUN MKDIR "${env:MH_MAILDIRPATH}" > $NULL
VOLUME ["${MH_MAILDIRPATH}"]

EXPOSE 1025
EXPOSE 8025
ENTRYPOINT ["powershell", "c:/MailHog_windows_amd64.exe", "-maildir-path", "${env:MH_MAILDIRPATH}"]