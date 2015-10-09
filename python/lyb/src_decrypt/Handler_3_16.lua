
require "main.model.GeneralListProxy";

Handler_3_16 = class(Command);

function Handler_3_16:execute()
	-- local shopMediator=self:retrieveMediator(ShopMediator.name);
	-- if shopMediator then
	--   local userCurrencyProxy=self:retrieveProxy(UserCurrencyProxy.name);
	--   local moneyData = {};
	--   moneyData["gold"] = userCurrencyProxy:getGold()
	--   moneyData["silver"] = userCurrencyProxy:getSilver()
	--   moneyData["prestige"] = userCurrencyProxy:getPrestige();
	--   moneyData["score"] = userCurrencyProxy:getGeneralEmployScore();
	--   moneyData["familyContribute"] = userCurrencyProxy:getFamilyContribute();
	--   moneyData["soulSpar"] = 0;
	--   shopMediator:refreshData(moneyData);
	-- end
	-- print("Handler_3_16 success");
	uninitializeSmallLoading();
end



Handler_3_16.new():execute();