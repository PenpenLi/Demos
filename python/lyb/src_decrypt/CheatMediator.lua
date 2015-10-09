require "main.view.cheat.ui.CheatUI";

CheatMediator = class(Mediator);

function CheatMediator:ctor()
  self.class = CheatMediator;
	self.viewComponent = CheatUI.new();
end

rawset(CheatMediator,"name","CheatMediator");

function CheatMediator:onRegister()
  
  self:getViewComponent():addEventListener("INPUT_TASKCOUNT",self.onClickTaskIDInput,self);
  self:getViewComponent():addEventListener("INPUT_ITEMID",self.onClickItemIDInput,self);
  self:getViewComponent():addEventListener("INPUT_ITEMCOUNT",self.onClickItemCountInput,self);
  self:getViewComponent():addEventListener("CLICK_CONFIRM",self.onClickConfirmButton,self);
  self:getViewComponent():addEventListener("CLICK_ClearBag",self.onClickClearBag,self);
  
  
   -- self:getViewComponent().itemIDInput:addEventListener(DisplayEvents.kTouchTap,self.onClickItemIDInput,self);
--  self:getViewComponent().itemCountInput:addEventListener(DisplayEvents.kTouchTap,self.onClickItemCountInput,self);
--  self:getViewComponent().confirmButtonDO:addEventListener(DisplayEvents.kTouchTap,self.onClickConfirmButton,self);
end

function CheatMediator:onInit()
  self:getViewComponent():onInit()
end


function CheatMediator:onClickItemIDInput(event)
  self:getViewComponent().itemCountInput.sprite:closeIME()
   self:getViewComponent().taskIDInput.sprite:closeIME()
   self:getViewComponent().itemIDInput.sprite:openIME()
end

function CheatMediator:onClickItemCountInput(event)
  self:getViewComponent().itemIDInput.sprite:closeIME()
  self:getViewComponent().taskIDInput.sprite:closeIME()
  self:getViewComponent().itemCountInput.sprite:openIME()
end

function CheatMediator:onClickTaskIDInput(event)
  self:getViewComponent().itemCountInput.sprite:closeIME()
  self:getViewComponent().itemIDInput.sprite:closeIME()
  self:getViewComponent().taskIDInput.sprite:openIME()
end
function CheatMediator:onClickConfirmButton(event)
  local table = event.data;
  if table["msgType"] == 1 then
    table["msgType"] = nil;
    sendMessage(100,3,table);
  else
    table["msgType"] = nil;
    sendMessage(100,1,table);
  end
end

function CheatMediator:onClickClearBag(event)
  sendMessage(100,2);
end

function CheatMediator:onRemove()
	self:getViewComponent():dispose();
end