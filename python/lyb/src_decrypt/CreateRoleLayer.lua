require "core.controls.TextInput"

CreateRoleLayer=class(Layer);
--是否能点击职业
-- local _canClick = true

function CreateRoleLayer:ctor()
  self.class=CreateRoleLayer;
  self.skeleton = nil;
  self.roleArray = {}
  self.buttonPositionArr = {}
end

function CreateRoleLayer:dispose()
      self:removeAllEventListeners();
      self:removeChildren();
	  CreateRoleLayer.superclass.dispose(self);
      self.armature:dispose()
end

function CreateRoleLayer:initialize(skeleton)

    require "core.utils.ParticleSystem"

    self:initLayer();
    
    -- self.particleLayer = sharedPreloadLayerManager():getLayer(GameConfig.PRELOAD_PARTICLE_SYSTEM_UI)
    -- ParticleSystem:particleRunForEver(self.particleLayer,"leaf7");

    self:setContentSize(CCSizeMake(GameConfig.STAGE_WIDTH,GameConfig.STAGE_HEIGHT))
    AddUIBackGround(self,StaticArtsConfig.BACKGROUD_CREAT_ROLE,nil,true)

    self.skeleton = skeleton;

    local armature=skeleton:buildArmature("createrole_ui");
    armature.animation:gotoAndPlay("f1");
    armature:updateBonesZ();
    armature:update();
    self.armature = armature;
    
    local armature_d=armature.display;
   --
    local wushuangImageBone = armature_d:getChildByName("wushuangImage");
    local jueliImageBone = armature_d:getChildByName("jueliImage");
    local rollerBone = armature_d:getChildByName("roller");
    local banshenxiangImageBone = armature_d:getChildByName("banshenxiangImage");

    self.bantouImage1 = armature_d:getChildByName("bantouImage1");
    self.bantouImage2 = armature_d:getChildByName("bantouImage2");

    self.bantouImage1.touchEnabled = false
    self.bantouImage2.touchEnabled = false

    jueliImageBone:addEventListener(DisplayEvents.kTouchTap,self.onClickJueliImage,self);
    wushuangImageBone:addEventListener(DisplayEvents.kTouchTap,self.onClickWushuangImage,self);
    -- self.poemImageBone = armature_d:getChildByName("poemImage");
    
    self.jueliImage = Image.new()
    self.jueliImage:loadByArtID(891)
    self.jueliImage:setPositionXY(banshenxiangImageBone:getPositionX(),banshenxiangImageBone:getPositionY())
    -- self.jueliImage.touchEnabled = false
    self.jueliImage:setOpacity(0)
    self:addChild(self.jueliImage)

    self.wushuangImage = Image.new()
    self.wushuangImage:loadByArtID(890)
    self.wushuangImage:setPositionXY(banshenxiangImageBone:getPositionX(),banshenxiangImageBone:getPositionY())
    -- self.wushuangImage.touchEnabled = false
    self.wushuangImage:setOpacity(0)
    self:addChild(self.wushuangImage)


    -- 特效们
    -- 无双身上的
    self.wushuangEffect = cartoonPlayer(StaticArtsConfig.FRAME_EFFECT_5,637,358,0,nil,2,nil,true)
    -- 绝离身上的
    self.jueliEffect = cartoonPlayer(StaticArtsConfig.FRAME_EFFECT_1,650,340,0,nil,2,nil,true)
    -- 光边左右
    self.guangbianEffect_1 = cartoonPlayer(StaticArtsConfig.FRAME_EFFECT_2,884,480,0,nil,2,nil,true)
    -- 光边中
    self.guangbianEffect_2 = cartoonPlayer(StaticArtsConfig.FRAME_EFFECT_2,1030,480,0,nil,2,nil,true)
    -- 光柱1
    self.guangzhuEffect_1 = cartoonPlayer(StaticArtsConfig.FRAME_EFFECT_4,980,430,0,nil,1,nil,true)

    self.wushuangImage:addChild(self.wushuangEffect)
    self.jueliImage:addChild(self.jueliEffect)

    self:addChild(armature_d);
    self.armature_d = armature_d;


    local beginGameButton = armature_d:getChildByName("common_big_blue_button");
    local beginGameButtonP = convertBone2LB4Button(beginGameButton);
    armature_d:removeChild(beginGameButton);

    local interButton = CommonButton.new();
    interButton:initialize("commonButtons/common_big_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
    interButton:setPosition(beginGameButtonP);
    self:addChild(interButton);
    self.interButton=interButton;
    self.interButton:addEventListener(DisplayEvents.kTouchTap,self.interButtonHandler,self);
    self.interButton:addEventListener(DisplayEvents.kTouchBegin,self.onLogButtonBegin,self);

    local goonGamePic = armature_d:getChildByName("goonGameImage");
    goonGamePic:setAnchorPoint(CCPointMake(0.5, 0.5));
    local contentSize = goonGamePic:getContentSize()    
    goonGamePic:setPositionXY(goonGamePic:getPositionX() + contentSize.width / 2, goonGamePic:getPositionY() - contentSize.height / 2);
    goonGamePic.touchEnabled = false;
    goonGamePic.touchChildren = false;
    self:addChild(goonGamePic);
    self.goonGamePic1 = goonGamePic
    armature_d:removeChild(goonGamePic);

    local input_1Data = armature:getBone("input_name").textData;
    self.inputNameText = TextInput.new("请输入名字",input_1Data.size,makeSize(input_1Data.width,input_1Data.height));
    self.inputNameText:setPositionXY(input_1Data.x - GameData.uiOffsetY / 5,input_1Data.y);
    self.inputNameText:setColor(ccc3(255,255,255))
    self:addChild(self.inputNameText);

    -- 骰子
    rollerBone:addEventListener(DisplayEvents.kTouchTap,self.onClickRoller,self);

    -- 诗
    self.poemLayer = Layer.new()
    self.poemLayer:initLayer()
    self:addChild(self.poemLayer)

    local chooseTips = armature:getBone("tipsText")
    local tipstext = createStrokeTextFieldWithTextData(chooseTips.textData,"选择你喜爱的形象吧(不分职业)",nil,1,ccc3(0,0,0));--createTextFieldWithTextData(chooseTips.textData,"选择你喜爱的形象吧(不分职业)")
    tipstext.touchEnabled = false
    self:addChild(tipstext)

    local randoValue = getRadomValue(1)
    if randoValue >= 0.5 then
        self:onClickJueliImage(true,true)
    else
        self:onClickWushuangImage(true,true)
    end

    self:addChild(self.guangbianEffect_1)
    self:addChild(self.guangbianEffect_2)
    self:addChild(self.guangzhuEffect_1)

    local mozhiUp = Image.new()
    mozhiUp:loadByArtID(898)
    mozhiUp:setPositionXY(0,GameData.uiOffsetY + GameConfig.STAGE_HEIGHT - mozhiUp:getContentSize().height)
    self:addChild(mozhiUp)

    local mozhiDown = Image.new()
    mozhiDown:loadByArtID(899)
    mozhiDown:setPositionXY(0,0)
    self:addChild(mozhiDown)    
end

function CreateRoleLayer:interButtonHandler()
    if self.particleLayer then
      ParticleSystem:removeParticleByUI(self.particleLayer)
      self.particleLayer = nil
    end    
    local name = self.inputNameText:getString()
    
    local nameLength = CommonUtils:calcCharCount(name);
    if nameLength == 0 then
        sharedTextAnimateReward():animateStartByString("请取个名字~");
    elseif nameLength > 6 then
        sharedTextAnimateReward():animateStartByString("名字不能超过6个字~");
    else
        GameData.userName = name
        sendMessage(2,2,{Career = self.selectedCareer,UserName = name})

        if GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_APPLE then
            recordAchievement()
        end
    end
end

function CreateRoleLayer:refreshUserName(userName)
    self.inputNameText:setString("")
    self.inputNameText:setString(userName)
end
function CreateRoleLayer:onLogButtonBegin(event)
  self.interButton:addEventListener(DisplayEvents.kTouchEnd,self.onLogButtonEnd,self);  
  self.goonGamePic1:setScale(0.9)
end

function CreateRoleLayer:onLogButtonEnd(event)
  self.goonGamePic1:setScale(1)
end
function CreateRoleLayer:onClickJueliImage(value,flag)

    if self.selectedCareer == 9000 then
        return
    end

    if flag then

    else
        MusicUtils:playEffect(506,false);
    end

    self.bantouImage1:setVisible(true)
    self.bantouImage2:setVisible(false)

    self.selectedCareer = 9000
    -- self:onClickRoller()
    
    self.wushuangEffect:setVisible(false)
    self.jueliEffect:setVisible(true)

    self.jueliImage:runAction(CCFadeIn:create(0.5,1))
    self.wushuangImage:runAction(CCFadeOut:create(0.5,0.8))    

    self.guangbianEffect_1:setPositionXY(1186,480)
    local guangzhuEffect_2
    local function effectCallBack()
        self.guangzhuEffect_1:setPositionXY(1110,430)
        self:removeChild(guangzhuEffect_2)
    end
    guangzhuEffect_2 = cartoonPlayer(StaticArtsConfig.FRAME_EFFECT_3,1110,360,1,effectCallBack,2,nil,true)
    self:addChild(guangzhuEffect_2)
end

function CreateRoleLayer:onClickWushuangImage(value,flag)

    if self.selectedCareer == 8000 then
        return
    end

    if flag then

    else
        MusicUtils:playEffect(506,false);
    end
    
    self.bantouImage1:setVisible(false)
    self.bantouImage2:setVisible(true)
    self.selectedCareer = 8000
    -- self:onClickRoller()

    self.wushuangEffect:setVisible(true)
    self.jueliEffect:setVisible(false)

    self.jueliImage:runAction(CCFadeOut:create(0.5,0.8))
    self.wushuangImage:runAction(CCFadeIn:create(0.5,1))

    self.guangbianEffect_1:setPositionXY(884,480)
    local guangzhuEffect_2
    local function effectCallBack()
        self.guangzhuEffect_1:setPositionXY(980,430)
        self:removeChild(guangzhuEffect_2)
    end
    guangzhuEffect_2 = cartoonPlayer(StaticArtsConfig.FRAME_EFFECT_3,960,360,1,effectCallBack,2,nil,true)
    self:addChild(guangzhuEffect_2)
end

function CreateRoleLayer:onClickRoller()
    MusicUtils:playEffect(7,false);
    sendMessage(2,8,{Career = self.selectedCareer})
end

-- -- type 1 无双  2 绝离
-- function CreateRoleLayer:displayPoem(type)

--     self.poemLayer:removeChildren(true)

--     local displayStr
--     if type == 1 then
--         displayStr = "纵横春秋纵是祸&且听风云且书过&是且是，错且错&汝书嗤笑我修罗&对即对，过即过&我刀枭煞汝佛陀"
--     else
--         displayStr = "把酒篱后恋香袖&帘卷西风醉清秋&环佩叮当身后酒&却不回头         &一盏离恨惹闲愁"
--     end
--     local textArr = {}
--     local peomArr = StringUtils:lua_string_split(displayStr,"&")
--     local i = 1

--     for k,v in pairs(peomArr) do
--         local str = ""
--         local _count = -1;
--         while (-1-string.len(v)) < _count do
--             str = str .. string.sub(v, -2 + _count, _count) .. "\n";
--             _count = -3 + _count;
--         end        
--         local text = BitmapTextField.new(str, "zhujuejieshao");
--         text:setPositionXY(self.poemImageBone:getPositionX() - (i - 1) * 80,self.poemImageBone:getPositionY()-280)
--         text:setAlpha(0)
--         textArr[i] = text
--         i = i + 1
--     end
--     local j = 1
--     local arrLenghth = table.getn(textArr)
--     local function _afterActionFunc()
--         if arrLenghth == j then
--             return
--         end

--         j = j + 1

--         self.poemLayer:addChild(textArr[j])
--         local array1 = CCArray:create();
--         array1:addObject(CCFadeIn:create(0.5))
--         array1:addObject(CCCallFunc:create(_afterActionFunc))
--         textArr[j]:runAction(CCSequence:create(array1))
--     end

--     self.poemLayer:addChild(textArr[j])
--     local array1 = CCArray:create();
--     array1:addObject(CCFadeIn:create(0.5))
--     array1:addObject(CCCallFunc:create(_afterActionFunc))
--     textArr[j]:runAction(CCSequence:create(array1))

-- end