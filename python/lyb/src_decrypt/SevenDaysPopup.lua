require "core.display.LayerPopable";
require "core.controls.CommonLayer";
require "core.controls.ScrollSelectButton";
require "main.model.SevenDaysProxy";
require "main.view.SevenDays.ui.render.LeftUI";
require "main.view.SevenDays.ui.render.Button_UI"
require "main.view.SevenDays.ui.printTab"

SevenDaysPopup = class(LayerPopableDirect);
-- SevenDaysPopup = class(LayerColor);

function SevenDaysPopup:ctor(  )
	self.class = SevenDaysPopup;
  -- self.currentDay = 2;
  self.data = {};
end

function SevenDaysPopup:dispose(  )
	self:removeAllEventListeners();
	self:removeChildren();
	SevenDaysPopup.superclass.dispose(self);
  -- Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timerHandler);
  -- self.timerHandler=nil

end

function SevenDaysPopup:onDataInit()
  self.userCurrencyProxy 	= self:retrieveProxy(UserCurrencyProxy.name);
  self.userProxy 			    = self:retrieveProxy(UserProxy.name);
  self.SevenDaysProxy 		= self:retrieveProxy(SevenDaysProxy.name);
  self.huodongProxy       = self:retrieveProxy(HuoDongProxy.name);
  self.bagProxy = self:retrieveProxy(BagProxy.name);
  self.currentDay = self.huodongProxy.CurrentDays;
  self.selectDay =  self.currentDay;

  --获取29_1数据
  self.datas = self.huodongProxy:getData();
  print("\n\n self.currentDay = ", self.currentDay);
  -- 活动ID为7-13获取活动结束时间
  print("self.datas" ,self.dates)
  for k,v in pairs(self.datas) do
    -- print("dates = ", k,v.ID, v.RemainSeconds)
    if v.ID > 6  and v.ID < 14 then 
      self.RemainSeconds = v.RemainSeconds;
      self.EndTime = v.EndTime;
      break;
    end
  end

  self.skeleton = self.SevenDaysProxy:getSkeleton();

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(true)
  layerPopableData:setHasUIFrame(true)
  layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_SEVENDAYS, nil, true, 2);
  layerPopableData:setArmatureInitParam(self.skeleton,"sevendays_ui")
  layerPopableData:setShowCurrency(false);
  self:setLayerPopableData(layerPopableData)
  self.layerPopableData = layerPopableData;
  
  sendMessage(29,2, {ID = self.currentDay + 6})
  log("self.currentDay + 6 = ".. self.currentDay + 6);

  -- local layerColor = LayerColorBackGround:getTransBackGround()
  -- self:addChild(layerColor);
  
end

function SevenDaysPopup:initialize(  )
	print("SevenDaysPopup initialize")
  self.context=self
  self.channel=1;
  self.btn_index = 1;
  self.tabofrightrender={}
  self.armature = armature;
  self:initLayer();
  self.sprite:setContentSize(CCSizeMake(1280, 720));
-- setCurrencyGroupVisible(false);

    

end

function SevenDaysPopup:updateTextDate(str)
  if self.endtime ~= nil then
    self.endtime:setString(str);
    return;
  end

end

function SevenDaysPopup:onPrePop()
 

  local bg1 = self.armature.display:getChildByName("bg1");
  self.bg1_pos = convertBone2LB(bg1);
  local rightbg = self.armature.display:getChildByName("rightbg");
  self.rightbg_pos = convertBone2LB(rightbg);
  self.rightbg_pos.x = self.rightbg_pos.x - self.bg1_pos.x;
  self.rightbg_pos.y = self.rightbg_pos.y - self.bg1_pos.y;
  print("\n\nself.rightbg_pos = ", self.rightbg_pos.x, self.rightbg_pos.y)
	log("function SevenDaysPopup:onPrePop()")
  local CurrentBtn = 1;
  -- self:updateTextDate();

  local endtime = self.armature:getBone("endtime").textData;
  self.endtime = createTextFieldWithTextData(endtime, "", true);
  self:addChild(self.endtime);
  self.endtime.touchEnabled = false;

end

--初始化和更新左边第几天界面
function SevenDaysPopup:updateLeftUI(  )
    if self.left_ui == nil then
      self.left_ui = LeftUI.new();
      self.left_ui:initialize(self, self.currentDay);
      self.left_ui:setPositionXY(129, 70);
      self:addChild(self.left_ui);
      self:refreshLeftRedDot();
      -- self.left_ui:refreshRedDot();
      self.composite = getCompositeRole(526)
      self.composite:setPositionXY(320,140)
      self:addChild(self.composite)
    else 
      self.left_ui:updateLeftUI(self, self.currentDay);
    end
    
end

--收到数据后进行刷新
function SevenDaysPopup:refreshData(  )
    --解除屏幕转圈加载
    -- uninitializeSmallLoading();
    print("function SevenDaysPopup:refreshData(  )1")
    local  checkdata = self.huodongProxy:gettakeAwardData();
    if checkdata ~= nil  then
      local IsAllTakeAward = 0; -- 0 为当天奖励全部领取，1 为当天奖励还有可领取
      for k,v in pairs(self.data[self.selectDay]) do
        if v.ConditionID == checkdata[1].ConditionID then
          v.BooleanValue = 1;
        end
        if v.Count >= v.MaxCount and v.BooleanValue == 0 then
          IsAllTakeAward = 1;
        end
      end
      self.huodongProxy:setReddotDataByID(self.selectDay + 6, IsAllTakeAward); -- 维护小红点

      if self.btn_index > 0 and self.btn_index < 4 then
        --领取物品后服务端返回的确认数据
        -- sharedTextAnimateReward():animateStartByString("领取奖励成功~！")
        self.button_ui.listScrollView:checkTackAward(self.selectDay, self.btn_index, checkdata);
        self:refreshButtonRaddot();
        return;
      elseif self.btn_index == 4 then

        self.button_ui.harlfPrice:checkTackAward(self.selectDay, self.btn_index, checkdata);
        -- sharedTextAnimateReward():animateStartByString("购买成功~！")


        -- print("-------------checkdata = ",checkdata[1].ConditionID, checkdata[1].BooleanValue, checkdata[1].Group);

        self:refreshButtonRaddot();
        return ;
      end
    else
      self.data[self.selectDay] = self.huodongProxy:getHuodongDataByID(self.selectDay + 6);
    end

    print("function SevenDaysPopup:refreshData(  )2")
    
    
    --初始化右边四个按钮
    self:updateButton(self.btn_index);
    -- 初始化左边七天按钮
    self:updateLeftUI(self.currentDay, self.btn_index);  
    
    print("self.btn_index = ", self.btn_index)

    --更新滑动列表
    if self.btn_index > 0 and self.btn_index < 4 then
      self.button_ui.listScrollView:updateListView(self.selectDay, self.btn_index);
    elseif self.btn_index == 4 then
      --刷新半价抢购界面
      self.button_ui.harlfPrice:updateHarfPrice(self.selectDay, self.btn_index);
    end
    
    self:refreshButtonRaddot();

end

--更新和初始化右边四个按钮
function SevenDaysPopup:updateButton( btn_index)
  log("function SevenDaysPopup:updateButton( index)")
    if self.button_ui == nil then
      local bg1 = self.armature.display:getChildByName("bg1");
      local button_ui_pos = convertBone2LB(bg1);
      self.button_ui_pos = button_ui_pos
      print("button_ui_pos = ", button_ui_pos.x, button_ui_pos.y);
      self.button_ui = Button_UI.new();
      self.button_ui:initialize(self, self.currentDay, btn_index);
      self.button_ui:setPositionXY(button_ui_pos.x, button_ui_pos.y);
      self:addChild(self.button_ui);
      print("self.button_ui ==  ", self.button_ui);

    else
      print("self.button_ui ~= nil ")
      -- self.button_ui:updateButton(btn_index);
    end


end

function SevenDaysPopup:refreshLeftRedDot(  )
  --获取29_1数据
  self.datas = self.huodongProxy:getData();
  print("self.datas" ,self.dates)
  for k,v in pairs(self.datas) do
    if v.ID > 6  and v.ID < 14 then 
      if v.BooleanValue == 0 then
        self.left_ui.reddotTab[v.ID - 6].IsVisible = false;
      else
        self.left_ui.reddotTab[v.ID - 6].IsVisible = true;
      end

      print("v.ID = ", v.ID, v.BooleanValue);    
    end
  end
  self.left_ui:refreshRedDot();
end

function SevenDaysPopup:refreshButtonRaddot()
  local data = self.huodongProxy:getHuodongDataByID(self.selectDay + 6);
  local count = {};
  local sum = 0;

  for k,v in pairs(data) do
    print(k, v.ID, v.BooleanValue, v.Group)
  end

  for i=1,4 do
    count[i] = 0;
  end

  for k,v in pairs(data) do
    print("refreshRedDot = ", v.Group, v.BooleanValue, v.Count, v.MaxCount);
    if v.BooleanValue == 0 and  v.Count >= v.MaxCount  then
      count[v.Group] = 1;
      sum = sum + 1;
    end
  end

  for i=1,4 do
    if count[i] == 1 then
      self.button_ui.btnReddotTab[i].IsVisible =  true;
    else
      self.button_ui.btnReddotTab[i].IsVisible =  false;
    end
    -- print("self.button_ui.btnReddotTab[i]", self.button_ui.btnReddotTab[i].IsVisible)
  end

  self.button_ui:refreshRedDot();

    --更新left_ui 小红点状态
    print("self.left_ui.reddotTab[self.selectDay].IsVisible = ",sum,  self.left_ui.reddotTab[self.selectDay].IsVisible);
    self.left_ui.reddotTab[self.selectDay].IsVisible = (sum ~= 0 or false); -- sum == 0 isvisible = true 否则 为false
    print("self.left_ui.reddotTab[self.selectDay].IsVisible = ", self.left_ui.reddotTab[self.selectDay].IsVisible);
    self.left_ui:refreshRedDot();
    for k,v in pairs(self.datas) do
      
      if v.ID == self.selectDay + 6 then
        v.BooleanValue = (sum == 0 and 0 or 1);
      end
          -- print("refreshButtonRaddot =  ", v.ID , self.selectDay, v.BooleanValue, self.left_ui.reddotTab[self.selectDay].IsVisible);
    end

end

function SevenDaysPopup:refreshRedDot( tab )
  if self.left_ui ~= nil and self.left_ui.reddotTab then
    print(" function SevenDaysPopup:refreshRedDot( tab ) ",#self.left_ui.reddotTab)
    for k,v in pairs(self.left_ui.reddotTab) do
      if tab[k+6] == true then
        self.left_ui.reddotTab[k].IsVisible = true;
        self.left_ui.reddotTab[k].reddot:setVisible(true);
      else
        self.left_ui.reddotTab[k].IsVisible = false;
        self.left_ui.reddotTab[k].reddot:setVisible(false);
      end
    end
  end

end

function SevenDaysPopup:onUIInit( ... )
  -- body

end

function SevenDaysPopup:stopSevendays()
  
  local stopCommonPopup = CommonPopup.new();
  stopCommonPopup:initialize("亲~！活动已经结束了哦！", self, self.closeUI,nil, nil, nil,true,{"确认"}, nil, nil, 2);
  sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(stopCommonPopup);
  -- self:addChild(stopCommonPopup);
end

--关闭按钮
function SevenDaysPopup:onUIClose(  )
  print("function SevenDaysPopup:onUIClose(  )")
  self:dispatchEvent(Event.new("CLOSE_SEVENDAYS_UI", nil, self));
end