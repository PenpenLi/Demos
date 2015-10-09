require "core.controls.Button";
require "core.events.DisplayEvent";
require "core.controls.CommonPopup";
require "core.controls.RichLabelTTF";
require "core.controls.FlexibleListScrollViewLayer";
require "core.controls.RichTextLineInput";
require "core.display.LayerPopable";
require "main.config.ConstItemIDConfig";
require "main.view.chat.ui.chatPopup.ButtonsSelector";

require "main.view.buddy.ui.HaoyouLayer";
require "main.view.buddy.ui.HaoyouXianhuaLayer";
require "main.view.buddy.ui.HaoyouChazhaoLayer";
require "main.view.buddy.ui.HaoyouShenqingLayer";

require "main.view.buddy.ui.HaoyouSonghuaLayer";

HaoyouPopup=class(LayerPopableDirect);

function HaoyouPopup:ctor()
  self.class=HaoyouPopup;
end

function HaoyouPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	HaoyouPopup.superclass.dispose(self);
  --CCTextureCache:sharedTextureCache():dumpCachedTextureInfo();
  BitmapCacher:removeUnused();
end

function HaoyouPopup:onDataInit()
  self.chatListProxy = self:retrieveProxy(ChatListProxy.name);
  self.buddyListProxy = self:retrieveProxy(BuddyListProxy.name);
  self.bagProxy = self:retrieveProxy(BagProxy.name);
  self.equipmentInfoProxy = self:retrieveProxy(EquipmentInfoProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.generalListProxy = self:retrieveProxy(GeneralListProxy.name);
  self.operationProxy = self:retrieveProxy(OperationProxy.name);
  self.countControlProxy = self:retrieveProxy(CountControlProxy.name);
  self.skeleton = self.buddyListProxy:getSkeleton();

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(false);
  layerPopableData:setHasUIFrame(false);
  -- layerPopableData:setShowCurrency(true);
  layerPopableData:setArmatureInitParam(self.skeleton,"buddy_ui");
  self:setLayerPopableData(layerPopableData);

  self.refreshTime=0;
  self.channel_buttons = {};
  self.panels = {};
end

function HaoyouPopup:onPrePop()
  -- local bg = LayerColorBackGround:getTransBackGround();
  -- bg:setPositionXY(-GameData.uiOffsetX,-GameData.uiOffsetY);
  -- self:addChildAt(bg,0);
  local artId1=getCurrentBgArtId()

  self.bgImage = Image.new();
  self.bgImage:loadByArtID(artId1);

  local yPos = -GameData.uiOffsetY
  local winSize = Director:sharedDirector():getWinSize();
  if GameVar.mapHeight - winSize.height > 30 then
    yPos = -GameData.uiOffsetY - 30
  end
  self.bgImage:setPositionXY(-GameData.uiOffsetX, yPos);
  
  self:addChildAt(self.bgImage,0);
end

function HaoyouPopup:onUIInit()
  local a=1;
  local s={"友\n好","花\n鲜","找\n查","请\n申"};
  while 5>a do
    local chat_channel_button=self.armature.display:getChildByName("tabBtn" .. a);
    local chat_channel_button_pos=convertBone2LB4Button(chat_channel_button);
    local chat_channel_button_text_data=self.armature:findChildArmature("tabBtn"  .. a):getBone("common_channel_button").textData;
    self.armature.display:removeChild(chat_channel_button);

    chat_channel_button=CommonButton.new();
    chat_channel_button:initialize("commonButtons/common_channel_button_normal","commonButtons/common_channel_button_down",CommonButtonTouchable.CUSTOM);
    -- chat_channel_button:initializeText(chat_channel_button_text_data,s[a]);
    chat_channel_button:initializeBMText(s[a],"anniutuzi",_,_,makePoint(25,50));
    chat_channel_button:setPosition(chat_channel_button_pos);
    chat_channel_button:addEventListener(DisplayEvents.kTouchTap,self.onChannelButtonTap,self,a);
    self.armature.display:addChild(chat_channel_button);
    table.insert(self.channel_buttons,chat_channel_button);
    a=1+a;
  end

  self.channel_buttons[2]:setVisible(false);
  self.channel_buttons[3]:setPositionY(130+self.channel_buttons[3]:getPositionY());
  self.channel_buttons[4]:setPositionY(130+self.channel_buttons[4]:getPositionY());
  local effect = self.armature.display:getChildByName("effect");
  effect:setPositionY(130+effect:getPositionY());

  self:onChannelButtonTap(nil, 1);
  self:refreshReddot();

  self.askBtn = self.armature.display:getChildByName("ask");
  SingleButton:create(self.askBtn);
  self.askBtn:addEventListener(DisplayEvents.kTouchTap,self.onShowTip, self);
end

function HaoyouPopup:onShowTip()
  -- MusicUtils:playEffect(7,false);
  local text=analysis("Tishi_Guizemiaoshu",21,"txt");
  TipsUtil:showTips(self.askBtn,text,500,nil,50);
end

function HaoyouPopup:onRequestedData()
  
end

function HaoyouPopup:onUIClose()
  self:dispatchEvent(Event.new(ChatNotifications.BUDDY_CLOSE,data,self));
  --self:setVisible(false);
end

function HaoyouPopup:onPreUIClose()
  -- self.buddyLayer:onChannelButtonTap(nil,0);
end

function HaoyouPopup:refreshBuddyData()
  uninitializeSmallLoading();
  self.panels[1]:initializeBuddyData();
end

function HaoyouPopup:onChannelButtonTap(event, num)
  if event then
    MusicUtils:playEffect(7,false);
  end
  for k,v in pairs(self.channel_buttons) do
    if num == k then
      v:select(true);
      v.parent:removeChild(v,false);
      self.armature.display:addChild(v);
    else
      v:select(false);
    end
  end
  if not self.panels[num] then
    local layer;
    if 1 == num then
      layer = HaoyouLayer.new();
      layer:initialize(self);
    elseif 2 == num then
      layer = HaoyouXianhuaLayer.new();
      layer:initialize(self);
    elseif 3 == num then
      layer = HaoyouChazhaoLayer.new();
      layer:initialize(self);
    elseif 4 == num then
      layer = HaoyouShenqingLayer.new();
      layer:initialize(self);
    end
    self.panels[num] = layer;
  end
  if self.select_panel then
    self.select_panel:setVisible(false);
    self.select_panel = nil;
  end
  self.select_panel = self.panels[num];
  self.select_panel:setVisible(true);
  self.armature.display:addChildAt(self.select_panel,3);
  if 4 == num then
    self.select_panel:initializeShenqingData();
    require "main.controller.command.mainScene.ToRefreshReddotCommand"
    ToRefreshReddotCommand.new():execute({data={type=FunctionConfig.FUNCTION_ID_10,value=0}});
  end
end

function HaoyouPopup:refreshByCurrency()
  if self.haoyouSonghuaLayer then
    self.haoyouSonghuaLayer:refreshByCurrency();
  end
end

function HaoyouPopup:refreshByCountControl()
  if self.haoyouSonghuaLayer then
    self.haoyouSonghuaLayer:refreshByCountControl();
  end
end

function HaoyouPopup:refreshShenqingData(data)
  if self.panels[4] then
    self.panels[4]:refreshShenqingData(data);
  end
end

function HaoyouPopup:refreshAddBuddys(userRelationArray)
  if self.panels[1] then
    self.panels[1]:refreshAddBuddys(userRelationArray);
  end
  if self.panels[4] then
    self.panels[4]:refreshAddBuddys(userRelationArray);
  end
end

function HaoyouPopup:deleteBuddy(userID)
  if self.panels[1] then
    self.panels[1]:deleteBuddy(userID);
  end
end

function HaoyouPopup:refreshReddot()
  if self.select_panel == self.panels[4] then
    GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_10] = false;
  end
  local effect = self.armature.display:getChildByName("effect");
  effect:setVisible(GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_10]);
  effect.parent:removeChild(effect,false);
  self.armature.display:addChild(effect);
end

function HaoyouPopup:refreshSongtiliBTN()
  log("000");
  if self.haoyouLayerItemSlotSongtili and not self.haoyouLayerItemSlotSongtili.isDisposed then
    self.haoyouLayerItemSlotSongtili:refreshSongtiliBTN();
  end
end