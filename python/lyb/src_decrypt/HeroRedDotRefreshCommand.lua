HeroRedDotRefreshCommand=class(Command);

function HeroRedDotRefreshCommand:ctor()
	self.class=HeroRedDotRefreshCommand;
end

function HeroRedDotRefreshCommand:execute(notification)
	local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
	if ButtonGroupMediator then
		local buttonGroupMediator = self:retrieveMediator(ButtonGroupMediator.name);
		if buttonGroupMediator then
			buttonGroupMediator:getViewComponent():setRedDotByHero();
			buttonGroupMediator:getViewComponent():setRedDotByStrengthen();
			buttonGroupMediator:getViewComponent():setRedDotByBangpai();
		end
	end
	if HeroHousePopupMediator then
		local heroHousePopupMediator = self:retrieveMediator(HeroHousePopupMediator.name);
		if heroHousePopupMediator then
			heroHousePopupMediator:getViewComponent():refreshRedDot();
		end
	end
	if HeroProPopupMediator then
		local heroProPopupMediator = self:retrieveMediator(HeroProPopupMediator.name);
		if heroProPopupMediator then
			heroProPopupMediator:getViewComponent():refreshRedDotGeneral();
		end
	end
	if StrengthenPopupMediator then
		local strengthenPopupMediator = self:retrieveMediator(StrengthenPopupMediator.name);
		if strengthenPopupMediator then
			strengthenPopupMediator:getViewComponent():refreshRedDot();
		end
	end
	-- if BangpaiMediator then
	-- 	local bangpaiMediator = self:retrieveMediator(BangpaiMediator.name);
	-- 	if bangpaiMediator then
	-- 		bangpaiMediator:getViewComponent():refreshRedDot();
	-- 	end
	-- end
end