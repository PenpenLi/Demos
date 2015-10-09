--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-5

	yanchuan.xie@happyelements.com
]]

GeneralListProxy=class(Proxy);

function GeneralListProxy:ctor()
  self.class=GeneralListProxy;
  self.data={};
  self.maxLevel = nil;
  self.isPopupLevelUpEffect = false;
end

rawset(GeneralListProxy,"name","GeneralListProxy");

--“更新”
function GeneralListProxy:refresh(generalId, configId, level, experience, armSlaveArray, usingEquipmentArray)
  self.data.generalId=generalId;
  self.data.configId=configId;
  self.data.level=level;
  recordScore(level);
  self.data.experience=experience;
  self:setArmSlaveData(armSlaveArray);
  self.data.usingEquipmentArray=usingEquipmentArray;
end

function GeneralListProxy:refreshNew(generalId, level, experience)
  self.data.generalId=generalId;
  self.data.level=level;
  recordScore(level);
  self.data.experience=experience;
end

--“更新装备”
function GeneralListProxy:refreshUsingEquipmentArray(replaceEquipmentArray)
  for k,v in pairs(replaceEquipmentArray) do
    --if self.data.generalId==v.GeneralId then
      self:refreshUsingEquipmentItem(v);
    --end
  end
end

--“更新装备”
function GeneralListProxy:refreshUsingEquipmentItem(replaceEquipment)
  for k,v in pairs(self.data.usingEquipmentArray) do
    if replaceEquipment.EquipmentPlaceId==v.EquipmentPlaceId then
      self.data.usingEquipmentArray[k]=nil;
      break;
    end
  end
  table.insert(self.data.usingEquipmentArray,replaceEquipment);
end

--“英魂”
function GeneralListProxy:getArmSlaveData()
  return self.data.armSlaveArray;
end

--“经验”
function GeneralListProxy:getExperience()
  return self.data.experience;
end

function GeneralListProxy:getDiffLevelExp(level1,level2,addExp)
  --[[local tempExp = addExp;
  local num = 0
  while (true) do
      if level1 + num == level2 then
        break
      end
      tempExp = analysis("Wujiang_Wujiangshengji",level1 + num,"exp") + tempExp;
      num = num + 1;
  end
  --print(tempExp.."======================"..self.data.experience.."========"..level1.."========"..level2)
  return tempExp - self.data.experience;]]
  if level1 == level2 then 
     return addExp - self.data.experience;
  end
  
  local returnValue = 0;
  if level2 == self:getMaxLevel() then
    returnValue = analysis("Wujiang_Wujiangshengji",self:getMaxLevel(),"exp") - self.data.experience + addExp; 
  else
    for i = level1, level2 do
       if i == level1 then
          returnValue = analysis("Wujiang_Wujiangshengji",level1 + 1,"exp") - self.data.experience;   
       elseif i == level2 then
          returnValue = returnValue + addExp; 
       else
          returnValue = returnValue + analysis("Wujiang_Wujiangshengji",i + 1,"exp"); 
       end
    end
  end
  return returnValue;
end

function GeneralListProxy:getMaxLevel()
  if self.maxLevel == nil then
      local generalTable=analysisTotalTable("Zhujiao_Zhujiaoshengji");
      table.remove(generalTable,1);
      for k,v in pairs(generalTable) do
        if self.maxLevel == nil then
            self.maxLevel = v.id;
        elseif v.id > self.maxLevel then
            self.maxLevel = v.id;
        end
      end
  end
  return self.maxLevel;
end

--“角色等级”
function GeneralListProxy:getLevel()
  return self.data.level;
end

function GeneralListProxy:getGeneralID()
  return self.data.generalId;
end

--“角色装备”
function GeneralListProxy:getUsingEquipmentData()
  return self.data.usingEquipmentArray;
end

function GeneralListProxy:setArmSlaveData(armSlaveArray)
    local table = {};
    for k,v in ipairs(armSlaveArray) do
      table[tostring(v.Place)] = v;
    end
    self.data.armSlaveArray = table;
end

--“英魂数据”
function GeneralListProxy:resetArmSlaveData(armSlaveArray)
    for k,v in ipairs(armSlaveArray) do
      self.data.armSlaveArray[tostring(v.Place)] = v;
    end
    return self.data.armSlaveArray;
end