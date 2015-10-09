--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

require "main.view.family.FamilyMediator";
require "main.config.FamilyConstConfig";
Handler_27_20 = class(MacroCommand);

function Handler_27_20:execute()
  print(".27.20.",recvTable["IDAndStateArray"]);
  local mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);

  local familyProxy=self:retrieveProxy(FamilyProxy.name);
  familyProxy:refreshActivitys(recvTable["IDAndStateArray"]);
  local familyMediator=self:retrieveMediator(FamilyMediator.name);
  if nil~=familyMediator then
  	familyMediator:refreshActivitys();
  end

  -- if nil~=mainSceneMediator then
  --   mainSceneMediator:refreshFirstSevenEffect();
  -- end
  --self:closeActivitys();
  self:refreshNewApply();
  self:refreshIconEffect()
end

function Handler_27_20:closeActivitys()
  --[[local familyProxy=self:retrieveProxy(FamilyProxy.name);
  if not familyProxy:getActivityIsOpen(FamilyConstConfig.ACTIVITY_4) then
    if FamilyTaskMediator and self:retrieveMediator(FamilyTaskMediator.name) then
      self:addSubCommand(FamilyTaskCloseCommand);
      sharedTextAnimateReward():animateStartByString("家族任务关闭了哦~");
    end
  end
  self:complete();]]
end
function Handler_27_20:refreshIconEffect()
  local mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);
  for k,v in pairs(recvTable["IDAndStateArray"]) do
      if v.ID == FamilyConstConfig.ACTIVITY_1 and v.State == 1 then--薪水
        self:retrieveProxy(FamilyProxy.name).familyEffectTap=nil;
        if nil~=mainSceneMediator then
          -- mainSceneMediator:addCaidanIconEffect()
          mainSceneMediator:refreshFamilyEffect()
        end
      end
    print(".27.20..",v.ID,v.State,v.Time);
  end

end
function Handler_27_20:refreshNewApply()
  for k,v in pairs(recvTable["IDAndStateArray"]) do
    if FamilyConstConfig.ACTIVITY_5==v.ID and 1==v.State then
      self:retrieveProxy(FamilyProxy.name).familyEffectTap=nil;
      local familyMediator=self:retrieveMediator(FamilyMediator.name);
      if nil~=familyMediator then
        familyMediator:refreshNewApply();
      end
      local mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);
      if nil~=mainSceneMediator then
        mainSceneMediator:refreshFamilyEffect();
      end
    end
  end
end

Handler_27_20.new():execute();