require "main.config.BattleConfig";
require "main.config.BagConstConfig";
require "main.common.CommonExcel";

BagProxy=class(Proxy);

function BagProxy:ctor()
  self.class=BagProxy;
  self.data={};
  self.const_body_item_id=1103;
  self.const_weapon_item_id=1101;
  self.const_debris_item_id=1300;
  self.debrisArray = {};
  self.skeleton=nil;
  self.hasDebris = false;
end

rawset(BagProxy,"name","BagProxy");

--更新道具
function BagProxy:refresh(userItemArray,booleanValue)
  if 1==booleanValue then -- or 3==booleanValue
    local function sortfunc(data_a,data_b)
      return data_a.Place < data_b.Place;
    end
    self.data=userItemArray;
    table.sort(self.data,sortfunc);
    for k,v in pairs(self.data) do
      if analysisHas("Daoju_Daojufenlei",math.floor(v.ItemId/1000)) then
        v.Tab = analysis("Daoju_Daojufenlei",math.floor(v.ItemId/1000),"tab");
      else
        v.Tab = 0;
      end
    end
  else
    for k,v in pairs(userItemArray) do
      self:refreshItem(v);
    end
  end
  if 3==booleanValue then -- or 3==booleanValue
    local function sortfunc(data_a,data_b)
      return data_a.Place < data_b.Place;
    end
    table.sort(self.data,sortfunc);
  end
  -- self:classify();
end

--更新一道具
function BagProxy:refreshItem(userItem)
  local uid=userItem.UserItemId;
  if analysisHas("Daoju_Daojufenlei",math.floor(userItem.ItemId/1000)) then
    userItem.Tab = analysis("Daoju_Daojufenlei",math.floor(userItem.ItemId/1000),"tab");
  else
    userItem.Tab = 0;
  end
  for k,v in pairs(self.data) do
    if uid==v.UserItemId then
      for k_,v_ in pairs(v) do
        v[k_]=userItem[k_];
      end
      if 0==userItem.Count then
        table.remove(self.data,k);
      end
      return;
    end
  end
  table.insert(self.data,userItem);
end

--ItemId2 打造前
function BagProxy:refreshItemByForge(userItemId, itemId, itemId2)
  local itemData=self:getItemData(userItemId);
  if itemData then
    itemData.ItemId=itemId;
  end
end

function BagProxy:getAllItemData(itemID)
  local a={};
  itemID=tonumber(itemID);
  for k,v in pairs(self.data) do
    if itemID==v.ItemId and (BagConstConfig.STORAGE[1]>v.Place or BagConstConfig.STORAGE[2]<v.Place) then
      table.insert(a,v);
    end
  end
  return a;
end

function BagProxy:getBodyItemID()
  if nil==self.data then
    return nil;
  end
  for k,v in pairs(self.data) do
    if 1==v.IsUsing and self.const_body_item_id==math.floor(v.ItemId/1000) then
      return v.ItemId;
    end
  end
end

--通过装备位置获取数据
function BagProxy:getEquipDataByPlace(placeId)
  if nil==self.data then
    return {};
  end
  local equipTb = {};
  for k,v in pairs(self.data) do
    local itemId = v.ItemId;
    local needId = math.floor(itemId/100000);
    if needId > 10 then
      local needId2 = math.floor(needId/10);
      if needId2 == placeId then
        table.insert(equipTb, v);
      end;
    end;
  end
  return equipTb;
end

function BagProxy:getEquipDataNotUsedByPlace(placeId)
  if nil==self.data then
    return {};
  end
  local equipTb = {};
  for k,v in pairs(self.data) do
    local itemId = v.ItemId;
    local needId = math.floor(itemId/100000);
    if needId > 10 then
      local needId2 = math.floor(needId/10);
      if needId2 == placeId and 0 == v.IsUsing then
        table.insert(equipTb, v);
      end;
    end;
  end
  return equipTb;
end


function BagProxy:getCountInBag()
  local _count = 0;
  for k,v in pairs(self.data) do
    if BagConstConfig.BAG[1] > v.Place or BagConstConfig.BAG[2] < v.Place then

    else
      _count = 1 + _count;
    end
  end
  return _count;
end

function BagProxy:getPageViewDatas(count, num)
  local _place = 0;
  for k,v in pairs(self.data) do
    if BagConstConfig.BAG[1] > v.Place or BagConstConfig.BAG[2] < v.Place or 1 == v.IsUsing then

    elseif num == v.Tab then
      _place = 1 + _place;
    end
  end
  if 0 == _place then
    _place = 1;
  end
  count = math.ceil(_place/count) * count;

  local _data = {};
  local _count =0;
  while count > _count do
    _count = 1 + _count;
    table.insert(_data, _count);
  end
  return _data;
end

function BagProxy:getPageViewData(num, id)
  local _place = 0;
  for k,v in pairs(self.data) do
    if BagConstConfig.BAG[1] > v.Place or BagConstConfig.BAG[2] < v.Place or 1 == v.IsUsing then

    elseif num == v.Tab then
      _place = 1 + _place;
      if id == _place then
        return v;
      end
    end
  end
end

--道具
function BagProxy:getData()
  return self.data;
end

function BagProxy:getDataInBags()
  
end

function BagProxy:getPlaceDataByItemID(itemID)
  local a={};
  for k,v in pairs(self.data) do
    if itemID==v.ItemId then
      local b={Count=v.Count,Place=v.Place};
      table.insert(a,b);
    end
  end
  return a;
end

function BagProxy:getItemData(userItemID)
  for k,v in pairs(self.data) do
    --print("v.UserItemId",v.UserItemId,userItemID);
    if userItemID==v.UserItemId then
      return v;
    end
  end
end

function BagProxy:getItemDataByPlace(place)
  for k,v in pairs(self.data) do
    if place == v.Place then
      return v;
    end
  end
end

function BagProxy:getUserItemId(itemID)
  for k,v in pairs(self.data) do
    if itemID==v.ItemId then
      return v.UserItemId;
    end
  end
  return nil;
end

function BagProxy:getItemDataIsUsing(userItemID)
  return 1==self:getItemData(userItemID).IsUsing;
end

function BagProxy:getItemNum(itemID)
  local itemCount = 0;
  itemID = tonumber(itemID);
  for k,v in pairs(self.data) do
    if itemID == v.ItemId and (BagConstConfig.STORAGE[1] > v.Place or BagConstConfig.STORAGE[2]<v.Place) then
      itemCount = v.Count + itemCount;
    end
  end
  return itemCount;
end


function BagProxy:getUsingItemNum(itemID)
  local a=0;
  itemID=tonumber(itemID);
  for k,v in pairs(self.data) do
    if itemID==v.ItemId and (BagConstConfig.USING[1]<= v.Place and BagConstConfig.USING[2]>=v.Place) then
      a=v.Count+a;
    end
  end
  return a;
end

function BagProxy:getUserItemIDUseByCategory(itemID)
  if nil==self.data then
    return nil;
  end
  local categoryID=math.floor(itemID/1000);
  for k,v in pairs(self.data) do
    if 1==v.IsUsing and categoryID==math.floor(v.ItemId/1000) then
      return v.UserItemId;
    end
  end
end

--道具分类放置
function BagProxy:classify()
  self.debrisArray={};
  for k,v in pairs(self.data) do
      if self.const_debris_item_id==math.floor(v.ItemId/1000) and (BagConstConfig.STORAGE[1]>v.Place or BagConstConfig.STORAGE[2]<v.Place) then
        self.hasDebris = true;
	      table.insert(self.debrisArray,copyTable(v));
      end
  end
  for k,v in pairs(self.debrisArray) do
      if v.Count ~= 0 then
          local tempCount = 0
          for k1,v1 in pairs(self.debrisArray) do
                if v1.ItemId == v.ItemId then
                    tempCount = v1.Count + tempCount;
                    self.debrisArray[k1].Count = 0;
                end
          end
          self.debrisArray[k].Count = tempCount;
      end
  end
end

--碎片
local function sortOnQuality(a, b)
  if a.quality<b.quality then
    return true;
  end
  return false;
end

function BagProxy:getDebrisArr()
    local len = 1;
    local sortTable = {};
    for k,v in pairs(self.debrisArray) do
          if v.Count ~= 0 then
              local parameter1 = analysis("Daoju_Daojubiao",v.ItemId,"parameter1");
              v.quality = analysis("Yinghun_Yinghunku",parameter1,"quality");
              sortTable[len] = v;
              len = len + 1;
          end
    end
    table.sort(sortTable, sortOnQuality)
    return sortTable;
end

function BagProxy:isDebrisFull()
    local len = 0;
    for k,v in pairs(self.debrisArray) do
          len = len + 1;
    end
    if len >= 32 then
        return true;
    else
        return false;
    end
end

function BagProxy:getCommonStuff4Totem()
  local a={};
  itemID=tonumber(itemID);
  for k,v in pairs(self.data) do
    if 33==analysis("Daoju_Daojubiao",v.ItemId,"functionID") and (BagConstConfig.STORAGE[1]>v.Place or BagConstConfig.STORAGE[2]<v.Place) then
      table.insert(a,v);
    end
  end
  return a;
end

function BagProxy:setStrongPointIdByUserItemID(userItemID, strongPointID)
  local data=self:getItemData(userItemID);
  if data then
    data.strongPointID=strongPointID;
  else
    error("");
  end
end

function BagProxy:getStrongPointIdByUserItemID(userItemID)
  local data=self:getItemData(userItemID);
  if data then
    return data.strongPointID;
  end
end

--"petStuff"
function BagProxy:getPetStuff(string)
  local a=StringUtils:lua_string_split(string,",");
  local petStuff={};
  for k,v in pairs(self.data) do
    if(BagConstConfig.STORAGE[1]>v.Place or BagConstConfig.STORAGE[2]<v.Place) then

      for k_,v_ in pairs(a) do
        if tonumber(v_)==v.ItemId then
          table.insert(petStuff,v);
        end
      end
      
    end
  end
  return petStuff;
end

--龙骨
function BagProxy:getSkeleton()
  if nil==self.skeleton then
    self.skeleton=SkeletonFactory.new();
    self.skeleton:parseDataFromFile("bag_ui");
  end
  return self.skeleton;
end

function BagProxy:getWeaponItemID()
  if nil==self.data then
    return nil;
  end
  for k,v in pairs(self.data) do
    if 1==v.IsUsing and self.const_weapon_item_id==math.floor(v.ItemId/1000) then
      return v.ItemId;
    end
  end
end

--英魂碎片评分
function BagProxy:getChipScore(itemID)
  local spirit_configID=analysis("Daoju_Daojubiao",itemID,"parameter1");
  local atk=analysis("Yinghun_Yinghunku",spirit_configID,"atk");
  local def=analysis("Yinghun_Yinghunku",spirit_configID,"def");
  local hp=analysis("Yinghun_Yinghunku",spirit_configID,"hp");
  local skill_table=StringUtils:lua_string_split(analysis("Yinghun_Yinghunku",spirit_configID,"skill"),",");

  return math.floor(atk*self:getChipScoreAverage(skill_table,1)
                    +def*0.8*self:getChipScoreAverage(skill_table,2)
                    +hp*0.12*self:getChipScoreAverage(skill_table,3)
                    +self:getChipScoreAdded(skill_table,1)
                    +self:getChipScoreAdded(skill_table,2)
                    +0.12*self:getChipScoreAdded(skill_table,3));
end

--英魂碎片额外系数
function BagProxy:getChipScoreAdded(skill_table, type)
  local a=0;
  for k,v in pairs(skill_table) do
    local skill_type=analysis("Jineng_Wujiangjineng",v,"type");
    if type==skill_type then
      a=analysis("Jineng_Wujiangjineng",v,"amount")+a;
    end
  end
  return a;
end

--英魂碎片技能平均系数
--1为伤害技能，2为辅助技能，3为特殊技能
function BagProxy:getChipScoreAverage(skill_table, type)
  local a=0;
  local num=0;
  for k,v in pairs(skill_table) do
    local skill_type=analysis("Jineng_Wujiangjineng",v,"type");
    if type==skill_type then
      num=1+num;
      a=1+analysis("Jineng_Wujiangjineng",v,"percentage")/100000+a;
    end
  end
  if 0==num then
    return 1;
  end
  return a/num;
end

--换装
function BagProxy:getCompositeRoleTable(career)
  local itemIdBody=self:getBodyItemID();
  local itemIdWeapon=self:getWeaponItemID();
  return self:getCompositeRoleTable4Player(itemIdBody,itemIdWeapon,career);
end

--更新玩家
function BagProxy:getCompositeRoleTable4Player(itemIdBody, itemIdWeapon, career)
  if itemIdBody then
    --itemIdBody=self:getArtsID(itemIdBody,career);
  else
    -- itemIdBody=analysis("Zhujiao_Zhujiaozhiye",career,"shenti");
    itemIdBody=analysis("Zhujiao_Huanhua",career,"body");
  end

  if itemIdWeapon then
    --itemIdWeapon=self:getArtsID(itemIdWeapon,career);
  else
    --itemIdWeapon=analysis("Zhujiao_Zhujiaozhiye",career,"wuqi");
  end
  
  local sourceTable = {[1] = plistData["key_" .. itemIdBody .. "_" .. BattleConfig.HOLD].source}--,
                        --[2]= plistData["key_" .. itemIdWeapon .. "_" .. BattleConfig.HIT_PI].source};
  for k,v in ipairs(sourceTable) do
      BitmapCacher:animationCache(v);
  end
  
  return {[1] = {["type"] = BattleConfig.TRANSFORM_BODY, ["sourceName"] = itemIdBody .. "_" .. BattleConfig.HOLD}}--,
          --[2] = {["type"] = BattleConfig.TRANSFORM_WEAPON, ["sourceName"] = itemIdWeapon .. "_" .. BattleConfig.HIT_PI}};
end

function BagProxy:getCompositeRoleTableReload(career)
  local a={};
  local b=self:getCompositeRoleTable(career);
  for k,v in pairs(b) do
    a[v["type"]]=self:getSourceName(v["sourceName"]);
  end
  return a;
end

function BagProxy:getRoleSize(career)
  local itemIdBody=self:getBodyItemID();
  if itemIdBody then
    itemIdBody=self:getArtsID(itemIdBody,career);
  else
    itemIdBody=analysis("Zhujiao_Zhujiaozhiye",career,"shenti");
  end
  return getFrameContentSize(itemIdBody .. "_" .. BattleConfig.HIT_PI);
end

function BagProxy:getArtsID(itemID, career)
  local a=1;
  while analysisHas("Zhuangbei_Zhuangbeisucaiduizhao",a) do
    local equipmentId=analysis("Zhuangbei_Zhuangbeisucaiduizhao",a,"equipmentId");
    local occupation=analysis("Zhuangbei_Zhuangbeisucaiduizhao",a,"occupation");
    if itemID==equipmentId and career==occupation then
      return analysis("Zhuangbei_Zhuangbeisucaiduizhao",a,"stuffId");
    end
    a=1+a;
  end
end

function BagProxy:getSourceName(sourceName)
  return StringUtils:lua_string_split(sourceName, "_")[1];
end

function BagProxy:getBagIsFull()
  local a=0;
  local placeOpened=analysis("Xishuhuizong_Xishubiao",1011,"constant");
  for k,v in pairs(self.data) do
    if 1==v.IsUsing or (BagConstConfig.BAG[1]>v.Place or BagConstConfig.BAG[2]<v.Place) then

    else
      a=1+a;
    end
  end
  return a>=placeOpened;
end

--获得背包剩余格子数
function BagProxy:getBagLeftPlaceCount(itemUseQueueProxy)
  local a=0;
  local placeOpened=analysis("Xishuhuizong_Xishubiao",1011,"constant");--itemUseQueueProxy:getPlaceOpenedCount();
  for k,v in pairs(self.data) do
    if 0==v.Count or 1==v.IsUsing or 0==v.Place or placeOpened<v.Place then

    else
      a=1+a;
    end
  end
  return placeOpened - a;
end

function BagProxy:getItemsByFunctionId(functionId)
  local returnValue = {};
  for k,v in pairs(self.data) do
    local curFunctionID=analysis("Daoju_Daojubiao", v.ItemId, "functionID");
    if functionId == curFunctionID then
      table.insert(returnValue, v);
    end
  end
  return returnValue;
end

function BagProxy:getStrengthenItemsByPlaceId(placeID)
  local returnValue = {};
  for k,v in pairs(self.data) do
    if analysisHas("Zhuangbei_Zhuangbeipeizhibiao",v.ItemId) then
      local place=analysis("Zhuangbei_Zhuangbeipeizhibiao", v.ItemId, "place");
      if place and place == placeID then
        table.insert(returnValue, v);
      end
    end
  end
  return returnValue;
end

function BagProxy:hasEnoughPlace4Item(itemUseQueueProxy, itemID, count)
  if not count then
    count=1;
  end
  local a=analysis("Daoju_Daojubiao",itemID,"overlap");
  local b=self:getAllItemData(itemID);
  local c=0;
  for k,v in pairs(b) do
    c=-v.Count+a+c;
  end
  return self:getBagLeftPlaceCount(itemUseQueueProxy)*a+c>count;
end

--宠物技能书 typeId==1 主动，typeId==2 被动 typeId==nil全部
function BagProxy:getPetSkillBooks(typeId)
  local returnTable={}
  for i,v in ipairs(self.data) do
    if math.floor(v.ItemId/1000)==1224 then
      if typeId==nil then
        returnTable[#returnTable+1] = v;
      else
        local skillId=analysis("Daoju_Daojubiao",v.ItemId,"parameter1");
        if math.floor(skillId/10000)==3 and typeId==1 then
          returnTable[#returnTable+1] = v;
        end  
        if math.floor(skillId/10000)==2 and typeId==2 then
          returnTable[#returnTable+1] = v;
        end  
      end
    end
  end

 -- for i,v in ipairs(returnTable) do
 --   print("returnTable:",i,v,v.ItemId)
 -- end
  return returnTable
end

--注意，只是背包里面的道具,不是整个道具表
function BagProxy:getItemIdByPetSkillIdFromBag(petSkillId)
  local tableSource = self:getPetSkillBooks()
  if #tableSource==0 then return 0 end;

  local itemId = 0;
  for i,v in ipairs(tableSource) do
    local tempId = analysis("Daoju_Daojubiao",v.ItemId,"parameter1");
    if tempId==petSkillId then
      itemId = v.ItemId;
      break
    end
  end
  return itemId
end

--从表里查，与上对应getItemIdByPetSkillIdFromBag
function BagProxy:getItemIdByPetSkillIdFromTable(petSkillId)
  local itemId = 0;
  local tt = analysisByName("Daoju_Daojubiao","parameter1",petSkillId)
  for k,v in pairs(tt) do
    for k1,v1 in pairs(v) do
      --print("====",k1,v1)
      if k1=="id" and math.floor(tonumber(v1)/1000)==1224 then
        itemId = v1;
        break
      end
    end
  end
  return itemId;
end

function BagProxy:getUserItemIdByPetSkillId(petSkillId)
  local itemIdSource = self:getItemIdByPetSkillIdFromBag(petSkillId)
  --print("111userItemIdArray:",itemIdSource)
  if itemIdSource==0 then return 0 end;

  local userItemIdArray = self:getAllItemData(itemIdSource)
  for k,v in pairs(userItemIdArray) do
    --print("112userItemIdArray:",k,v)
    for k1,v1 in pairs(v) do
      --print(k1,v1)
    end
  end
  --print("113userItemIdArray:",#userItemIdArray)
  return userItemIdArray[1].UserItemId
end