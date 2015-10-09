--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

require "main.view.family.FamilyMediator";

Handler_27_7 = class(Command);

function Handler_27_7:execute()
  print(".27.7.",recvTable["UserId"],recvTable["BooleanValue"]);

  local familyMediator=self:retrieveMediator(FamilyMediator.name);
  if nil~=familyMediator then
  	familyMediator:refreshFamilyVerify(recvTable["UserId"],recvTable["BooleanValue"]);
  	--sharedTextAnimateReward():animateStartByString("您已" .. (1==recvTable["BooleanValue"] and "同意" or "拒绝") .. familyMediator:getUserNameByApplyLayer(recvTable["UserId"]) .. "加入家族");
  	local id=1==recvTable["BooleanValue"] and PopupMessageConstConfig.ID_156 or PopupMessageConstConfig.ID_157;
  	local name=0==recvTable["UserId"] and "全部申请者" or familyMediator:getUserNameByApplyLayer(recvTable["UserId"]);
  	sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(id,{name}));
  end
end

Handler_27_7.new():execute();