param (
    [string]$pluginKey = "PluginLite",
	[string]$version = "1.0",
	[string]$description = "Ultra light plugin customized with DSL"
)

$pluginName = "${pluginKey}-${version}"

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

# Update plugin.xml with key, version, label, description
$b = Select-Xml -Path .\META-INF\plugin.xml -XPath '//key'
$b.Node.'#text' = $pluginKey
$b.Node.OwnerDocument.Save($b.Path)

$b = Select-Xml -Path .\META-INF\plugin.xml -XPath '//version'
$b.Node.'#text' = $version
$b.Node.OwnerDocument.Save($b.Path)

$b = Select-Xml -Path .\META-INF\plugin.xml -XPath '//label'
$b.Node.'#text' = $pluginKey
$b.Node.OwnerDocument.Save($b.Path)

$b = Select-Xml -Path .\META-INF\plugin.xml -XPath '//description'
$b.Node.'#text' = $description
$b.Node.OwnerDocument.Save($b.Path)

del "${pluginKey}.zip" -ErrorAction SilentlyContinue
del "${pluginKey}.jar" -ErrorAction SilentlyContinue
dir . | Add-Zip "${pluginKey}.zip"
Move-Item "${pluginKey}.zip" "${pluginKey}.jar"

ectool uninstallPlugin "$pluginName"
ectool installPlugin "${pluginKey}.jar"
ectool promotePlugin "$pluginName"

type $Env:TEMP/log.txt