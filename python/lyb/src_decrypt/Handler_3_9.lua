-- 次数控制 同步
require "main.view.mainScene.MainSceneMediator";
require "main.view.arena.ArenaMediator";
require "main.view.vip.VipMediator";
require "main.view.treasury.TreasuryMediator";
-- require "main.view.family.ui.familyBanquet.FamilyBanquetMediator";
-- require "main.view.family.ui.familyBanquet.FamilyHoldBanquetPopup";
-- require "main.view.family.ui.familyBanquet.FamilyHoldBanquetMediator";

Handler_3_9 = class(MacroCommand);

function Handler_3_9:execute()
  local userCountControlArray = recvTable["UserCountControlArray"];
  -- 是否是正点刷新
  local isEverydayRefresh = recvTable["BooleanValue"] == 1; 

  local countControlProxy=self:retrieveProxy(CountControlProxy.name);
  countControlProxy:refresh(userCountControlArray);

  for k,v in pairs(userCountControlArray) do
    local countID = v.ID;
    print("v.ID", countID,v.CurrentCount,v.TotalCount,v.AddCount,v.MaxAddCount,v.BuyCountNeedGold)

    if countID == CountControlConfig.ID_1 then

    elseif countID == CountControlConfig.ID_2 then-- 竞技场
      if JingjichangMediator then
        local jingjichangMediator = self:retrieveMediator(JingjichangMediator.name);
        if jingjichangMediator then
          jingjichangMediator:getViewComponent():refreshCishu();
        end
      end
    elseif countID == CountControlConfig.ID_3 then -- 竞技场

      if JingjichangMediator then
        local jingjichangMediator=self:retrieveMediator(JingjichangMediator.name);
        if nil~=jingjichangMediator then
          -- arenaMediator:refreshTimesData(countControlProxy);
          jingjichangMediator:getViewComponent():refreshCishu();
        end
      end

      if isEverydayRefresh then
        GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_26] = false
      end
      self:addSubCommand(ToRefreshReddotCommand);
      self:complete({data={type=FunctionConfig.FUNCTION_ID_26}}); 

    elseif countID == CountControlConfig.ID_4 or countID == CountControlConfig.ID_5 then
      if isEverydayRefresh then
        GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_36] = false
      end

      self:addSubCommand(ToRefreshReddotCommand);
      self:complete({data={type=FunctionConfig.FUNCTION_ID_36}});   
      local treasuryMediator = self:retrieveMediator(TreasuryMediator.name);
      if nil~=treasuryMediator then
        treasuryMediator:refreshCountData();
      end 
    elseif countID == CountControlConfig.ID_6 then
      if isEverydayRefresh then
        GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_34] = false
      end

      self:addSubCommand(ToRefreshReddotCommand);
      self:complete({data={type=FunctionConfig.FUNCTION_ID_34}});       
    elseif countID == CountControlConfig.ID_7 then
      if isEverydayRefresh then
        GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_35] = false
      end

      self:addSubCommand(ToRefreshReddotCommand);
      self:complete({data={type=FunctionConfig.FUNCTION_ID_35}}); 
    elseif countID == CountControlConfig.ID_9 then -- 竞技场
      local arenaMediator=self:retrieveMediator(ArenaMediator.name);
      if nil~=arenaMediator then
        arenaMediator:refreshUpdateTimesData();
      end
    -- elseif countID == CountControlConfig.ID_10 then -- 五行
    --   local fiveEleMediator = self:retrieveMediator(FiveEleBtleMediator.name);
    --   if nil~=fiveEleMediator then
    --     fiveEleMediator:refreshCountData();
    --   end

    elseif countID == CountControlConfig.ID_11 then -- 酒宴举办次数

    elseif countID == CountControlConfig.ID_12 then -- 酒宴参加次数

    elseif countID == CountControlConfig.ID_13 then -- 温酒次数
      
    end
  end

  -- -- 以下写的不好 每次次数刷新都全部刷？
  -- local activityProxy=self:retrieveProxy(ActivityProxy.name);
  -- activityProxy:refreshPersistentActivity(countControlProxy);
  
  -- --local vipMediator=self:retrieveMediator(VipMediator.name);
  -- --if nil~=vipMediator then
  -- --  vipMediator:refreshPrivilegeData();
  -- --end

  

  -- if FamilyMediator then
  --   local familyMediator=self:retrieveMediator(FamilyMediator.name);
  --   if nil~=familyMediator then
  --     familyMediator:refreshActivity4FamilyBoss();
  --   end
  -- end  
 end

Handler_3_9.new():execute();