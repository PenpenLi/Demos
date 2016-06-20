local PersonalCenterGuide = class()

-- local print = function ( str )
-- 	oldPrint("[PersonalCenterGuide] "..str)
-- end

function PersonalCenterGuide:create(parameter)
    local guide = PersonalCenterGuide.new()
    local function init()
        CCUserDefault:sharedUserDefault():setBoolForKey("personal.center.panel.guide.has.played", true)
        CCUserDefault:sharedUserDefault():setBoolForKey("personal.center.panel.guide.has.played2", true)
        HomeScene:sharedInstance().settingButton:updateDotTipStatus()
        guide:init(parameter)
    end
    if guide:isNeedGuide() then
        parameter.panel:runAction(CCCallFunc:create(init))
    end
    return guide
end

function PersonalCenterGuide:isNeedGuide()
    --一期引导
    self.guide1Played = CCUserDefault:sharedUserDefault():getBoolForKey("personal.center.panel.guide.has.played", false)
    --二期引导（加入成就）
    self.guide2Played = CCUserDefault:sharedUserDefault():getBoolForKey("personal.center.panel.guide.has.played2", false)
    
    return not self.guide1Played or not self.guide2Played
end

function PersonalCenterGuide:init(parameter)
    self.panel = parameter.panel
    self.childs = {}

    local function buildBtn( name, btnTable, str, changeLabel)
        local content = Layer:create()
        local editBtn = self.panel:buildInterfaceGroup(name)
        content:addChild(editBtn)
        self.panel:addChild(content)

        btn = GroupButtonBase:create(editBtn)
        btn:setString(str)

        btn:ad(DisplayEvents.kTouchTap, function ()
            self:closeAll()
            btnTable[2]()
        end)
        local pos = btnTable[1]:getPosition()
        local size = btnTable[1]:getGroupBounds().size
        local sSize = btn:getGroupBounds().size
        content:setPosition(ccp(pos.x, pos.y))
        content:setScaleX(size.width / sSize.width)
        content:setScaleY(size.height / sSize.height)

        if changeLabel then
            --btn.label:setScaleY(0.78)
            --btn.label:setScaleX(0.68)
            btn:setColorMode(kGroupButtonColorMode.blue)

            if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
                editBtn:getChildByName("mi"):setVisible(true)
                editBtn:getChildByName("iconSize"):setVisible(false)
                btn:setString("米聊邀请")
                btn.label:setPositionX(-52)
            else
                editBtn:getChildByName("iconSize"):setVisible(true)
                editBtn:getChildByName("mi"):setVisible(false)
            end
        end

        table.insert(self.childs, content)
        return content
    end

    local frameSize = Director:sharedDirector():getVisibleSize()
    local originPos = Director:sharedDirector():getVisibleOrigin()
    local pSize = self.panel:getGroupBounds().size
    local origin = self.panel:getParent():convertToNodeSpace(ccp(originPos.x, originPos.y))
    --TODO:把所有引导加入一个layer
    -- self.layer = LayerColor:createWithColor(ccc3(0,0,0), frameSize.width, frameSize.height)
    local layer = LayerColor:createWithColor(ccc3(0,0,0), frameSize.width * 2, frameSize.height * 2)
    layer:setTouchEnabled(true, 0, true)
    layer:ad(DisplayEvents.kTouchTap, function ()
            self:nextAnimation()
        end)
    layer:setPosition(ccp(origin.x - pSize.width / 2, origin.y))
    layer:setOpacity(160)
    layer.maskGuideBg = true
    table.insert(self.childs, layer)
    self.panel:addChild(layer)

    local layerGuide = Layer:create()
    local guidePanel = ResourceManager:sharedInstance():buildGroup("guide_info_panelSR")
    layerGuide.guidePanel = guidePanel
    layerGuide:setAnchorPoint(ccp(0, 0))
    layerGuide:addChild(guidePanel)
    local gSize = guidePanel:getGroupBounds().size
    --self.guidePanel:setPosition(ccp(pSize.width / 2, gSize.height))
    guidePanel:setPositionY(gSize.height)
    layerGuide:setPositionX(120)
    layerGuide:setPositionY(25)

    guidePanel:getChildByName("skipicon"):setVisible(false)

    local gText = guidePanel:getChildByName("text")
    gText:setColor(ccc3(139, 64, 1))
    gText:setPositionY(gText:getPositionY() - 50)
    gText:setString(localize("tutorial.my.card.text2"))
    layerGuide:setScale(0.6)
    local animation = CommonSkeletonAnimation:createTutorialDown()
    animation.name = "animation"
    local sprite = CocosObject:create()
    sprite:addChild(animation)
    sprite:setScaleX(-1)
    sprite:setPosition(ccp(270, 38))
    sprite.name = "animation"
    guidePanel:addChild(sprite)
    table.insert(self.childs, layerGuide)
    self.panel:addChild(layerGuide)
    self.layerGuide = layerGuide

    self.editBtn = buildBtn("ui_buttons/ui_button_label", parameter.editBtn, localize("my.card.btn1"))
    self.sendBtn = buildBtn("ui_buttons/ui_button_left_icon", parameter.sendBtn, "发名片加好友", true)
    self.sendBtn:setVisible(false)
    self.editBtn:setVisible(false)

    self.bubleEdit = self.panel:buildInterfaceGroup("personal/personal_center_account_btn")
    local btnTable = parameter.bubleEdit
    local pos = btnTable[1]:getPosition()
    local size = btnTable[1]:getGroupBounds().size
    local sSize = self.bubleEdit:getGroupBounds().size
    self.bubleEdit:setPosition(ccp(pos.x, pos.y))
    self.bubleEdit:setScaleX(size.width / sSize.width)
    self.bubleEdit:setScaleY(size.height / sSize.height)
    self.panel:addChild(self.bubleEdit)

    self.bubleEdit:setTouchEnabled(true, 0, true)
    self.bubleEdit:ad(DisplayEvents.kTouchTap, function ()
            self:closeAll()
            btnTable[2]()
        end)
    self.bubleEdit:setVisible(false)

    btnTable = parameter.achiBtn

    self.achiBtn = self:buildAchiBtn(btnTable)
    self.achiBtn:ad(DisplayEvents.kTouchTap, function ()
            self:closeAll()
            btnTable[2]()
        end)
    self.achiBtn:setVisible(false)
    table.insert(self.childs, self.achiBtn)

    local achiBtnPos = self.achiBtn:getPosition()
    local editBtnPos = self.editBtn:getPosition()
    local sendBtnPos = self.sendBtn:getPosition()
    local bubleEditPos = self.bubleEdit:getPosition()

    local bSize = self.bubleEdit:getGroupBounds().size
    bubleEditPos = ccp(bubleEditPos.x + bSize.width / 2, bubleEditPos.y - bSize.height / 2)
    table.insert(self.childs, self.bubleEdit)
    self.btnType = {
        edit = 1,
        send = 2,
        account = 3,
        achi = 4
    }

    self.configs = {
        [self.btnType.achi] = {
            ccp(achiBtnPos.x + 40, achiBtnPos.y),
            ccp(achiBtnPos.x + 40, achiBtnPos.y + 90),
            ccp(achiBtnPos.x + 140, achiBtnPos.y + 90),
            ccp(achiBtnPos.x + 140, achiBtnPos.y + 160),
            ccp(-20, 0),
            btn = self.achiBtn,
            panelBtn = self.panel.achiBtn,
            nextType = self.btnType.edit,
            text = localize("tutorial.my.card.text4"),
            textPosY = 20,
        },
        [self.btnType.edit] = {
            ccp(editBtnPos.x, editBtnPos.y + 40),
            ccp(editBtnPos.x, editBtnPos.y + 100),
            ccp(editBtnPos.x + 180, editBtnPos.y + 100),
            ccp(editBtnPos.x + 180, editBtnPos.y + 150),
            ccp(-20, 0),
            btn = self.editBtn,
            panelBtn = self.panel.editBtn,
            nextType = self.btnType.send,
            text = localize("tutorial.my.card.text5"),
            textPosY = 20,
        },
        [self.btnType.send] = {
            ccp(sendBtnPos.x, sendBtnPos.y - 40),
            ccp(sendBtnPos.x, sendBtnPos.y - 100),
            ccp(sendBtnPos.x - 180, sendBtnPos.y - 100),
            ccp(sendBtnPos.x - 180, sendBtnPos.y - 150),
            ccp(20, 0),
            btn = self.sendBtn,
            panelBtn = self.panel.sendBtn,
            nextType = self.btnType.account,
            text = localize("tutorial.my.card.text6"),
            textPosY = -20,
        },
        [self.btnType.account] = {
            ccp(bubleEditPos.x, bubleEditPos.y - 40),
            ccp(bubleEditPos.x, bubleEditPos.y - 100),
            ccp(bubleEditPos.x - 80, bubleEditPos.y - 100),
            ccp(bubleEditPos.x - 80, bubleEditPos.y - 150),
            ccp(-20, 0),
            btn = self.bubleEdit,
            panelBtn = self.panel.bubleEdit,
            nextType = nil,
            text = localize("tutorial.my.card.text7"),
            textPosY = -20,
        },
    }

    local hasCard = parameter.sendBtn[1]:isVisible()
    local hasAccount = parameter.bubleEdit[1]:isVisible()

    if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
        hasCard = false
        self.mitalkHasCard = parameter.sendBtn[1]:isVisible()
    end

    if not self.guide1Played and not self.guide2Played then
        self.hasAchi = parameter.achiBtn[1]:isVisible()
        self.hasCard = hasCard
        self.hasAccount = hasAccount
        self.hasEdit = parameter.editBtn[1]:isVisible()
    elseif self.guide1Played and not self.guide2Played then
        self.hasAchi = parameter.achiBtn[1]:isVisible()
        self.onlyAchiGuide = true
        self.hasCard = hasCard
        self.hasAccount = hasAccount
        self.hasEdit = parameter.editBtn[1]:isVisible()
    end

    local curType = self.btnType.achi

    if self.hasAchi then
        curType = self.btnType.achi
        self.firstType = curType
    end

    if self.hasEdit then
        self.configs[curType].nextType = self.btnType.edit
        curType = self.btnType.edit
    end

    if curType and self.firstType == nil then
        self.firstType = curType
    end

    if hasCard then
        self.configs[curType].nextType = self.btnType.send
        curType = self.btnType.send
    end

    if curType and self.firstType == nil then
        self.firstType = curType
    end

    if hasAccount then
        self.configs[curType].nextType = self.btnType.account
        curType = self.btnType.account
    end

    if curType and self.firstType == nil then
        self.firstType = curType
    end

    self.configs[curType].nextType = nil

    local ratio = frameSize.width / frameSize.height
    if ratio > 0.6 then
        self.configs[self.btnType.achi] = {
            ccp(achiBtnPos.x + 40, achiBtnPos.y - 80),
            ccp(achiBtnPos.x + 40, achiBtnPos.y - 150),
            ccp(achiBtnPos.x + 140, achiBtnPos.y - 150),
            ccp(achiBtnPos.x + 140, achiBtnPos.y - 200),
            ccp(-20, 0),
            btn = self.achiBtn,
            panelBtn = self.panel.achiBtn,
            nextType = self.btnType.edit,
            text = localize("tutorial.my.card.text4"),
            linePosY = 4,
            textPosY = -20,
        }

        self.configs[self.btnType.edit] = {
                ccp(editBtnPos.x, editBtnPos.y - 40),
                ccp(editBtnPos.x, editBtnPos.y - 100),
                ccp(editBtnPos.x + 180, editBtnPos.y - 100),
                ccp(editBtnPos.x + 180, editBtnPos.y - 160),
                ccp(20, 0),
                btn = self.editBtn,
                panelBtn = self.panel.editBtn,
                nextType = self.btnType.send,
                text = localize("tutorial.my.card.text5"),
                linePosY = 4,
                textPosY = -20,
            }

        self.configs[self.btnType.send][2] = ccp(sendBtnPos.x, sendBtnPos.y - 90)
        self.configs[self.btnType.send][3] = ccp(sendBtnPos.x - 180, sendBtnPos.y - 90)
        self.configs[self.btnType.send][4] = ccp(sendBtnPos.x - 180, sendBtnPos.y - 120)

        self.configs[self.btnType.account][2] = ccp(bubleEditPos.x, bubleEditPos.y - 90)
        self.configs[self.btnType.account][3] = ccp(bubleEditPos.x - 80, bubleEditPos.y - 90)
        self.configs[self.btnType.account][4] = ccp(bubleEditPos.x - 80, bubleEditPos.y - 120)

        local pos = self.layerGuide:getPosition()
        self.layerGuide:setPositionY(pos.y - 150)
    end

    FrameLoader:loadArmature('skeleton/personal_center_guide')
    self:startAnimal()
    --self:setPanelBtnVisible(false)
    print("init >>>>>")
end

function PersonalCenterGuide:buildAchiBtn( btnTable )
    self.achiBtn = self.panel:buildInterfaceGroup("personal/pc_panel_achi_btn")
    local pos = btnTable[1]:getPosition()
    local size = btnTable[1]:getGroupBounds().size
    local sSize = self.achiBtn:getGroupBounds().size
    self.achiBtn:setPosition(ccp(pos.x, pos.y))
    self.achiBtn:setScaleX(size.width / sSize.width)
    self.achiBtn:setScaleY(size.height / sSize.height)
    self.panel:addChild(self.achiBtn)

    self.achiBtn:setTouchEnabled(true, 0, true)

    local totalAchiLevel = PersonalCenterManager:getData(PersonalCenterManager.TOTAL_ACHI_LEVEL)
    local medalType = AchievementManager:getMedalType(totalAchiLevel)
    self.achiBtn:getChildByName("_bg"):setVisible(false)
    local isCopper = medalType == AchievementManager.medalType.Copper
    local isSilver = medalType == AchievementManager.medalType.Silver
    local isGolden = medalType == AchievementManager.medalType.Gold

    local fntFile
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
        local achiLevelLabel  = LabelBMMonospaceFont:create(30, 30, 15, fntFile)
        local labelText = tostring(totalAchiLevel)
        local starImageSize = self.achiBtn:getGroupBounds().size
        achiLevelLabel:setString(labelText)

        achiLevelLabel:setAnchorPoint(ccp(0.5, 0.5))
        if totalAchiLevel < 10 then
            achiLevelLabel:setPositionXY(starImageSize.width/2-2, -starImageSize.height/2-10)
        else
            achiLevelLabel:setPositionXY(starImageSize.width/2-4, -starImageSize.height/2-10)
        end

        self.achiBtn:addChild(achiLevelLabel)
    end

    return self.achiBtn
end

function PersonalCenterGuide:setPanelBtnVisible(visible)
    self.panel.sendBtn:setVisible(visible)
    self.panel.editBtn:setVisible(visible)
    self.panel.bubleEdit:setVisible(visible)
end

function PersonalCenterGuide:startAnimal()
    if self.onlyAchiGuide then
        self:achiAnimation()
    else
        self:guidePanelAnimation()
    end
end

function PersonalCenterGuide:guidePanelAnimation()
    local pos = self.layerGuide:getPosition()
    local scalex = self.layerGuide:getScaleX()
    local scaley = self.layerGuide:getScaleY()

    self.layerGuide:setPositionY(pos.y + 200)
    self.layerGuide:runAction(CCMoveBy:create(0.1, ccp(0, -200)))

    local function next()
        self:btnAnimation(self.firstType)
    end

    local arr = CCArray:create()
    arr:addObject(CCDelayTime:create(0.5))
    arr:addObject(CCScaleTo:create(0.1, scalex, scaley - 0.3))
    arr:addObject(CCScaleTo:create(0.1, scalex, scaley + 0.3))
    arr:addObject(CCScaleTo:create(0.1, scalex, scaley - 0.2))
    arr:addObject(CCScaleTo:create(0.1, scalex, scaley))
    arr:addObject(CCCallFunc:create(next))
    self.layerGuide:runAction(CCSequence:create(arr))
end

function PersonalCenterGuide:btnAnimation( btnType )
    local btn = self.configs[btnType].btn
    if btn == nil then return end
    btn:setVisible(true)
    self.configs[btnType].panelBtn:setVisible(false)
    btn:setAnchorPointCenterWhileStayOrigianlPosition()

    local scalex = btn:getScaleX()
    local scaley = btn:getScaleY()

    local function next()
        self.count = 1
        self:lineAnimation(btnType)
    end

    local arr = CCArray:create()
    arr:addObject(CCScaleTo:create(0.2, scalex + 0.2 , scaley + 0.2))
    arr:addObject(CCScaleTo:create(0.1, scalex - 0.2, scaley - 0.2))
    arr:addObject(CCScaleTo:create(0.1, scalex + 0.1, scaley + 0.1))
    arr:addObject(CCScaleTo:create(0.1, scalex, scaley))
    arr:addObject(CCCallFunc:create(next))
    btn:runAction(CCSequence:create(arr))

    if self.animNode == nil then
        self.animNode = ArmatureNode:create("personal_center_guide")
        self.animNode:setAnchorPoint(ccp(0.5, 0.5))
        self.panel:addChild(self.animNode)
    end

    self.animNode:playByIndex(0, 1)
    local pos = btn:getPosition()
    if btnType == self.btnType.account or btnType == self.btnType.achi then
        local size = btn:getGroupBounds().size
        self.animNode:setPosition(ccp(pos.x + size.width / 2 - 12, pos.y - size.height / 2 + 20))
    else
        self.animNode:setPosition(ccp(pos.x, pos.y + 10))
    end
end

function PersonalCenterGuide:lineAnimation( btnType)
    local function next()
        if self.count == 4 then
            self:textAnimation(btnType)
            return 
        end
        self:lineAnimation(btnType)
    end
    print(self.count)
    local pos = self.configs[btnType][self.count]
    local pos1 = self.configs[btnType][self.count + 1]
    self.count = self.count + 1

    local scalex = 1.0
    local scaley = 1.0

    if pos1.x - pos.x < 0.001 and pos1.x - pos.x > -0.001 then
        scaley = (pos1.y - pos.y) / 4
    else
        scalex = (pos1.x - pos.x) / 4
    end

    local line = LayerColor:createWithColor(ccc3(255, 255, 255), 4, 4)

    local linePosY = 0
    if self.count == 4 then
        linePosY = self.configs[btnType].linePosY or 0
    end

    line:setPosition(ccp(pos.x, pos.y + linePosY))
    table.insert(self.childs, line)
    self.panel:addChild(line)
    line:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.2, scalex, scaley), CCCallFunc:create(next)))
end

function PersonalCenterGuide:textAnimation(btnType)
    local config = self.configs[btnType]
    local text = TextField:create(config.text, nil, 30, nil, hAlignment, kCCVerticalTextAlignmentCenter)
    text:setAnchorPoint(ccp(0.5, 0.5))
    text:setOpacity(0)
    local pos = config[4]
    local movePos = config[5]
    text:setPosition(ccp(pos.x, pos.y + config.textPosY))
    table.insert(self.childs, text)
    self.panel:addChild(text)

    text:runAction(CCMoveBy:create(0.2, movePos))

    local function next()
        if config.nextType then
            self:btnAnimation(config.nextType)
        else
            --self:businessCardAnimation()
        end
    end

    local arr = CCArray:create()
    arr:addObject(CCFadeIn:create(0.2))
    arr:addObject(CCDelayTime:create(1.2))
    arr:addObject(CCCallFunc:create(next))

    text:runAction(CCSequence:create(arr))
end

function PersonalCenterGuide:nextAnimation()
    if self.businessCardAnimationFinished ~= true and not self.onlyAchiGuide then
        self:businessCardAnimation()
    else
        self:closeAll()
    end
end

function PersonalCenterGuide:achiAnimation()
    if not self.hasAchi then 
        self:closeAll() 
        return
    end
    self.layerGuide:setVisible(false)
    self.panel.achiBtn:setVisible(false)
    self.achiBtn:setVisible(true)
    self.panel.editBtn:setVisible(self.hasEdit)
    self.panel.bubleEdit:setVisible(self.hasAccount)
    self.panel.sendBtn:setVisible(self.hasCard)
    self.sendBtn:setVisible(false)

    local pos = self.achiBtn:getPosition()
    local text = GameGuideUI:panelMini("tutorial.achievement.text2")
    local size = text:getGroupBounds().size
    text:setContentSize(CCSizeMake(size.width, size.height))
    text:ignoreAnchorPointForPosition(false)
    text:setAnchorPoint(ccp(0.5, 0.5))
    text:setPosition(ccp(pos.x + 330, pos.y + size.height))
    self.panel:addChild(text)

    table.insert(self.childs, text)

    local function complete()
        self:closeAll()
    end

    local anim = CommonSkeletonAnimation:createTutorialMoveIn2()
    anim:setScaleX(-1)
    anim:ad(ArmatureEvents.COMPLETE, complete)
    anim:setPosition(ccp(80, -200))
    self.panel:addChild(anim)
    table.insert(self.childs, anim)
end

function PersonalCenterGuide:businessCardAnimation()
    if not self.hasCard then 
        self:closeAll() 
        return
    end

    self.businessCardAnimationFinished = true

    for i,v in ipairs(self.childs) do
        if v.maskGuideBg ~= true then
            v:setVisible(false)
            v:stopAllActions()
        end
    end
    self.panel.achiBtn:setVisible(self.hasAchi)
    self.panel.editBtn:setVisible(self.hasEdit)
    self.panel.bubleEdit:setVisible(self.hasAccount)
    self.panel.sendBtn:setVisible(false)
    self.sendBtn:setVisible(true)
    local pos = self.sendBtn:getPosition()
    local text = GameGuideUI:panelMini("tutorial.my.card.text3")
    local size = text:getGroupBounds().size
    text:setContentSize(CCSizeMake(size.width, size.height))
    text:ignoreAnchorPointForPosition(false)
    text:setAnchorPoint(ccp(0.5, 0.5))
    text:setPosition(ccp(pos.x + 20, pos.y + size.height + 200))
    self.panel:addChild(text)

    table.insert(self.childs, text)

    local function complete()
        self:closeAll()
    end

    local anim = CommonSkeletonAnimation:createTutorialMoveIn2()
    anim:ad(ArmatureEvents.COMPLETE, complete)
    anim:setPosition(ccp(550, -600))
    self.panel:addChild(anim)
    table.insert(self.childs, anim)
end

function PersonalCenterGuide:closeAll()
    self.isCloseAll = true
    --self:setPanelBtnVisible(true)
    self.panel.bubleEdit:setVisible(self.hasAccount)

    local hasCard = self.hasCard
    if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
        hasCard = self.mitalkHasCard or true
    end
    self.panel.sendBtn:setVisible(hasCard)

    self.panel.editBtn:setVisible(self.hasEdit)
    self.panel.achiBtn:setVisible(self.hasAchi)

    for i,v in ipairs(self.childs) do
        v:setVisible(false)
        v:stopAllActions()
        v:removeFromParentAndCleanup(true)
        v:dispose()
    end
    if self.panel then
        self.panel:updateProfile()
    end

    ArmatureFactory:remove("skeleton", "personal_center_guide")
end

return PersonalCenterGuide