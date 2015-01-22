UpdateSJSuccessPanel = class(BasePanel)
function UpdateSJSuccessPanel:create(reward, sjRewards)
	local panel = UpdateSJSuccessPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.update_new_version_panel)
	panel:init(reward, sjRewards)

	return panel
end

function UpdateSJSuccessPanel:init(reward, sjRewardList)

	local visibleSize	= CCDirector:sharedDirector():getVisibleSize()
	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
	
	
	self.updateReward = reward
	self.sjRewardList = sjRewardList
	self.ui = self:buildInterfaceGroup('UpdateSuccessSjPanel')
	BasePanel.init(self, self.ui)
	self:setPositionForPopoutManager()

	self:initText()
	self:initReward()
	self:initButton()
end

function UpdateSJSuccessPanel:initText( ... )
	-- body
	local title = self.ui:getChildByName("title")
	title:setText(Localization:getInstance():getText("sj.update.get.reward.title"))
	local titleSize = title:getContentSize()
	local titleScale = 65 / titleSize.height
	title:setScale(titleScale)
	local bg = self.ui:getChildByName("bg")
	local bgSize = bg:getGroupBounds().size
	title:setPositionX((bgSize.width - titleSize.width * titleScale) / 2)

	local content_key = "update.award.normal"
	if self.sjRewardList and #self.sjRewardList > 0 then
		content_key = "sj.update.get.reward"
	end
	local contentText = self.ui:getChildByName("content_txt")
	contentText:setString(Localization:getInstance():getText(content_key))
end

function UpdateSJSuccessPanel:initReward( ... )
	-- body
	local reward_container = self.ui:getChildByName("rewards")
	self.rewardList = {}
	if self.updateReward then
		table.insert(self.rewardList, self.updateReward)
	end

	if self.sjRewardList then
		for k, v in pairs(self.sjRewardList) do
			table.insert(self.rewardList, v)
		end
	end

	local rewardItemList = {}
	for k=1, 6 do
		local rewardItem = reward_container:getChildByName("reward"..k)
		local size =  rewardItem:getGroupBounds().size 
		if k <= #self.rewardList then
			local reward = self.rewardList[k]
			local image = ResourceManager:sharedInstance():buildItemSprite(reward.itemId)
			image:setAnchorPoint(ccp(0.5,0.5))
			image:setPosition(ccp(size.width/2, -size.height/2))
			image.name = "image"
			rewardItem:addChildAt(image, 1)
			local num = rewardItem:getChildByName("num_text")
			num:setText("x" .. tostring(reward.num))
			local numContentSize = num:getContentSize()
			num:setPositionX((size.width - numContentSize.width)/2)
			reward.itemShow = rewardItem
		else
			rewardItem:setVisible(false)
		end
		rewardItemList[k] = rewardItem
	end

	---重新排列
	local parentSize = reward_container:getGroupBounds().size
	self:resetPositon(rewardItemList, parentSize)
end

function UpdateSJSuccessPanel:resetPositon( rewardItemList , parentSize)
	-- body
	local rewardItemSize = rewardItemList[1]:getGroupBounds().size
	local maxItem = math.min(#self.rewardList, 6) 
	local xList = {}
	for k = 1, 3 do 
		xList[k] = rewardItemList[k]:getPositionX()
	end
	local y = (rewardItemSize.height - parentSize.height)/2
	if maxItem == 1 then
		rewardItemList[1]:setPosition(ccp((parentSize.width - rewardItemSize.width)/2, y))
	elseif maxItem == 2 then
		rewardItemList[1]:setPosition(ccp((xList[2]+xList[1])/2, y))
		rewardItemList[2]:setPosition(ccp((xList[3]+xList[2])/2, y))
	elseif maxItem == 3 then
		for k = 1, 3 do
			rewardItemList[k]:setPositionY(y) 
		end
	elseif maxItem == 4 then
		rewardItemList[1]:setPositionX((xList[2] + xList[1])/2)
		rewardItemList[2]:setPositionX((xList[3] + xList[2])/2)
		rewardItemList[3]:setPosition(ccp((xList[2]+ xList[1])/2, rewardItemList[4]:getPositionY()))
		rewardItemList[4]:setPositionX((xList[3] + xList[2])/2)
	elseif maxItem == 5 then
		rewardItemList[4]:setPositionX((xList[2]+xList[1])/2)
		rewardItemList[5]:setPositionX((xList[3]+xList[2])/2)
	end
end

function UpdateSJSuccessPanel:initButton( ... )
	-- body
	self.okBtn = GroupButtonBase:create(self.ui:getChildByName('okBtn'))
	self.okBtn:setEnabled(true)
	self.okBtn:setString(Localization:getInstance():getText('sj.update.get.reward.button'))-- '领取'
	local function onTab( ... )
		-- body
		self:onOkTapped()
	end
	self.okBtn:addEventListener(DisplayEvents.kTouchTap, onTab)
end

function UpdateSJSuccessPanel:popout()
	PopoutManager:sharedInstance():addWithBgFadeIn(self, true, false, false)
	self.allowBackKeyTap = true
end

function UpdateSJSuccessPanel:onCloseBtnTapped()
	PopoutManager:sharedInstance():removeWithBgFadeOut(self, false)
	self.allowBackKeyTap = false
end

function UpdateSJSuccessPanel:onOkTapped()

	self.okBtn:setEnabled(false)

	local v = self.rewardList
	if #self.rewardList == 0  then 
		self:onCloseBtnTapped()		
		return
	end

	local function onSuccess( evt )
		local i = 0
		for k, v in pairs(self.rewardList) do 
			local config = {numer=1,updateButton=true}
			function config.finishCallback( ... )
				i = i + 1 
				if i >= #self.rewardList then
					self:onCloseBtnTapped()
					HomeScene:sharedInstance():checkDataChange()
					UserManager.getInstance().updateReward = nil
					local sjRewards = UserManager.getInstance().sjRewards
					if sjRewards and #sjRewards > 0 then
						MarkModel:getInstance():resetMarkInfo()
					end
					UserManager.getInstance().sjRewards = nil
					if evt and evt.data and evt.data.unlockArea then
						NewVersionUtil:showUnlockCloudTip(evt.data.unlockArea)
					end
					
				end
			end
			local anim = nil
			if v.itemId == 14 then 
				anim = HomeSceneFlyToAnimation:sharedInstance():goldFlyToAnimation(config)
				UserManager:getInstance().user:setCash(UserManager:getInstance().user:getCash() + v.num)
				UserService:getInstance().user:setCash(UserService:getInstance().user:getCash() + v.num)
			elseif v.itemId == 2 then 
				anim = HomeSceneFlyToAnimation:sharedInstance():coinStackAnimation(config)
				UserManager:getInstance().user:setCoin(UserManager:getInstance().user:getCoin() + v.num)
				UserService:getInstance().user:setCoin(UserService:getInstance().user:getCoin() + v.num)
			else
				config.propId = v.itemId
				anim = HomeSceneFlyToAnimation:sharedInstance():jumpToBagAnimation(config)
				UserManager:getInstance():addUserPropNumber(v.itemId, v.num)
				UserService:getInstance():addUserPropNumber(v.itemId, v.num)
			end

			local sprites = (v.itemId == 2 and {anim.sprites}) or anim.sprites
			local image = v.itemShow:getChildByName("image")
			local numText = v.itemShow:getChildByName("num_text")
			for k, v2 in ipairs(sprites) do
				v2:setAnchorPoint(ccp(0.5,0.5))
				local pos = image:getPositionInWorldSpace()
				v2:setScale(image:getContentSize().width/v2:getContentSize().width)
				v2:setPosition(pos)
				Director.sharedDirector():getRunningScene():addChild(v2)
			end
			anim:play()
			if image then image:setVisible(false) end
			if numText then numText:setVisible(false) end 
		end
	end
	local function onFail( evt ) 
		
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(evt.data)), "negative")
		self:onCloseBtnTapped()

	   	UserManager.getInstance().updateReward = nil
	end
	local http = GetUpdateRewardHttp.new(true)
	http:ad(Events.kComplete, onSuccess)
	http:ad(Events.kError, onFail)
	http:load()
end