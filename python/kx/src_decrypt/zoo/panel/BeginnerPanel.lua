require "zoo.panel.basePanel.BasePanel"
require "zoo.net.OnlineGetterHttp"
require "zoo.baseUI.ButtonWithShadow"

BeginnerPanel = class(BasePanel)

function BeginnerPanel:create()
	local panel = BeginnerPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.BeginnerPanel)
	if panel:init() then
		return panel
	else
		panel = nil
		return nil
	end
end

function BeginnerPanel:isBaiduPlatform()
	if PlatformConfig:isBaiduPlatform() then
		return true
	end
	return false
end

function BeginnerPanel:init()
	self.rewardList = MetaManager.getInstance():getNewUserRewards()

	self.ui = self:buildInterfaceGroup("BeginnerPanel") 
	BasePanel.init(self, self.ui)
	self.panelName = "beginnerPanel"
	self:setPositionForPopoutManager()

	self.bg = self.ui:getChildByName("_bg")
	self.captain = self.ui:getChildByName("captain")
	self.cmtText = self.ui:getChildByName("cmtText")
	self.avlText = self.ui:getChildByName("avlText")
	self.btnGet = self.ui:getChildByName("btnGet")
	assert(self.captain)
	self.items = {}
	for i = 1, 5 do
		self.items[i] = self.ui:getChildByName("item"..(i - 1))
	end
	self.btnGet = GroupButtonBase:create(self.btnGet)

	if PlatformConfig:isPlatform(PlatformNameEnum.kCMGame) and DcUtil.getSubPlatform and DcUtil.getSubPlatform() == "he201507211442349840" then --江西移动活动
		self.captain:setText(Localization:getInstance():getText("beginner.panel.title"))
		self.cmtText:setString(Localization:getInstance():getText("enter.invite.code.panel.des.jxyd"))
	elseif self:isBaiduPlatform() then
		self.captain:setText(Localization:getInstance():getText("beginner.panel.title.baidu"))
		self.cmtText:setString(Localization:getInstance():getText("beginner.panel.cmt.text.baidu"))
	elseif PlatformConfig:isQQPlatform() then
		self.captain:setText(Localization:getInstance():getText("activity.gift.center.panel.title"))
		self.cmtText:setString(Localization:getInstance():getText("beginner.panel.cmt.text"))
	else
		self.captain:setText(Localization:getInstance():getText("beginner.panel.title"))
		self.cmtText:setString(Localization:getInstance():getText("beginner.panel.cmt.text"))
	end
	local capSize = self.captain:getContentSize()
	local capScale = 65 / capSize.height
	self.captain:setScale(capScale)
	local bgSize = self.bg:getGroupBounds().size
	self.captain:setPositionX((bgSize.width - capSize.width * capScale) / 2 + self.bg:getPositionX())

	self.avlText:setString(Localization:getInstance():getText("beginner.panel.avl.time"))
	self.btnGet:setString(Localization:getInstance():getText("beginner.panel.btn.get.text"))
	for i = 1, 5 do
		local sprite
		if self.rewardList[i].itemId == ItemType.COIN then
			sprite = Sprite:createWithSpriteFrameName("iconHeap_4uy30000")
			sprite:setAnchorPoint(ccp(0, 1))
		else
			sprite = ResourceManager:sharedInstance():buildItemGroup(self.rewardList[i].itemId)
		end
		local icon = self.items[i]:getChildByName("icon")
		local num = self.items[i]:getChildByName("num")

		local numFS = self.items[i]:getChildByName("num_fontSize")
		local label = TextField:createWithUIAdjustment(numFS, num)
		self.items[i]:addChild(label)
		local pos = icon:getPosition()
		if i == 1 then
			sprite:setScale(1.2)
		else
			sprite:setScale(0.8)
		end
		sprite:setPosition(ccp(pos.x, pos.y))
		icon:getParent():addChildAt(sprite, 1)
		icon:removeFromParentAndCleanup(true)
		label:setString("x"..self.rewardList[i].num)
	end

	local function onGetTouched()
		self:getPresents()
	end
	self.btnGet:ad(DisplayEvents.kTouchTap, onGetTouched)

	self:initOnePlusUI();
	return true
end

function BeginnerPanel:initOnePlusUI()
	local function hideOnePlusLogo()
		local onePlusLogo = self.ui:getChildByName("onePlusLogo")
		if onePlusLogo then
			onePlusLogo:setVisible(false)
		end
	end
	if StartupConfig:getInstance():getPlatformName()=="oppo" then
		local actInfo = table.find(UserManager:getInstance().actInfos or {},function(v)
			return v.actId == 7
		end)
		if actInfo then
			self.captain:setText(Localization:getInstance():getText("activity.school.new.user.title"))
			self.cmtText:setString(Localization:getInstance():getText("activity.school.new.user.desc"))
			local capSize = self.captain:getContentSize()
			local capScale = 65 / capSize.height
			self.captain:setScale(capScale)
			local bgSize = self.bg:getGroupBounds().size
			self.captain:setPositionX((bgSize.width - capSize.width * capScale) / 2 + self.bg:getPositionX())
		else
			hideOnePlusLogo()
		end
	else
		hideOnePlusLogo()
	end
end

function BeginnerPanel:getPresents()
	local context = self 

	local function onGetRewardComplete(evt)
		UserManager:getInstance().userExtend:setNewUserReward(1)
		local rewards = evt.data
		if rewards and #rewards > 0 then
			self:openPackage()
			if self.getCallback then
				self.getCallback()
			end
		else
			PopoutManager:sharedInstance():remove(context, true)
		end
	end

	local function onGetRewardError(err)
		PopoutManager:sharedInstance():remove(context, true)
	end

	local http = GetNewUserRewardsHttp.new()
	http:addEventListener(Events.kComplete, onGetRewardComplete)
	http:addEventListener(Events.kError, onGetRewardComplete)
	http:load()
end

function BeginnerPanel:openPackage()
	local vSize = Director:sharedDirector():getVisibleSize()
	local vOrigin = Director:sharedDirector():getVisibleOrigin()
	local home = HomeScene:sharedInstance()
	local width, spare = 60, 30
	local fullWidth = 5 * width + 4 * spare
	local startX = (vSize.width - fullWidth) / 2
	-- 无限精力
	local function onOver()

		-- show tip for beginner
		local scene = HomeScene:sharedInstance()
		scene.energyButton:showTip()
		scene:checkDataChange()

		local logic = UseEnergyBottleLogic:create(ItemType.INFINITE_ENERGY_BOTTLE)
		logic:start(true)
	end
	local sprite = home:createFlyingEnergyAnim(true)
	sprite:setPosition(ccp(startX + vOrigin.x, vSize.height / 2 + vOrigin.y))
	sprite:playFlyToAnim(onOver)
	-- 银币
	sprite = home:createFlyingCoinAnim()
	sprite:setPosition(ccp(startX + width + spare + vOrigin.x, vSize.height / 2 + vOrigin.y))
	sprite:playFlyToAnim(false, false)
	-- 其他道具
	for i = 1, #self.rewardList do
		if self.rewardList[i].itemId ~= ItemType.COIN and self.rewardList[i].itemId ~= ItemType.INFINITE_ENERGY_BOTTLE then
			sprite = home:createFloatingItemAnim(self.rewardList[i].itemId)
			sprite:setPosition(ccp(startX + (i - 1) * (width + spare) + vOrigin.x, vSize.height / 2 + vOrigin.y))
			sprite:playFlyToAnim(false)
		end
	end

	PopoutManager:sharedInstance():remove(self, true)
end

function BeginnerPanel:setGetCallback(callback)
	self.getCallback = callback
end

function BeginnerPanel:popout()
	PopoutQueue:sharedInstance():push(self)
end

function BeginnerPanel:getHCenterInScreenX(...)
	assert(#{...} == 0)

	local visibleSize	= CCDirector:sharedDirector():getVisibleSize()
	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
	local selfWidth		= 718

	local deltaWidth	= visibleSize.width - selfWidth
	local halfDeltaWidth	= deltaWidth / 2

	return visibleOrigin.x + halfDeltaWidth
end