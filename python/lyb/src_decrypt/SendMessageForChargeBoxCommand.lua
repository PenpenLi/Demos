-------------------------
-- SendMessageForChargeBoxCommand
-------------------------

SendMessageForChargeBoxCommand=class(Command);

function SendMessageForChargeBoxCommand:ctor()
	self.class=SendMessageForChargeBoxCommand;
end

function SendMessageForChargeBoxCommand:execute(notification)
	local bagProxy = self:retrieveProxy(BagProxy.name)
	local itemUseQueueProxy = self:retrieveProxy(ItemUseQueueProxy.name)
	local leftCount = bagProxy:getBagLeftPlaceCount(itemUseQueueProxy)
		
	local message = notification.data
	local itemID = message.itemID
	local Position = message.Position
	local booleanValue = message.BooleanValue
	
	local battleProxy = self:retrieveProxy(BattleProxy.name)
		
	local functionID = analysis("Daoju_Daojubiao",itemID,"functionID")
	-- 如果是货币 英魂，英魂碎片之类的不用判断背包数量直接发命令
	if functionID == 0
	or functionID == 10
	or functionID == 13
	or booleanValue == 0 then
		battleProxy.boxIndex = Position
		sendMessage(18,2,message)
	else
		if leftCount > 0 then
			battleProxy.boxIndex = Position
			sendMessage(18,2,message)
		else			
			local tips=CommonPopup.new();
			tips:initialize("背包已满!",nil,nil,nil,nil,nil,true);
			sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_SHIFT_SCENE):addChild(tips);	
			return			
		end
	end
	
end
