# PluginLite
PluginLite makes is very easy to create a plugin project based on DSL.  All that is needed is a text editor and the ability to zip or jar up directories.

## Steps to creating a custom plugin from PluginLite
1. Download the zip file from github or do a **git clone https://github.com/electric-cloud/PluginLite**
2. Copy directory, e.g., cp -r PluginLite MyPlugin
2. Decide on a version number, e.g., 1.0
3. Edit META-INF/plugin.xml (key, version, label) with the name and version of your plugin
4. Edit dsl/promote.groovy to include your own DSL
5. Zip up the directories only (dsl, META-INF, pages and any others you have added) 
6. Import plugin and promote

## Alternative steps to creating a plugin
PowerShell and ec-perl scripts (createPlugin.ps1 and createPlugin.pl) are provided as an alternative to the instructions above.  Edit dsl/promote.groovy to include your own DSL, then
```powershell
ectool --server <your flow server> login <username>
.\createPlugin.ps1 [-pluginKey <your plugin name>] [-version <version>] [-description <description>]
```

or

```
ectool --server <your flow server> login <username>
ec-perl createPlugin.pl [--pluginKey <your plugin name>] [--version <version>] [--description <description>]
```

This will perform the following actions:
1. Update META-INF/plugin.xml with the values provided
2. Insert the file ec_setup.pl into META-INF/project.xml (this code is run on promotion and demotion/uninstall of the plugin)
3. Create a plugin jar file from the files and directories in the current working directory
4. Install plugin on to the Electric Flow server
5. Promote the plugin

## Debugging
Promotion and Demotion logging information is written to both a property and a file:
- Property: plugin property sheet / ec_setup.log
- File: flow plugins directory / plugin name / ec_setup.log

## Running in Linux
- See page 8 of "PluginLite Introduction" to get PluginLite running in a Linux environment

## Clean up on plugin uninstall or demotion
The file dsl/demote.groovy is run when the plugin in demoted.  Use this to clean up any properties, project or other objects that were created by promote.groovy.

## Modeling methods illustrated with this plugin
* Create Plugin from DSL
* Access plugin properties from within the DSL
* Create jobsteps from files
* Make plugin project visible in all (optionally, certain) contexts
* Add plugin to plugin picker menus
* Breaking up a large DSL file into multiple DSL files and evaluated in a procedure
	* Variable sharing through job properties
	* Shared header (constants) through properties
	* Ability to run each DSL file stand-alone
		* Use job property header in a procedure contexts
		* Use existing job propery header for debugging
		* Use debug header for debugging
	* Run the procedure with a transaction


