// Variables available for use in DSL code
def pluginName = args.pluginName
def pluginKey = getProject("/plugins/$pluginName/project").pluginKey
def pluginDir = getProperty("/server/settings/pluginsDirectory").value + "/" + pluginName
// END Variables

// Server level property that exposes plugin procedures to pipeline tasks,
// application processes and component processes (pick lists)
property "/server/ec_customEditors/pickerStep/$pluginKey - Sample Procedure", value:
"""\
<step>
	<project>/plugins/$pluginKey/project</project>
	<procedure>Sample Procedure</procedure>
	<category>Utility</category>
</step>
""".stripIndent()
// TIP: Remove this property in demote.groovy
// END property

// Sample plugin project content.  pluginName can be replaced by a name
// to create a non-plugin project
project pluginName,{
	
	// Make this plugin visible in all contexts
	property "ec_visibility", value: "all" // Legal values: pickListOnly, hidden, all
	property "pluginBaseName", value: pluginKey
	property "pluginDir", value: pluginDir
	
	procedure "Sample Procedure",{
		step "Hello", shell: "ec-perl",
			// Get step content from a file in this plugin directory
			command: new File(pluginDir + "/dsl/steps/Hello.pl").text
	}

}
