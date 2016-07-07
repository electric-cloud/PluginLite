# PluginLite
PluginLite makes is very easy to create a plugin, requiring no more than a text editor and the ability to zip or jar up directories.  Customization is done purely through DSL.

## Steps to creating a custom plugin from PluginLite
1. Copy directory, e.g., cp -r PluginLite MyPlugin
2. Decide on a version number, e.g., 1.0
3. Edit META-INF/plugin.xml (key, version, label) with this information
4. Edit dsl/promote.groovy to include your own DSL, whether in this file alone or by including files
5. Edit pages/help.xml to create your own documentation
8. Zip up the directories (dsl, META-INF, pages and any others you have added) 
9. Change extension to .jar
10. Import plugin and promote

## Debugging
Promotion and Demotion logging information is written to both a property and a file:
- Property: plugin property sheet / ec_setup.log
- File: flow plugins directory / plugin name / ec_setup.log