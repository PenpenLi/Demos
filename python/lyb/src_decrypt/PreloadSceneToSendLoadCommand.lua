--require "core.net.SocketManager"
  
  PreloadSceneToSendLoadCommand = class(Command);

  function PreloadSceneToSendLoadCommand:ctor()
    self.class = PreloadSceneToSendLoadCommand;
  end

  function PreloadSceneToSendLoadCommand:execute(notification)
    
	--local tableData = notification.data
	--GameData.userAccount = tableData["Key"]
	--sendMessage(2,1,tableData)
  end
