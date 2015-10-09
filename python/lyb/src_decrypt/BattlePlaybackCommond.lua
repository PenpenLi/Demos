BattlePlaybackCommond=class(MacroCommand);

function BattlePlaybackCommond:ctor()
	self.class=BattlePlaybackCommond;
end

function BattlePlaybackCommond:execute()
	package.loaded["main.controller.handler.Handler_7_24"] = nil
	package.loaded["main.controller.handler.Handler_7_15"] = nil
	package.loaded["main.controller.handler.Handler_7_16"] = nil
	package.loaded["main.controller.handler.Handler_7_19"] = nil
	package.loaded["main.controller.handler.Handler_7_21"] = nil
	package.loaded["main.controller.handler.Handler_7_4"] = nil
	package.loaded["main.controller.handler.Handler_7_12"] = nil
	local battleProxy = self:retrieveProxy(BattleProxy.name)
	local function playbackFun(playData)
		battleProxy.handlerData = playData;
		battleProxy.handlerType = "BattlePlaybackCommond";
		if playData.SubType == 24 then
			require "main.controller.handler.Handler_7_24";
		elseif playData.SubType == 15 then
			require "main.controller.handler.Handler_7_15";
		elseif playData.SubType == 16 then
			require "main.controller.handler.Handler_7_16";
		elseif playData.SubType == 19 then
			require "main.controller.handler.Handler_7_19";
		elseif playData.SubType == 21 then
			require "main.controller.handler.Handler_7_21";
		elseif playData.SubType == 4 then
			require "main.controller.handler.Handler_7_4";
		elseif playData.SubType == 12 then
			require "main.controller.handler.Handler_7_12";
		elseif playData.SubType == 7 then
			require "main.controller.command.battleScene.BattlePvpFiveCloseCommand"
			self:addSubCommand(BattlePvpFiveCloseCommand)	
  			self:complete()
		end
	end
	battleProxy:startPlayBack(playbackFun)
end
