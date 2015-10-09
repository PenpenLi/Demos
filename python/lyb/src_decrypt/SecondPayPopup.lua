require "core.display.LayerPopable";
require "core.controls.CommonLayer";
require "main.model.SecondPayProxy";
require "main.view.secondPay.ui.SecondPayText"
require "main.view.secondPay.ui.SecondPayViewItem"

SecondPayPopup=class(LayerPopableDirect);

function SecondPayPopup:ctor()
  self.class=SecondPayPopup;
end

function SecondPayPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  SecondPayPopup.superclass.dispose(self);
  self.armature:dispose()
end

function SecondPayPopup:onDataInit()
  self.SecondPayProxy=self:retrieveProxy(SecondPayProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.huodongProxy = self:retrieveProxy(HuoDongProxy.name);
  self.bagProxy = self:retrieveProxy(BagProxy.name);
  self.skeleton = self.SecondPayProxy:getSkeleton();
  local layerPopableData=LayerPopableData.new();
  layerPopableData:setHasUIBackground(true)
  layerPopableData:setHasUIFrame(true)
  layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_HERO_HOUSE, nil, true, 2);
  layerPopableData:setArmatureInitParam(self.skeleton,"leichong_ui")
  layerPopableData:setShowCurrency(true);
  self:setLayerPopableData(layerPopableData)
  if MainSceneMediator then
    local med=Facade.getInstance():retrieveMediator(MainSceneMediator.name);
    self.med = med;
  end
end


function SecondPayPopup:initialize(context)
  self:initLayer();
  self.sprite:setContentSize(CCSizeMake(1280, 720));
  self.context = context;

end

function SecondPayPopup:onPrePop()
  

  local armature=self.armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;


  self.bg=Image.new();
  self.bg:loadByArtID(1111);
  self.bg:setPositionXY(85, 80);
  self.bg:setScale(0.85);
  self.armature_d:addChild(self.bg);

  for i=1,6 do
    local textData = self.armature:getBone("text"..i).textData;
    local text = createTextFieldWithTextData(textData, SecondPayText[i], true);
    self:addChild(text);
  end
  local temArmature = armature_d:getChildByName("logo");
  temArmature.parent:removeChild(temArmature, false);
  self.armature_d:addChild(temArmature);
  local temArmature = armature_d:getChildByName("bg");
  self.rightbg_pos = convertBone2LB(temArmature);
end

function SecondPayPopup:initScrollView(  )
  if self.listScrollView == nil then
    self.listScrollView = ListScrollViewLayer.new();
    self.listScrollView:initLayer();
    self.listScrollView:setPositionXY(self.rightbg_pos.x + 11 ,self.rightbg_pos.y);
    self.listScrollView:setItemSize(makeSize(598, 140));
    self.listScrollView:setViewSize(makeSize(598,385));
    self.armature_d:addChild(self.listScrollView);
  end
end

function SecondPayPopup:refreshData(data)

  print("function SecondPayPopup:refreshData(data)")

  if self.listScrollView == nil then
    self:initScrollView();
  end

  self.data = self.huodongProxy:getHuodongDataByID(17);
  if self.data == nil then
    return
  end

  if #self.data ~= 1 then
    -- 初始化数据
    self.data2 = self.data;
    local IsOpenReddot = 0;
    for k,v in pairs(self.data2) do
      if v.Count >= v.MaxCount and v.BooleanValue ==0 then
        IsOpenReddot = 1;
      end
      local item = SecondPayViewItem.new();
      item:initialize(self, 17, v);
      self.listScrollView:addItem(item);
    end
    self.med:refreshSecondPay(IsOpenReddot);
    self.huodongProxy:setReddotDataByID(17, IsOpenReddot);
  else
    --领取后确认的数据
    local index = 0;
    for k,v in pairs(self.data2) do
        if self.data[1].ConditionID == v.ConditionID then
          index = k;
          v.BooleanValue = self.data[1].BooleanValue;
          break;
        end
    end
    if index > 0 and index <= #self.data2 then
      -- 找到领取的数据
      sharedTextAnimateReward():animateStartByString("领取成功~！");
      self.listScrollView:removeItemAt(index - 1);
      local item = SecondPayViewItem.new();
      item:initialize(self, 17, self.data[1]);
      self.listScrollView:addItemAt(item, index - 1, true);

      self.SecondPayReddot = 0;
      local CloseSecondPayMainIcon = true;
      for k,v in pairs(self.data2) do
        if v.Count >= v.MaxCount then
          if v.BooleanValue == 0 then
            -- 表示还有东西没领取
            self.SecondPayReddot = 1;
            CloseSecondPayMainIcon = false;
            break;
          end
        else
          -- 还有条件为达到
          CloseSecondPayMainIcon = false;
        end 
      end
      if CloseSecondPayMainIcon == true then
        -- 关闭主界面ICON
        local FUNCTION_ID = 56;
        self.huodongProxy.IsOpenFisrtSecondPay = false;
        self.med:closeButtonsByFunctionID(FUNCTION_ID);
        self.huodongProxy:setReddotDataByID(17, 0);
      end
      self.med:refreshSecondPay(self.SecondPayReddot);
      self.huodongProxy:setReddotDataByID(17, self.SecondPayReddot);
    end
  end
end

function SecondPayPopup:onUIClose( )
  self:dispatchEvent(Event.new("SecondPayClose",nil,self));
end

function SecondPayPopup:getBagState(num)

  print(" function SecondPayPopup:getBagState(num) ", num)
  local bagIsFull = self.bagProxy:getBagIsFull();
  if bagIsFull then 
    sharedTextAnimateReward():animateStartByString("亲，您的背包已满哦~！");
    return false;
  end
  local leftPlaceCount = self.bagProxy:getBagLeftPlaceCount();
  print(" function SecondPayPopup:getBagState(num) ", num,leftPlaceCount)

  if num > leftPlaceCount then
    sharedTextAnimateReward():animateStartByString("亲，您的背包空间不足哦~！");
    return false;
  end
  return true;
end