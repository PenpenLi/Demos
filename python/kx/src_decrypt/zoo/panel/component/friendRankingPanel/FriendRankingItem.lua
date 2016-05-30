
FriendRankingItem = class(ItemInClippingNode)

function FriendRankingItem:create()
	local instance = FriendRankingItem.new()
	instance:loadRequiredResource(PanelConfigFiles.friend_ranking_panel)
	instance:init()
	return instance

end


function FriendRankingItem:ctor()
	self.name = 'FriendRankingItem'
	self.debugTag = 0
	self.itemFoldHeight = 119
	self.itemExtendHeight = nil --之后初始化这个值
	self.starPosXOffset = 55
end

function FriendRankingItem:loadRequiredResource(panelConfigFile)
	self.panelConfigFile = panelConfigFile
	self.builder = InterfaceBuilder:create(panelConfigFile)
end

function FriendRankingItem:unloadRequiredResource()
end

function FriendRankingItem:init()
	local ui = self.builder:buildGroup('friendRankingPanelItem')--ResourceManager:sharedInstance():buildGroup('friendRankingPanelItem')

	VerticalTileItem.init(self,ui)

	self.golden = ui:getChildByName('goldenCrown')
	self.silver  = ui:getChildByName('silverCrown')
	self.bronze = ui:getChildByName('bronzeCrown')
	self.normal = ui:getChildByName('normal')

	self.greySend = ui:getChildByName('greySendBtn')
	self.greySend:setOpacity(150)
	self.normalSend = ui:getChildByName('normalSendBtn')

	self.star = ui:getChildByName('star')

	-- self.starLabel = TextField:createWithUIAdjustment(self.star:getChildByName('textSize'), self.star:getChildByName('text'))
	-- ui:addChild(self.starLabel)
	self.starLabel = self.star:getChildByName('text')

	self.levelLabel = ui:getChildByName('levelLabel')

	self.rankLabel = TextField:createWithUIAdjustment(ui:getChildByName('rankLabelSize'), ui:getChildByName('rankLabel'))
	ui:addChild(self.rankLabel)

	self.labelACG = self.ui:getChildByName("labelACG")

	self.selectedIcon = ui:getChildByName('selectedIcon')
	self.selectBtn = ui:getChildByName('selectBtn')
	self.bgNormal = ui:getChildByName('bgNormal')
	self.bgSelected = ui:getChildByName('bgSelected')
	self.bgMyself = ui:getChildByName('bgMyself')

	self.avatar = ui:getChildByName('avatar')
	self.nameLabel = ui:getChildByName('labelName')

	self.normalSend:ad(DisplayEvents.kTouchTap, function(event) self:onSendBtnTap(event) end)

	self.selectBtn:ad(DisplayEvents.kTouchTap, function(event) self:onSelectBtnTap(event) end)

	self:setContent(ui)

	local touchArea = self.ui:getChildByName("title_touch_area")
	touchArea:setTouchEnabled(true, 0, true)
	touchArea:ad(DisplayEvents.kTouchTap, function(event) 
			self:onItemTapped(event) 
		end)
	self.touchArea = touchArea
	self.touchAreaScaleX = self.touchArea:getScaleX()
end

function FriendRankingItem:initContent()
	local friend_item_content = self.builder:buildGroup('friend_item_content')
	self.itemContent = friend_item_content
	self.ui:addChildAt(self.itemContent, 1)
	self.itemContent:setPositionY(self.ui:getChildByName('bgNormal'):getPositionY() - 100)

	self.itemExtendHeight = self.itemFoldHeight + self.itemContent:getGroupBounds().size.height - 20

	self.btnAsk = GroupButtonBase:create(self.itemContent:getChildByName('btnAsk'))
	self.btnAsk:setString(localize('request.message.panel.zero.energy.button1'))
	self.btnAsk:setColorMode(kGroupButtonColorMode.blue)
	self.btnAsk:ad(DisplayEvents.kTouchTap, function()
			self:askEnergy()
		end)

	self.btnSend = GroupButtonBase:create(self.itemContent:getChildByName('btnSend'))
	self.btnSend:setString("免费送精力")
	self.btnSend:ad(DisplayEvents.kTouchTap, function()
			self:sendEnergy()
		end)

	self:initRanking()
	self:initAchievement()
	self:initAchievementIcon(self.user)
end

function FriendRankingItem:askEnergy()
	-- print("todo: askEnergy!!!!!!!!!!!")
	local function onSuccess()
		-- print('onSuccess')
		if self.isDisposed then
			return
		end
		-- self:stopLoading()
		self.btnAsk:setEnabled(false)
		self.btnAsk:setString('已请求')
    end
    
    local function onFail(evt)
    	-- print('onFail')
    	if  self.isDisposed then
    		return
    	end
    	-- self:stopLoading()
        CommonTip:showTip(Localization:getInstance():getText("error.tip."..evt.data), "negative")

        --其实已不能索要精力，但前端数据不对，还以为能索要，因此更新一下前端记录的数据--
        if 730225 == tonumber(evt.data) then
        	UserManager:getInstance():addWantIds({self.user.uid})
        	self.btnAsk:setEnabled(false)
        end
    end

    -- print("self.user.uid: "..tostring(self.user.uid))
    local level = UserManager:getInstance().user:getTopLevelId()
    local meta = MetaManager:getInstance():getFreegift(level)
    FreegiftManager:sharedInstance():requestGift({self.user.uid}, meta.itemId, onSuccess, onFail, true)
    -- self:playLoading()
end

function FriendRankingItem:sendEnergy()
	-- print("todo: sendEnergy!!!!!!")
	self:onSendBtnTap()
end

function FriendRankingItem:onItemTapped()
	-- print("on item tapped!!!!!!!!!!!!!")
	if self.beforeToggleCallback then
		self.beforeToggleCallback(self)
	end

	if self.itemContent then
		self:foldItem()
		self.friendRankingPanel:fold()
	else
		self:initContent()

		self:setHeight(self.itemExtendHeight)
		self:adjustAskSendButton()

		if self.friendRankingPanel.expandItemIndex == nil or self.friendRankingPanel.expandItemIndex > self.index then
			if self:getPositionInWorldSpace().y < 700 then
				local offsetY = -self:getPositionY() - 119*3 - 50
				offsetY = math.max(0, offsetY)
				self.view:gotoPositionY(offsetY)
			end
		else
			if self:getPositionInWorldSpace().y < 700 then
				local offsetY = -self:getPositionY() - 119*3 - self.itemExtendHeight + 119 - 50
				offsetY = math.max(0, offsetY)
				self.view:gotoPositionY(offsetY)
			end
		end

		self.friendRankingPanel:expandItem(self.index)
	end

	if self.afterToggleCallback then
		self.afterToggleCallback()
	end
end

function FriendRankingItem:adjustAskSendButton()
	if self.btnSend and self.btnAsk then
		self.btnSend:setVisible(self:canSend())
		self.btnAsk:setVisible(self:canRequestFrom(self.user.uid))

		if self.askSendBtnCenterX == nil then
			self.askSendBtnCenterX = (self.btnAsk:getPositionX() + self.btnSend:getPositionX()) / 2
		end
		if not self.btnSend:isVisible() then
			self.btnAsk:setPositionX(self.askSendBtnCenterX)
		end

		if not self.btnAsk:isVisible() then
			self.btnSend:setPositionX(self.askSendBtnCenterX)
		end
	end
end

function FriendRankingItem:foldItem()
	if self.itemContent then
		self.itemContent:removeFromParentAndCleanup(true)
		self.itemContent:dispose()
		self.itemContent = nil
		self:setHeight(119)
	end
end

function FriendRankingItem:setAfterToggleCallback(callback)
	self.afterToggleCallback = callback
end

function FriendRankingItem:setBeforeToggleCallback(callback)
	self.beforeToggleCallback = callback
end

function FriendRankingItem:setData(data)
	self.user = data
	self.profile = data

	if data.achievement and data.achievement.achievements then
		table.sort(data.achievement.achievements, 
			function(ach1, ach2) 
				return ach1.id > ach2.id 
			end)
	end

	self:refreshUserInfo(data)
	self:refreshProfile(data)
end

local icon_achievement_ids = {10, 50, 60, 70, 90, 100, 140, 150, 160, 170, 180, 190, 'q'}
local show_level_achievements = {50, 60, 70, 90}

local achiIds = AchievementManager.shareId
local tipCreator = {
	[achiIds.N_STAR_REWARD] = function(data)
				local starRewards = MetaManager.getInstance().star_reward
				local starNum = 0
				for _,v in ipairs(starRewards) do
					if v.id == data.level then
						starNum = v.starNum
						break
					end
				end

				return localize("show_off_desc_"..data.id, {num = starNum})
			end,
	[achiIds.FIVE_TIMES_FOUR_STAR] = function(data)
				local starNum = data.level * 5
				return localize("show_off_desc_70_1", {num = starNum})
			end,
	[achiIds.PASS_N_HIDEN_LEVEL] = function(data)
				return localize('show_off_desc_60_1', {num = data.level})
			end,
	[achiIds.UNLOCK_NEW_OBSTACLE] = function ( data )
				local firstNewObstacleLevels = MetaManager:getInstance().global.firstNewObstacleLevels
				table.sort(firstNewObstacleLevels)
				-- local levelName = ''
				-- if firstNewObstacleLevels[data.level] then
				-- 	levelName = localize("achievement.blocker.name."..firstNewObstacleLevels[data.level])
				-- end
				local maxLevel = MetaManager.getInstance():getMaxNormalLevelByLevelArea()
				local level = data.level
				while firstNewObstacleLevels[level] > maxLevel do
					level = level - 1
				end

				return localize("show_off_desc_50_1", {num = firstNewObstacleLevels[level]})
		   end,
	[achiIds.SCORE_PASS_THOUSAND] = function(data)
				local starNum = data.level * 5
				return localize("show_off_desc_10_1")
			end
}

function FriendRankingItem:initAchievementIcon(user)
	local score = AchievementManager:getTotalScore(user)
	local achiLevel = AchievementManager:getFriendAchiLevel(score)
	
	local icon = self.itemContent:getChildByName('icon_achivement')
	self.iconAchievement = icon
	local medalType = AchievementManager:getMedalType(achiLevel)

    local isCopper = medalType == AchievementManager.medalType.Copper
    local isSilver = medalType == AchievementManager.medalType.Silver
    local isGolden = medalType == AchievementManager.medalType.Gold
    local isNone = medalType == AchievementManager.medalType.None

    local fntFile
    if isGolden then
        fntFile = 'fnt/race_rank.fnt'
    elseif isSilver then
        fntFile = 'fnt/race_rank_silver.fnt'
    elseif isCopper then
        fntFile = 'fnt/race_rank_copper.fnt'
    end

    icon:getChildByName("default"):setVisible(isNone)
    icon:getChildByName("copper"):setVisible(isCopper)
    icon:getChildByName("silver"):setVisible(isSilver)
    icon:getChildByName("gold"):setVisible(isGolden)

    if not isNone then
        local achiLevelLabel  = LabelBMMonospaceFont:create(30, 30, 15, fntFile)
        local labelText = tostring(achiLevel)
        local starImageSize = icon:getGroupBounds().size
        achiLevelLabel:setString(labelText)

        --拙劣的调整字体位置，是一位数还是两位数区别对待
        achiLevelLabel:setAnchorPoint(ccp(0.5, 0.5))
        if achiLevel < 10 then
            achiLevelLabel:setPositionXY(starImageSize.width/2-2, -starImageSize.height/2-10)
        else
            achiLevelLabel:setPositionXY(starImageSize.width/2-4, -starImageSize.height/2-10)
        end

        icon:addChild(achiLevelLabel)
    end

    -- 新需求，好友没有任何成就时，不显示任何勋章图标，所以要隐藏默认图标
    if isNone and tonumber(self.user.uid) ~= tonumber(UserManager.getInstance().user.uid) then
	    icon:getChildByName("default"):setVisible(false)
	    -- 调整 右侧文字位置
	    local widgetsToAdjust = {
	    	self.itemContent:getChildByName('lbl_percent'),
	    	self.itemContent:getChildByName('star_tip1'),
	    	self.itemContent:getChildByName('star_tip2'),
	    	self.itemContent:getChildByName('star_tip3'),
	    	self.itemContent:getChildByName('rank_tip_bg')
		}

		local offsetX = -45
		table.each(
			widgetsToAdjust,
			function(widget)
				local x = widget:getPositionX()
				x = x + offsetX
				widget:setPositionX(x)
			end
		)
	end
end

function FriendRankingItem:isOwner()
	return self.user.uid == UserManager:getInstance().user.uid
end

function FriendRankingItem:initRanking()
	function wordHardToGetStar()
		if self:isOwner() then
			self.itemContent:getChildByName("star_tip3"):setString(localize('my.card.panel.text1.1'))
		else
			self.itemContent:getChildByName("star_tip3"):setString(localize('my.card.panel.friend.text1'))
		end
		self.itemContent:getChildByName("lbl_percent"):setString('')
		self.itemContent:getChildByName("star_tip2"):setString('')
		self.itemContent:getChildByName("star_tip1"):setString('')
	end
	function onLogined()
		local starNum = self.user:getTotalStar() or 0
		if starNum <= 0 then --没有星星
			wordHardToGetStar()
		else
			self.itemContent:getChildByName("star_tip1"):setString(localize('my.card.panel.text3'))
			local pctOfRank = 0
			if self.user.achievement then
				pctOfRank = self.user.achievement.pctOfRank / 100
			end
			self.itemContent:getChildByName("lbl_percent"):setString(string.format("%.2f", pctOfRank).."%")
			self.itemContent:getChildByName("star_tip2"):setString(localize('my.card.panel.text4'))
			self.itemContent:getChildByName("star_tip3"):setString('')
		end
	end
	function onLoginFail()
		local starNum = self.user:getTotalStar() or 0
		if starNum <= 0 then --没有星星
			wordHardToGetStar()
		else
			if self.isDisposed == false then
				self.itemContent:getChildByName("star_tip3"):setString(localize('my.card.panel.text1.2'))
				self.itemContent:getChildByName("lbl_percent"):setString('')
				self.itemContent:getChildByName("star_tip2"):setString('')
				self.itemContent:getChildByName("star_tip1"):setString('')
			end
		end
	end
	onLoginFail()
	RequireNetworkAlert:callFuncWithLogged(onLogined, onLoginFail, nil, kRequireNetworkAlertTipType.kNoTip)
end

function FriendRankingItem:initAchievement()
	local filterd = self.user.achievement and self.user.achievement.achievements or {}
	filterd = filterd or {}

	local achievements = {}

	for id,achi in pairs(filterd) do
		local config = AchievementManager:getConfig(achi.id)
		if config == nil then
			config = AchievementManager:getConfig(tonumber(achi.id))
		end
		if config and achi.level > 0 then
			table.insert(achievements, achi)
		end
	end

	table.sort(
		achievements, 
		function(a, b)
			local configA = AchievementManager:getConfig(a.id)
			local configB = AchievementManager:getConfig(b.id)
			if configA and configB then
				return configA.priority < configB.priority
			else
				return false
			end
		end
	)

	-- print(table.tostring(achievements))
	if #achievements == 0 then
		self.itemContent:getChildByName("label_no_achievement"):setString('')
		local pos = self.itemContent:getChildByName("label_no_achievement"):getPosition()
		local label_no_achievement = LabelBMMonospaceFont:create(36, 36, 36, 'fnt/green_button.fnt')
		self.itemContent:addChild(label_no_achievement)
		label_no_achievement:setString(localize('achievement_panel_no_metal'))
		label_no_achievement:setPositionXY(pos.x, pos.y - 50)
		label_no_achievement:setToParentCenterHorizontal()
		
		for i=1,4 do
			self.itemContent:getChildByName("achivement_bg"..i):setVisible(false)
			self.itemContent:getChildByName("achievement"..i):setVisible(false)
		end
		return
	end
	for i=1,4 do
		local iconAchievement = self.itemContent:getChildByName("achievement"..i)
		if achievements[i] then

			iconAchievement:setTouchEnabled(true, 0 , true)
			iconAchievement:ad(DisplayEvents.kTouchTap, function() 
					-- print("onItem touched!!!!!!!!!!!!!!, "..i)
					local config = AchievementManager:getConfig(tonumber(achievements[i].id))
					local builder = InterfaceBuilder:create(PanelConfigFiles.bag_panel_ui)
					local content = builder:buildGroup('bagItemTipContent')
					local desc = content:getChildByName('desc')
					local title = content:getChildByName('title')
					local sellBtn = content:getChildByName('sellButton')
					local useBtn = content:getChildByName('useButton')

					sellBtn:removeFromParentAndCleanup(true)
					sellBtn:dispose()
					useBtn:removeFromParentAndCleanup(true)
					useBtn:dispose()
					title:setString(localize(config.keyName))

					local createFunc = tipCreator[achievements[i].id]
					if createFunc then
						desc:setString(createFunc(achievements[i]))
					else
						desc:setString(localize(config.shareTitle))
					end
					local tip = BubbleTip:create(content, 105)
					tip:show(iconAchievement:getGroupBounds())
				end)

			for _,v in ipairs(icon_achievement_ids) do
				local icon = iconAchievement:getChildByName(tostring(v))
				local config = AchievementManager:getConfig(tonumber(achievements[i].id))
				if tostring(config.id) == tostring(v) then
					local level = achievements[i].level
					if achievements[i].id == AchievementManager.shareId.UNLOCK_NEW_OBSTACLE then
						local firstNewObstacleLevels = MetaManager:getInstance().global.firstNewObstacleLevels
						table.sort(firstNewObstacleLevels)
						local maxLevel = MetaManager.getInstance():getMaxNormalLevelByLevelArea()
						while (firstNewObstacleLevels[level] and firstNewObstacleLevels[level] > maxLevel) do
							level = level - 1
						end
					end
					icon:setVisible(true)
					if table.exist(show_level_achievements, tonumber(v)) then
						local levelText = icon:getChildByName("level")
						local levelTextValue = ' '..level.."级"
						if level < 10 then
							levelTextValue = ' '..levelTextValue
						end
						levelText:setText(levelTextValue)
						-- levelText:setScale(0.5)
					end

					if achievements[i].id == AchievementManager.shareId.UNLOCK_NEW_OBSTACLE then
						local firstNewObstacleLevels = MetaManager:getInstance().global.firstNewObstacleLevels
						level = firstNewObstacleLevels[level]
						local obstacleConfig = require "zoo.PersonalCenter.ObstacleIconConfig"
            			local index = obstacleConfig[level]
            			local name = "area_icon_"..index.."0000"
            			if CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(name) == nil then
            				FrameLoader:loadImageWithPlist("flash/quick_select_level.plist")
            			end
            			if CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(name) ~= nil then
	            			local obstacle = Sprite:createWithSpriteFrameName(name)
	            			icon:addChild(obstacle)
	            			obstacle:setScale(0.4)
	            			local size = icon:getContentSize()
	            			obstacle:setAnchorPoint(ccp(0.5, 0.5))
	            			obstacle:setPositionXY(60, -45)
	            		end
					end
				else
					icon:setVisible(false)
				end
			end
		else
			iconAchievement:setVisible(false)
			-- self.itemContent:getChildByName("achivement_bg"..i):setVisible(false)
		end
	end
end

function FriendRankingItem:refreshUserInfo(data)
	self.isSnsFriend = FriendManager.getInstance():isSnsFriend(data.uid)

	local level = data:getTopLevelId()
	if not level or level == '' then 
		level = 1
	end

	local star = data:getTotalStar()
	if not star then
		star = 0
	end

	self.starLabel:setText(star)
	self.levelLabel:setString(Localization:getInstance():getText('level.number.label.txt', {level_number = level}))
	self:exitSelectingMode()
end

function FriendRankingItem:refreshProfile(profile)

	local username = HeDisplayUtil:urlDecode(profile.name or '')

	if string.isEmpty(username) then 
		username = 'ID: '..profile.uid
	end
	self.nameLabel:setString(username)

	local headUrl = profile.headUrl
	-- end fix
	if string.isEmpty(headUrl) then
		headUrl = 1
	end

	self:changePlayerHead(tonumber(profile.uid), headUrl)

	-- print("isPersonalInfoEdited: ", self:isPersonalInfoEdited())

	self.levelLabel:setVisible(true)

	local ageText = ''
	local genderText = ''
	local constellationText = ''

	local age = profile.age

	-- 如果隐私保密
	if self:isInfoVisible(profile) then
		age = nil
	end

	age = age or 0
	if tonumber(age) == 100 then
		age = "99+"
	end

	ageText = age == 0 and "" or age.."岁".." "

	
	local gender = profile.gender

	-- 如果隐私保密
	if self:isInfoVisible(profile) then
		gender = nil
	end

	local genderTextGroup = {'', localize('my.card.edit.panel.content.male'), localize('my.card.edit.panel.content.female')}
	gender = gender or 0
	genderText = genderTextGroup[gender + 1]..' '

	local constellation = profile.constellation

	--如果隐私保密
	if self:isInfoVisible(profile) then
		constellation = 0
	end

	constellation = constellation or 0
	
	if constellation > 0 then
		constellationText = localize('my.card.edit.panel.content.constellation'..constellation)
	end
	self.labelACG:setString(ageText..genderText..constellationText)
end

function FriendRankingItem:isPersonalInfoEdited()
	if not self.profile then return false end

	local age = self.profile.age or 0
	local gender = self.profile.gender or 0
	local constellation = self.profile.constellation or 0

	return tonumber(age) > 0 or tonumber(gender) > 0 or tonumber(constellation) > 0
end

function FriendRankingItem:changePlayerHead(uid, headUrl)
	local function onImageLoadFinishCallback(head)
		if self.isDisposed then return end ---  prevent from crashes
		local headHolder = self.avatar:getChildByName('holder')
		local headHolderSize = headHolder:getContentSize()
		headHolder:setAnchorPointCenterWhileStayOrigianlPosition()
		head:setAnchorPoint(ccp(-0.5, -0.5))
		head:setPositionXY(0, 0)
		local tarWidth = headHolderSize.width
		local realWidth = head:getContentSize().width
		local scale = tarWidth / realWidth
		head:setScale(scale)
		if self.currentHead then
			self.currentHead:removeFromParentAndCleanup(true)
			self.currentHead:dispose()
			self.currentHead = head
		end
		headHolder:addChild(head)
	end
	HeadImageLoader:create(uid, headUrl, onImageLoadFinishCallback)
end

function FriendRankingItem:setRank(rank)
	if self.isDisposed then return end
	assert(type(rank) == 'number')
	assert(rank > 0)


	self.golden:setVisible(rank == 1)
	self.silver:setVisible(rank == 2)
	self.bronze:setVisible(rank == 3)
	self.normal:setVisible(rank > 3)

	self.rankLabel:setString(rank)
end

function FriendRankingItem:setSelected(selected)
	if self.isDisposed then return end
	self.selected = selected
	self.selectedIcon:setVisible(selected)
	self.bgSelected:setVisible(selected)
	self.bgNormal:setVisible(not selected)
end

function FriendRankingItem:setSelectEnable( isEnable )
	local disableBox = self.selectBtn:getChildByName("disableBox")
	local enableBox = self.selectBtn:getChildByName("enableBox")
	if isEnable then
		disableBox:setVisible(false)
		enableBox:setVisible(true)
	else
		disableBox:setVisible(true)
		enableBox:setVisible(false)
	end
end

function FriendRankingItem:enterSelectingMode()
	if self.isDisposed then return end

	if self.isSnsFriend then
		self:setSelectEnable(false)
	else
		self:setSelectEnable(true)
	end

	self.star:setVisible(false)
	self:showSendButton(false)
	self.selectBtn:setVisible(true)
	self.selectBtn:setButtonMode(true)
	self.selectBtn:setTouchEnabled(true, 5, true)
	self:setSelected(false)

	self.touchArea:setScaleX(self.touchAreaScaleX*0.8)
end

function FriendRankingItem:exitSelectingMode()
	if self.isDisposed then return end

	self.star:setVisible(true)
	self:showSendButton(true)

	self:setSelected(false)
	self.selectBtn:setVisible(false)
	self.selectBtn:setButtonMode(false)
	self.selectBtn:setTouchEnabled(false)

	self.touchArea:setScaleX(self.touchAreaScaleX)
end

function FriendRankingItem:showSendButton(doShow)
	if self.isDisposed then return end

-- temp hack: for hiding the send buttons forever
	doShow = false
	if doShow then
		if self:canSend() then
			self.greySend:setVisible(false)
			self.normalSend:setVisible(true)
			self.normalSend:setTouchEnabled(true, 5, true)
			self.normalSend:setButtonMode(true)
		else
			self.greySend:setVisible(true)
			self.normalSend:setVisible(false)
			self.normalSend:setTouchEnabled(false)
			self.normalSend:setButtonMode(false)
		end
	else
		self.greySend:setVisible(false)
		self.normalSend:setVisible(false)
		self.normalSend:setTouchEnabled(false, 5, false)
	end

end

function FriendRankingItem:canSend()
	if self.user then 
		return FreegiftManager:sharedInstance():canSendTo(tonumber(self.user.uid))
	else 
		return false
	end
end

function FriendRankingItem:canRequestFrom(friendId)
	local wantIds = UserManager:getInstance():getWantIds()
	-- print('wantIds',table.tostring(wantIds))
	return (not table.includes(wantIds, friendId))
end

function FriendRankingItem:getUser()
	return self.user
end

function FriendRankingItem:enableSend()
	if not self.isDisposed then
		-- self:stopLoading()
		if self.btnSend then self.btnSend:setEnabled(true) end


		self.greySend:setVisible(false)
		self.normalSend:setVisible(false)
		self.normalSend:setTouchEnabled(false, 5, true)
		self.normalSend:setButtonMode(false)
	end
end

function FriendRankingItem:hideSend()
	if not self.isDisposed then
		self.greySend:setVisible(false)
		self.normalSend:setVisible(false)
		self.normalSend:setTouchEnabled(false)
		self.normalSend:setButtonMode(false)
	end
end

function FriendRankingItem:disableSend()
	if not self.isDisposed then
		-- self:stopLoading()
		if self.btnSend then self.btnSend:setEnabled(false) end

		self.greySend:setVisible(false)
		self.normalSend:setVisible(false)
		self.normalSend:setTouchEnabled(false)
		self.normalSend:setButtonMode(false)
	end
end

function FriendRankingItem:onSendBtnTap(event)
	-- self:disableSend()
	-- self:playLoading()

	local function success(data)
		if not self.isDisposed then
			self:disableSend()
		end
		if self.synchronizer then
			self.synchronizer:onSendSucceeded(self)
		end
		self.btnSend:setString(localize('add.friend.panel.message.sent'))

		local _, remain = FreegiftManager:sharedInstance():canSendMore()
		if remain > 0 then
			CommonTip:showTip(localize('add.friend.panel.send.energy', {num=remain}))
		else
			CommonTip:showTip(localize('message.center.panel.commontip.sentall'))
		end
		-- print('sucess')
	end

	local function fail(err)
		if not self.isDisposed then
			self:enableSend()
		end
		if self.synchronizer then
			self.synchronizer:onSendFailed(self)
		end
		local err_code = tonumber(err.data)
		if err_code then
			CommonTip:showTip(Localization:getInstance():getText("error.tip."..err.data))
		end
		-- print('error')
	end
	
	-- print("self.user.uid: "..tostring(self.user.uid))
	FreegiftManager:sharedInstance():sendGiftTo(tonumber(self.user.uid), success, fail, true)
	
	if self.synchronizer then
		self.synchronizer:onSendDispatched(self)
	end
end

function FriendRankingItem:onSelectedIconTap(event)
	self:setSelected(false)
end

function FriendRankingItem:onSelectBtnTap(event)
	if not self.selected then 
		if self.isSnsFriend then
			local platform = ""
			local text = nil
			if _G.sns_token and _G.sns_token.authorType then
				if _G.sns_token.authorType == PlatformAuthEnum.kPhone or _G.sns_token.authorType == PlatformAuthEnum.kWeibo then
					text = Localization:getInstance():getText("add.friend.panel.delete.phone.friend")
				else
					platform = PlatformConfig:getPlatformNameLocalization(_G.sns_token.authorType)
				end
			end
			if not text then
				text = Localization:getInstance():getText("add.friend.panel.delete.platform.friend", {platform = platform})
			end
			CommonTip:showTip(text)
		else
			self.selected  = true
			self:setSelected(true)
		end
	else 
		self.selected = false
		self:setSelected(false)
	end
end

function FriendRankingItem:dispose()
	if self.synchronizer then 
		self.synchronizer:unregister(self) 
		self.synchronizer = nil
	end
	ItemInClippingNode.dispose(self)
	-- print ('FriendRankingItem:dispose', self:getArrayIndex())
end

-- function FriendRankingItem:playLoading()
-- 	if self.isDisposed then return end
-- 	self.timeoutId = setTimeOut(function ()
-- 		local scene = Director:sharedDirector():getRunningScene()
--     	self.loadingAnim = CountDownAnimation:createNetworkAnimation(scene, onCloseButtonTap, localize('share.feed.sending.tips'))
-- 		self.loadingAnim:setAnchorPoint(ccp(0.5, 0))
-- 		local size = Director.sharedDirector():getVisibleSize()
-- 		self.loadingAnim:setPositionXY(size.width/2, -size.height/2)
-- 		self.timeoutId = nil
-- 	end, 0.2)
-- end

-- function FriendRankingItem:stopLoading()
-- 	if self.isDisposed then return end
-- 	if self.loadingAnim and not self.loadingAnim.isDisposed then
-- 		self.loadingAnim:removeFromParentAndCleanup(true)
-- 		self.loadingAnim = nil
-- 	end
-- 	if self.timeoutId then
-- 		cancelTimeOut(self.timeoutId)
-- 		self.timeoutId = nil
-- 	end
-- end

function FriendRankingItem:isInfoVisible(profile)
	return profile.secret == true and tonumber(profile.uid) ~= tonumber(UserManager.getInstance().user.uid)
end

function FriendRankingItem:setView(view)
	self.view = view
end

function FriendRankingItem:setIndex(index)
	self.index = index
end

function FriendRankingItem:setPanel(panel)
	self.panel = panel
end

function FriendRankingItem:setFriendRankingPanel(panel)
	self.friendRankingPanel = panel
end