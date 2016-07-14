// Variables available for use in DSL code
def pluginName = args.pluginName
def pluginKey = getProject("/plugins/$pluginName/project").pluginKey
def pluginDir = getProperty("/server/settings/pluginsDirectory").value + "/" + pluginName
// END Variables

// Sample plugin project content.  pluginName can be replaced by a name
// to create a non-plugin project
project pluginName,{
	
	// Make this plugin visible in all contexts
	property "ec_visibility", value: "all" // Legal values: pickListOnly, hidden, all
	
	procedure "Sample Procedure",{
	
		// Server level property that exposes this procedure for use in pipeline tasks,
		// application processes and component processes (pick lists). Note that
		// procedureName an intrinsic variable for the procedure closure
		property "/server/ec_customEditors/pickerStep/$pluginKey - $procedureName",
			value:
				"""\
					<step>
						<project>/plugins/$pluginKey/project</project>
						<procedure>$procedureName</procedure>
						<category>Utility</category>
					</step>
				""".stripIndent(),
			description: "A sample procedure"
		// TIP: Remove this property in demote.groovy
		// END property	
	
		step "Hello", shell: "ec-perl",
			// Get step content from a file in this plugin directory
			command: new File(pluginDir + "/dsl/steps/Hello.pl").text
	}

}
