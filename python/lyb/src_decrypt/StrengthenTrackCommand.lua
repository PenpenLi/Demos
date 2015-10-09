
StrengthenTrackCommand=class(MacroCommand);

function StrengthenTrackCommand:ctor()
	self.class=StrengthenTrackCommand;
end

function StrengthenTrackCommand:execute(notification)
  local a,b=self:getTrackStrongPointID(notification:getData().ItemId);
  print("+++",a,b);
  local openFunctionProxy=self:retrieveProxy(OpenFunctionProxy.name);
  if 1==a then
    local id=self:getID();
    if nil==id then
      sharedTextAnimateReward():animateStartByString("关卡尚未开启哦~");
    else
      local data={eventType=GameConfig.TASK_EVENT_TYPE_1,eventValue=id,eventParamType=GameConfig.STRONGPOINT_PARAM_TYPE_2};
      self:addSubCommand(AutoGuideCommand);
      self:complete(MainSceneNotification.new("",data));
    end
  elseif 2==a then
    if openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_74) then
      self:addSubCommand(OpenFunctionUICommand);
      self:complete(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,FunctionConfig.FUNCTION_ID_74));
      
      local teamShadowMediator=self:retrieveMediator(TeamShadowMediator.name);
      teamShadowMediator:createRoomAuto();

      local createRoomMediator=self:retrieveMediator(CreateShadowRoomMediator.name);
      createRoomMediator:createRoomAuto(b);

      return;
    end
    self:getFunctionOpen();
  elseif 3==a then
    if openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_65) then
      self:retrieveProxy(TowerProxy.name):setTrack(b);
      self:addSubCommand(OpenFunctionUICommand);
      self:complete(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,FunctionConfig.FUNCTION_ID_65));
      return;
    end
    self:getFunctionOpen();
  end  
end

function StrengthenTrackCommand:getFunctionOpen()
  local commonPopup=CommonPopup.new();
  commonPopup:initialize("功能尚未开启哦~",nil,nil,nil,nil,nil,true);
  sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(commonPopup);
end

function StrengthenTrackCommand:getTrackStrongPointID(itemID)
  local generalListProxy=self:retrieveProxy(GeneralListProxy.name);
  local level=generalListProxy:getLevel();
  -- local a=1;

  local diaoluoTable=analysisTotalTable("Diaoluo_Putongdiaoluo");
  table.remove(diaoluoTable,1);

  for k,v in pairs(diaoluoTable) do
    if itemID==v.itemId then

      local c=v.page;
      local d=v.floor;
      if 0~=c then
        return 2,c;
      elseif 0~=d then
        return 3,d;
      end
    end

  end

  return 1;
end

function StrengthenTrackCommand:getID(itemID)
  local lastStrongPointId=self:retrieveProxy(StrongPointInfoProxy.name).lastStrongPointId;
  local minLv=analysis("Diaoluo_Guankaquanjudiaoluo",itemID,"minLv");
  local maxLv=analysis("Diaoluo_Guankaquanjudiaoluo",itemID,"maxLv");
  while analysisHas("Juqing_Guanka",lastStrongPointId) do
    local sort=analysis("Juqing_Guanka",lastStrongPointId,"sort");
    local lv=analysis("Juqing_Guanka",lastStrongPointId,"lv");
    if not sort and 0~=sort and minLv<=lv and maxLv>=lv then
      return lastStrongPointId;
    end
    lastStrongPointId=-1+lastStrongPointId;
  end
end