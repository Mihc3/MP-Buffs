MPB_Options = CreateFrame("Frame", "MPB_Options", UIParent)
function MPB_Options:Load()
	MPB_Options:Hide()

	MPB_Options:SetBackdrop({bgFile = "Interface\\TabardFrame\\TabardFrameBackground", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 25, insets = {left = 4, right = 4, top = 4, bottom = 4}})
	MPB_Options:SetBackdropColor(0, 0, 0, 0.7)
	MPB_Options:SetBackdropBorderColor(0, 204/255, 51/255)
	
	MPB_Options:SetPoint("CENTER",UIParent)
	MPB_Options:SetWidth(400)
	MPB_Options:SetHeight(200)
	MPB_Options:EnableMouse(true)
	MPB_Options:SetMovable(true)
	MPB_Options:RegisterForDrag("LeftButton")
	MPB_Options:SetUserPlaced(true)
	MPB_Options:SetScript("OnDragStart", function(self) self:StartMoving() end)
	MPB_Options:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	MPB_Options:SetFrameStrata("FULLSCREEN_DIALOG")
	
	--[[ MP Buffs - Options ]]--
	local Label, Button, CheckBox
	
	local Label = MPB_Options:CreateFontString("MPB_FS_TITLE", "ARTWORK", "GameFontNormal")
	Label:SetPoint("TOP", 0, -12)
	Label:SetTextColor(1,1,1) 
	Label:SetText("|cFF00CC33MP Buffs|r ("..MPBuffs.Version..") - Options")
	Label:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
	Label:SetShadowOffset(1, -1)
	
	Button = CreateFrame("button", "MPB_BTN_CLOSE", MPB_Options, "UIPanelButtonTemplate")
	Button:SetHeight(14)
	Button:SetWidth(14)
	Button:SetPoint("TOPRIGHT", -12, -11)
	Button:SetText("x")
	Button:SetScript("OnClick", function(self) MPB_Options:Hide() end)
	
	-- Enable/disable addon
	Label = MPB_Options:CreateFontString("MPB_FS_STATUS", "ARTWORK", "GameFontNormal")
	Label:SetPoint("TOPLEFT", 10, -30)
	Label:SetTextColor(1,1,1) 
	Label:SetText("Addon is now "..(MPB_Data["ENABLED"] and "|cFF00CC33enabled|r" or "|cFFFF0000disabled|r")..".")
	
	Button = CreateFrame("button", "MPB_BTN_TOGGLE", MPB_Options, "UIPanelButtonTemplate")
	Button:SetHeight(16)
	Button:SetWidth(60)
	Button:SetPoint("TOPLEFT", "MPB_FS_STATUS", "TOPLEFT", 134, 1)
	Button:SetText(MPB_Data["ENABLED"] and "Disable" or "Enable")
	Button:SetScript("OnClick", function(self)
		MPB_Data["ENABLED"] = not MPB_Data["ENABLED"]
		self:SetText(MPB_Data["ENABLED"] and "Disable" or "Enable")
		getglobal("MPB_FS_STATUS"):SetText("Addon is now "..(MPB_Data["ENABLED"] and "|cFF00CC33enabled|r" or "|cFFFF0000disabled|r")..".")
		MPBuffs:Toggled()
	end)
	
	Button = CreateFrame("button", "MPB_BTN_RESTORE_DEFAULT_SETTINGS", MPB_Options, "UIPanelButtonTemplate")
	Button:SetHeight(18)
	Button:SetWidth(180)
	Button:SetPoint("TOPLEFT", 10, -46)
	Button:SetText("Restore Default Settings")
	Button:SetScript("OnClick", function(self)
		MPB_Data["ICON_SIZE"] = 28
		MPB_Data["DURATION_SHOWN"] = true
		MPB_Data["DURATION_WARNING_TIME"] = 60
		MPB_Data["BORDER_BUFF"] = true
		MPB_Data["BORDER_DEBUFF"] = true
		MPB_Data["CASTER_DISPLAY_MODE"] = 2
		MPB_Data["CASTER_DISPLAY_LETTERS"] = 4		
		MPB_Data["COOLDOWN_INDICATOR"] = true
		MPB_Data["FLASH_EXPIRING_MODE"] = 2
		MPB_Data["FLASH_EXPIRING_TIME"] = 30
		MPB_Data["FLASH_EXPIRING_PERIOD"] = 2
		MPB_Data["FLASH_EXPIRING_MIN_ALPHA"] = 0.2	
		MPB_Data["TOOLTIP_DISPLAY"] = true
		MPB_Options:Hide()
		MPB_Options:Show()
	end)
	
	--[[
	Button = CreateFrame("button", "MPB_BTN_MOVE_FRAME", MPB_Options, "UIPanelButtonTemplate")
	Button:SetHeight(18)
	Button:SetWidth(180)
	Button:SetPoint("TOPLEFT", 10, -66)
	Button:SetText("Move Buffs & Debuffs Frame")
	Button:SetScript("OnClick", nil)
	Button:Disable()
	]]
	
	Label = MPB_Options:CreateFontString("MPB_FS_ICON_SIZE", "ARTWORK", "GameFontNormal")
	Label:SetPoint("TOPLEFT", 10, -70)
	Label:SetTextColor(1,1,1) 
	Label:SetText("Icon Size:")
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_ICON_SIZE_1", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_FS_ICON_SIZE", "TOPLEFT", 56, 3)
	_G["MPB_CB_ICON_SIZE_1".."Text"]:SetText("28px")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["ICON_SIZE"] == 28) end)
	CheckBox:SetScript("OnClick", function(self)
		for i=1,3 do
			getglobal("MPB_CB_ICON_SIZE_"..i):SetChecked(false)
		end
		self:SetChecked(true)
		MPB_Data["ICON_SIZE"] = 28
	end)
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_ICON_SIZE_2", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_CB_ICON_SIZE_1", "TOPLEFT", 44, 0)
	_G["MPB_CB_ICON_SIZE_2".."Text"]:SetText("30px")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["ICON_SIZE"] == 30) end)
	CheckBox:SetScript("OnClick", function(self)
		for i=1,3 do
			getglobal("MPB_CB_ICON_SIZE_"..i):SetChecked(false)
		end
		self:SetChecked(true)
		MPB_Data["ICON_SIZE"] = 30
	end)
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_ICON_SIZE_3", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_CB_ICON_SIZE_2", "TOPLEFT", 44, 0)
	_G["MPB_CB_ICON_SIZE_3".."Text"]:SetText("32px")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["ICON_SIZE"] == 32) end)
	CheckBox:SetScript("OnClick", function(self)
		for i=1,3 do
			getglobal("MPB_CB_ICON_SIZE_"..i):SetChecked(false)
		end
		self:SetChecked(true)
		MPB_Data["ICON_SIZE"] = 32
	end)
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_BORDER_BUFF_SHOWN", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", 10, -84)
	_G["MPB_CB_BORDER_BUFF_SHOWN".."Text"]:SetText("Show Buff Border")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["BORDER_BUFF"]) end)
	CheckBox:SetScript("OnClick", function(self) MPB_Data["BORDER_BUFF"] = not MPB_Data["BORDER_BUFF"] end)
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_BORDER_DEBUFF_SHOWN", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_CB_BORDER_BUFF_SHOWN", "TOPLEFT", 0, -14)
	_G["MPB_CB_BORDER_DEBUFF_SHOWN".."Text"]:SetText("Show Debuff Border")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["BORDER_DEBUFF"]) end)
	CheckBox:SetScript("OnClick", function(self) MPB_Data["BORDER_DEBUFF"] = not MPB_Data["BORDER_DEBUFF"] end)
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_CD_INDICATOR_SHOWN", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_CB_BORDER_DEBUFF_SHOWN", "TOPLEFT", 0, -14)
	_G["MPB_CB_CD_INDICATOR_SHOWN".."Text"]:SetText("Show Cooldown Indicator")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["COOLDOWN_INDICATOR"]) end)
	CheckBox:SetScript("OnClick", function(self) MPB_Data["COOLDOWN_INDICATOR"] = not MPB_Data["COOLDOWN_INDICATOR"] end)
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_DURATION_SHOWN", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", 10, -126)
	_G["MPB_CB_DURATION_SHOWN".."Text"]:SetText("Show Buff Durations")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["DURATION_SHOWN"]) end)
	CheckBox:SetScript("OnClick", function(self) MPB_Data["DURATION_SHOWN"] = not MPB_Data["DURATION_SHOWN"] end)
	
	Label = MPB_Options:CreateFontString("MPB_FS_DURATION_WARNING", "ARTWORK", "GameFontNormal")
	Label:SetPoint("TOPLEFT", "MPB_CB_DURATION_SHOWN", "TOPLEFT", 0, -18)
	Label:SetTextColor(1,1,1) 
	Label:SetText("Duration Warning:")
		
	CheckBox = CreateFrame("CheckButton", "MPB_CB_DURATION_WARNING_1", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_FS_DURATION_WARNING", "TOPLEFT", 108, 2)
	_G["MPB_CB_DURATION_WARNING_1".."Text"]:SetText("Disabled")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["DURATION_WARNING_TIME"] == 0) end)
	CheckBox:SetScript("OnClick", function(self) 
		MPB_Data["DURATION_WARNING_TIME"] = 0
		for i=1,6 do
			getglobal("MPB_CB_DURATION_WARNING_"..i):SetChecked(false)
		end
		self:SetChecked(true)
	end)

	CheckBox = CreateFrame("CheckButton", "MPB_CB_DURATION_WARNING_2", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_FS_DURATION_WARNING", "TOPLEFT", 0, -14)
	_G["MPB_CB_DURATION_WARNING_2".."Text"]:SetText("10s")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["DURATION_WARNING_TIME"] == 10) end)
	CheckBox:SetScript("OnClick", function(self) 
		MPB_Data["DURATION_WARNING_TIME"] = 10
		for i=1,6 do
			getglobal("MPB_CB_DURATION_WARNING_"..i):SetChecked(false)
		end
		self:SetChecked(true)
	end)
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_DURATION_WARNING_3", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_FS_DURATION_WARNING", "TOPLEFT", 40, -14)
	_G["MPB_CB_DURATION_WARNING_3".."Text"]:SetText("15s")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["DURATION_WARNING_TIME"] == 15) end)
	CheckBox:SetScript("OnClick", function(self) 
		MPB_Data["DURATION_WARNING_TIME"] = 15
		for i=1,6 do
			getglobal("MPB_CB_DURATION_WARNING_"..i):SetChecked(false)
		end
		self:SetChecked(true)
	end)
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_DURATION_WARNING_4", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_FS_DURATION_WARNING", "TOPLEFT", 80, -14)
	_G["MPB_CB_DURATION_WARNING_4".."Text"]:SetText("30s")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["DURATION_WARNING_TIME"] == 30) end)
	CheckBox:SetScript("OnClick", function(self) 
		MPB_Data["DURATION_WARNING_TIME"] = 30
		for i=1,6 do
			getglobal("MPB_CB_DURATION_WARNING_"..i):SetChecked(false)
		end
		self:SetChecked(true)
	end)
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_DURATION_WARNING_5", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_FS_DURATION_WARNING", "TOPLEFT", 120, -14)
	_G["MPB_CB_DURATION_WARNING_5".."Text"]:SetText("45s")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["DURATION_WARNING_TIME"] == 45) end)
	CheckBox:SetScript("OnClick", function(self) 
		MPB_Data["DURATION_WARNING_TIME"] = 45
		for i=1,6 do
			getglobal("MPB_CB_DURATION_WARNING_"..i):SetChecked(false)
		end
		self:SetChecked(true)
	end)
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_DURATION_WARNING_6", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_FS_DURATION_WARNING", "TOPLEFT", 160, -14)
	_G["MPB_CB_DURATION_WARNING_6".."Text"]:SetText("60s")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["DURATION_WARNING_TIME"] == 60) end)
	CheckBox:SetScript("OnClick", function(self) 
		MPB_Data["DURATION_WARNING_TIME"] = 60
		for i=1,6 do
			getglobal("MPB_CB_DURATION_WARNING_"..i):SetChecked(false)
		end
		self:SetChecked(true)
	end)
	
	Label = MPB_Options:CreateFontString("MPB_FS_DURATION_WARNING_HINT", "ARTWORK", "GameFontNormal")
	Label:SetPoint("TOPLEFT", "MPB_FS_DURATION_WARNING", "TOPLEFT", 0, -32) 
	Label:SetText("|cFFBEBEBE(turns duration text to white color)|r")
	Label:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
	
	
	
	
	Label = MPB_Options:CreateFontString("MPB_FS_FLASH_EXPIRING", "ARTWORK", "GameFontNormal")
	Label:SetPoint("TOPLEFT", 210, -30)
	Label:SetTextColor(1,1,1) 
	Label:SetText("Flash Expiring:")
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_FLASH_EXPIRING_1", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_FS_FLASH_EXPIRING", "TOPLEFT", 86, 2)
	_G["MPB_CB_FLASH_EXPIRING_1".."Text"]:SetText("Disabled")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["FLASH_EXPIRING_MODE"] == 1) end)
	CheckBox:SetScript("OnClick", function(self)
		for i=1,4 do
			getglobal("MPB_CB_FLASH_EXPIRING_"..i):SetChecked(false)
		end
		self:SetChecked(true)
		MPB_Data["FLASH_EXPIRING_MODE"] = 1
	end)
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_FLASH_EXPIRING_2", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_FS_FLASH_EXPIRING", "TOPLEFT", 0, -14)
	_G["MPB_CB_FLASH_EXPIRING_2".."Text"]:SetText("Buffs")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["FLASH_EXPIRING_MODE"] == 2) end)
	CheckBox:SetScript("OnClick", function(self)
		for i=1,4 do
			getglobal("MPB_CB_FLASH_EXPIRING_"..i):SetChecked(false)
		end
		self:SetChecked(true)
		MPB_Data["FLASH_EXPIRING_MODE"] = 2
	end)
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_FLASH_EXPIRING_3", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_FS_FLASH_EXPIRING", "TOPLEFT", 46, -14)
	_G["MPB_CB_FLASH_EXPIRING_3".."Text"]:SetText("Debuffs")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["FLASH_EXPIRING_MODE"] == 3) end)
	CheckBox:SetScript("OnClick", function(self)
		for i=1,4 do
			getglobal("MPB_CB_FLASH_EXPIRING_"..i):SetChecked(false)
		end
		self:SetChecked(true)
		MPB_Data["FLASH_EXPIRING_MODE"] = 3
	end)
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_FLASH_EXPIRING_4", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_FS_FLASH_EXPIRING", "TOPLEFT", 104, -14)
	_G["MPB_CB_FLASH_EXPIRING_4".."Text"]:SetText("Both")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["FLASH_EXPIRING_MODE"] == 4) end)
	CheckBox:SetScript("OnClick", function(self)
		for i=1,4 do
			getglobal("MPB_CB_FLASH_EXPIRING_"..i):SetChecked(false)
		end
		self:SetChecked(true)
		MPB_Data["FLASH_EXPIRING_MODE"] = 4
	end)
	
	Label = MPB_Options:CreateFontString("MPB_FS_FLASH_EXPIRING_TIME", "ARTWORK", "GameFontNormal")
	Label:SetPoint("TOPLEFT", "MPB_FS_FLASH_EXPIRING", "TOPLEFT", 0, -32)
	Label:SetTextColor(0.7,0.7,0.7) 
	Label:SetText("Time:")
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_FLASH_EXPIRING_TIME_1", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_FS_FLASH_EXPIRING_TIME", "TOPLEFT", 32, 3)
	_G["MPB_CB_FLASH_EXPIRING_TIME_1".."Text"]:SetText("10s")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["FLASH_EXPIRING_TIME"] == 10) end)
	CheckBox:SetScript("OnClick", function(self)
		for i=1,4 do
			getglobal("MPB_CB_FLASH_EXPIRING_TIME_"..i):SetChecked(false)
		end
		self:SetChecked(true)
		MPB_Data["FLASH_EXPIRING_TIME"] = 10
	end)
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_FLASH_EXPIRING_TIME_2", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_CB_FLASH_EXPIRING_TIME_1", "TOPLEFT", 36, 0)
	_G["MPB_CB_FLASH_EXPIRING_TIME_2".."Text"]:SetText("20s")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["FLASH_EXPIRING_TIME"] == 20) end)
	CheckBox:SetScript("OnClick", function(self)
		for i=1,4 do
			getglobal("MPB_CB_FLASH_EXPIRING_TIME_"..i):SetChecked(false)
		end
		self:SetChecked(true)
		MPB_Data["FLASH_EXPIRING_TIME"] = 20
	end)
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_FLASH_EXPIRING_TIME_3", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_CB_FLASH_EXPIRING_TIME_2", "TOPLEFT", 36, 0)
	_G["MPB_CB_FLASH_EXPIRING_TIME_3".."Text"]:SetText("30s")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["FLASH_EXPIRING_TIME"] == 30) end)
	CheckBox:SetScript("OnClick", function(self)
		for i=1,4 do
			getglobal("MPB_CB_FLASH_EXPIRING_TIME_"..i):SetChecked(false)
		end
		self:SetChecked(true)
		MPB_Data["FLASH_EXPIRING_TIME"] = 30
	end)
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_FLASH_EXPIRING_TIME_4", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_CB_FLASH_EXPIRING_TIME_3", "TOPLEFT", 36, 0)
	_G["MPB_CB_FLASH_EXPIRING_TIME_4".."Text"]:SetText("60s")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["FLASH_EXPIRING_TIME"] == 60) end)
	CheckBox:SetScript("OnClick", function(self)
		for i=1,4 do
			getglobal("MPB_CB_FLASH_EXPIRING_TIME_"..i):SetChecked(false)
		end
		self:SetChecked(true)
		MPB_Data["FLASH_EXPIRING_TIME"] = 60
	end)
	
	Label = MPB_Options:CreateFontString("MPB_FS_FLASH_EXPIRING_PERIOD", "ARTWORK", "GameFontNormal")
	Label:SetPoint("TOPLEFT", "MPB_FS_FLASH_EXPIRING_TIME", "TOPLEFT", 0, -13)
	Label:SetTextColor(0.7,0.7,0.7) 
	Label:SetText("Period:")
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_FLASH_EXPIRING_PERIOD_1", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_FS_FLASH_EXPIRING_PERIOD", "TOPLEFT", 40, 3)
	_G["MPB_CB_FLASH_EXPIRING_PERIOD_1".."Text"]:SetText("1s")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["FLASH_EXPIRING_PERIOD"] == 1) end)
	CheckBox:SetScript("OnClick", function(self)
		for i=1,4 do
			getglobal("MPB_CB_FLASH_EXPIRING_PERIOD_"..i):SetChecked(false)
		end
		self:SetChecked(true)
		MPB_Data["FLASH_EXPIRING_PERIOD"] = 1
	end)
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_FLASH_EXPIRING_PERIOD_2", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_CB_FLASH_EXPIRING_PERIOD_1", "TOPLEFT", 34, 0)
	_G["MPB_CB_FLASH_EXPIRING_PERIOD_2".."Text"]:SetText("1.5s")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["FLASH_EXPIRING_PERIOD"] == 1.5) end)
	CheckBox:SetScript("OnClick", function(self)
		for i=1,4 do
			getglobal("MPB_CB_FLASH_EXPIRING_PERIOD_"..i):SetChecked(false)
		end
		self:SetChecked(true)
		MPB_Data["FLASH_EXPIRING_PERIOD"] = 1.5
	end)
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_FLASH_EXPIRING_PERIOD_3", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_CB_FLASH_EXPIRING_PERIOD_2", "TOPLEFT", 38, 0)
	_G["MPB_CB_FLASH_EXPIRING_PERIOD_3".."Text"]:SetText("2s")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["FLASH_EXPIRING_PERIOD"] == 2) end)
	CheckBox:SetScript("OnClick", function(self)
		for i=1,4 do
			getglobal("MPB_CB_FLASH_EXPIRING_PERIOD_"..i):SetChecked(false)
		end
		self:SetChecked(true)
		MPB_Data["FLASH_EXPIRING_PERIOD"] = 2
	end)
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_FLASH_EXPIRING_PERIOD_4", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_CB_FLASH_EXPIRING_PERIOD_3", "TOPLEFT", 34, 0)
	_G["MPB_CB_FLASH_EXPIRING_PERIOD_4".."Text"]:SetText("3s")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["FLASH_EXPIRING_PERIOD"] == 3) end)
	CheckBox:SetScript("OnClick", function(self)
		for i=1,4 do
			getglobal("MPB_CB_FLASH_EXPIRING_PERIOD_"..i):SetChecked(false)
		end
		self:SetChecked(true)
		MPB_Data["FLASH_EXPIRING_PERIOD"] = 3
	end)
	
	Label = MPB_Options:CreateFontString("MPB_FS_FLASH_EXPIRING_MIN_ALPHA", "ARTWORK", "GameFontNormal")
	Label:SetPoint("TOPLEFT", "MPB_FS_FLASH_EXPIRING_PERIOD", "TOPLEFT", 0, -13)
	Label:SetTextColor(0.7,0.7,0.7) 
	Label:SetText("Min. Alpha:")
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_FLASH_EXPIRING_MIN_ALPHA_1", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_FS_FLASH_EXPIRING_MIN_ALPHA", "TOPLEFT", 65, 3)
	_G["MPB_CB_FLASH_EXPIRING_MIN_ALPHA_1".."Text"]:SetText("0.2s")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["FLASH_EXPIRING_MIN_ALPHA"] == 0.2) end)
	CheckBox:SetScript("OnClick", function(self)
		for i=1,3 do
			getglobal("MPB_CB_FLASH_EXPIRING_MIN_ALPHA_"..i):SetChecked(false)
		end
		self:SetChecked(true)
		MPB_Data["FLASH_EXPIRING_MIN_ALPHA"] = 0.2
	end)
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_FLASH_EXPIRING_MIN_ALPHA_2", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_CB_FLASH_EXPIRING_MIN_ALPHA_1", "TOPLEFT", 39, 0)
	_G["MPB_CB_FLASH_EXPIRING_MIN_ALPHA_2".."Text"]:SetText("0.4s")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["FLASH_EXPIRING_MIN_ALPHA"] == 0.4) end)
	CheckBox:SetScript("OnClick", function(self)
		for i=1,3 do
			getglobal("MPB_CB_FLASH_EXPIRING_MIN_ALPHA_"..i):SetChecked(false)
		end
		self:SetChecked(true)
		MPB_Data["FLASH_EXPIRING_MIN_ALPHA"] = 0.4
	end)
	
	CheckBox = CreateFrame("CheckButton", "MPB_CB_FLASH_EXPIRING_MIN_ALPHA_3", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_CB_FLASH_EXPIRING_MIN_ALPHA_2", "TOPLEFT", 39, 0)
	_G["MPB_CB_FLASH_EXPIRING_MIN_ALPHA_3".."Text"]:SetText("0.6s")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["FLASH_EXPIRING_MIN_ALPHA"] == 0.6) end)
	CheckBox:SetScript("OnClick", function(self)
		for i=1,3 do
			getglobal("MPB_CB_FLASH_EXPIRING_MIN_ALPHA_"..i):SetChecked(false)
		end
		self:SetChecked(true)
		MPB_Data["FLASH_EXPIRING_MIN_ALPHA"] = 0.6
	end)
	
	Label = MPB_Options:CreateFontString("MPB_FS_CASTER", "ARTWORK", "GameFontNormal")
	Label:SetPoint("TOPLEFT", 210, -104)
	Label:SetTextColor(1,1,1)
	Label:SetText("Caster Display:")
	
	CheckBox = CreateFrame("CheckButton", "CASTER_DISPLAY_MODE_1", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_FS_CASTER", "TOPLEFT", 90, 2)
	_G["CASTER_DISPLAY_MODE_1".."Text"]:SetText("Never")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["CASTER_DISPLAY_MODE"] == 1) end)
	CheckBox:SetScript("OnClick", function(self)
		for i=1,3 do
			getglobal("CASTER_DISPLAY_MODE_"..i):SetChecked(false)
		end
		self:SetChecked(true)
		MPB_Data["CASTER_DISPLAY_MODE"] = 1
		MPBuffs:UpdateChanges()
	end)
	
	CheckBox = CreateFrame("CheckButton", "CASTER_DISPLAY_MODE_2", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_FS_CASTER", "TOPLEFT", 0, -14)
	_G["CASTER_DISPLAY_MODE_2".."Text"]:SetText("On Mouse Hover")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["CASTER_DISPLAY_MODE"] == 2) end)
	CheckBox:SetScript("OnClick", function(self)
		for i=1,3 do
			getglobal("CASTER_DISPLAY_MODE_"..i):SetChecked(false)
		end
		self:SetChecked(true)
		MPB_Data["CASTER_DISPLAY_MODE"] = 2
		MPBuffs:UpdateChanges()
	end)
	
	CheckBox = CreateFrame("CheckButton", "CASTER_DISPLAY_MODE_3", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_FS_CASTER", "TOPLEFT", 102, -14)
	_G["CASTER_DISPLAY_MODE_3".."Text"]:SetText("Always")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["CASTER_DISPLAY_MODE"] == 3) end)
	CheckBox:SetScript("OnClick", function(self)
		for i=1,3 do
			getglobal("CASTER_DISPLAY_MODE_"..i):SetChecked(false)
		end
		self:SetChecked(true)
		MPB_Data["CASTER_DISPLAY_MODE"] = 3
		MPBuffs:UpdateChanges()
	end)
	
	Label = MPB_Options:CreateFontString("MPB_FS_CASTER_DISPLAY_LETTERS", "ARTWORK", "GameFontNormal")
	Label:SetPoint("TOPLEFT", 210, -138)
	Label:SetTextColor(1,1,1)
	Label:SetText("Caster Number of Letters:")
	
	CheckBox = CreateFrame("CheckButton", "CASTER_DISPLAY_LETTERS_1", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_FS_CASTER_DISPLAY_LETTERS", "TOPLEFT", 0, -14)
	_G["CASTER_DISPLAY_LETTERS_1".."Text"]:SetText("Three (3)")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["CASTER_DISPLAY_LETTERS"] == 3) end)
	CheckBox:SetScript("OnClick", function(self)
		for i=1,3 do
			getglobal("CASTER_DISPLAY_LETTERS_"..i):SetChecked(false)
		end
		self:SetChecked(true)
		MPB_Data["CASTER_DISPLAY_LETTERS"] = 3
	end)
	
	CheckBox = CreateFrame("CheckButton", "CASTER_DISPLAY_LETTERS_2", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_FS_CASTER_DISPLAY_LETTERS", "TOPLEFT", 64, -14)
	_G["CASTER_DISPLAY_LETTERS_2".."Text"]:SetText("Four (4)")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["CASTER_DISPLAY_LETTERS"] == 4) end)
	CheckBox:SetScript("OnClick", function(self)
		for i=1,3 do
			getglobal("CASTER_DISPLAY_LETTERS_"..i):SetChecked(false)
		end
		self:SetChecked(true)
		MPB_Data["CASTER_DISPLAY_LETTERS"] = 4
	end)
	
	CheckBox = CreateFrame("CheckButton", "CASTER_DISPLAY_LETTERS_3", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", "MPB_FS_CASTER_DISPLAY_LETTERS", "TOPLEFT", 122, -14)
	_G["CASTER_DISPLAY_LETTERS_3".."Text"]:SetText("Five (5)")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["CASTER_DISPLAY_LETTERS"] == 5) end)
	CheckBox:SetScript("OnClick", function(self)
		for i=1,3 do
			getglobal("CASTER_DISPLAY_LETTERS_"..i):SetChecked(false)
		end
		self:SetChecked(true)
		MPB_Data["CASTER_DISPLAY_LETTERS"] = 5
	end)
	
	
	
	CheckBox = CreateFrame("CheckButton", "MPB_FS_CASTER_TOOLTIP_DISPLAY", MPB_Options, "UICheckButtonTemplate")
	CheckBox:SetWidth(20)
	CheckBox:SetHeight(20)
	CheckBox:SetPoint("TOPLEFT", 210, -172)
	_G["MPB_FS_CASTER_TOOLTIP_DISPLAY".."Text"]:SetText("Show Tooltips On Mouse Hover")
	CheckBox:SetScript("OnShow",  function(self) self:SetChecked(MPB_Data["TOOLTIP_DISPLAY"]) end)
	CheckBox:SetScript("OnClick", function(self)
		MPB_Data["TOOLTIP_DISPLAY"] = not MPB_Data["TOOLTIP_DISPLAY"]
	end)
end