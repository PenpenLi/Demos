require "core.utils.CommonUtil";
require "core.controls.Button";
require "core.events.DisplayEvent";
require "core.controls.CommonPopup";
require "core.controls.TextLineInput";
require "main.view.chat.ui.chatPopup.ChatContentItem";
require "core.controls.CommonScrollList";

ChatContent=class(Layer);

function ChatContent:ctor()
  self.class=ChatContent;
end

function ChatContent:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  ChatContent.superclass.dispose(self);
end

function ChatContent:initialize(context)
  self:initLayer();
  self.context=context;
  self.skeleton=self.context.skeleton;
  self.isBuddy=isBuddy;
  local viewSize=makeSize(955,435);
  local itemSize=makeSize(955,95);
  self.itemSize=itemSize;

  self.listScrollViewLayer=ListScrollViewLayer.new();
  self.listScrollViewLayer:initLayer();
  self.listScrollViewLayer:setViewSize(viewSize);
  self.listScrollViewLayer:setItemSize(itemSize);
  self:addChild(self.listScrollViewLayer);
end

function ChatContent:initializeData(datas)
  for k,v in pairs(datas) do
    self:addContentItem(v);
  end
end

function ChatContent:addContentItem(data)
  local a=ChatContentItem.new();
  a:initialize(self.skeleton,self.context,data,self.itemSize);
  self.listScrollViewLayer:addItem(a,true);
  self:refreshListScrollViewLayer();
end

function ChatContent:refreshListScrollViewLayer()
  if ConstConfig.CHAT_MAX_ITEM<self.listScrollViewLayer:getItemCount() then
    self.listScrollViewLayer:removeItemAt(0);
    self.listScrollViewLayer:scrollToItemByIndex(-1+ConstConfig.CHAT_MAX_ITEM);
  end
end