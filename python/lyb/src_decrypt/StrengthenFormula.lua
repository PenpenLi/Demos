--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-13

	yanchuan.xie@happyelements.com
]]

StrengthenFormula={};

function StrengthenFormula:getStrengthenBoundString(strengthenItem, vipLV)
  local strengthenMin,strengthenMax=self:getStrengthenBound(strengthenItem,vipLV);
  return "最低 +" .. strengthenMin .. "  最高 +" .. strengthenMax;
end

function StrengthenFormula:getStrengthenSilver(strengthenItem, vipLV)
  return self:getStrengthenSilverByLevel(strengthenItem:getBagItemData().ItemId,strengthenItem:getStrengthLevel(),vipLV);
end

function StrengthenFormula:getStrengthMaxLevelAndSilver(strengthenItem, vipLV, userSilver, userLevel)
  local itemId=strengthenItem:getBagItemData().ItemId;
  local level4Strengthen=strengthenItem:getStrengthLevel();
  local silver=0;
  while level4Strengthen<userLevel do
    local s=self:getStrengthenSilverByLevel(itemId,level4Strengthen,vipLV);
    if userSilver<s+silver then
      break;
    end
    silver=s+silver;
    level4Strengthen=1+level4Strengthen;
  end
  return level4Strengthen,silver;
end

function StrengthenFormula:getStrengthenSilverByLevel(itemId, strengthenLV, vipLV)
  local propID=tonumber(analysis("Zhuangbei_Zhuangbeibiao",itemId,"attribute"));
  local quality=analysis("Zhuangbei_Zhuangbeibiao",itemId,"quality");
  local vipLV=vipLV;

  --佩戴等级
  local lv=analysis("Zhuangbei_Zhuangbeibiao",itemId,"lv");
  --装备最大花费
  local maxCost=analysis("Zhuangbei_Zhuangbeiqianghua",strengthenLV,"max" .. self:getEquipmentName(itemId) .. "cost");
  --强化花费银两= int(max(int(装备最大花费*（30+佩戴等级^0.5-品质)*0.02),1)*佩戴等级^0.25)*10
  local silver=math.floor(math.max(math.floor(maxCost*(30+math.pow(lv,0.5)-quality)*0.02),1)*math.pow(lv,0.25))*10;
  return silver;
end

function StrengthenFormula:getDegradeSilver(strengthenItem, vipLV)
  local strengthenLV=strengthenItem:getStrengthLevel();
  local propID=tonumber(analysis("Zhuangbei_Zhuangbeibiao",strengthenItem:getBagItemData().ItemId,"attribute"));
  local quality=analysis("Zhuangbei_Zhuangbeibiao",strengthenItem:getBagItemData().ItemId,"quality");
  local vipLV=vipLV;

  --佩戴等级
  local lv=analysis("Zhuangbei_Zhuangbeibiao",strengthenItem:getBagItemData().ItemId,"lv");
  --装备最小返还
  local minReturn=analysis("Zhuangbei_Zhuangbeiqianghua",strengthenLV,"min" .. self:getEquipmentName(strengthenItem:getBagItemData().ItemId) .. "return");
  --降级返还银两=int(max(int(装备最小返还*（30+佩戴等级^0.5-品质)*0.02),1)*佩戴等级^0.25)*10
  local silver=math.floor(math.max(math.floor(minReturn*(30+math.pow(lv,0.5)-quality)*0.02),1)*math.pow(lv,0.25))*10;
  return silver;
end

function StrengthenFormula:getStrengthenBound(strengthenItem, vipLV)
  return self:getStrengthenBoundMinAndMax(strengthenItem:getBagItemData().ItemId,strengthenItem:getStrengthLevel(),vipLV);
end

function StrengthenFormula:getStrengthenBoundMinAndMax(itemID, strengthenLV, vipLV)
  local propID=tonumber(analysis("Zhuangbei_Zhuangbeibiao",itemID,"attribute"));
  local quality=analysis("Zhuangbei_Zhuangbeibiao",itemID,"quality");
  local vipLV=vipLV;

  --佩戴等级
  local lv=analysis("Zhuangbei_Zhuangbeibiao",itemID,"lv");
  --装备最大强化
  local maxLv=analysis("Zhuangbei_Zhuangbeiqianghua",strengthenLV,"max" .. self:getEquipmentName(itemID));
  --装备最小强化
  local minLv=analysis("Zhuangbei_Zhuangbeiqianghua",strengthenLV,"min" .. self:getEquipmentName(itemID));

  --最大强化值=max(int(装备最大强化*（30+佩戴等级^0.5-品质+int((vip等级+3)/2)^1.5*1.5)*0.02),1)
  --最小强化值=max(int(装备最大强化*（30+佩戴等级^0.5-品质+int((vip等级+3)/2)^1.5*1.5)*0.02),1)

  --装备最大强化值=  max(int(装备理论最大强化*(30+佩戴等级^0.25*10)*0.005*(6/品质)^0.75)*((VIP等级/13)^1.5+1)),1)               
  --装备最大强化值=  max(int(装备理论最大强化*(30+佩戴等级^0.25*10)*0.005*(6/品质)^0.75*((VIP等级/40)+1)),1)           
  --装备最小强化值=  max(int(装备理论最小强化*(30+佩戴等级^0.25*10)*0.005*(6/品质)^0.75),1)                

  --强化最大值=  max(int(强化系数*(1+佩戴等级/100)*(6/品质)*((VIP等级/40)+1)),1)+1          
  --强化最小值=  max(int(强化系数*(1+佩戴等级/100)*(6/品质)),1) 
  --强化最大值=  max(int(强化系数*(1+佩戴等级/100)*{1+(6-品质)*0.2+max(5-品质，0)*0.2}*(VIP等级/40+1)),1)
  --强化最小值=  max(int(强化系数*(1+佩戴等级/100)*{1+(6-品质)*0.2+max(5-品质，0)*0.2}*(VIP等级/40+1)),1)    --添加VIP控制
    
  --强化bj=  max(int(强化系数*(1+佩戴等级/100)*{1+(6-品质)*0.2+max(5-品质，0)*0.2}),1)
  --强化pt=  max(int(强化系数*(1+佩戴等级/100)*{1+(6-品质)*0.2+max(5-品质，0)*0.2}),1)    --添加VIP控制    

  --强化值=  max(int(rand()^1.5* 强化范围+强化最小值),强化最小值)

  local strengthenMax=math.max(math.floor(maxLv*(1+lv/100)*(1+(6-quality)*0.2+math.max(5-quality,0)*0.2)),1);
  local strengthenMin=math.max(math.floor(minLv*(1+lv/100)*(1+(6-quality)*0.2+math.max(5-quality,0)*0.2)),1);

  return strengthenMin,strengthenMax;
end

--武将基础初始
function StrengthenFormula:getParam1(attribute)
  if 1==attribute then
    return 12;
  elseif 2==attribute then
    return 10;
  elseif 3==attribute then
    return 8;
  end
  return 0;
end

--转换系数
function StrengthenFormula:getParam2(attribute)
  if 1==attribute then
    return 25;
  elseif 2==attribute then
    return 10;
  elseif 3==attribute then
    return 10;
  end
  return 0;
end

function StrengthenFormula:getEquipmentName(id)
  local a=math.floor(id/1000);
  if 1101==a then--武器
    return "Weapon";
  elseif 1102==a then--头盔
    return "Helmet";
  elseif 1103==a then--护甲
    return "Corselet";
  elseif 1104==a then--鞋子
    return "Shoe";
  elseif 1105==a then--项链
    return "Ring";
  elseif 1106==a then--戒指
    return "Necklace";
  end
end

function StrengthenFormula:getStarAddBoundString(strengthenItem, isStarMax)
  local equipLV=analysis("Zhuangbei_Zhuangbeibiao",strengthenItem:getBagItemData().ItemId,"lv");
  local quality=analysis("Zhuangbei_Zhuangbeibiao",strengthenItem:getBagItemData().ItemId,"quality");
  local starLevel=strengthenItem:getEquipmentInfo().StarLevel;
  local categoryID=strengthenItem:getBagItem():getCategoryID();
  local prop={analysis("Zhuangbei_Zhuangbeibuwei",categoryID,"attribute1"),
              analysis("Zhuangbei_Zhuangbeibuwei",categoryID,"attribute2"),
              analysis("Zhuangbei_Zhuangbeibuwei",categoryID,"attribute3")};
  local prop_add_num=analysis("Zhuangbei_Zhuangbeixingji",isStarMax and starLevel or 1+starLevel,"addNumber");
  local prop_coefficient={analysis("Zhuangbei_Zhuangbeibuwei",categoryID,"attributeRatio1"),
                          analysis("Zhuangbei_Zhuangbeibuwei",categoryID,"attributeRatio2"),
                          analysis("Zhuangbei_Zhuangbeibuwei",categoryID,"attributeRatio3")};
  
  --升星数值=MAX(INT((佩戴等级^0.7*(7-品质)^0.33*(星级+2)^1.7*0.334+5*(星级+2))*升星系数),1)

  local a=0;
  local b={};
  while 3>a do
    a=1+a;
    
    local c=prop_add_num>=a;
    local d={analysis("Wujiang_Wujiangshuxing",prop[a],"name")};
    if isStarMax then
      table.insert(d,strengthenItem:getEquipmentInfoProxy():getPropertyValue(strengthenItem:getBagItemData().UserItemId,prop[a]));
    else
      table.insert(d,c and strengthenItem:getEquipmentInfoProxy():getPropertyValue(strengthenItem:getBagItemData().UserItemId,prop[a]) or (self:getAddNumberStarLevel(a) .. "星开启"));
      table.insert(d,c and math.max(math.floor((math.pow(equipLV,0.7)*math.pow(7-quality,0.33)*math.pow(2+starLevel,1.7)*0.334+(starLevel+2)*5)*prop_coefficient[a]),1) or nil);
    end
    table.insert(b,d);
  end
  return b;
end

function StrengthenFormula:getStarAddBoundStringConverted(strengthenItem, isStarMax)
  local equipLV=analysis("Zhuangbei_Zhuangbeibiao",strengthenItem:getBagItemData().ItemId,"lv");
  local quality=analysis("Zhuangbei_Zhuangbeibiao",strengthenItem:getBagItemData().ItemId,"quality");
  local starLevel=strengthenItem:getEquipmentInfo().StarLevel;
  local categoryID=strengthenItem:getBagItem():getCategoryID();
  local prop={analysis("Zhuangbei_Zhuangbeibuwei",categoryID,"attribute1"),
              analysis("Zhuangbei_Zhuangbeibuwei",categoryID,"attribute2"),
              analysis("Zhuangbei_Zhuangbeibuwei",categoryID,"attribute3")};
  local prop_add_num=analysis("Zhuangbei_Zhuangbeixingji",isStarMax and starLevel or 1+starLevel,"addNumber");
  local prop_coefficient={analysis("Zhuangbei_Zhuangbeibuwei",categoryID,"attributeRatio1"),
                          analysis("Zhuangbei_Zhuangbeibuwei",categoryID,"attributeRatio2"),
                          analysis("Zhuangbei_Zhuangbeibuwei",categoryID,"attributeRatio3")};
  
  --升星数值=MAX(INT((佩戴等级^0.7*(7-品质)^0.33*(星级+2)^1.7*0.334+5*(星级+2))*升星系数),1)

  local a=0;
  local b={};
  local id_convert={[8]=2,[9]=3,[10]=1};
  local coefficient=analysis("Zhandouxishu_Xishubiao",analysis("Zhuangbei_Zhuangbeibiao",strengthenItem:getBagItemData().ItemId,"occupation"));
  local coefficient_t={[8]=coefficient.intGJXS,[9]=coefficient.techniqueGJXS,[10]=coefficient.StrengthGJXS};
  while 3>a do
    a=1+a;
    
    local c=prop_add_num>=a;
    local d={analysis("Wujiang_Wujiangshuxing",id_convert[prop[a]],"name")};
    if isStarMax then
      table.insert(d,strengthenItem:getEquipmentInfoProxy():getPropertyValue(strengthenItem:getBagItemData().UserItemId,id_convert[prop[a]]));
    else
      table.insert(d,c and strengthenItem:getEquipmentInfoProxy():getPropertyValue(strengthenItem:getBagItemData().UserItemId,id_convert[prop[a]]) or (self:getAddNumberStarLevel(a) .. "星开启"));
      local prop_v=strengthenItem:getEquipmentInfoProxy():getPropertyValue(strengthenItem:getBagItemData().UserItemId,prop[a]);
      local prop_v1=math.max(math.floor((math.pow(equipLV,0.7)*math.pow(7-quality,0.33)*math.pow(2+starLevel,1.7)*0.334+(starLevel+2)*5)*prop_coefficient[a]),1);
      table.insert(d,c and (prop_v1-prop_v)*coefficient_t[prop[a]] or nil);
    end
    table.insert(b,d);
  end
  return b;
end

function StrengthenFormula:getAddNumberStarLevel(addNumber)
  local a=1;
  while analysisHas("Zhuangbei_Zhuangbeixingji",a) do
    if analysis("Zhuangbei_Zhuangbeixingji",a,"addNumber")==addNumber then
      return a;
    end
    a=1+a;
  end
end

function StrengthenFormula:getStarAddValue(userEquipmentId, bagProxy, equipmentInfoProxy, isForge)
  local bagItemData=bagProxy:getItemData(userEquipmentId);
  local equipmentInfo=equipmentInfoProxy:getEquipmentInfo(userEquipmentId);
  
  local equipLV=analysis("Zhuangbei_Zhuangbeibiao",bagItemData.ItemId,"lv");
  local quality=analysis("Zhuangbei_Zhuangbeibiao",bagItemData.ItemId,"quality");
  local starLevel=equipmentInfo.StarLevel;
  local categoryID=math.floor(bagItemData.ItemId/1000);
  local prop={analysis("Zhuangbei_Zhuangbeibuwei",categoryID,"attribute1"),
              analysis("Zhuangbei_Zhuangbeibuwei",categoryID,"attribute2"),
              analysis("Zhuangbei_Zhuangbeibuwei",categoryID,"attribute3")};
  local prop_add_num;
  if isForge then
    if 0==starLevel then
      prop_add_num=0;
    else
      prop_add_num=analysis("Zhuangbei_Zhuangbeixingji",starLevel,"addNumber");
    end
  else
    prop_add_num=analysis("Zhuangbei_Zhuangbeixingji",1+starLevel,"addNumber");
  end
  local prop_coefficient={analysis("Zhuangbei_Zhuangbeibuwei",categoryID,"attributeRatio1"),
                          analysis("Zhuangbei_Zhuangbeibuwei",categoryID,"attributeRatio2"),
                          analysis("Zhuangbei_Zhuangbeibuwei",categoryID,"attributeRatio3")};
  
  --升星数值=MAX(INT((佩戴等级^0.7*(7-品质)^0.33*(星级+2)^1.7*0.334+5*(星级+2))*升星系数),1)
  local s={};
  local a=0;
  while prop_add_num>a do
    a=1+a;
    
    local b={Type=prop[a],
             Value=math.max(math.floor((math.pow(equipLV,0.7)*math.pow((7-quality),0.33)*math.pow(2+starLevel,1.7)*0.334+(starLevel+2)*5)*prop_coefficient[a]),1)};
    table.insert(s,b);
  end
  return s;
end

function StrengthenFormula:getStarAddSilver(strengthenItem)
  --INT(INT((星级)/3+1)*（佩戴等级/品质）^0.5*5)*10000
  --INT( ((星级-1)/3+1) *（1/品质^0.5） * 佩戴等级^0.2 * 5 ) *2500
  --int(int(当前星级/3+1)*(佩戴等级/品质)^0.2*5)*2500
  local equipLV=analysis("Zhuangbei_Zhuangbeibiao",strengthenItem:getBagItemData().ItemId,"lv");
  local quality=analysis("Zhuangbei_Zhuangbeibiao",strengthenItem:getBagItemData().ItemId,"quality");
  local starLevel=strengthenItem:getEquipmentInfo().StarLevel;
  --return math.floor(math.floor((starLevel)/3+1)*math.pow(equipLV/quality,0.5)*5)*10000;
  --return math.floor(((starLevel-1)/3+1)*(1/math.pow(quality,0.5))*math.pow(equipLV,0.2)*5)*2500;
  return math.floor(math.floor(starLevel/3+1)*(math.pow(equipLV/quality,0.2)*5))*2500;
end

function StrengthenFormula:getEquipSellSilver(bagItem, equipmentInfoProxy)
  local equipLV=analysis("Zhuangbei_Zhuangbeibiao",bagItem:getItemData().ItemId,"lv");
  local quality=analysis("Zhuangbei_Zhuangbeibiao",bagItem:getItemData().ItemId,"quality");
  local strengthenLV=equipmentInfoProxy:getEquipmentInfo(bagItem:getItemData().UserItemId).StrengthenLevel;
  --int(强化等级^3.33/品质^0.2*佩戴等级^0.2/1000)*1000+int(600/品质*佩戴等级)
  local silver=math.floor(math.pow(strengthenLV,3.33)/math.pow(quality,0.2)*math.pow(equipLV,0.2)/1000)*1000+math.floor(600/quality*equipLV)+equipmentInfoProxy:getGemSellSilver(bagItem:getItemData().UserItemId);
  return 1000000>silver and silver or (math.floor(silver/10000) .. "万");
end