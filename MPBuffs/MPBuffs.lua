MPBuffs = CreateFrame("Frame")
MPBuffs.Title = "|cFF00CC33MP Buffs|r"
MPBuffs.Version = "v1.0"
MPBuffs.ClassColors = {["DEATHKNIGHT"] = "C41F3B", ["DRUID"] = "FF7D0A", ["HUNTER"] = "ABD473", ["MAGE"] = "69CCF0", ["PALADIN"] = "F58CBA", ["PRIEST"] = "FFFFFF", ["ROGUE"] = "FFF569", ["SHAMAN"] = "0070DE", ["WARLOCK"] = "9482C9", ["WARRIOR"] = "C79C6E"}
MPBuffs.DebuffTypeColor = {
	["none"]	= {r = 0.8, g = 0, b = 0},
	["Magic"]	= {r = 0.2, g = 0.6, b = 1},
	["Curse"]	= {r = 0.6, g = 0, b = 1},
	["Disease"]	= {r = 0.6, g = 0.4, b = 0},
	["Poison"]	= {r = 0, g = 0.6, b = 0},
}
function MPBuffs:Load()
	MPB_Data = MPB_Data or {
		["ENABLED"] = true, 
		-- Buff Display options
		-- Duration
		["DURATION_SHOWN"] = true,
		["DURATION_WARNING_TIME"] = 60,
		["DURATION_SIZE"] = 10,
		-- Border
		["BORDER_BUFF"] = true,
		["BORDER_COLOR_BUFF"] = {0,0,0},
		["BORDER_DEBUFF"] = true,
		["BORDER_COLOR_DEBUFF"] = {0.8,0,0},
		["BORDER_COLOR_DEBUFF_MAGIC"] = {0.2,0.6,1},
		["BORDER_COLOR_DEBUFF_CURSE"] = {0.6,0,1},
		["BORDER_COLOR_DEBUFF_DISEASE"] = {0.6,0.4,0},
		["BORDER_COLOR_DEBUFF_POISON"] = {0,0.6,0},
		-- Caster
		["CASTER_DISPLAY_MODE"] = 2, -- 1 = NEVER, 2 = ON MOUSE HOVER, 3 = ALWAYS
		["CASTER_DISPLAY_LETTERS"] = 4, -- MIN 3, MAX 5
		["CASTER_SIZE"] = 10,
		-- Count (Stacks)
		["COUNT_SIZE"] = 12,
		
		["COOLDOWN_INDICATOR"] = true,
		["FLASH_EXPIRING_MODE"] = 2, -- 1 = DISABLED, 2 = BUFFS ONLY, 3 = DEBUFFS ONLY, 4 = BUFF AND DEBUFFS
		["FLASH_EXPIRING_TIME"] = 30,
		["FLASH_EXPIRING_PERIOD"] = 2,
		["FLASH_EXPIRING_MIN_ALPHA"] = 0.2,
		
		["BUFF_PER_ROW"] = 8,
		["BUFF_MAX_DISPLAY"] = 32,
		["DEBUFF_PER_ROW"] = 8,
		["DEBUFF_MAX_DISPLAY"] = 16,
		
		["TOOLTIP_DISPLAY"] = true,
	}
	
	self.Frame = CreateFrame("Frame", "MPB_Frame")
	self.Frame:SetPoint("TOPRIGHT", -180, -13)
	self.Frame:SetScript("OnUpdate", function(self, elapsed) if MPB_Data["ENABLED"] then MPBuffs:OnUpdate(self, elapsed) end end)
	self.Frame:SetWidth(200)
	self.Frame:SetHeight(32)
	
	self.EnchantFrame = CreateFrame("Frame", "MPB_EnchantFrame")
	self.EnchantFrame:SetPoint("TOPRIGHT", nil, "TOPRIGHT", -180, -13)
	self.EnchantFrame:SetWidth(36)
	self.EnchantFrame:SetHeight(36)
	self.Enchant1 = self:CreateButton("MPB_Enchant1", self.EnchantFrame)
	self.Enchant1:SetPoint("TOPRIGHT", 0, 0)
	self.Enchant2 = self:CreateButton("MPB_Enchant2", self.EnchantFrame)
	self.Enchant2:SetPoint("RIGHT", "MPB_Enchant1", "LEFT", -5, 0)
	self.EnchantFrame:SetScript("OnUpdate", function() if MPB_Data["ENABLED"] then MPBuffs:Enchant_OnUpdate() end end)
	
	self:Toggled()
end

function MPBuffs:Toggled()
	if MPB_Data["ENABLED"] then
		BuffFrame:UnregisterEvent("UNIT_AURA")
		BuffFrame:Hide()
		TemporaryEnchantFrame:Hide()
		
		self.Frame:Show()
		self.EnchantFrame:Show()
		self:RegisterEvent("UNIT_AURA")
	else
		self.Frame:Hide()
		self.EnchantFrame:Hide()
		self:UnregisterEvent("UNIT_AURA")
		
		BuffFrame:Show()
		BuffFrame:RegisterEvent("UNIT_AURA")
		TemporaryEnchantFrame:Show()
	end
end

MPBuffs.LastUpdate = 0
function MPBuffs:OnUpdate(self, elapsed)
	MPBuffs.LastUpdate = MPBuffs.LastUpdate + elapsed
	if MPBuffs.LastUpdate < 0.1 then return end
	MPBuffs.LastUpdate = MPBuffs.LastUpdate - 0.1
	MPBuffs:Update()
end

function MPBuffs:UNIT_AURA(self, event, ...)
	local unit = ...
	if unit == "player" then
		self:Update()
	end
end

MPBuffs.BuffCount = 0
MPBuffs.DebuffCount = 0
function MPBuffs:Update()
	self.BuffCount = 0
	for i=1,MPB_Data["BUFF_MAX_DISPLAY"] do
		if self:UpdateAura("MPB_Buff", i, "HELPFUL") then
			self.BuffCount = self.BuffCount + 1
		end
	end

	self.DebuffCount = 0
	for i=1,MPB_Data["DEBUFF_MAX_DISPLAY"] do
		if self:UpdateAura("MPB_Debuff", i, "HARMFUL") then
			self.DebuffCount = self.DebuffCount + 1
		end
	end
	
	self:UpdateAnchors()
end

function MPBuffs:UpdateAura(ButtonName, AuraIndex, Filter)
	local Unit = UnitName("player")
	local Name, Rank, Texture, Count, DebuffType, Duration, ExpirationTime, UnitCaster = UnitAura(Unit, AuraIndex, Filter)

	local BuffName = ButtonName..AuraIndex
	local Buff = getglobal(BuffName)
	
	if not Name then
		if Buff then
			Buff:Hide()
			Buff.Overlay:Hide()
			Buff.Cooldown:Hide()
			if Buff.Overlay then
				Buff.Overlay:Hide()
			end
		end
		return
	else
		Buff = self:CreateButton(BuffName)
		
		if Count > 1 then
			Buff.Overlay.Count:SetText(Count)
			Buff.Overlay.Count:Show()
		else
			Buff.Overlay.Count:Hide()
		end
		
		local CasterName, Color
		if not UnitCaster then
			CasterName = "Unknown"
			Color = "FFFFFF"
		elseif UnitCaster == "pet" then
			CasterName = UnitName("player")
			Color = self.ClassColors[strupper(select(2,UnitClass("player")))]
		elseif UnitCaster:sub(1,8) == "partypet" then
			UnitCaster = "raid"..UnitCaster:sub(9)
			CasterName = UnitName(UnitCaster)
			Color = self.ClassColors[strupper(select(2,UnitClass(UnitCaster)))]
		elseif UnitCaster:sub(1,7) == "raidpet" then
			UnitCaster = "raid"..UnitCaster:sub(8)
			CasterName = UnitName(UnitCaster)
			Color = self.ClassColors[strupper(select(2,UnitClass(UnitCaster)))]
		elseif UnitCaster:sub(1,5) == "party" or UnitCaster:sub(1,4) == "raid" or UnitCaster:sub(1,6) == "player" then
			CasterName = UnitName(UnitCaster)
			Color = self.ClassColors[strupper(select(2,UnitClass(UnitCaster)))]
		else
			CasterName = UnitCaster and UnitName(UnitCaster) or nil
			Color = "FFFFFF"
		end
		Buff.Overlay.Caster:SetText("|cFF"..Color..string.sub(CasterName or "Unknown",1,MPB_Data["CASTER_DISPLAY_LETTERS"]).."|r")
		if MPB_Data["CASTER_DISPLAY_MODE"] == 3 then
			Buff.Overlay.Caster:Show()
		end
		
		Buff:RegisterForClicks("RightButtonUp")
		Buff.Duration = Duration
		Buff.ExpirationTime = ExpirationTime
		Buff.NamePrefix = ButtonName
		Buff:SetID(AuraIndex)
		Buff.Helpful = Filter == "HELPFUL"
		Buff.Unit = Unit
		Buff.Filter = Filter
		Buff:SetAlpha(1)
		Buff:Show()
		Buff.Overlay:Show()
		
		Buff:SetScript("OnEnter", function(self)
			if MPB_Data["CASTER_DISPLAY_MODE"] == 2 then self.Overlay.Caster:Show() end
			if MPB_Data["TOOLTIP_DISPLAY"] then GameTooltip:SetOwner(Buff, "ANCHOR_BOTTOMLEFT") end
			end)
		Buff:SetScript("OnLeave", function(self)
			if MPB_Data["CASTER_DISPLAY_MODE"] == 2 then self.Overlay.Caster:Hide() end
			GameTooltip:Hide()
		end)
		
		local DisplayBorder = Buff.Helpful and MPB_Data["BORDER_BUFF"] or not Buff.Helpful and MPB_Data["BORDER_DEBUFF"]
		local BuffBorder = getglobal(BuffName.."Border")
		if DisplayBorder then
			local Color
			if Buff.Helpful then
				Color = {r = 0, g = 0, b = 0}
			elseif DebuffType then
				Color = self.DebuffTypeColor[DebuffType]
			else
				Color = self.DebuffTypeColor["none"]
			end
			BuffBorder:SetVertexColor(Color.r, Color.g, Color.b)
			BuffBorder:Show()
		else
			BuffBorder:Hide()
		end
		
		Buff:SetScript("OnClick", function(self, button)
			if (button == "RightButton") then
				CancelUnitBuff("player", self:GetID(), self.Filter)
			end
		end)

		if Duration > 0 and ExpirationTime then
			if not Buff.TimeLeft then
				Buff.TimeLeft = ExpirationTime - GetTime()
				Buff:SetScript("OnUpdate", function(self, elapsed) MPBuffs:BuffButton_OnUpdate(self, elapsed) end)
			else
				Buff.TimeLeft = ExpirationTime - GetTime()
			end
			Buff.Overlay.Duration:Show()
		else
			local Icon = getglobal(BuffName.."Icon")
			Icon:SetAlpha(1)
			Buff.Cooldown:SetAlpha(1)
			Buff.Cooldown:Hide()
			Buff.Overlay.Duration:Hide()
			Buff:SetScript("OnUpdate", nil)
			Buff.TimeLeft = nil
		end
		
		getglobal(BuffName.."Icon"):SetTexture(Texture)
				
		if GameTooltip:IsOwned(Buff) then
			GameTooltip:SetUnitAura(Unit, AuraIndex, Filter)
		end
	end
	return true
end

function MPBuffs:CreateButton(ButtonName, Parent)	
	local Button = getglobal(ButtonName)
	if not Button then
		Button = CreateFrame("Button", ButtonName, Parent or self.Frame, "DebuffButtonTemplate")
	
		Button.Cooldown = CreateFrame("Cooldown", nil, Button, "CooldownFrameTemplate")
		Button.Cooldown:SetAllPoints()
		Button.Cooldown:SetReverse(true)
		Button.Cooldown:SetDrawEdge(true)
		
		Button.Overlay = CreateFrame("Frame", nil, Button)
		Button.Overlay:SetAllPoints()
		
		Button.Overlay.Duration = Button.Overlay:CreateFontString(nil, "OVERLAY", "GameTooltipText")
		Button.Overlay.Duration:SetPoint("TOP", Button, "BOTTOM", 0, -2) 
		Button.Overlay.Duration:SetFont("Fonts\\FRIZQT__.TTF", MPB_Data["DURATION_SIZE"], "OUTLINE")
		Button.Overlay.Duration:Hide()
		
		Button.Overlay.Count = Button.Overlay:CreateFontString(nil, "OVERLAY", "GameTooltipText")
		Button.Overlay.Count:SetPoint("BOTTOMRIGHT", -2, 2)
		Button.Overlay.Count:SetFont("Fonts\\FRIZQT__.TTF", MPB_Data["COUNT_SIZE"], "OUTLINE")
		Button.Overlay.Count:Hide()
		
		Button.Overlay.Caster = Button.Overlay:CreateFontString(nil, "OVERLAY", "GameTooltipText")
		Button.Overlay.Caster:SetPoint("TOP", 0, -2)
		Button.Overlay.Caster:SetFont("Fonts\\FRIZQT__.TTF", MPB_Data["CASTER_SIZE"], "OUTLINE")
		Button.Overlay.Caster:Hide()
	end
	return Button
end

function MPBuffs:BuffButton_OnUpdate(self, elapsed)		
	local M = MPB_Data["FLASH_EXPIRING_MODE"]
	local DoFlash = (M == 4 or self.Helpful and M == 2 or not self.Helpful and M == 3) and self.TimeLeft < MPB_Data["FLASH_EXPIRING_TIME"]
	
	local Icon = getglobal(self:GetName().."Icon")
	local P, mA = MPB_Data["FLASH_EXPIRING_PERIOD"], MPB_Data["FLASH_EXPIRING_MIN_ALPHA"]
	
	Icon:SetAlpha(DoFlash and math.abs((GetTime()%P)-P/2)*(1-mA)+mA or 1)
	self.Cooldown:SetAlpha(DoFlash and math.abs((GetTime()%P)-P/2)*(1-mA)+mA or 1)
	
	-- Update duration
	MPBuffs:UpdateDuration(self)
	self.TimeLeft = max(self.TimeLeft - elapsed, 0)
end

function MPBuffs:UpdateDuration(Buff)
	if MPB_Data["COOLDOWN_INDICATOR"] and Buff.TimeLeft and Buff.Helpful and Buff.Duration and Buff.ExpirationTime and Buff.ExpirationTime > 0 then
		Buff.Cooldown:SetCooldown(Buff.ExpirationTime - Buff.Duration, Buff.Duration)
	else
		Buff.Cooldown:Hide()		
	end

	if MPB_Data["DURATION_SHOWN"] and Buff.TimeLeft then
		Buff.Overlay.Duration:SetText(self:TimeToString(Buff.TimeLeft))
		local Color = Buff.TimeLeft < MPB_Data["DURATION_WARNING_TIME"] and HIGHLIGHT_FONT_COLOR or NORMAL_FONT_COLOR
		Buff.Overlay.Duration:SetTextColor(Color.r, Color.g, Color.b)
		Buff.Overlay.Duration:Show()
	else
		Buff.Overlay.Duration:Hide()
	end
end

function MPBuffs:Enchant_OnUpdate()
	local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges = GetWeaponEnchantInfo()
	
	if not hasMainHandEnchant and not hasOffHandEnchant then
		getglobal("MPB_Enchant1"):Hide()
		getglobal("MPB_Enchant2"):Hide()
		self.Frame:SetPoint("TOPRIGHT", self.EnchantFrame, "TOPRIGHT", 0, 0)
		return
	end
	
	local enchantIndex = 0
	if hasOffHandEnchant then
		enchantIndex = enchantIndex + 1
		local EnchantButton = getglobal("MPB_Enchant1")
		local EnchantButtonBorder = getglobal("MPB_Enchant1Border")
		local EnchantButtonIcon = getglobal("MPB_Enchant1Icon")
		EnchantButton:SetID(17)
		
		EnchantButton.Helpful = true
		
		EnchantButton:RegisterForClicks("RightButtonUp")
		EnchantButton:SetAlpha(1)
		EnchantButton:Show()
		
		EnchantButton:SetScript("OnEnter", function(self) if MPB_Data["TOOLTIP_DISPLAY"] then GameTooltip:SetOwner(EnchantButton, "ANCHOR_BOTTOMLEFT") end end)
		EnchantButton:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
		
		if MPB_Data["BORDER_BUFF"] then
			EnchantButtonBorder:SetVertexColor(0.7, 0, 0.7) --199/255,21/255,133/255
			EnchantButtonBorder:Show()
		else
			EnchantButtonBorder:Hide()
		end
		
		EnchantButton:SetScript("OnClick", function(self, button) if (button == "RightButton") then CancelItemTempEnchantment(2) end end)
		
		if offHandExpiration then
			offHandExpiration = offHandExpiration/1000
			
			if not EnchantButton.TimeLeft then
				EnchantButton.TimeLeft = offHandExpiration
				EnchantButton:SetScript("OnUpdate", function(self, elapsed) MPBuffs:BuffButton_OnUpdate(self, elapsed) end)
			else
				EnchantButton.TimeLeft = offHandExpiration
			end
			EnchantButton.Overlay.Duration:Show()
		else
			EnchantButtonIcon:SetAlpha(1)
			EnchantButton.Cooldown:SetAlpha(1)
			EnchantButton.Cooldown:Hide()
			EnchantButton.Overlay.Duration:Hide()
			EnchantButton:SetScript("OnUpdate", nil)
			EnchantButton.TimeLeft = nil
		end
		
		EnchantButtonIcon:SetTexture(GetInventoryItemTexture("player", 17))
		
		if GameTooltip:IsOwned(EnchantButton) then
			GameTooltip:SetOwner(EnchantButton, "ANCHOR_BOTTOMLEFT")
			GameTooltip:SetInventoryItem("player", EnchantButton:GetID())
		end
	end
	if hasMainHandEnchant then
		enchantIndex = enchantIndex + 1
		local EnchantButton = getglobal("MPB_Enchant"..enchantIndex)
		local EnchantButtonBorder = getglobal("MPB_Enchant"..enchantIndex.."Border")
		local EnchantButtonIcon = getglobal("MPB_Enchant"..enchantIndex.."Icon")
		EnchantButton:SetID(16)
		
		EnchantButton.Helpful = true
		
		EnchantButton:RegisterForClicks("RightButtonUp")
		EnchantButton:SetAlpha(1)
		EnchantButton:Show()
		
		EnchantButton:SetScript("OnEnter", function(self) if MPB_Data["TOOLTIP_DISPLAY"] then GameTooltip:SetOwner(EnchantButton, "ANCHOR_BOTTOMLEFT") end end)
		EnchantButton:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
		
		
		if MPB_Data["BORDER_BUFF"] then
			EnchantButtonBorder:SetVertexColor(0.7, 0, 0.7) --199/255,21/255,133/255
			EnchantButtonBorder:Show()
		else
			EnchantButtonBorder:Hide()
		end
		
		EnchantButton:SetScript("OnClick", function(self, button) if (button == "RightButton") then CancelItemTempEnchantment(1) end end)
		
		if mainHandExpiration then
			mainHandExpiration = mainHandExpiration/1000
			
			if not EnchantButton.TimeLeft then
				EnchantButton.TimeLeft = mainHandExpiration
				EnchantButton:SetScript("OnUpdate", function(self, elapsed) MPBuffs:BuffButton_OnUpdate(self, elapsed) end)
			else
				EnchantButton.TimeLeft = mainHandExpiration
			end
			EnchantButton.Overlay.Duration:Show()
		else
			EnchantButtonIcon:SetAlpha(1)
			EnchantButton.Cooldown:SetAlpha(1)
			EnchantButton.Cooldown:Hide()
			EnchantButton.Overlay.Duration:Hide()
			EnchantButton:SetScript("OnUpdate", nil)
			EnchantButton.TimeLeft = nil
		end

		EnchantButtonIcon:SetTexture(GetInventoryItemTexture("player", 16))
				
		if GameTooltip:IsOwned(EnchantButton) then
			GameTooltip:SetOwner(EnchantButton, "ANCHOR_BOTTOMLEFT")
			GameTooltip:SetInventoryItem("player", EnchantButton:GetID())
		end
	end
	
	for i=enchantIndex+1, 2 do
		getglobal("MPB_Enchant"..i):Hide()
	end
	
	self.EnchantFrame:SetWidth(enchantIndex*32)
	self.Frame:SetPoint("TOPRIGHT", self.EnchantFrame, "TOPLEFT", -5, 0)
end

function MPBuffs:TimeToString(Time)
	Time = Time >= 0 and Time or 0
	if Time < 60 then
		return string.format("%0.1fs",self:Round(Time,1))
	elseif Time < 3600 then
		return self:Round(Time/60,0,true).."m"
	elseif Time < 3600*24 then
		return self:Round(Time/3600,0,true).."h"
	else
		return self:Round(Time/(3600*24),0,true).."d"
	end
end

function MPBuffs:Round(num, idp, up)
	if not num then return 0 end
	local mult = 10^(idp or 0)
	return math.floor(num * mult + (up and 0.99 or 0.5)) / mult
end

function MPBuffs:UpdateAnchors()
	local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges = GetWeaponEnchantInfo()
	local Enchants = (hasMainHandEnchant and 1 or 0) + (hasOffHandEnchant and 1 or 0)
	
	for i=1,self.BuffCount do
		local Buff = getglobal("MPB_Buff"..i)
		Buff:ClearAllPoints()
		if i > 1 and mod(i+Enchants,MPB_Data["BUFF_PER_ROW"]) == 1 then -- MPB_Data["BUFF_PER_ROW"] 
			if i+Enchants == MPB_Data["BUFF_PER_ROW"]+1 then
				Buff:SetPoint("TOP", self.Enchant1, "BOTTOM", 0, SHOW_BUFF_DURATIONS == "1" and -19 or -6)
			else
				Buff:SetPoint("TOP", getglobal("MPB_Buff"..(i-MPB_Data["BUFF_PER_ROW"])), "BOTTOM", 0, SHOW_BUFF_DURATIONS == "1" and -19 or -6)
			end
		elseif i == 1 then
			Buff:SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", 0, 0)
		else
			Buff:SetPoint("RIGHT", getglobal("MPB_Buff"..(i-1)), "LEFT", -5, 0)
		end
	end
	
	local rows = ceil((self.BuffCount+Enchants)/MPB_Data["BUFF_PER_ROW"])
	
	for i=1,self.DebuffCount do
		local Debuff = getglobal("MPB_Debuff"..i)
		Debuff:ClearAllPoints()
		if i > 1 and mod(i, MPB_Data["DEBUFF_PER_ROW"]) == 1 then
			Debuff:SetPoint("TOP", getglobal("MPB_Debuff"..(i-MPB_Data["DEBUFF_PER_ROW"])), "BOTTOM", 0, -15)
		elseif i == 1 then
			if rows < 2 then
				Debuff:SetPoint("TOPRIGHT", getglobal("MPB_Enchant1"), "BOTTOMRIGHT", 0, -1*((2*15)+30))
			else
				Debuff:SetPoint("TOPRIGHT", getglobal("MPB_Enchant1"), "BOTTOMRIGHT", 0, -rows*(15+30))
			end
		else
			Debuff:SetPoint("RIGHT", getglobal("MPB_Debuff"..(i-1)), "LEFT", -5, 0)
		end
	end
end

function MPBuffs:UpdateChanges()
	if MPB_Data["CASTER_DISPLAY_MODE"] == 3 then
		MPBuffs.Enchant1.Overlay.Caster:Show()
		MPBuffs.Enchant2.Overlay.Caster:Show()
	else
		MPBuffs.Enchant1.Overlay.Caster:Hide()
		MPBuffs.Enchant2.Overlay.Caster:Hide()
	end
	MPBuffs.Enchant1.Overlay.Caster:SetFont("Fonts\\FRIZQT__.TTF", MPB_Data["CASTER_SIZE"], "OUTLINE")
	MPBuffs.Enchant2.Overlay.Caster:SetFont("Fonts\\FRIZQT__.TTF", MPB_Data["CASTER_SIZE"], "OUTLINE")
		
	for i=1,40 do
		Buff = getglobal("MPB_Buff"..i)
		if not Buff then Buff = getglobal("MPB_Debuff"..i) end
		if not Buff then break end
		if MPB_Data["CASTER_DISPLAY_MODE"] == 3 then
			Buff.Overlay.Caster:Show()
		else
			Buff.Overlay.Caster:Hide()
		end
		Buff.Overlay.Caster:SetFont("Fonts\\FRIZQT__.TTF", MPB_Data["CASTER_SIZE"], "OUTLINE")
	end
end

MPBuffs:SetScript("OnEvent", function(self, event, ...)
	self[event](self, ...)
end)

function SlashCmdList.MPBUFFS(msg, editbox)
	if not MPB_Options:IsVisible() then
		MPB_Options:Show()
	else
		MPB_Options:Hide()
	end
end

function MPBuffs:ADDON_LOADED(addon)
	if addon ~= "MPBuffs" then return end
	self:Load()
	MPB_Options:Load()
	SLASH_MPBUFFS1 = '/mpb';
	print("|cFF00CC33MP Buffs|r ("..self.Version..") Loaded!")
end

MPBuffs:RegisterEvent("ADDON_LOADED")