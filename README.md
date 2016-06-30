# PluginLite

## Manual Process for Creating Plugin from this template
- Copy folders (add any folders you want)
- Add your own code
	- dsl/main.groovy
	- dsl/steps/
	- htdocs/*.html
- zip directories
- change name to <your plugin name>.jar
- (you can use jar cvf <your plugin name>.jar *)
- Install and promote
 
## PowerShell Script Automates the process
- ectool login ...
- ./createJar.ps1 -pluginKey <your plugin name> -version <plugin version> -description <description>

This will create the plugin jar, install and promote your plugin.
