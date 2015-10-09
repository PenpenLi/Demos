require "main.view.modalDialog.ui.LeftModalDialogPopup";


local _callBackFun = nil
ModalDialogUI=class(LayerPopableDirect);

function ModalDialogUI:ctor()
  self.class=ModalDialogUI;
  self.talkmiddleArr = nil;
  self.loop = 1;
  self.step = 1;
  self.const_max_task = 5;
  self.dialogTaskId = 1;
  self.strongPointId = 0;
end

function ModalDialogUI:dispose()
  -- self:removeDialogTimer()
  self:removeAllEventListeners();
  self:removeChildren();
	ModalDialogUI.superclass.dispose(self);
  BitmapCacher:removeUnused();
  _callBackFun = nil
end
function ModalDialogUI:initialize()

  self:initLayer();
end
function ModalDialogUI:onDataInit()
  print("11111111111111function ModalDialogUI:onDataInit()")
    self.taskProxy=self:retrieveProxy(TaskProxy.name);
  self.bagProxy=self:retrieveProxy(BagProxy.name);
  self.itemUseQueueProxy=self:retrieveProxy(ItemUseQueueProxy.name);
  self.userProxy=self:retrieveProxy(UserProxy.name);
  self.battleProxy=self:retrieveProxy(BattleProxy.name)
  self.storyLineProxy=self:retrieveProxy(StoryLineProxy.name)
end
function ModalDialogUI:onPrePop()
  
  self.skeleton = self.taskProxy:getModalDialogSkeleton();
  

  
  self:addEventListener(DisplayEvents.kTouchTap, self.onTaskTap, self);  
  local mainSize = Director:sharedDirector():getWinSize();
  self.sprite:setContentSize(CCSizeMake(mainSize.width, mainSize.height));


end

function ModalDialogUI:onUIInit()

  self.leftModalDialogPopup = LeftModalDialogPopup.new();
  self.leftModalDialogPopup:initializeUI(self.skeleton);
  --if not self.isBattleDialog then
    self.leftModalDialogPopup:setPositionXY(-1 * GameData.uiOffsetX,-1 * GameData.uiOffsetY);
  --end
  
  self:addChild(self.leftModalDialogPopup);

  self.jianTouEffect = cartoonPlayer("1095",1200, 70,0,nil,.8)
  self.jianTouEffect.touchEnabled = false;
  self:addChild(self.jianTouEffect);


  print("self.strongPointId, self.dialogTaskId", self.strongPointId, self.dialogTaskId)

  self.taskPo = analysis("Juqing_Guankaduihua", self.dialogTaskId);

  self.talkNPCArr = StringUtils:lua_string_split(self.taskPo.talkGetNPC, "#")
  self.talkPlayerArr = StringUtils:lua_string_split(self.taskPo.talkGetPlayer, "#")
  self.talkmiddleArr = StringUtils:lua_string_split(self.taskPo.talkmiddle, "#");
  self:setShowDialog()

end

function ModalDialogUI:refreshModalDialog(data)

  self.strongPointId = data.strongPointId
  self.enterBattle = data.enterBattle
  self.battleType = data.battleType;
  self.dialogTaskId = data.dialogTaskId;
  self.doNotSendToServer = data.doNotSendToServer;
  self.step = 1;
  self.loop = 1;

  print("self.battleType", self.battleType)
end

-- 战场押黑
function ModalDialogUI:refreshModalDialogForBattle(data)
  self.isBattleDialog = true;
  self.battleDialogArr = nil;
  self.isTutorAfterBattle = data.isTutorAfterBattle
  self.isGreenHand = data.isGreenHand
  _callBackFun = data.callBackFun

  self:onDataInit()
  self:onPrePop()

  self.leftModalDialogPopup = LeftModalDialogPopup.new();
  self.leftModalDialogPopup:initializeUI(self.skeleton);


  --if not self.isBattleDialog then
    self.leftModalDialogPopup:setPositionXY(-1 * GameData.uiOffsetX,-1 * GameData.uiOffsetY);
  --end
  
  self:addChild(self.leftModalDialogPopup);

  self.step = 1;
  self.battleDialogArr = StringUtils:lua_string_split(data.dialog, "@")
  self.totalStep = #self.battleDialogArr;
	self:setBattleShowDialog()

  -- local function dialogTimer()
  --       self:removeDialogTimer();
  --       local paramTabel = {isTutorAfterBattle=self.isTutorAfterBattle,isGreenHand = self.isGreenHand}
  --       local event = Event.new("BATTLE_DIALOG_EVENT", paramTabel , self);
  --       self:dispatchEvent(event); 
 
  -- end
  -- self.dialogTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(dialogTimer, 80, false)
  self.jianTouEffect = cartoonPlayer("1095",1200, 70,0,nil,.8)
  self.jianTouEffect.touchEnabled = false;
  self.jianTouEffect:setPositionY(70-GameData.uiOffsetY)
  self:addChild(self.jianTouEffect);
end

-- function ModalDialogUI:removeDialogTimer()
--       if self.dialogTimer then
--               Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.dialogTimer);
--               self.dialogTimer = nil
--       end
-- end

function ModalDialogUI:setBattleShowDialog()
    if self.step > self.totalStep then
          -- self:removeDialogTimer();
      if _callBackFun then
        _callBackFun()
        _callBackFun = nil
      end
    
      local paramTabel = {isTutorAfterBattle=self.isTutorAfterBattle,isGreenHand = self.isGreenHand}
      local event = Event.new("BATTLE_DIALOG_EVENT", paramTabel , self);
      self:dispatchEvent(event);       
      return;
    end
    local dialogStringArr = StringUtils:lua_string_split(self.battleDialogArr[self.step], "#")
    local nameID = dialogStringArr[1];
    if nameID == "10" then
          self.leftModalDialogPopup:refreshModalDialog(self.userProxy.career, self.userProxy.userName, dialogStringArr[3],nil,1,dialogStringArr[2])
    else

          local npcName =  analysis("Juqing_JuqingNPC", nameID, "name")
          self.leftModalDialogPopup:refreshModalDialog(nameID, npcName, dialogStringArr[3],nil,nil,dialogStringArr[2])
    end
    self.step = self.step + 1;
end

function ModalDialogUI:setShowDialog()
  if self.battleType==10 then
    bg=875
  else
    bg=getCurrentBgArtId()
  end
    local resultValue = self:getDialogByLoop()
    if resultValue ~= "" then
      print("3333333333333333333333333333self.step", self.step)
      if self.step == 1 then
        resultValue = StringUtils:stuff_string_replace(resultValue, 'name', self.userProxy.userName, 4);
        local npcName =  analysis("Juqing_JuqingNPC", self.taskPo.getNPC, "name")
        self.leftModalDialogPopup:refreshModalDialog(self.taskPo.getNPC, npcName, resultValue,bg)
        self.step = 2;
      elseif self.step == 2 then
        resultValue = StringUtils:stuff_string_replace(resultValue, 'name', self.userProxy.userName, 4);
        self.leftModalDialogPopup:refreshModalDialog(self.userProxy.career, self.userProxy.userName, resultValue,bg,1)
        self.step = 3;
      elseif self.step == 3 then
        local middleNpcName = analysis("Juqing_JuqingNPC", self.taskPo.middleNpc, "name");
        resultValue = StringUtils:stuff_string_replace(resultValue, 'name', self.userProxy.userName, 4);
        self.leftModalDialogPopup:refreshModalDialog(self.taskPo.middleNpc, middleNpcName, resultValue,bg);
        self.loop = self.loop + 1;
        self.step = 1;
      end
    end
end
--一共三轮对话。
function ModalDialogUI:getDialogByLoop()
   local returnValue = "";
   if self.step == 1 then
      if self:hasDialog(self.talkNPCArr[self.loop]) then
         self.step = 1;
         returnValue = self.talkNPCArr[self.loop];
      elseif self:hasDialog(self.talkPlayerArr[self.loop])  then
         self.step = 2;
         returnValue = self.talkPlayerArr[self.loop];
      elseif self:hasDialog(self.talkmiddleArr[self.loop])  then
         self.step = 3;
         returnValue = self.talkmiddleArr[self.loop];
      else
         self:hanleTaskEvent(); 
         print("dialogOver 1")
      end 
   elseif self.step == 2 then
      if self:hasDialog(self.talkPlayerArr[self.loop])  then
         self.step = 2;
         returnValue = self.talkPlayerArr[self.loop];
      elseif self:hasDialog(self.talkmiddleArr[self.loop])  then
         self.step = 3;
         returnValue = self.talkmiddleArr[self.loop];
      elseif self:hasDialog(self.talkNPCArr[self.loop + 1])  then
         self.loop = self.loop + 1
         self.step = 1;
         returnValue = self.talkNPCArr[self.loop];
      else
        self:hanleTaskEvent(); 
        print("dialogOver 2")
      end 
   elseif self.step == 3 then
      if self:hasDialog(self.talkmiddleArr[self.loop])  then
         self.step = 3;
         returnValue = self.talkmiddleArr[self.loop];
      elseif self:hasDialog(self.talkNPCArr[self.loop + 1])  then
         self.loop = self.loop + 1
         self.step = 1;
         returnValue = self.talkNPCArr[self.loop];
      elseif self:hasDialog(self.talkPlayerArr[self.loop + 1])  then
         self.loop = self.loop + 1;
         self.step = 2;
         returnValue = self.talkPlayerArr[self.loop];
      else
        self:hanleTaskEvent(); 
        print("dialogOver 2")
      end 
   end
   return returnValue;
end
function ModalDialogUI:hasDialog(content)
   if "" == content or nil == content then
      return false;     
   else
      return true;
   end
end
function ModalDialogUI:hanleTaskEvent()
    print("self.taskPo.id", self.taskPo.id)
    if self.strongPointId ~= 0 and not self.doNotSendToServer then
      local msg = {StrongPointId = self.strongPointId};
      sendMessage(4,2,msg); 
    end
    if self.enterBattle then
      if not self.battleType then
        self.battleType = BattleConfig.BATTLE_TYPE_10;
      end
      self:dispatchEvent(Event.new("ENTER_BATTLE_EVENT", {strongPointId = self.strongPointId, battleType = self.battleType}, self));
    end
    if GameVar.tutorStage == TutorConfig.STAGE_1002 then
      sendServerTutorMsg({Stage = GameVar.tutorStage, Step = 100201, BooleanValue = 0})
      local hBttonGroupMediator = Facade.getInstance():retrieveMediator(HButtonGroupMediator.name);
      local targetPosData = hBttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_24)--剧情
      openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_STORY_BTN_W, height = GameConfig.TUTOR_STORY_BTN_H});
      if GameVar.hideCurrencyForTutor then
       GameVar.hideCurrencyForTutor = nil;
       setCurrencyGroupVisible(true)
      end
    end
    self:onCloseButtonTap();
end
function ModalDialogUI:checkBagFull()
  local taskPo = analysis("Renwu_Renwubiao", self.taskPo.ID);  
  if taskPo.get == "" then
     return false; 
  else
    local result = self:handleCheckBagFullByAward(taskPo.get);
    return result;
  end
  return false;
end

function ModalDialogUI:handleCheckBagFullByAward(awardStr)
  local itemCount = 0;--占格子的道具数目
  local acceptAwardTable =  StringUtils:lua_string_split(awardStr, ";");     
  for i_k, i_v in pairs(acceptAwardTable) do
       if i_v ~= "" then
         local oneTaskRewards = StringUtils:lua_string_split(i_v, ",");
         local itemId = tonumber(oneTaskRewards[1]);
         if itemId > 100 then
            itemCount = itemCount + 1;
         end
       end
  end
  if itemCount > 0 and self.bagProxy:getBagLeftPlaceCount(self.itemUseQueueProxy) < itemCount then
      return true;
  end
  return false;
end

function ModalDialogUI:onTaskTap(event)

    MusicUtils:playEffect(505,false);
    if not self.isBattleDialog then
        self:setShowDialog();
    else
        self:setBattleShowDialog();
    end
    --self.step = self.step + 1; 
end
function ModalDialogUI:onCloseButtonTap(event)
    self:dispatchEvent(Event.new("MODAL_DIALOG_CLOSE", nil, self))
end

