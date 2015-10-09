require "main.view.trackItem.ui.TrackItemRender"
TrackItemUI = class(LayerPopableDirect)

function TrackItemUI:ctor()
	self.class = TrackItemUI;
end

function TrackItemUI:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  TrackItemUI.superclass.dispose(self);
  if self.cdTime1Listener then
    self.cdTime1Listener:dispose();
    self.cdTime1Listener = nil;
  end
  self.armature:dispose()
end
function TrackItemUI:onDataInit()

  self.userCurrencyProxy=self:retrieveProxy(UserCurrencyProxy.name);
  self.countControlProxy=self:retrieveProxy(CountControlProxy.name);
  self.userProxy=self:retrieveProxy(UserProxy.name);
  self.storyLineProxy = self:retrieveProxy(StoryLineProxy.name); 
  self.openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name)
  self.bagProxy = self:retrieveProxy(BagProxy.name)

  self.skeleton = SkeletonFactory.new();
  self.skeleton:parseDataFromFile("trackItem_ui");

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(false);
  layerPopableData:setHasUIFrame(false);
  layerPopableData:setVisibleDelegate(false)
  layerPopableData:setShowCurrency(true);
  layerPopableData:setArmatureInitParam(self.skeleton,"trackItem_ui");
  self:setLayerPopableData(layerPopableData);

end

function TrackItemUI:initialize()
  self:initLayer();

  self.mainSize = Director:sharedDirector():getWinSize();

  self.childLayer = LayerColor.new();
  self.childLayer:initLayer();
  self.childLayer:setColor(ccc3(0,0,0));
  self.childLayer:setOpacity(0);
  self:addChild(self.childLayer)
  self.childLayer.sprite:setContentSize(CCSizeMake(self.mainSize.width+1000, self.mainSize.height)); 
  self.childLayer:setPositionXY(-500, 0)
  self:setPositionXY(-GameData.uiOffsetX,  -GameData.uiOffsetY)    
  self.childLayer:addEventListener(DisplayEvents.kTouchTap,self.onPanelTap,self);

  self.sprite:setContentSize(CCSizeMake(self.mainSize.width, self.mainSize.height));

end

function TrackItemUI:onUIInit()

  self:addChild(self.armature.display);

  local size = self.armature.display:getChildByName("common_copy_panel_5"):getContentSize();
  self.armature.display:setPositionXY((self.mainSize.width - size.width)/2, (self.mainSize.height - size.height)/2-20)
  print("function TrackItemUI:onUIInit()")
---GameData.uiOffsetX/2, GameData.uiOffsetY/2

  self.bag_item_nametext_data = self.armature:getBone("itemName_txt").textData;
  -- self.itemName_txt = createTextFieldWithTextData(itemName_txtTextData, "绝世好剑剑");
  -- self.armature.display:addChild(self.itemName_txt);

  local itemType_txtDescData = self.armature:getBone("itemType_txt").textData;
  self.itemType_txt = createTextFieldWithTextData(itemType_txtDescData, "【武器】");
  self.armature.display:addChild(self.itemType_txt);

  local huodetujing_txtTextData = self.armature:getBone("huodetujing_txt").textData;
  self.huodetujing_txt = createTextFieldWithTextData(huodetujing_txtTextData, "物品获得途径");
  self.armature.display:addChild(self.huodetujing_txt);

  local common_copy_equipe_bg = self.armature.display:getChildByName("common_copy_equipe_bg");
  self.item1Pos = convertBone2LB(common_copy_equipe_bg);


  self.listScrollViewLayer=ListScrollViewLayer.new();
  self.listScrollViewLayer:initLayer();
  self.listScrollViewLayer:setPositionXY(22,64-35);
  self.listScrollViewLayer:setViewSize(makeSize(371,122*3+35));
  self.listScrollViewLayer:setItemSize(makeSize(371,122));
  self.armature.display:addChild(self.listScrollViewLayer);


end

function TrackItemUI:setParallelDisplay(parallelDisplay)
  self.parallelDisplay = parallelDisplay
end

function TrackItemUI:refreshData(data)
  self.targetItemId = data.itemId

  self:setItemInfo();
  self.itemType_txt:setString("拥有：" .. data.count .. "/" .. data.totalCount);

  local tempItemPo = analysis("Daoju_Daojubiao",self.targetItemId)
  print("self.targetItemId", self.targetItemId)
  if analysisHas("Daoju_Daojusuoyinfenlei",tempItemPo.syid) then
    local laiY = analysis("Daoju_Daojusuoyinfenlei",tempItemPo.syid, "laiY")
    local laiYuans = StringUtils:lua_string_split(laiY, ",");
    for k, v in pairs(laiYuans)do
      print("v", v)
      if tonumber(v) == 1 then
        self:checkStrongPoint()
      elseif tonumber(v) == 2 then
        self:checkShadow()
      elseif tonumber(v) == 3 then
        self:checkXunBao()
      elseif tonumber(v) == 5 then
        self:checkLunJianShop();
      elseif tonumber(v) == 6 then
        self:checkBangPaiShop();
      elseif tonumber(v) == 7 then
        self:checkHuangChengShop();
      elseif tonumber(v) == 8 then
        self:checkZhaoHuan()
      elseif tonumber(v) == 9 then--十国
        self:checkTenCountry()
      elseif tonumber(v) == 10 then--试炼
        self:checkShiLian()
      elseif tonumber(v) == 11 then--日常任务
        self:checkRiChang()
      elseif tonumber(v) == 12 then--英雄志全局掉落
        self:checkGlobalShadow();
      end
    end
  else
    self.tipText = TextField.new(CCLabelTTF:create("此道具暂无掉落",FontConstConfig.OUR_FONT,"20"));
    self.armature.display:addChild(self.tipText);
    self.tipText:setPositionXY(140,307);
  end
end
function TrackItemUI:setItemInfo()

  local tempItemPo = analysis("Daoju_Daojubiao",self.targetItemId)
  if tempItemPo.functionID==4 then
    color=getSimpleGrade(tempItemPo.color)
  else
    color=tempItemPo.color
  end

  self.bag_item_name=createTextFieldWithQualityID(color, self.bag_item_nametext_data, tempItemPo.name);
  self.armature.display:addChild(self.bag_item_name);

  local itemImage = BagItem.new(); 
  itemImage:initialize({ItemId = self.targetItemId, Count = 1});
  itemImage:setBackgroundVisible(true)
  itemImage:setPositionXY(self.item1Pos.x + 8, self.item1Pos.y + 8);
  itemImage.touchEnabled=true
  itemImage.touchChildren=true
  itemImage:addEventListener(DisplayEvents.kTouchTap, self.onItemTip, self);
  self.armature.display:addChild(itemImage);


end
function TrackItemUI:onItemTip(event)

end

function TrackItemUI:checkStrongPoint()
  local strongPointId;
  local currentStrongPointDrop = self:checkCurrentStrongPointId();

  if currentStrongPointDrop then
    local trackItemRender = TrackItemRender.new();
    local tempStrongPointPo = analysis("Juqing_Guanka",self.storyLineProxy.lastStrongPointId)
    trackItemRender:initialize(self, {type = 1, value = self.storyLineProxy.lastStrongPointId, state = 3, count = 0})
    self.listScrollViewLayer:addItem(trackItemRender);
  end
  local strongPointTables = {};
  for k, v in pairs(self.storyLineProxy.strongPointArray) do
     local tempStrongPointPo = analysis("Juqing_Guanka",v.StrongPointId)
     if tempStrongPointPo.Gtype == 1 and v.State == 1 then--and v.Count and v.Count ~= tempStrongPointPo.cishu
       table.insert(strongPointTables, tempStrongPointPo)
     end
  end
  local function sortFun(a, b)
    local storyOrderA = analysis("Juqing_Juqing", b.storyId, "order");
    local storyOrderB = analysis("Juqing_Juqing", b.storyId, "order");
    if storyOrderA < storyOrderB then
      return true;
    elseif storyOrderA > storyOrderB then
      return false;
    else
      if a.order > b.order then   
        return true;
      elseif a.order < b.order then  
        return false
      else
        return false      
      end
    end
  end

  table.sort(strongPointTables, sortFun)

  local isFind = false;
  for key, value in ipairs(strongPointTables) do
    if isFind then
      break;
    end
    local strongPointLv = analysis("Zhandoupeizhi_Zhanchangpeizhi", value.id, "lv");
    local dropItems = analysisByName("Diaoluo_Putongdiaoluo", "battleId", value.id);
    for key1, value1 in pairs(dropItems) do
      if value1.itemId == self.targetItemId then
        isFind = true;
        strongPointId = value.id;
        break;
      end
    end
    local tempTotalGlobalTable = analysisTotalTable("Diaoluo_Guankaquanjudiaoluo")
    for key2, value2 in pairs(tempTotalGlobalTable) do
      if strongPointLv >= value2.minLv and strongPointLv <= value2.maxLv  and 1 == value2.Gtype then
         if value2.itemId == self.targetItemId then
            strongPointId = value.id;
            isFind = true;
            break;
         end
      end
    end
  end

  print("strongPointId", strongPointId)
  local trackItemRender = TrackItemRender.new();
  local state = 1;
  if strongPointId then
    sendMessage(4, 3, {StrongPointId=strongPointId})
    if self.storyLineProxy.lastStrongPointId == strongPointId then
      state = 3;
    end
  elseif not currentStrongPointDrop and self.targetItemId == 8000000 then
    state = 2;
    strongPointId = self:checkUnOpenedStoryLine(true)
  elseif not currentStrongPointDrop then
    state = 2;
    print("strongPointId = self:checkUnOpenedStoryLine(false)")
    strongPointId = self:checkUnOpenedStoryLine(false)
  end
  if strongPointId then
    local count = self.storyLineProxy:getStrongPointFinishCount(strongPointId)
    trackItemRender:initialize(self, {type = 1, value = strongPointId, state = state, count = count})
    self.listScrollViewLayer:addItem(trackItemRender);
  end

  if not currentStrongPointDrop and not strongPointId then
    self.tipText = TextField.new(CCLabelTTF:create("此道具暂无掉落",FontConstConfig.OUR_FONT,"20"));
    self.armature.display:addChild(self.tipText);
    self.tipText:setPositionXY(140,307);
  end
end

function TrackItemUI:checkCurrentStrongPointId()
  local currentStrongPointDrop = false;
  local first = analysis("Juqing_Guanka", self.storyLineProxy.lastStrongPointId, "first");
  local strongPointDrops = StringUtils:stuff_string_split(first);
  for k, v in pairs(strongPointDrops) do
    local itemId = tonumber(v[1]);
    if itemId == self.targetItemId then
        currentStrongPointDrop = true;
        break;
    end
  end
  local strongPointLv = analysis("Zhandoupeizhi_Zhanchangpeizhi", self.storyLineProxy.lastStrongPointId, "lv");
  local dropItems = analysisByName("Diaoluo_Putongdiaoluo", "battleId", self.storyLineProxy.lastStrongPointId);
  for key1, value1 in pairs(dropItems) do
    if value1.itemId == self.targetItemId then
      currentStrongPointDrop = true;
      strongPointId = self.storyLineProxy.lastStrongPointId;
      break;
    end
  end
  local tempTotalGlobalTable = analysisTotalTable("Diaoluo_Guankaquanjudiaoluo")
  for key2, value2 in pairs(tempTotalGlobalTable) do
    if strongPointLv >= value2.minLv and strongPointLv <= value2.maxLv and 1 == value2.Gtype then
       if value2.itemId == self.targetItemId then
          strongPointId = self.storyLineProxy.lastStrongPointId;
          currentStrongPointDrop = true;
          break;
       end
    end
  end
  return currentStrongPointDrop;
end
function TrackItemUI:checkUnOpenedStoryLine(isMainGeneral)
  local strongPointId;
  local storyId = analysis("Juqing_Guanka", self.storyLineProxy.lastStrongPointId, "storyId");
  local strongPoints = analysisByName("Juqing_Guanka", "storyId", self.storyLineProxy.lastStrongPointId);
  for k, v in pairs(strongPoints) do
    local state = self.storyLineProxy:getStrongPointState(v.id);
    if not state or state == 2 then
      local first = analysis("Juqing_Guanka", self.storyLineProxy.lastStrongPointId, "first");
      local strongPointDrops = StringUtils:stuff_string_split(first);
      for k1, v1 in pairs(strongPointDrops) do
        local itemId = tonumber(v1[1]);
        if itemId == self.targetItemId then
            strongPointId = self.storyLineProxy.lastStrongPointId;
            break;
        end
      end
    end
  end
  if not strongPointId then
      local nextStoryId = analysis("Juqing_Juqing", 10028, "parent");
      local storyTables = {};

      while( nextStoryId ~= storyId)do
        table.insert(storyTables,1,nextStoryId)
        nextStoryId = analysis("Juqing_Juqing", nextStoryId, "parent");
      end
      local hasFind = false;
      for k, v in ipairs(storyTables) do
        if hasFind then
            break;
        end
        local strongPoints = analysisByName("Juqing_Guanka", "storyId", v);
        local strongPointArr = {};
        for k4, v4 in pairs(strongPoints) do
          table.insert(strongPointArr, v4);
        end
        local function sortFun(a, b)
          if a.order < b.order then
            return true;
          elseif a.order > b.order then
            return false
          else
            return false;
          end
        end
        table.sort(strongPointArr, sortFun)


        for key, value in ipairs(strongPointArr) do
          if hasFind then
            break;
          end
          if isMainGeneral then
            local strongPointDrops = StringUtils:stuff_string_split(value.first);
            for k2, v2 in pairs(strongPointDrops) do
              local itemId = tonumber(v2[1]);
              if itemId == self.targetItemId then
                  strongPointId = value.id;
                  hasFind = true;
                  break;
              end
            end
          else
            local strongPointLv = analysis("Zhandoupeizhi_Zhanchangpeizhi", value.id, "lv");
            local dropItems = analysisByName("Diaoluo_Putongdiaoluo", "battleId", value.id);
            for key1, value1 in pairs(dropItems) do
              if value1.itemId == self.targetItemId then
                strongPointId = value.id;
                hasFind = true;
                break;
              end
            end
            local tempTotalGlobalTable = analysisTotalTable("Diaoluo_Guankaquanjudiaoluo")
            for key2, value2 in pairs(tempTotalGlobalTable) do
              if strongPointLv >= value2.minLv and strongPointLv <= value2.maxLv and 1 == value2.Gtype then
                 if value2.itemId == self.targetItemId then
                    hasFind = true;
                    strongPointId = value.id;
                    break;
                 end
              end
            end
          end
        end
      end
  end
  if strongPointId then
    -- local strongPointPo = analysis("Juqing_Guanka", strongPointId);--, "scenarioName"
    -- local storyLinePo = analysis("Juqing_Juqing", strongPointPo.storyId);
    -- self.tipText = TextField.new(CCLabelTTF:create("剧情第".. storyLinePo.zhangjie .. "章" .. strongPointPo.scenarioName .. "掉落",FontConstConfig.OUR_FONT,"20"));
    -- self.armature.display:addChild(self.tipText);
    -- self.tipText:setPositionXY(290,307);
  end
  return strongPointId;
end

function TrackItemUI:checkShadow()
  local yxzTables = self:getYxzTable();
  local yxzStrongPointId,state = self:traverseCheckShadowPuTong(yxzTables)
  if yxzStrongPointId then
    local trackItemRender = TrackItemRender.new();
    local count = self.storyLineProxy:getStrongPointFinishCount(yxzStrongPointId)
    trackItemRender:initialize(self, {type = 2, value = yxzStrongPointId, state = state, count = count})
    self.listScrollViewLayer:addItem(trackItemRender);  
  end
end  
--遍历执行
function TrackItemUI:traverseCheckShadowPuTong(yxzTables)
  local yxzStrongPointId;
  local state = 2;
  local hasFind = false;
  for k, v in ipairs(yxzTables) do
    print("yxzTables v:", v)
    local dropItems = analysisByName("Diaoluo_Putongdiaoluo", "battleId", v.id);
    for k1, v1 in pairs(dropItems) do
      if v1.itemId == self.targetItemId then
        yxzStrongPointId = v.id;
        state = v.state;
        if state == 1 or state == 3 then
          local count = self.storyLineProxy:getStrongPointFinishCount(yxzStrongPointId)
          print("count:", count)
          if yxzStrongPointId and self.storyLineProxy:getStrongPointFinishCount(yxzStrongPointId) ~= 3 then
            hasFind = true;
            break;
          end
        else
          hasFind = true;
          break;
        end
      end
    end
  end
  return yxzStrongPointId, state;
end
function TrackItemUI:getYxzTable()
  local yingxiongzhis = analysisTotalTable("Juqing_Yingxiongzhi")
  local yxzTables = {};

  local function sortShadowFun(a, b)
    if a.id < b.id then   
      return true;
    elseif a.id > b.id then  
      return false
    else
      return false      
    end
  end

  for k, v in pairs(yingxiongzhis) do
    local state = self.storyLineProxy:getStrongPointState(v.id);
    table.insert(yxzTables, {id = v.id, state = state})
  end

  table.sort(yxzTables, sortShadowFun)
  return yxzTables;
end  
function TrackItemUI:checkGlobalShadow()

  local yxzTables = self:getYxzTable();
  local yxzStrongPointId,state = self:traverseCheckShadow(yxzTables);
  print("yxzStrongPointId", yxzStrongPointId)

  if yxzStrongPointId then
    local trackItemRender = TrackItemRender.new();

    local count = self.storyLineProxy:getStrongPointFinishCount(yxzStrongPointId)
    trackItemRender:initialize(self, {type = 2, value = yxzStrongPointId, state = state, count = count})
    self.listScrollViewLayer:addItem(trackItemRender);
  end
end
--遍历执行
function TrackItemUI:traverseCheckShadow(yxzTables)
  local yxzStrongPointId;
  local hasFind = false;
  local state = 2;
  for k, v in ipairs(yxzTables) do
    if hasFind then
      break;
    end
    local tempTotalGlobalTable = analysisTotalTable("Diaoluo_Guankaquanjudiaoluo")
    for k2, v2 in pairs(tempTotalGlobalTable) do
       if v2.itemId == self.targetItemId and v2.Gtype == 2 then
          yxzStrongPointId = v.id;
          state = v.state;
          if v.state == 1 or v.state == 3 then
            if yxzStrongPointId and self.storyLineProxy:getStrongPointFinishCount(yxzStrongPointId) ~= 3 then
              hasFind = true;
              break;
            end
          else
            hasFind = true;
            break; 
          end
       end
    end
  end
  return yxzStrongPointId, state;
end
function TrackItemUI:checkLunJianShop()
  local trackItemRender = TrackItemRender.new();
  trackItemRender:initialize(self, {type = 5, value = self.targetItemId})
  self.listScrollViewLayer:addItem(trackItemRender);
end
function TrackItemUI:checkBangPaiShop()
  local trackItemRender = TrackItemRender.new();
  trackItemRender:initialize(self, {type = 6, value = self.targetItemId})
  self.listScrollViewLayer:addItem(trackItemRender);
end
function TrackItemUI:checkHuangChengShop()
  local trackItemRender = TrackItemRender.new();
  trackItemRender:initialize(self, {type = 7, value = self.targetItemId})
  self.listScrollViewLayer:addItem(trackItemRender);
end
function TrackItemUI:checkXunBao()
  local trackItemRender = TrackItemRender.new();
  trackItemRender:initialize(self, {type = 3, value = self.targetItemId})
  self.listScrollViewLayer:addItem(trackItemRender);
end

function TrackItemUI:checkZhaoHuan()
  local trackItemRender = TrackItemRender.new();
  trackItemRender:initialize(self, {type = 8, value = nil})
  self.listScrollViewLayer:addItem(trackItemRender);
end
function TrackItemUI:checkTenCountry()
  local trackItemRender = TrackItemRender.new();
  trackItemRender:initialize(self, {type = 9, value = nil})
  self.listScrollViewLayer:addItem(trackItemRender);
end
function TrackItemUI:checkShiLian()
  local trackItemRender = TrackItemRender.new();
  trackItemRender:initialize(self, {type = 10, value = nil})
  self.listScrollViewLayer:addItem(trackItemRender);

end
function TrackItemUI:checkRiChang()
  local trackItemRender = TrackItemRender.new();
  trackItemRender:initialize(self, {type = 11, value = nil})
  self.listScrollViewLayer:addItem(trackItemRender);
end
function TrackItemUI:onUIClose(event)
  if self.parallelDisplay then
    self.parallelDisplay:onCloseButtonTap();
  end
   print("onUIClose")
  self:dispatchEvent(Event.new("CLOSE_TRACK_ITEM",nil,self));
end
function TrackItemUI:onPanelTap(event)
  if self.parallelDisplay then
    self.parallelDisplay:onCloseButtonTap();
  end
  self:closeUI()
end

function TrackItemUI:onStrongPointTap(strongPointId, quickBattle)
  self:dispatchEvent(Event.new("ON_STRONGPOINT_TAP",{strongPointId =strongPointId, quickBattle = quickBattle},self));
end
function TrackItemUI:onShadowTap(strongPointId, quickBattle)
  self:dispatchEvent(Event.new("ON_SHADOW_TAP",{strongPointId =strongPointId, quickBattle = quickBattle},self));
end
function TrackItemUI:onShopTap(data)
  self:dispatchEvent(Event.new("ON_SHOP_TAP",data,self));
end
function TrackItemUI:onXunBaoTap(xunBaoData)
  self:dispatchEvent(Event.new("ON_XUNBAO_TAP",{xunBaoData = xunBaoData},self));
end
function TrackItemUI:onZhaoHuanTap(zhaoHuanData)
  self:dispatchEvent(Event.new("ON_ZHAOHUAN_TAP",{zhaoHuanData = zhaoHuanData},self));
end
function TrackItemUI:onTenCountryTap(tenCountryData)
  self:dispatchEvent(Event.new("ON_TENCOUNTRY_TAP",{tenCountryData = tenCountryData},self));
end
function TrackItemUI:onShiLianTap(shiLianData)
  self:dispatchEvent(Event.new("ON_SHILIAN_TAP",{shiLianData = shiLianData},self));
end
function TrackItemUI:onRiChangTap(richangData)
  self:dispatchEvent(Event.new("ON_RICHANG_TAP",{richangData = richangData},self));
end