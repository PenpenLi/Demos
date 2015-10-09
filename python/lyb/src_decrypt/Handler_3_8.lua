--
require "main.view.bag.BagPopupMediator";
require "main.view.mainScene.MainSceneMediator";
require "main.model.UserCurrencyProxy";
require "main.view.battleScene.lottery.LotteryMediator"
-- require "main.view.shop.ShopMediator"

Handler_3_8 = class(MacroCommand);

function Handler_3_8:execute()
  --print(".3.8..",recvTable["Gold"],recvTable["BindingGold"],recvTable["Silver"],recvTable["Vitality"],recvTable["PhysicalPower"],recvTable["Prestige"]);
  
  --BagPopupMediator
  local bagPopupMediator=self:retrieveMediator(BagPopupMediator.name);
  local userCurrencyProxy=self:retrieveProxy(UserCurrencyProxy.name);
  local gold = recvTable["Gold"];
  local silver = recvTable["Silver"];
  local vitality =0-- recvTable["Vitality"]
  local physicalPower = recvTable["PhysicalPower"]
  local prestige = recvTable["Prestige"];
  local score = recvTable["Score"];
  local familyContribute = recvTable["FamilyContribute"];
  local booleanValue = recvTable["BooleanValue"];


  print("gold", gold, "silver", silver, "physicalPower", physicalPower)

  self.changeGold = userCurrencyProxy:getGold() - gold;
  self.changeSilver = userCurrencyProxy:getSilver() - silver;
  self.changePhysicalPower = userCurrencyProxy:getTili() - physicalPower;
  self.changePrestige = userCurrencyProxy:getPrestige() - prestige;
  self.changeScore = userCurrencyProxy:getScore() - score;
  self.changeFamilyContribute = 0;
  if recvTable["FamilyContribute"] then
    self.changeFamilyContribute = userCurrencyProxy:getFamilyContribute() - familyContribute;
  end
	userCurrencyProxy:refresh(recvTable["Gold"]
                            ,recvTable["Silver"]
                            ,recvTable["PhysicalPower"]
                            ,recvTable["Prestige"]
                            ,recvTable["Score"]
                            ,recvTable["FamilyContribute"]
                            ,recvTable["StoryLineStar"]);

  if 0 ~= self.changeSilver then
    local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
    local generalArray = heroHouseProxy.generalArray;
    for k,v in pairs(generalArray) do
      heroHouseProxy:setHongdianData(v.GeneralId,1);
      heroHouseProxy:setHongdianData(v.GeneralId,3);
      heroHouseProxy:setHongdianData(v.GeneralId,4);
      heroHouseProxy:setHongdianData(v.GeneralId,5);
      heroHouseProxy:setHongdianData(v.GeneralId,6);
      heroHouseProxy:setHongdianData(v.GeneralId,7);
    end
    if HeroRedDotRefreshCommand then
      HeroRedDotRefreshCommand.new():execute();
    end
  end



  if booleanValue ~= 0 then
    if self.changeGold < 0 then
        sharedTextAnimateReward():animateStartByString("元宝"..self:getTextAnimateString(self.changeGold));

        local langyalingMediator=self:retrieveMediator(LangyalingMediator.name);
        if nil~=langyalingMediator then
          langyalingMediator:refreshCurrency();
        end

    end
    if self.changeSilver < 0 then
        sharedTextAnimateReward():animateStartByString("银两"..self:getTextAnimateString(self.changeSilver));
        
        local langyalingMediator=self:retrieveMediator(LangyalingMediator.name);
        if nil~=langyalingMediator then
          langyalingMediator:refreshCurrency();
        end        
    end
    if self.changePhysicalPower < 0 then
        sharedTextAnimateReward():animateStartByString("体力"..self:getTextAnimateString(self.changePhysicalPower));
    end
    if self.changePrestige < 0 then
        sharedTextAnimateReward():animateStartByString("声望"..self:getTextAnimateString(self.changePrestige));
        GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_33] = false -- 再获得声望以后还是再提醒
        self:addSubCommand(ToRefreshReddotCommand);
        self:complete({data={type=FunctionConfig.FUNCTION_ID_33}});         
    end
    if self.changeScore < 0 then
        sharedTextAnimateReward():animateStartByString("荣誉"..self:getTextAnimateString(self.changeScore));
    end
    if self.changeFamilyContribute < 0 then
        sharedTextAnimateReward():animateStartByString("帮贡"..self:getTextAnimateString(self.changeFamilyContribute));
    end
  end

  -- if nil~=bagPopupMediator then
  --   -- bagPopupMediator:refreshCurrency(userCurrencyProxy);
  -- end
  
  if CurrencyGroupMediator then
    local currencyGroupMediator=self:retrieveMediator(CurrencyGroupMediator.name);
    if nil~=currencyGroupMediator then
      currencyGroupMediator:setHuobiText();
    end
  end
  if FactionCurrencyMediator then
    local factionCurrencyMediator=self:retrieveMediator(FactionCurrencyMediator.name);
    if nil~=factionCurrencyMediator then
      factionCurrencyMediator:setHuobiText();
      -- factionCurrencyMediator:refreshRedDot();
    end
  end

	--ShopMediator
	if ShopMediator then
		local shopMediator = self:retrieveMediator(ShopMediator.name);
		if shopMediator then
			shopMediator:refreshData();
		end
	end	
    if ShopTwoMediator then
    local shopTwoMediator = self:retrieveMediator(ShopTwoMediator.name);
    if shopTwoMediator then
      shopTwoMediator:refreshData2();
    end
  end 
  if ShadowHeroImageMediator then
    local heroImageMediator = self:retrieveMediator(ShadowHeroImageMediator.name);
    if heroImageMediator then
      heroImageMediator:refreshTili();
    end
  end 
  if StrongPointInfoMediator then
    local srongPointInfoMediator = self:retrieveMediator(StrongPointInfoMediator.name);
    if srongPointInfoMediator then
      srongPointInfoMediator:refreshTili();
    end
  end 
  if QuickBattleMediator then
    local quickBattleMediator = self:retrieveMediator(QuickBattleMediator.name);
    if quickBattleMediator then
      quickBattleMediator:refreshTili();
    end
  end
  if JingjichangMediator then
    local jingjichangMediator = self:retrieveMediator(JingjichangMediator.name);
    if jingjichangMediator then
      jingjichangMediator:getViewComponent():refreshRongyu();
    end
  end
	--提示爵位可提升
	if self.changePrestige < 0 or self.changeSilver < 0 then
		local userProxy = self:retrieveProxy(UserProxy.name);
		local nobility = userProxy:getNobility();
		local jueweiTbl = analysisTotalTable("Wujiang_Juewei");
		for k,v in pairs(jueweiTbl)do
			if v["id"] == nobility+1 and userCurrencyProxy:getPrestige() >= v["prestige"] 
					and not userProxy.nobilityNoticed and userCurrencyProxy:getSilver() >= v["money"] then
				recvTable["ID"] = 57;
				recvTable["Content"] = "";
				recvTable["ParamStr1"] = "";
				recvTable["ParamStr2"] = "";
				recvTable["ParamStr3"] = "";
				recvMessage(1011, 6);
				userProxy.nobilityNoticed = true;
			end
		end
	end
	
  if HeroProPopupMediator then
    local heroProPopupMediator = self:retrieveMediator(HeroProPopupMediator.name);
    if heroProPopupMediator then
      heroProPopupMediator:getViewComponent():refreshBySilver();
    end
  end

  -- 检查小红点
  self:checkRedDot()
end

function Handler_3_8:checkRedDot()

  -- 检查是否有需要刷新红点的
  self:addSubCommand(JudgeReddotCommand);
  self:complete({data={functionId=0}}); 
end

function Handler_3_8:getTextAnimateString(changeString)
    return changeString < 0 and "增加"..(0 - changeString) or "减少"..changeString;
end

function Handler_3_8:getGainArray()
	local gainArray = {};
	gainArray[3] = self.changeGold;	--元宝ItemId
  gainArray[2] = self.changeSilver;	--银两ItemId
  gainArray[5] = self.changeVitality;	--元气ItemId
  gainArray[6] = self.changePhysicalPower;	--体力ItemId
  gainArray[7] = self.changePrestige;	--声望ItemId
	return gainArray;
end

Handler_3_8.new():execute();