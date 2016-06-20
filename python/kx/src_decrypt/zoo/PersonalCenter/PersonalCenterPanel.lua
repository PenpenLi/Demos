local PersonalCenterPanel = class(BasePanel)

-- local print = function ( str )
-- 	oldPrint("[PersonalCenterPanel] "..str)
-- end

function PersonalCenterPanel:create(manager)
    local panel = PersonalCenterPanel.new()
    panel:loadRequiredResource(PanelConfigFiles.personal_center_panel)
    panel:init(manager)
    return panel
end

function PersonalCenterPanel:init(manager)
	self.manager = manager

	self.moreAvatarList = {}

	self.ui = self:buildInterfaceGroup("personal_center_panel")
    BasePanel.init(self, self.ui)


    self.closeBtn = self.ui:getChildByName('closeBtn')
	self.closeBtn:setTouchEnabled(true, 0, false)
	self.closeBtn:setButtonMode(true)
	self.closeBtn:addEventListener(DisplayEvents.kTouchTap, 
	                               function (event) 
	                               		self:onCloseBtnTapped(event) 
	                               end)

    --self.name = self.ui:getChildByName("name")
    --self.name:setString(HeDisplayUtil:urlDecode(manager:getData(manager.NAME)))

    self.editBtn = GroupButtonBase:create(self.ui:getChildByName('editBtn'))
    self.editBtn:setString(localize("my.card.btn1"))
    local function onTapEditBtn()
        if not kUserLogin then
            CommonTip:showTip(localize("my.card.panel.warning.tip3"))
        else
            local EditProfilePanel = require "zoo.PersonalCenter.EditProfilePanel"
            local panel = EditProfilePanel:create(manager)
            panel.parentPanel = self
            panel:popout()
            self.editPanel = panel
            DcUtil:UserTrack({category='my_card', sub_category="my_card_click_edit_profile"}, true)
        end
    end

    self.onTapEditBtn = onTapEditBtn
    self.editBtn:ad(DisplayEvents.kTouchTap, onTapEditBtn)

    local finishedEdit = self.ui:getChildByName('finishedEdit')
    -- local sexUi = finishedEdit:getChildByName("sex")
    -- local consUi = finishedEdit:getChildByName("cons")
    -- local size_sex = sexUi:getGroupBounds().size
    -- local size_cons = consUi:getGroupBounds().size
    -- sexUi:setContentSize(CCSizeMake(size_sex.width, size_sex.height))
    -- sexUi:ignoreAnchorPointForPosition(false)
    -- sexUi:setAnchorPoint(ccp(0.5, 0))

    -- consUi:setContentSize(CCSizeMake(size_cons.width, size_cons.height))
    -- consUi:ignoreAnchorPointForPosition(false)
    -- consUi:setAnchorPoint(ccp(0.5, 0))

    self.editBtn1 = finishedEdit:getChildByName("editBtn")
    self.editBtn1:setTouchEnabled(true)
    self.editBtn1:ad(DisplayEvents.kTouchTap, onTapEditBtn)

    self.bubleEdit =  self.ui:getChildByName("bubleEdit")
    self.bubleEdit:setTouchEnabled(true)

    local function setRedDot()
        if self.manager:getData(self.manager.SHOW_ACCBTN_REDDOT) then
            self.ui:getChildByName("bubleEdit"):getChildByName("resDot"):setVisible(true)
        else
            self.ui:getChildByName("bubleEdit"):getChildByName("resDot"):setVisible(false)
        end

        if self.avatarSelectGroup then
            --self.avatarSelectGroup:updateClickState()
        end
    end

    setRedDot()

    local function onTapBubleEdit() 
        local panel = AccountSettingPanel:create()
        panel.bindCallBack = setRedDot 
        panel:popout()
        DcUtil:UserTrack({category='my_card', sub_category="my_card_click_setting"}, true)
        --DcUtil:UserTrack({ category='setting', sub_category="setting_click_my_account"})

        if __WIN32 then return end
        if self:hasAccountBinded() then return end

        local authConfig = PlatformConfig.authConfig
    
        print(table.tostring(authConfig))
        local singleAuth
        if type(authConfig) == 'table' and #authConfig == 1 and authConfig[1] ~= PlatformAuthEnum.kGuest
        then
            singleAuth = authConfig[1]
        elseif type(authConfig) ~= 'table' and authConfig ~= PlatformAuthEnum.kGuest then
            singleAuth = authConfig
        end
        if singleAuth then
            if singleAuth == PlatformAuthEnum.kPhone then
                panel:bindNewPhone()
            else
                panel:bindNewSns(singleAuth)
            end
        end
    end

    self.bubleEdit:ad(DisplayEvents.kTouchTap, onTapBubleEdit)

    if not self.manager:getData(self.manager.SHOULD_SHOW_ACCBTN) then
        self.bubleEdit:setVisible(false)
    end

    self.starNum = self.ui:getChildByName("starNum")
    self.starNum:setScale(0.7)
    self.starNum:setAnchorPoint(ccp(0.5, 0.5))
    local pos = self.starNum:getPosition()
    self.starNum:setPosition(ccp(pos.x + 40 , pos.y - 25))
    self.starNum:setText(manager:getData(manager.STAR))
   
    if manager:getData(manager.STAR) == 0 then
        self.ui:getChildByName("starTip"):setString(localize("my.card.panel.text1.1"))
        self.ui:getChildByName("starTip1"):setVisible(false)
        self.ui:getChildByName("starTip2"):setVisible(false)
        self.ui:getChildByName("starTip3"):setVisible(false)
    else
        local starTip2 = self.ui:getChildByName("starTip2")
        self.ui:getChildByName("starTip1"):setString(localize('my.card.panel.text3'))
        self.ui:getChildByName("starTip3"):setString(localize('my.card.panel.text4'))
        self.ui:getChildByName("starTip"):setVisible(false)

        local function updatePercentRank( pctRank )
            starTip2:setString(string.format("%.2f",pctRank / 100).."%")
        end
        updatePercentRank(manager:getData(manager.PERCENT_RANK))
        manager:reigsterDataEvent(manager.PERCENT_RANK, updatePercentRank)
    end

    if (not kUserLogin) and manager:getData(manager.STAR) ~= 0 then
        self.ui:getChildByName("starTip"):setString(localize("my.card.panel.text1.2"))
        self.ui:getChildByName("starTip1"):setVisible(false)
        self.ui:getChildByName("starTip2"):setVisible(false)
        self.ui:getChildByName("starTip3"):setVisible(false)
        self.ui:getChildByName("starTip"):setVisible(true)
    end

    local code = self.ui:getChildByName("qrcode")
	code:setVisible(false)

	local size = code:getGroupBounds().size
	local qrcode = CocosObject.new(QRManager:generatorQRNode(manager:getData(manager.QR_CODE), size.width, 1, ccc4(74, 175, 23, 255)))
	local sSize = qrcode:getContentSize()
	qrcode:setAnchorPoint(ccp(0, 1))
	qrcode:setScaleX(size.width / sSize.width)
	qrcode:setScaleY(-size.height / sSize.height) -- original and correct scaleY of image is smaller than zero.
	qrcode:setPositionXY(code:getPositionX(), code:getPositionY() - sSize.height * math.abs(qrcode:getScaleY()))
	self.ui:addChildAt(qrcode, 11)

    local idPos = self.ui:getChildByName("idPos")
    idPos:setVisible(false)
    local idSize = idPos:getGroupBounds().size
    local posIdLabelNum = idPos:getPosition()

    local idLabelUi = self.ui:getChildByName("idLabel")
    local posx = idLabelUi:getPositionX()
	idLabelUi:setVisible(false)
    local idLabel = LabelBMMonospaceFont:create(36, 36, 25, "fnt/nametag.fnt")
    idLabel:setAnchorPoint(ccp(0, 0.5))
    idLabel:setPosition(ccp(posx, posIdLabelNum.y - idSize.height / 2 - 3))
    idLabel:setString(localize("my.card.panel.text2").."：")
    self.ui:addChildAt(idLabel, 11)
	local idLabelNum = self.ui:getChildByName("idLabelNum")
    
	idLabelNum:setAnchorPoint(ccp(0.5, 0.5))
    idLabelNum:setScale(1.2)
	idLabelNum:setPosition(ccp(posIdLabelNum.x + idSize.width / 2, posIdLabelNum.y - idSize.height / 2 - 3))
	idLabelNum:setText(manager:getData(manager.INVITE_CODE))

	local function update5()
        if self.isDisposed then return end
        local text = idLabelNum
        if not text or text.isDisposed then return end
        local arr = CCArray:create()
        arr:addObject(CCScaleTo:create(0.1, 1.55))
        arr:addObject(CCScaleTo:create(0.1, 1.05))
        arr:addObject(CCScaleTo:create(0.1, 1.3))
        arr:addObject(CCScaleTo:create(0.1, 1.2))
        text:runAction(CCSequence:create(arr))
    end
    self.schedule = Director:sharedDirector():getScheduler():scheduleScriptFunc(update5, 5, false)

    local sendBtnUi = self.ui:getChildByName('sendBtn')
    self.sendBtn = GroupButtonBase:create(self.ui:getChildByName('sendBtn'))

    if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
        sendBtnUi:getChildByName("mi"):setVisible(true)
        sendBtnUi:getChildByName("iconSize"):setVisible(false)
        self.sendBtn:setString("米聊邀请")
        self.sendBtn.label:setPositionX(-45)
    else
        sendBtnUi:getChildByName("iconSize"):setVisible(true)
        sendBtnUi:getChildByName("mi"):setVisible(false)
        self.sendBtn:setString(localize("my.card.btn2"))
    end

    self.sendBtn:setColorMode(kGroupButtonColorMode.blue)
    local function onTapSendBtn()
        local function cb()
            self.sendBtn:setEnabled(true)
        end

        setTimeOut(cb, 3)
        self.sendBtn:setEnabled(false)
        self.manager:sendBusinessCard(cb, cb, cb)
    end
    self.sendBtn:ad(DisplayEvents.kTouchTap, onTapSendBtn)

    if not self.manager:getData(self.manager.SHOULD_SHOW_CARD_BTN) then
        self.sendBtn:setVisible(false)
    end

    local rank = manager:getData(manager.STAR_FRIEND_RANK)
    self.starRankTip = self.ui:getChildByName("starRankTip")
    self.starRankTip:getChildByName("text"):setString("当前所获星星数在好友中排名：第"..rank.."名")
    self.starRankTip:setVisible(false)

    local function timeout()
    	self.starRankTip:setVisible(false)
    end

    self.starRankImg = self.ui:getChildByName("starRankImg")
    self.starRankImg:setTouchEnabled(true, 0, true)
    self.starRankImg:ad(DisplayEvents.kTouchTap, function ()
    	if not self.starRankTip.isDisposed and not self.starRankTip:isVisible() then
    		self.starRankTip:setVisible(true)
    		setTimeOut(timeout, 3)
    	end
    end)

    local silver = self.starRankImg:getChildByName("silver")
    silver:setPositionX(silver:getPositionX() + 4)
    self.starRankImg:getChildByName("golden"):setVisible(rank == 1)
    silver:setVisible(rank == 2)
    self.starRankImg:getChildByName("bronze"):setVisible(rank == 3)
    self.starRankImg:getChildByName("other"):setVisible(rank > 3)
    local starRank = self.ui:getChildByName("starRank")
    starRank:setAnchorPoint(ccp(0.5, 0.5))
    local starRankPos = starRank:getPosition()
    starRank:setPosition(ccp(starRankPos.x + 8, starRankPos.y - 15))
    starRank:setText(rank)

    local image = self.ui:getChildByName("image")
    image:setVisible(false)
    image:setAnchorPointCenterWhileStayOrigianlPosition()
    local posImage = image:getPosition()
    local sprite = Sprite:createEmpty()
    sprite:setPosition(ccp(posImage.x, posImage.y))
    local imageSize = image:getGroupBounds().size
    local imageWidth = imageSize.width
    local imageHeight = imageSize.height
    self.ui:addChildAt(sprite, 14)

    local function changePlayer( clipping, headUrl )
        if clipping.headSprite.refCocosObj == nil then return end
        local texture, rect = clipping:getHeadTextureAndRect()
        sprite:setTexture(texture)
        sprite:setTextureRect(rect, false, CCSizeMake(imageWidth, imageHeight))
        sprite:setScale(imageWidth * 2 / rect.size.width / 3)

        if tostring(self.manager:getData(self.manager.HEAD_URL)) ~= tostring(headUrl) then
            self.manager:setData(self.manager.HEAD_URL, tostring(headUrl))
            self.manager:uploadUserProfile()
        end
    end

    local AvatarSelectGroup = require "zoo.PersonalCenter.AvatarSelectGroup"
    self.avatarSelectGroup = AvatarSelectGroup:buildGroup(manager, 
                                self.ui:getChildByName("moreAvatars"),
                                self.ui:getChildByName("avatar"),
                                self.ui:getChildByName("nameLabel"),
                                changePlayer
                                )
    self.avatarSelectGroup.parent = self
    --打点用
    self.avatarSelectGroup.originalPlace = 0

    self.achiBtn = self.ui:getChildByName("starImg")
    self.achiBtn:setTouchEnabled(true)

    local function onTapAchiBtn()
        local AchievementPanel = require "zoo.PersonalCenter.AchievementPanel"
        local achievementPanel = AchievementPanel:create(manager)
        achievementPanel.parentPanel = self
        achievementPanel:popout()
        DcUtil:UserTrack({category='my_card', sub_category="my_card_click_achievement"}, true)
    end
    self.achiBtn:ad(DisplayEvents.kTouchTap, onTapAchiBtn)

    local totalAchiLevel = self.manager:getData(self.manager.TOTAL_ACHI_LEVEL)

    --根据成就等级，显示不同的勋章，使用不同的字体
    local fntFile = nil
    local charWidth     = 30
    local charHeight    = 30
    local charInterval  = 15
    
    local medalType = AchievementManager:getMedalType(totalAchiLevel)
    self.achiBtn:getChildByName("_bg"):setVisible(false)
    local isCopper = medalType == AchievementManager.medalType.Copper
    local isSilver = medalType == AchievementManager.medalType.Silver
    local isGolden = medalType == AchievementManager.medalType.Gold
    if isGolden then
        fntFile = 'fnt/race_rank.fnt'
    elseif isSilver then
        fntFile = 'fnt/race_rank_silver.fnt'
    elseif isCopper then
        fntFile = 'fnt/race_rank_copper.fnt'
    end

    self.achiBtn:getChildByName("default"):setVisible(medalType == AchievementManager.medalType.None)
    self.achiBtn:getChildByName("copper"):setVisible(isCopper)
    self.achiBtn:getChildByName("silver"):setVisible(isSilver)
    self.achiBtn:getChildByName("golden"):setVisible(isGolden)

    if medalType ~= AchievementManager.medalType.None then
        local achiLevelLabel  = LabelBMMonospaceFont:create(charWidth, charHeight, charInterval, fntFile)
        local labelText = tostring(totalAchiLevel)
        local starImageSize = self.achiBtn:getGroupBounds().size
        achiLevelLabel:setString(labelText)

        --拙劣的调整字体位置，是一位数还是两位数区别对待
        achiLevelLabel:setAnchorPoint(ccp(0.5, 0.5))
        if totalAchiLevel < 10 then
            achiLevelLabel:setPositionXY(starImageSize.width/2-2, -starImageSize.height/2-10)
        else
            achiLevelLabel:setPositionXY(starImageSize.width/2-4, -starImageSize.height/2-10)
        end

        self.achiBtn:addChild(achiLevelLabel)
    end

    self:updateProfile(true)

    --guide
    local PersonalCenterGuide = require "zoo.PersonalCenter.PersonalCenterGuide"
    local para = {
        achiBtn = {self.achiBtn, onTapAchiBtn},
        editBtn = {self.editBtn, onTapEditBtn},
        bubleEdit = {self.bubleEdit, onTapBubleEdit},
        sendBtn = {self.sendBtn, onTapSendBtn},
        panel = self
    }
    self.guide = PersonalCenterGuide:create(para)
    -- self.guide:popout()
    print("init >>>>>")
end

function PersonalCenterPanel:hasAccountBinded()
    return UserManager.getInstance().profile:isPhoneBound() or UserManager.getInstance().profile:isSNSBound()
end

function PersonalCenterPanel:updateProfile(isInit)
    local m = self.manager
    local age = m:getData(m.AGE)
    local cons = m:getData(m.CONSTELLATION)
    local sex = m:getData(m.SEX)

    local finishedEdit = self.ui:getChildByName("finishedEdit")

    local headUrl = m:getData(m.HEAD_URL)

    if not isInit then
        self.avatarSelectGroup:changeAvatarImage(headUrl)
    end

    local name = self.ui:getChildByName("nameLabel"):getChildByName("label")
    local nameText = HeDisplayUtil:urlDecode(m:getData(m.NAME))
    if name:isVisible() then
        name:setString(nameText)
    elseif self.avatarSelectGroup.input then
        self.avatarSelectGroup.input:setText(nameText)
    end

    if  age == 0 and cons == 0 and sex == 0 then
        self.ui:getChildByName('editBtn'):setVisible(true)
        finishedEdit:setVisible(false)
        return
    end

    if not isInit then
        self.manager:uploadUserProfile()
    end

    self.ui:getChildByName('editBtn'):setVisible(false)
    finishedEdit:setVisible(true)

    local labelACG = finishedEdit:getChildByName('labelACG')

    local ageText = ''
    local genderText = ''
    local constellationText = ''

    if tonumber(age) == 100 then
        age = "99+"
    end

    ageText = age == 0 and "" or age.."岁".." "
    
    local genderTextGroup = {'', localize('my.card.edit.panel.content.male'), localize('my.card.edit.panel.content.female')}
    genderText = genderTextGroup[sex + 1]..' '

    if cons > 0 then
        constellationText = localize('my.card.edit.panel.content.constellation'..cons)
    end
    local labelACGText = ageText..genderText..constellationText
    labelACG:setString(labelACGText)

    local offsetX = #labelACGText * (9) - 9
    self.editBtn1:setPositionX(offsetX + labelACG:getPositionX())
end

function PersonalCenterPanel:onEnterHandler(event, ...)
    if event == "enter" then
        self.allowBackKeyTap = true
        self:runAction(self:createShowAnim())
    end
end

function PersonalCenterPanel:createShowAnim()
    local centerPosX    = self:getHCenterInParentX()
    local centerPosY    = self:getVCenterInParentY()

    local function initActionFunc()
        local initPosX  = centerPosX
        local initPosY  = centerPosY + 100
        self:setPosition(ccp(initPosX, initPosY))
    end
    local initAction = CCCallFunc:create(initActionFunc)
    local moveToCenter      = CCMoveTo:create(0.5, ccp(centerPosX, centerPosY))
    local backOut           = CCEaseQuarticBackOut:create(moveToCenter, 33, -106, 126, -67, 15)
    local targetedMoveToCenter  = CCTargetedAction:create(self.refCocosObj, backOut)

    local function onEnterAnimationFinished( )self:onEnterAnimationFinished() end
    local actionArray = CCArray:create()
    actionArray:addObject(initAction)
    actionArray:addObject(targetedMoveToCenter)
    actionArray:addObject(CCCallFunc:create(onEnterAnimationFinished))
    return CCSequence:create(actionArray)
end

function PersonalCenterPanel:onEnterAnimationFinished()
   
end

function PersonalCenterPanel:popout()
    PopoutManager:sharedInstance():add(self, true, false)
end

function PersonalCenterPanel:onCloseBtnTapped()
    if self.avatarSelectGroup.photoView ~= nil then
        self.avatarSelectGroup:closePhotoView()
        return
    end

	PopoutManager:sharedInstance():remove(self, true)
	self.allowBackKeyTap = false
	if self.schedule then
		Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.schedule)
		self.schedule = nil
	end

	if self.manager then
		--self.manager:uploadUserProfile()
        self.manager:unreigsterDataEvent(self.manager.PERCENT_RANK)
        self.manager.panel = nil
	end
    self.avatarSelectGroup.parent = nil
end

return PersonalCenterPanel