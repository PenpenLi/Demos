--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

require "main.controller.notification.TipNotification";
require "main.view.activity.ui.ActivityPopup";

ActivityMediator=class(Mediator);

function ActivityMediator:ctor()
  self.class=ActivityMediator;
  self.viewComponent=ActivityPopup.new();
end

rawset(ActivityMediator,"name","ActivityMediator");

function ActivityMediator:intializeUI(skeleton, activityProxy, countControlProxy, bagProxy, itemUseQueueProxy, generalListProxy, userCurrencyProxy, userDataAccumulateProxy)
  self:getViewComponent():initializeUI(skeleton,activityProxy,countControlProxy,bagProxy,itemUseQueueProxy, generalListProxy, userCurrencyProxy, userDataAccumulateProxy);
end

function ActivityMediator:onToAutoGuide(event)
  self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,event.data));
end

function ActivityMediator:onClose(event)
  self:sendNotification(ActivityNotification.new(ActivityNotifications.ACTIVITY_CLOSE));
end

function ActivityMediator:onRegister()
  self:getViewComponent():initialize();
  self:onSignInLayerRegister();
  self:onLevelGiftRegister();
  self:onRegisterActivityGift();
  self:onDownloadGiftRegister();
  --self:onAmassFortunesRegister();
  --self:onSlotRegister();
  self:onCDKeyRegister();
  self:getViewComponent():addEventListener(TipNotifications.OPEN_TIP_COMMOND,self.popTip,self);
  self:getViewComponent():addEventListener(TipNotifications.REMOVE_TIP_COMMOND,self.closeTip,self);
  self:getViewComponent():addEventListener("TO_AUTO_GUIDE",self.onToAutoGuide,self);
  self:getViewComponent():addEventListener(ActivityNotifications.ACTIVITY_CLOSE,self.onClose,self);
end

function ActivityMediator:onRemove()
	if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end

------------------------------------------------公共--------------------------------------------------------------

function ActivityMediator:changeTab(id)
  self:getViewComponent():changeTab(id);
end

function ActivityMediator:changeTabToUpdate()
  self:getViewComponent():changeTabToUpdate();
end

function ActivityMediator:closeTip(event)
  self:sendNotification(TipNotification.new(TipNotifications.REMOVE_TIP_COMMOND));
end

function ActivityMediator:popTip(event)
  self:sendNotification(TipNotification.new(TipNotifications.OPEN_TIP_COMMOND,event.data));
end

function ActivityMediator:refreshActivity()
  self:getViewComponent():refreshActivity();
end

------------------------------------------------签到奖励--------------------------------------------------------------

function ActivityMediator:onSignInLayerRegister()
  self:getViewComponent():addEventListener(ActivityNotifications.SIGN_IN_REQUEST_DATA,self.onSignInRequestData,self);
  self:getViewComponent():addEventListener(ActivityNotifications.SIGN_IN_REQUEST_CARD_DATA,self.onSignInRequestCardData,self);
  self:getViewComponent():addEventListener(ActivityNotifications.SIGN_IN_GET_ROW_BONUS,self.onGetRowBonus,self);
    self:getViewComponent():addEventListener("Tutor_download",self.onTutorDownload,self);
  self:getViewComponent():addEventListener("vip_recharge",self.onRecharge,self);
end


function ActivityMediator:onTutorDownload(event)

end
function ActivityMediator:onSignInRequestData(event)
  self:sendNotification(ActivityNotification.new(ActivityNotifications.SIGN_IN_REQUEST_DATA));
end

function ActivityMediator:onSignInRequestCardData(event)
  self:sendNotification(ActivityNotification.new(ActivityNotifications.SIGN_IN_REQUEST_CARD_DATA,event.data));
end

function ActivityMediator:onGetRowBonus(event)
  self:sendNotification(ActivityNotification.new(ActivityNotifications.SIGN_IN_GET_ROW_BONUS,event.data));
end

--更新签到抽奖
function ActivityMediator:refreshSignInData()
  self:getViewComponent():refreshSignInData();
end

------------------------------------------------招财进宝--------------------------------------------------------------
--[[
function ActivityMediator:onAmassFortunesRegister()
  self:getViewComponent():addEventListener(ActivityNotifications.AMASS_FORTUNES_REQUEST_DATA, self.onAmassFortuneRequestData, self);

end

function ActivityMediator:onAmassFortuneRequestData(event)
  self:sendNotification(ActivityNotification.new(ActivityNotifications.AMASS_FORTUNES_REQUEST_DATA, event.data));
end

function ActivityMediator:refreshAmassFortuneData(gold)
  self:getViewComponent():refreshAmassFortuneData(gold)
end

--第几次玩老虎机
function ActivityMediator:refreshAmassFortunesCount(gold)
  self:getViewComponent():refreshAmassFortunesCount(gold)
end

function ActivityMediator:refreshOtherAmassFortune(data)
  self:getViewComponent():refreshOtherAmassFortune(data)
end
]]
------------------------------------------------消费返利--------------------------------------------------------------
function ActivityMediator:refreshExpense()
  self:getViewComponent():refreshExpense()
end
------------------------------------------------充值返利--------------------------------------------------------------
function ActivityMediator:refreshPay()
  self:getViewComponent():refreshPay()
end
function ActivityMediator:onRecharge()
    self:sendNotification(MainSceneNotification.new(MainSceneNotifications.OPEN_PLATFORM_CHARGE_UI_COMMAND));
end
------------------------------------------------等级礼包--------------------------------------------------------------

function ActivityMediator:onLevelGiftRequestData(event)
  self:sendNotification(ActivityNotification.new(ActivityNotifications.LEVEL_GIFT_REQUEST_DATA));
end

function ActivityMediator:onLevelGiftGetBonus(event)
  self:sendNotification(ActivityNotification.new(ActivityNotifications.LEVEL_GIFT_GET_BONUS,event.data));
end

function ActivityMediator:refreshLevelGift()
  self:getViewComponent():refreshLevelGift();
end

function ActivityMediator:refreshLevelGift4Fetched(level)
  self:getViewComponent():refreshLevelGift4Fetched(level);
end

function ActivityMediator:onLevelGiftRegister()
  self:getViewComponent():addEventListener(ActivityNotifications.LEVEL_GIFT_REQUEST_DATA,self.onLevelGiftRequestData,self);
  self:getViewComponent():addEventListener(ActivityNotifications.LEVEL_GIFT_GET_BONUS,self.onLevelGiftGetBonus,self);
end

------------------------------------------------下载礼包--------------------------------------------------------------

function ActivityMediator:onDownloadGiftRequestData(event)
  self:sendNotification(ActivityNotification.new(ActivityNotifications.DOWNLOAD_GIFT_REQUEST_DATA));
end

function ActivityMediator:onDownloadGiftGetBonus(event)
  self:sendNotification(ActivityNotification.new(ActivityNotifications.DOWNLOAD_GIFT_GET_BONUS,event.data));
end

function ActivityMediator:refreshDownloadGift()
  self:getViewComponent():refreshDownloadGift();
end

function ActivityMediator:onDownloadGiftRegister()
  self:getViewComponent():addEventListener(ActivityNotifications.DOWNLOAD_GIFT_REQUEST_DATA,self.onDownloadGiftRequestData,self);
  self:getViewComponent():addEventListener(ActivityNotifications.DOWNLOAD_GIFT_GET_BONUS,self.onDownloadGiftGetBonus,self);
end

------------------------------------------------老虎机--------------------------------------------------------------
--[[
function ActivityMediator:onSlotBroadcast(event)
  self:sendNotification(ActivityNotification.new(ActivityNotifications.ACTIVITY_BROADCAST,event.data));
end

function ActivityMediator:onSlotRegister()
  self:getViewComponent():addEventListener(ActivityNotifications.ACTIVITY_BROADCAST,self.onSlotBroadcast,self);
end
]]

------------------------------------------------系统奖励-------------------------------------------------------------

function ActivityMediator:onRegisterActivityGift()
	self:getViewComponent():addEventListener("getReward",self.getReward,self);
  self:getViewComponent():addEventListener("toBag",self.toBag,self);
end

function ActivityMediator:refreshRewardData(rewardTable, timerRewardTable, retainTable)
	self:getViewComponent():refreshRewardData(rewardTable, timerRewardTable, retainTable);
end

function ActivityMediator:gainReward(ID)
  self:getViewComponent():gainReward(ID);
end

function ActivityMediator:toBag()
	self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_AVATAR))
end

function ActivityMediator:getReward(event)
	self:sendNotification(ActivityNotification.new(ActivityNotifications.GETREWARD,event.data));

end

function ActivityMediator:restartActivityGiftLayer()
  uninitializeSmallLoading();
  if self:getViewComponent().layers[10] then
    if self:getViewComponent().layers[10].parent then
      self:getViewComponent().layers[10].parent:removeChild(self:getViewComponent().layers[10]);
      self:getViewComponent().layers[10] = nil;
      self:getViewComponent():onItemTap(10);
    end
  end
end

------------------------------------------------CDKey-------------------------------------------------------------

function ActivityMediator:onCDKeyGetBonus(event)
  self:sendNotification(ActivityNotification.new(ActivityNotifications.CD_KEY_GET_BONUS,event.data));
end

function ActivityMediator:onCDKeyRegister()
  self:getViewComponent():addEventListener(ActivityNotifications.CD_KEY_GET_BONUS,self.onCDKeyGetBonus,self);
end

function ActivityMediator:getItemXYById(id)
  return self:getViewComponent():getItemXYById(id);
end
