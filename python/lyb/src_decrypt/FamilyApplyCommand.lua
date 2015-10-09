--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyApplyCommand=class(Command);

function FamilyApplyCommand:ctor()
	self.class=FamilyApplyCommand;
end

function FamilyApplyCommand:execute(notification)
  local data=notification:getData();
  print("familyApplyCommand",data.FamilyId,data.UserId,data.UserName,data.BooleanValue);
  local userProxy = self:retrieveProxy(UserProxy.name);
  if(connectBoo) then
  	if 0 == userProxy:getFamilyPositionID() then
  		sendMessage(27,14,data);
  	else
  		sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_287));
  	end
  end
end