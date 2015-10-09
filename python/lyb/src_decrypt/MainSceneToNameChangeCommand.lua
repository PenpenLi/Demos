--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-1-31

	yanchuan.xie@happyelements.com
]]

MainSceneToNameChangeCommand=class(MacroCommand);

function MainSceneToNameChangeCommand:ctor()
	self.class=MainSceneToNameChangeCommand;
end

function MainSceneToNameChangeCommand:execute()
  self:require();
  local bagChangeNamePopup=BagChangeNamePopup.new();
  bagChangeNamePopup:initialize(self:retrieveProxy(BagProxy.name),self:retrieveProxy(UserCurrencyProxy.name),self:retrieveProxy(ShopProxy.name),self,self.onConfirm,self.onCancle,self.onToCharge);
  sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(bagChangeNamePopup);
end

function MainSceneToNameChangeCommand:onConfirm(s)
	sendMessage(3,30,{UserName=s});
end

function MainSceneToNameChangeCommand:onCancle()

end

function MainSceneToNameChangeCommand:onToCharge()
	self:addSubCommand(OpenPlatformChargeCommand);
	self:complete();
end

function MainSceneToNameChangeCommand:require()
  require "main.view.bag.ui.bagPopup.BagChangeNamePopup";
end