
#Requires Autohotkey v2
;AutoGUI creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;EasyAutoGUI-AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2
#Include <darkMode>
if A_LineFile = A_ScriptFullPath && !A_IsCompiled
{
	myGui := Constructor()
	myGui.Show()
	darkMode(mygui)
}

Constructor()
{
	global current_context := "", previous_context := "", _context := "", built_value := "", display_value := ""
	myGui := Gui()
	myGui.SetFont('s13', "Arial")
	finished := myGui.Add("Edit", "x30 y370 w526 h196 +Multi")
	code := myGui.Add("Edit", "x24 y48 w526 h121 +Multi")
	myGui.Add("Text", "x24 y8  h29", "Paste Code Here (everything automatically in clipboard on change)")
	categoryyy := myGui.Add("Edit", "x202 y328 w353 h26")
	myGui.Add("Text", "x32 y328 w166 h29", "Category/Language")
	question := myGui.Add("Edit", "x32 y240 w526 h66 +Multi")
	myGui.Add("Text", "x32 y184 w150 h33", "Question")
	myGui.Add("Button", "x+20 yp ", "Add Another").OnEvent("Click", AddAnother)
	myGui.Add("Button", "x+20 yp ", "Copy").OnEvent("Click", Build)
	finished.OnEvent("Change", Build)
	code.OnEvent("Change", Build)
	categoryyy.OnEvent("Change", Build)
	question.OnEvent("Change", Build)
	myGui.OnEvent('Close', (*) => ExitApp())
	myGui.Title := "Window (Clone)"

	Build(*)
	{
		built_value :=
			"
		(
I am providing a long piece of context along with my question. Make sure your response is all code, and has no explanation unless theres a problem. Before considering my question, ingest and analyze the context.  
For sending you that content, I will follow this rule:
[START <category>]
this is the context/code to ingest
[END  <category>]

)"
		built_value .= "`nMy request is as follows: `n" . question.Value "`n`n`n" "the context is as follows: `n" PreviousContext() "`n" Context() "`n`nAgain, considering the context, my request is as follows: `n" . question.Value
		finished.value := built_value
		A_ClipBoard := built_value
	}
	Context()
	{
		global current_context
		current_context := "[START " categoryyy.Value "]`n" code.Value "`n[END " categoryyy.Value "]"
		return current_context
	}
	PreviousContext() {
		global previous_context
		return previous_context
	}
	DisplayValue(*)
	{
		A_ClipBoard := built_value

	}
	AddAnother(*) {
		previous_context := previous_context . current_context
		categoryyy.Value := ""
		code.Value := ""

	}
	
	
	return myGui
}