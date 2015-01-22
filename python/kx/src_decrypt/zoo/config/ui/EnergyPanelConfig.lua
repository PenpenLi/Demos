

-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013Äê10ÔÂ29ÈÕ  0:37:21
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- EnergyPanelConfig
---------------------------------------------------

local config = {
	initY = 115 - 30
}

EnergyPanelConfig = class()

function EnergyPanelConfig:ctor()
end

function EnergyPanelConfig:init(energyPanel, ...)
	assert(energyPanel)
	assert(#{...} == 0)

	self.energyPanel = energyPanel
end

function EnergyPanelConfig:getInitY(...)
	assert(#{...} == 0)

	assert(config.initY)
	return config.initY
end

function EnergyPanelConfig:create(energyPanel, ...)
	assert(energyPanel)
	assert(#{...} == 0)

	local newEnergyPanelConfig = EnergyPanelConfig.new()
	newEnergyPanelConfig:init(energyPanel)
	return newEnergyPanelConfig
end
