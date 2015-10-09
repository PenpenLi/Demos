--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-28

	yanchuan.xie@happyelements.com
]]

EquipmentInfoProxy=class(Proxy);

function EquipmentInfoProxy:ctor()
  self.class=EquipmentInfoProxy;
  self.data=nil;
  self.jinjie_general_id_cache = nil;
  self.jinjie_item_id_cache = nil;
  self.jinjie_target_item_id_cache = nil;
end

rawset(EquipmentInfoProxy,"name","EquipmentInfoProxy");

function EquipmentInfoProxy:getEquipPropValue(generalID, itemID, propID, level)
  local data = self:getEquipInfoByHeroIDAndItemID(generalID, itemID);
  return self:getEquipPropValueAllPlayer(data,propID,level);
end

function EquipmentInfoProxy:getEquipPropValueAllPlayer(data, propID, level)
  local value = 0;
  local equip_type = nil;
  local heroHouseProxy = Facade.getInstance():retrieveProxy(HeroHouseProxy.name);
  local generalData = heroHouseProxy:getGeneralData(data.GeneralId);
  if data then
    if not level then
      level = data.StrengthenLevel;
    end
    local tb_data = analysisWithCache("Zhuangbei_Zhuangbeipeizhibiao",data.ItemId,"attribute");
    if "" ~= tb_data then
      tb_data = StringUtils:lua_string_split(tb_data,",");
      if propID == tonumber(tb_data[1]) then
        value = tonumber(tb_data[2]);
        equip_type = 1;
      end
    else
      for k,v in pairs(data.PropertyArray) do
        if 0 ~= v.Type and propID == v.Type then
          if (2 == math.floor(data.ItemId/1000000) and analysisWithCache("Xishuhuizong_Xishubiao",1081,"constant") <= generalData.Level)
             or (6 == math.floor(data.ItemId/1000000) and analysisWithCache("Xishuhuizong_Xishubiao",1082,"constant") <= generalData.Level) then
            value = v.Value;
            equip_type = 2;
          end
          break;
        end
      end
    end
    if 1 == equip_type then
      value = 0;
      if HeroPropConstConfig.GONG_JI == propID then
        value = 15 + level * HeroPropConstConfig.XI_SHU_ZHUANG_BEI_LEVEL_M1 / 100 + value;
      elseif HeroPropConstConfig.NEI_GONG_JI == propID then
        value = 13 + level * HeroPropConstConfig.XI_SHU_ZHUANG_BEI_LEVEL_M3 / 100 + value;
      elseif HeroPropConstConfig.FANG_YU == propID then
        value = 10 + level * HeroPropConstConfig.XI_SHU_ZHUANG_BEI_LEVEL_M2 / 100 + value;
      elseif HeroPropConstConfig.NEI_FANG_YU == propID then
        value = 12 + level * HeroPropConstConfig.XI_SHU_ZHUANG_BEI_LEVEL_M4 / 100 + value;
      elseif HeroPropConstConfig.SHENG_MING == propID then
        value = 100 + level * HeroPropConstConfig.XI_SHU_ZHUANG_BEI_LEVEL_M5 + value;
      end
    elseif 2 == equip_type then

    end
  end
  return math.floor(value);
end

function EquipmentInfoProxy:getZhanli(generalID, itemID)
  local a=self:getEquipInfoByHeroIDAndItemID(generalID, itemID);
  if nil==a then
    return 0;
  end
  if nil==a.Zhanli then
    self:setZhanli(generalID, itemID);
  end
  return a.Zhanli;
end

function EquipmentInfoProxy:setZhanli(generalID, itemID)
  -- local data=self:getEquipInfoByHeroIDAndItemID(generalID, itemID);
  -- local bagProxy = Facade.getInstance():retrieveProxy(BagProxy.name);
  -- local propIDs = analysis("Zhuangbei_Zhuangbeipeizhibiao",itemID,"attribute");
  -- propIDs = StringUtils:lua_string_split(propIDs,",");
  -- propIDs = {tonumber(propIDs[1])};
  -- -- local id = analysis("Zhuangbei_Zhuangbeipeizhibiao",itemID,"Additional1");
  -- -- if ""~=id then
  -- --   id = StringUtils:stuff_string_split(id);
  -- --   for k,v in pairs(id) do
  -- --     table.insert(propIDs, v[1]);
  -- --   end
  -- -- end
  -- local value = 0;
  -- for k,v in pairs(propIDs) do
  --   local tb_data = analysisHas("Shuxing_Shuju",v) and analysis("Shuxing_Shuju",v) or nil;
  --   local zhanli = 0;
  --   if tb_data then
  --     if isPer then
  --       zhanli = 0;
  --     else
  --       zhanli = self:getEquipPropValue(generalID, itemID, v)*tb_data.attribute/100000;
  --     end
  --   end

  --   value = math.ceil(zhanli) + value;
  -- end
  -- data.Zhanli = value;
end

function EquipmentInfoProxy:delete(userItemArray)
  if nil==self.data then
    return;
  end
  for k,v in pairs(userItemArray) do
    if 0==v.Count then
      self:deleteItem(v.UserItemId);
    end
  end
end

function EquipmentInfoProxy:deleteItem(userEquipmentId)
  for k,v in pairs(self.data) do
    if userEquipmentId==v.UserEquipmentId then
      table.remove(self.data,k);
      return;
    end
  end
end

--更新装备
function EquipmentInfoProxy:refresh(equipmentInfoArray)
  local function sortFunc(data_a, data_b)
    return data_a.ItemId < data_b.ItemId;
  end
  for k,v in pairs(equipmentInfoArray) do
    -- table.sort(v.ExtraPropertyArray,sortFunc);
  end
  table.sort(equipmentInfoArray,sortFunc);
  if nil==self.data then
    self.data=equipmentInfoArray;
    return;
  else
    for k,v in pairs(equipmentInfoArray) do
      self:refreshItem(v);
    end
  end
end

function EquipmentInfoProxy:refreshItem(equipmentInfo)
  local a=self:getEquipInfoByHeroIDAndItemID(equipmentInfo.GeneralId,equipmentInfo.ItemId);
  if a then
    for k,v in pairs(a) do
      a[k]=equipmentInfo[k];
    end
    return;
  end
  table.insert(self.data,equipmentInfo);
end

function EquipmentInfoProxy:refreshitemByXilian()

end

function EquipmentInfoProxy:getEquipsByHeroID(generalID)
  local data = {};
  for k,v in pairs(self.data) do
    if generalID==v.GeneralId then
      table.insert(data,v);
    end
  end
  local function sortFunc(data_a, data_b)
    return data_a.ItemId < data_b.ItemId;
  end
  table.sort(data,sortFunc);
  return data;
end

function EquipmentInfoProxy:getEquipInfoByHeroIDAndItemID(generalID, itemID)
  if not self.data then return nil; end;
  for k,v in pairs(self.data) do
    if generalID==v.GeneralId and itemID==v.ItemId then
      return v;
    end
  end
end

function EquipmentInfoProxy:getEquipInfoByHeroIDAndPlace(generalID, place)
  if not self.data then return nil; end;
  for k,v in pairs(self.data) do
    if generalID==v.GeneralId and place==math.floor(v.ItemId/1000000) then
      return v;
    end
  end
end

function EquipmentInfoProxy:getEquipmentStrengthenLevel(generalID, itemID)
  local data = self:getEquipInfoByHeroIDAndItemID(generalID, itemID);
  if data then
    return data.StrengthenLevel;
  end
  return 0;
end

function EquipmentInfoProxy:refreshStrengthen(generalID, itemID, strengthenLevel, param1, param2)
  local data = self:getEquipInfoByHeroIDAndItemID(generalID, itemID);
  data.StrengthenLevel = strengthenLevel;
end

function EquipmentInfoProxy:refreshJinjie()
  if self.jinjie_general_id_cache and self.jinjie_item_id_cache then
    local data = self:getEquipInfoByHeroIDAndItemID(self.jinjie_general_id_cache, self.jinjie_item_id_cache);
    data.ItemId = self.jinjie_target_item_id_cache;
  end
end

--装备降级
--Sequence:0~1表示基础属性,2~3表示强化属性,4~6表示升星属性
--Sequence:1~2表示基础属性,3~4表示强化属性,5~7表示升星属性
function EquipmentInfoProxy:refreshItemDegrade(userEquipmentId, strengthenValue, preStrengthenValue, zhanLi)
  local a=self:getEquipmentInfo(userEquipmentId);
  local b=a.PropertyArray;

  for k,v in pairs(b) do
    if 3==v.Sequence or 4==v.Sequence then
      if v.Type and v.Value then
        v.Value=strengthenValue-a.StrengthenValue+v.Value;
        break;
      end
    end
  end

  a.StrengthenLevel=-1+a.StrengthenLevel;
  a.StrengthenValue=strengthenValue;
  a.PreStrengthenValue=preStrengthenValue;
  a.Zhanli=zhanLi;
end

--装备打造
--itemId2 打造前itemId
function EquipmentInfoProxy:refreshItemForge(userEquipmentId, itemId, itemId2, strengthenValue, preStrengthenValue, zhanLi, bagProxy)
  local a=self:getEquipmentInfo(userEquipmentId);
  local b=a.PropertyArray;
  local attribute=analysis("Zhuangbei_Zhuangbeibiao",itemId,"attribute");
  local amount=analysis("Zhuangbei_Zhuangbeibiao",itemId,"amount");
  for k,v in pairs(b) do
    if 1==v.Sequence or 2==v.Sequence then
      if attribute==v.Type then
        v.Value=amount;
        break;
      end
    end
  end

  local level=-analysis("Zhuangbei_Zhuangbeidazao",itemId2,"downgrad")+a.StrengthenLevel;
  a.StrengthenLevel=0>level and 0 or level;
  a.StrengthenValue=strengthenValue;
  a.PreStrengthenValue=preStrengthenValue;
  a.Zhanli=zhanLi;

  local propTable=StrengthenFormula:getStarAddValue(userEquipmentId,bagProxy,self,true);
  local starLevel=self:getStarLevel(userEquipmentId);
  self:refreshItemStarAdd(userEquipmentId,starLevel,propTable,zhanLi);
end

--装备强化
function EquipmentInfoProxy:refreshItemStrengthen(userEquipmentId, strengthenValue, preStrengthenValue, zhanLi, bagProxy, strengthenLevel)
  local a=self:getEquipmentInfo(userEquipmentId);
  local b=a.PropertyArray;
  
  local aa=0;
  for k,v in pairs(b) do
    if 3==v.Sequence or 4==v.Sequence then
      if v.Type and v.Value then
        aa=1;
        v.Value=strengthenValue-a.StrengthenValue+v.Value;
        break;
      end
    end
  end
  if 0==aa then
    for k,v in pairs(b) do
      if 3==v.Sequence or 4==v.Sequence then
        if 0==v.Type then
          aa=1;
          v.Type=analysis("Zhuangbei_Zhuangbeibiao",bagProxy:getItemData(userEquipmentId).ItemId,"attribute");
          v.Value=strengthenValue;
          break;
        end
      end
    end
  end
  if 0==aa then
    error("error in strengthen");
  end

  if not strengthenLevel then
    strengthenLevel=1+a.StrengthenLevel;
  end
  a.StrengthenLevel=strengthenLevel;
  a.StrengthenValue=strengthenValue;
  a.PreStrengthenValue=preStrengthenValue;
  a.Zhanli=zhanLi;
end

--装备升星
function EquipmentInfoProxy:refreshItemStarAdd(userEquipmentId, starLevel, starAddBound, zhanLi)
  local a=self:getEquipmentInfo(userEquipmentId);
  local b=a.PropertyArray;
  a.StarLevel=starLevel;
  
  for k,v in pairs(starAddBound) do
    local aa=0;

    for k_,v_ in pairs(b) do
      if 5==v_.Sequence or 6==v_.Sequence or 7==v_.Sequence then
        if v.Type==v_.Type then
          aa=1;
          v_.Value=v.Value;
          break;
        end
      end
    end
    if 0==aa then
      for k_,v_ in pairs(b) do
        if 5==v_.Sequence or 6==v_.Sequence or 7==v_.Sequence then
          if 0==v_.Type then
            aa=1;
            v_.Type=v.Type;
            v_.Value=v.Value;
            break;
          end
        end
      end
    end
    if 0==aa then
      error("error in staradd");
    end
  end

  a.Zhanli=zhanLi;
end

--装备
function EquipmentInfoProxy:getData()
  return self.data;
end

function EquipmentInfoProxy:getEquipmentInfo(userEquipmentId)
  --print("+++",userEquipmentId);
  if not self.data then return nil; end;
  for k,v in pairs(self.data) do
    --print(v.UserEquipmentId,v.StrengthenLevel,v.ExtraPropertyArray);
    if userEquipmentId==v.UserEquipmentId then
      return v;
    end
  end
end

--附加
function EquipmentInfoProxy:getPropertyArray(userEquipmentId)
  local a=self:getEquipmentInfo(userEquipmentId);
  if nil==a then
    return nil;
  end
  return a.PropertyArray;
end

--附加
function EquipmentInfoProxy:getExtraPropertyArray(userEquipmentId)
  local a=self:getEquipmentInfo(userEquipmentId);
  if nil==a then
    return nil;
  end
  return a.ExtraPropertyArray;
end

function EquipmentInfoProxy:getPropertyValue(userEquipmentId, propID)
  local propertyArray=self:getPropertyArray(userEquipmentId);
  if nil==propertyArray then
    return 0;
  end
  local a=0;
  for k,v in pairs(propertyArray) do
    if propID==v.Type then
      a=v.Value+a;
    end
  end
  return a;
end

function EquipmentInfoProxy:getPropertyValueWithStrengthened(userEquipmentId, propID)
  local propertyArray=self:getPropertyArray(userEquipmentId);
  if nil==propertyArray then
    return 0;
  end
  local a=0;
  for k,v in pairs(propertyArray) do
    if propID==v.Type and (1==v.Sequence or 2==v.Sequence or 3==v.Sequence or 4==v.Sequence) then
      a=v.Value+a;
    end
  end
  return a;
end

--星
function EquipmentInfoProxy:getStarLevel(userEquipmentId)
  local a=self:getEquipmentInfo(userEquipmentId);
  if nil==a then
    return 0;
  end
  if nil == a.StarLevel then
    return 0;
  end
  return a.StarLevel;
end

--强化
function EquipmentInfoProxy:getStrengthLevel(userEquipmentId)
  local a=self:getEquipmentInfo(userEquipmentId);
  if nil==a then
    return 0;
  end
  return a.StrengthenLevel;
end

--判断是否有宝石
function EquipmentInfoProxy:hasGem(userEquipmentId)
  local resualt = false;
  -- local equipmentInfo = self:getEquipmentInfo(userEquipmentId);
  -- for k,v in pairs(equipmentInfo.HoleArray)do
  --   if 0 ~= v.ItemId then
  --     resualt = true;
  --     return resualt;
  --   end
  -- end
  return resualt;
end

--获得宝石ItemId数组
function EquipmentInfoProxy:getGemArray(userEquipmentId)
	local equipmentInfo = self:getEquipmentInfo(userEquipmentId);
	local returnTbl = {};
	for k,v in pairs(equipmentInfo.HoleArray)do
		if 0 ~= v.ItemId then
			table.insert(returnTbl,v);
		end
	end
	return returnTbl;
end

function EquipmentInfoProxy:getGemSellSilver(userEquipmentId)
  local a=self:getGemArray(userEquipmentId);
  local b=0;
  for k,v in pairs(a) do
    b=b+analysis("Daoju_Daojubiao",v.ItemId,"price");
  end
  return b;
end

function EquipmentInfoProxy:refreshShipinXinlianChenggong(data)
  local equip_data = self:getEquipInfoByHeroIDAndItemID(data.GeneralId, data.ItemId);
  equip_data.PropertyArray = data.PropertyArray;
end