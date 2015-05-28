require 'zoo.panel.share.ShareBasePanel'
require 'zoo.panel.share.ChooseNotiFriendPanel'

SharePassFriendPanel = class(ShareBasePanel)

function SharePassFriendPanel:ctor()

end

function SharePassFriendPanel:init()
	--初始化文案内容
	self.shareTitleName	= Localization:getInstance():getText(self.shareTitleKey)
	ShareBasePanel.init(self, self.shareType, self.shareTitleName)
	if self.passFriendType == PassFriendType.SCORE then
		local currentLevel = ShareManager.data.level
		local userName = UserManager.getInstance().profile.name
		self.notyMessage = Localization:getInstance():getText(self.shareNotiKey,{friend = userName,num = currentLevel})
	elseif self.passFriendType == PassFriendType.LEVEL then
		local userName = UserManager.getInstance().profile.name
		self.notyMessage = Localization:getInstance():getText(self.shareNotiKey,{friend = userName})
	end
	
	self:runFlyBirdAction()
	self:runNpcAction()
	self:runCircleLightAction()
	self:runStarParticle()
	self:runStarGroup3Action()
end

local function getDayStartTimeByTS(ts)
	local utc8TimeOffset = 57600 -- (24 - 8) * 3600
	local oneDaySeconds = 86400 -- 24 * 3600
	return ts - ((ts - utc8TimeOffset) % oneDaySeconds)
end

local function now()
	return os.time() + (__g_utcDiffSeconds or 0)
end
--override
function SharePassFriendPanel:onShareBtnTapped()
	ShareBasePanel.onShareBtnTapped(self,self.shareId)
	if not __IOS_FB then 
		local notiTypeId = LocalNotificationType.kSharePassFriendScore 
		if self.passFriendType == PassFriendType.SCORE then
			DcUtil:UserTrack({category = "show", sub_category = "push_show_off_button_110"})
		elseif self.passFriendType == PassFriendType.LEVEL then
			notiTypeId = LocalNotificationType.kSharePassFriendLevel
			DcUtil:UserTrack({category = "show", sub_category = "push_show_off_button_120"})
		end
		
		-- On Friend Choosed
		local function onFriendChoose(friendIds)
			if friendIds and #friendIds>0 then 
				local function onPushSuccess(event)
					--向后端同步
					local function onSuccess(event)
				        CommonTip:showTip(Localization:getInstance():getText("show_off_to_friend_success"), "positive")
				        --打点
				        --发银币奖励
				        if self.rewardConfig then 
					      	UserManager:getInstance().user:setCoin(UserManager:getInstance().user:getCoin() + self.rewardConfig.rewardNum)
							UserService:getInstance().user:setCoin(UserService:getInstance().user:getCoin() + self.rewardConfig.rewardNum)
						end
						--记录炫耀次数
        				ShareManager:increaseShareAllTime()
				        --关闭
				        self:removePopout()
				    end

				    local function onFail(event)
				        self:showFaildTip("show_off_to_friend_fail")
				        --关闭
				        self:removePopout()
				    end
				    
				    local http = OpNotifyHttp.new()
				    http:ad(Events.kComplete, onSuccess)
				    http:ad(Events.kError, onFail)
				    http:load(OpNotifyType.kXuanYao)
				end
				local function onPushFail()
					self:showFaildTip("show_off_to_friend_fail")
				end

				local targetTime = now()
				-- local now = os.time()
				-- local dayStartTime = getDayStartTimeByTS(now)
				-- if now > dayStartTime + 10 * 3600 then
				-- 	targetTime = dayStartTime + 24 * 3600 + 10 * 3600
				-- else
				-- 	targetTime = dayStartTime + 10 * 3600
				-- end
				local http = PushNotifyHttp.new()
				http:load(friendIds, self.notyMessage, notiTypeId, targetTime * 1000)
				http:ad(Events.kComplete, onPushSuccess)
			    http:ad(Events.kError, onPushFail)
			end
		end

		-- Pop Out Choose Friend Panel
		local panel = ChooseNotiFriendPanel:create(onFriendChoose, self.passedFriendIds)
		panel:popout()
	end
end

function SharePassFriendPanel:showFaildTip(strKey)
	local scene = Director:sharedDirector():getRunningScene()
	if scene then
		local item = RequireNetworkAlert.new(CCNode:create())
		item:buildUI(Localization:getInstance():getText(strKey))
		scene:addChild(item)  
	end
end

function SharePassFriendPanel:runFlyBirdAction()
	local flyAnimalUi = self.ui:getChildByName("flyAnimal")
	if flyAnimalUi then 
		flyAnimalUi:setOpacity(0)
		--flyAnimalUi:setScale(0)
		flyAnimalUi:setAnchorPointWhileStayOriginalPosition(ccp(0.5, 0.5))

		local oriPos = flyAnimalUi:getPosition()
		flyAnimalUi:setPosition(ccp(oriPos.x, oriPos.y-150))
		local sequenceArr = CCArray:create()
		local spwanArr = CCArray:create()
		spwanArr:addObject(CCEaseBackOut:create(CCMoveBy:create(0.2, ccp(0, 150))))
		spwanArr:addObject(CCFadeTo:create(0.2, 255))
		--spwanArr:addObject(CCScaleTo:create(0.2, 1))
		sequenceArr:addObject(CCSpawn:create(spwanArr))
		sequenceArr:addObject(CCDelayTime:create(0.5))
		local spwanArr2 = CCArray:create()
		spwanArr2:addObject(CCRotateBy:create(0.5,-720))
		spwanArr2:addObject(CCJumpBy:create(0.5,ccp(-500,300),200,1))
		sequenceArr:addObject(CCSpawn:create(spwanArr2))
		flyAnimalUi:stopAllActions();
		flyAnimalUi:runAction(CCSequence:create(sequenceArr));
	end
end

function SharePassFriendPanel:runNpcAction()
	local npcUi = self.ui:getChildByName("npc")
	if npcUi then
		npcUi:setOpacity(0)
		npcUi:setAnchorPointWhileStayOriginalPosition(ccp(0.5, 0))

		local oriPos = npcUi:getPosition()
		npcUi:setPosition(ccp(oriPos.x+20, oriPos.y-300))
		local sequenceArr = CCArray:create()
		local delayTime = CCDelayTime:create(0.6)
		local spwanArr = CCArray:create()
		spwanArr:addObject(CCEaseBackOut:create(CCMoveBy:create(0.3, ccp(-20, 300))))
		spwanArr:addObject(CCFadeTo:create(0.3, 255))
		sequenceArr:addObject(delayTime)
		sequenceArr:addObject(CCSpawn:create(spwanArr))

		npcUi:stopAllActions();
		npcUi:runAction(CCSequence:create(sequenceArr));
	end
end

function SharePassFriendPanel:runCircleLightAction()
	local circleLightUi = self.ui:getChildByName("circleLightBg")
	if circleLightUi then 
		parentUiPos = circleLightUi:getPosition()
		local bg = circleLightUi:getChildByName("bg")
		local posAdjust = circleLightUi:getPosition()
		bg:setAnchorPointCenterWhileStayOrigianlPosition(ccp(posAdjust.x-40,posAdjust.y+120))
		bg:setOpacity(0)
		local sequenceArr = CCArray:create()
		sequenceArr:addObject(CCDelayTime:create(0.8))
		sequenceArr:addObject(CCFadeTo:create(0.1, 255))

		bg:stopAllActions()
		bg:runAction(CCSequence:create(sequenceArr))
		bg:runAction((CCRepeatForever:create(CCRotateBy:create(0.1, 6))))

		local light = circleLightUi:getChildByName("bg1")
		light:setAnchorPointCenterWhileStayOrigianlPosition()
		light:setOpacity(0)
		local sequenceArr1 = CCArray:create()
		sequenceArr1:addObject(CCDelayTime:create(0.8))
		local function fadeCallBack()
			light:setOpacity(50)
		end
		sequenceArr1:addObject(CCCallFunc:create(fadeCallBack))
		sequenceArr1:addObject(CCScaleTo:create(0.7, 4.5))
		light:stopAllActions()
		light:runAction(CCSequence:create(sequenceArr1))

		local circle = circleLightUi:getChildByName("bg2")
		circle:setAnchorPointCenterWhileStayOrigianlPosition()
		circle:setOpacity(0)
		local sequenceArr2 = CCArray:create()
		sequenceArr2:addObject(CCDelayTime:create(0.8))
		local function fadeCallBack()
			circle:setOpacity(255)
		end
		sequenceArr2:addObject(CCCallFunc:create(fadeCallBack))
		local spwanArr = CCArray:create()
		spwanArr:addObject(CCScaleTo:create(0.5, 4.5))
		spwanArr:addObject(CCFadeOut:create(0.5))
		sequenceArr2:addObject(CCSpawn:create(spwanArr))
		circle:stopAllActions()
		circle:runAction(CCSequence:create(sequenceArr2))
	end
end

function SharePassFriendPanel:runStarParticle()
	if not _G.__use_low_effect then
		local function addParticle()
			local particle = ParticleSystemQuad:create("share/star1.plist")
			particle:setPosition(ccp(370,-440))
			local childIndex = self.ui:getChildIndex(self.ui:getChildByName("npc"))
			self.ui:addChildAt(particle, childIndex)	
		end 
		self.ui:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.8), CCCallFunc:create(addParticle)))
	end
end

function SharePassFriendPanel:runStarGroup3Action()
	local starGroup3 = self.ui:getChildByName("starGroup3")
	if starGroup3 then 
		local starGroup3Table = {}
		for i=1,5 do
			local whiteStar = {}
			whiteStar.ui = starGroup3:getChildByName("star"..i)
			whiteStar.ui:setAnchorPointCenterWhileStayOrigianlPosition()
			whiteStar.ui:setOpacity(0)
			
			if i==1 then 
				whiteStar.delayTime = 0.7
				whiteStar.oriScale = whiteStar.ui:getScale()
				--whiteStar.
			elseif i==2 then 
				whiteStar.delayTime = 1.1
				whiteStar.oriScale = whiteStar.ui:getScale()
			elseif i==3 then 
				whiteStar.delayTime = 0.7
				whiteStar.oriScale = whiteStar.ui:getScale()
			elseif i==4 then 
				whiteStar.delayTime = 0.9
				whiteStar.oriScale = whiteStar.ui:getScale()
			elseif i==5 then
				whiteStar.delayTime = 1.1
				whiteStar.oriScale = whiteStar.ui:getScale()
			end
			whiteStar.ui:setScale(0)
			table.insert(starGroup3Table, whiteStar)
		end

		for i,v in ipairs(starGroup3Table) do
			local sequenceArr = CCArray:create()
			local delayTime = CCDelayTime:create(v.delayTime)
			local spwanArr1 = CCArray:create()
			local spwanArr2 = CCArray:create()
			local tempTime = 0.4
			spwanArr1:addObject(CCFadeTo:create(tempTime, 255))
			spwanArr1:addObject(CCScaleTo:create(tempTime, v.oriScale))
			spwanArr1:addObject(CCRotateBy:create(tempTime*3, 270))
			spwanArr2:addObject(CCFadeTo:create(tempTime, 0))
			spwanArr2:addObject(CCScaleTo:create(tempTime, 0))
			spwanArr2:addObject(CCRotateBy:create(tempTime*3, 270))

			sequenceArr:addObject(delayTime)
			sequenceArr:addObject(CCSpawn:create(spwanArr1))
			sequenceArr:addObject(CCSpawn:create(spwanArr2))
			
			v.ui:stopAllActions();
			v.ui:runAction(CCSequence:create(sequenceArr));
		end
	end
end

function SharePassFriendPanel:create(shareId, shareType, shareNotiKey, shareTitleKey, passFriendType)
	local friendInfos = nil
	if passFriendType==PassFriendType.SCORE then 
		friendInfos = ShareManager:getShareData(ShareManager.ConditionType.OVER_FRIEND_TABLE)
	elseif passFriendType==PassFriendType.LEVEL then 
		friendInfos = ShareManager:getShareData(ShareManager.ConditionType.LEVEL_OVER_FRIEND_TABLE)
	end
	-- if friendInfos then
	-- 	passedFriendIds = {}
	-- 	for i,v in ipairs(friendInfos) do
	-- 	 	table.insert(passedFriendIds,v.uid)
	-- 	end 
	-- else
	-- 	print("error=====================SharePassFriendPanel.passedFriendIds is null") 
	-- 	return nil
	-- end
	local panel = SharePassFriendPanel.new()
	panel:loadRequiredResource("ui/NewSharePanel.json")
	panel.ui = panel:buildInterfaceGroup('SharePassFriendPanel')
	panel.shareId = shareId
	panel.shareType = shareType
	panel.shareNotiKey = shareNotiKey
	panel.shareTitleKey = shareTitleKey
	panel.passedFriendIds = friendInfos
	panel.passFriendType = passFriendType
	panel:init()
	return panel
end