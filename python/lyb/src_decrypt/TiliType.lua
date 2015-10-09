require "main.view.mainScene.component.ui.CurrencyGroupUI";
require "main.view.mainScene.addTili.AddTiliUI";
require "main.view.tip.ui.SmallTip";

TiliType = {TILI = 1,
			ARENA = 2,
			FAMILYCONTRIBUTE = 3}

CurrencyGroupMediator = class(Mediator)

function CurrencyGroupMediator:ctor()
	self.class = CurrencyGroupMediator
	self.tiliType = TiliType.TILI;
end

rawset(CurrencyGroupMediator,"name","CurrencyGroupMediator")

function CurrencyGroupMediator:onRegister()
	self.viewComponent = CurrencyGroupUI.new()
  local proxyRetriever  = ProxyRetriever.new();

  self.userCurrencyProxy=proxyRetriever:retrieveProxy(UserCurrencyProxy.name);
  self.userProxy = proxyRetriever:retrieveProxy(UserProxy.name);
  self.bagProxy=proxyRetriever:retrieveProxy(BagProxy.name);
  self.countControlProxy=proxyRetriever:retrieveProxy(CountControlProxy.name);
  self.openFunctionProxy = proxyRetriever:retrieveProxy(OpenFunctionProxy.name)
end


function CurrencyGroupMediator:initialize()
	self.viewComponent:initialize()
	self.viewComponent.jia_yuanbaoDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
	self.viewComponent.yuanbao_bantouDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
	self.viewComponent.tili_bantouDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
	self.viewComponent.jia_yingliangDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
	self.viewComponent.jia_tiliDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
	self.viewComponent.tili_bantouDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
	self.viewComponent.yingliang_bantouDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
end

function CurrencyGroupMediator:setHuobiText()
	self.viewComponent:setHuobiText()
	-- if self.isAreaRongYu then
	if self.tiliType == TiliType.ARENA then
		self:refreshAreaRongYu()
	elseif self.tiliType == TiliType.ARENA then
		self.viewComponent:refreshFamilyContribute(false)
	end
end

function CurrencyGroupMediator:refreshAreaRongYu()
	-- self.isAreaRongYu = true
	self.tiliType = TiliType.ARENA;
	self.viewComponent:refreshAreaRongYu(false)
end

function CurrencyGroupMediator:areaExitRongYu()
	-- self.isAreaRongYu = nil
	self.tiliType = TiliType.TILI;
	self.viewComponent:refreshAreaRongYu(true)
end


function CurrencyGroupMediator:refreshFamilyContribute(bool)
	--false时候，刷成帮贡条，true时刷成体力条
	if bool == false then
		self.tiliType = TiliType.FAMILYCONTRIBUTE;
	else
		self.tiliType = TiliType.TILI;
	end
	self.viewComponent:refreshFamilyContribute(bool)
end

function CurrencyGroupMediator:onTipsBegin(event)
  	--self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_VIP));
  	 local targetName = event.target.name
    if targetName ~= "tili_bantou" or  targetName ~= "yuanbao_bantou" or  targetName ~= "yingliang_bantou" then
        event.target:setScale(0.88);
    else
	
	end
	event.target:addEventListener(DisplayEvents.kTouchEnd,self.onTipsEnd,self);
end

function CurrencyGroupMediator:onTipsEnd(event)
	event.target:setScale(1);
	event.target:removeEventListener(DisplayEvents.kTouchEnd,self.onTipsEnd,self);

	local targetName = event.target.name
	print("MainSceneMediator:onTipsEnd",targetName)
	if targetName == "chongzhi_button" then
  		self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_VIP));
	elseif  targetName == "yuanbao_bantou" then
		self.smallTip = SmallTip.new();
		event.globalPosition.y = event.globalPosition.y+GameData.uiOffsetY*2;
		self.smallTip:initialize("元宝：" .. self.userCurrencyProxy.gold, event.globalPosition);
		self.viewComponent:addChild(self.smallTip)
		print("yuanbao_bantou")
	elseif targetName == "jia_yuanbao"  then
	  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_VIP));
	elseif targetName == "jia_tili" then
		self:onAddTili();
	elseif targetName == "tili_bantou" then
		-- if not self.isAreaRongYu then
		if self.tiliType == TiliType.TILI then
	  		local addTiliUI = AddTiliUI.new();
	  		addTiliUI:initializeUI(self.userCurrencyProxy, self.countControlProxy);
	  		sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_ASSIST):addChild(addTiliUI);
  		elseif self.tiliType == TiliType.ARENA then
	  		self.smallTip = SmallTip.new();
	  		self.smallTip:initialize("荣誉值：" .. self.userCurrencyProxy:getScore(), event.globalPosition);
	  		self.viewComponent:addChild(self.smallTip)
	  	elseif self.tiliType == TiliType.FAMILYCONTRIBUTE then
	  		self.smallTip = SmallTip.new();
	  		self.smallTip:initialize("帮贡值：" .. self.userCurrencyProxy:getValueByMoneyType(10), event.globalPosition);
	  		self.viewComponent:addChild(self.smallTip)
		end
	elseif targetName == "yingliang_bantou" then
		self.smallTip = SmallTip.new();
		event.globalPosition.y = event.globalPosition.y+GameData.uiOffsetY*2;
		self.smallTip:initialize("银两：" .. self.userCurrencyProxy.silver, event.globalPosition);
		self.viewComponent:addChild(self.smallTip)
		print("yingliang_bantou")
	elseif targetName == "jia_yingliang"  then
		if self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_27) then
			self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPEN_HAND_OF_MIDAS_UI));
		else
			sharedTextAnimateReward():animateStartByString("功能尚未开启");
		end
	end
	MusicUtils:playEffect(7,false)
end

function CurrencyGroupMediator:onAddTili()
  onHandleAddTili({type = 1})
  if GameVar.tutorStage == TutorConfig.STAGE_2014 then
	openTutorUI({x=544, y=210, width = 190, height = 60, alpha = 125});
  end
end


function CurrencyGroupMediator:onRemove()
	if self:getViewComponent().parent then
    	self:getViewComponent().parent:removeChild(self:getViewComponent());
  	end
end
