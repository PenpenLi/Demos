

Handler_2_2 = class(MacroCommand);

function Handler_2_2:execute()

	hecDC(2,44)

	GameVar.tutorStage = TutorConfig.STAGE_1001;
	sendServerTutorMsg({Stage = TutorConfig.STAGE_1001})

	platformCreateRole(GameData.ServerId,GameData.platFormUserId,GameData.userName,1)

	if GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_TONGBUTUI then
		hecDC(8)
	end	
	--todo by jiasq
	-- GameVar.tutorStage = TutorConfig.STAGE_1002;
	-- sendServerTutorMsg({Stage = TutorConfig.STAGE_1002})
	if connectBoo then
	  sendMessage(2,7)
	end

end

Handler_2_2.new():execute();