
require "main.view.tianXiang.ui.render.TianXiangItem"
TianXiangItemSlot = class(CommonSlot);

-- creat
function TianXiangItemSlot:ctor()
  self.class = TianXiangItemSlot;
  self.tianXiangZuId = nil
  self.tianxiangItems = {};
  -- self.childLayer1 = Layer.new();
  -- self.childLayer2 = Layer.new();
end
function TianXiangItemSlot:dispose()

  self:removeAllEventListeners();
  self:removeChildren();
  TianXiangItemSlot.superclass.dispose(self);

end

function TianXiangItemSlot:initialize(context)
  self.context = context;
  self:initLayer();
  -- self.childLayer1:initLayer();
  -- self.childLayer2:initLayer();

  self:setContentSize(self.context.mainSize)
  print("TianXiangItemSlot:initialize")
end

function TianXiangItemSlot:setSlotData(tianXiangZuId)
  -- print("tianXiangZuId", tianXiangZuId);
  self:cleanSlotData();
  print("\n\n\ntianXiangZuId = ", tianXiangZuId);
  self.tianXiangZuId = tianXiangZuId;
  self.tianxiangZuPo = analysis("Zhujiao_Tianxiangshouhuzu",tianXiangZuId)




  local mapID = self.tianxiangZuPo.map

  self.tianxiangPos = analysisByName("Zhujiao_Tianxiangshouhudian","group", tianXiangZuId)

  log("TianXiangItemSlot:initMap ++++++mapID:" .. mapID)
  self.mapUIData = analysisMapUI(mapID)
  self.detailTable = self.mapUIData.outersTable
  
  print("self.mapUIData.backartid:", self.mapUIData.backartid)
  ----add背景
  self.backImage = Image.new()
  self.backImage:loadByArtID(self.mapUIData.backartid)
  self.backImage:setAnchorPoint(CCPointMake(0.5, 0.5))
  self.backImage:setPositionXY(self.context.mainSize.width/2 - GameData.uiOffsetX/2, self.context.mainSize.height/2 - GameData.uiOffsetY/2)

  self.backImage:setScale(self.mapUIData.backArtScaleSize)

  self.woldWidth = self.backImage:getContentSize().width
  self:addChild(self.backImage)



  ----add背景
  self.titleImage = Image.new()
  self.titleImage:loadByArtID(self.tianxiangZuPo.artid)
  -- self.titleImage:setAnchorPoint(CCPointMake(0.5, 0.5))
  self.titleImage:setPositionXY(self.context.mainSize.width/2-170, self.context.mainSize.height-100)
  self:addChild(self.titleImage)

  -- self:addChild(self.childLayer1)
  -- self:addChild(self.childLayer2)

  ----add 房子
  for k,v in pairs(self.tianxiangPos) do
    -- print("strongPointId", v.id)
    local strongPointInEditor = self.detailTable[v.id]
    local tianxiangItem = TianXiangItem.new();

    tianxiangItem:initialize(self.context, self, v.id, strongPointInEditor.xPos+GameData.uiOffsetX+30, strongPointInEditor.yPos+GameData.uiOffsetY+15);

    self.tianxiangItems[v.id] = tianxiangItem
    self:addChild(tianxiangItem) 
  end

end


function TianXiangItemSlot:cleanSlotData()
  print("TianXiangItemSlot:removeSlotData()")
  self.data = nil;
  self:removeChildren();
  self.tianxiangItems = {};
end

function TianXiangItemSlot:clean()
  self.tianxiangItems = {};
  self:removeAllEventListeners();
end
function TianXiangItemSlot:refreshData()
  for k, v in pairs(self.tianxiangItems) do
    v:setData();
    print("    v:setData();")
  end
end