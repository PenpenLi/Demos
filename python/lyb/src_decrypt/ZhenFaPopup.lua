require "core.display.LayerPopable";
require "core.controls.CommonLayer";
require "main.model.ZhenFaProxy";
require "main.view.zhenFa.ui.ZhenFaRender"
require "main.view.zhenFa.ui.ZhenFaGrid"

ZhenFaPopup=class(LayerPopableDirect);

function ZhenFaPopup:ctor()
  self.class=ZhenFaPopup;
  self.gridTab = {};
  self.renderTab = {};
  self.id = 1;
  -- self.idIn = false;
  self.idLevel = 0;
end

function ZhenFaPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  ZhenFaPopup.superclass.dispose(self);
  self.armature:dispose()
end

function ZhenFaPopup:onDataInit()
  self.zhenFaProxy=self:retrieveProxy(ZhenFaProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  -- self.huodongProxy = self:retrieveProxy(HuoDongProxy.name);
  self.bagProxy = self:retrieveProxy(BagProxy.name)
  self.userCurrencyProxy = self:retrieveProxy(UserCurrencyProxy.name);
  self.skeleton = self.zhenFaProxy:getSkeleton();
  local layerPopableData=LayerPopableData.new();
  layerPopableData:setHasUIBackground(true)
  layerPopableData:setHasUIFrame(true)
  layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_HERO_HOUSE, nil, true, 2);
  layerPopableData:setArmatureInitParam(self.skeleton,"zhenfa_ui")
  layerPopableData:setShowCurrency(true);
  self:setLayerPopableData(layerPopableData)

end

function ZhenFaPopup:initialize()
  self:initLayer();
  self.sprite:setContentSize(CCSizeMake(1280, 720));
end

function ZhenFaPopup:onPrePop()
  
  self.formationArray = self.zhenFaProxy:getData();
  --初始为第一个开放的
  -- for i,v in ipairs(self.formationArray) do
  --     self.idLevel = v.Level;
  --     break;
  --   -- print("v.ID, v.Level", v.ID, v.Level)
  --   -- if v.ID == 1 then
  --   --    -- self.idIn = true;
  --   --    self.idLevel = v.Level;
  --   -- end
  -- end

  local armature=self.armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;

  local logo = BitmapTextField.new("阵 法","anniutuzi");
  logo:setPosition(ccp(575 , 610));
  armature_d:addChild(logo);

  -- self.zhenFaTab1 = analysis("Zhenfa_Zhenfa", 1);

  local text_data = self.armature:getBone("name_txt").textData;
  self.name_txt = createTextFieldWithTextData(text_data, "");
  self.armature_d:addChild(self.name_txt)

  local text_data = self.armature:getBone("jihuo_txt").textData;
  self.jihuo_txt = createTextFieldWithTextData(text_data, "(未激活)");
  self.armature_d:addChild(self.jihuo_txt)

  local text_data = self.armature:getBone("jiacheng_txt").textData;
  self.jiacheng_txt = createTextFieldWithTextData(text_data, "阵法加成", true);
  self.armature_d:addChild(self.jiacheng_txt)

  -- -- local text_data = self.armature:getBone("manji_txt").textData;
  -- -- self.manji_txt = createTextFieldWithTextData(text_data, "( 满级Lv.10 )", true);
  -- -- self.armature_d:addChild(self.manji_txt)
  
  local text_data = self.armature:getBone("dangqian_txt").textData;
  self.dangqian_txt = createTextFieldWithTextData(text_data, "当前等级：未激活");
  self.armature_d:addChild(self.dangqian_txt)

  local text_data = self.armature:getBone("xiaji_txt").textData;
  self.xiaji_txt = createTextFieldWithTextData(text_data, "");
  self.armature_d:addChild(self.xiaji_txt)

  local text_data = self.armature:getBone("jihuozhenfa_txt").textData;
  self.jihuozhenfa_txt = createTextFieldWithTextData(text_data, "激活阵型", true);
  self.armature_d:addChild(self.jihuozhenfa_txt)

  local text_data = self.armature:getBone("num_txt").textData;
  self.num_txt = createTextFieldWithTextData(text_data, "");
  self.armature_d:addChild(self.num_txt)

  local blueButton =armature_d:getChildByName("blue_button");
  local blueButton_pos=convertBone2LB4Button(blueButton);
  self.armature_d:removeChild(blueButton)
  
  self.askButton =armature_d:getChildByName("common_copy_ask_button");
  SingleButton:create(self.askButton);
  self.askButton:addEventListener(DisplayEvents.kTouchTap, self.askTap, self);

  self.blueButton=CommonButton.new();
  self.blueButton:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  self.blueButton:setPosition(blueButton_pos);
  self.blueButton.touchEnabled=true
  self.armature_d:addChild(self.blueButton);
  self.blueButton:addEventListener(DisplayEvents.kTouchBegin,self.blueButtonTouchedBegin,self);

  local txt = "阵法激活"
  if self.idLevel == 0 then
    -- self.jihuo_txt:setString("(未激活)")
  else
    txt = "阵法升级"
    -- self.jihuo_txt:setString("(Lv." .. self.idLevel .. ")")
    self.jihuozhenfa_txt:setString("阵法升级")
  end

  local text_data = self.armature:getBone("lignqu_txt").textData;
  self.up_txt = createTextFieldWithTextData(text_data, txt, true);
  self.up_txt:setPositionXY(65, 30);
  self.up_txt:setAnchorPoint(ccp(0.5, 0.5))
  self.up_txt.touchEnabled = false;
  self.blueButton:addChild(self.up_txt);

  self.textTips = BitmapTextField.new("已满级","anniutuzi")
  self.textTips:setPositionXY(650,120)
  self.textTips.touchEnable = false
  self.armature_d:addChild(self.textTips)  

  self:addListScrollView();
  self:setItemCost()
  self:addGrids();

   if GameVar.tutorStage == TutorConfig.STAGE_1026 then
      GameVar.tutorSmallStep = 102610;
      openTutorUI({x=978, y=26, width = 100, height = 20, alpha = 125, fullScreenTouchable = true, hideTutorHand = true, blackBg = true});

      self.tutorLayer = Layer.new();
      self.tutorLayer:initLayer();
      self.tutorLayer:setContentSize(Director:sharedDirector():getWinSize());
      self.tutorLayer:addEventListener(DisplayEvents.kTouchTap, self.onTutorTap, self);
      self:addChild(self.tutorLayer)
   end 
end
function ZhenFaPopup:onTutorTap(event)
  self:removeChild(self.tutorLayer)
   if GameVar.tutorStage == TutorConfig.STAGE_1026 then
      sendServerTutorMsg({});
      closeTutorUI();
   end 
end
function ZhenFaPopup:addGrids()
  local grid1 = self.armature_d:getChildByName("grid1");

  local grid2 = self.armature_d:getChildByName("grid2");

  local grid3 = self.armature_d:getChildByName("grid3");

  local grid4 = self.armature_d:getChildByName("grid4");
  local grid5 = self.armature_d:getChildByName("grid5");
  local grid6 = self.armature_d:getChildByName("grid6");
  local grid7 = self.armature_d:getChildByName("grid7");
  local grid8 = self.armature_d:getChildByName("grid8");
  local grid9 = self.armature_d:getChildByName("grid9");
    
  table.insert(self.gridTab, grid1);
  table.insert(self.gridTab, grid2);
  table.insert(self.gridTab, grid3);
  table.insert(self.gridTab, grid4);
  table.insert(self.gridTab, grid5);
  table.insert(self.gridTab, grid6);
  table.insert(self.gridTab, grid7);
  table.insert(self.gridTab, grid8);
  table.insert(self.gridTab, grid9);

  for i,v in ipairs(self.gridTab) do
    v:setVisible(false)
  end

  local position1 = analysis("Zhenfa_Zhenfa", self.id, "position");

  local positionTab = StringUtils:lua_string_split(position1, ',');
  for i,v in ipairs(positionTab) do
    self.gridTab[tonumber(v)]:setVisible(true)
  end

end

function ZhenFaPopup:selectItem(id)
  
  self.id = id
  self.idLevel = 0;
  for i,v in ipairs(self.formationArray) do
    if v.ID == self.id then
       self.idLevel = v.Level;
    end
  end

  self.shenJiTab = self:getZhenfashengjiTable(self.id,self.idLevel) --analysis("Zhenfa_Zhenfashengji", (self.id-1)*10 + self.idLevel);
  self.shenJiTab2 = self:getZhenfashengjiTable(self.id,self.idLevel + 1) --analysis("Zhenfa_Zhenfashengji", (self.id-1)*10 + self.idLevel + 1);

  self.selectTab = analysis("Zhenfa_Zhenfa", id);
  self.positionTab = StringUtils:lua_string_split(self.selectTab.position, ',');

  for i,v in ipairs(self.gridTab) do
    v:setVisible(false)
  end

  for i,v in ipairs(self.positionTab) do
    self.gridTab[tonumber(v)]:setVisible(true)
  end

  for i,v in ipairs(self.renderTab) do
    if v.indexId1 == id then
      v.frame:setVisible(true);
    else
      v.frame:setVisible(false);
    end
  end

  local txt = "阵法激活"
  if self.idLevel == 0 then
    txt = "阵法激活"
    self.jihuozhenfa_txt:setString("阵法激活")
    self.jihuo_txt:setString("(未激活)")
    self.dangqian_txt:setString("当前等级：未激活")    
  else
    txt = "阵法升级"
    self.jihuozhenfa_txt:setString("阵法升级")
    self.dangqian_txt:setString("当前等级：Lv."..self.idLevel..self.shenJiTab.Info)
    self.jihuo_txt:setString("(Lv." .. self.idLevel .. ")")
  end

  self.up_txt:setString(txt);

  self.armature_d:removeChild(self.itemImage);
  self.armature_d:removeChild(self.xiaohao_img)

  self.name_txt:setString(self.selectTab.name)
 
  -- 满级了
  if not self.shenJiTab2 then
    self.textTips:setVisible(true)
    self.xiaji_txt:setString("")
    self.blueButton:setVisible(false)
    self.xiaji_txt:setString("")
    self.num_txt:setString("")
    return
  else
    self.textTips:setVisible(false)
    self.blueButton:setVisible(true)
  end

  self.xiaji_txt:setString("下一等级：Lv."..tostring(self.idLevel+1)..self.shenJiTab2.Info)
  local itemCost = StringUtils:lua_string_split(self.shenJiTab2.cost, ',');
  local yinbiCost = StringUtils:lua_string_split(self.shenJiTab2.money, ',');

  self.bagCount = self.bagProxy:getItemNum(itemCost[1]);
  self.itemImage = BagItem.new(); 
  self.itemImage:initialize({ItemId = itemCost[1], Count = 1});
  
  self.itemImage:setPositionXY(500, 100)
  self.itemImage:setBackgroundVisible(true)
  self.armature_d:addChild(self.itemImage)
  self.itemImage.touchEnabled=true;
  self.itemImage.touchChildren=true;  
  self.itemImage.bagHasCount = self.bagCount
  self.itemImage.totalNeedCount = tonumber(itemCost[2])

  self.itemImage:addEventListener(DisplayEvents.kTouchTap,self.onTap,self);
  self.itemImage:setTextString(self.bagCount .. "/" .. tonumber(itemCost[2]),CommonUtils:ccc3FromUInt(self.bagCount >= tonumber(tonumber(itemCost[2])) and 16710121 or 16711680));

  local xiaohao_imgID = analysis("Daoju_Daojubiao",tonumber(yinbiCost[1]),"art");
  self.yinbiCount = self.bagProxy:getItemNum(xiaohao_imgID);
  self.xiaohao_img = Image.new();
  self.xiaohao_img:loadByArtID(xiaohao_imgID);
  self.xiaohao_img:setScale(0.6)
  self.xiaohao_img:setPositionXY(625, 115);
  self.armature_d:addChild(self.xiaohao_img);
  self.num_txt:setString(yinbiCost[2])
  
end

function ZhenFaPopup:onTap(event)
  -- self:dispatchEvent(Event.new("ON_ITEM_TIP", {item = event.target},self));
  popItemDetailLayer(event.target,self);
end

function ZhenFaPopup:addListScrollView()

  local render1=self.armature_d:getChildByName("render1");
  local render2=self.armature_d:getChildByName("render2");
  
  self.render_pos=convertBone2LB(render1)

  self.list_x = self.render_pos.x;
  self.list_y = self.render_pos.y + render1:getContentSize().height;
  -- print("$$$$$$$$$ self.list_x, self.list_y", self.list_x, self.list_y)
  self.armature_d:removeChild(render1);
  self.armature_d:removeChild(render2);

  self.listScrollViewLayer=ListScrollViewLayer.new();
  self.listScrollViewLayer:initLayer();
  self.listScrollViewLayer:setPositionXY(self.list_x, self.list_y - 500 + 5);
  self.listScrollViewLayer:setViewSize(makeSize(235, 500));
  self.listScrollViewLayer:setItemSize(makeSize(220, 115));
  self.listScrollViewLayer:setDirection(kCCScrollViewDirectionVertical);
  self.listScrollViewLayer.touchEnabled=true;
  self.listScrollViewLayer.touchChildren=true
  self.armature_d:addChild(self.listScrollViewLayer);
 
  self:sortTable()

  self.renderTab[1].frame:setVisible(true);

end

local function sortOnIndex1(a, b) return a.ID < b.ID end
-- local function sortOnIndex2(a, b) return a.Level > b.Level end

function ZhenFaPopup:sortTable()
 
  table.sort(self.formationArray, sortOnIndex1)
  -- table.sort(self.formationArray, sortOnIndex2)  
  self.renderTab = {}
  local hasnotOpenTable = {1,2,3,4,5,6,7,8,9,10,11}
  for i,v in ipairs(self.formationArray) do
    
    local render = ZhenFaRender.new();
    render:initialize(self, v.ID);
    render:setPositionXY(0, 115);
    render.indexId1 = v.ID

    local layer = LayerColor.new();
    layer:initLayer();
    layer:setOpacity(true)
    layer:addChild(render)
    table.insert(self.renderTab, render);

    for k1,v1 in pairs(hasnotOpenTable) do
      if v1 == v.ID then
        table.remove(hasnotOpenTable, k1);
      end
    end    
    self.listScrollViewLayer:addItem(layer);

    render.unactivate:setVisible(false);
    render.panel:addChild(render.redIcon)
  end

  for k,v in pairs(hasnotOpenTable) do
    local render = ZhenFaRender.new();
    render:initialize(self, v);
    render:setPositionXY(0, 115);
    render.indexId1 = v

    local layer = LayerColor.new();
    layer:initLayer();
    layer:setOpacity(true)
    layer:addChild(render)
    table.insert(self.renderTab, render);
    self.listScrollViewLayer:addItem(layer);
    
    render.unactivate:addChild(render.redIcon)
  end
end

function ZhenFaPopup:blueButtonTouchedBegin(event)
  self.blueButton:addEventListener(DisplayEvents.kTouchEnd, self.blueButtonTouchedEnd, self);
  self.up_txt:setScale(0.9);
end

function ZhenFaPopup:getZhenfashengjiTable(zhenfaId,zhenfaLevel)
  local idTable = analysisByName("Zhenfa_Zhenfashengji","formId",zhenfaId);
  for k,v in pairs(idTable) do
    if v.level == zhenfaLevel then
      return v
    end
  end
end

function ZhenFaPopup:blueButtonTouchedEnd(event)

  self.up_txt:setScale(1);
  -- print("self.id", self.id,self.idLevel)
  self.shenJiTab = self:getZhenfashengjiTable(self.id,self.idLevel) -- analysis("Zhenfa_Zhenfashengji", (self.id-1)*60 + self.idLevel);
  self.shenJiTab2 = self:getZhenfashengjiTable(self.id,self.idLevel + 1) --analysis("Zhenfa_Zhenfashengji", (self.id-1)*60 + self.idLevel + 1);
  
  local itemCost = StringUtils:lua_string_split(self.shenJiTab2.cost, ',');
  local yinbiCost = StringUtils:lua_string_split(self.shenJiTab2.money, ',');

  self.bagCount = self.bagProxy:getItemNum(itemCost[1]);

  self.yinbiCount = self.userCurrencyProxy:getMoneyByItemID(tonumber(yinbiCost[1]));
  


  if self.idLevel >= self.userProxy.level then
    sharedTextAnimateReward():animateStartByString("阵法等级不能超过主角等级!");
    return
  end

  if self.bagCount < tonumber(itemCost[2]) then
    sharedTextAnimateReward():animateStartByString("您的道具不够!");
    return;
  end

  -- print("@@@", self.yinbiCount, yinbiCost[2])
  if self.yinbiCount < tonumber(yinbiCost[2]) then
    sharedTextAnimateReward():animateStartByString("您的银币不够!");
    self:dispatchEvent(Event.new("TO_DIANJINSHOU"));
    return;
  end
  sendMessage(6, 21, {ID = self.id})
end

function ZhenFaPopup:refreshData(ID, level)

  local overEffect = cartoonPlayer("1090",640,360,1,rollComplete,1,nil,nil)
  self:addChild(overEffect) 
  
  self.listScrollViewLayer:removeAllItems()
  self:sortTable()
  
  self.id = ID;
  self.idLevel = level;

  for i,v in ipairs(self.renderTab) do
    if v.indexId1 == self.id then
      v.frame:setVisible(true);
      if self.id ~= 1 then
        self.listScrollViewLayer:scrollToItemByIndex(i-1,false)
      end
    else
      v.frame:setVisible(false);
    end
  end  

  self.up_txt:setString("阵法升级")
  self.jihuozhenfa_txt:setString("阵法升级")

  self.armature_d:removeChild(self.itemImage);
  self.armature_d:removeChild(self.xiaohao_img)

  self.shenJiTab = self:getZhenfashengjiTable(self.id,self.idLevel) --analysis("Zhenfa_Zhenfashengji", (self.id-1)*10 + self.idLevel);
  self.shenJiTab2 = self:getZhenfashengjiTable(self.id,self.idLevel + 1) --analysis("Zhenfa_Zhenfashengji", (self.id-1)*10 + self.idLevel + 1);

  self.dangqian_txt:setString("当前等级：Lv."..tostring(self.idLevel)..self.shenJiTab.Info)

  if self.idLevel == 0 then
    self.jihuo_txt:setString("(未激活)")
  else
    self.jihuo_txt:setString("(Lv." .. self.idLevel .. ")")
  end

  -- 满级了
  if not self.shenJiTab2 then
    self.textTips:setVisible(true)
    self.xiaji_txt:setString("")
    self.blueButton:setVisible(false)
    self.xiaji_txt:setString("")
    self.num_txt:setString("")
    return
  else
    self.textTips:setVisible(false)
    self.blueButton:setVisible(true)
  end

  self.xiaji_txt:setString("下一等级：Lv."..tostring(self.idLevel+1)..self.shenJiTab2.Info) 

  local itemCost = StringUtils:lua_string_split(self.shenJiTab2.cost, ',');
  local yinbiCost = StringUtils:lua_string_split(self.shenJiTab2.money, ',');

  self.bagCount = self.bagProxy:getItemNum(itemCost[1]);
  self.itemImage = BagItem.new(); 
  self.itemImage:initialize({ItemId = itemCost[1], Count = 1});
  self.itemImage.touchEnabled=true;
  self.itemImage.touchChildren=true;    
  self.itemImage:setPositionXY(500, 100)
  self.itemImage:setBackgroundVisible(true)
  self.itemImage.bagHasCount = self.bagCount;
  self.itemImage.totalNeedCount = tonumber(itemCost[2]);
  self.armature_d:addChild(self.itemImage)
  self.itemImage:addEventListener(DisplayEvents.kTouchTap,self.onTap,self);
  self.itemImage:setTextString(self.bagCount .. "/" .. tonumber(itemCost[2]),CommonUtils:ccc3FromUInt(self.bagCount >= tonumber(tonumber(itemCost[2])) and 16710121 or 16711680));

  local xiaohao_imgID = analysis("Daoju_Daojubiao",tonumber(yinbiCost[1]),"art");
  self.xiaohao_img = Image.new();
  self.xiaohao_img:loadByArtID(xiaohao_imgID);
  self.xiaohao_img:setScale(0.6)
  self.xiaohao_img:setPositionXY(625, 115);
  self.armature_d:addChild(self.xiaohao_img);
  self.num_txt:setString(yinbiCost[2])

end

function ZhenFaPopup:setItemCost()

  if self.formationArray[1] then
    self.id = self.formationArray[1].ID
    self.idLevel = self.formationArray[1].Level
  end

  self.shenJiTab = self:getZhenfashengjiTable(self.id,self.idLevel) --analysis("Zhenfa_Zhenfashengji", (self.id-1)*10 + self.idLevel);
  self.shenJiTab2 = self:getZhenfashengjiTable(self.id,self.idLevel + 1) --analysis("Zhenfa_Zhenfashengji", (self.id-1)*10 + self.idLevel + 1);

  log("self.idLevel===="..self.idLevel)

 
  local txt = "阵法激活"
  if self.idLevel == 0 then
    self.dangqian_txt:setString("当前等级：未激活")
    self.jihuo_txt:setString("(未激活)")
  else
    txt = "阵法升级"
    self.dangqian_txt:setString("当前等级：Lv."..tostring(self.idLevel)..self.shenJiTab.Info)    
    self.jihuo_txt:setString("(Lv." .. self.idLevel .. ")")
  end
 
  self.up_txt:setString(txt);

  local zhenfaVO = analysis("Zhenfa_Zhenfa", self.id);

  self.name_txt:setString(zhenfaVO.name)

  -- 满级了
  if not self.shenJiTab2 then
    self.textTips:setVisible(true)
    self.xiaji_txt:setString("")
    self.blueButton:setVisible(false)
    self.xiaji_txt:setString("")
    self.num_txt:setString("")
    return
  else
    self.textTips:setVisible(false)
    self.blueButton:setVisible(true)
  end
  
  self.xiaji_txt:setString("下一等级：Lv."..tostring(self.idLevel+1)..self.shenJiTab2.Info)

  local itemCost = StringUtils:lua_string_split(self.shenJiTab2.cost, ',');
  local yinbiCost = StringUtils:lua_string_split(self.shenJiTab2.money, ',');

  self.bagCount = self.bagProxy:getItemNum(itemCost[1]);
  self.itemImage = BagItem.new(); 
  self.itemImage:initialize({ItemId = itemCost[1], Count = 1});
  self.itemImage.touchEnabled=true;
  self.itemImage.touchChildren=true;    
  self.itemImage:setPositionXY(500, 100)
  self.itemImage:setBackgroundVisible(true)
  self.itemImage.bagHasCount = self.bagCount;
  self.itemImage.totalNeedCount = tonumber(itemCost[2]);
  
  self.armature_d:addChild(self.itemImage)
  self.itemImage:addEventListener(DisplayEvents.kTouchTap,self.onTap,self);
  self.itemImage:setTextString(self.bagCount .. "/" .. tonumber(itemCost[2]),CommonUtils:ccc3FromUInt(self.bagCount >= tonumber(tonumber(itemCost[2])) and 16710121 or 16711680));

  local xiaohao_imgID = analysis("Daoju_Daojubiao",tonumber(yinbiCost[1]),"art");
  self.xiaohao_img = Image.new();
  self.xiaohao_img:loadByArtID(xiaohao_imgID);
  self.xiaohao_img:setScale(0.6)
  self.xiaohao_img:setPositionXY(625, 115);
  self.xiaohao_img.touchEnabled = false
  self.armature_d:addChild(self.xiaohao_img);
  self.num_txt:setString(yinbiCost[2])
end

function ZhenFaPopup:askTap(event)
  local functionStr = analysis("Tishi_Guizemiaoshu",18,"txt");
  TipsUtil:showTips(event.target,functionStr,nil,0);
end

function ZhenFaPopup:onUIClose( )
  self:dispatchEvent(Event.new("ZhenFaClose",nil,self));
end
