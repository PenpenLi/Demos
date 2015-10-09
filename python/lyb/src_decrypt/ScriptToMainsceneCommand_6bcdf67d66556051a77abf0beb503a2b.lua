
ScriptToMainsceneCommand=class(MacroCommand);

function ScriptToMainsceneCommand:ctor()
	self.class=ScriptToMainsceneCommand;
end

function ScriptToMainsceneCommand:execute(skipBool)
    -- local function blackFadeInBackFun()
        -- ScreenShake:dispose();
        -- sharedTextAnimateReward():disposeTextAnimateReward()
        BitmapCacher:deleteTextureMap(GameData.deleteBattleTextureMap)
        GameData.deleteBattleTextureMap = {};
        -- sharedBattleLayerManager():disposeBattleLayerManager()
        -- self:removeMediator(BattleSceneMediator.name)
        sendServerTutorMsg({Stage = TutorConfig.STAGE_1002})
        -- if connectBoo then
        --     sendMessage(2,7)
        -- end
    -- end
    local function blackFadeInBackFun()
        self:addSubCommand(BattleToMainCommand) 
        self:complete() 
    end
    Tweenlite:delayCallS(0,blackFadeInBackFun);
end
