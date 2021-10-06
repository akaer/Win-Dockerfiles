# from https://stackoverflow.com/a/58100621/131626

$fontCSharpCode = @'
using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Runtime.InteropServices;
namespace FontResource
{
    public class AddRemoveFonts
    {
        [DllImport("gdi32.dll")]
        static extern int AddFontResource(string lpFilename);
        public static int AddFont(string fontFilePath) {
            try
            {
                Console.Write("Registering font {0}", Path.GetFileName(fontFilePath));
                var ret = AddFontResource(fontFilePath);
                Console.WriteLine(" -> done");
                return ret;
            }
            catch ( Exception ex )
            {
                Console.WriteLine(" -> failed");
                Console.WriteLine(ex.Message);
                return 0;
            }
        }
    }
}
'@

Add-Type $fontCSharpCode

$sFontsFolder = "C:\Windows\Fonts";
$sRegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts";
$objShell = New-Object -ComObject Shell.Application;
$objFolder = $objShell.namespace($sFontsFolder);

foreach ($objFile in $objFolder.items()) {
    if ($objFile.Name -ne "lucon.ttf") {
        $sFontName = $($objFolder.getDetailsOf($objFile, 21))
        $sRegKeyName = $sFontName, "(TrueType)" -join " "
        $sRegKeyValue = $objFile.Name

        $null = New-ItemProperty -Path $sRegPath -Name $sRegKeyName -Value $sRegKeyValue -PropertyType String -Force

        [FontResource.AddRemoveFonts]::AddFont($objFile.Path) | Out-Null
    }
}
