-------------------------
--BattleInitCommand handler_7_15 handler_7_16
-------------------------

ScriptToMainsceneCommand=class(MacroCommand);

function ScriptToMainsceneCommand:ctor()
	self.class=ScriptToMainsceneCommand;
end

--------------------------
--角色移动数据
--------------------------
function ScriptToMainsceneCommand:execute(skipBool)

    ScreenShake:dispose();
    ScreenScale:dispose();
    sharedTextAnimateReward():disposeTextAnimateReward()
    BitmapCacher:deleteTextureMap(GameData.deleteBattleTextureMap)
    GameData.deleteBattleTextureMap = {};
    local function blackFadeInBackFun()
            sharedBattleLayerManager():disposeBattleLayerManager()
            self:removeMediator(BattleSceneMediator.name)
            require "main.view.preloadScene.PreloadSceneMediator";
            local preLoadSceneMediator = self:retrieveMediator(PreloadSceneMediator.name)
            if not preLoadSceneMediator then
            preLoadSceneMediator = PreloadSceneMediator.new();
            self:registerMediator(preLoadSceneMediator:getMediatorName(),preLoadSceneMediator);
            end
            Director:sharedDirector():replaceScene(preLoadSceneMediator:getViewComponent());
            require "main.controller.command.mainScene.ToCteateRoleCommand"
            self:addSubCommand(ToCteateRoleCommand);
            local data = {data={type = GameConfig.SCENE_TYPE_3}};
            self:complete(data)
    end

    if skipBool then
        blackFadeInBackFun()
    else
        blackFadeIn(blackFadeInBackFun,1,nil,nil,nil)
    end

end
