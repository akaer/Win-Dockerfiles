Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Import-Module Selenium
Import-Module Pester

$Global:testURL = 'https://google.de'
$Global:Width = 1360
$Global:Height = 1020

Describe 'Simple Google search' {

    BeforeAll {
        $chromeOptions = New-Object OpenQA.Selenium.Chrome.ChromeOptions

        # https://peter.sh/experiments/chromium-command-line-switches/
        $chromeOptions.AddArguments('headless', 'disable-gpu', 'no-sandbox', 'enable-logging', 'no-default-browser-check', 'no-first-run', '--log-level=3', '--password-store=basic')
        $driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($chromeOptions)
        $driver.Manage().Window.Size = new-Object System.Drawing.Size($Global:Width, $Global:Height)
        $driver.Navigate().GoToUrl($Global:testURL)
    }

    It "Should open $Global:testURL" {
        $driver.Title | Should -Be 'Google'
        $driver.GetScreenshot().SaveAsFile('screenshot1a.png', 'png')
    }

    Describe 'Cookie banner handling' {
    
        BeforeAll {
            $cookieBtn = $driver.FindElementByXPath('//*[@id="L2AGLb"]/div')
        }
    
        It 'Can find the cookie warning' {
            $cookieBtn | Should -Not -BeNullOrEmpty
            $cookieBtn.Text | Should -Be 'Alle akzeptieren'
            $driver.GetScreenshot().SaveAsFile('screenshot2a.png', 'png')
        }

        It 'Can accept the cookie warning' {
            $cookieBtn.Click()
        }
    }

    Describe 'Perform a search' {

        BeforeAll {
            $search = $driver.FindElementByName('q')
        }

        It 'Can find the search input' {
            $search | Should -Not -BeNullOrEmpty
            $driver.GetScreenshot().SaveAsFile('screenshot3a.png', 'png')
        }

        It 'Can enter search term and submit' {
            $search.SendKeys('Selenium Pester Powershell')
            $driver.GetScreenshot().SaveAsFile('screenshot4a.png', 'png')
            $search.Submit()
        }
    }

    AfterAll {
        $driver.GetScreenshot().SaveAsFile('screenshot5a.png', 'png')

        $driver.Close()
        $driver.Quit()
    }
}
