
Handler_9_13 = class(Command);

function Handler_9_13:execute()
	local treasureId = recvTable["ID"]
	local treasurePO = analysis("Zangbaotu_Zangbaotujiangli",treasureId);
	if treasurePO.battleId ~= 0 then
		--sharedTextAnimateReward():animateStartByString("不小心遇到宝藏守卫了,勇敢的战斗吧!");
	elseif treasurePO.itemID ~= 0 then
		--local itemName = analysis("Daoju_Daojubiao",treasurePO.ItemId,"name");
		local popup=CommonPopup.new();
		if treasurePO.itemID < 100 then
	    	popup:initialize('<content><font color="#FFFFFF">你小心翼翼的打开宝藏意外</font>'..StringUtils:getString4Popup(PopupMessageConstConfig.ID_2,{treasurePO.number,treasurePO.itemID}),self,nil,nil,nil,nil,true,{"确定"},true,true);
	    else
	    	popup:initialize('<content><font color="#FFFFFF">你小心翼翼的打开宝藏意外</font>'..StringUtils:getString4Popup(PopupMessageConstConfig.ID_1,{treasurePO.itemID,treasurePO.number}),self,nil,nil,nil,nil,true,{"确定"},true,true);
	    end
	    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(popup)
	else--if treasurePO.itemID == 0 then
		local popup=CommonPopup.new();
	    popup:initialize("现场一片狼藉看来宝藏已经被人挖走了。。。",self,nil,nil,nil,nil,true,nil,nil,true);
	    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(popup)
	end
	--local bagProxy=self:retrieveProxy(BagProxy.name);
    --bagProxy:setStrongPointId(nil);
end

Handler_9_13.new():execute();