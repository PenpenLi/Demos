--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

require "core.utils.LayerColorBackGround";
require "main.view.activity.ui.SignInLayer";
require "main.view.activity.ui.LevelGiftLayer";
require "main.view.activity.ui.ActivityItem";
--require "main.view.activity.ui.amassFortunes.AmassFortunesLayer";
require "main.view.activity.ui.ExpenseRebateLayer";
require "main.view.activity.ui.PayRebateLayer";
require "main.view.activity.ui.DownloadGiftLayer";
require "main.view.activity.ui.activityGift.ActivityGiftLayer";
require "main.view.activity.ui.cdKey.CDKeyLayer";
-- require "main.view.activity.ui.show.ShowActivityLayer";
require "main.view.bag.ui.bagPopup.CurrencyItem";
require "main.view.tip.ui.AdaptableTip";

ActivityPopup=class(TouchLayer);

function ActivityPopup:ctor()
  self.class=ActivityPopup;
end

function ActivityPopup:dispose()
  self:onItemTap(0);
  for k,v in pairs(self.layers) do
    v:dispose();
  end
  LittleHelperCloseCommand.new():execute();
  self:removeAllEventListeners();
  self:removeChildren();
  ActivityPopup.superclass.dispose(self);
  self.armature4dispose:dispose();
  BitmapCacher:removeUnused();
end

function ActivityPopup:initialize()
  self:initLayer();
end

function ActivityPopup:initializeUI(skeleton, activityProxy, countControlProxy, bagProxy, itemUseQueueProxy, generalListProxy, userCurrencyProxy, userDataAccumulateProxy)
  self.skeleton=skeleton;
  self.activityProxy=activityProxy;
  self.countControlProxy=countControlProxy;
  self.bagProxy=bagProxy;
  self.itemUseQueueProxy=itemUseQueueProxy;
  self.generalListProxy=generalListProxy;
  self.userCurrencyProxy = userCurrencyProxy;
  self.userDataAccumulateProxy = userDataAccumulateProxy;
  self.const_item_num=5.4;
  self.items={};
  self.item_select=nil;
  self.layers={};
  self.subscribe=nil;

  -- local layerColor = LayerColorBackGround:getBackGround()
  --layerColor:setPositionY(5)
  -- self:addChild(layerColor);
  
  --骨骼
  local armature=skeleton:buildArmature("activity_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  AddUIBackGround(self);

  local item=self.armature:getChildByName("common_copy_button_bg_1");
  self.item_size=CommonSkeleton:getBoneTextureDisplay("common_inner_tab_button_down"):getContentSize();
  self.item_size.height=5+self.item_size.height;
  self.item_pos=item:getPosition();

  --closeButton
  local closeButton=self.armature:getChildByName("common_copy_close_button");
  local close_pos=convertBone2LB4Button(closeButton);--closeButton:getPosition();
  self.armature:removeChild(closeButton);
  
  closeButton=CommonButton.new();
  closeButton:initialize("common_close_button_normal","common_close_button_down",CommonButtonTouchable.BUTTON);
  closeButton:setPosition(close_pos);
  closeButton:addEventListener(DisplayEvents.kTouchTap,self.onCloseButtonTap,self);
  self.armature:addChild(closeButton);

  --item
  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPositionXY(self.item_pos.x,self.item_pos.y-self.const_item_num*self.item_size.height);
  self.item_layer:setViewSize(makeSize(self.item_size.width,
                                       self.const_item_num*self.item_size.height));
  self.item_layer:setItemSize(self.item_size);
  self.armature:addChildAt(self.item_layer,4);
  self:refreshActivity();
  --self:setPositionY(-5);

  AddUIFrame(self);  
end

function ActivityPopup:hasPanel(id)
  return nil~=self.layers[id];
end

--移除
function ActivityPopup:onCloseButtonTap(event)

  --[[if self.layers[5] then
    self.layers[5]:disposeTime();
  end
  self:refreshBroadcast(false);]]
  self:dispatchEvent(Event.new(ActivityNotifications.ACTIVITY_CLOSE,nil,self));
end

function ActivityPopup:onItemTap(item_num)
  if self.item_select then
    local selected_num=self.item_select:getNum();
    --活跃度
    -- if 12==selected_num then
    --   LittleHelperCloseCommand.new():execute();
    -- else
      self.armature:removeChild(self:getPanel(selected_num),false);
    -- end
    self.item_select:select(false);
    self.item_select=nil;

  end
  local a=self:getPanel(item_num);
  if a then
    self.item_select=self:getItemByID(item_num);
    self.armature:addChildAt(a,4);
    self.item_select:select(true);
  end
end

function ActivityPopup:closeTip(event)
  if self.tipBg then
    self:removeChild(self.tipBg);
    self.tipBg=nil;
  end
  if self.currency then
    self:removeChild(self.currency);
    self.currency=nil;
  else
    self:dispatchEvent(Event.new(TipNotifications.REMOVE_TIP_COMMOND,nil,self));
  end
end

function ActivityPopup:popTip(itemID, count, position)
  --[[self.tipBg=LayerColorBackGround:getTransBackGround();
  self.tipBg:addEventListener(DisplayEvents.kTouchTap,self.closeTip,self);
  self:addChild(self.tipBg);
  if 1000000<itemID then
    self:dispatchEvent(Event.new(TipNotifications.OPEN_TIP_COMMOND,itemID,self));
  else
    self.currency=CurrencyItem.new();
    self.currency:initialize(self.bagProxy:getSkeleton(),nil,count);
    self.currency:setString(analysis("Daoju_Daojubiao",itemID,"name") .. " " .. count);
    self.currency:setPosition(getTipPosition(self.currency,position));
    self:addChild(self.currency);
  end]]
  self.currency=AdaptableTip.new();
  self.currency:initialize(itemID .. "," .. count,position);
  self:addChild(self.currency);
end

function ActivityPopup:refreshActivity()
  local b=self.activityProxy:getAllActivities();
  if self.item_select then
    if self.activityProxy:getDateByID(self.item_select:getNum()) then

    else
      if 0==table.getn(b) then
        sharedTextAnimateReward():animateStartByString("活动关闭了哦!");
        self:onCloseButtonTap();
        return;
      else
        for k,v in pairs(self.items) do
          if v==self.item_select then
            self:onItemTap();
            self.item_layer:removeItemAt(-1+k,true);
          end
        end
      end
    end
  end
  for k,v in pairs(b) do
    if self:getItemByID(v) then

    else
      local item=ActivityItem.new();
      item:initialize(self.skeleton,self:getPanelNameByID(v),v,self,self.onItemTap,self.parent_container);
      table.insert(self.items,item);
      self.item_layer:addItem(item);
    end
  end
  self.item_layer:removeAllItems();
  local c={};
  for k,v in pairs(self.items) do
    if self.activityProxy:getDateByID(v:getNum()) and v:getNum() ~= 5 then--5是招财进宝
      table.insert(c,v);
    end
  end
  self.items=c;
  for k,v in pairs(self.items) do
    self.item_layer:addItem(v);
  end
  if self.item_select then

  else
    if self.items[1] then
      self:onItemTap(self.items[1]:getNum());
    end
  end
end

function ActivityPopup:getItemByID(id)
  for k,v in pairs(self.items) do
    if id==v:getNum() then
      return v;
    end
  end
end

function ActivityPopup:getPanelNameByID(id)
  return analysis("Huodongbiao_Huodong",id,"name");
end

function ActivityPopup:getIsBagFull(count)
  if not count then count=0; end
  if count>self.bagProxy:getBagLeftPlaceCount(self.itemUseQueueProxy) then
    local a=CommonPopup.new();
    a:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_8),self,self.onToGetSilver,nil,nil,nil,false,{"背包","取消"});
    self:addChild(a);
    --sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_8));
    return true;
  end
  return false;
end

function ActivityPopup:onToGetSilver()
  self.parent_container:dispatchEvent(Event.new("TO_AUTO_GUIDE",{ID=FunctionConfig.FUNCTION_ID_21},self));
end

------------------------------------------------公共--------------------------------------------------------------

function ActivityPopup:changeTab(id)
  for k,v in pairs(self.items) do
    if id==v:getNum() then
      self:onItemTap(id);
      return;
    end
  end
end



function ActivityPopup:getItemXYById(id)
  local xPos, yPos = self.item_pos.x, self.item_pos.y
  local index = 0
  for k,v in ipairs(self.items) do
    index = index + 1
    print("ActivityPopup:index", index)
    if id==v:getNum() then
      print("ActivityPopup:getItemXYById", k)
      xPos, yPos = self.item_pos.x, self.item_pos.y- (k)*self.item_size.height
      break;
    end

  end
  return xPos, yPos
end
function ActivityPopup:changeTabToUpdate()
  local id=FunctionConfig.FUNCTION_ID_100;
  for k,v in pairs(self.items) do
    if id==v:getNum() then
      self:onItemTap(id);
      return;
    end
  end
end

function ActivityPopup:getPanel(num)

  local layer=self.layers[num];
  if layer then
    return layer;
  elseif 1==num or 2==num then
    -- --充值返利
    -- self.layers[num]=PayRebateLayer.new();
    -- self.layers[num]:initialize(self.skeleton,self.activityProxy,self.generalListProxy,self,num);
  elseif 3==num or 4==num then
    -- --消费返利
    -- self.layers[num]=ExpenseRebateLayer.new();
    -- self.layers[num]:initialize(self.skeleton,self.activityProxy,self.generalListProxy,self,num);
  elseif 5==num or 6==num then
    --招财进宝
    --[[self.layers[num] = AmassFortunesLayer.new();
    self.layers[num]:initialize(self.skeleton, self.activityProxy, self.userCurrencyProxy, self.userDataAccumulateProxy, self);
    self:refreshBroadcast(true);]]
  elseif 7==num then
    --签到
    self.layers[num]=SignInLayer.new();
    self.layers[num]:initialize(self.skeleton,self.activityProxy,self.countControlProxy,self);
  elseif 8==num then
    --等级礼包
    self.layers[num]=LevelGiftLayer.new();
    self.layers[num]:initialize(self.skeleton,self.activityProxy,self.generalListProxy,self);
  elseif 9==num then
    --下载奖励
    self.layers[num]=DownloadGiftLayer.new();
    self.layers[num]:initialize(self.skeleton,self.activityProxy,self.generalListProxy,self);
    sendMessage(24, 17)
	elseif 10==num then
		self.layers[num]=ActivityGiftLayer.new();
    self.layers[num]:initialize(self.skeleton,self,self.bagProxy,self.itemUseQueueProxy);
  elseif 11==num then
    self.layers[num]=CDKeyLayer.new();
    self.layers[num]:initialize(self.skeleton,self);
  elseif 12==num then
    -- self.layers[num]=ShowActivityLayer.new();
    -- self.layers[num]:initialize(self.skeleton,self,num);
    MainSceneToLittleHelperCommand.new():execute();
    self.layers[num]=Facade:getInstance():retrieveMediator(LittleHelperMediator.name):getViewComponent();
  end
  return self.layers[num];

end

------------------------------------------------充值返利--------------------------------------------------------------

function ActivityPopup:refreshPay()
  if self:hasPanel(1) then
    self:getPanel(1):refreshPay();
  elseif self:hasPanel(2) then
    self:getPanel(2):refreshPay();
  end
end

------------------------------------------------消费返利--------------------------------------------------------------

function ActivityPopup:refreshExpense()
  if self:hasPanel(3) then
    self:getPanel(3):refreshExpense();
  elseif self:hasPanel(4) then
    self:getPanel(4):refreshExpense();
  end
end

------------------------------------------------招财进宝--------------------------------------------------------------
--[[
function ActivityPopup:refreshAmassFortuneData(gold)
  if self:hasPanel(5) then
    self:getPanel(5):refreshData(gold);
  elseif self:hasPanel(6) then
    self:getPanel(6):refreshData(gold);
  end
end

function ActivityPopup:refreshAmassFortunesCount(gold)
  if self:hasPanel(5) then
    self:getPanel(5):refreshAmassFortunesCount(gold);
  elseif self:hasPanel(6) then
    self:getPanel(6):refreshAmassFortunesCount(gold);
  end
end

function ActivityPopup:refreshOtherAmassFortune(gold)
  if self:hasPanel(5) then
    self:getPanel(5):refreshOtherPlayer(gold);
  elseif self:hasPanel(6) then
    self:getPanel(6):refreshOtherPlayer(gold);
  end
end]]
--[[
function ActivityPopup:refreshBroadcast(bool)
  self:dispatchEvent(Event.new(ActivityNotifications.ACTIVITY_BROADCAST,{Type=bool and 1 or 0},self));
end]]

------------------------------------------------签到奖励--------------------------------------------------------------

--更新签到抽奖
function ActivityPopup:refreshSignInData()
  self:getPanel(7):refresh();
end

function ActivityPopup:onSignInLayerItemTap(item)
  if self:getIsBagFull() then
    return true;
  end
  self:dispatchEvent(Event.new(ActivityNotifications.SIGN_IN_REQUEST_CARD_DATA,{Place=item:getPlace()},self));
end

------------------------------------------------等级礼包--------------------------------------------------------------

function ActivityPopup:refreshLevelGift()
  self:getPanel(8):refreshLevelGift();
end

function ActivityPopup:refreshLevelGift4Fetched(level)
  self:getPanel(8):refreshLevelGift4Fetched(level);
end

------------------------------------------------下载礼包--------------------------------------------------------------

function ActivityPopup:refreshDownloadGift()
  self:getPanel(9):refreshDownloadGift();
end

------------------------------------------------系统奖励--------------------------------------------------------------
function ActivityPopup:refreshRewardData(rewardTable, timerRewardTable, retainTable)
	self:getPanel(10):refreshRewardData(rewardTable, timerRewardTable, retainTable);
end

function ActivityPopup:gainReward(ID)
	self:getPanel(10):gainReward(ID);
end
