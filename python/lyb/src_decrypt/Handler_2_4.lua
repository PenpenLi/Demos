

Handler_2_4 = class(MacroCommand);

 
function Handler_2_4:heartHitBack()

	logoutSuccess(GameConfig.CONNECT_TYPE_3)	

end
 
function Handler_2_4:closeGame()
	if GameData.platFormID == GameConfig.PLATFORM_CODE_UC then
		UCExit();
	end
	Director:sharedDirector():endGame();
end
function Handler_2_4:execute()
	GameData.isConnect = false
	GameData.isConnecting = true
	GameData.isKickByOther = true
	
	uninitializeSmallLoading()
	
	local quitStr = StringUtils:getString4Popup(PopupMessageConstConfig.ID_231)
	local textTable = StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_231)
		
	local tips=CommonPopup.new();
	tips:initialize(quitStr,self,self.heartHitBack,nil,self.closeGame,nil,nil,textTable,nil,true,CommonPopupCloseButtonPram.CANCLE);

	commonAddToScene(tips, true)	
	if BattleSceneMediator then
	    local battleMediator = self:retrieveMediator(BattleSceneMediator.name);  
	    if battleMediator then
	    	battleMediator:stopAllNodeAction()
	    end

	    local battleProxy = self:retrieveProxy(BattleProxy.name)
	    if battleProxy then
	    	battleProxy:cleanAIBattle()
	    end
    end
 end

Handler_2_4.new():execute();