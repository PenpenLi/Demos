--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-19

	yanchuan.xie@happyelements.com
]]

require "main.model.BagProxy";
require "main.model.GeneralListProxy";
require "main.model.EffectProxy";

Handler_6_5 = class(Command);

function Handler_6_5:execute()
	print("Handler_6_5 ",recvTable["GeneralId"],recvTable["Experience"],recvTable["GradeExp"]);
  local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  heroHouseProxy:refreshGeneralExpAndHunli(recvTable["GeneralId"],recvTable["Experience"],recvTable["GradeExp"]);

  self:retrieveMediator(HeroProPopupMediator.name):refreshGeneralExpAndHunli();


 --  local bagPopupMediator=self:retrieveMediator(BagPopupMediator.name);
 --  local bagProxy=self:retrieveProxy(BagProxy.name);
 
 --  generalListProxy:refreshNew(recvTable["GeneralId"],
 --                           newLevel,
 --                           recvTable["Experience"]);
 --  if nil~=bagPopupMediator then
 --    bagPopupMediator:refreshLevelExpNew(newLevel,recvTable["Experience"]);
 --  end
	
	-- --LotteryMediator
	-- -- if LotteryMediator then
	-- -- 	local lotteryMediator=self:retrieveMediator(LotteryMediator.name);
	-- -- 	if lotteryMediator then
	-- -- 		lotteryMediator:showGainItem({0-expIncrease});
	-- -- 		-- sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_1,{1,expIncrease}));
	-- -- 	end
 -- --  end

 --  require "main.controller.command.officialServer.OfficialServerForceUpdateCommand";
 --  OfficialServerForceUpdateCommand.new():execute();
end

Handler_6_5.new():execute();
