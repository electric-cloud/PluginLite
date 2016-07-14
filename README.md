# PluginLite
PluginLite makes is very easy to create a plugin project based on DSL.  All that is needed is a text editor and the ability to zip or jar up directories.

## Steps to creating a custom plugin from PluginLite
1. Copy directory, e.g., cp -r PluginLite MyPlugin
2. Decide on a version number, e.g., 1.0
3. Edit META-INF/plugin.xml (key, version, label) with the name and version of your plugin
4. Edit dsl/promote.groovy to include your own DSL
5. Zip up the directories only (dsl, META-INF, pages and any others you have added) 
6. Import plugin and promote

## Alternative steps to creating a plugin
The PowerShell script createPlugin.ps1 can be used as an alternative to the instructions above.  Edit dsl/promote.groovy to include your own DSL, then
```powershell
ectool --server <your flow server> login <username>
.\createPlugin.ps1 <your plugin name> <version> <description>
```
This will change META-INF/plugin.xml to the values provided, create a jar file plugin from directories, upload  and promote the plugin.

## Debugging
Promotion and Demotion logging information is written to both a property and a file:
- Property: plugin property sheet / ec_setup.log
- File: flow plugins directory / plugin name / ec_setup.log

## Optional functionality
The file dsl/demote.groovy is run when the plugin in demoted.  Use this to clean up any properties, project or other objects that were created by promote.groovy.

