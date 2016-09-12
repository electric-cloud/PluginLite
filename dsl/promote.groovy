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

	/*
		Example of breaking up a large DSL file into smaller chunks and combined in a procedure.
		See https://ask.electric-cloud.com/questions/6777/how-to-best-break-up-large-dsl-files.html
		for details.
	*/
	def dslDir = pluginDir + "/dsl/steps/"
    def commonProp = "abc"

	procedure "Multi-DSL",{

		step "Common properties",
			command: """\
				ectool setProperty /myJob/commonProp "$commonProp"
				ectool setProperty /myJob/commonProp "$dslDir"
			""".stripIndent()

		step "DSL 0 - header",
			command: new File(dslDir + "header.groovy").text,
			shell: "ectool evalDsl --dslFile {0}"

		step "DSL 1",
			command: new File(dslDir + "dsl_1.groovy").text,
			shell: "ectool evalDsl --dslFile {0}"

	} // procedure "Multi-DSL"
} // project pluginName

transaction {
	runProcedure projectName: pluginName, procedureName: "Multi-DSL"
}
