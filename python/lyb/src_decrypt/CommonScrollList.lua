--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-15

	yanchuan.xie@happyelements.com
]]

require "core.controls.ScrollPane";
require "core.display.Layer";
require "core.display.ccTypes";
require "core.utils.CommonUtil";

CommonScrollList=class(Layer);

function CommonScrollList:ctor()
  self.class=CommonScrollList;
  self.scrollPane=ScrollPane.new();
end

function CommonScrollList:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  CommonScrollList.superclass.dispose(self);
end

function CommonScrollList:initialize(position, viewSize, maxItem)
  self:initLayer();
  self:setPosition(position);

  self.scrollPane:initLayer();
  self.scrollPane:setDirection(kCCScrollViewDirectionVertical);
  self.scrollPane:setContentSize(makeSize(1,1));
  self.scrollPane:setViewSize(viewSize);
  self:addChild(self.scrollPane);

  self.viewSize=viewSize;
  self.maxItem=maxItem;
  self.items={};
  self.item_height=0;
end

function CommonScrollList:appendItem(item, height)
  local a={item, height};
  table.insert(self.items, a);

  self:setItemHeight();
  self.scrollPane:addChild(item);
  
  self:scrollToBottom();

  if nil~=self.maxItem then
  	if #self.items>self.maxItem then
  		self:pullItem();
  	end
  end
end

function CommonScrollList:pullItem()
  local item=self.items[1];
  table.remove(self.items,1);

  self.scrollPane:removeChild(item[1]);
  self:setItemHeight();

  self:scrollToBottom();
end

function CommonScrollList:scrollToBottom()
  local size=self.scrollPane:getContentSize();
  if size.height<self.viewSize.height then
    self.scrollPane:setContentOffset(makePoint(0, self.viewSize.height-size.height) ,true);
    return;
  end
  self.scrollPane:setContentOffset(makePoint(0, 0) ,true);
end

function CommonScrollList:setItemHeight()
  self.item_height=0;
  for k,v in pairs(self.items) do
    self.item_height=v[2]+self.item_height;
  end
  local a=self.item_height;
  self.scrollPane:setContentSize(makeSize(self.viewSize.width, self.item_height));
  for k,v in pairs(self.items) do
    a=-v[2]+a;
    v[1]:setPositionXY(0,a);
  end
end

function CommonScrollList:refreshChatContent(data)
  local userName=data.UserName;
  local level=data.Level;
  local chatContent=data.ChatContent;
  local mainType=data.MainType;
  local subType=data.SubType;
  local textData=copyTable(ConstConfig.CHAT_TEXT_DATA);

  chatContent=userName .. ": " .. chatContent;

  if mainType==ConstConfig.MAIN_TYPE_CHAT then

    if subType==ConstConfig.SUB_TYPE_WORLD then
      textData.color=16762880;
      chatContent="[世界]" .. chatContent;
    elseif subType==ConstConfig.SUB_TYPE_PRIVATE then
      chatContent="[私聊]" .. chatContent;
    elseif subType==ConstConfig.SUB_TYPE_INFLUENCE then
      chatContent="[势力]" .. chatContent;
    elseif subType==ConstConfig.SUB_TYPE_GROUP then
      textData.color=6619135;
      chatContent="[队伍]" .. chatContent;
    elseif subType==ConstConfig.SUB_TYPE_FACTION then
      chatContent="[帮会]" .. chatContent;
    elseif subType==ConstConfig.SUB_TYPE_HELP_BUDDY then
      chatContent="[求助]" .. chatContent;
    end

  elseif mainType==ConstConfig.MAIN_TYPE_BUDDY then

  end

  if userName==ConstConfig.USER_NAME then
    textData.color=16777215;
  end

  textData.height=textData.height*math.ceil(createTextFieldWithTextDataTest(textData,chatContent)/textData.width);
  local text=createTextFieldWithTextData(textData,chatContent);
  self:appendItem(text,text:getContentSize().height);print(mainType,subType,chatContent);
end