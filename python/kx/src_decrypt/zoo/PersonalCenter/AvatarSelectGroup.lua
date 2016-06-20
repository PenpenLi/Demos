local AvatarSelectGroup = class()

-- local print = function ( str )
-- 	oldPrint("[AvatarSelectGroup] "..str)
-- end

-- local print = oldPrint

function AvatarSelectGroup:buildGroup(manager, moreAvatars, avatar, nameLabel, changePlayerCb)
    local group = AvatarSelectGroup.new()
    group:init(manager, moreAvatars, avatar, nameLabel, changePlayerCb)
    return group
end

function AvatarSelectGroup:init(manager, moreAvatars, avatar, nameLabel, changePlayerCb)
	self.moreAvatarList = {}
    self.manager = manager
    self.changePlayerCb = changePlayerCb

    self.customAvatarIndex = 11
    local fileId = UserManager:getInstance().profile.fileId
    self.customHeadUrl = (fileId and fileId ~= "") and ("http://animal-10001882.image.myqcloud.com/"..fileId) 
                                                    or tostring(self.customAvatarIndex)
    
    self.customHeadChangeList = {}

    local config = {
        [PlatformAuthEnum.kWeibo]  = "微博",
        [PlatformAuthEnum.kQQ]     = "QQ",
        [PlatformAuthEnum.kWDJ]    = "豌豆荚",
        [PlatformAuthEnum.kMI]     = "小米",
        [PlatformAuthEnum.k360]    = "360",
    }

    local function changeNameAndHeadTip(tipKey)
        if _G.sns_token then
            local authorizeType = SnsProxy:getAuthorizeType()
            local text = localize(tipKey, {platform = config[authorizeType]})
            CommonTip:showTip(text)
        end
    end

    if nameLabel then
        self.nameLabel = nameLabel
        local touch = self.nameLabel:getChildByName("touch")
        touch:setVisible(false) 
        self.nameLabel:getChildByName("label"):setString(HeDisplayUtil:urlDecode(manager:getData(manager.NAME)))
        self.nameLabel:getChildByName("inputBegin"):setVisible(false)

        self.isNickNameUnModifiable = manager:getData(manager.NAME_MODIFIABLE)
        if not self.isNickNameUnModifiable then 
            self.nameLabel:getChildByName("label"):setVisible(false)
            self:initInput()
        else
            self.nameLabel:setTouchEnabled(true)
            local function tips()
                if not kUserLogin then
                    CommonTip:showTip(localize("my.card.panel.warning.tip1"))
                else
                    changeNameAndHeadTip("my.card.edit.panel.tip1")
                end
            end
            self.nameLabel:ad(DisplayEvents.kTouchTap, tips)
        end
    end

	self.moreAvatars = moreAvatars
	self.moreAvatars:setVisible(false)
    self.shadow = self.moreAvatars:getChildByName('shadow1')

    --点击shadow 隐藏 moreAvatars
    local function onShadowTouch()
        self:onAvatarTouch()
    end
    local inputLayer = Layer:create()
    inputLayer:setPositionX(-200)
    inputLayer:setPositionY(-1280)
    moreAvatars:getParent():addChildAt(inputLayer, moreAvatars:getZOrder() - 1)
    local shadowSize = self.shadow:getContentSize()
    inputLayer:setContentSize(CCSizeMake(shadowSize.width, shadowSize.height))
    inputLayer:addEventListener(DisplayEvents.kTouchTap, onShadowTouch)
    inputLayer:setTouchEnabled(true, 0, true)
    inputLayer:setVisible(false)
    self.shadow.inputLayer = inputLayer

    self.avatar = avatar
    self.playerAvatar = self:initAvatar(self.avatar:getChildByName("settingavatarframework"))
	
	local headUrl = self.manager:getData(self.manager.HEAD_URL)
    self.playerAvatar:changeImage(nil, headUrl, true)

    self.isHeadImageUnModifiable = manager:getData(manager.HEAD_MODIFIABLE)
    if self.isHeadImageUnModifiable then
        local arrow = self.avatar:getChildByName("avatarArrow") 
        if arrow then arrow:setVisible(false) end
    end

    local function onAvatarTouch()
        if not kUserLogin then
            CommonTip:showTip(localize("my.card.panel.warning.tip2"))
            return
        end

        if self.isHeadImageUnModifiable then
            changeNameAndHeadTip("my.card.edit.panel.tip2")
            return
        end
        self:onAvatarTouch()
    end
    self:initMoreAvatars(self.moreAvatars)
    self.avatar:setTouchEnabled(true, 0, true)
    self.avatar:setButtonMode(true)
    self.avatar:addEventListener(DisplayEvents.kTouchTap, onAvatarTouch)

    print("init >>>>>")
end

function AvatarSelectGroup:setActive(state)
    if state then
        self.avatar:setTouchEnabled(true, 0, true)
        self.avatar:getChildByName('avatarArrow'):setVisible(true)
    else
        self.avatar:getChildByName('avatarArrow'):setVisible(false)
        self.avatar:setTouchEnabled(false)
    end
end

function AvatarSelectGroup:closeMoreAvatars()
    if self.moreAvatars:isVisible() then
        self:onAvatarTouch()
    end
end

function AvatarSelectGroup:setFriendRankingMode()
    self.friendRankingMode = true
    self.shadow:setVisible(false)
    self.avatar:getChildByName('avatarArrow'):setVisible(false)
end

function AvatarSelectGroup:updateClickState()
    local isNickNameUnModifiable = self.manager:getData(self.manager.NAME_MODIFIABLE)
    if isNickNameUnModifiable ~= self.isNickNameUnModifiable then
        if self.input and isNickNameUnModifiable then
            self.input:setVisible(false)
            self.input:removeFromParentAndCleanup(true)
            self.input:dispose()
            self.nameLabel:getChildByName("label"):setString(HeDisplayUtil:urlDecode(self.manager:getData(self.manager.NAME)))
            self.nameLabel:getChildByName("label"):setVisible(true)
        end

        self.isNickNameUnModifiable = isNickNameUnModifiable
    end

    local isHeadImageUnModifiable = self.manager:getData(self.manager.HEAD_MODIFIABLE)
    if self.isHeadImageUnModifiable ~= isHeadImageUnModifiable and not isHeadImageUnModifiable then
        local arrow = self.avatar:getChildByName("avatarArrow") 
        if arrow then arrow:setVisible(false) end
        self.isHeadImageUnModifiable = isHeadImageUnModifiable
    end

    print("updateClickState.........")
end

function AvatarSelectGroup:initInput(onBeginCallback)
    local user = UserManager.getInstance().user
    local profile = UserManager.getInstance().profile   
    local inputSelect = self.nameLabel:getChildByName("inputBegin")
    local inputSize = inputSelect:getContentSize()
    local inputPos = inputSelect:getPosition()
    inputSelect:setVisible(true)
    inputSelect:removeFromParentAndCleanup(false)

    local function onTextBegin()
        local place = self.originalPlace or 1
        DcUtil:UserTrack({category='my_card', sub_category="my_card_click_edit_name", place = place}, true)
        if onBeginCallback then onBeginCallback() end
    end
    
    local function onTextEnd()
        if self.input then
            local profile = UserManager.getInstance().profile
            local text = self.input:getText() or ""
            if text ~= "" then
                -- 敏感词过滤
                if IllegalWordFilterUtil.getInstance():isIllegalWord(text) then
                    local oldName = HeDisplayUtil:urlDecode(profile.name or "")
                    self.input:setText(oldName)
                    CommonTip:showTip(Localization:getInstance():getText("error.tip.illegal.word"), "negative")
                else
                    if profile.name ~= text then
                        --profile:setDisplayName(text)
                        if self.originalPlace == 0 then
                            self.manager:setData(self.manager.NAME, text)
                            DcUtil:UserTrack({category='my_card', sub_category="my_card_profile_name"}, true)
                            self.manager:uploadUserProfile()
                        else
                            if self.changeName then
                                self.changeName(text)
                            end
                        end
                    end
                end
            else
                self.input:setText(profile:getDisplayName())
                CommonTip:showTip(Localization:getInstance():getText("game.setting.panel.username.empty"), "negative")
            end
        end
    end

    local position = ccp(inputPos.x + inputSize.width/2, inputPos.y - inputSize.height/2)
    local input = TextInputIm:create(inputSize, Scale9Sprite:createWithSpriteFrameName("personal/ui_empty0000"), inputSelect.refCocosObj)
    
    if __WP8 then
        self:clampWp8Input(input)
    end

    input.originalX_ = position.x
    input.originalY_ = position.y

    input:setText(profile:getDisplayName())
    input:setPosition(position)
    input:setFontColor(ccc3(0,0,0))
    input:setMaxLength(12)
    input:ad(kTextInputEvents.kBegan, onTextBegin)
    input:ad(kTextInputEvents.kEnded, onTextEnd)
    self.nameLabel:addChild(input)
    self.input = input

    if not __IOS then
        self.input.refCocosObj:setTouchPriority(0)
    end

    inputSelect:dispose()
end

function AvatarSelectGroup:onAvatarTouch()
    if self.isHeadImageUnModifiable then
        self.moreAvatars:setVisible(false)
        if self.takePhotoBtn then self.takePhotoBtn:setVisible(false) end
        self.shadow.inputLayer:setVisible(false)
        return
    end

    if self.moreAvatars:isVisible() then 
        self.moreAvatars:setVisible(false)
        if self.takePhotoBtn then self.takePhotoBtn:setVisible(false) end
        self.shadow.inputLayer:setVisible(false)
    else 
        local place = self.originalPlace or 1
        DcUtil:UserTrack({category='my_card', sub_category="my_card_click_edit_photo", place = place}, true)
        self.moreAvatars:setVisible(true)
        if self.takePhotoBtn then self.takePhotoBtn:setVisible(true) end
        self.shadow.inputLayer:setVisible(true)
        if self.closeOtherPanel then
            self.closeOtherPanel()
        end
    end
end

function AvatarSelectGroup:clampWp8Input( input )
    input.setText = function ( _input, oriText )
        local width = 200
        local posX=0
        local posY=0
        local cacheWidths = {}
        local cacheLabels = {}
        local function createLabel(text)
            if cacheLabels[text] and cacheLabels[text]:getParent() then 
                 cacheLabels[text] = nil
            end
            if not cacheLabels[text] then 
                cacheLabels[text] = CCLabelTTF:create(text,"",30)
            end
            return cacheLabels[text]
        end
        local function measureWidth(text)
            if not cacheWidths[text] then 
                local label = createLabel(text)
                cacheWidths[text] = label:getContentSize().width
            end
            return cacheWidths[text]
        end

        local t = {}
        for uchar in string.gfind(oriText, "[%z\1-\127\194-\244][\128-\191]*") do
            t[#t + 1] = uchar
        end

        local function sub( s,e )
            local t2 = {}
            for i=s,e do
                t2[i-s+1] = t[i]
            end
            return table.concat(t2,"")
        end

        local start = 1
        local str = ""

        local len = #t - start + 1
        local _end = #t
        local i = 2
        local newLine = false
        while true do 
            newLine = false
            local str1 = sub(start,_end)
            if str1 == "" then
                str = ""
                _end = start - 1
                newLine = true
                break
            end

            local w1 = measureWidth(str1)
            if _end == #t and posX + w1 <= width then --or str1 == "" 
                str = str1
                break
            end
            local str2 = sub(start,math.min(#t,_end + 1))
            local w2 = measureWidth(str2)

            if posX + w1 <= width and posX + w2 > width then 
                str = str1
                newLine = true
                break
            end

            if posX + w1 > width then 
                _end = _end - math.ceil(len / i) 
            elseif posX + w2 <= width then 
                _end = _end + math.ceil(len / i)
            end
            i = i * 2
        end

         _input.refCocosObj:setText(str)
    end
end

function AvatarSelectGroup:initAvatar( group )
    if not group then return nil end
    local avatarPlaceholder = group:getChildByName("avatarPlaceholder")
    local frameworkChosen = group:getChildByName("frameworkChosen")
    if frameworkChosen then frameworkChosen:setVisible(false) end

    local hitArea = CocosObject:create()
    hitArea.name = kHitAreaObjectName
    hitArea:setContentSize(CCSizeMake(100,100))
    hitArea:setPosition(ccp(0, 0))
    avatarPlaceholder:addChild(hitArea)

    group.chooseIcon = frameworkChosen
    group.select = function ( avatar, val )
        avatar.selected = val
        if avatar.chooseIcon then avatar.chooseIcon:setVisible(val) end
    end
    group.changeImage = function( avatar, userId, headUrl, isChangePlayer)
        if avatar == nil or headUrl == nil or headUrl == "nil" or headUrl == "" then return end

        local oldImageIndex = nil

        if avatar.isCustomAvatar == true then
            table.insert(self.customHeadChangeList, headUrl)
        end

        if avatar.headImage then 
            oldImageIndex = avatar.headImage.headImageUrl
            avatar.headImage:removeFromParentAndCleanup(true)
            avatar.headImage = nil
        end

        local frameSize = avatarPlaceholder:getContentSize()
        local function onImageLoadFinishCallback(clipping)
            if avatar.isDisposed then return end
            local clippingSize = clipping:getContentSize()
            local scale = frameSize.width/clippingSize.width
            clipping:setScale(scale*0.83)
            clipping:setPosition(ccp(frameSize.width/2-2,frameSize.height/2))

            local isNeedChange = true

            if avatar.isCustomAvatar == true then
                local lastHeadUrl = self.customHeadChangeList[#self.customHeadChangeList]
                if tostring(lastHeadUrl) ~= tostring(headUrl) then
                    isNeedChange = false
                    self.customHeadChangeList = {}
                    clipping:dispose()
                end
                avatar.isCustomAvatar = false
            end

            if avatar.headImage ~= nil then
                isNeedChange = false
                if not clipping.isDisposed then
                    clipping:dispose()
                end
            end

            if isNeedChange then
                avatarPlaceholder:addChild(clipping)
                avatar.headImage = clipping
                if (not self.isHeadImageUnModifiable) and tostring(headUrl) and self.playerAvatar ~= avatar then
                    if string.find(tostring(headUrl), "http://") ~= nil then
                        for u,v in pairs(self.moreAvatarList) do
                            if string.find(tostring(u), "http://") ~= nil then
                                self.moreAvatarList[tostring(u)] = nil
                            end
                        end
                    end
                    self.moreAvatarList[tostring(headUrl)] = avatar
                end
                if isChangePlayer and self.changePlayerCb then 
    	            self.changePlayerCb(clipping, headUrl)
    	        end
            end
        end

        HeadImageLoader:create(userId, headUrl, onImageLoadFinishCallback)

        return oldImageIndex
    end
    return group
end

function AvatarSelectGroup:changeAvatarImage( headUrl, isCustom)
    if isCustom and self.customHeadUrl and self.moreAvatarList[self.customHeadUrl] then
        local customAvatar = self.moreAvatarList[self.customHeadUrl]
        self.moreAvatarList[self.customHeadUrl] = nil
        self.moreAvatarList[tostring(headUrl)] = customAvatar
        customAvatar.isCustomAvatar = true
        customAvatar:changeImage(nil, headUrl)
        customAvatar:setVisible(true)
        self.customHeadUrl = headUrl
    end

    local oldHeadAvatar = self.moreAvatarList[tostring(headUrl)]
    local oldImageIndex = self.defaultAvatar:changeImage(nil, headUrl)
    
    if self.playerAvatar then self.playerAvatar:changeImage(nil, tostring(headUrl), true) end
    if oldHeadAvatar then
        oldHeadAvatar:changeImage("exp."..tostring(oldImageIndex), tostring(oldImageIndex))
    end

    if not isCustom and 
        string.find(tostring(headUrl), "http://") == nil and
        string.find(tostring(oldImageIndex), "http://") ~= nil and
        oldHeadAvatar ~= self.lastAvatar then
        local oriHeadUrl = self.lastAvatar:changeImage(nil, tostring(oldImageIndex))
        oldHeadAvatar:changeImage(nil, tostring(oriHeadUrl))
    end
end

function AvatarSelectGroup:initMoreAvatars( group )
    local profile_url = self.manager:getData(self.manager.HEAD_URL)
    local kMaxHeadImages = UserManager.getInstance().kMaxHeadImages

    for index = 0 , kMaxHeadImages do
        local avatar = self:initAvatar(group:getChildByName("p"..(index + 1)))
        if avatar then
            avatar.index = index
            avatar:changeImage("exp."..index, index)
        end

        if index == 10 then
            self.defaultAvatar = avatar
        end
    end

    local customAvatar = self:initAvatar(group:getChildByName("p"..(self.customAvatarIndex + 1)))
    self.lastAvatar = customAvatar
    
    if self.customHeadUrl ~= tostring(self.customAvatarIndex) then
        self.moreAvatarList[self.customHeadUrl] = customAvatar
        customAvatar.isCustomAvatar = true
        customAvatar:changeImage("exp.", self.customHeadUrl)
        customAvatar:setVisible(true)
    else
        self.moreAvatarList[tostring(self.customAvatarIndex)] = customAvatar
        customAvatar:setVisible(false)
    end

    local function onAvatarItemTouch( evt )
        for headUrl, v in pairs(self.moreAvatarList) do
            if v:hitTestPoint(evt.globalPosition, true) and v:isVisible() then
                self:onAvatarTouch()
                --if tonumber(profile_url) ~= headUrl then
                    self:changeAvatarImage(headUrl)
                --end
                break
            end
        end
    end

    group:setTouchEnabled(true, 0, true)
    group:ad(DisplayEvents.kTouchTap, onAvatarItemTouch)
    self.defaultAvatar:select(true)

    self:changeAvatarImage(profile_url)

    local showPhotoBtn = self.manager:getData(self.manager.ENABLE_CUSTOM_HEAD)

    local takePhotoBtnUI = self.moreAvatars:getChildByName('take_a_photo')
    if not showPhotoBtn then
        --Layer 1
        local bgLayer = self.moreAvatars:getChildByName('Layer 1')
        local size = bgLayer:getContentSize()
        bgLayer:setContentSize(CCSizeMake(size.width, size.height - 110))
        takePhotoBtnUI:setVisible(false)
    else
        self.takePhotoBtn = GroupButtonBase:create(takePhotoBtnUI)
        self.takePhotoBtn:setString(localize('my.card.edit.panel.text1'))
        local function onTakePhotoBtnTapped()
            PaymentNetworkCheck.getInstance():check(
            function ()
                self:buildPhotoView()
            end, 
            function ()
                CommonTip:showTip(localize("dis.connect.warning.tips"), "negative",nil, 2)
            end)
        end
        self.takePhotoBtn:addEventListener(DisplayEvents.kTouchTap, onTakePhotoBtnTapped)
        self.takePhotoBtn.groupNode:setTouchEnabled(false)
        self.takePhotoBtn.groupNode:setTouchEnabled(true, 0, true)
        self.takePhotoBtn:setVisible(false)
    end
end

local function buildPhotoBtn( name, width, height, tap )
    local btn = LayerColor:createWithColor(ccc3(255,255,255), width, height)
    btn:setTouchEnabled(true, 0, true)
    btn:ad(DisplayEvents.kTouchTap, tap)

    local text = TextField:create(name, nil, 40, nil, hAlignment, kCCVerticalTextAlignmentCenter)
    text:setColor(ccc3(208,159,82))
    text:setPosition(ccp(width / 2, height / 2))
    btn:addChild(text)
    return btn
end

function AvatarSelectGroup:closePhotoView()
    if self.photoView and not self.photoView.isDisposed then
        self.photoView:removeFromParentAndCleanup(true)
        self.photoView:dispose()
        self.photoView = nil
    end
end

function AvatarSelectGroup:buildPhotoView()
    if self.photoView then return end
    local size = Director:sharedDirector():getVisibleSize()
    local origin = Director:sharedDirector():getVisibleOrigin()
    local height = 76
    local bg = LayerColor:createWithColor(ccc3(0,0,0), size.width, size.height)
    bg.hitTestPoint = function ()
        return true
    end
    bg:setTouchEnabled(true, 0, true)
    bg:setOpacity(100)

    local colorBg = LayerColor:createWithColor(ccc3(255,207,128), size.width, 238)
    bg:addChild(colorBg)

    local function closeView()
        self:closePhotoView()
    end

    local photoBtn = buildPhotoBtn(localize("my.card.edit.panel.text2"), size.width, height, function ()
        closeView()
        self:takePhoto()
    end)

    local selectPictureBtn = buildPhotoBtn(localize("my.card.edit.panel.text3"), size.width, height, function ()
        closeView()
        self:selectPicture()
    end)

    local cancelBtn = buildPhotoBtn(localize("my.card.edit.panel.text4"), size.width, height, closeView)

    selectPictureBtn:setPositionY(height + 10)
    photoBtn:setPositionY(2 * height + 12)

    bg:addChild(cancelBtn)
    bg:addChild(selectPictureBtn)
    bg:addChild(photoBtn)

    self.photoView = bg
    local parent = self.moreAvatars:getParent()
    local pos = parent:convertToNodeSpace(origin)
    bg:setPosition(ccp(pos.x, pos.y))
    parent:addChild(bg)
end

function AvatarSelectGroup:takeImageSuccess( path )
    local fileId = UserManager:getInstance().profile.fileId
    local expired = Localhost:timeInSec() + 60

    local function onSuccess( evt )
        self:uploadImage(path, evt.data)
    end

    local function onFail( evt )
        
    end

    self:getSign(fileId, expired, onSuccess, onFail)
end

function AvatarSelectGroup:getSign(fileId, expired, onSuccess, onFail )
    local http = GetSignHttp.new()
    http:ad(Events.kComplete, onSuccess)
    http:ad(Events.kError, onFail)
    http:load(fileId, expired)
end

function AvatarSelectGroup:uploadImage( path, data )
    local function onSuccess(fileId, headUrl )
        print("uploadImage success >>> ",fileId, headUrl)
        if self.moreAvatarList[tostring(self.customAvatarIndex)] then
            self.moreAvatarList[tostring(self.customAvatarIndex)]:setVisible(true)
        end
        --data.pornDetectSignCI
        self:pornDetect(headUrl, fileId)
        self:delImage(data.signOnceCI)
        UserManager:getInstance().profile.fileId = fileId
        
        if not self.moreAvatars.isDisposed then
            self:changeAvatarImage(headUrl, true)
        else
            self.manager:setData(self.manager.HEAD_URL, tostring(headUrl))
            self.manager:uploadUserProfile()
            if self.needUpdateHead then
                if self.originalPlace == 0 then
                    if self.manager.panel then
                        self.manager.panel.avatarSelectGroup:changeAvatarImage(headUrl, true)
                    end
                elseif self.manager.panel and self.manager.panel.editPanel then
                    self.manager.panel.editPanel.avatarSelectGroup:changeAvatarImage(headUrl, true)
                end

                self.parent = nil
            end
        end

        DcUtil:UserTrack({category='my_card', sub_category="my_card_upload_photo"}, true)
    end

    local function onError( errCode, errMsg )
        print("uploadImage error >>> ", errCode, errMsg)
    end

    PhotoUpload:upload(path, data.signCI, onSuccess, onError)
end

function AvatarSelectGroup:pornDetect(headUrl, fileId )
    local function _pornDetect(evt)
        PhotoUpload:pornDetect(headUrl, evt.data.pornDetectSignCI, 
                                function ( msg )
                                    print("pornDetect success >>> ", msg)
                                end, 
                                function ( errCode, errMsg )
                                    print("pornDetect error >>> ", errCode, errMsg)
                                end
                                )
    end

    local selfPhotoCheckFeature = MaintenanceManager:getInstance():isEnabled("SelfPhotoCheckFeature")
    if selfPhotoCheckFeature then
        self:getSign(fileId, Localhost:timeInSec() + 60, _pornDetect,function (evt)--[[do nothing]]  end)
    end
end

function AvatarSelectGroup:delImage(sign )
    local function onSuccess( msg )
        print("delImage success >>> ", msg)
    end

    local function onError( errCode, errMsg )
        print("delImage error >>> ", errCode, errMsg)
    end

    local fileId = UserManager:getInstance().profile.fileId
    print("fileId >>> ", fileId)

    if fileId ~= nil and fileId ~= "" and type(fileId) == "string" and sign ~= nil then
        PhotoUpload:del(fileId, sign, onSuccess, onError)
    end
end

function AvatarSelectGroup:selectPicture()
    local cb = {
        onSuccess = function ( path )
            if path ~= nil then
                self:takeImageSuccess(path)
            end
            self.manager:setData(self.manager.IS_TAKE_PHOTO, false)
            self:onAvatarTouch()
        end,
        onError = function ( code, errMsg )
            print("selectPicture error ", code, errMsg)
            self.manager:setData(self.manager.IS_TAKE_PHOTO, false)
            CommonTip:showTip(localize("my.card.edit.panel.warning.photo"), nil, nil, 3)
        end,
        onCancel = function ()
            print("selectPicture cancel")
            self.manager:setData(self.manager.IS_TAKE_PHOTO, false)
        end,
    }

    local isTakePhoto = self.manager:getData(self.manager.IS_TAKE_PHOTO)
    if not isTakePhoto then
        self.manager:setData(self.manager.IS_TAKE_PHOTO, true)
        HeadPhotoTaker:selectPicture(cb)
    end
end

function AvatarSelectGroup:takePhoto()
    local cb = {
        onSuccess = function ( path )
            if path ~= nil then
                self:takeImageSuccess(path)
            end
            self.manager:setData(self.manager.IS_TAKE_PHOTO, false)
            if self.originalPlace == 0 then
                self.manager:showPersonalCenterPanel()
            elseif self.parent and self.parent.parentPanel and self.parent.parentPanel.onTapEditBtn then
                self.parent.parentPanel.onTapEditBtn()
            end
        end,
        onError = function ( code, errMsg )
            print("takePhoto error ", code, errMsg)
            self.manager:setData(self.manager.IS_TAKE_PHOTO, false)
            if self.originalPlace == 0 then
                self.manager:showPersonalCenterPanel()
            elseif self.parent and self.parent.parentPanel and self.parent.parentPanel.onTapEditBtn then
                self.parent.parentPanel.onTapEditBtn()
            end
            CommonTip:showTip(localize("my.card.edit.panel.warning.camera"), nil, nil, 3)
        end,
        onCancel = function ()
            print("takePhoto cancel")
            self.manager:setData(self.manager.IS_TAKE_PHOTO, false)
            if self.originalPlace == 0 then
                self.manager:showPersonalCenterPanel()
            elseif self.parent and self.parent.parentPanel and self.parent.parentPanel.onTapEditBtn then
                self.parent.parentPanel.onTapEditBtn()
            end
        end,
    }

    local isTakePhoto = self.manager:getData(self.manager.IS_TAKE_PHOTO)
    if not isTakePhoto then
        if self.parent then
            self.needUpdateHead = true
            self.parent:onCloseBtnTapped()
        end
        self.manager:setData(self.manager.IS_TAKE_PHOTO, true)
        HeadPhotoTaker:takePicture(cb)
    end
end

return AvatarSelectGroup