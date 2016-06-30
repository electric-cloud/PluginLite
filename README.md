# PluginLite
PluginLite provides a template for the easiest way to create a plugin.  All that is needed is a text editor and the ability to create a zip file.  The details of your plugin project are added through DSL.  The main.groovy DSL code can reference other files in the plugin.

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
