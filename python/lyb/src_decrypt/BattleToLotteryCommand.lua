

BattleToLotteryCommand=class(Command);

function BattleToLotteryCommand:ctor()
	self.class=BattleToLotteryCommand;
end

function BattleToLotteryCommand:execute(notification)
	require "main.model.Battle.LotteryProxy"
	local flipType = notification:getData()["flipType"]
	local lotteryProxy = self:retrieveProxy(LotteryProxy.name);
	if nil == lotteryProxy then
		lotteryProxy = LotteryProxy.new();
		self:registerProxy(lotteryProxy:getProxyName(),lotteryProxy);
	end	
	local battleProxy = self:retrieveProxy(BattleProxy.name);
	local currencyProxy = self:retrieveProxy(UserCurrencyProxy.name);
	require "main.view.battleScene.lottery.LotteryMediator"
	local mediator = self:retrieveMediator(LotteryMediator.name);
	if nil == mediator then
		mediator = LotteryMediator.new();
		self:registerMediator(mediator:getMediatorName(),mediator);
	end
	
	local countProxy = self:retrieveProxy(CountControlProxy.name);
	mediator:initializeUI(lotteryProxy,battleProxy,currencyProxy,countProxy);
	sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_UI):addChild(mediator:getViewComponent());
end