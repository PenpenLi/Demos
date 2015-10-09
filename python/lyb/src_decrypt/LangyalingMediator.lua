require "main.view.langyaling.ui.LangyalingPopup";

LangyalingMediator=class(Mediator);

function LangyalingMediator:ctor()
	self.class = LangyalingMediator;
	self.viewComponent = LangyalingPopup.new();
end

rawset(LangyalingMediator,"name","LangyalingMediator");

function LangyalingMediator:onRegister()

	local viewComponent = self:getViewComponent();
	if not viewComponent or viewComponent and not viewComponent.addEventListener then
		self:onUIColse({data = {}});
		return;
	end
	
	viewComponent:addEventListener(LangyalingNotifications.CLOSE_UI_LANGYALING,self.onUIColse,self);
	viewComponent:addEventListener("TO_VIP",self.onToVip,self);
	viewComponent:addEventListener("TO_DIANJINSHOU",self.onToDianjinshou,self);
	viewComponent:addEventListener("TO_REFRESH_REDDOT",self.onRefreshReddot,self);
	viewComponent:addEventListener("ON_ITEM_TIP",self.onItemTips,self);
	
end

function LangyalingMediator:onUIColse(event)
	self:sendNotification(LangyalingNotification.new(LangyalingNotifications.CLOSE_UI_LANGYALING, event.data));
end

function LangyalingMediator:onRemove()
	local viewComponent = self:getViewComponent();
	if not viewComponent then
		return;
	end

	if self:getViewComponent().parent then
    	self:getViewComponent().parent:removeChild(self:getViewComponent());
	end
end

-- 返回抽卡结果
function LangyalingMediator:popCard(cardArray)
    self:getViewComponent():popClickLayer(cardArray)
end

function LangyalingMediator:onToVip(event)
	self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_VIP));
end

function LangyalingMediator:onToDianjinshou(event)
	self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPEN_HAND_OF_MIDAS_UI, {showCurrency = false}));
end

function LangyalingMediator:onRefreshReddot(event)
	self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_REFRESH_REDDOT,{type=FunctionConfig.FUNCTION_ID_12}));
end
function LangyalingMediator:refreshCurrency()
	self:getViewComponent():refreshCurrency()
end

function LangyalingMediator:onItemTips(event)
  	self:sendNotification(TipNotification.new(TipNotifications.OPEN_TIP_COMMOND, event.data));
end

function LangyalingMediator:setIsPopupLayer()
	if self:getViewComponent().cardsLayer then
		self:getViewComponent().cardsLayer.isPopupLayer = false
	end
end

