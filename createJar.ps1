function Add-Zip
{
    param([string]$zipfilename)

    if(-not (test-path($zipfilename)))
    {
        set-content $zipfilename ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18))
        (dir $zipfilename).IsReadOnly = $false
    }

    $shellApplication = new-object -com shell.application
        $zipfilenameFull = get-childitem $zipfilename
    $zipPackage = $shellApplication.NameSpace($zipfilenameFull.FullName)

        #$files = Get-ChildItem -Path $srcdir | where{! $_.PSIsContainer}

    foreach($file in $input)
    {
            write-host $file.FullName
                        $zipPackage.CopyHere($file.FullName)
                        while($zipPackage.Items().Item($file.name) -eq $null){
                                Start-sleep -seconds 1
                        }
            #Start-sleep -milliseconds 500
    }
}

# Update project.xml with ec_setup.pl
$ec_setup = Get-Content ec_setup.pl
$a = Select-Xml -Path .\META-INF\project.xml -XPath '//value[../propertyName/text() = "ec_setup"]'
$a.Node.'#text'=$ec_setup -join "`n"
$a.Node.OwnerDocument.Save($a.Path)

del .\PluginLite.zip -ErrorAction SilentlyContinue
del .\PluginLite.jar -ErrorAction SilentlyContinue
dir . | Add-Zip .\PluginLite.zip
mv PluginLite.zip PluginLite.jar

ectool uninstallPlugin PluginLite-1.0
ectool installPlugin PluginLite.jar
ectool promotePlugin PluginLite-1.0

type $Env:TEMP/log.txt