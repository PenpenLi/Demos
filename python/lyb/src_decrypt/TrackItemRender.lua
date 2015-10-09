-------------------------------------------------------------------------
--  Class include: TrackItemRender
-------------------------------------------------------------------------

TrackItemRender = class(TouchLayer);
function TrackItemRender:ctor()
	self.class = TrackItemRender;  
end

function TrackItemRender:dispose()
    self:removeAllEventListeners();
    self:removeChildren();
    TrackItemRender.superclass.dispose(self);
end
----------------
--center
----------------
function TrackItemRender:initialize(context, data)
  self.context = context;
  self:initLayer();


  self.data = data;

  local common_item_bg_1 = CommonPanelSkeleton:getBoneTextureDisplay("commonPanels/common_item_bg_1")

  self:addChild(common_item_bg_1)
  common_item_bg_1:setScale(0.72)

  local armature= self.context.skeleton:buildArmature("trackItem_render");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;
  self:addChild(armature_d);

  self:setContentSize(armature_d:getGroupBounds(false).size);

  local alertInfo_bg = self.context.skeleton:getBoneTextureDisplay("alertInfo_bg")
  armature_d:addChildAt(alertInfo_bg, 1)
  alertInfo_bg:setPositionXY(14, 65)

  local alertInfo_txtTextData = armature:getBone("alertInfo_txt").textData;
  self.alertInfo_txt = createTextFieldWithTextData(alertInfo_txtTextData, "");
  armature_d:addChild(self.alertInfo_txt);

  local strongPointName_txtTextData = armature:getBone("strongPointName_txt").textData;
  self.strongPointName_txt = createStrokeTextFieldWithTextData(strongPointName_txtTextData, "");
  armature_d:addChild(self.strongPointName_txt);


  local action_txtTextData = armature:getBone("action_txt").textData;
  self.action_txt = createStrokeTextFieldWithTextData(action_txtTextData, "点击前往");
  self.action_txt.touchEnabled = false;
  armature_d:addChild(self.action_txt);

  local common_copy_mingzi_bg = armature_d:getChildByName("common_copy_mingzi_bg");

  local actionStr = ""

  local functionIcon = Image.new();

  if data.type == 1 then

    local tempStrongPointPo = analysis("Juqing_Guanka",data.value)
    if self.context.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_39) and data.state == 1 and self.context.storyLineProxy:getStrongPointStarCount(data.value) == 3 then
      common_copy_mingzi_bg:addEventListener(DisplayEvents.kTouchTap,self.onPanelTap,self);
      self.action_txt:setString("点击扫荡");
      self.data.quickBattle = true;
    elseif data.state == 3 or  data.state == 1 then
      self.data.quickBattle = false;
      common_copy_mingzi_bg:addEventListener(DisplayEvents.kTouchTap,self.onPanelTap,self);
    else
      common_copy_mingzi_bg:setVisible(false)
      self.action_txt:setString("未开启");
      self.action_txt:setColor(CommonUtils:ccc3FromUInt(16711680));
    end
    functionIconId = analysis("Gongnengkaiqi_Gongnengkaiqi", FunctionConfig.FUNCTION_ID_24, "icon")
    local storyLinePo = analysis("Juqing_Juqing", tempStrongPointPo.storyId);
    if tempStrongPointPo then
      self.alertInfo_txt:setString("第".. storyLinePo.zhangjie .. "章:" .. tempStrongPointPo.scenarioName .. "掉落"); 

      -- local count = data.count and data.count or 0;
      -- self.strongPointName_txt:setString("")--"(" .. (tempStrongPointPo.cishu - count) .. "/" .. tempStrongPointPo.cishu .. ")"
    end
  elseif data.type == 2 then
  	print("data.type == 2  data.value", data.value)
    local tempStrongPointPo = analysis("Juqing_Guanka",data.value)
  	self.alertInfo_txt:setString("英雄志" .. tempStrongPointPo.scenarioName .. "掉落");
    local tempStrongPointPo = analysis("Juqing_Guanka",data.value)

    local count = data.count and data.count or 0;
  	self.strongPointName_txt:setString("(" .. (tempStrongPointPo.cishu - count) .. "/" .. tempStrongPointPo.cishu .. ")")
  	
    if self.context.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_39) and data.state == 1 and self.context.storyLineProxy:getStrongPointStarCount(data.value) == 3 then
      self.data.quickBattle = true;
      self.action_txt:setString("点击扫荡");
      common_copy_mingzi_bg:addEventListener(DisplayEvents.kTouchTap,self.onPanelTap,self);
      self.strongPointName_txt:setVisible(true)
    elseif data.state == 3 or data.state == 1 then
      self.data.quickBattle = false;
      common_copy_mingzi_bg:addEventListener(DisplayEvents.kTouchTap,self.onPanelTap,self);
      self.strongPointName_txt:setVisible(true)
    else
      common_copy_mingzi_bg:setVisible(false)
      self.action_txt:setString("未开启");    
      self.action_txt:setColor(CommonUtils:ccc3FromUInt(16711680));
      self.strongPointName_txt:setVisible(false)
    end
    functionIconId = analysis("Gongnengkaiqi_Gongnengkaiqi", FunctionConfig.FUNCTION_ID_22, "icon")
  elseif data.type == 3 then
    self.alertInfo_txt:setString("寻宝可获得");
    self.strongPointName_txt:setVisible(false);
    functionIconId = analysis("Gongnengkaiqi_Gongnengkaiqi", FunctionConfig.FUNCTION_ID_44, "icon")

    if self.context.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_44) then
      common_copy_mingzi_bg:addEventListener(DisplayEvents.kTouchTap,self.onPanelTap,self);
    else
      self.action_txt:setString("暂未开启");
      self.action_txt:setColor(CommonUtils:ccc3FromUInt(16711680));
    end
  elseif data.type == 5 then
    functionIconId = analysis("Gongnengkaiqi_Gongnengkaiqi", FunctionConfig.FUNCTION_ID_3, "icon")
    self.alertInfo_txt:setString("荣誉商店可兑换");
    if self.context.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_26) then
      common_copy_mingzi_bg:addEventListener(DisplayEvents.kTouchTap,self.onPanelTap,self);
    else
      self.action_txt:setString("暂未开启");
      self.action_txt:setColor(CommonUtils:ccc3FromUInt(16711680));
    end
  elseif data.type == 6 then
    self.alertInfo_txt:setString("帮派商店可兑换");
    functionIconId = analysis("Gongnengkaiqi_Gongnengkaiqi", FunctionConfig.FUNCTION_ID_3, "icon")

    if self.context.userProxy.familyId == 0 then
      self.action_txt:setString("暂无帮派");
      self.action_txt:setColor(CommonUtils:ccc3FromUInt(16711680));
    else
      common_copy_mingzi_bg:addEventListener(DisplayEvents.kTouchTap,self.onPanelTap,self);
    end
  elseif data.type == 7 then
    functionIconId = analysis("Gongnengkaiqi_Gongnengkaiqi", FunctionConfig.FUNCTION_ID_3, "icon")
    self.alertInfo_txt:setString("国库可兑换");
    if self.context.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_35) then
      common_copy_mingzi_bg:addEventListener(DisplayEvents.kTouchTap,self.onPanelTap,self); 
    else
      self.action_txt:setString("暂未开启");
      self.action_txt:setColor(CommonUtils:ccc3FromUInt(16711680));
    end
  elseif data.type == 8 then
    self.alertInfo_txt:setString("使用令牌召唤可获得");
    common_copy_mingzi_bg:addEventListener(DisplayEvents.kTouchTap,self.onPanelTap,self);

    functionIconId = analysis("Gongnengkaiqi_Gongnengkaiqi", FunctionConfig.FUNCTION_ID_12, "icon")
  elseif data.type == 9 then--十国
    functionIconId = analysis("Gongnengkaiqi_Gongnengkaiqi", FunctionConfig.FUNCTION_ID_34, "icon")
    self.alertInfo_txt:setString("通关征战可获得");
    if self.context.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_34) then
      sendMessage(19,17)
      Facade.getInstance():registerCommand(FactionNotifications.TO_TEN_COUNTRY,ToTenCountryCommand);

      common_copy_mingzi_bg:addEventListener(DisplayEvents.kTouchTap,self.onPanelTap,self);
    else
      self.action_txt:setString("暂未开启");
      self.action_txt:setColor(CommonUtils:ccc3FromUInt(16711680));
    end
  elseif data.type == 10 then--试炼
    self.alertInfo_txt:setString("琅琊试炼可获得");
    functionIconId = analysis("Gongnengkaiqi_Gongnengkaiqi", FunctionConfig.FUNCTION_ID_34, "icon")
    if self.context.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_34) then
      common_copy_mingzi_bg:addEventListener(DisplayEvents.kTouchTap,self.onPanelTap,self);
    else
      self.action_txt:setString("暂未开启");
      self.action_txt:setColor(CommonUtils:ccc3FromUInt(16711680));
    end
  elseif data.type == 11 then--日常
    self.alertInfo_txt:setString("日常任务可获得");
    common_copy_mingzi_bg:addEventListener(DisplayEvents.kTouchTap,self.onPanelTap,self);
    functionIconId = analysis("Gongnengkaiqi_Gongnengkaiqi", FunctionConfig.FUNCTION_ID_8, "icon")  
    
    if self.context.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_28) then
      common_copy_mingzi_bg:addEventListener(DisplayEvents.kTouchTap,self.onPanelTap,self);
    else
      self.action_txt:setString("暂未开启");
      self.action_txt:setColor(CommonUtils:ccc3FromUInt(16711680));
    end

  end
  functionIcon:loadByArtID(functionIconId)
  if data.type == 1 then
    functionIcon:setScale(0.75)
  else
    functionIcon:setScale(0.9)
  end
  functionIcon:setAnchorPoint(CCPoint:new(0.5, 0.5)) 
  functionIcon:setPositionXY(55,62);
  functionIcon.touchEnabled = false;
  self.armature_d:addChild(functionIcon)


end

function TrackItemRender:onPanelTap(event)
	
  if self.data.type == 1 then
    if self.data.state ~= 2 then
    	self.context:onStrongPointTap(self.data.value, self.data.quickBattle);
    end
  elseif self.data.type == 2 then
    if self.data.state ~= 2 then
  	  self.context:onShadowTap(self.data.value, self.data.quickBattle);
    end
  elseif self.data.type == 3 then
	  print("TrackItemRender:onXunBaoTap")
  	self.context:onXunBaoTap(self.data.value);
  elseif self.data.type == 5  or self.data.type == 6 or self.data.type == 7  then
    print("TrackItemRender:onShopTap")
    self.context:onShopTap(self.data);
  elseif self.data.type == 8 then
    print("TrackItemRender:onZhaoHuanTap")
    self.context:onZhaoHuanTap(self.data.value);
  elseif self.data.type == 9 then
    print("TrackItemRender:onTenCountryTap")
    self.context:onTenCountryTap(self.data.value);
  elseif self.data.type == 10 then
    print("TrackItemRender:onShiLianTap")
    self.context:onShiLianTap(self.data.value);
  elseif self.data.type == 11 then
    print("TrackItemRender:onRiChangTap")
    self.context:onRiChangTap(self.data.value);  
  else

  end
-- onShiLianTap

end