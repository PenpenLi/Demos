-------------------------
--BattleInitCommand handler_7_5 handler_7_12
-------------------------

BattleEffectCommand=class(Command);

function BattleEffectCommand:ctor()
	self.class=BattleEffectCommand;
	self.battleProxy = nil;
end

function BattleEffectCommand:execute(notification)
	require "main.config.BattleConfig"
	require "main.view.battleScene.BattleLayerManager"
  --战场数据
    self.battleProxy = self:retrieveProxy(BattleProxy.name);
    --self:addEffect();
    --self:removeEffect();
    if(notification.type == "Handler_7_5") then
        self:addEffect(notification["untilID"]);
    elseif(notification.type == "Handler_7_12") then
        self:removeEffect(notification["untilID"]);
    end
    
end

---------------
--添加效果
---------------
function BattleEffectCommand:addEffect(playerUnitID)
      local aiEngin = self.battleProxy.aiEnginMap[playerUnitID];
      local roleVO = self.battleProxy.battleGeneralArray[playerUnitID];
      aiEngin:addEffectAction(roleVO);
end

---------------
--去除效果
---------------
function BattleEffectCommand:removeEffect(playerUnitID)
      local aiEngin = self.battleProxy.aiEnginMap[playerUnitID];
      aiEngin:removeEffectAction();
end
