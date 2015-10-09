
Handler_2_6 = class(Command);

function Handler_2_6:backToMain()
	
	Director:sharedDirector():endGame();
	
end
	
function Handler_2_6:execute()
	
	GameData.isConnect = false;
	GameData.isConnecting = true;
	
	local popup=CommonPopup.new();
	popup:initialize("服务器进入维护阶段,请关注游戏公告,稍后重新登录!",self,self.backToMain,nil,nil,nil,true,nil,nil,true,CommonPopupCloseButtonPram.CONFIRM);

	commonAddToScene(popup, true)

	-- 3秒后自动关闭
	local _loopFunction
	local function endGame()
		if _loopFunction then
			Director:sharedDirector():getScheduler():unscheduleScriptEntry(_loopFunction)
		end		
		Director:sharedDirector():endGame();
	end
	_loopFunction = Director:sharedDirector():getScheduler():scheduleScriptFunc(_endGame, 3, false)
end

Handler_2_6.new():execute();