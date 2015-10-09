--[[
    随机无双技能
  ]]
require "main.view.battleScene.wushuang.WushuangMediator"
Handler_7_21 = class(MacroCommand)

function Handler_7_21:execute()
	local battleProxy = self:retrieveProxy(BattleProxy.name)
	local userProxy = self:retrieveProxy(UserProxy.name)
	local battleUnitID
    local yinghunId
    local skillId
    if not battleProxy.handlerType then
        battleUnitID = recvTable["BattleUnitID"];
		yinghunId = recvTable["ConfigId"];
		skillId = recvTable["SkillId"];
    elseif battleProxy.handlerType == "BattlePlaybackCommond" then
        local handlerData = battleProxy.handlerData;
        battleUnitID = handlerData.BattleUnitID
		yinghunId = handlerData.ConfigId
		skillId = handlerData.SkillId
		battleProxy.handlerData = nil;
        battleProxy.handlerType = nil;
        package.loaded["main.controller.handler.Handler_7_21"] = nil
    end
    
	local wushuangMediator = self:retrieveMediator(WushuangMediator.name)
	if not wushuangMediator then
		wushuangMediator = WushuangMediator.new()
		self:registerMediator(WushuangMediator.name,wushuangMediator)
	end
	require "main.controller.command.battleScene.WushuangCloseCommond"
  	self:registerCommand(BattleSceneNotifications.BATTLE_WUSHUANG_CLOSE,WushuangCloseCommond);
	wushuangMediator:initUI(battleProxy,userProxy)	
	sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_UI):addChild(wushuangMediator:getViewComponent());

end

Handler_7_21.new():execute();