--[[
	同步设置数据
	zhangke
]]

Handler_3_22 = class(MacroCommand);

function Handler_3_22:execute()

	local operatonProxy = self:retrieveProxy(OperationProxy.name);
	if not operatonProxy then
		operatonProxy = OperationProxy.new();
		self:registerProxy(operatonProxy.class.name,operatonProxy);
	end
	
	operatonProxy:setData(recvTable["IDArray"]);
	
	-- local titleNameTable = {"打开背景音乐","","显示其他玩家","显示称号","手动无双(vip3以上自动)","自动拒绝切磋"}
	
	-- local IDTable = {}
	-- local dataTable = recvTable["IDArray"]
	-- if dataTable then
	--     for kd,vd in pairs(dataTable) do
	--         IDTable[vd["ID"]] = vd["ID"]
	--     end
	-- end
	-- local localData = {}
	-- local oldLocal = {}
	-- for i = 1,5 do
	-- 	-- 音效没了，暂时特殊处理，回头加设置加到2这里
	-- 	if i > 1 then
	-- 		i = i + 1
	-- 	end

	--     local value
	-- 	if IDTable[i] then
	-- 		value = true
	-- 	else
	-- 		value = false
	-- 	end
				
	-- 	localData[i] = {id = i,title = titleNameTable[i],value = value}
	-- 	oldLocal[i] = {id = i,title = titleNameTable[i],value = value}
	-- 	if i == 1 then
	-- 	    GameData.isMusicOn = value
	-- 	    GameData.isPlaySoundEffect = value
	-- 	elseif i == 2 then
	-- 		-- GameData.isPlaySoundEffect = value
	-- 	elseif i == 4 then 
	-- 		GameData.isShowPlayerTitle = value
	-- 	elseif i == 6 then
	-- 		print("DUEL VALUE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",value)
	-- 		GameData.autoRejectDuel = value;
	-- 	end
	-- end
	
	-- operatonProxy.operationData = localData
	-- operatonProxy.oldOperationData = oldLocal
	
end

Handler_3_22.new():execute();