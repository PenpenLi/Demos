--[[
	切换场景
]]

ReplaceSceneCommand=class(Command);

function ReplaceSceneCommand:ctor()
	self.class=ReplaceSceneCommand;
end

function ReplaceSceneCommand:execute()

        local mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);
        GameData.isPopQuitPanel = false
        Director:sharedDirector():replaceScene(mainSceneMediator:getViewComponent());
end