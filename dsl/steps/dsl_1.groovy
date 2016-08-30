// Variable declaration for debugging purposes
def debugHeader = '''\
	a = "xyz"
	b = [1:20, 3:40]
	proj = "test"
'''.stripIndent()

// Variable declaration when running in a procedure
// Accommodate possible multiline content
def header = '''\
	$[/myJob/header]
'''.stripIndent()

// Use the appropriate variable header
if (header.contains('$[')) { // Being evaluated outside of job step context
	evaluate(debugHeader)
} else { // Being evaluated from a job step context
	evaluate(header)
}

def desc = "variable a = " + a + " b[3] = " + b[3]
project proj,{
	procedure "DSL 1", description: desc
}