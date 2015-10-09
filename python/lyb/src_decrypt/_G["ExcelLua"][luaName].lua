
function unrequireExcel(luaName,pathName)
  -- print("release Excel",luaName)
  _G["ExcelLua"][luaName] = nil;
  package.loaded[pathName..luaName] = nil;
end

local analysisCache = {};
local analysisByNameCache = {};
local analysis2keyCache = {};
local analysis3keyCache = {};
local analysisHasCache = {};
local analysisTotalTableCache = {};
local analysisTotalTableArrayCache = {};

function ExcelCacheClean()
  analysisCache = {};
  analysisByNameCache = {};
  analysis2keyCache = {};
  analysis3keyCache = {};
  analysisHasCache = {};
  analysisTotalTableCache = {};
  analysisTotalTableArrayCache = {};
end

function analysisWithCache(luaName,key,paramName)
  local k = (luaName and luaName or "")
            .. "|" .. (key and key or "")
            .. "|" .. (paramName and paramName or "");
  if nil == analysisCache[k] then
    analysisCache[k] = analysis(luaName,key,paramName);
  end
  return analysisCache[k];
end
function analysisByNameWithCache(luaName,paramName,value)
  local k = (luaName and luaName or "")
            .. "|" .. (paramName and paramName or "")
            .. "|" .. (value and value or "");
  if nil == analysisByNameCache[k] then
    analysisByNameCache[k] = analysisByName(luaName,paramName,value);
  end
  return analysisByNameCache[k];
end
function analysis2keyWithCache(luaName,p1,p1value,p2,p2value)
  local k = (luaName and luaName or "")
            .. "|" .. (p1 and p1 or "")
            .. "|" .. (p1value and p1value or "")
            .. "|" .. (p2 and p2 or "")
            .. "|" .. (p2value and p2value or "");
  if nil == analysis2keyCache[k] then
    analysis2keyCache[k] = analysis2key(luaName,p1,p1value,p2,p2value);
  end
  return analysis2keyCache[k];
end
function analysis3keyWithCache(luaName,p1,p1value,p2,p2value,p3,p3value)
  local k = (luaName and luaName or "")
            .. "|" .. (p1 and p1 or "")
            .. "|" .. (p1value and p1value or "")
            .. "|" .. (p2 and p2 or "")
            .. "|" .. (p2value and p2value or "")
            .. "|" .. (p3 and p3 or "")
            .. "|" .. (p3value and p3value or "");
  if nil == analysis3keyCache[k] then
    analysis3keyCache[k] = analysis3key(luaName,p1,p1value,p2,p2value,p3,p3value);
  end
  return analysis3keyCache[k];
end
function analysisHasWithCache(luaName,key)
  local k = (luaName and luaName or "")
            .. "|" .. (key and key or "");
  if nil == analysisHasCache[k] then
    analysisHasCache[k] = analysisHas(luaName,key);
  end
  return analysisHasCache[k];
end
function analysisTotalTableWithCache(luaName)
  local k = (luaName and luaName or "");
  if nil == analysisTotalTableCache[k] then
    analysisTotalTableCache[k] = analysisTotalTable(luaName);
  end
  return analysisTotalTableCache[k];
end
function analysisTotalTableArrayWithCache(luaName)
  local k = luaName and luaName or "";
  if nil == analysisTotalTableArrayCache[k] then
    analysisTotalTableArrayCache[k] = analysisTotalTableArray(luaName);
  end
  return analysisTotalTableArrayCache[k];
end


function analysis(luaName,key,paramName)
    local luaFileName = "resource.bin.client."..luaName

    require(luaFileName)
  
    local tableName = ExcelLua[luaName]
    local table1 = tableName[1]
    
    local realKey
    if(key ~= nil) then
      realKey = "key"..key
    end
    
    -- 根据不同参数返回不同值
    if(realKey == nil) then
      -- if luaName ~= "Yuyanbao_Yuyanbao" and GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then
      --   for k,v in pairs(tableName)do
      --       if 1 == k then
              
      --       else
      --          for k2, v2 in pairs(v) do
      --           if type(v2) == "string" then-- 
      --             local beginIndex, endIndex = string.find(v2, "_@_")
      --             if beginIndex then
      --               local keyIndex = string.sub(v2, 4)
      --               if analysisHas("Yuyanbao_Yuyanbao", keyIndex) then
      --                 v[k2] = analysis("Yuyanbao_Yuyanbao", keyIndex).zhongwenfanti
      --               end
      --             end
      --           end
      --         end
      --       end
      --   end
      -- end
      return tableName
    elseif(paramName == nil) then--
      local returnTable = {}
      for k,v in pairs(table1) do
        local temp = tableName[realKey]
        if temp then
          returnTable[v] = temp[k]
        end
      end
      returnTable = copyTable(returnTable)
      -- if luaName ~= "Yuyanbao_Yuyanbao" and GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then
      --   for k2, v2 in pairs(returnTable) do
      --     if type(v2) == "string" then-- 
      --       local beginIndex, endIndex = string.find(v2, "_@_")
      --       if beginIndex then
      --         local keyIndex = string.sub(v2, 4)
      --         if analysisHas("Yuyanbao_Yuyanbao", keyIndex) then
      --           returnTable[k2] = analysis("Yuyanbao_Yuyanbao", keyIndex).zhongwenfanti
      --         end
      --       end
      --     end
      --   end
      -- end
      -- unrequireExcel(luaName, "resource.bin.client.");
      return returnTable
    else
      local index
      for k,v in pairs(table1) do
       if(paramName == v) then
         index = k
         break
       end
      end
      if nil==tableName or nil==tableName[realKey] or nil==tableName[realKey][index] then
        print("ExcelError",luaName,realKey,paramName,index);
      end
      local result = tableName[realKey][index]

      -- if luaName ~= "Yuyanbao_Yuyanbao" and GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE  then
      --     if type(result) == "string" then-- GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE
      --       local beginIndex, endIndex = string.find(result, "_@_")
      --       if beginIndex then
      --         local keyIndex = string.sub(result, 4)
      --         if analysisHas("Yuyanbao_Yuyanbao", keyIndex) then
      --           result = analysis("Yuyanbao_Yuyanbao", keyIndex).zhongwenfanti
      --         end
      --       end
            
      --     end
      -- end
      -- unrequireExcel(luaName, "resource.bin.client.");
      return result
    end
end

-- --
--    luaName lua文件名
--    paramName 变量名
--    value 变量值
function analysisByName(luaName,paramName,value)
    
    local luaFileName = "resource.bin.client."..luaName
    if GameData.connectType ~= 0 then
        package.loaded[luaFileName] = nil
    end
    require(luaFileName)
  
    local tableName = ExcelLua[luaName]
    local table1 = tableName[1]
    
    local nameIndex
    for k,v in pairs(table1) do
      if(v == paramName) then
        nameIndex = k
        break;
      end
    end
   
    local returnTable = {}
    for k,v in pairs(tableName) do
      if(v[nameIndex] == value) then
         local temp = {};
         for i_k, i_v in pairs(v) do 
            -- if luaName ~= "Yuyanbao_Yuyanbao" and GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then--and GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE
            --   if type(i_v) == "string" then-- 
            --     local beginIndex, endIndex = string.find(i_v, "_@_")
            --     if beginIndex then
            --       local keyIndex = string.sub(i_v, 4)
            --       if analysisHas("Yuyanbao_Yuyanbao", keyIndex) then
            --         i_v = analysis("Yuyanbao_Yuyanbao", keyIndex).zhongwenfanti
            --       end
            --     end
            --   end
            -- end
           temp[table1[i_k]] = i_v;
         end
         returnTable[k] = temp;
      end
    end
    returnTable = copyTable(returnTable)
    -- unrequireExcel(luaName, "resource.bin.client.");
    return returnTable;
end

function analysis2key(luaName,p1,p1value,p2,p2value)
  local luaFileName = "resource.bin.client."..luaName
  if GameData.connectType ~= 0 then
      package.loaded[luaFileName] = nil
  end
  require(luaFileName)

  local result 
  local tableName = ExcelLua[luaName]
  local table1 = tableName[1]
  
  local nameIndex1,nameIndex2
  for k,v in pairs(table1) do
    if(v == p1) then
      nameIndex1 = k
    end
    if(v == p2) then
      nameIndex2 = k
    end
  end

  for k,v in pairs(tableName) do
    if v[nameIndex1]==p1value and v[nameIndex2]==p2value then
      local temp = {};
      for i_k, i_v in pairs(v) do 

         -- if luaName ~= "Yuyanbao_Yuyanbao" and GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then--
         --    if type(i_v) == "string" then-- 
         --      local beginIndex, endIndex = string.find(i_v, "_@_")
         --      if beginIndex then
         --        local keyIndex = string.sub(i_v, 4)
         --        if analysisHas("Yuyanbao_Yuyanbao", keyIndex) then
         --          i_v = analysis("Yuyanbao_Yuyanbao", keyIndex).zhongwenfanti
         --        end
         --      end
         --    end
         --  end
         temp[table1[i_k]] = i_v;
      end
      result = temp
    end
  end
  return result
end

function analysis3key(luaName,p1,p1value,p2,p2value,p3,p3value)
  local luaFileName = "resource.bin.client."..luaName
  if GameData.connectType ~= 0 then
      package.loaded[luaFileName] = nil
  end
  require(luaFileName)

  local result 
  local tableName = ExcelLua[luaName]
  local table1 = tableName[1]
  
  local nameIndex1,nameIndex2,nameIndex3
  for k,v in pairs(table1) do
    if(v == p1) then
      nameIndex1 = k
    end
    if(v == p2) then
      nameIndex2 = k
    end
    if(v == p3) then
      nameIndex3 = k
    end
  end

  for k,v in pairs(tableName) do
    if v[nameIndex1]==p1value and v[nameIndex2]==p2value and v[nameIndex3]==p3value then
      local temp = {};
      for i_k, i_v in pairs(v) do 

         -- if luaName ~= "Yuyanbao_Yuyanbao" and GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then--
         --    if type(i_v) == "string" then-- 
         --      local beginIndex, endIndex = string.find(i_v, "_@_")
         --      if beginIndex then
         --        local keyIndex = string.sub(i_v, 4)
         --        if analysisHas("Yuyanbao_Yuyanbao", keyIndex) then
         --          i_v = analysis("Yuyanbao_Yuyanbao", keyIndex).zhongwenfanti
         --        end
         --      end
         --    end
         --  end
         temp[table1[i_k]] = i_v;
      end
      result = temp
    end
  end
  return result
end

function analysisByNameForSort(luaName,paramName,value)
    
    local luaFileName = "resource.bin.client."..luaName
    if GameData.connectType ~= 0 then
        package.loaded[luaFileName] = nil
    end
    require(luaFileName)
  
    local tableName = ExcelLua[luaName]
    local table1 = tableName[1]
    
    local nameIndex
    for k,v in pairs(table1) do
      if(v == paramName) then
        nameIndex = k
        break;
      end
    end
    
    local returnTable = {}
    for k,v in pairs(tableName) do
      if(v[nameIndex] == value) then
         local temp = {};
         for i_k, i_v in pairs(v) do 
            -- if luaName ~= "Yuyanbao_Yuyanbao" and GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then--
            --   if type(i_v) == "string" then-- 
            --     local beginIndex, endIndex = string.find(i_v, "_@_")
            --     if beginIndex then
            --       local keyIndex = string.sub(i_v, 4)
            --       if analysisHas("Yuyanbao_Yuyanbao", keyIndex) then
            --         i_v = analysis("Yuyanbao_Yuyanbao", keyIndex).zhongwenfanti
            --       end
            --     end
            --   end
            -- end
           temp[table1[i_k]] = i_v;
         end
         --returnTable[k] = temp;
         table.insert(returnTable,temp)
      end
    end
    returnTable = copyTable(returnTable)
    -- unrequireExcel(luaName, "resource.bin.client.");
    return returnTable;
end

--根据键值来判断表里是否有该条数据
function analysisHas(luaName,key)
    
	local luaFileName = "resource.bin.client."..luaName
    require(luaFileName)
  
    local tableName = ExcelLua[luaName]
    local table1 = tableName[1]
    
    local realKey
    if(key ~= nil) then
      realKey = "key"..key
    end
    
    if(realKey == nil) then
      -- unrequireExcel(luaName, "resource.bin.client.");
      return false
    else
      if not tableName[realKey] then
        -- unrequireExcel(luaName, "resource.bin.client.");
        return false;
      else 
        -- unrequireExcel(luaName, "resource.bin.client.");
        return true;
      end
    end
end
--根据名称返回整个大表
function analysisTotalTable(luaName)
  local luaFileName = "resource.bin.client."..luaName
  if GameData.connectType ~= 0 then
    package.loaded[luaFileName] = nil
  end
  require(luaFileName)

  local tableName = ExcelLua[luaName]
  local table1 = tableName[1]

  local returnTable = {}
  for k,v in pairs(tableName) do
    if k ~= 1 then
      local temp = {};
      for i_k, i_v in pairs(v) do 
          -- if luaName ~= "Yuyanbao_Yuyanbao" and GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then--
          --   if type(i_v) == "string" then-- 
          --     local beginIndex, endIndex = string.find(i_v, "_@_")
          --     if beginIndex then
          --       local keyIndex = string.sub(i_v, 4)
          --       if analysisHas("Yuyanbao_Yuyanbao", keyIndex) then
          --         i_v = analysis("Yuyanbao_Yuyanbao", keyIndex).zhongwenfanti
          --       end
          --     end
          --   end
          -- end
         temp[table1[i_k]] = i_v;
       end
      returnTable[k] = temp;	
    end
  end
  returnTable = copyTable(returnTable)
  -- unrequireExcel(luaName, "resource.bin.client.");
  return returnTable;
end
--根据名称返回整个大表,大表是个数组，键值是数字
function analysisTotalTableArray(luaName)
    local luaFileName = "resource.bin.client."..luaName
    if GameData.connectType ~= 0 then
        package.loaded[luaFileName] = nil
    end
    require(luaFileName)
  
    local tableName = ExcelLua[luaName]
    local table1 = tableName[1]
    
    local returnTable = {}
    for k,v in pairs(tableName) do
      if k ~= 1 then
         local temp = {};
         for i_k, i_v in pairs(v) do 
            -- if luaName ~= "Yuyanbao_Yuyanbao" and GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then--
            --   if type(i_v) == "string" then-- 
            --     local beginIndex, endIndex = string.find(i_v, "_@_")
            --     if beginIndex then
            --       local keyIndex = string.sub(i_v, 4)
            --       if analysisHas("Yuyanbao_Yuyanbao", keyIndex) then
            --         i_v = analysis("Yuyanbao_Yuyanbao", keyIndex).zhongwenfanti
            --       end
            --     end
            --   end
            -- end
           temp[table1[i_k]] = i_v;
         end
         table.insert(returnTable, temp); 
      end
    end
    returnTable = copyTable(returnTable)
    -- unrequireExcel(luaName, "resource.bin.client.");
    return returnTable;
end

function getPetSkillLevel(skillMap,skillId)
  for key,skill in pairs(skillMap) do
    if skillId == skill.id then
      return skill.lv
    end
  end
end

function getPetSkillKey(skillId)
    --print(skillId.."=========getPetSkillKey============="..level)
    local skillConfig =  analysis2key("Jineng_Chongwuzhudongjineng","id",skillId,"lv",1)
    return skillConfig
end

function getAnalysisSkillRealKey(skillId)
  if skillId == 2201001 then
    local aaa = 111
  end
    local jinengPO = analysis("Jineng_Jineng",skillId)
    if not jinengPO.editorid or jinengPO.editorid<1 then return end
    local  realKey = "key".. jinengPO.editorid
    return realKey,jinengPO.duangjnzdid,jinengPO.typyP;
end
local function sortOnIndexID(a, b) return a.sortId < b.sortId end
function analysisSingalSkill(key)
    if key == "0" then return; end;
    --log(key.."=============analysisSingalSkill01=============="..career)
    local realKey = getAnalysisSkillRealKey(key)
    if not realKey or realKey == "key0" then return end
    log("=============analysisSingalSkill02=============  "..key.."  "..realKey)
    if BattleData.screenSkillArray[realKey] then
        return BattleData.screenSkillArray[realKey],BattleData.attackSkillArray[realKey],BattleData.beAttackSkillArray[realKey]
    end
      local fileName = "Jineng_zuhe"
    local luaFileName = "resource.bin.client."..fileName
    
      if GameData.connectType ~= 0 then
         package.loaded[luaFileName] = nil
      end
      
      require(luaFileName);
    
      local tableName = ExcelLua[fileName];
      local titleTable = tableName[1];
      local realSkill = tableName[realKey]

    local attackSkillTable = {};
    local beAttackSkillTable = {};
    local screenSkillTable = {};
    for k1,v1 in pairs(realSkill) do
      if k1 == "a1" or k1 == "a2" or k1 == "a3" or k1 == "a4" or k1 == "a5" or k1 == "a6"  or k1 == "a7" or k1 == "a8" or k1 == "a9" or k1 == "a10" then
        local aTable = {};
        for k2,v2 in pairs(v1) do
          if titleTable[k2] then
            aTable[titleTable[k2]] = v2;
          end
        end
        aTable.sortId = tonumber(string.sub(k1, 2, 3));
        table.insert(attackSkillTable,aTable)
      elseif k1 == "b1" or k1 == "b2" or k1 == "b3" or k1 == "b4" or k1 == "b5" or k1 == "b6" or k1 == "b7" or k1 == "b8" or k1 == "b9" or k1 == "b10" then
        local bTable = {};
        for k3,v3 in pairs(v1) do
          if titleTable[k3] then
            bTable[titleTable[k3]] = v3;
          end
        end
        table.insert(beAttackSkillTable,bTable)
        bTable.sortId = tonumber(string.sub(k1, 2, 3));
      else
        screenSkillTable[k1] = v1;  
      end
    end
    table.sort(attackSkillTable,sortOnIndexID)
    table.sort(beAttackSkillTable,sortOnIndexID)
    BattleData.screenSkillArray[realKey] = screenSkillTable;
    BattleData.beAttackSkillArray[realKey] = beAttackSkillTable;
    BattleData.attackSkillArray[realKey] = attackSkillTable;
    return screenSkillTable,attackSkillTable,beAttackSkillTable;
end

function analysisSkillthreeArr(key)
  if key == 0 or not key then return end
  local skillArr = StringUtils:lua_string_split(key,",")
  for k,v in pairs(skillArr) do
    analysisSingalSkill(v)
  end
end

-- 解析地图拼成的UI 庄园 区域图等
function analysisMapUI(mapUIIndex)
	local mapUIName = "manor_"..mapUIIndex
	local luaFileName = "resource.manors."..mapUIName
    if GameData.connectType ~= 0 then
        package.loaded[luaFileName] = nil
    end		
	require(luaFileName)
	
	local tableData = ManorLua[mapUIName]
	return tableData;
end

-- 解析bin用于联合主键keyStr:{keyName,keyName,....}(按表顺序写)   key:key1_key2
function analysisByUnionKey(luaName,keyStr,key)
  
  local luaFileName = "resource.bin.client."..luaName
  require(luaFileName)
  
  local tableKey = ExcelLua[luaName.."_"..table.concat( keyStr, "_")];
  local tableName = ExcelLua[luaName];
  local table1 = tableName[1]

  if not tableKey then
    local nameIndex=1;
    local valueIdxArr = {};
    tableKey = {};

    for k,v in pairs(table1) do
      if(v == keyStr[nameIndex]) then
        valueIdxArr[nameIndex] = k;
        nameIndex=nameIndex+1;
        if not keyStr[nameIndex] then break;end
      end
    end
    for k,v in pairs(tableName) do
      if k ~= 1 then
        local keyValueArr = {};
        for i,vi in ipairs(valueIdxArr) do
          keyValueArr[i]=v[vi];
        end
        tableKey[table.concat( keyValueArr, "_")]=k;
      end
    end
    ExcelLua[luaName.."_"..table.concat( keyStr, "_")]=tableKey;
  end
  local returnTable = {}
  tableKey = tableName[tableKey[key]];
  if not tableKey then return end
  for k,v in pairs(table1) do
    returnTable[v] = tableKey[k];
  end
  return returnTable;
end

-- 解析
function analysisWarPoint(warId)
   local warLua = "war_"..warId
   local luaFileName = "resource.wars."..warLua;
     if GameData.connectType ~= 0 then
         package.loaded[luaFileName] = nil
     end   
   require(luaFileName);
  
   local tableData = WarLua[warLua];

   return tableData.monstersTable;
end
function analysisMonsterConfigs(battleId,battleModeId)
  local monsterConfigs = {};
  local maxSubRound = {};
  local battleConfig = analysis("Zhandoupeizhi_Zhanchangpeizhi",battleId);
  local warConfigs = analysisWarPoint(battleModeId);
  -- local bossTable = {}
  for k,v in pairs(warConfigs) do
    local sr = maxSubRound[v.bigRoundId];
    if not sr or sr<v.smallRoundId then
      maxSubRound[v.bigRoundId]=v.smallRoundId;
    end
    local monsterConfig = {};
    monsterConfig.battleId = battleId;
    if not v.type or v.type<1 then v.type=1; end
    monsterConfig.level = battleConfig.lv;
    local monsterType = analysis("Guaiwu_Guaiwubiao",v.monsterId,"type");
    if monsterType == 2 or monsterType == 3 then
      monsterConfig.monsterType = monsterType;
      local cfqtejd = analysis("Guaiwu_Guaiwubiao",v.monsterId,"cfqtejd");
      cfqtejd = cfqtejd or 0
      monsterConfig.cfqtejd = cfqtejd>0 and cfqtejd or nil;
      -- table.insert(bossTable,{bigRoundId = v.bigRoundId,key = })
    end
    setParentTable(monsterConfig,v);
    table.insert(monsterConfigs,monsterConfig);
  end
  return monsterConfigs,maxSubRound;
end
function setParentTable(Child, ...)
  Child = Child or {};
  local pTables = {...};
  setmetatable(Child,{ __index =
  function (t, key)
    for i,v in pairs(pTables) do

      local value = v[key];
      if value then 
        return value;
      end
    end
    return nil;
  end
  });
  return Child;
end