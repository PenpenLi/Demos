-------------------------
--BattleInitCommand handler_7_6 handler_7_13
-------------------------

BattleOverCommand=class(MacroCommand);

function BattleOverCommand:ctor()
	self.class=BattleOverCommand;
	self.battleProxy = nil;
	self.scheduleFun = nil;
	self.battleOverNewUI = nil;
	self.lowFlag = nil
end

function BattleOverCommand:execute(notification)
	require "main.config.BattleConfig"
  require "core.utils.ScreenScale"
	require "main.view.battleScene.BattleLayerManager"
	require "main.view.battleScene.BattleOverMediator"
  require "main.view.battleScene.lottery.LotteryMediator"
	require "main.controller.command.battleScene.BattleToLotteryCommand"
	require "main.controller.command.battleScene.CloseLotteryCommand"
	require "main.controller.command.battleScene.CloseBattleOverMediatorCommand"
	require "main.controller.command.battleScene.SendMessageForChargeBoxCommand"

    --战场数据
    self.battleProxy = self:retrieveProxy(BattleProxy.name);
    self.notification=notification;
    if(notification.type == "Handler_7_6") then
        local function startFun()
          self:initDialogUI();
        end
        Tweenlite:delayCallS(1,startFun);
    elseif(notification.type == "BattleDialogOverCommand") then
        self:battleOver();
    elseif(notification.type == "BattleLoadFailedCommand") then
        self.battleProxy:cleanBattleOverData()
        self:onLeave();
    elseif(notification.type == "BattleExitCloseCommand") then
        self.battleProxy:cleanBattleOverData()
        self:onLeave();
    end
end

function BattleOverCommand:initDialogUI()
    if not self.battleProxy.lastAttackData_7_6 then return;end;
    if not self.battleProxy.lastAttackData_7_6.isVictory then
        self:setBattleOverTimeOut()
        return false
    end
    -- if self.battleProxy.battleScriptArr and self.battleProxy.battleScriptArr[6] then -- 有结束脚本就播
    --   self.battleProxy.dialogType = BattleConfig.Battle_Dialog_Leave;
    --   self.battleProxy.battleScriptPlayer:begin(self.battleProxy.battleScriptArr[6])
    -- else
    --   self:setBattleOverTimeOut()
    -- end
    self:setBattleOverTimeOut()
end

---------------
--战场结束
---------------
function BattleOverCommand:battleOver()
  local function setOverTimeOut()
      self:setBattleOverTimeOut()
  end
  Tweenlite:delayCallS(1,setOverTimeOut);
end

function BattleOverCommand:setBattleOverTimeOut()
  local tbl = self.battleProxy.lastAttackData_7_6;
  self.battleProxy.lastAttackData_7_6 = nil
  if not tbl then return;end;
  if not sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_UI) then return;end

  Director.sharedDirector():getScheduler():setTimeScale(1)

  for key,generalVO in pairs(self.battleProxy.battleGeneralArray) do
    if generalVO.battleIcon then
      generalVO.battleIcon:playAndLoop(BattleConfig.ROLE_HOLD);
      generalVO.battleIcon:setStopTimer(true)
    end
  end
  local battleOverMediator = self:retrieveMediator(BattleOverMediator.name);
  if not battleOverMediator then
      battleOverMediator = BattleOverMediator.new()
      self:registerMediator(battleOverMediator:getMediatorName(),battleOverMediator);
      self:registerCommand(BattleSceneNotifications.TO_LOTTERY,BattleToLotteryCommand);
      self:registerCommand(BattleSceneNotifications.CLOSE_LOTTERY_MEDIATOR,CloseLotteryCommand);
      self:registerCommand(BattleSceneNotifications.CLOSE_BATTLEOVER_MEDIATOR,CloseBattleOverMediatorCommand);
      self:registerCommand(BattleSceneNotifications.SEND_MESSAGE_FOR_CHARGE_BOX,SendMessageForChargeBoxCommand);
  end
  battleOverMediator:onInit(tbl,self.battleProxy)
  LayerManager:addLayerPopable(battleOverMediator:getViewComponent());
  log("=========battleOver===================")
  self.battleProxy:cleanBattleOverData()
end

function BattleOverCommand:onLeave(event)
    -- require "main.controller.command.battleScene.WushuangCloseCommond"
    require "main.controller.command.battleScene.CloseLotteryCommand"
    -- self:addSubCommand(WorldBossCloseCommond) 
    self:addSubCommand(CloseLotteryCommand) 
    -- self:addSubCommand(WushuangCloseCommond) 
  	self:addSubCommand(BattleToMainCommand)	
  	self:complete() 
end

