require "core.display.LayerPopable";
require "core.controls.CommonLayer";
require "core.controls.ScrollSelectButton";
require "main.view.shopTwo.ui.ShopTwoItemPageView";
ShopTwoPopup=class(LayerPopableDirect);

function ShopTwoPopup:ctor()
  self.class=ShopTwoPopup;
  self.count = 5;
  self.bg_image = nil;
  self.SHOP_TYPE_4 = 4 --论剑商店
end
function ShopTwoPopup:dispose()
  ShopTwoPopup.superclass.dispose(self);
end
function ShopTwoPopup:onDataInit()
  

  self.shopProxy=self:retrieveProxy(ShopProxy.name);
  self.userCurrencyProxy=self:retrieveProxy(UserCurrencyProxy.name);
  self.generalListProxy=self:retrieveProxy(GeneralListProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.countControlProxy=self:retrieveProxy(CountControlProxy.name);
  self.itemUseQueueProxy=self:retrieveProxy(ItemUseQueueProxy.name);
  self.storyLineProxy=self:retrieveProxy(StoryLineProxy.name)
  self.bagProxy = self:retrieveProxy(BagProxy.name);

  self.skeleton = self.shopProxy:getSkeleton();
  local layerPopableData=LayerPopableData.new();
  layerPopableData:setHasUIBackground(true)
  layerPopableData:setHasUIFrame(true)
  layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_SHOP,nil,true,2)
  layerPopableData:setArmatureInitParam(self.skeleton,"shop_ui")
  layerPopableData:setShowCurrency(true);
  self:setLayerPopableData(layerPopableData)

end


function ShopTwoPopup:initialize()
  self.context=self
  self.channel=1;
  self:initLayer();
  local mainSize = Director:sharedDirector():getWinSize();
  self.sprite:setContentSize(CCSizeMake(1280, 720));
  self.skeleton=nil;

  self.childLayer = Layer.new();
  self.childLayer:initLayer();
end

function ShopTwoPopup:onPrePop()
  

  local armature=self.armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;
  armature_d.touchEnabled=true;

  
  local shop_render1=armature_d:getChildByName("shop_render1");
  local shop_render2=armature_d:getChildByName("shop_render2");
  local shop_render3=armature_d:getChildByName("shop_render3");
  
  self.render_width=shop_render1:getGroupBounds().size.width
  self.render_height=shop_render1:getGroupBounds().size.height
  self.render_space_left2right=shop_render2:getPositionX()-shop_render1:getPositionX()-self.render_width
  self.render_space_top2bottom=shop_render1:getPositionY()-shop_render3:getPositionY()-self.render_height
  armature_d:removeChild(shop_render1);
  armature_d:removeChild(shop_render2);
  armature_d:removeChild(shop_render3);

  local channel1=armature_d:getChildByName("channel_1");
  local channel2=armature_d:getChildByName("channel_2");
  self.channel1_pos=convertBone2LB4Button(channel1);
  self.channel2_pos=convertBone2LB4Button(channel2);
  self.channel1_text=armature:findChildArmature("channel_1"):getBone("common_channel_button").textData;
  self.channel2_text=armature:findChildArmature("channel_2"):getBone("common_channel_button").textData;
  armature_d:removeChild(channel1)
  armature_d:removeChild(channel2)

  local refresh=armature_d:getChildByName("refresh")
  self.refresh_pos=convertBone2LB4Button(refresh);
  armature_d:removeChild(refresh)

  armature_d:addChild(self.childLayer)

  self:addChild(armature_d)
  self.gril_bg = Image.new()
  self.gril_bg:loadByArtID(1167)
  self.gril_bg:setScale(1)

  
  
end

function ShopTwoPopup:onUIInit()

  local text_data = self.armature:getBone("vip").textData;
  self.vipText = createTextFieldWithTextData(text_data,"vip6开启");
  self:addChild(self.vipText);
  self.vipText:setVisible(false)


  self.refresh_button=CommonButton.new();
  self.refresh_button:initialize("commonButtons/common_small_red_button_normal",nil,CommonButtonTouchable.BUTTON);
  self.refresh_button:initializeBMText("刷新","anniutuzi");
  self.refresh_button:setPosition(self.refresh_pos);
  self.refresh_button:addEventListener(DisplayEvents.kTouchTap, self.fresh, self);
  self:addChild(self.refresh_button);
  



  self.channel_button2=CommonButton.new();
  self.channel_button2:initialize("commonButtons/common_channel_button_normal","commonButtons/common_channel_button_down",CommonButtonTouchable.CUSTOM);
  self.channel_button2:initializeBMText("市\n黑","anniutuzi",_,_,makePoint(23,50));
  self.channel_button2:setPositionXY(self.channel2_pos.x,self.channel2_pos.y);
  self.channel_button2.touchEnabled=true
  self.channel_button2:addEventListener(DisplayEvents.kTouchTap,self.onChannelButton2Tap,self,a);
  self:addChild(self.channel_button2);

  self.channel_button1=CommonButton.new();
  self.channel_button1:initialize("commonButtons/common_channel_button_normal","commonButtons/common_channel_button_down",CommonButtonTouchable.CUSTOM);
  self.channel_button1:initializeBMText("城\n商","anniutuzi",_,_,makePoint(23,50));
  self.channel_button1:setPositionXY(self.channel1_pos.x,self.channel1_pos.y);
  self.channel_button1.touchEnabled=true
  self:addChild(self.channel_button1);


  self.armature_d:addChildAt(self.gril_bg,2)
  self.gril_bg.touchEnabled = false;
  self.gril_bg:setPositionXY(-50,20) 
  local text_Data = self.armature:getBone("world").textData;
  -- if self.shopType == self.SHOP_TYPE_4 then
  --   text_Data.alignment = kCCTextAlignmentRight
  -- end
  self.timeRemaining = createTextFieldWithTextData(text_Data, "",nil,0);
  self:addChild(self.timeRemaining)

  local sType = self.shopType or 3 
  print("self.shopType", self.shopType)
  local shopItems = analysisByName("Shangdian_Shangdianwupin", "type", sType)
  self.datas = {};
  for k,v in pairs(shopItems) do
    table.insert(self.datas, v);
  end

  local function sortFun(v1, v2)
    if(v1.sort < v2.sort) then
      return true;
    elseif v1.sort > v2.sort then
      return false
    else
      return false;
    end
  end
  table.sort(self.datas, sortFun)


  self.channel_button1:select(true)
  self.channel_button2:select(false)


  local page = nil;
  local itemIndex = nil;
  print("self.itemId", self.itemId)
  if self.itemId then
    self.itemId = tonumber(self.itemId);
    local index = 1;
    for k, v in ipairs(self.datas) do
      print("v.itemid", v.itemid)
      if v.itemid == self.itemId then
        break;
      end
      index = index + 1;
    end

    page = math.ceil(index / 6);
    itemIndex = index % 6;

    print("+++++++++++++++index,itemIndex", index,itemIndex)

    if itemIndex == 0 then
      itemIndex = 6;
    end
  end

  self:yuanbaoshangdian(page, itemIndex);

  if self.shopType == self.SHOP_TYPE_4 then
      self.channel_button1:setVisible(false)
      self.channel_button2:setVisible(false)
      -- self.timeRemaining:setString("当前荣誉值 : "..self.context.userCurrencyProxy:getScore())
      -- self.timeRemaining:setVisible(true)
  end
end

function ShopTwoPopup:setShopType(shopType, itemId)
  self.shopType = shopType
  self.itemId = itemId;
end

function ShopTwoPopup:refreshData()
  if(self.channel==1) then
    self:yuanbaoshangdian();
  else
    self:xianshishangdian();
    self:showTimeRemaining();
  end
end
function ShopTwoPopup:refreshData2()
    if(self.channel==1) then
    self:yuanbaoshangdian();
  else
    self:xianshishangdian();
  end
end

function ShopTwoPopup:yuanbaoshangdian(page, itemIndex)

    if(self.scrollView) then
      self.page=self.scrollView:getCurrentPage()
      self.childLayer:removeChild(self.scrollView);
    end
    self.scrollView=ShopTwoItemPageView.new(CCPageView:create());
    self.scrollView:initialize(self);
    self.scrollView:setPositionXY(332,145);
    self.childLayer:addChild(self.scrollView);
    local function onPageViewScrollStoped()
     self.scrollView:onPageViewScrollStoped();
       if self.boneLightCartoon then
        self:removeChild(self.boneLightCartoon)
        self.boneLightCartoon = nil;
      end
    end
    self.scrollView:registerScrollStopedScriptHandler(onPageViewScrollStoped);
    if(self.pageControl) then
        self.childLayer:removeChild(self.pageControl);
    end

      self.pageControl = self.scrollView.pageViewControl;
      self.pageControl.touchEnabled=false
      self.pageControl.touchChildren=false
      self.childLayer:addChild(self.pageControl);
      print("self.scrollView:getMaxPage()",self.scrollView:getMaxPage())
      if #self.datas<=6 then
        self.pageControl:setVisible(false)
      else
        self.pageControl:setVisible(true)
      end 


  --
    if(page) then
      self.scrollView:update(self.datas, page);
      local xIndex = itemIndex % 3
      local yIndex = math.ceil(itemIndex / 3) == 2 and 0 or 1;
      if xIndex == 0 then
        xIndex = 2;
      else
        xIndex = xIndex - 1;
      end
      self.boneLightCartoon = cartoonPlayer("610",46, 39, 0);
      self.boneLightCartoon.touchEnabled = false;
      self:addChild(self.boneLightCartoon);

      print("xIndex,yIndex,",xIndex,yIndex, itemIndex)
      self.boneLightCartoon:setPositionXY(320+162 + 265*xIndex-23, 160+113+yIndex*235-10);
    elseif self.page then
      self.scrollView:update(self.datas,self.page)
    else
      self.scrollView:update(self.datas)
    end
    self.vipText:setVisible(false)
    self.refresh_button:setVisible(false)
    self.timeRemaining:setVisible(false)
  -- if self.shopType == self.SHOP_TYPE_4 then
  --     self.timeRemaining:setString("当前荣誉值 : "..self.context.userCurrencyProxy:getScore())
  --     self.timeRemaining:setVisible(true)
  -- end
end

function ShopTwoPopup:xianshishangdian()

  if(self.scrollView) then
      self.childLayer:removeChild(self.scrollView);
  end
  self.scrollView=ShopTwoItemPageView.new(CCPageView:create());
  self.scrollView:initialize(self);
  self.scrollView:setPositionXY(332,145);
  self.childLayer:addChild(self.scrollView);
  local function onPageViewScrollStoped()
     self.scrollView:onPageViewScrollStoped();
  end
  self.scrollView:registerScrollStopedScriptHandler(onPageViewScrollStoped);

  self.childLayer:removeChild(self.pageControl);

  self.datas2 = {};
  if(self.shopProxy.IDBooleanArray) then
      for k,v in pairs(self.shopProxy.IDBooleanArray) do
        table.insert(self.datas2, analysis("Shangdian_Shangdianwupin",v.ID));
      end
      local function sortFun(v1, v2)
        if(v1.sort < v2.sort) then
          return true;
        elseif v1.sort > v2.sort then
          return false
        else
          return false;
        end
      end
    table.sort(self.datas2, sortFun)
    self.scrollView:update(self.datas2);
  end
  self.vip=self.userProxy.vipLevel
  self.isOpen = analysis("Huiyuan_Huiyuantequan",14,"vip"..tostring(self.vip))
  if self.isOpen == 0 then
     self.vipText:setVisible(true)
  end
  self.refresh_button:setVisible(true)
  self.timeRemaining:setVisible(true)
 
  
end

function ShopTwoPopup:onChannelButton1Tap(event)
  if event then
    MusicUtils:playEffect(7,false);
  end
  self.channel_button1:select(true)
  self.channel_button2:select(false)

  self.channel_button2:addEventListener(DisplayEvents.kTouchTap,self.onChannelButton2Tap,self,a);
  self.channel_button1:removeEventListener(DisplayEvents.kTouchTap,self.onChannelButton1Tap,self,a);
  self:swapChildren(self.channel_button1, self.channel_button2)
  self.channel=1;
  self:yuanbaoshangdian()
end

function ShopTwoPopup:onChannelButton2Tap(event)
  if event then
    MusicUtils:playEffect(7,false);
  end
  self.channel_button1:select(false)
  self.channel_button2:select(true)
  self.channel_button1:addEventListener(DisplayEvents.kTouchTap,self.onChannelButton1Tap,self,a);
  self.channel_button2:removeEventListener(DisplayEvents.kTouchTap,self.onChannelButton2Tap,self,a);
  self:swapChildren(self.channel_button1, self.channel_button2)
  self.channel=2;
  sendMessage(24,1);
  hecDC(3,14,2)
end

function ShopTwoPopup:shopTwoItemClick(item,callBack)
      self.layer=Layer.new();
      self.layer:initLayer();
      self.layer.touchEnabled=true;
      local mainSize = Director:sharedDirector():getWinSize();
      self.layer:setContentSize(CCSizeMake(mainSize.width, mainSize.height));
      self.layer:addEventListener(DisplayEvents.kTouchTap,self.closeTip,self,a);
      self:addChild(self.layer)
  self:dispatchEvent(Event.new("SHOPTWO_ITEM_CLICK",{item=item,callBack=callBack, showButton = true},self))
end

function ShopTwoPopup:closeTip()
  self:dispatchEvent(Event.new("CLOSETIP",itemid,self))
  
  self:removeChild(self.layer)
end
function ShopTwoPopup:onUIClose()
  Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timerHandler);
  self.timerHandler=nil;
  self:dispatchEvent(Event.new("ShopTwoClose",nil,self));
end

function ShopTwoPopup:fresh()

  if self.isOpen == 1 then
    self.cost=analysis("Xishuhuizong_Xishubiao",1039,"constant")
    local commonPopup=CommonPopup.new();
    commonPopup:initialize("确定花" .. self.cost .. "元宝刷新物品吗？",self,self.onConfirm,nil,self.onCancel,nil,nil,{"确认","取消"},nil,true,false);
    self.context.parent:addChild(commonPopup);
  else
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_512, {6}));
  end
end

function ShopTwoPopup:onConfirm()
  local money=self.context.userCurrencyProxy.gold
  if(money<self.cost) then
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_514));
    self:dispatchEvent(Event.new("gotochongzhi",nil,self));
  else
    sendMessage(24,2);
  end
end
function ShopTwoPopup:showTimeRemaining()
 
        self.remainSeconds=self.shopProxy.RemainSeconds
          local hour=math.floor(self.remainSeconds/3600);
          local minute=math.floor((self.remainSeconds-3600*hour)/60)
          local second=self.remainSeconds-3600*hour-60*minute;
          if(hour<10) then
             self.hour_str="0"..tostring(hour);
          else 
            self.hour_str=tostring(hour);
          end
          if(minute<10) then
            self.minute_str="0"..tostring(minute);
          else 
            self.minute_str=tostring(minute);
          end
          if(second<10) then
            self.second_str="0"..tostring(second);
          else 
            self.second_str=tostring(second);
          end
          self.timeRemaining:setString("下次自动刷新倒计时:"..self.hour_str..":"..self.minute_str..":"..self.second_str);
      local function timerLoop()
        self.remainSeconds=self.remainSeconds-1
        if self.remainSeconds<= 0 then
              Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timerHandler);
              self.timerHandler=nil
              sendMessage(24,1); 
        else
          local hour=math.floor(self.remainSeconds/3600);
          local minute=math.floor((self.remainSeconds-3600*hour)/60)
          local second=self.remainSeconds-3600*hour-60*minute;
          if(hour<10) then
             self.hour_str="0"..tostring(hour);
          else 
            self.hour_str=tostring(hour);
          end
          if(minute<10) then
            self.minute_str="0"..tostring(minute);
          else 
            self.minute_str=tostring(minute);
          end
          if(second<10) then
            self.second_str="0"..tostring(second);
          else 
            self.second_str=tostring(second);
          end
          self.timeRemaining:setString("下次自动刷新倒计时:"..self.hour_str..":"..self.minute_str..":"..self.second_str);
        end
      end
    if(self.timerHandler==nil) then
      self.timerHandler = Director:sharedDirector():getScheduler():scheduleScriptFunc(timerLoop, 1, false)
    end
    

end
function ShopTwoPopup:gotochongzhi()
  self:dispatchEvent(Event.new("gotochongzhi",nil,self));
end
function ShopTwoPopup:gotodianjin()
  self:dispatchEvent(Event.new("gotodianjin",nil,self));
end