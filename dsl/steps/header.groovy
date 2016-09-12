property "/myJob/header", value: '''\
	// Do not use 'def'
	a = "abc"
	b = [1:2, 3:4]
	proj = "$[/myProject/projectName]"
	commonProp = "$[/myJob/commonProp]"
'''.stripIndent()