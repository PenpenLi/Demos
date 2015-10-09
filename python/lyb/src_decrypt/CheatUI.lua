require "core.controls.TextInput"

CheatUI = class(Layer)

function CheatUI:ctor()
  self.class = CheatUI;
end

function CheatUI:dispose()
  --self:removeAllEventListeners();
  self:removeChildren();
end

--intialize UI
function CheatUI:onInit()
  
  self:initLayer()
  
--  local movieClip = MovieClip.new();
--  movieClip:initFromFile("cheat_ui", "main");
--  movieClip:gotoAndPlay("f1");
--  self:addChild(movieClip.layer);
--  movieClip:update();
  
--  self.closeButtonDO = movieClip.armature:getBone("common_copy_close_button").displayBridge.display
--  self.confirmButtonDO = movieClip.armature:getBone("common_copy_button").displayBridge.display
  -- self:setPositionXY(100,100)
  self.itemIDInput = TextInput.new("道具Id...",  20);
  self.taskIDInput = TextInput.new("任务Id...",  20);
  self.itemCountInput = TextInput.new("道具数量...",  20);
  
  self:addChild(self.itemIDInput)
  self:addChild(self.itemCountInput)
  self:addChild(self.taskIDInput)
  
  self.itemIDInput:setPositionXY(50,150)
  self.itemCountInput:setPositionXY(200,150)
  self.taskIDInput:setPositionXY(50,210)

  
  self.itemIDInput:addEventListener(DisplayEvents.kTouchTap,self.onInputItemID,self)
  self.itemCountInput:addEventListener(DisplayEvents.kTouchTap,self.onInputItemCount,self)
  self.taskIDInput:addEventListener(DisplayEvents.kTouchTap,self.onInputTaskID,self)
--  self.closeButtonDO:addEventListener(DisplayEvents.kTouchTap,self.onClickCloseButton,self)
--  self.confirmButtonDO:addEventListener(DisplayEvents.kTouchTap,self.onClickConformButton,self)


  -- self.confirmText = MultiColoredLabel.new('<content><font color="#00FF00">格式</font><font color="#FF0000">1500001,3</font></content>', "fonts/FZY4JW.ttf", 40);
	-- self.confirmText:setPositionXY(50, 350);
	-- self:addChild(self.confirmText);


  self.closeText = TextField.new(CCLabelTTF:create("000000",FontConstConfig.OUR_FONT,24),true);
  self.closeText:setString("关闭");
  self.closeText:setPositionXY(50,50);
  self:addChild(self.closeText);
  self.closeText:addEventListener(DisplayEvents.kTouchTap,self.onClickCloseButton,self)
  
  
  self.confirmText = TextField.new(CCLabelTTF:create("000000",FontConstConfig.OUR_FONT,24),true);
  self.confirmText:setString("确定");
  self.confirmText:setPositionXY(200,50);

  self.titleText = TextField.new(CCLabelTTF:create("ffffff",FontConstConfig.OUR_FONT,24),true);
  self.titleText:setString("作弊");
  self.titleText:setPositionXY(100,300);
  
  self.clearBag = TextField.new(CCLabelTTF:create("ffffff",FontConstConfig.OUR_FONT,24),true);
  self.clearBag:setString("---清空背包---");
  self.clearBag:setPositionXY(150,250);
  
  self:addChild(self.confirmText);
  self:addChild(self.titleText);
  self:addChild(self.clearBag);
  self.confirmText:addEventListener(DisplayEvents.kTouchTap,self.onClickConformButton,self)
  self.clearBag:addEventListener(DisplayEvents.kTouchTap,self.onClickClearBag,self)
end

function CheatUI:setData()

end

function CheatUI:onInputItemID(event)
  self:dispatchEvent(Event.new("INPUT_ITEMID",{},self));
end

function CheatUI:onInputItemCount(event)
  self:dispatchEvent(Event.new("INPUT_ITEMCOUNT",{},self));
end

function CheatUI:onInputTaskID(event)
  self:dispatchEvent(Event.new("INPUT_TASKCOUNT",{},self));
end
function CheatUI:onClickCloseButton(event)
  self:dispose()
end

function CheatUI:onClickClearBag(event)
  self:dispatchEvent(Event.new("CLICK_ClearBag",table,self));
end

function CheatUI:onClickConformButton(event)
  
  local table = {};
  local taskId = self.taskIDInput:getInputText();
  if "" ~= taskId then
      table["msgType"] = 1;
      table["TaskId"] = tonumber(taskId);

  else
      table["msgType"] = 2;
      local itemId = self.itemIDInput:getInputText()
  
      local pos = string.find(itemId, ",");
      if pos then
        table["ItemId"] = string.sub(itemId,1,pos-1)
        table["Count"] = string.sub(itemId,pos+1,-1)
      else  
        table["ItemId"] = self.itemIDInput:getInputText()
        table["Count"] = self.itemCountInput:getInputText()
      end
  end



 
  self:dispatchEvent(Event.new("CLICK_CONFIRM",table,self));
  
end

