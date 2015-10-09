

VipGiftNoticeCommand=class(MacroCommand);

function VipGiftNoticeCommand:ctor()
	self.class=VipGiftNoticeCommand;
end

function VipGiftNoticeCommand:execute(notification)
 --  local countProxy = self:retrieveProxy(CountControlProxy.name);
	-- local vipProxy = self:retrieveProxy(VipProxy.name);
	-- local userProxy = self:retrieveProxy(UserProxy.name);
	
	-- local vipLevel = userProxy:getVipLevel();
	-- for i = 1,vipLevel do
	-- 	-- print("VipGiftNoticeCommand",i,countProxy:getRemainCountByID(CountControlConfig.Vip,i))
	-- 	if 0 ~= countProxy:getRemainCountByID(CountControlConfig.Vip,i) then
	-- 		vipProxy.notice = true;
	-- 		self:addSubCommand(MainSceneIconEffectCommand);
	-- 		self:complete("vip");
	-- 		break;
	-- 	end
	-- end
end