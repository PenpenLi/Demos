
HiddenBranchIntroductionPanel = class(BasePanel)

function HiddenBranchIntroductionPanel:init(tip)

	tip = tip or "hide.area.infor.panel.desc.1"

	local panel = GameGuideUI:panelSD(tip,true)
	BasePanel.init(self,panel)

	-- self.ui:setPositionY(-250)

	self.ui:setPositionY(-80)

	panel.ui:setTouchEnabled(true)
	panel.ui.hitTestPoint = function( ... )
		return true
	end
	panel.ui:addEventListener(DisplayEvents.kTouchTap,function( ... )
		self:onConfirmTapped()
	end)

	-- self.ui = self:buildInterfaceGroup("HiddenBranchGuidePanel") 
	-- BasePanel.init(self, self.ui)

	-- self.bg = self.ui:getChildByName("bg")
	-- self.confirmBtn = self.ui:getChildByName("confirmBtn")
	-- self.confirmBtn = GroupButtonBase:create(self.confirmBtn) 
	-- self.confirmBtn:setString(Localization:getInstance():getText("hide.area.infor.panel.btn"))
	-- self.descLabel1 = self.ui:getChildByName("label1")
	-- self.descLabel2 = self.ui:getChildByName("label2")
	-- self.descLabel1:setString(Localization:getInstance():getText("hide.area.infor.panel.desc.1"))
	-- self.descLabel2:setString(Localization:getInstance():getText("hide.area.infor.panel.desc.2"))

	-- self:setPositionForPopoutManager()

	-- local function onConfirmTapped(event)
	-- 	self:onConfirmTapped()
	-- end
	-- self.confirmBtn:ad(DisplayEvents.kTouchTap, onConfirmTapped)
end

function HiddenBranchIntroductionPanel:onConfirmTapped()
	self:markAutoPopoutFlag()
	PopoutManager:sharedInstance():remove(self, true)
end

function HiddenBranchIntroductionPanel:markAutoPopoutFlag()
	Cookie.getInstance():write(CookieKey.kHiddenAreaIntroduction, "true")
end

-- function HiddenBranchIntroductionPanel:getHCenterInScreenX(...)
-- 	assert(#{...} == 0)

-- 	local visibleSize	= CCDirector:sharedDirector():getVisibleSize()
-- 	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
-- 	local selfWidth		= 705.95

-- 	local deltaWidth	= visibleSize.width - selfWidth
-- 	local halfDeltaWidth	= deltaWidth / 2

-- 	return visibleOrigin.x + halfDeltaWidth
-- end

function HiddenBranchIntroductionPanel:create(tip)
	local v = HiddenBranchIntroductionPanel.new()
	-- v:loadRequiredResource(PanelConfigFiles.unlock_hidden_area_panel)
	v:init(tip)
	return v
end