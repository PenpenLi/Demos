TenCountryProxy=class(Proxy);

function TenCountryProxy:ctor()
	self.class=TenCountryProxy;
	self.skeleton = nil;
	self.placeId = nil;
	self.placeGeneralIdArray = nil;
	self.generalStateArray = nil;
	self.placeState = nil;
end

function TenCountryProxy:resertData()
  self.skeleton = nil;
  self.placeGeneralIdArray = nil;
  self.generalStateArray = nil;
  self.placeState = nil
  self.tapGeneralId = nil
end

function TenCountryProxy:getSkeleton()
    if nil==self.skeleton then
      self.skeleton=SkeletonFactory.new();
      self.skeleton:parseDataFromFile("shiguo_ui");
    end
    return self.skeleton;
end

function TenCountryProxy:onRemove()
end

rawset(TenCountryProxy,"name","TenCountryProxy");

function TenCountryProxy:getFightGeneralArray()
  return self.placeGeneralIdArray
end

-- function TenCountryProxy:getTenCountryGeneralInPlayOverCount()
--     return 4 == #self.placeGeneralIdArray
-- end

function TenCountryProxy:insertGeneralIdArray(generalId)
  local tempTable = {GeneralId = generalId}
  table.insert(self.placeGeneralIdArray,tempTable)

  self.joinGeneralId = nil
end

function TenCountryProxy:removeGeneralIdArray(generalId)
    for key,generalVO in pairs(self.placeGeneralIdArray) do
      if generalVO.GeneralId == generalId then
        table.remove(self.placeGeneralIdArray,key)
      end
    end
    self.quitGeneralId = nil
end

function TenCountryProxy:getUpGeneralNum()
    local number = 0
    for key,generalVO in pairs(self.placeGeneralIdArray) do
      number = number + 1
    end
    return number
end

function TenCountryProxy:isInUpItem(generalId)
  for key,value in pairs(self.placeGeneralIdArray) do
    if value.GeneralId == generalId then
      return true
    end
  end
end

function TenCountryProxy:isBelowLevel(generalId,heroHouseProxy)
    local generalVO = heroHouseProxy:getGeneralData(generalId)
    if generalVO.Level < analysis("Xishuhuizong_Xishubiao",1018,"constant") then
        return true
    end
end

function TenCountryProxy:addNextPlace()
  self.placeId = self.placeId + 1
  self.placeState = 0
end

function TenCountryProxy:getBloodItem(bloodData,VO)
  require("main.controller.command.battleScene.battle.battlefield.config.BattleConstants")
  local blood = {CurrentHP = 100000,CurrentMP = 0}
  for key,bloodVO in pairs(bloodData) do
    if bloodVO.BattleUnitID == VO.GeneralId then
      blood = bloodVO
      break
    end
  end
  local mapcityArmature=self:getSkeleton():buildArmature("blood_ui");
  mapcityArmature.animation:gotoAndPlay("f1");
  mapcityArmature:updateBonesZ();
  mapcityArmature:update();
  mapcityArmature.display.touchEnabled = false;
  mapcityArmature.display.touchChildren = false;

  local bloodProgress = ProgressBar.new(mapcityArmature,"hp_pro");
  bloodProgress:setProgress(blood.CurrentHP/100000)
  local powerProgress = ProgressBar.new(mapcityArmature,"nuqitiao");
  local mpValue = blood.CurrentMP and blood.CurrentMP/self:getMaxRage(VO.ConfigId) or 0
  powerProgress:setProgress(mpValue)
  if blood.CurrentHP ~= 0 then
    mapcityArmature.display:getChildByName("dead"):setVisible(false)
  end
  return mapcityArmature.display,blood.CurrentHP == 0;
end

function TenCountryProxy:getMaxRage(battleUnitID)
    local skillId = analysis("Kapai_Kapaiku",battleUnitID,"two");
    return analysis("Jineng_Jineng",skillId,"xiaoHao");
end