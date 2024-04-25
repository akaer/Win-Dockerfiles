Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Import-Module Selenium
Import-Module Pester

$Global:testURL = 'https://google.de'
$Global:Width = 1360
$Global:Height = 1020

Describe 'Simple Google search' {

    BeforeAll {
        Start-SeChrome -StartURL "$Global:testURL" -AsDefaultDriver -Arguments @('headless', 'disable-gpu', 'no-sandbox', 'enable-logging', 'no-default-browser-check', 'no-first-run', '--log-level=3', '--password-store=basic')
        $Global:SeDriver.Manage().Window.Size = new-Object System.Drawing.Size($Global:Width, $Global:Height)
    }

    It "Should open $Global:testURL" {
        SeShouldHave -Title eq 'Google'
        New-SeScreenshot -Path 'screenshot1b.png' -ImageFormat Png
    }

    Describe 'Cookie banner handling' {
    
        BeforeAll {
            $cookieBtn = Get-SeElement -By 'XPath' -Selection '//*[@id="L2AGLb"]/div'
        }
    
        It 'Can find the cookie warning' {
            $cookieBtn | Should -Not -BeNullOrEmpty
            $cookieBtn.Text | Should -Be 'Alle akzeptieren'
            New-SeScreenshot -Path 'screenshot2b.png' -ImageFormat Png
        }

        It 'Can accept the cookie warning' {
            $cookieBtn | Invoke-SeClick
        }
    }

    Describe 'Perform a search' {

        BeforeAll {
            $search = Get-SeElement -By 'Name' -Selection 'q'
        }

        It 'Can find the search input' {
            $search | Should -Not -BeNullOrEmpty
            New-SeScreenshot -Path 'screenshot3b.png' -ImageFormat Png
        }

        It 'Can enter search term and submit' {
            $search | SeType -ClearFirst -Keys "Selenium Pester Powershell"
            New-SeScreenshot -Path 'screenshot4b.png' -ImageFormat Png
            $search | SeType -Keys "{{enter}}"
        }
    }

    AfterAll {
        New-SeScreenshot -Path 'screenshot5b.png' -ImageFormat Png
        Stop-SeDriver
    }
}
