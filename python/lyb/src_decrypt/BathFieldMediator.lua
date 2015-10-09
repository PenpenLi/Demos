require "main.view.family.bathField.ui.BathFieldLayer"

BathFieldMediator = class(Mediator)

function BathFieldMediator:ctor()
	self.class = BathFieldMediator;
	self.viewComponent = BathFieldLayer.new();
	self.isAttend = false;
end
rawset(BathFieldMediator,"name","BathFieldMediator");

function BathFieldMediator:onRegister()
	self.viewComponent:addEventListener("SummonLittleBuddy",self.onSummonBuddy,self);
	self.viewComponent:addEventListener("SummonBeauty",self.onSummonBeauty,self);
	self.viewComponent:addEventListener("BATHFIELD_CLOSE",self.onClose,self);
	self.viewComponent:addEventListener("INTO_BATH_POOL",self.onIntoPool,self);
end

function BathFieldMediator:initialize(skeleton,userCurrencyProxy)
	self.viewComponent:initialize(skeleton,userCurrencyProxy);
end

function BathFieldMediator:onRemove()
	if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
	self.viewComponent = nil;
end

function BathFieldMediator:onSummonBeauty()	--召唤美女
	sendMessage(27,53);
end

function BathFieldMediator:onSummonBuddy(evt)
	self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_SEND,evt.data));
end

function BathFieldMediator:onClose()
	if self.isAttend then
		sendMessage(27,54);	--用于服务器标识玩家是否加入泡澡以后离开界面
	end
	self:sendNotification(BathFieldNotification.new(BathFieldNotifications.BATH_FIELD_CLOSE));
end

function BathFieldMediator:updatePlayers(otherPlayerInfos,playerInfo)
	self:getViewComponent():updatePlayers(otherPlayerInfos,playerInfo);
end

function BathFieldMediator:setTouchStatus(bool)
	self:getViewComponent():setTouchStatus(bool);
end

function BathFieldMediator:onIntoPool(evt)	--请求进入
	self.isAttend = true;
	sendMessage(27,51);
end

function BathFieldMediator:onResault(gain)
	self:getViewComponent():onResault(gain);
end
