--require "main.controller.command.data.dataInitialize.DataInitialize"

Handler_2_1 = class(MacroCommand);

function Handler_2_1:execute()
    local userState = recvTable["LoginState"];
    if 7 == recvTable["LoginState"] then
    	sharedTextAnimateReward():animateStartByString("讨厌!这个名字不好啦!换一个啦!");
    	return;
    end
    self:onExecuteComplete(userState);
    require "main.view.serverMerge.ServerMergeMediator";
    self:removeMediator(ServerMergeMediator.name);
end

local function dataInitialize()

	require "main.controller.command.data.dataInitialize.DataInitializeCommand1"
	require "main.controller.command.data.dataInitialize.DataInitializeCommand2"
	require "main.controller.command.data.dataInitialize.DataInitializeCommand3"
	require "main.controller.command.data.dataInitialize.DataInitializeCommand4"
	require "main.controller.command.data.dataInitialize.DataInitializeCommand5"

    DataInitializeCommand1.new():execute();
    DataInitializeCommand2.new():execute();
    DataInitializeCommand3.new():execute();
    DataInitializeCommand4.new():execute();
    DataInitializeCommand5.new():execute();
end

function Handler_2_1:videoBackFun()
	hecDC(2,42)
end

function Handler_2_1:onExecuteComplete(userState)

	    GameData.isConnect = true
        GameData.isConnecting = false
	    GameData.isKickByOther = false
        local userProxy = self:retrieveProxy(UserProxy.name);
        userProxy.userState = userState;
		GameData.userState = userState

        if userState == 0 then  -- 新用户

            uninitializeSmallLoading();
 	    	dataInitialize()
			hecDC(2,41)
			
			MusicUtils:playVideo(1,self)
            
            require "main.controller.command.mainScene.ToCteateRoleCommand"
            ToCteateRoleCommand.new():execute()

        elseif userState == 1 then -- 无用
          
        elseif userState == 2 then -- 老用户
        	
        	dataInitialize()
            sendMessage(2,7)
        
			local data = {data={}};
		    self:addSubCommand(BeginLoadingSceneCommand)
			self:complete(data)		
        elseif userState == 3 then --用户没登录

        elseif userState == 4 then  --代表用户Id被封
        	local quitStr = StringUtils:getString4Popup(PopupMessageConstConfig.ID_256)
			local text_table = StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_256)        
			local tips=CommonPopup.new();
			tips:initialize(quitStr,self,nil,nil,nil,nil,true,text_table,nil,true);
			commonAddToScene(tips)			
        elseif userState == 5 then   -- 合服  新名字验证不过
			
        end
end

Handler_2_1.new():execute();