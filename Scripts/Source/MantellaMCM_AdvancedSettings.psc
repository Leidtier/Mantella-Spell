Scriptname MantellaMCM_AdvancedSettings Hidden

function Render(MantellaMCM mcm, MantellaRepository Repository) global
    mcm.SetCursorFillMode(mcm.TOP_TO_BOTTOM)
    LeftColumn(mcm, Repository)
    mcm.SetCursorPosition(1)
    RightColumn(mcm, Repository)
endfunction

function LeftColumn(MantellaMCM mcm, MantellaRepository Repository) global
	mcm.AddHeaderOption("Debug")
	mcm.oid_debugNPCselectMode = mcm.AddToggleOption("NPC Debug Select Mode", Repository.NPCdebugSelectModeEnabled)
    mcm.AddHeaderOption("Keyword Based Tracking")
    mcm.oid_useTrackingByKeyword = mcm.AddToggleOption("Use Keyword based tracking", Repository.useTrackingByKeywords)
    mcm.oid_useAllowanceList = mcm.AddToggleOption("Only track allowed things", Repository.useAllowanceList)
    mcm.oid_useBlockList = mcm.AddToggleOption("Don't track blocked things", Repository.useBlockList)
endfunction

function RightColumn(MantellaMCM mcm, MantellaRepository Repository) global
	mcm.AddHeaderOption("HTTP")
    If (Repository.IsVR())
        mcm.oid_httpPort = mcm.AddSliderOption("Port", Repository.HttpPort)
    else
        mcm.oid_httpPort = mcm.AddInputOption("Port", Repository.HttpPort)
    EndIf	
endfunction

function OptionInputUpdate(MantellaMCM mcm, int optionID, string inputText, MantellaRepository Repository) global
	If optionID == mcm.oid_httpPort
		int convertedInput = inputText as int
		if(convertedInput > 0 && convertedInput < 65535)
			Repository.HttpPort = convertedInput
			mcm.SetInputOptionValue(optionID, inputText)
		endIf
	endIf
endfunction

function SliderOptionOpen(MantellaMCM mcm, int optionID, MantellaRepository Repository) global
    ; SliderOptionOpen is used to choose what to display when the user clicks on the slider
    if optionID==mcm.oid_httpPort
        mcm.SetSliderDialogStartValue(repository.HttpPort)
        mcm.SetSliderDialogDefaultValue(4999)
        mcm.SetSliderDialogRange(1, 65535)
        mcm.SetSliderDialogInterval(1)    
    endif
endfunction

function SliderOptionAccept(MantellaMCM mcm, int optionID, float value, MantellaRepository Repository) global
    ;SliderOptionAccept is used to update the Repository with the user input (that input will then be used by the Mantella effect script
    If  optionId == mcm.oid_httpPort
        mcm.SetSliderOptionValue(optionId, value)
        Repository.HttpPort = value as int
    EndIf
endfunction

function OptionUpdate(MantellaMCM mcm, int optionID, MantellaRepository Repository) global
	if optionID == mcm.oid_debugNPCselectMode
		Repository.NPCdebugSelectModeEnabled =! Repository.NPCdebugSelectModeEnabled
		mcm.SetToggleOptionValue(mcm.oid_debugNPCselectMode, Repository.NPCdebugSelectModeEnabled)
    elseif optionID == mcm.oid_useTrackingByKeyword
        Repository.useTrackingByKeywords =! Repository.useTrackingByKeywords
        mcm.SetToggleOptionValue(optionID, Repository.useTrackingByKeywords)
    elseif optionID == mcm.oid_useAllowanceList
        Repository.useAllowanceList =! Repository.useAllowanceList
        mcm.SetToggleOptionValue(optionID, Repository.useAllowanceList)
    elseif optionID == mcm.oid_useBlockList
        Repository.useBlockList =! Repository.useBlockList
        mcm.SetToggleOptionValue(optionID, Repository.useBlockList)
	endIf
endfunction 
