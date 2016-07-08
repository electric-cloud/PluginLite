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

	write-host "Zipping up directories"
    foreach($file in $input)
    {
		write-host $file.FullName
			$zipPackage.CopyHere($file.FullName)
			while($zipPackage.Items().Item($file.name) -eq $null){
					Start-sleep -seconds 1
			}
    }
}

# Update project.xml with ec_setup.pl
write-host "Updating project.xml with ec_setup.pl"
$ec_setup = Get-Content ec_setup.pl
$a = Select-Xml -Path .\META-INF\project.xml -XPath '//value[../propertyName/text() = "ec_setup"]'
$a.Node.'#text'=$ec_setup -join "`n"
$a.Node.OwnerDocument.Save($a.Path)

write-host "Updating plugin.xml with key, version, label, description"
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

write-host "Removing old zip and jar files"
del "${pluginKey}.zip" -ErrorAction SilentlyContinue
del "${pluginKey}.jar" -ErrorAction SilentlyContinue
dir . | Add-Zip "${pluginKey}.zip"
Move-Item "${pluginKey}.zip" "${pluginKey}.jar"

write-host "Demoting old plugin"
ectool promotePlugin "$pluginName" --promoted false
write-host "Uninstalling old plugin"
ectool uninstallPlugin "$pluginName"
write-host "Installing new plugin"
ectool installPlugin "${pluginKey}.jar"
write-host "Promoting new plugin"
ectool promotePlugin "$pluginName"

write-host "Output from ec_setup.pl promoting plugin:"
type $Env:TEMP/ec_setup.log