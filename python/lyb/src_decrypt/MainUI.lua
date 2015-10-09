require "main.view.mainScene.component.ui.UserInfoGroupUI";
MainUI = class(Layer);

-- local TASK_EFFECT_ID = "1349_1001";
--新手七天按钮有无判断：由后台定，后台有数据就出现

function MainUI:ctor()
	self.class = MainUI;
  self.shopButtonDO = nil

  self.huodongButtonDO = nil
  
  self.caidanButtonDO = nil


  self.liaotiandiDO = nil
  self.liaotiandiNumberDO = nil

  self.gantanhaoData = nil -- 感叹号数据

  self.FIX_BUTTON_GROUP_X = 10;
  self.FIX_BUTTON_GROUP_Y = 10;


end

function MainUI:dispose()

	self.movieClip1:dispose();
	self.movieClip1 = nil;
	self.movieClip2:dispose();
	self.movieClip2 = nil;
  self.movieClip3:dispose();
  self.movieClip3 = nil;

	self:removeAllEventListeners();
  	self:removeChildren();
	MainUI.superclass.dispose(self);
	mainUiSelf = nil
end

function MainUI:onInit()    
    
    self:initLayer();
    mainUiSelf = self

  local proxyRetriever  = ProxyRetriever.new();

  self.vipProxy=proxyRetriever:retrieveProxy(VipProxy.name);
  self.userCurrencyProxy=proxyRetriever:retrieveProxy(UserCurrencyProxy.name);
  self.generalListProxy=proxyRetriever:retrieveProxy(GeneralListProxy.name);
  self.userProxy = proxyRetriever:retrieveProxy(UserProxy.name);
  self.openFunctionProxy=proxyRetriever:retrieveProxy(OpenFunctionProxy.name);
  self.itemUseQueueProxy=proxyRetriever:retrieveProxy(ItemUseQueueProxy.name);
  -- self.buddyListProxy=proxyRetriever:retrieveProxy(BuddyListProxy.name);



	-- 根据设备宽高定位主界面4个角的位置
  	local winSize = Director:sharedDirector():getWinSize();
  
    local layerColor = LayerColor.new();
    layerColor:initLayer();
    layerColor:changeWidthAndHeight(winSize.width,54);
    layerColor:setColor(ccc3(0,0,0));
    layerColor:setOpacity(125);
     layerColor:setPositionXY(-GameData.uiOffsetX,66+winSize.height - 118 -GameData.uiOffsetY)
    self:addChild(layerColor)



    self.userInfoGroupUI = UserInfoGroupUI.new()
    self.userInfoGroupUI:initialize()
    self:addChild(self.userInfoGroupUI)
   -- self.userInfoGroupUI:setPositionXY(-GameData.uiOffsetX,winSize.height - 118 -GameData.uiOffsetY)

    local movieClip2 = MovieClip.new();
    movieClip2:initFromFile("main_ui", "mainui_2");
    movieClip2:gotoAndPlay("f1");
    movieClip2.layer:setPositionXY(GameData.uiOffsetX,  -GameData.uiOffsetY)    
    self:addChild(movieClip2.layer);
    movieClip2:update();
    self.movieClip2 = movieClip2;

    local movieClip3 = MovieClip.new();
    movieClip3:initFromFile("main_ui", "mainui_3");
    movieClip3:gotoAndPlay("f1");
    movieClip3.layer:setPositionXY(GameData.uiOffsetX,  -GameData.uiOffsetY)    
    self:addChild(movieClip3.layer);
    movieClip3:update();
    self.movieClip3 = movieClip3;

    local movieClip1 = MovieClip.new();
    movieClip1:initFromFile("main_ui", "mainui_1");
    movieClip1:gotoAndPlay("f1");
    movieClip1.layer:setPositionXY(GameData.uiOffsetX,GameData.uiOffsetY)        
    self:addChild(movieClip1.layer);
    movieClip1:update();
    self.movieClip1 = movieClip1;


    self.chongzhi = movieClip1.armature:getBone("chongzhi"):getDisplay()  
    self.chongzhiDO = Image.new()
    self.chongzhiDO.name = self.chongzhi.name
    self.chongzhiDO:loadByArtID(741);
    self.chongzhiDO:setAnchorPoint(ccp(0.5,0.5))
    self.chongzhiDO:setPositionXY(self.chongzhi.x - 8,self.chongzhi.y-35)
    movieClip1.layer:addChild(self.chongzhiDO)

    self.boneLightCartoon = BoneCartoon.new()
    self.boneLightCartoon:create(StaticArtsConfig.BONE_EFFECT_CHONGZHI_BUTTON,0);
    self.boneLightCartoon:setMyBlendFunc()
    movieClip1.layer:addChild(self.boneLightCartoon);

    self.boneLightCartoon:setPositionXY(self.chongzhi.x - 50, self.chongzhi.y-50)

   ------------------------------------------------------- 右上 --------------------------------------------
  -- self.rightTopBgDO = movieClip1.armature:getBone("background"):getDisplay()
  -- self.rightTopBgDO:setVisible(false);
   ------------------------------------------------------- 居中 --------------------------------------------

  -- 感叹号
  self.gantanhaoButtonDO = movieClip2.armature:getBone("gantanhaoButton"):getDisplay()  
  -- local size = self.gantanhaoButtonDO:getGroupBounds().size;
  -- local pos = ccp(size.width/2,-size.height/2);
  -- local sprite = cartoonPlayer("1931_1001",pos,0);
  -- local plistItem = plistData["key_1931_1001"];
  --   GameData.deleteAllMainSceneTextureMap[plistItem.source] = plistItem.source;
  -- sprite.touchChildren = false;
  -- sprite.touchEnabled = false;
  -- self.gantanhaoButtonDO:addChild(sprite);

  self.gantanhaoButtonDO:setVisible(false)


  self.buddy_commend_button=movieClip2.armature:getBone("buddy_commend_button"):getDisplay();
  --self.buddy_commend_button:addEventListener(DisplayEvents.kTouchBegin,self.onBuddyCommendBegin,self);
  self.buddy_commend_button:setVisible(false);

  self.buddy_request_button=movieClip2.armature:getBone("buddy_request_button"):getDisplay();
  self.buddy_request_button:addEventListener(DisplayEvents.kTouchBegin,self.onBuddyRequestBegin,self);
  self.buddy_request_button:setVisible(false);


  --功能+号
  local gongneng = movieClip3.armature:getBone("gongneng"):getDisplay()  
  self.gongnengDO = Image.new()
  self.gongnengDO.name = gongneng.name
  self.gongnengDO:loadByArtID(904);
  self.gongnengDO:setAnchorPoint(ccp(0.5,0.5))
  self.gongnengDO:setPositionXY(gongneng.x +5,gongneng.y-3)
  movieClip3.layer:addChild(self.gongnengDO)

  self.gongnengDO:runAction(CCRotateBy:create(0 , 45));
  

  
  self.common_return_button=CommonSkeleton:getBoneTextureDisplay("commonButtons/common_return_button_normal")
  self.common_return_button.name = "common_return_button"
  self:addChild(self.common_return_button)
  self.common_return_button:setAnchorPoint(ccp(0.5,0.5))

  self.common_return_button:setPositionXY(-GameData.uiOffsetX+winSize.width-65, winSize.height - 39 -GameData.uiOffsetY)
  -- 聊天
  self.liaotiandiDO = movieClip2.armature:getBone("liaotiandi"):getDisplay()
  -- self.liaotiandiNumberDO = movieClip2.armature:getBone("liaotiandinumber"):getDisplay()
  -- self.liaotiandiNumberDO:setVisible(false)
  -- self.effectChatNumber=EffectChatNumber.new();
  -- self.effectChatNumber:initialize();
  -- self.liaotiandiNumberDO:addChild(self.effectChatNumber)


end
function MainUI:setVisibleByBool(bool)

    self.movieClip1.layer:setVisible(bool)
    self.movieClip3.layer:setVisible(bool)
    self.userInfoGroupUI:setVisible(bool)
    self.common_return_button:setVisible(not bool);
  
end
-- 感叹号
function MainUI:setGantanhao(dataTable)


end
-------------------------------------------------effect----------------------------------------------------

function MainUI:refreshChatPrivateAndBuddyEffect()
  if not self.chat_private_and_buddy_effect then
  	self.chat_private_and_buddy_effect=cartoonPlayer(EffectConstConfig.CHAT_BUTTON,28,38,0);
  	self.chat_private_and_buddy_effect.touchChildren=false;
    self.chat_private_and_buddy_effect.touchEnabled=false;
    self.movieClip4.layer:addChild(self.chat_private_and_buddy_effect);
  end
  self.chat_private_and_buddy_effect:setVisible(0~=self.effectChatNumber:getNum());
end

function MainUI:setImageScale(image,buttonDO, funImage)
  image:setAnchorPoint(ccp(0.5,0.5))
  local size = image:getContentSize()
  image:setPositionXY(size.width/2,size.height/2 - 100)
  buttonDO.imageButton = image
end


function MainUI:onBuddyRequestBegin(event)
	require "main.view.buddy.ui.buddyPopup.InviteByGantanhaoLayer";
	self.inviteByGantanhaoLayer=InviteByGantanhaoLayer.new();
	self.inviteByGantanhaoLayer:initialize(self);
	sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(self.inviteByGantanhaoLayer);
	self.buddy_request_button:setVisible(false);
end

function MainUI:refreshGantanhao4BuddyFeedExp()
  if self.chatListProxy.hasNewGantanhao then
  	recvTable["ID"]=42;
  	recvTable["ParamStr1"]="";
  	recvTable["ParamStr2"]="";
  	recvTable["ParamStr3"]="";
  	recvTable["Content"]="";
  	recvMessage(1011,6);
  	self.chatListProxy.hasNewGantanhao=false;
  end
end

function MainUI:hideInviteByGantanhaoLayer()
	if self.inviteByGantanhaoLayer and self.inviteByGantanhaoLayer.parent then
        self.inviteByGantanhaoLayer.parent:removeChild(self.inviteByGantanhaoLayer)
        self.inviteByGantanhaoLayer = nil;
	end
	self.inviteByGantanhaoLayer = nil;
end

function MainUI:refreshTurnTable(boo)
  self.effect_containers[FunctionConfig.FUNCTION_ID_123]:setVisible(boo)   
end
