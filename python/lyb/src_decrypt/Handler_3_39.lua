

Handler_3_39 = class(MacroCommand);

function Handler_3_39:execute()
	local bool = recvTable["BooleanValue"]
	if bool == 1 then return end
	local scene = Director.sharedDirector():getRunningScene();	
	if  scene.name == GameConfig.BATTLE_SCENE then
		local commonPopup=CommonPopup.new();
	    commonPopup:initialize("战斗已经结束啦~",self,self.toMainscene,nil,nil,nil,true,nil,nil,true);
	    if sharedBattleLayerManager() and sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_SHIFT_SCENE) then
			sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_SHIFT_SCENE):addChild(commonPopup);
		end
	end
end

function Handler_3_39:toMainscene()
	self:addSubCommand(BattleOverCommand)	
  	self:complete({type = "BattleLoadFailedCommand"}) 
end


Handler_3_39.new():execute();