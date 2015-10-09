BangpaiRedDotRefreshCommand=class(Command);

function BangpaiRedDotRefreshCommand:ctor()
	self.class=BangpaiRedDotRefreshCommand;
end

function BangpaiRedDotRefreshCommand:execute(notification)
	if ButtonGroupMediator then
		local buttonGroupMediator = self:retrieveMediator(ButtonGroupMediator.name);
		if buttonGroupMediator then
			buttonGroupMediator:getViewComponent():setRedDotByBangpai();
		end
	end
	local familyProxy = self:retrieveProxy(FamilyProxy.name);
	local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
	local userProxy = self:retrieveProxy(UserProxy.name);
	if familyProxy.family_npc_hongdian then
		familyProxy.family_npc_hongdian:setVisible(heroHouseProxy.Hongidan_Huoyuedu or (heroHouseProxy.Hongidan_Shenqingdu and userProxy:getHasQuanxian(1)));
	end

	if BangpaiMediator then
		local bangpaiMediator = self:retrieveMediator(BangpaiMediator.name);
		if bangpaiMediator then
			bangpaiMediator:getViewComponent():refreshRedDot();
		end
	end
end