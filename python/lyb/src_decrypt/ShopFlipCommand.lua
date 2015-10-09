--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-8-21

	yanchuan.xie@happyelements.com
]]

ShopFlipCommand=class(MacroCommand);

function ShopFlipCommand:ctor()
	self.class=ShopFlipCommand;
end

function ShopFlipCommand:execute(notification)
  self:addSubCommand(OpenShopUICommand);
  self:complete();
  self:retrieveMediator(ShopMediator.name):flipByItemID(notification:getData().ItemId);
end