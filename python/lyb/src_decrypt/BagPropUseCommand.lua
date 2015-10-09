BagPropUseCommand=class(MacroCommand);

function BagPropUseCommand:ctor()
	self.class=BagPropUseCommand;
end

function BagPropUseCommand:execute(notification)
  print("bagPropUse",notification:getData().ItemId);
  --if BagConstConfig.USE_ID_8==analysis("Daoju_Daojugongneng",analysis("Daoju_Daojubiao",notification:getData().ItemId,"functionID"),"use") then
  if 1==analysis("Daoju_Daojugongneng",analysis("Daoju_Daojubiao",notification:getData().ItemId,"functionID"),"synthesis") then
    local syntheticItemID=analysis("Daoju_Daojubiao",notification:getData().ItemId,"parameter3");
    money=analysis("Daoju_Hecheng",syntheticItemID,"money");
    if ""==money then

    else
      money=StringUtils:stuff_string_split(money);
      money=money[1];
      if self:retrieveProxy(UserCurrencyProxy.name):getMoneyByItemID(tonumber(money[1]))<tonumber(money[2]) then
        if 2==tonumber(money[1]) then
          sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_20));
        elseif 3==tonumber(money[1]) then
          sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_18));
        end
        return;
      end
    end
  elseif BagConstConfig.USE_ID_11==analysis("Daoju_Daojugongneng",analysis("Daoju_Daojubiao",notification:getData().ItemId,"functionID"),"use") and self:retrieveProxy(PetBankProxy.name):getIsFull() then
  	sharedTextAnimateReward():animateStartByString("宠物包包已经满了喔 !");
  	return;
  elseif 1002==math.floor(notification:getData().ItemId/1000) and analysis("Daoju_Daojubiao",notification:getData().ItemId,"parameter2")>self:retrieveProxy(UserProxy.name):getLevel() then
    local function confirmBack()
      self:addSubCommand(OpenFunctionUICommand);
      self:complete(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,{ID=FunctionConfig.FUNCTION_ID_103,TYPE_ID=2}));
    end
    local commonPopup=CommonPopup.new();
    commonPopup:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_123,{analysis("Daoju_Daojubiao",notification:getData().ItemId,"parameter2")}),self,confirmBack,nil,nil,nil,false,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_123),nil,true);
    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(commonPopup);
    return;
  end
  if(connectBoo) then
    sendMessage(9,4,notification:getData());
  end
end