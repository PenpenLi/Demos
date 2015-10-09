require "core.mvc.ext.ProxyRetriever";
require "main.view.rankList.ui.RankListSlot";

PlayerInfoPopup=class(Layer);

PlayerInfoPopup.inited = nil;
function PlayerInfoPopup:clean()
  local bool = false;
  if PlayerInfoPopup.inited and not PlayerInfoPopup.inited.isDisposed then
    PlayerInfoPopup.inited.parent:removeChild(PlayerInfoPopup.inited);
    bool = true;
  end
  PlayerInfoPopup.inited = nil;
  return bool;
end

function PlayerInfoPopup:ctor()
  self.class=PlayerInfoPopup;
  PlayerInfoPopup:clean();
  PlayerInfoPopup.inited = self;
end

function PlayerInfoPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  PlayerInfoPopup.superclass.dispose(self);
end

function PlayerInfoPopup:initialize(data)
  self.data = data;
  self:initLayer();
  
  local retriever = ProxyRetriever.new();
  self.buddyListProxy = retriever:retrieveProxy(BuddyListProxy.name);
  self.bagProxy = retriever:retrieveProxy(BagProxy.name);
  self.rankListProxy = retriever:retrieveProxy(RankListProxy.name);
  self.skeleton = self.buddyListProxy:getSkeleton();

  local bg=LayerColorBackGround:getOpacityBackGround();
  bg:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
  bg:setPositionXY(-GameData.uiOffsetX,-GameData.uiOffsetY);
  self:addChild(bg);

  --骨骼
  local armature=self.skeleton:buildArmature("look_player_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  self.armature:getChildByName("title_descb"):setScale(0.85);

  local img = Image.new();
  img:loadByArtID(304);
  img:setPositionXY(10,0);
  self.armature:addChildAt(img,2);

  local text="<content><font color='#FFFFFF'>" .. self.data.UserName .. "</font><font color='#FFCC01'> Lv." .. self.data.Level .. "</font></content>";
  self.title_descb=createMultiColoredLabelWithTextData(armature:getBone("title_descb").textData,text);
  self.armature:addChild(self.title_descb);

  text=self.data.Zhanli;
  self.zhanli_img=createTextFieldWithTextData(armature:getBone("zhanli_img").textData,text);
  self.armature:addChild(self.zhanli_img);

  text=self.data.Flower;
  self.xianhua_img=createTextFieldWithTextData(armature:getBone("xianhua_img").textData,text);
  self.armature:addChild(self.xianhua_img);

  local a=1;
  local s={self.buddyListProxy:getIsHaoyou(self.data.UserId) and "删除好友" or "加为好友","查看英雄"};
  while 3>a do
    local chat_channel_button=self.armature:getChildByName("btn_" .. a);
    local chat_channel_button_pos=convertBone2LB4Button(chat_channel_button);
    local chat_channel_button_text_data=self.armature4dispose:findChildArmature("btn_"  .. a):getBone("common_small_blue_button").textData;
    self.armature:removeChild(chat_channel_button);

    chat_channel_button=CommonButton.new();
    chat_channel_button:initialize("commonButtons/common_small_blue_button_normal",_,CommonButtonTouchable.BUTTON);
    chat_channel_button:initializeText(chat_channel_button_text_data,s[a]);
    -- chat_channel_button:initializeBMText(s[a],"anniutuzi",_,_,makePoint(25,50));
    chat_channel_button:setPosition(chat_channel_button_pos);
    chat_channel_button:addEventListener(DisplayEvents.kTouchTap,self.onChannelButtonTap,self,a);
    self.armature:addChild(chat_channel_button);
    a=1+a;
  end

  local size=CCDirector:sharedDirector():getWinSize();
  local popupSize=self.armature:getChildByName("common_background_1"):getContentSize();
  -- self.armature:setPositionXY((size.width-popupSize.width)/2,(size.height-popupSize.height)/2);
  self.armature:setPositionXY(math.floor((GameConfig.STAGE_WIDTH-popupSize.width)/2),math.floor((GameConfig.STAGE_HEIGHT-popupSize.height)/2));
  sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(self);

  local configID = self.data.TransforId;
  local figure=CompositeActionAllPart.new();
  figure:initLayer();
  figure:transformPartCompose(self.bagProxy:getCompositeRoleTable4Player(analysis("Zhujiao_Huanhua",configID,"body")));
  -- local pos = self.armature.display:getChildByName("slot_l_" .. self.generalIDs[i].Place):getPosition();
  figure:setPositionXY(188,205);
  self.armature:addChild(figure);
  -- figure:setScale(0.8);

  local closeButton =self.armature:getChildByName("close_btn");
  closeButton:setVisible(false);
  SingleButton:create(closeButton);
  closeButton:addEventListener(DisplayEvents.kTouchTap, self.onSelfTap, self);
end

function PlayerInfoPopup:onSelfTap(event)
  self.parent:removeChild(self);
end

function PlayerInfoPopup:onChannelButtonTap(event, i)
  if 1 == i then
    if self.buddyListProxy:getIsHaoyou(self.data.UserId) then
      local function cb()
        initializeSmallLoading();
        sendMessage(21,3,{UserId=self.data.UserId});
        self:onSelfTap();
      end
      local tips=CommonPopup.new();
      tips:initialize("确定删除好友吗?",nil,cb,_,_,_,_,_,_,true);
      -- self:addChild(tips);
      commonAddToScene(tips, true);
    else
      if not getBuddyValid(self.data.UserId) then
        return;
      end
      sendMessage(21,4,{UserId=self.data.UserId,UserName=""});
      -- sharedTextAnimateReward():animateStartByString("加为好友请求已发出 ~");
    end
  elseif 2 == i then
    initializeSmallLoading();
    sendMessage(3,13,{UserId = self.data.UserId,UserName=""});
  end
end

function PlayerInfoPopup:addBuddy()
    local function onConfirm()
    if self.buddyListProxy:getBuddyNumFull() then
      sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_63));
      return;
    end
    if self.buddyListProxy:getBuddyData(self.buddyListProxy.lookIntoData.UserName) then
      sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_62));
      return;
    end
    if ConstConfig.USER_NAME==self.buddyListProxy.lookIntoData.UserName then
      sharedTextAnimateReward():animateStartByString("知道你会加自己的,O(∩_∩)O哈哈~!");
      return;
    end
    sendMessage(21,4,self.buddyListProxy.lookIntoData);
    self:onSelfTap();
  end
  local popup=CommonPopup.new();
  local text='<content><font color="#FFFFFF">确定加</font><font color="#00FF00">' .. self.buddyListProxy.lookIntoData.UserName .. '</font><font color="#FFFFFF">好友吗</font><font color="#FFFFFF">?</font></content>';
  popup:initialize(text,nil,onConfirm,nil,nil,nil,nil,nil,true);
  self:addChild(popup);
end

function PlayerInfoPopup:deleteBuddy()
  local function onConfirm()
    sendMessage(21,3,self.buddyListProxy.lookIntoData);
    self:onSelfTap();
  end
  local popup=CommonPopup.new();
  local text='<content><font color="#FFFFFF">你真的要删除好友</font><font color="#00FF00">' .. self.buddyListProxy.lookIntoData.UserName .. '</font><font color="#FFFFFF">吗</font><font color="#FFFFFF">?</font><font color="#FFFFFF">删除以后就会从好友列表消失哦!</font></content>';
  popup:initialize(text,nil,onConfirm,nil,nil,nil,nil,nil,true);
  self:addChild(popup);
end