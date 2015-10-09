--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-15

	yanchuan.xie@happyelements.com
]]

require "core.utils.CommonUtil";
require "core.controls.Button";
require "core.events.DisplayEvent";
require "core.controls.CommonPopup";
require "core.controls.TextLineInput";
require "main.view.chat.ui.chatPopup.ChatTalkerScrollList";
require "main.view.chat.ui.chatPopup.BuddyItemPopup";
require "core.controls.CommonScrollList";

BuddyFeedItem=class(Layer);

function BuddyFeedItem:ctor()
  self.class=BuddyFeedItem;
end

function BuddyFeedItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  BuddyFeedItem.superclass.dispose(self);
end

function BuddyFeedItem:initialize(skeleton, context, data, itemSize)
  self:initLayer();
  self.skeleton=skeleton;
  self.context=context;
  self.data=data;
  self.itemSize=itemSize;
  self.isUser=data.UserName==ConstConfig.USER_NAME;

  local function cb(a, b)
    self.context.container_parent:lookInto(a,b,nil,false);
  end
  self.text=createAutosizeMultiColoredLabelWithTextData({x=0,y=0,size=18,width=itemSize.width,height=itemSize.height,alignment=kCCTextAlignmentLeft},self:getContent(self.data));
  self.text:initialize();
  self.text:setLinkFunctionHandle(cb);
  self.text:addEventListener(DisplayEvents.kTouchBegin,self.onTextTap,self);
  self.text:setPositionY(5);
  self:addChild(self.text);
  local size=self.text:getContentSize();
  self:setContentSize(makeSize(size.width,10+size.height));
end

function BuddyFeedItem:onTextTap(event)
  self.context.container_parent.buddy_item_popup_pos=event.globalPosition;
end

function BuddyFeedItem:getContent(data)
  local id=data.ID;
  local paramStr1=data.ParamStr1;
  local paramStr2=data.ParamStr2;
  local paramStr3=data.ParamStr3;
  local str=analysis("Tishi_Haoyoudongtai",id,"txt");
  if ""==str then
    return;
  end
  local sarr=StringUtils:broad_string_split(str);
  local chat={};
  for k,v in pairs(sarr) do
    local data={};
    data.Type=ConstConfig.CHAT_CONTENT_ARRAY_TYPE_FONT;
    if 1==id then
      if "@1"==v[2] then
        data.ParamStr1=v[1];
        data.ParamStr2=ConstConfig.CHAT_NAME .. "," .. paramStr1;
        data.ParamStr3="1";
        data.ParamStr4=paramStr1;
      elseif "@2"==v[2] then
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=paramStr2;
      elseif "@3"==v[2] then
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=paramStr3;
      else
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=v[2];
      end
    elseif 2==id then
      if "@1"==v[2] then
        data.ParamStr1=v[1];
        data.ParamStr2=ConstConfig.CHAT_NAME .. "," .. paramStr1;
        data.ParamStr3="1";
        data.ParamStr4=paramStr1;
      elseif "@2"==v[2] then
        data.ParamStr1=string.sub(getColorByQuality(analysis("Yinghun_Yinghunku",paramStr2,"quality"),true),2,7);
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=analysis("Yinghun_Yinghunku",paramStr2,"name");
      else
        data.ParamStr1=v[1];
        data.ParamStr2="";
        data.ParamStr3="";
        data.ParamStr4=v[2];
      end
    end
    table.insert(chat,data);
  end
  local a=os.date("*t",data.Time);
  local h=a.hour;
  local text;
  if 10>tonumber(h) then
    h="0" .. h;
  end
  local m=a.min;
  if 10>tonumber(m) then
    m="0" .. m;
  end
  text='<font color="#FFFFFF">[ ' .. h .. ':' .. m .. ' ]   </font>';
  str='<content>' .. text .. StringUtils:setContentData(chat) .. '</content>';
  return str;
end