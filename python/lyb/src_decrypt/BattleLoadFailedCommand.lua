

BattleLoadFailedCommand=class(MacroCommand);

function BattleLoadFailedCommand:ctor()
	self.class=BattleLoadFailedCommand;
end

function BattleLoadFailedCommand:execute()
	local scene = Director.sharedDirector():getRunningScene();	
	if  scene.name == GameConfig.BATTLE_SCENE then
		local commonPopup=CommonPopup.new();
	    commonPopup:initialize("进入战斗失败！",self,self.toMainscene,nil,nil,nil,true,nil,nil,true);
	    if sharedBattleLayerManager() and sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_SHIFT_SCENE) then
			sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_SHIFT_SCENE):addChild(commonPopup);
		end
	end
end

function BattleLoadFailedCommand:toMainscene()
	self:addSubCommand(BattleOverCommand)	
  	self:complete({type = "BattleLoadFailedCommand"}) 
end
