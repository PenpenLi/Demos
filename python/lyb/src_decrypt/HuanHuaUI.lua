require "main.view.huanHua.ui.HuanHuaRender";
HuanHuaUI = class(LayerPopableDirect)

function HuanHuaUI:ctor()
	self.class = HuanHuaUI
end

function HuanHuaUI:dispose()
  HuanHuaUI.superclass.dispose(self);
end
	
function HuanHuaUI:onDataInit()

  self:initLayer();
  self.mainSize = Director:sharedDirector():getWinSize();
  self.sprite:setContentSize(self.mainSize);

  self.userCurrencyProxy=self:retrieveProxy(UserCurrencyProxy.name);
  self.generalListProxy=self:retrieveProxy(GeneralListProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.familyProxy = self:retrieveProxy(FamilyProxy.name);
  self.bagProxy = self:retrieveProxy(BagProxy.name);
  self.skeleton = getSkeletonByName("huanHua_ui");

  self.layerPopableData=LayerPopableData.new();
  self.layerPopableData:setHasUIBackground(true)
  self.layerPopableData:setHasUIFrame(true)
  self.layerPopableData:setArmatureInitParam(self.skeleton,"huanHua_ui")
  self:setLayerPopableData(self.layerPopableData)

end
function HuanHuaUI:onUIInit()
  local artId1 = getCurrentBgArtId();
  self.bgImage = Image.new();
  self.bgImage:loadByArtID(artId1);

  self:addChildAt(self.bgImage, 0)
  local yPos = -GameData.uiOffsetY

  if GameVar.mapHeight - self.mainSize.height > 30 then
    yPos = -GameData.uiOffsetY - 30
  end
  self.bgImage:setPositionXY(-GameData.uiOffsetX, yPos);

  local armature=self.armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;

  self.armature_d:setPositionXY((self.mainSize.width - 609)/2, (self.mainSize.height - 679)/2-GameData.uiOffsetY/2);


  self.headTitleText=BitmapTextField.new("幻化主角形象", "anniutuzi");
  self.headTitleText:setPositionXY(175,605);
  self.armature_d:addChild(self.headTitleText);

  self.listScrollViewLayer=ListScrollViewLayer.new();
  self.listScrollViewLayer:initLayer();
  self.listScrollViewLayer:setPositionXY(42, 63)
  self.listScrollViewLayer:setViewSize(makeSize(505,516));
  -- self.listScrollViewLayer:setItemSize(CCSizeMake(width,height));
  self.armature_d:addChild(self.listScrollViewLayer);

  self:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);

  self.childLayer = Layer.new();
  self.childLayer:initLayer();

end

function HuanHuaUI:setData()
  self.renderTables = {};
  local totalWidth,totalHeight = 0,0;
  for k = 4, 1,-1 do
    print("=============K", k)
    local render = HuanHuaRender.new();
    render:initData(self, self["tempTable" .. k]);
    print("```````````````````````totalHeight", totalHeight)
    render:setPositionXY(0, totalHeight)

    local itemSize = render.armature_d2:getGroupBounds().size;
    local tempHeight = itemSize.height;
    print("tempHeight", tempHeight)
    totalWidth  = itemSize.width;

    totalHeight = tempHeight + totalHeight;
    self.childLayer:addChild(render)
    table.insert(self.renderTables, render);
  end
  self.listScrollViewLayer:setItemSize(CCSizeMake(totalWidth,totalHeight));
  self.listScrollViewLayer:addItem(self.childLayer);

  --self.listScrollViewLayer:scrollToItemByIndex(3)
end

function HuanHuaUI:refreshState()
  for k, v in pairs(self.renderTables)do
    v:refreshRender();
  end
end

function HuanHuaUI:refreshSelectState()
  for k, v in pairs(self.renderTables)do
    v:refreshSelectState();
  end
end

function HuanHuaUI:checkOpenedTableHas(id)
  for k, v in pairs(self.openedTable) do
    if v.ID == id then
      return true
    end
  end
  return false
end
function HuanHuaUI:refreshHuanHua(IDArray)

  self.openedTable = {};
  for k, v in pairs(IDArray) do
    table.insert(self.openedTable, {ID = v.ID, BooleanValue = 1});
  end

  self.tempTable1 = {};
  self.tempTable2 = {};
  self.tempTable3 = {};
  self.tempTable4 = {};

  local tempTotalGlobalTable = analysisTotalTable("Zhujiao_Huanhua")
  for k, v in pairs(tempTotalGlobalTable) do
    if not self:checkOpenedTableHas(v.id) then
      if 1 == v.teamid then
        if self.userProxy:getCareer() == 8000 and v.id == 2 then
        elseif self.userProxy:getCareer() == 9000 and v.id == 1 then 
        else
          table.insert(self.tempTable1, {ID = v.id, BooleanValue = 0})
        end
      elseif 2 == v.teamid then   
        table.insert(self.tempTable2, {ID = v.id, BooleanValue = 0})
      elseif 3 == v.teamid then   
        table.insert(self.tempTable3, {ID = v.id, BooleanValue = 0})
      elseif 4 == v.teamid then   
        table.insert(self.tempTable4, {ID = v.id, BooleanValue = 0})
      end
    end
  end

  local function sortFun(a, b)
    local item1 = analysis("Zhujiao_Huanhua", a.ID)
    local item2 = analysis("Zhujiao_Huanhua", b.ID)--, "sort"
    if item1.teamid < item2.teamid then
      return true
    elseif item1.teamid > item2.teamid then
      return false;
    else
      if item1.sort < item2.sort then
        return true;
      elseif item1.sort > item2.sort then
        return false;
      else
        return false;
      end
    end
  end

  table.sort(self.tempTable1, sortFun);
  table.sort(self.tempTable2, sortFun);
  table.sort(self.tempTable3, sortFun);
  table.sort(self.tempTable4, sortFun);

  table.sort(self.openedTable, sortFun);

  for i = #self.openedTable, 1, -1 do
    local item = self.openedTable[i];
    local teamid = analysis("Zhujiao_Huanhua", item.ID, "teamid")
    if teamid == 1 then
      table.insert(self.tempTable1, 1, item)
    elseif teamid == 2 then 
      table.insert(self.tempTable2, 1, item)
    elseif teamid == 3 then
      table.insert(self.tempTable3, 1, item)
    else
      table.insert(self.tempTable4, 1, item)
    end
  end

  self:setData()

end

function HuanHuaUI:onSelfTap(event)
  print("onSelfTap")
  if self.popup_boolean then
    self.popup_boolean=false;
    return;
  end
  if self.huanHuaHeroPanel then
    self:removeHuanHuaHeroPanel();
  end
  if self.selectedId then
    self.selectedId = nil;
    self:refreshSelectState();
  end
  self.popup_boolean=false;
end
function HuanHuaUI:removeHuanHuaHeroPanel()
  self:removeChild(self.huanHuaHeroPanel);
  self.huanHuaHeroPanel = nil;
end
function HuanHuaUI:onUIClose()
  self:dispatchEvent(Event.new("HuanHuaClose",nil,self));
end
