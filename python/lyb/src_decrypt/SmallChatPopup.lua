--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

require "core.utils.LayerColorBackGround";
require "core.utils.Scheduler";
require "main.config.FunctionConfig";

SmallChatPopup=class(TouchLayer);

function SmallChatPopup:ctor()
  self.class=SmallChatPopup;
end

function SmallChatPopup:dispose()
  if self.sprite then self:stopAllActions(); end
  self:removeAllEventListeners();
  self:removeChildren();
	SmallChatPopup.superclass.dispose(self);
  --self.removeArmature:dispose()
  BitmapCacher:removeUnused();
end

function SmallChatPopup:initialize()
  self:initLayer();
end

--
function SmallChatPopup:initializeUI(skeleton, smallChatProxy, openFunctionProxy)
  self.skeleton=skeleton;
  self.smallChatProxy=smallChatProxy;
  self.openFunctionProxy=openFunctionProxy;
  
  -- --骨骼
  -- local armature=skeleton:buildArmature("small_chat_ui");
  -- armature.animation:gotoAndPlay("f1");
  -- armature:updateBonesZ();
  -- armature:update();
  -- self.removeArmature = armature;
  -- self.armature=armature.display;
  -- self:addChild(self.armature);

  -- --common_copy_button_bg_1
  -- local text_data=armature:getBone("common_copy_button_bg_1").textData;
  -- local text="";
  -- local chat_content_descb=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  -- self.armature:addChild(chat_content_descb);
  -- self.chat_content_descb=chat_content_descb;
  -- self.chat_content_text_data=text_data;

  local layer=Layer.new();
  layer:initLayer();
  layer:setContentSize(makeSize(410,80));
  self:addChild(layer);

  self.chat_content_descb=createRichMultiColoredLabelWithTextData({x=35,y=23, width=350, height=55,lineType="single line",size=22,color=16777215,alignment=kCCTextAlignmentLeft,space=0,textType="static"},"");
  self:addChild(self.chat_content_descb);

  self:refresh();
  self:setPositionXY(70,12-GameData.uiOffsetY-10);
  self:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
end

function SmallChatPopup:onSelfTap(event)
  if self.effect then
    self.effect:setVisible(false);
  end
  self:dispatchEvent(Event.new(MainSceneNotifications.REFRESH_CHAT_ICON_EFFECT,nil,self));
  self:dispatchEvent(Event.new(MainSceneNotifications.TO_CHAT,nil,self));
end

function SmallChatPopup:refresh(hasChat)
  local data=self.smallChatProxy:getData();
  local text;
  if data then
    text='<content>' .. '<font color="' .. getHexColorByMainTypeAndSubType(data.MainType,data.SubType,self:getIsUser(data)) .. '">' .. self:getChannelName(data.MainType,data.SubType,data.UserName,data.TargetUserName) .. '</font>';
    text=text .. StringUtils:setContentData(data.ChatContentArray) .. '</content>';
  else
    text='<content><font color="#FFFFFF">[广播]: 欢迎来到琅琊榜,大家一起来愉快的玩耍吧!</font></content>';
  end
  self.chat_content_descb:setString(text);
  --local b=self.chat_content_descb:getContentSize().height>self.chat_content_text_data.height and self.chat_content_text_data.height or self.chat_content_descb:getContentSize().height;
  --self.chat_content_descb:setPositionY(-9+self.chat_content_text_data.y+self.chat_content_text_data.height-b);
  -- if data and ConstConfig.USER_NAME~=data.UserName and (ConstConfig.MAIN_TYPE_CHAT==data.MainType and ConstConfig.SUB_TYPE_PRIVATE==data.SubType or ConstConfig.MAIN_TYPE_BUDDY==data.MainType) and not hasChat then
  --   if not self.effect then
  --     self.effect=cartoonPlayer(EffectConstConfig.SMALL_CHAT,makePoint(172,36),0);
  --     self.effect.touchChildren=false;
  --     self.effect.touchEnabled=false;
  --     self:addChild(self.effect);
  --   end
  --   self.effect:setVisible(true);
  -- end
end

function SmallChatPopup:getChannelName(mainType, subType, userName, targetUserName)
  if mainType==ConstConfig.MAIN_TYPE_CHAT then

    local a="";
    if subType==ConstConfig.SUB_TYPE_WORLD then
      a="[世界] ";
    elseif subType==ConstConfig.SUB_TYPE_PRIVATE then
      a="[私聊] ";
      if userName==ConstConfig.USER_NAME then
        a=a .. "我对" .. targetUserName .. "说 :";
      else
        a=a .. userName .. "对我说 :";
      end
      return a;
    elseif subType==ConstConfig.SUB_TYPE_INFLUENCE then
      a="[势力] ";
    elseif subType==ConstConfig.SUB_TYPE_GROUP then
      a="[队伍] ";
    elseif subType==ConstConfig.SUB_TYPE_FACTION then
      a="[帮派] ";
    elseif subType==ConstConfig.SUB_TYPE_NEAR then
      a="[附近] ";
    elseif subType==ConstConfig.SUB_TYPE_BROAD then
      return "[广播] ";
    end
    return a .. userName .." :";
  elseif mainType==ConstConfig.MAIN_TYPE_BUDDY then
    local b="";
    if userName==ConstConfig.USER_NAME then
      b="我对" .. targetUserName .. "说 :";
    else
      b=userName .. "对我说 :";
    end
    return b;
  end
end

function SmallChatPopup:getIsUser(data)
  return data.UserName==ConstConfig.USER_NAME;
end






function SmallChatPopup:onMenu()
  self:refreshPos(not getMenuOpened());
end

function SmallChatPopup:refreshPos(bool)
  print("->",bool);
  self:stopAllActions();
  print("++++++++++++++++++SmallChatPopup",self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_53));
  self:setVisible(self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_53));
  local moveTo1;
  function cf()
    
  end
  if bool then
    local array=CCArray:create();
    moveTo1=CCMoveBy:create(0.3,ccp(0,self:getGroupBounds().size.height));
    local delay=CCDelayTime:create(3);
    local callBack=CCCallFunc:create(cf);
    array:addObject(moveTo1);
    array:addObject(delay);
    array:addObject(callBack);
    self:runAction(CCSequence:create(array));
  else
    moveTo1=CCMoveTo:create(0.3,ccp(self:getPositionX(),self:getPositionY()-self:getGroupBounds().size.height));
    local easeOut1=CCEaseIn:create(moveTo1,0.3);
    self:runAction(easeOut1);
  end
end