

BattleUnitDeadCommand=class(MacroCommand);

function BattleUnitDeadCommand:ctor()
	self.class=BattleUnitDeadCommand;
end

function BattleUnitDeadCommand:execute(notification)
    self.battleProxy = self:retrieveProxy(BattleProxy.name);
    self:roleDead(notification.data.unitID)
end

function BattleUnitDeadCommand:roleDead(battleUnitID)
    --self:checkMainPlayerDead(battleUnitID)
    self:remveMonsterAndPlayer(battleUnitID);
end

-- function BattleUnitDeadCommand:checkMainPlayerDead(battleUnitID)
--     if not self.battleProxy.hasZhuJue then 
--         local roleVO = self.battleProxy.battleGeneralArray[battleUnitID]
--         if roleVO.isMainPlayer then
--             local heroVO = self.battleProxy:getClientMainUnit()
--             ScreenMove:setTargetPlayer(heroVO.battleIcon)
--         end
--     end
-- end

function BattleUnitDeadCommand:remveMonsterAndPlayer(battleUnitID)
    local roleVO = self.battleProxy.battleGeneralArray[battleUnitID]
    if not roleVO.battleIcon then return end
    if not roleVO.battleIcon.sprite then return;end;
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS):removeChild(roleVO.battleIcon);
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_MAP):removeChild(roleVO.roleShadow); 
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_MAP).shadowBatchLayer:removeChild(roleVO.roleShadow); 
    self.battleProxy:deleteAiEngin(battleUnitID);
end
