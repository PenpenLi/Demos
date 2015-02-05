require "zoo.panel.ChooseFriendPanel"

ChooseNotiFriendPanel = class(ChooseFriendPanel)

function ChooseNotiFriendPanel:ctor()
	self.shareNotiList = nil
end

function ChooseNotiFriendPanel:init(onConfirmCallback,shareNotiList)
	self.shareNotiList = shareNotiList
	if ChooseFriendPanel.init(self, onConfirmCallback, {}) then 
		return true
	end
end

function ChooseNotiFriendPanel:create(onConfirmCallback,shareNotiList)
	local panel = ChooseNotiFriendPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.AskForEnergyPanel)
	if panel:init(onConfirmCallback, shareNotiList) then
		print("return true, panel should been shown")
		return panel
	else
		print("return false, panel's been destroyed")
		panel = nil
		return nil
	end
end