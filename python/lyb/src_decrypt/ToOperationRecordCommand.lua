
ToOperationRecordCommand=class(Command);

function ToOperationRecordCommand:ctor()
	self.class=ToOperationRecordCommand;
end

function ToOperationRecordCommand:execute(notification)
	local operaionProxy = self:retrieveProxy(OperationProxy.name);
	if notification.data then  -- 操作
		local operationMediator = self:retrieveMediator(OperationMediator.name);
		if(operationMediator == nil) then
			operationMediator = OperationMediator.new()
			self:registerMediator(operationMediator:getMediatorName(),operationMediator);
			self:registerCommand(MainSceneNotifications.TO_OPERATION_RECORD, ToOperationRecordCommand);
		end	
		local id = notification.data.id
		-- 音效没了，暂时特殊处理，回头加设置加到2这里
		-- if id > 1 then 
		-- 	id = id + 1
		-- end

		local display = notification.data.display
		local value = not display.isOn
		local operationData = operaionProxy.operationData
		if operationData then
			for k,v in pairs(operationData) do
				if k == id then
					v.value = value
				end
			end
		end

		operationMediator:refreshData(display)
		
		-- 写死的设置的处理
		if id == 1 then -- 音乐
			if value then
				local musicID
				local userProxy = self:retrieveProxy(UserProxy.name)
				if userProxy.sceneType ==  GameConfig.SCENE_TYPE_2 then
					local storyLineTable = analysis("Juqing_Juqing", userProxy["storyLineId"]);
					musicID = storyLineTable.music;
				end
				MusicUtils:play(musicID,true);
				-- MusicUtils:resume()
			else
				MusicUtils:stop(true);
				-- MusicUtils:pause()
			end
			-- GameData.isPlaySoundEffect = value
		elseif id == 2 then -- 音效
			-- GameData.isPlaySoundEffect = value
		
		elseif id == 3 then -- 屏蔽其他玩家
			local mainMediator = self:retrieveMediator(MainSceneMediator.name)
			local userProxy = self:retrieveProxy(UserProxy.name)
			local petBankProxy = self:retrieveProxy(PetBankProxy.name);
			mainMediator:visibleOtherPlayer(value,userProxy.userId, petBankProxy:getConfigID())
		elseif id == 4 then -- 屏蔽称号
			GameData.isShowPlayerTitle = value;
			local mainMediator = self:retrieveMediator(MainSceneMediator.name)
			mainMediator:visiblePlayerTitle(value);
		elseif id == 6 then -- 自动拒绝切磋
			GameData.autoRejectDuel = value;
		end
		
	else -- 关闭界面
		local sendMsg = {}
		local operationData = operaionProxy.operationData
		local oldOperationData = operaionProxy.oldOperationData

		if operationData then
			for k,v in pairs(operationData) do
				if v.value ~= oldOperationData[k].value then
					table.insert(sendMsg,{ID=k})
					operaionProxy.oldOperationData[k].value = not operaionProxy.oldOperationData[k].value
							
                    if k == 1 then
		                GameData.isMusicOn = v.value
		            end
				end
			end			
		end
	end
end
