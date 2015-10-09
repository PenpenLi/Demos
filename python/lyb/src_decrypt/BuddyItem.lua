--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-15

	yanchuan.xie@happyelements.com
]]

require "core.controls.Button";
require "core.events.DisplayEvent";
require "core.utils.Scheduler";
require "core.controls.CommonPopup";
require "core.controls.CommonScrollList";

BuddyItem=class(Layer);

function BuddyItem:ctor()
  self.class=BuddyItem;
end

function BuddyItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	BuddyItem.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function BuddyItem:initialize(skeleton, data, context, onTap, onMsgStateContext, onMsgState)
  self:initLayer();
  self.skeleton=skeleton;
  
  self.context=context;
  self.onTap=onTap;
  self.onMsgStateContext=onMsgStateContext;
  self.onMsgState=onMsgState;

  self.data=data;
  self.selected=false;
  self.common_scroll_list=nil;
  self.is_online=false;
  self.pannel_tip=nil;

  --骨骼
  local armature=skeleton:buildArmature("buddy_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  --[[self.tip_new=self.armature:getChildByName("tip_new");
  self.tip_new.touchEnabled=false;
  self.tip_new.touchChildren=false;
  self.armature:removeChild(self.tip_new,false);

  self.tip_help=self.armature:getChildByName("tip_help");
  self.tip_help.touchEnabled=false;
  self.tip_help.touchChildren=false;
  self.armature:removeChild(self.tip_help,false);]]

  --buddy_item_bg
  self.buddy_item_bg=self.armature:getChildByName("buddy_item_bg");
  self.buddy_item_bg_pos=convertBone2LB(self.buddy_item_bg);
  --buddy_item_over
  self.buddy_item_over=self.armature:getChildByName("buddy_item_over");
  -- self.armature:removeChild(self.buddy_item_over,false);
  self.buddy_item_over:setVisible(false);
  --userName
  local text=StringUtils:substr(self.data.UserName);
  self.buddy_name_descb=createTextFieldWithTextData(armature:getBone("buddy_name_descb").textData,text);
  self.armature:addChild(self.buddy_name_descb);
  --online
  text="";
  self.online_descb=createTextFieldWithTextData(armature:getBone("online").textData,text);
  self.armature:addChild(self.online_descb);
  --common_copy_lv_bg
  self.common_copy_lv_bg=self.armature:getChildByName("common_copy_lv_bg");
  --level
  text=self.data.Level;
  self.buddy_level_descb=createTextFieldWithTextData(armature:getBone("common_copy_lv_bg").textData,text);
  self.armature:addChild(self.buddy_level_descb);

  --tip
  local tip=self.armature:getChildByName("pannel_tip_bg");
  local tip_pos=convertBone2LB(tip);
  self.armature:removeChild(tip);
  self.pannel_tip=PannelTip.new();
  self.pannel_tip:initialize(self.skeleton);
  self.pannel_tip:setPosition(tip_pos);
  self.armature:addChild(self.pannel_tip);

  self:addEventListener(DisplayEvents.kTouchTap,self.onItemTap,self);
end

function BuddyItem:createCommonScrollList()
  self.common_scroll_list=ChatContent.new();
  self.common_scroll_list:initialize(self.skeleton,self.context.context,true);
  self.common_scroll_list:setPosition(makePoint(265,155));
end

function BuddyItem:onItemTap(event)
  print(event);
  self.onTap(self.context,self,event);
end

function BuddyItem:refreshChatContent(data)
  
  --等级
  if self.data.Level~=data.Level then
    self.data.Level=data.Level;
    self.buddy_level_descb:setString(self.data.Level);
  end
  --[[聊天
  if data.MainType==ConstConfig.MAIN_TYPE_CHAT and false==self.selected then

    if data.SubType==ConstConfig.SUB_TYPE_PRIVATE and self.is_chat_private then
      self:removeAllTip();
      self:addChild(self.tip_new);
    elseif data.SubType==ConstConfig.SUB_TYPE_HELP_BUDDY then
      self:removeAllTip();
      self:addChild(self.tip_help);
    end
    
  end
  --好友
  if data.MainType==ConstConfig.MAIN_TYPE_BUDDY and false==self.selected then
    if false==self:contains(self.tip_new) then
      self:msgStateChange(1);
    end

    self:removeAllTip();
    self:addChild(self.tip_new);
  end]]

  --ChatContent
  if self.common_scroll_list then
    self.common_scroll_list:addContentItem(data);
  else
    self:getCommonScrollList();
  end

  if not self.selected then
    self:msgStateChange(1);
    if data.UserName~=ConstConfig.USER_NAME then
      self.pannel_tip:onMsg();
    end
  end
end

--更新好友
function BuddyItem:refreshBuddyData()
  self.buddy_level_descb:setString(self.data.Level);
end

function BuddyItem:select(boolean)
  print("????????????????????????????????????");
  --[[if self.is_buddy_item and self:contains(self.tip_new) then
    self:msgStateChange(0);
  end]]

  -- if boolean then
  --   --self:removeAllTip();
  --   self:addChild(self.buddy_item_over);
  -- else
  --   self:removeChild(self.buddy_item_over,false);
  -- end
  self.buddy_item_over:setVisible(boolean);
  self.selected=boolean;

  if self.pannel_tip:isVisible() then
    self:msgStateChange(0);
    self.pannel_tip:onTap();
  end
end

function BuddyItem:setOnline(boolean)
  if boolean==self.is_online then
    return;
  end
  self.is_online=boolean;
  local bg=self.skeleton:getCommonBoneTextureDisplay("common_inner_tab_button_normal");
  if self.buddy_item_bg then
    self.armature:removeChild(self.buddy_item_bg);
  end
  if boolean then
    self.buddy_item_bg=bg;
    self.buddy_item_bg:setPosition(self.buddy_item_bg_pos);
    self.armature:addChildAt(self.buddy_item_bg,0);
    self.armature:addChildAt(self.common_copy_lv_bg,3);
    self.armature:addChildAt(self.buddy_level_descb,3);

    self.buddy_name_descb:setString(StringUtils:substr(self.data.UserName));
    self.buddy_name_descb:setColor(CommonUtils:ccc3FromUInt(16777215));

    self.online_descb:setString("");
    self.online_descb:setColor(CommonUtils:ccc3FromUInt(16777215));
  else
    local data=CommonSkeleton.textureAtlasData:getSubTextureData("common_inner_tab_button_normal");
    self.buddy_item_bg=Sprite.new(getGraySprite(bg.sprite,data.x,data.y));
    self.buddy_item_bg:setPosition(self.buddy_item_bg_pos);
    self.armature:addChildAt(self.buddy_item_bg,0);
    self.armature:removeChild(self.common_copy_lv_bg,false);
    self.armature:removeChild(self.buddy_level_descb,false);

    self.buddy_name_descb:setString(StringUtils:substr(self.data.UserName));
    self.buddy_name_descb:setColor(CommonUtils:ccc3FromUInt(13421772));

    self.online_descb:setString("未在线");
    self.online_descb:setColor(CommonUtils:ccc3FromUInt(13421772));
  end
end

function BuddyItem:isEqualUserName(userName)
  return userName==self.data.UserName;
end

function BuddyItem:removeAllTip()
  --[[if self:contains(self.tip_new) then
    self:removeChild(self.tip_new,false);
  end
  if self:contains(self.tip_help) then
    self:removeChild(self.tip_help,false);
  end]]
end

function BuddyItem:msgStateChange(state)
  if self.onMsgStateContext and self.onMsgState then
    local a={UserId=self.data.UserId,UserName=self.data.UserName,State=state};
    self.onMsgState(self.onMsgStateContext,a);
  end
end

function BuddyItem:getCommonScrollList()
  if not self.common_scroll_list then
    self:createCommonScrollList();
    self.common_scroll_list:initializeData(self.context.chatListProxy:getBuddyData(self.data.UserName));
  end
  return self.common_scroll_list;
end

function BuddyItem:getCopyData()
  return copyTable(self.data);
end

--求助
function BuddyItem:getIsHelp()
  return self:contains(self.tip_help);
end

--名称
function BuddyItem:getUserName()
  return self.data.UserName;
end

function BuddyItem:getUserLevel()
  return self.data.Level;
end

function BuddyItem:getIsOnline()
  return self.is_online;
end

function BuddyItem:getUserId()
  return self.data.UserId;
end