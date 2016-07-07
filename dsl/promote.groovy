def pluginName = args.pluginName
def pluginKey = getProject("/plugins/$pluginName/project").pluginKey
def pluginDir = getProperty("/server/settings/pluginsDirectory").value + "/" + pluginName

project pluginName,{
	
	property "pluginBaseName", value: pluginKey
	property "pluginDir", value: pluginDir
	
	procedure "Sample Procedure",{
		step "Hello", shell: "ec-perl", command: new File(pluginDir + "/dsl/steps/Hello.pl").text
	}
}
