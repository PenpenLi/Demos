require "core.utils.CommonUtil";
require "core.controls.Button";
require "core.events.DisplayEvent";
require "core.controls.CommonPopup";
require "core.controls.TextLineInput";
require "main.view.chat.ui.chatPopup.ChatTalkerScrollList";
require "core.controls.CommonScrollList";

ChatContentItem=class(Layer);

function ChatContentItem:ctor()
  self.class=ChatContentItem;
end

function ChatContentItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  ChatContentItem.superclass.dispose(self);
end

function ChatContentItem:initialize(skeleton, context, data, itemSize)
  self:initLayer();
  self.skeleton=skeleton;
  self.context=context;
  self.data=data;
  self.itemSize=itemSize;
  self.isUser=data.UserName==ConstConfig.USER_NAME;
  
  self.layerCont = LayerColor.new();
  self.layerCont:initLayer();
  self.layerCont:changeWidthAndHeight(985,95);
  self.layerCont:setOpacity(0);
  self:addChild(self.layerCont);

  local img_bg = CommonSkeleton:getBoneTextureDisplay("commonImages/common_player_bg");
  img_bg:setPositionXY(20,12);
  self.layerCont:addChild(img_bg);

  local img_line = self.context.skeleton:getBoneTexture9Display("line",nil,165,1);
  img_line:setPositionXY(0,3);
  self.layerCont:addChild(img_line);

  if not self.data.ConfigId or 0 == self.data.ConfigId then
    self.data.ConfigId = 1;
  end
  if self.data.ConfigId and 0 ~= self.data.ConfigId then
    local img = Image.new();
    print(">",self.data.ConfigId);
    img:loadByArtID(analysis("Zhujiao_Huanhua",self.data.ConfigId,"head"));
    img:setScale(0.76);
    img:setPositionXY(26,20);
    self.layerCont:addChild(img);
  end

  --local text=self:getContent4GM(self.data.MainType,self.data.SubType,self.data.UserName,self.data.TargetUserName);
  local function cb(a, b)
    if string.find(a,"familyID:") then
      a = string.gsub(a,"familyID:","");
      local str = StringUtils:lua_string_split(a,",");
      self.context:applyFamily(str[2]);
    else
      self.context:lookInto(a,b,text,true);
    end
  end
  
  self.text=createRichMultiColoredLabelWithTextData({x=0,y=0,size=26,width=itemSize.width,height=itemSize.height,alignment=kCCTextAlignmentLeft},self:getContent(self.data.MainType,self.data.SubType,self.data.UserName,self.data.TargetUserName, self.data.UserId, self.data.TargetUserId));
  self.text:initialize();
  self.text:setLinkFunctionHandle(cb);
  self.text:addEventListener(DisplayEvents.kTouchBegin,self.onTextTap,self);
  -- self.text:setPositionY((GameData.gameUIScaleRate-1)>0 and -50*(GameData.gameUIScaleRate-1) or 0);
  -- log(self.text:getPositionY());
  self.text:setPositionXY(112,16);
  self.layerCont:addChild(self.text);
  
  local channel_text = createRichMultiColoredLabelWithTextData({x=0,y=0,width=100,height=50,size=26,alignment=kCCTextAlignmentLeft},self:getChannel(self.data.MainType,self.data.SubType,self.data.UserName,self.data.TargetUserName, self.data.UserId, self.data.TargetUserId));
  channel_text:setPositionXY(112,55);
  local channel_textSize=channel_text:getContentSize();
  self.layerCont:addChild(channel_text);

  local vipWidth = 0;
  local vipImg = getVIPImg(self.data.VipLevel);
  if vipImg then
    vipImg:setScale(0.65);
    vipImg:setPositionXY(channel_textSize.width+112,58);
    self.layerCont:addChild(vipImg);

    vipWidth=vipImg:getGroupBounds().size.width;
  end

  local name_text = createRichMultiColoredLabelWithTextData({x=0,y=0,width=500,height=50,size=26,alignment=kCCTextAlignmentLeft},self:getNameWithFamily(self.data.MainType,self.data.SubType,self.data.UserName,self.data.TargetUserName, self.data.UserId, self.data.TargetUserId));
  name_text:initialize();
  name_text:setLinkFunctionHandle(cb);
  name_text:addEventListener(DisplayEvents.kTouchBegin,self.onTextTap,self);
  name_text:setPositionXY(channel_textSize.width+vipWidth+10+112,55);
  self.layerCont:addChild(name_text);

  local size=self.layerCont:getContentSize();--self.text:getContentSize();
  self:setContentSize(makeSize(size.width,size.height));
end

function ChatContentItem:onTextTap(event)
  self.context.buddy_item_popup_pos=event.globalPosition;
  -- self.context.buddy_item_popup_pos.y = 20 + self.context.buddy_item_popup_pos.y;
end

function ChatContentItem:getChannel(mainType, subType, userName, targetUserName, userID, targetUserID)
  if mainType==ConstConfig.MAIN_TYPE_CHAT then
    local a='<content>';
    if subType==ConstConfig.SUB_TYPE_WORLD then
      a=a .. '<font color="#E1D2A0">[世界] </font>';
    elseif subType==ConstConfig.SUB_TYPE_PRIVATE then
      a=a .. '<font color="#FDEE03">[私聊] </font>';
    elseif subType==ConstConfig.SUB_TYPE_INFLUENCE then
      a=a .. '<font color="#FFA200">[势力] </font>';
    elseif subType==ConstConfig.SUB_TYPE_GROUP then
      a=a .. '<font color="#00FFB4">[队伍] </font>';
    elseif subType==ConstConfig.SUB_TYPE_FACTION then
      a=a .. '<font color="#FF00F6">[帮派] </font>';
    elseif subType==ConstConfig.SUB_TYPE_NEAR then
      a=a .. '<font color="#00A2FF">[附近] </font>';
    elseif subType==ConstConfig.SUB_TYPE_BROAD then
      a=a .. '<font color="#FFFC00">[广播] </font>';
    end
    return a .. '</content>';
  elseif mainType==ConstConfig.MAIN_TYPE_BUDDY then
    return '<content><font color="#E1D2A0">[好友] </font></content>'
  end
end

function ChatContentItem:getContent(mainType, subType, userName, targetUserName, userID, targetUserID)
  -- if mainType==ConstConfig.MAIN_TYPE_CHAT then

  -- 	local a='<content>';
  --   if subType==ConstConfig.SUB_TYPE_WORLD then
  --     a=a .. '<font color="#E1D2A0">[世界] </font>';
  --   elseif subType==ConstConfig.SUB_TYPE_PRIVATE then
  --     a=a .. '<font color="#FDEE03">[私聊] </font>';
  --     if self.isUser then
  --       a=a .. '<font color="#FFFFFF">我对</font><font color="#00FCFF" link="' .. ConstConfig.CHAT_NAME .. ',' .. targetUserName .. ',' .. targetUserID .. '" ref="1">' .. targetUserName .. '</font><font color="#FFFFFF">说 :</font>';
  --     else
  --       a=a .. '<font color="#00FCFF" link="' .. ConstConfig.CHAT_NAME .. ',' .. userName .. ','.. userID ..'" ref="1">' .. userName .. '</font><font color="#FFFFFF">对我说 :</font>';
  --     end
  --     return a .. StringUtils:setContentData(self.data.ChatContentArray) .. '</content>';
  --   elseif subType==ConstConfig.SUB_TYPE_INFLUENCE then
  --     a=a .. '<font color="#FFA200">[势力] </font>';
  --   elseif subType==ConstConfig.SUB_TYPE_GROUP then
  --     a=a .. '<font color="#00FFB4">[队伍] </font>';
  --   elseif subType==ConstConfig.SUB_TYPE_FACTION then
  --     a=a .. '<font color="#FF00F6">[帮派] </font>';
  --   elseif subType==ConstConfig.SUB_TYPE_NEAR then
  --     a=a .. '<font color="#00A2FF">[附近] </font>';
  --   elseif subType==ConstConfig.SUB_TYPE_BROAD then
  --     return a .. '<font color="#FFFC00">[广播] </font>' .. StringUtils:setContentData(self.data.ChatContentArray) .. '</content>';
  --   end
  --   return a .. '<font color="#' .. (self.isUser and 'FFFFFF' or '00FCFF') .. '"' .. (self.isUser and '' or (' link="' .. ConstConfig.CHAT_NAME .. ',' .. userName .. ','.. userID .. '" ref="1"')) .. '>' .. userName .. '</font><font color="#FFFFFF"> :</font>' .. StringUtils:setContentData(self.data.ChatContentArray) .. '</content>';
  -- elseif mainType==ConstConfig.MAIN_TYPE_BUDDY then

  -- 	local b="<content>";
  -- 	if self.isUser then
  -- 	  b=b .. '<font color="#FFFFFF">我对</font><font color="#00FCFF">' .. targetUserName .. '</font><font color="#FFFFFF">说 :</font>';
  -- 	else
  -- 	  b=b .. '<font color="#00FCFF">' .. userName .. '</font><font color="#FFFFFF">对我说 :</font>';
  -- 	end
  -- 	return b .. StringUtils:setContentData(self.data.ChatContentArray) .. '</content>';
  -- end
  if mainType==ConstConfig.MAIN_TYPE_CHAT then

    local a='<content>';
    if subType==ConstConfig.SUB_TYPE_WORLD then
      
    elseif subType==ConstConfig.SUB_TYPE_PRIVATE then
      return a .. StringUtils:setContentData(self.data.ChatContentArray) .. '</content>';
    elseif subType==ConstConfig.SUB_TYPE_INFLUENCE then
      
    elseif subType==ConstConfig.SUB_TYPE_GROUP then
      
    elseif subType==ConstConfig.SUB_TYPE_FACTION then
      
    elseif subType==ConstConfig.SUB_TYPE_NEAR then
      
    elseif subType==ConstConfig.SUB_TYPE_BROAD then
      return a .. StringUtils:setContentData(self.data.ChatContentArray) .. '</content>';
    end
    return a .. StringUtils:setContentData(self.data.ChatContentArray) .. '</content>';
  elseif mainType==ConstConfig.MAIN_TYPE_BUDDY then
    local b="<content>";
    return b .. StringUtils:setContentData(self.data.ChatContentArray) .. '</content>';
  end
end

function ChatContentItem:getNameWithFamily(mainType, subType, userName, targetUserName, userID, targetUserID)
  if "" == userName then
    return "";
  end
  if mainType==ConstConfig.MAIN_TYPE_CHAT then

   local a='<content>';
    if subType==ConstConfig.SUB_TYPE_WORLD then
      
    elseif subType==ConstConfig.SUB_TYPE_PRIVATE then
      if self.isUser then
        a=a .. '<font color="#FFFFFF">我对</font><font color="#00FCFF" link="' .. ConstConfig.CHAT_NAME .. ',' .. targetUserName .. ',' .. targetUserID .. '" ref="1">' .. targetUserName .. '</font><font color="#FFFFFF">说 :</font>';
      else
        a=a .. '<font color="#00FCFF" link="' .. ConstConfig.CHAT_NAME .. ',' .. userName .. ','.. userID ..'" ref="1">' .. userName .. '</font><font color="#FFFFFF">对我说 :</font>';
      end
      return a .. '</content>';
    elseif subType==ConstConfig.SUB_TYPE_INFLUENCE then
      
    elseif subType==ConstConfig.SUB_TYPE_GROUP then
      
    elseif subType==ConstConfig.SUB_TYPE_FACTION then
      
    elseif subType==ConstConfig.SUB_TYPE_NEAR then
      
    elseif subType==ConstConfig.SUB_TYPE_BROAD then
      return a .. '<font color="#FFFFFF"></font></content>';
    end
    return a .. '<font color="#' .. (self.isUser and 'FFFFFF' or 'FFB400') .. '"' .. (self.isUser and '' or (' link="' .. ConstConfig.CHAT_NAME .. ',' .. userName .. ','.. userID .. '" ref="1"')) .. '>' .. userName .. ' </font><font color="#FFB400">' .. (''==self.data.FamilyName and '' or ('(' .. self.data.FamilyName .. '帮派) :')) .. '</font></content>';
  elseif mainType==ConstConfig.MAIN_TYPE_BUDDY then

   local b="<content>";
   if self.isUser then
     b=b .. '<font color="#FFFFFF">我对</font><font color="#00FCFF">' .. targetUserName .. '</font><font color="#FFFFFF">说 :</font>';
   else
     b=b .. '<font color="#00FCFF">' .. userName .. '</font><font color="#FFFFFF">对我说 :</font>';
   end
   return b .. '</content>';
  end
end

function ChatContentItem:getContent4GM(mainType, subType, userName, targetUserName)
  if mainType==ConstConfig.MAIN_TYPE_CHAT then

    local a='<content>';
    if subType==ConstConfig.SUB_TYPE_WORLD then
      a=a .. '<font color="#E1D2A0">[世界] </font>';
    elseif subType==ConstConfig.SUB_TYPE_PRIVATE then
      a=a .. '<font color="#FDEE03">[私聊] </font>';
      if self.isUser then
        a=a .. '<font color="#FFFFFF">我对</font><font color="#00FCFF" link="' .. ConstConfig.CHAT_NAME .. ',' .. targetUserName .. '" ref="1">' .. targetUserName .. '</font><font color="#FFFFFF">说 :</font>';
      else
        a=a .. '<font color="#00FCFF" link="' .. ConstConfig.CHAT_NAME .. ',' .. userName .. '" ref="1">' .. userName .. '</font><font color="#FFFFFF">对我说 :</font>';
      end
      return a .. StringUtils:setContentData4GM(self.data.ChatContentArray) .. '</content>';
    elseif subType==ConstConfig.SUB_TYPE_INFLUENCE then
      a=a .. '<font color="#FFA200">[势力] </font>';
    elseif subType==ConstConfig.SUB_TYPE_GROUP then
      a=a .. '<font color="#00FFB4">[队伍] </font>';
    elseif subType==ConstConfig.SUB_TYPE_FACTION then
      a=a .. '<font color="#FF00F6">[帮派] </font>';
    elseif subType==ConstConfig.SUB_TYPE_NEAR then
      a=a .. '<font color="#00A2FF">[附近] </font>';
    elseif subType==ConstConfig.SUB_TYPE_BROAD then
      return a .. '<font color="#FFFC00">[广播] </font>' .. StringUtils:setContentData4GM(self.data.ChatContentArray) .. '</content>';
    end
    return a .. '<font color="#' .. (self.isUser and 'FFFFFF' or '00FCFF') .. '"' .. (self.isUser and '' or (' link="' .. ConstConfig.CHAT_NAME .. ',' .. userName .. '" ref="1"')) .. '>' .. userName .. '</font><font color="#FFFFFF"> :</font>' .. StringUtils:setContentData4GM(self.data.ChatContentArray) .. '</content>';
  elseif mainType==ConstConfig.MAIN_TYPE_BUDDY then

    local b="<content>";
    if self.isUser then
      b=b .. '<font color="#FFFFFF">我对</font><font color="#00FCFF">' .. targetUserName .. '</font><font color="#FFFFFF">说 :</font>';
    else
      b=b .. '<font color="#00FCFF">' .. userName .. '</font><font color="#FFFFFF">对我说 :</font>';
    end
    return b .. StringUtils:setContentData4GM(self.data.ChatContentArray) .. '</content>';
  end
end