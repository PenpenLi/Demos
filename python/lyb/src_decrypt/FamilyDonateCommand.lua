--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyDonateCommand=class(Command);

function FamilyDonateCommand:ctor()
	self.class=FamilyDonateCommand;
end

function FamilyDonateCommand:execute(notification)
  local data=notification:getData();
  print("familyDonateCommand",data.Count);
  if(connectBoo) then
  	sendMessage(27,4,data);
  	sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_151,{data.Count,data.Count}));
  end
end