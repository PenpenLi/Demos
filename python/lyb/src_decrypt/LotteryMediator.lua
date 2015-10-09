


LotteryMediator = class (Mediator)

function LotteryMediator:ctor()
	require "main.view.battleScene.lottery.ui.LotteryUI"
  self.class = LotteryMediator;
  self.viewComponent = nil;
end

rawset (LotteryMediator,"name","LotteryMediator");

function LotteryMediator:onRegister()
  self.viewComponent = LotteryUI.new();
  self.viewComponent:addEventListener("ENTER_BATTLE_FIELD",self.enterBattleField,self)
  self.viewComponent:addEventListener("QUIT_BATTLE_FIELD",self.quitBattleField,self)
  self.viewComponent:addEventListener("CLOSE_LOTTERY_MEDIATOR",self.closeLotteryMediator,self)
  self.viewComponent:addEventListener("SEND_MESSAGE_FOR_CHARGE_BOX",self.sendMessageForChargeBox,self)
  
end

function LotteryMediator:onRemove()
	if self.viewComponent.parent then
	    self.viewComponent.parent:removeChild(self.viewComponent);	
	end
end

function LotteryMediator:initializeUI(lotteryProxy,battleProxy,currencyProxy,countProxy)
	self.viewComponent:initializeUI(lotteryProxy,battleProxy,currencyProxy,countProxy);
end

function LotteryMediator:refreshUI(boo,itemId,count)
	if not boo then
		self.viewComponent:refreshFreeUI();
		self.viewComponent:showGainItem(itemId,count);
	end
end

function LotteryMediator:refreshUserCurrency(userCurrency)
	self.viewComponent:refreshUserCurrency(userCurrency);
end

function LotteryMediator:enterBattleField(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_BATTLE, event.data));
end

function LotteryMediator:quitBattleField(event)
  self:sendNotification(BattleSceneNotification.new(BattleSceneNotifications.TO_MAINSCENE));
end
function LotteryMediator:closeLotteryMediator(event)
  self:sendNotification(BattleSceneNotification.new(BattleSceneNotifications.CLOSE_LOTTERY_MEDIATOR));
end
function LotteryMediator:sendMessageForChargeBox(event)
  self:sendNotification(BattleSceneNotification.new(BattleSceneNotifications.SEND_MESSAGE_FOR_CHARGE_BOX,event.data));
end

-- 刷新关卡次数
-- function LotteryMediator:refreshCount(strongPiontCount)
	-- self.viewComponent:refreshCount(strongPiontCount);
-- end
function LotteryMediator:addHaveBuyItem(boo,index)
	self.viewComponent:addHaveBuyItem(boo,index);
end
-- 刷新体力
-- function LotteryMediator:refreshTili(tili)
	-- self.viewComponent:refreshTili(tili);
-- end
function LotteryMediator:showGainItem(ItemIdArray)
	self.viewComponent:showGainItem(ItemIdArray);
end