WeeklyRaceRankAnimation = class()

local function getHeadImage(uid, headurl)
    local avatar = CocosObject:create()
    local head = HeadImageLoader:create(uid, headurl)
    local headBg = SpriteColorAdjust:createWithSpriteFrameName('ui_images/ui_image_headicon_30000')
    local sunshine = SpriteColorAdjust:createWithSpriteFrameName('sunshine0000')
    local glow = SpriteColorAdjust:createWithSpriteFrameName('glow0000')
    local star = SpriteColorAdjust:createWithSpriteFrameName('star0000')
    head:setScale(1.7)
    head:setPositionX(-4)
    headBg:setScale(1.612)
    star:setScale(0.6)
    star:setOpacity(0)
    sunshine:setScale(1.4)
    sunshine:setOpacity(0)
    avatar:addChild(sunshine)
    avatar:addChild(star)
    avatar:addChild(glow)
    avatar:addChild(headBg)
    avatar:addChild(head)
    avatar:setContentSize(CCSizeMake(0, 0))
    sunshine:setAnchorPoint(ccp(0.5, 0.5))
    glow:setAnchorPoint(ccp(0.5, 0.5))
    star:setAnchorPoint(ccp(0.4, 0.5))
    sunshine:setAnchorPoint(ccp(0.5, 0.5))

    avatar.getShiningAction = function (_self)
        local starAction = CCTargetedAction:create(star.refCocosObj, 
                            CCSequence:createWithTwoActions(
                            CCFadeIn:create(0.01),
                            CCSpawn:createWithTwoActions(CCFadeOut:create(0.6), CCScaleTo:create(0.3, 1.6))
                            ))
        local sunshineAction = CCTargetedAction:create(sunshine.refCocosObj, 
                                CCSequence:createWithTwoActions(
                                    CCFadeIn:create(0.01),
                                    CCRepeat:create(CCRotateBy:create(5, 360), 9999)))
        local glowAction = CCTargetedAction:create(glow.refCocosObj, CCFadeIn:create(0.1))
        local actions = CCArray:create()
        actions:addObject(starAction)
        actions:addObject(sunshineAction)
        actions:addObject(glowAction)
        return CCTargetedAction:create(avatar.refCocosObj, CCSpawn:create(actions))
    end
    avatar.getCompressAction = function (_self)
        local compress = CCSequence:createWithTwoActions(CCScaleTo:create(0.1, 1.3, 0.7), CCScaleTo:create(0.1, 1, 1))
        return CCTargetedAction:create(avatar.refCocosObj, compress)
    end
    return avatar
end

local function getCrown()
    local crown = SpriteColorAdjust:createWithSpriteFrameName('crown0000')
    crown:setAnchorPoint(ccp(0.5, 0.2))
    crown.getSwingAction = function (_self)
        local compress = CCSequence:createWithTwoActions(CCScaleTo:create(0.04, 1.3, 0.7), CCScaleTo:create(0.04, 1, 1))
        local seq = CCArray:create()
        seq:addObject(compress)
        seq:addObject(CCRotateTo:create(0.07, -20))
        seq:addObject(CCRotateTo:create(0.14, 20))
        seq:addObject(CCRotateTo:create(0.14, -20))
        seq:addObject(CCRotateTo:create(0.07, 0))
        local actions = CCEaseSineIn:create(CCSequence:create(seq))
        return CCTargetedAction:create(crown.refCocosObj, actions)
    end
    return crown
end

local function getLight(left)
    local light = SpriteColorAdjust:createWithSpriteFrameName('light0000')
    light:setAnchorPoint(ccp(0.5, 1))

    light.getSwingAction = function (_self)
        local angle 
        if left then 
            angle = -30 
        else 
            angle = 30
        end
        local rotate
        if left then 
            rotate = CCRepeat:create(CCSequence:createWithTwoActions(CCRotateBy:create(0.8, 15), CCRotateBy:create(0.8, -15)), 9999)
        else 
            rotate = CCRepeat:create(CCSequence:createWithTwoActions(CCRotateBy:create(0.8, -15), CCRotateBy:create(0.8, 15)), 9999)
        end
        light:setRotation(angle)
        return CCTargetedAction:create(light.refCocosObj, rotate)
    end
    return light
end

function WeeklyRaceRankAnimation:playNo1Animation(panelWithRank)
    FrameLoader:loadImageWithPlist("ui/weekly_race_animation.plist")
    local builder = InterfaceBuilder:createWithContentsOfFile('ui/weekly_race_animation.json')
    local vo = Director:sharedDirector():getVisibleOrigin()
    local vs = Director:sharedDirector():getVisibleSize()
    local btnRes = builder:buildGroup('ui_buttons/ui_button_label')
    local btn = GroupButtonBase:create(btnRes)
    btn:setString(Localization:getInstance():getText('share.feed.button.achive'))
    local txt = TextField:create(Localization:getInstance():getText('weekly.race.animation.txt.no1'), nil, 34, CCSizeMake(600, 100))
    txt:setAnchorPoint(ccp(0.5, 0.5))
    local uid = UserManager:getInstance().profile.uid
    local headurl = UserManager:getInstance().profile.headUrl
    local headImage = getHeadImage(uid, headurl)
    local crown = getCrown()
    local leftLight = getLight(true)
    local rightLight = getLight(false)
    local container = LayerColor:create()

    local function closePanel()
        if not container.isDisposed then
            container:removeFromParentAndCleanup(true)
            InterfaceBuilder:unloadAsset('ui/weekly_race_animation.json')
            FrameLoader:unloadImageWithPlists({"ui/weekly_race_animation.plist"})
        end
    end
    local closeBtn = builder:buildGroup('ui_buttons/ui_button_close_green')
    closeBtn:setTouchEnabled(true)
    closeBtn:ad(DisplayEvents.kTouchTap, closePanel)
    closeBtn:setPosition(ccp(vs.width - 50, vs.height - 50))
    container:addChild(closeBtn)

    local function onBtnTapped()
        if not container.isDisposed then
            closePanel()
            if panelWithRank and not panelWithRank.isDisposed then
                local levelId = panelWithRank.levelSuccessTopPanel.levelId
                if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
                	SnsUtil.weeklyRaceShareNo1( PlatformShareEnum.kMiTalk, levelId)
                else
                	SnsUtil.weeklyRaceShareNo1( PlatformShareEnum.kWechat, levelId)
                end
            end
        end
    end

    local function enter(container, leftLight, rightLight, crown, headImage, btn, txt)
        print('enter')
        local headPos = ccp(vs.width / 2, vs.height / 2)
        local crownPos = ccp(headPos.x, headPos.y + 150)
        local leftLightPos = ccp(vs.width / 10, vs.height *(9/10))
        local rightLightPos = ccp(vs.width / 10 * 9, vs.height *(9/10))
        local btnPos = ccp(vs.width / 2, vs.height / 5)
        local txtPos = ccp(btnPos.x, btnPos.y + 100)
        btn:ad(DisplayEvents.kTouchTap, onBtnTapped)
        btn:setPosition(btnPos)
        btn:setVisible(false)
        txt:setOpacity(0)
        txt:setPosition(txtPos)
        crown:setPosition(ccp(crownPos.x, vs.height + 100))
        headImage:setPosition(ccp(headPos.x, vo.x - 100))
        leftLight:setPosition(leftLightPos)
        rightLight:setPosition(rightLightPos)
        leftLight:setOpacity(0)
        rightLight:setOpacity(0)

        local headEnter = CCTargetedAction:create(headImage.refCocosObj, CCEaseBounceOut:create(CCMoveTo:create(0.3, headPos)))
        local delay1 = CCDelayTime:create(0.2)
        local leftLightEnter = CCTargetedAction:create(leftLight.refCocosObj, CCFadeIn:create(0.01))
        local delay2 = CCDelayTime:create(0.3)
        local rightLightEnter = CCTargetedAction:create(rightLight.refCocosObj, CCFadeIn:create(0.01))
        local crownEnter = CCTargetedAction:create(crown.refCocosObj, CCEaseBounceOut:create(CCMoveTo:create(0.2, crownPos)))
        local crownStart = crown:getSwingAction()
        local headStart = headImage:getShiningAction()
        local leftLightStart = leftLight:getSwingAction()
        local rightLightStart = rightLight:getSwingAction()
        local txtShow = CCTargetedAction:create(txt.refCocosObj, CCFadeIn:create(0.01))
        local btnShow = CCTargetedAction:create(btn.refCocosObj, CCCallFunc:create(function () btn:setVisible(true) end))
        local arriveArray = CCArray:create()
        arriveArray:addObject(crownStart)
        arriveArray:addObject(headStart)
        arriveArray:addObject(leftLightStart)
        arriveArray:addObject(rightLightStart)
        arriveArray:addObject(txtShow)
        arriveArray:addObject(btnShow)
        local onCrownArrive = CCSpawn:create(arriveArray)
        local enterArray = CCArray:create()
        enterArray:addObject(headEnter)
        enterArray:addObject(delay1)
        enterArray:addObject(leftLightEnter)
        enterArray:addObject(delay2)
        enterArray:addObject(rightLightEnter)
        enterArray:addObject(crownEnter)
        enterArray:addObject(onCrownArrive)
        local enterAction = CCSequence:create(enterArray)
        container:runAction(enterAction)
    end

    container:setContentSize(CCSizeMake(vs.width, vs.height))
    container:setColor(ccc3(0,0,0))
    container:setOpacity(230)
    container:setTouchEnabled(true, 0, true)
    
    local scene = Director:sharedDirector():getRunningScene()
    container:addChild(leftLight)
    container:addChild(rightLight)
    container:addChild(headImage)
    container:addChild(crown)
    container:addChild(txt)
    container:addChild(btnRes)
    container:setPosition(ccp(vo.x, vo.y))
    scene:addChild(container)
    enter(container, leftLight, rightLight, crown, headImage, btnRes, txt)
end
local function createAnimal( name, parent )
    local position = animal_positions[name]
    local node = ArmatureNode:create(name)
    node.name = name
    node:playByIndex(0)
    node:setPosition(ccp(position.x, -position.y))
    node:setVisible(false)
    parent:addChild(node)
    return node
end
function WeeklyRaceRankAnimation:playSurpassingAnimation(surpassedFriend, panelWithRank)
    if not surpassedFriend then return end
    FrameLoader:loadImageWithPlist("ui/weekly_race_animation.plist")
    FrameLoader:loadArmature("skeleton/chicken_fly_animation")
    local builder = InterfaceBuilder:createWithContentsOfFile('ui/weekly_race_animation.json')
    local vo = Director:sharedDirector():getVisibleOrigin()
    local vs = Director:sharedDirector():getVisibleSize()
    local friendName = HeDisplayUtil:urlDecode(surpassedFriend.name)
    local friendUid = surpassedFriend.uid
    local friendHeadUrl = surpassedFriend.headUrl

    local uid = UserManager:getInstance().profile.uid
    local headurl = UserManager:getInstance().profile.headUrl
    local myHead = getHeadImage(uid, headurl)
    myHead:setScale(0.8)
    local friendHead = getHeadImage(friendUid, friendHeadUrl)
    friendHead:setScale(0.6)

    local container = LayerColor:create()
    container:setContentSize(CCSizeMake(vs.width, vs.height))
    container:setColor(ccc3(0,0,0))
    container:setOpacity(230)
    container:setTouchEnabled(true, 0, true)

    local greenBg2 = SpriteColorAdjust:createWithSpriteFrameName('greenBg20000')
    local greenBg = SpriteColorAdjust:createWithSpriteFrameName('greenBg0000')
    greenBg:setAnchorPoint(ccp(0, 1))
    greenBg2:setAnchorPoint(ccp(0, 0))

    local bgWidth = greenBg:getContentSize().width
    local bgHeight = greenBg:getContentSize().height
    local greenBg2Height = greenBg2:getContentSize().height
    local greenBg2Width = greenBg2:getContentSize().width
    local greenBgPos = ccp((vs.width - bgWidth) / 2, vs.height / 2)
    local greenBg2Pos = ccp(greenBgPos.x, greenBgPos.y - 3)
    local chickenPos = ccp(greenBgPos.x + 130, greenBgPos.y)
    local myHeadPos = ccp(greenBgPos.x + greenBg2Width / 2, greenBgPos.y - bgHeight / 2 - 20)
    local friendHeadPos = ccp(greenBgPos.x + bgWidth / 3 * 2 + 50, greenBgPos.y - bgHeight / 2)
    local btnPos = ccp(vs.width / 2, vs.height / 7)
    local txtPos = ccp(btnPos.x, btnPos.y + 80)
    local btnRes = builder:buildGroup('ui_buttons/ui_button_label')
    local btn = GroupButtonBase:create(btnRes)
    btn:setString(Localization:getInstance():getText('share.feed.button.achive'))
    local txt = TextField:create(Localization:getInstance():getText('weekly.race.animation.txt.surpass', {name = friendName}), nil, 34, CCSizeMake(600, 100))
    txt:setAnchorPoint(ccp(0.5, 0.5))
    local chicken = ArmatureNode:create('chickenzs')
    chicken:playByIndex(0)
    chicken:setAnimationScale(0.5)

    local function closePanel()
        if not container.isDisposed then
            container:removeFromParentAndCleanup(true)
            InterfaceBuilder:unloadAsset('ui/weekly_race_animation.json')
            FrameLoader:unloadImageWithPlists({"ui/weekly_race_animation.plist"})
        end
    end
    local closeBtn = builder:buildGroup('ui_buttons/ui_button_close_green')
    closeBtn:setTouchEnabled(true)
    closeBtn:ad(DisplayEvents.kTouchTap, closePanel)
    closeBtn:setPosition(ccp(vs.width - 50, vs.height - 50))
    container:addChild(closeBtn)

    local function onBtnTapped()
        if not container.isDisposed then
            container:removeFromParentAndCleanup(true)
            InterfaceBuilder:unloadAsset('ui/weekly_race_animation.json')
            FrameLoader:unloadImageWithPlists({"ui/weekly_race_animation.plist"})

            if panelWithRank and not panelWithRank.isDisposed then
                local levelId = panelWithRank.levelSuccessTopPanel.levelId
                if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
                	SnsUtil.weeklyRaceShareSurpass( PlatformShareEnum.kMiTalk, levelId)
                else
                	SnsUtil.weeklyRaceShareSurpass( PlatformShareEnum.kWechat, levelId)
                end
            end
        end
    end
    btn:ad(DisplayEvents.kTouchTap, onBtnTapped)

    local function enter(container, chicken, greenBg2, myHead, friendHead, btn, txt)
        greenBg2:setScaleY(0)
        greenBg:setPosition(greenBgPos)
        greenBg2:setPosition(greenBg2Pos)
        chicken:setPosition(chickenPos)
        txt:setOpacity(0)
        txt:setPosition(txtPos)
        btn:setVisible(false)
        btn:setPosition(btnPos)
        myHead:setPosition(myHeadPos)
        friendHead:setPosition(friendHeadPos)
        local greenBg2Action = CCTargetedAction:create(greenBg2.refCocosObj, 
                                CCSequence:createWithTwoActions(
                                    CCEaseExponentialOut:create(CCScaleTo:create(0.5, 1, 0.5)),
                                    CCEaseExponentialOut:create(CCScaleTo:create(0.5, 1, 1))
                                    )
                                )
        local chickenAction = CCTargetedAction:create(chicken.refCocosObj, 
                                CCSequence:createWithTwoActions(
                                    CCSequence:createWithTwoActions(
                                       CCEaseExponentialOut:create(CCMoveBy:create(0.5, ccp(0, greenBg2Height / 2))),
                                       CCEaseExponentialOut:create(CCMoveBy:create(0.5, ccp(0, greenBg2Height / 2)))
                                        ),                                
                                    CCCallFunc:create(function () print('setAnimationScale') chicken:setAnimationScale(0.8) end)
                                    )
                                )
        local myHeadAction = CCTargetedAction:create(myHead.refCocosObj, 
                                    CCSequence:createWithTwoActions(
                                        CCEaseExponentialOut:create(CCMoveBy:create(0.5, ccp(0, greenBg2Height / 2))),
                                        CCEaseExponentialOut:create(CCMoveBy:create(0.5, ccp(0, greenBg2Height / 2)))
                                        )
                                )
        local arr = CCArray:create()
        arr:addObject(greenBg2Action)
        arr:addObject(chickenAction)
        arr:addObject(myHeadAction)
        local spawn = CCSpawn:create(arr)
        local arr2 = CCArray:create()
        local headShining = myHead:getShiningAction()
        local btnAction = CCCallFunc:create(function () print('setVisible')  btn:setVisible(true) end)
        local txtAction = CCTargetedAction:create(txt.refCocosObj, CCFadeIn:create(0.01))
        arr2:addObject(spawn)
        arr2:addObject(btnAction)
        arr2:addObject(txtAction)
        arr2:addObject(headShining)
        container:runAction(CCSequence:create(arr2))

    end

    local scene = Director:sharedDirector():getRunningScene()
    container:setPosition(ccp(vo.x, vo.y))
    container:addChild(txt)
    container:addChild(btnRes)
    container:addChild(greenBg)
    container:addChild(greenBg2)
    container:addChild(myHead)
    container:addChild(friendHead)
    container:addChild(chicken)
    scene:addChild(container)
    enter(container, chicken, greenBg2, myHead, friendHead, btnRes, txt)

end
