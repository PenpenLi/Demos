-- require "main.view.heroScene.HeroConfig"

TimeCUtil = {};
TimeCUtil.time = 0;
function TimeCUtil:star()
  TimeCUtil.time = CommonUtils:getOSTime();
end
function TimeCUtil:getTime(s)
  if not s then
    s = "";
  end
  local v = CommonUtils:getOSTime();
  log("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT" .. s .. ": " .. (v - TimeCUtil.time));
  TimeCUtil.time = v;
end

HeroHouseProxy=class(Proxy);

function HeroHouseProxy:ctor()
  self.class=HeroHouseProxy;
  self.skeleton = nil
  self.team_skeleton = nil
  --GeneralId,ConfigId,UsingEquipmentArray,SkillArray,Level,Grade,IsPlay,Time,IsMainGeneral
  self.generalArray ={};--返回 英魂列表
  self.init = false;
  self.generalExp = {};
  self.generalHunli = {};
  self.treasuryGeneralArr = {};

  self.skillLevelUpGeneralIDCache = nil;
  self.skillLevelUpSkillIDCache = nil;
  self.skillLevelUpIncreaseCache = nil;

  self.shengjiGeneralIDCache = nil;
  self.shengjiTargetArrayCache = nil;
  self.shengjiLevelCache = nil;
  self.shengjiExpCache = nil;
  self.shengjiTotalExpCache = nil;

  self.jinjieGeneralIDCache = nil;
  self.jinjieTargetIDCache = nil;

  self.jinjieGeneralIDCache = nil;
  self.jinjieTargetArrayCache = nil;
  self.jinjieLevelCache = nil;
  self.jinjieExpCache = nil;
  self.jinjieTotalExpCache = nil;

  self.generalCount = 0;
  self.hongdianDatas = {};

  self.num_count = 0;
  self.smallLoadingKey = 0;

   self.FEBGeneralArr2 = {};
   self.FEBGeneralArr3 = {};
   self.FEBGeneralArr4 = {};
   self.FEBGeneralArr5 = {};
   self.FEBGeneralArr6 = {};

   self.employGeneralArray = nil;

   self.Hongidan_Huoyuedu=nil;
   self.Hongidan_Shenqingdu=nil;

   self.Jinengshengji_Bool = nil;
   self.Shengji_Bool = nil;
   self.selectConfiId = nil;

   self.Shengxing_Bool = nil;
   self.Jinjie_Bool = nil;

   self.Yuanfen_Jinjie_Bool = nil;

   self.peibing_peizhi = {};
end

function HeroHouseProxy:refreshYuanfenShengji(generalFateArray)
  for k,v in pairs(generalFateArray) do
    local data = self:getGeneralData(v.GeneralId);
    for k_,v_ in pairs(v.FateLevelArray) do
      for k__,v__ in pairs(data.FateLevelArray) do
        if v_.ID == v__.ID then
          v__.Level = v_.Level;
          break;
        end
      end
    end
  end
end

function HeroHouseProxy:refreshPeibingPeizhi(data)
  self.peibing_peizhi[data.Type] = data;
end

function HeroHouseProxy:getPeibingPeizhi(type)
  return self.peibing_peizhi[type];
end

function HeroHouseProxy:refreshEmployGeneralArray(employGeneralArray)
  self.employGeneralArray = employGeneralArray;
end

function HeroHouseProxy:refreshEmployGeneralArrayByType(generalId, place, type)
  for k,v in pairs(self.employGeneralArray) do
    if type == v.Type then
      v.GeneralId = generalId;
      v.Place = place;
      return;
    end
  end
  table.insert(self.employGeneralArray,{GeneralId=generalId,Place=place,Type=type});
end

function HeroHouseProxy:getGuyongGeneralIDByType(type)
  for k,v in pairs(self.employGeneralArray) do
    if type == v.Type and 0 ~= v.GeneralId then
      return v.GeneralId;
    end
  end
end

function HeroHouseProxy:createHongdianData(generalID)
  local hongdianData = {GeneralId = generalID,

                        BetterEquip = nil,
                        Levelable = nil,
                        Gradeable = nil,
                        StarLevelable = nil,
                        Skillable = nil,
                        BetterJinjieEquip = nil,
                        Yuanfenable = nil,

                        Sign_Main = nil,
                        Sign_House = nil,

                        Sign_BetterEquip = {[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0},
                        Sign_Levelable = nil,
                        Sign_Gradeable = nil,
                        Sign_StarLevelable = nil,
                        Sign_Skillable = nil,
                        Sign_BetterJinjieEquip = {[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0},
                        Sign_Yuanfen = {}};
  return hongdianData;
end

function HeroHouseProxy:getHongdianData(generalID)
  for k,v in pairs(self.hongdianDatas) do
    if generalID == v.GeneralId then
      return v;
    end
  end
  local hongdianData = self:createHongdianData(generalID);
  table.insert(self.hongdianDatas, hongdianData);
  return hongdianData;
end

function HeroHouseProxy:setHongdianDatas()
  if self.hongdianDatasSet then
    return;
  end
  self.hongdianDatasSet = true;
  for k,v in pairs(self.generalArray) do
    self:setHongdianData(v.GeneralId);
  end
  require "main.controller.command.hero.HeroRedDotRefreshCommand";
  HeroRedDotRefreshCommand.new():execute();
end

function HeroHouseProxy:setHongdianData(generalID, set_type)
  if not self.hongdianDatasSet then
    return;
  end
  local bagProxy = Facade.getInstance():retrieveProxy(BagProxy.name);
  local userProxy = Facade.getInstance():retrieveProxy(UserProxy.name);
  local userCurrencyProxy = Facade.getInstance():retrieveProxy(UserCurrencyProxy.name);
  local generalListProxy = Facade.getInstance():retrieveProxy(GeneralListProxy.name);
  local equipmentInfoProxy = Facade.getInstance():retrieveProxy(EquipmentInfoProxy.name);
  local openFunctionProxy = Facade.getInstance():retrieveProxy(OpenFunctionProxy.name);
  local generalData = self:getGeneralData(generalID);
  local hongdianData = self:getHongdianData(generalID);
  local isMainGeneral = 1 == generalData.IsMainGeneral;
  local mainGeneralData = self:getMainGeneral();

  local function setBetterEquip()
    if not openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_14) then
      hongdianData.BetterEquip = nil;
      return;
    end
    -- if true then hongdianData.BetterEquip = nil;return;end
    -- if 2 > tonumber(generalData.Level) then hongdianData.BetterEquip = nil;return; end
    local tb = {[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0};

    local job = analysis("Kapai_Kapaiku",generalData.ConfigId,"job");

    for k,v in pairs(tb) do
      if 1 == hongdianData.Sign_BetterEquip[k] or 2 == k or 6 == k then

      else
        local equip_data = equipmentInfoProxy:getEquipInfoByHeroIDAndPlace(generalID,k);
        local jinjieData = analysis2keyWithCache("Zhuangbei_Zhuangbeijinjiebiao","job",job,"equipmentId",equip_data.ItemId);
        if jinjieData and 0 ~= jinjieData.target and equip_data.StrengthenLevel >= jinjieData.levelLimit then
        
        elseif equip_data.StrengthenLevel < generalData.Level and analysisHasWithCache("Zhuangbei_Zhuangbeiqianghua",1+equip_data.StrengthenLevel) then
          -- local silver_need = math.floor(analysis("Zhuangbei_Zhuangbeiqianghua",1+equip_data.StrengthenLevel,"cost")*analysis("Zhuangbei_Zhuangbeipeizhibiao",equip_data.ItemId,"level")/40);
          local silver_need = analysis("Zhuangbei_Zhuangbeiqianghua",1+equip_data.StrengthenLevel,"cost");
          if userCurrencyProxy:getSilver() >= silver_need then
            tb[k] = 1;
          end
        end
      end
    end
    for k,v in pairs(tb) do
      if 1 == v then
        hongdianData.BetterEquip = tb;
        return;
      end
    end
    hongdianData.BetterEquip = nil;
  end

  local function setLevelable()
    -- if isMainGeneral then
    --   hongdianData.Levelable = nil;
    --   return;
    -- end
    -- if true then hongdianData.Levelable = nil;return;end
    local exp = generalData.Experience;
    local level = generalData.Level;
    if not analysisHas("Kapai_Kapaishengjijingyan",1+level) then
      hongdianData.Levelable = nil;
      return;
    end
    if 1 + level > userProxy:getLevel() then
      hongdianData.Levelable = nil;
      return;
    end
    local needExp = analysis("Kapai_Kapaishengjijingyan",1+level,"exp") - exp;
    local datas;
    if isMainGeneral then
      datas = {[1012006] = 0};
    else
      datas = {[1012001] = 0, [1012002] = 0, [1012003] = 0, [1012004] = 0};
    end
    local bagDatas = bagProxy:getData();
    local expFeed = 0;
    for k,v in pairs(bagDatas) do
      if datas[v.ItemId] then
        expFeed = analysis("Daoju_Daojubiao",v.ItemId,"parameter1") * v.Count + expFeed;
        if expFeed >= needExp then
          hongdianData.Levelable = true;
          return;
        end
      end
    end
    hongdianData.Levelable = nil;
  end

  local function setGradeable()
    if not openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_15) then
      hongdianData.Gradeable = nil;
      return;
    end
    -- if isMainGeneral then
    --   hongdianData.StarLevelable = nil;
    --   return;
    -- end
    -- if true then hongdianData.StarLevelable = nil;return;end
    -- if 2 > tonumber(generalData.Level) then hongdianData.StarLevelable = nil;return; end
    -- if 30 > tonumber(generalData.Level) then hongdianData.StarLevelable = nil;return; end
    local table_data = analysis("Kapai_Kapaiku",generalData.ConfigId);
    local grade = generalData.Grade;
    if not analysisHas("Kapai_KapaiyanseduiyingID",1+grade) then
      hongdianData.Gradeable = nil;
      return;
    end
    local yanse_tb_data = analysis("Kapai_KapaiyanseduiyingID",1+grade);
    local items = StringUtils:stuff_string_split(yanse_tb_data.xuQiu);
    local isCountEnough = true;
    for k,v in pairs(items) do
      local count = tonumber(v[2]);
      local bagCount = bagProxy:getItemNum(tonumber(v[1]));
      isCountEnough = isCountEnough and count <= bagCount;
      if not isCountEnough then
        hongdianData.Gradeable = nil;
        return;
      end
    end
    local level_need = yanse_tb_data.level;
    if level_need > generalData.Level then
      hongdianData.Gradeable = nil;
      return;
    end
    local silver_need = yanse_tb_data.money;
    if silver_need <= userCurrencyProxy:getSilver() then
      hongdianData.Gradeable = true;
    else
      hongdianData.Gradeable = nil;
    end
  end

  local function setStarLevelable()
    if not openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_19) then
      hongdianData.StarLevelable = nil;
      return;
    end
    -- if isMainGeneral then
    --   hongdianData.StarLevelable = nil;
    --   return;
    -- end
    local table_data = analysis("Kapai_Kapaiku",generalData.ConfigId);
    local starExp = StringUtils:lua_string_split(table_data.soul,",")[1];
    starExp = bagProxy:getItemNum(starExp);
    local starLevel = generalData.StarLevel;
    if starLevel >= tonumber(table_data.star) then
      hongdianData.StarLevelable = nil;
      return;
    end

    local expNeed = StringUtils:stuff_string_split(table_data.starRequest);
    expNeed = tonumber(expNeed[1 + starLevel][2]);

    local commonNeed = 0;
    local commonGet = 0;
    if table_data.commonRequest and "" ~= table_data.commonRequest then
      commonNeed = StringUtils:stuff_string_split(table_data.commonRequest);
      commonNeed = tonumber(commonNeed[1 + starLevel][2]);
      commonGet = bagProxy:getItemNum(table_data.commonItem);
    end

    local silverNeed = StringUtils:stuff_string_split(table_data.starCost);
    silverNeed = tonumber(silverNeed[1 + starLevel][2]);

    if expNeed <= starExp and commonNeed <= commonGet and silverNeed <= userCurrencyProxy:getSilver() then
      hongdianData.StarLevelable = true;
    else
      hongdianData.StarLevelable = nil;
    end
  end

  local function setSkillable()
    -- if true then hongdianData.Skillable = nil; return; end
    if not openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_17) then
      hongdianData.Skillable = nil;
      return;
    end

    local data = {[1]=0,[2]=0,[3]=0,[4]=0};
    local tb_data = analysis("Kapai_Kapaiku",generalData.ConfigId);
    local skills = {"one","two","skill","skill2"};
    local colors = {"color1","color2","color3","color4"};
    local money_str = {"money1","money2","money3","money4"};
    for i=1,4 do
      local skill_data = nil;
      if tb_data[skills[i]] and 0 ~= tb_data[skills[i]] then
        skill_data = analysis("Jineng_Jineng",tb_data[skills[i]]);
      end
      if skill_data then
        local skillLevel = self:getSkillLevel(generalData.GeneralId, tb_data[skills[i]]);
        local levelIsMax = skillLevel >= userProxy:getLevel() or skillLevel >= generalData.Level;
        if tb_data[colors[i]] and generalData.Grade < tb_data[colors[i]] then

        elseif levelIsMax then

        else
          local silver = analysis("Jineng_Shengjixiaohao", 1+skillLevel, money_str[i]);  
          data[i] = userCurrencyProxy:getSilver() >= silver and 1 or 0;
        end
      end
    end
    for k,v in pairs(data) do
      if 1 == v then
        hongdianData.Skillable = data;
        return;
      end
    end
    hongdianData.Skillable = nil;
  end

  local function setBetterJinjieEquip()
    if not openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_64) then
      hongdianData.BetterJinjieEquip = nil;
      return;
    end
    local tb = {[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0};
    local xianglian_kaiqi_level = analysisWithCache("Xishuhuizong_Xishubiao",1081,"constant");
    local jiezhi_kaiqi_level = analysisWithCache("Xishuhuizong_Xishubiao",1082,"constant");
    for k,v in pairs(tb) do
      if 1 == hongdianData.Sign_BetterJinjieEquip[k] then

      else

        if 2 == k and generalData.Level < xianglian_kaiqi_level then

        elseif 6 == k and generalData.Level < jiezhi_kaiqi_level then

        else
          -- print("===",generalID,k);
          local equip_data = equipmentInfoProxy:getEquipInfoByHeroIDAndPlace(generalID,k);
          local job = analysisWithCache("Kapai_Kapaiku",generalData.ConfigId,"job");
          local jijie_data = analysis2keyWithCache("Zhuangbei_Zhuangbeijinjiebiao","job",job,"equipmentId",equip_data.ItemId);
          if not jijie_data then
          
          elseif 0 == jijie_data.target then

          else
            local silver_need = tonumber(StringUtils:lua_string_split(jijie_data.money,",")[2]);

            local level_is_enough = true;

            if 2 == k or 6 == k then
              level_is_enough= generalData.Level >= jijie_data.levelLimit;
            else
              level_is_enough= equip_data.StrengthenLevel >= jijie_data.levelLimit;
            end

            local silver_is_enough = userCurrencyProxy:getSilver()>=silver_need;

            local stuff_is_enough = true;
            local costs = jijie_data.cost;
            if costs and "" ~= costs then
              costs = StringUtils:stuff_string_split(costs);
              local costs_tmp = {};
              for k,v in pairs(costs) do
                if 0 ~= tonumber(v[2]) then
                  table.insert(costs_tmp,v);
                end
              end
              costs = costs_tmp;
              for k,v in pairs(costs) do
                local bagCount = bagProxy:getItemNum(tonumber(v[1]));
                stuff_is_enough = stuff_is_enough and bagCount >= tonumber(v[2]);
              end
            else
              stuff_is_enough = false;
            end

            if level_is_enough and silver_is_enough and stuff_is_enough then
              tb[k] = 1;
            end
          end
            
        end
      end
    end
    for k,v in pairs(tb) do
      if 1 == v then
        hongdianData.BetterJinjieEquip = tb;
        return;
      end
    end
    hongdianData.BetterJinjieEquip = nil;
  end

  local function setYuanfenable()
    local datas = self:getYuanfenData(generalID);
    local tbs = {};
    for key,value in pairs(datas) do
      local isJihuo = self:getIsYuanfenJihuo(generalID,value.id);
      if isJihuo then
        local yuanfen_level = self:getYuanfenLevel(generalID,value.id);
        local shengji_data = analysis2keyWithCache("Kapaiyuanfen_Yuanfenshengji","yfId",value.id,"level", yuanfen_level);
        local xiaoguo_data = analysis2keyWithCache("Kapaiyuanfen_Yuanfenshengji","yfId",value.id,"level", 1 + yuanfen_level);

        if xiaoguo_data then
          local req_level = xiaoguo_data.HeroLevel;
          if req_level and "" == req_level then
            req_level = {};
          else
            req_level = StringUtils:stuff_string_split(req_level);
          end
          local req_star = xiaoguo_data.HeroStar;
          if req_star and "" == req_star then
            req_star = {};
          else
            req_star = StringUtils:stuff_string_split(req_star);
          end
          
          local req_color = xiaoguo_data.HeroColor;
          if req_color and "" == req_color then
            req_color = {};
          else
            req_color = StringUtils:stuff_string_split(req_color);
          end

          local hero_ids = {};--StringUtils:lua_string_split(value.require,",");
          if req_level then
            for k,v in pairs(req_level) do
              if 0 ~= tonumber(v[1]) then
                table.insert(hero_ids,tonumber(v[1]));
              end
            end
          end
          if req_star then
            for k,v in pairs(req_star) do
              if 0 ~= tonumber(v[1]) then
                table.insert(hero_ids,tonumber(v[1]));
              end
            end
          end
          if req_color then
            for k,v in pairs(req_color) do
              if 0 ~= tonumber(v[1]) then
                table.insert(hero_ids,tonumber(v[1]));
              end
            end
          end

          local condit_enough = true;
          for k,v in pairs(hero_ids) do
            if not condit_enough then
              break;
            end

            if req_level and k <= table.getn(req_level) then
              for k_,v_ in pairs(req_level) do
                if tonumber(v) == tonumber(v_[1]) then
                  local bool = self:getGeneralDataByConfigID(tonumber(v_[1])).Level >= tonumber(v_[2]);
                  condit_enough = condit_enough and bool;
                  break;
                end
              end

            elseif req_star and k <= (table.getn(req_star) + table.getn(req_level)) then
              for k_,v_ in pairs(req_star) do
                if tonumber(v) == tonumber(v_[1]) then
                  local bool = self:getGeneralDataByConfigID(tonumber(v_[1])).StarLevel >= tonumber(v_[2]);
                  condit_enough = condit_enough and bool;
                  break;
                end
              end

            elseif req_color and k <= (table.getn(req_color) + table.getn(req_star) + table.getn(req_level)) then
              for k_,v_ in pairs(req_color) do
                if tonumber(v) == tonumber(v_[1]) then
                  local bool = self:getGeneralDataByConfigID(tonumber(v_[1])).Grade >= tonumber(v_[2]);
                  condit_enough = condit_enough and bool;
                  break;
                end
              end
            end
          end

          if condit_enough then
            local stuff_is_enough = true;
            local costs = xiaoguo_data.cost;
            if costs and "" ~= costs then
              costs = StringUtils:stuff_string_split(costs);
              local costs_tmp = {};
              for k,v in pairs(costs) do
                if 0 ~= tonumber(v[2]) then
                  table.insert(costs_tmp,v);
                end
              end
              costs = costs_tmp;
              for k,v in pairs(costs) do
                if not stuff_is_enough then
                  break;
                end
                local bagCount = bagProxy:getItemNum(tonumber(v[1]));
                stuff_is_enough = stuff_is_enough and bagCount >= tonumber(v[2]);
              end
            else
              stuff_is_enough = false;
            end

            if stuff_is_enough then
              local silver_is_enough = userCurrencyProxy:getSilver()>=xiaoguo_data.money;
              if silver_is_enough then
                table.insert(tbs,value.id);
              end
            end
          end
        end
      end

    end

    for k,v in pairs(tbs) do
      if v then
        hongdianData.Yuanfenable = tbs;
        return;
      end
    end
    hongdianData.Yuanfenable = nil;
  end

  if 1 == set_type then
    setBetterEquip();
  elseif 2 == set_type then
    setLevelable();
  elseif 3 == set_type then
    setGradeable();
  elseif 4 == set_type then
    setStarLevelable();
  elseif 5 == set_type then
    setSkillable();
  elseif 6 == set_type then
    setBetterJinjieEquip();
  elseif 7 == set_type then
    setYuanfenable();
  else
    setBetterEquip();
    setLevelable();
    setGradeable();
    setStarLevelable();
    setSkillable();
    setBetterJinjieEquip();
    setYuanfenable();
  end

  -- print("->",hongdianData.GeneralId);
  -- print(hongdianData.BetterEquip);
  -- print(hongdianData.Levelable);
  -- print(hongdianData.Gradeable);
  -- print(hongdianData.StarLevelable);
  -- print(hongdianData.Skillable);
  -- print(hongdianData.BetterJinjieEquip);
  -- print(hongdianData.Yuanfenable);
end

function HeroHouseProxy:getRedDotMain()
  for k,v in pairs(self.hongdianDatas) do
    if v.BetterEquip
    or v.Levelable
    or v.Gradeable
    or v.StarLevelable
    or v.Skillable
    or v.BetterJinjieEquip
    or v.Yuanfenable then
      return true;
    end
  end
  return false;
end

function HeroHouseProxy:getRedDotMain4Strengthen()
  for k,v in pairs(self.hongdianDatas) do
    if v.BetterEquip or v.BetterJinjieEquip then
      return true;
    end
  end
  return false;
end

function HeroHouseProxy:getHongdianDatas()
  return self.hongdianDatas;
end

rawset(HeroHouseProxy,"name","HeroHouseProxy");

function HeroHouseProxy:getExpByGeneralID(generalID)
  local data = self:getGeneralData(generalID);
  return data.Experience;
  -- return self.generalExp[generalID];
end

function HeroHouseProxy:getHunliByGeneralID(generalID)
  local data = self:getGeneralData(generalID);
  if not data then
    return 0;
  end
  local bagProxy = Facade:getInstance():retrieveProxy(BagProxy.name);
  local count = analysis("Kapai_Kapaiku",data.ConfigId,"soul");
  count = StringUtils:lua_string_split(count,",");
  count = tonumber(count[1]);
  return bagProxy:getItemNum(count);
  -- return data.GradeExp;
  -- return self.generalHunli[generalID];
end

function HeroHouseProxy:refreshGeneralExpAndHunli(generalID, exp, hunli)
  self.generalExp[generalID] = exp;
  self.generalHunli[generalID] = hunli;
end

function HeroHouseProxy:cleanGeneralExpAndHunli()
  self.generalExp = {};
  self.generalHunli = {};
end

function HeroHouseProxy:deleteDataByGeneralID(generalID)
  for k,v in pairs(self.generalArray) do
    if generalID == v.GeneralId then
      table.remove(self.generalArray, k);
      break;
    end
  end
end

--技能升级
function HeroHouseProxy:refreshDataBySkillLevelUp()
  if self.skillLevelUpGeneralIDCache then
    -- local data = self:getSkillArrayByGeneralId(self.skillLevelUpGeneralIDCache);
    -- for k,v in pairs(data) do
    --   if self.skillLevelUpSkillIDCache == v.ConfigId then
    --     v.Level = self.skillLevelUpIncreaseCache + v.Level;
    --     break;
    --   end
    -- end
    self.skillLevelUpGeneralIDCache = nil;
    self.skillLevelUpSkillIDCache = nil;
    self.skillLevelUpIncreaseCache = nil;
  end
end

--升级
function HeroHouseProxy:refreshDataByShengji()
  if self.shengjiGeneralIDCache then
    -- local data = self:getSkillArrayByGeneralId(self.shengjiGeneralIDCache);
    -- data.Level = self.shengjiLevelCache;
    -- self:refreshGeneralExp(self.shengjiGeneralIDCache, self.shengjiExpCache);
    -- for k,v in pairs(self.shengjiTargetArrayCache) do
    --   self:deleteDataByGeneralID(v);
    -- end
    local data = self:getGeneralData(self.shengjiGeneralIDCache).Experience;
    self.generalExp[self.shengjiGeneralIDCache] = data and data or self.shengjiExpCache;
    -- self.shengjiGeneralIDCache = nil;
    -- self.shengjiTargetArrayCache = nil;
    -- self.shengjiLevelCache = nil;
    -- self.shengjiExpCache = nil;
    -- self.shengjiTotalExpCache = nil;
  end
end

--升阶
function HeroHouseProxy:refreshDataByJinjie()
  if self.jinjieGeneralIDCache then
    -- local data = self:getGeneralData(self.jinjieGeneralIDCache);
    -- data.Grade = 1 + data.Grade;
    -- self:deleteDataByGeneralID(self.jinjieTargetIDCache);
    
    -- self.jinjieGeneralIDCache = nil;
    -- self.jinjieTargetIDCache = nil;

    -- self.jinjieGeneralIDCache = nil;
    -- self.jinjieTargetArrayCache = nil;
    -- self.jinjieLevelCache = nil;
    -- self.jinjieExpCache = nil;
    -- self.jinjieTotalExpCache = nil;
    local data = self:getGeneralData(self.jinjieGeneralIDCache).GradeExp;
    self.generalHunli[self.jinjieGeneralIDCache] = data;
  end
end

function HeroHouseProxy:refreshZhanli()
  self.num_count = 1 + self.num_count;
  if 0 ~= self.num_count%30 then
    return;
  end
  for k,v in pairs(self.generalArray) do
    if not v.Zhanli then
      self:getGeneralZhanliByGeneralID(v.GeneralId);
      return;
    end
  end
  removeSchedule(self,self.refreshZhanli);
end

function HeroHouseProxy:resertHeroBankData()
     
end

function HeroHouseProxy:getGeneralArray()
  return self.generalArray;
end
--不包括主角本身
function HeroHouseProxy:getStoryLinePlayGeneralArray()
 local returnValue = {};
 for k, v in pairs(self.generalArray)do
    if v.IsPlay == 1 then
      table.insert(returnValue, v);
    end
    print("v.IsPlay", v.IsPlay)
  end
  return returnValue;
end
function HeroHouseProxy:initialize()
  self.init = true;
  self.num_count = 0;
  removeSchedule(self,self.refreshZhanli);
  --addSchedule(self,self.refreshZhanli);
end

function HeroHouseProxy:getGeneralArrayWithPlayer()
  local generalData = self:getGeneralArrayByType(5);
  local data = {};--TimeCUtil:star();
  -- local function sortOnByZhanLi(a, b)
  --   return self:getGeneralZhanliByGeneralID(a.GeneralId) > self:getGeneralZhanliByGeneralID(b.GeneralId);
  -- end
  -- local function sortOnByStar1(a, b)
  --   local itemsData1 = analysisWithCache("Kapai_Kapaiku", a.ConfigId)--卡牌库
  --   local itemsData2 = analysisWithCache("Kapai_Kapaiku", b.ConfigId)--卡牌库
  --   if a.Level > b.Level then
  --     return true;
  --   elseif a.Level < b.Level then
  --     return false;
  --   elseif itemsData1.star > itemsData2.star then
  --     return true;
  --   elseif itemsData1.star < itemsData2.star then
  --     return false;
  --   end
  --   return a.ConfigId > b.ConfigId;
  -- end
  for k,v in pairs(generalData) do
    if 0 == v.IsMainGeneral then
      table.insert(data, v);
    end
  end
  --table.sort(data, sortOnByZhanLi);
  -- table.sort(data, sortOnByStar1);
  return data;
end

function HeroHouseProxy:getIsPlayArr()
  local num = #self.generalArray;
  local isplayArr = {};
    for i=1,num do
      if (self.generalArray[i].IsPlay == 1) and (self.generalArray[i].IsMainGeneral ~= 1) then
        table.insert(isplayArr, self.generalArray[i]);
      end;
    end
  return isplayArr;
end

function HeroHouseProxy:getIsPlayGeneralIDArr()
  local arr = {};
  local num = #self.generalArray;
    for i=1,num do
      if (self.generalArray[i].IsPlay == 1) and (self.generalArray[i].IsMainGeneral ~= 1) then
        table.insert(arr, self.generalArray[i].GeneralId);
      end;
    end
  return arr;
end

function HeroHouseProxy:getArenaDefGeneral(arenaProxy)
  local generalTable = arenaProxy.generalIdArray
  local tempTable = {}
  for key,VO in pairs(generalTable) do
      table.insert(tempTable,VO.GeneralId)
  end
  return tempTable
end

function HeroHouseProxy:getArenaAtkGeneral(arenaProxy)
  local generalTable = arenaProxy.generalIdArray2
  local tempTable = {}
  for key,VO in pairs(generalTable) do
      table.insert(tempTable,VO.GeneralId)
  end
  return tempTable
end

function HeroHouseProxy:getShadowGeneral(shadowProxy)
  local generalTable = shadowProxy.generalIdArray
  if not generalTable then
    -- print("+++++++++++++++++++++++++++++++++++++++----")
  end
  local tempTable = {}
  for key,VO in pairs(generalTable) do
      table.insert(tempTable,VO.GeneralId)
  end
  return tempTable
end
function HeroHouseProxy:getTenCountryRightGeneral(tenCountryProxy)
  local generalTable = tenCountryProxy.placeGeneralIdArray
  local tempTable = {}
  for key,VO in pairs(generalTable) do
      table.insert(tempTable,VO.GeneralId)
  end
  return tempTable
end

function HeroHouseProxy:getIsNotPlayArr()
  local num = #self.generalArray;
  local isplayArr = {};
  for i=1,num do
    if (self.generalArray[i].IsPlay ~= 1) and (self.generalArray[i].IsMainGeneral ~= 1) then
      table.insert(isplayArr, self.generalArray[i]);
    end;
  end
  local function sortOnByZhanLi(a, b)
    if a.IsPlay > b.IsPlay then
      return true;
    elseif a.IsPlay < b.IsPlay then
      return false;
    elseif a.IsMainGeneral > b.IsMainGeneral then
      return true;
    elseif a.IsMainGeneral < b.IsMainGeneral then
      return false;
    elseif self:getZongZhanli(a.GeneralId) > self:getZongZhanli(b.GeneralId) then
        return true;
    elseif self:getZongZhanli(a.GeneralId) < self:getZongZhanli(b.GeneralId) then
        return false;
    elseif a.Grade > b.Grade then
        return true;
    elseif a.Grade < b.Grade then
        return false;
    end
    return a.ConfigId > b.ConfigId;
  end
  table.sort(isplayArr, sortOnByZhanLi);
  return isplayArr;
end

function HeroHouseProxy:setFEBGeneralArr(arr,type)
  self["FEBGeneralArr"..type] = {};
  for k,v in pairs(arr) do
    table.insert(self["FEBGeneralArr"..type],v["GeneralId"]);
  end
end
function HeroHouseProxy:getFEBGeneralArr(type)
  return self["FEBGeneralArr"..type];
end

function HeroHouseProxy:setTreasuryGeneralArr(arr)
  self.treasuryGeneralArr = {};
  for k,v in pairs(arr) do
    table.insert(self.treasuryGeneralArr,v["GeneralId"]);
  end
end
function HeroHouseProxy:getTreasuryGeneralArr()
  return self.treasuryGeneralArr;
end
function HeroHouseProxy:isInTrsryGenrlArr(GeneralId)
	for k,v in pairs(self.treasuryGeneralArr) do
	 	if v == GeneralId then return true end;
	end
	return false;
end
function HeroHouseProxy:getIsTreasuryPlayArr()
  local num = #self.generalArray;
  local isplayArr = {};
    for i=1,num do
      if self:isInTrsryGenrlArr(self.generalArray[i].GeneralId) and (self.generalArray[i].IsMainGeneral ~= 1) then
        table.insert(isplayArr, self.generalArray[i]);
      end;
    end
    return isplayArr;
end

function HeroHouseProxy:getIsNotTreasuryPlayArr()
  local num = #self.generalArray;
  local isplayArr = {};
    for i=1,num do
      if not self:isInTrsryGenrlArr(self.generalArray[i].GeneralId) and (self.generalArray[i].IsMainGeneral ~= 1) then
        table.insert(isplayArr, self.generalArray[i]);
      end;
    end
    return isplayArr;
end
function HeroHouseProxy:getGeneralInPlayOverCount()
  return 3 == table.getn(self:getIsPlayArr());
end
function HeroHouseProxy:getTreasuryGeneralInPlayOverCount()
  return 3 == table.getn(self.treasuryGeneralArr);
end
function HeroHouseProxy:getGeneralArray4HeroHouse()
  local bagProxy = Facade.getInstance():retrieveProxy(BagProxy.name);
  local excel_data = analysisTotalTable("Kapai_Kapaiku");
  local excel_data_tmp = {};
  for k,v in pairs(excel_data) do
    if 1==v.jiQi then
      table.insert(excel_data_tmp,v);
    end
  end
  local function sfunc(data_a, data_b)
    if (data_a.Count >= data_a.MaxCount) and (data_b.Count < data_b.MaxCount) then
      return true;
    elseif (data_a.Count < data_a.MaxCount) and (data_b.Count >= data_b.MaxCount) then
      return false;
    -- elseif data_a.StarMax > data_b.StarMax then
    --   return true;
    -- elseif data_a.StarMax < data_b.StarMax then
    --   return false;
    end
    -- return data_a.ConfigId > data_b.ConfigId;
    return data_a.Sort < data_b.Sort;
  end
  excel_data = excel_data_tmp;
  local data = copyTable(self:getGeneralArrayByType(5));
  local tmp = {};
  for k,v in pairs(data) do
    tmp[v.ConfigId] = 1;
  end
  local tmp_excel_data = {};
  for k,v in pairs(excel_data) do
    if tmp[v.id] then

    elseif 1000>v.id then
      local hunshi = StringUtils:lua_string_split(v.soul,",");
      table.insert(tmp_excel_data, {GeneralId=0,ConfigId=v.id,Level=1,Grade=v.quality,ItemId = tonumber(hunshi[1]),Count = bagProxy:getItemNum(tonumber(hunshi[1])),MaxCount = tonumber(hunshi[2]),StarMax=v.star,Sort=v.sort});
    end
  end
  table.sort(tmp_excel_data,sfunc);
  for k,v in pairs(tmp_excel_data) do
    table.insert(data,v);
  end
  return data;
end
--type 1:按照时间降序  2:按照战力降序  3:按照星级降序  4:按照星级升序  
function HeroHouseProxy:getGeneralArrayByType(type)
  --按照时间降序
  --GeneralId,ConfigId,UsingEquipmentArray,SkillArray,Level,Grade,IsPlay,Time
  local function sortOnByTime(a, b)
    if a.IsPlay > b.IsPlay then
      return true;
    elseif a.IsPlay < b.IsPlay then
      return false;
    elseif a.IsMainGeneral > b.IsMainGeneral then
      return true;
    elseif a.IsMainGeneral < b.IsMainGeneral then
      return false;
    elseif a.Time > b.Time then
        return true;
    elseif a.Time < b.Time then
        return false;
    elseif a.Grade > b.Grade then
        return true;
    elseif a.Grade < b.Grade then
        return false;
    end
    return a.ConfigId > b.ConfigId;
  end

  --按照战力降序--临时
  --GeneralId,ConfigId,UsingEquipmentArray,SkillArray,Level,Grade,IsPlay,Time
  local function sortOnByZhanLi(a, b)
    if a.IsPlay > b.IsPlay then
      return true;
    elseif a.IsPlay < b.IsPlay then
      return false;
    elseif a.IsMainGeneral > b.IsMainGeneral then
      return true;
    elseif a.IsMainGeneral < b.IsMainGeneral then
      return false;
    elseif self:getGeneralZhanliByGeneralID(a.GeneralId) > self:getGeneralZhanliByGeneralID(b.GeneralId) then
        return true;
    elseif self:getGeneralZhanliByGeneralID(a.GeneralId) < self:getGeneralZhanliByGeneralID(b.GeneralId) then
        return false;
    elseif a.Grade > b.Grade then
        return true;
    elseif a.Grade < b.Grade then
        return false;
    end
    return a.ConfigId > b.ConfigId;
  end

  --按照星级降序
  --GeneralId,ConfigId,UsingEquipmentArray,SkillArray,Level,Grade,IsPlay,Time
  local function sortOnByStar1(a, b)
  local itemsData1 = analysis("Kapai_Kapaiku", a.ConfigId)--卡牌库
  local itemsData2 = analysis("Kapai_Kapaiku", b.ConfigId)--卡牌库
    -- if a.IsPlay > b.IsPlay then
    --   return true;
    -- elseif a.IsPlay < b.IsPlay then
    --   return false;
    -- else
    if a.IsMainGeneral > b.IsMainGeneral then
      return true;
    elseif a.IsMainGeneral < b.IsMainGeneral then
      return false;
    elseif itemsData1.star > itemsData2.star then
      return true;
    elseif itemsData1.star < itemsData2.star then
      return false;
    end
    -- elseif a.StarLevel > b.StarLevel then
    --     return true;
    -- elseif a.StarLevel < b.StarLevel then
    --     return false;
    -- elseif a.Grade > b.Grade then
    --     return true;
    -- elseif a.Grade < b.Grade then
    --     return false;
    -- end
    return a.ConfigId > b.ConfigId;
  end

  --按照星级升序
  --GeneralId,ConfigId,UsingEquipmentArray,SkillArray,Level,Grade,IsPlay,Time
  local function sortOnByStar2(a, b)
  local itemsData1 = analysis("Kapai_Kapaiku", a.ConfigId)--卡牌库
  local itemsData2 = analysis("Kapai_Kapaiku", b.ConfigId)--卡牌库
    if a.IsPlay > b.IsPlay then
      return true;
    elseif a.IsPlay < b.IsPlay then
      return false;
    elseif a.IsMainGeneral > b.IsMainGeneral then
      return true;
    elseif a.IsMainGeneral < b.IsMainGeneral then
      return false;
    elseif a.StarLevel < b.StarLevel then
        return true;
    elseif a.StarLevel > b.StarLevel then
        return false;
    elseif a.Grade > b.Grade then
        return true;
    elseif a.Grade < b.Grade then
        return false;
    end
    return a.ConfigId > b.ConfigId;
  end

  local function sortOnByNew(a, b)
    local itemsData1 = analysis("Kapai_Kapaiku", a.ConfigId)--卡牌库
    local itemsData2 = analysis("Kapai_Kapaiku", b.ConfigId)--卡牌库
    if a.IsMainGeneral > b.IsMainGeneral then
      return true;
    elseif a.IsMainGeneral < b.IsMainGeneral then
      return false;
    elseif a.Level > b.Level then
        return true;
    elseif a.Level < b.Level then
        return false;
    elseif a.Grade > b.Grade then
        return true;
    elseif a.Grade < b.Grade then
        return false;
    -- elseif itemsData1.sort < itemsData2.sort then
    --     return true;
    -- elseif itemsData1.sort > itemsData2.sort then
    --     return false;
    end
    return a.ConfigId > b.ConfigId;
  end

  local function getGeneralArrayWithHolder(generalArray)
    local data = copyTable(generalArray);
    if data[1] and 1 == data[1].IsPlay then
      table.insert(data, 1, {Holder = 1});
    end
    for k,v in pairs(data) do
      if 0 == v.IsPlay then
        table.insert(data, k, {Holder = 2});
        break;
      end
    end
    return data;
  end

  if type == 1 then
  	table.sort(self.generalArray, sortOnByTime);
  elseif type == 2 then
  	table.sort(self.generalArray, sortOnByZhanLi);
  elseif type == 3 then
  	table.sort(self.generalArray, sortOnByStar1);
  elseif type == 4 then
  	table.sort(self.generalArray, sortOnByStar2);
  elseif type == 5 then
    table.sort(self.generalArray, sortOnByNew);
  end;

  -- return getGeneralArrayWithHolder(self.generalArray);
  return self.generalArray;
end

function HeroHouseProxy:getAllHeroEquipped()
  local data = {};
  for k,v in pairs(self.generalArray) do
    for k_,v_ in pairs(v.UsingEquipmentArray) do
      if 0 ~= v_.UserEquipmentId then
        table.insert(data, v);
        break;
      end
    end
  end
  return data;
end

function HeroHouseProxy:getIsPlayByGeneralID(generalId)
  return 1 == self:getGeneralData(generalId).IsPlay;
end

function HeroHouseProxy:getGeneralData(generalId)
  for k,v in pairs(self.generalArray) do
    if generalId == v.GeneralId then
      return v;
    end
  end
  return nil;
end

function HeroHouseProxy:getGeneralDataByConfigID(configId)
  for k,v in pairs(self.generalArray) do
    if configId == v.ConfigId then
      return v;
    end
  end
  return nil;
end

function HeroHouseProxy:setSelectConfiId(configId)
  self.selectConfiId = configId;
end

function HeroHouseProxy:getSelectConfiId(configId)
  return self.selectConfiId;
end

function HeroHouseProxy:getConfigIDByGeneralId(generalId)
  for k,v in pairs(self.generalArray) do
    if generalId == v.GeneralId then
      return v.ConfigId;
    end
  end
  return nil;
end

function HeroHouseProxy:refreshGeneralIsPlay(generalIdArray)
  local data = {};
  for k,v in pairs(generalIdArray) do
    data[v.GeneralId] = 1;
  end
  for k,v in pairs(self.generalArray) do
    v.IsPlay = 1 == v.IsMainGeneral and 1 or (data[v.GeneralId] and 1 or 0);
  end
end

function HeroHouseProxy:getHasGeneralPlayByConfigId(generalId, configId)
  local bool_1 = false;
  local bool_2 = false;
  for k,v in pairs(self.generalArray) do
    if generalId == v.GeneralId and 1 == v.IsPlay then
      bool_1 = true;
    end
    if configId == v.ConfigId and 1 == v.IsPlay  then
      bool_2 = true;
    end
  end
  return bool_1 and bool_2;
end

function HeroHouseProxy:getUsingEquipmentArrayByGeneralId(generalId)
  return self:getGeneralData(generalId).UsingEquipmentArray;
end

function HeroHouseProxy:getHasEquipByGeneralId(generalId, itemId, bagProxy)
  local usingEquipmentArray = self:getUsingEquipmentArrayByGeneralId(generalId);
  for k,v in pairs(usingEquipmentArray) do
    local data = bagProxy:getItemData(v.UserEquipmentId);
    if data and itemId == data.ItemId then
      return true;
    end
  end
  return false;
end

function HeroHouseProxy:getSkillArrayByGeneralId(generalId)
  return self:getGeneralData(generalId).SkillArray;
end

function HeroHouseProxy:getSkillLevel(generalId, skillId, generalData)
  -- if isTalent then
  --   local data = self:getGeneralData(generalId);
  --   if data.TalentLevel then
  --     return data.TalentLevel;
  --   else
  --     return 1;
  --   end
  -- end
  -- if 10 > skillId then
  --   local data = self:getGeneralData(generalId);
  --   if data.WuxingLevel then
  --     return data.WuxingLevel;
  --   else
  --     return 1;
  --   end
  -- end
  if not generalData then
    generalData = self:getGeneralData(generalId);
  end

  local tb_data = analysisWithCache("Kapai_Kapaiku",generalData.ConfigId);
  local skills = {"one","two","skill","skill2"};
  local colors = {"color1","color2","color3","color4"};

  local skillArray = self:getSkillArrayByGeneralId(generalId);
  if skillArray then
    for k,v in pairs(skillArray) do
      if tonumber(skillId) == v.ConfigId then
        -- if tonumber(tb_data[colors[k]]) > generalData.Grade then
        --   return 0;
        -- end
        return v.Level;
      end
    end
  end
  
  -- for k,v in pairs(skills) do
  --   if tonumber(tb_data[v]) == skillId then
  --     if tonumber(tb_data[colors[k]]) > generalData.Grade then
  --       return 0;
  --     else
  --       return 1;
  --     end
  --     break;
  --   end
  -- end
  return 0;
end

function HeroHouseProxy:getIsMainGeneral(generalId)
  return 1 == self:getGeneralData(generalId).IsMainGeneral;
end

function HeroHouseProxy:getDatas4Jinjie(generalId)
  local configID = self:getGeneralData(generalId).ConfigId;
  local grade = self:getGeneralData(generalId).Grade;
  local datas = {};
  if self:getIsMainGeneral(generalId) then

  else
    for k,v in pairs(self.generalArray) do
      if generalId ~= v.GeneralId and configID == v.ConfigId and 0 == v.IsPlay then--and grade == v.Grade
        table.insert(datas, v);
      end
    end
  end
  datas = copyTable(datas);
  table.insert(datas, 1, {Holder = 2});
  return datas;
end

function HeroHouseProxy:getDatas4Shengji(generalId)
  local configID = self:getGeneralData(generalId).ConfigId;
  local datas = {};
  if self:getIsMainGeneral(generalId) then

  else
    for k,v in pairs(self.generalArray) do
      if generalId ~= v.GeneralId and 0 == v.IsMainGeneral and 0 == v.IsPlay then
        table.insert(datas, v);
      end
    end
  end
  datas = copyTable(datas);
  table.insert(datas, 1, {Holder = 2});
  return datas;
end

function HeroHouseProxy:getMainGeneral()
  for k,v in pairs(self.generalArray) do
    if 1 == v.IsMainGeneral then
      return v;
    end
  end
end

function HeroHouseProxy:getMaxGrade()
  return 11;
end

function HeroHouseProxy:getYuanfenData(generalId)
  local generalData = self:getGeneralData(generalId);
  return self:getYuanfenDataByConfigID(generalData.ConfigId);
end

function HeroHouseProxy:getYuanfenDataByConfigID(configID)
  local datas = analysisByNameWithCache("Kapaiyuanfen_Kapaiyuanfen", "cardid", configID);
  local function sortFunc(data_a, data_b)
    return data_a.id < data_b.id;
  end
  local _tb = {};
  for k,v in pairs(datas) do
    table.insert(_tb, v);
  end
  datas = _tb;
  table.sort(datas, sortFunc);
  return datas;
end

function HeroHouseProxy:getYuanfenLevel(generalId, yuanfenID)
  local generalData = self:getGeneralData(generalId);
  if generalData.FateLevelArray then
    for k,v in pairs(generalData.FateLevelArray) do
      if yuanfenID == v.ID then
        return v.Level;
      end
    end
  end
  return 1;
end

function HeroHouseProxy:getIsYuanfenJihuo(generalId, yuanfenID)
  local jihuo = true;
  local data = analysisWithCache("Kapaiyuanfen_Kapaiyuanfen",yuanfenID);
  -- local bagProxy = Facade.getInstance():retrieveProxy(BagProxy.name);
  local req;
  -- if ""~=data.require1 then
  --   req = StringUtils:stuff_string_split(data.require1);
  --   for k,v in pairs(req) do
  --     jihuo = jihuo and (self:getGeneralDataByConfigID(tonumber(v[1])) and tonumber(v[2]) <= self:getGeneralDataByConfigID(tonumber(v[1])).Level or false);
  --   end
  -- end
  -- if ""~=data.require2 then
  --   req = StringUtils:stuff_string_split(data.require2);
  --   for k,v in pairs(req) do
  --     jihuo = jihuo and (self:getGeneralDataByConfigID(tonumber(v[1])) and tonumber(v[2]) <= self:getGeneralDataByConfigID(tonumber(v[1])).Grade or false);
  --   end
  -- end
  -- if ""~=data.require3 then
  --   req = StringUtils:stuff_string_split(data.require3);
  --   for k,v in pairs(req) do
  --     jihuo = jihuo and (self:getGeneralDataByConfigID(tonumber(v[1])) and tonumber(v[2]) <= self:getGeneralDataByConfigID(tonumber(v[1])).StarLevel or false);
  --   end
  -- end
  if ""~=data.require then
    req = StringUtils:lua_string_split(data.require,",");
    for k,v in pairs(req) do
      jihuo = jihuo and self:getGeneralDataByConfigID(tonumber(v));
    end
  end
  return jihuo;
end

function HeroHouseProxy:getGeneralZhanliByGeneralID(generalID, data)
  if not data then
    data = self:getGeneralData(generalID);
  end
  if not data.Zhanli then
    self:setGeneralZhanliByGeneralID(generalID, data);
  end
  return data.Zhanli;
end

function HeroHouseProxy:setGeneralZhanliByGeneralID(generalID, data)
  if not data then
    data = self:getGeneralData(generalID);
  end
  data.Zhanli = self:getZongZhanli(generalID);
end

--英雄基础
function HeroHouseProxy:getPropValueHeroJiChuAttach(generalId, propID, generalData)
  -- if not generalData then
  --   generalData = self:getGeneralData(generalId);
  -- end
  -- if HeroPropConstConfig.GONG_JI == propID then
  --   return analysisWithCache("Kapai_Kapaiku",generalData.ConfigId,"attackWai");
  -- elseif HeroPropConstConfig.NEI_GONG_JI == propID then
  --   return analysisWithCache("Kapai_Kapaiku",generalData.ConfigId,"attackNei");
  -- elseif HeroPropConstConfig.FANG_YU == propID then
  --   return analysisWithCache("Kapai_Kapaiku",generalData.ConfigId,"ArmorWai");
  -- elseif HeroPropConstConfig.NEI_FANG_YU == propID then
  --   return analysisWithCache("Kapai_Kapaiku",generalData.ConfigId,"ArmorNei");
  -- elseif HeroPropConstConfig.SHENG_MING == propID then
  --   return analysisWithCache("Kapai_Kapaiku",generalData.ConfigId,"lif");
  -- end
  return 0;
end

--英雄等级
function HeroHouseProxy:getPropValueHeroLevelAttach(generalId, propID, generalData)
  if not generalData then
    generalData = self:getGeneralData(generalId);
  end
  local value = 0;
  local chengzhanglv = HeroPropConstConfig["XI_SHU_STAR_CHENG_ZHANG_LV_" .. generalData.StarLevel];
  if HeroPropConstConfig.GONG_JI == propID then
    value = analysisWithCache("Kapai_Kapaiku",generalData.ConfigId,"attackWai") + ( HeroPropConstConfig.XI_SHU_HERO_LEVEL_M1 + chengzhanglv ) * ( generalData.Level - 1) / 10;
  elseif HeroPropConstConfig.NEI_GONG_JI == propID then
    value = analysisWithCache("Kapai_Kapaiku",generalData.ConfigId,"attackNei") + ( HeroPropConstConfig.XI_SHU_HERO_LEVEL_M3 + chengzhanglv ) * ( generalData.Level - 1) / 10;
  elseif HeroPropConstConfig.FANG_YU == propID then
    value = analysisWithCache("Kapai_Kapaiku",generalData.ConfigId,"ArmorWai") + ( HeroPropConstConfig.XI_SHU_HERO_LEVEL_M2 + chengzhanglv ) * ( generalData.Level - 1) / 15;
  elseif HeroPropConstConfig.NEI_FANG_YU == propID then
    value = analysisWithCache("Kapai_Kapaiku",generalData.ConfigId,"ArmorNei") + ( HeroPropConstConfig.XI_SHU_HERO_LEVEL_M4 + chengzhanglv ) * ( generalData.Level - 1) / 10;
  elseif HeroPropConstConfig.SHENG_MING == propID then
    value = analysisWithCache("Kapai_Kapaiku",generalData.ConfigId,"lif") + ( HeroPropConstConfig.XI_SHU_HERO_LEVEL_M5 + chengzhanglv ) * ( generalData.Level - 1) * analysisWithCache("Kapai_Kapaiku",generalData.ConfigId,"hp") / 100;
  end
  return math.floor(value);
end

--英雄进阶
function HeroHouseProxy:getPropValueHeroGradeAttach(generalId, propID, generalData)
  if not generalData then
    generalData = self:getGeneralData(generalId);
  end
  local value = 0;
  local chengzhanglv = HeroPropConstConfig["XI_SHU_STAR_CHENG_ZHANG_LV_" .. generalData.StarLevel];
  if HeroPropConstConfig.GONG_JI == propID then
    value = HeroPropConstConfig.XI_SHU_HERO_GRADE_M1 * ( HeroPropConstConfig.XI_SHU_HERO_GRADE_N1 + chengzhanglv ) * ( -1 + generalData.Grade ) / 10;
  elseif HeroPropConstConfig.NEI_GONG_JI == propID then
    value = HeroPropConstConfig.XI_SHU_HERO_GRADE_M3 * ( HeroPropConstConfig.XI_SHU_HERO_GRADE_N3 + chengzhanglv ) * ( -1 + generalData.Grade ) / 10;
  elseif HeroPropConstConfig.FANG_YU == propID then
    value = HeroPropConstConfig.XI_SHU_HERO_GRADE_M2 * ( HeroPropConstConfig.XI_SHU_HERO_GRADE_N2 + chengzhanglv ) * ( -1 + generalData.Grade ) / 15;
  elseif HeroPropConstConfig.NEI_FANG_YU == propID then
    value = HeroPropConstConfig.XI_SHU_HERO_GRADE_M4 * ( HeroPropConstConfig.XI_SHU_HERO_GRADE_N4 + chengzhanglv ) * ( -1 + generalData.Grade ) / 10;
  elseif HeroPropConstConfig.SHENG_MING == propID then
    value = analysisWithCache("Kapai_Kapaiku",generalData.ConfigId,"hp") * ( HeroPropConstConfig.XI_SHU_HERO_GRADE_N5 + chengzhanglv ) * ( -1 + generalData.Grade ) / 100;
  end
  return math.floor(value);
end

--装备
function HeroHouseProxy:getPropValueEquipAttach(generalId, propID, generalData)
  local equipmentInfoProxy = Facade.getInstance():retrieveProxy(EquipmentInfoProxy.name);
  local bagProxy = Facade.getInstance():retrieveProxy(BagProxy.name);
  local data = equipmentInfoProxy:getEquipsByHeroID(generalId);
  local value = 0;
  for k,v in pairs(data) do
    value = equipmentInfoProxy:getEquipPropValue(generalId, v.ItemId, propID) + value;
  end
  return value;
end

--官职
function HeroHouseProxy:getPropValueGuanzhiAttach(generalId, propID, generalData)
  -- if not self:getIsMainGeneral(generalId) then return 0; end
  local nobility = Facade.getInstance():retrieveProxy(UserProxy.name):getNobility();
  local value = 0;
  for i=nobility,1,-1 do
  -- local i = nobility;
    local buff = analysisWithCache("Shili_Guanzhi",i,"buff");
    if buff and "" ~= buff then
      buff = StringUtils:stuff_string_split(buff);
      for k,v in pairs(buff) do
        if propID == tonumber(v[1]) then
          value = tonumber(v[2]) + value;
        end
      end
    end
  end
  return math.floor(value);
end

--缘分
function HeroHouseProxy:getPropValueYuanFenAttach(generalId, propID, generalData)
  local data = self:getYuanfenData(generalId);
  local value = 0;
  if data then
    for k,v in pairs(data) do
      local isJihuo = self:getIsYuanfenJihuo(generalId, v.id);
      if not isJihuo then
        
      else
        local buff = analysis2keyWithCache("Kapaiyuanfen_Yuanfenshengji","yfId",v.id,"level",self:getYuanfenLevel(generalId, v.id));
        buff = StringUtils:stuff_string_split(buff.effect);
        for k_,v_ in pairs(buff) do
          if propID == tonumber(v_[1]) then
            value = tonumber(v_[2]) + value;
          end
        end
      end
    end
  end
  return math.floor(value);
end

--通关星
function HeroHouseProxy:getPropValueTongguanxingAttach(generalId, propID, generalData)
  if not generalData then
    generalData = self:getGeneralData(generalId);
  end
  local userProxy = Facade.getInstance():retrieveProxy(UserProxy.name);
  local tb_data = analysisTotalTable("Zhujiao_Tianxiangshouhudian");
  local i = 10001;
  local value = 0;
  if userProxy.zodiacId then
    while i <= userProxy.zodiacId do
      local data = tb_data["key" .. i];
      if propID == data.attributeid then
        value = value + data.attributeUp;
      end
      i = data.id2;
      if not i or 0 == i then
       break;
      end
    end
  end
  return math.floor(value);
end

-- （角色攻击+该角色装备攻击+BUFF攻击+被动技能攻击+该角色缘分攻击+成就攻击）
--*（1+BUFF攻击百分比+被动技能百分比攻击+该角色缘分攻击百分比+成就攻击百分比
function HeroHouseProxy:getZongPropValue(generalId, propID)
  local generalData = self:getGeneralData(generalId);
  local _value = 0;
  _value = self:getPropValueHeroJiChuAttach(generalId, propID, generalData) + _value;
  _value = self:getPropValueHeroLevelAttach(generalId, propID, generalData) + _value;
  _value = self:getPropValueHeroGradeAttach(generalId, propID, generalData) + _value;
  _value = self:getPropValueEquipAttach(generalId, propID, generalData) + _value;
  _value = self:getPropValueGuanzhiAttach(generalId, propID, generalData) + _value;
  _value = self:getPropValueYuanFenAttach(generalId, propID, generalData) + _value;
  _value = self:getPropValueTongguanxingAttach(generalId, propID, generalData) + _value;

  return _value;
end

function HeroHouseProxy:getZongPropValueWithPer(generalId, propID)
  local value = self:getZongPropValue(generalId, propID);
  local value_per = self:getZongPropValue(generalId, HeroPropConstConfig:getKEY_PER(propID));
   --print("--------------------------------------------------------");
   --print(propID,HeroPropConstConfig:getKEY_PER(propID),value,value_per);
  return (1 + value_per / 100000) * value;
end

function HeroHouseProxy:getZhanliByValue(generalId, propID, value, isPer)
  local tb_data = analysisWithCache("Shuxing_Shuju",propID);
  local zhanli = 0;
  if nil == tb_data.attribute or nil == tb_data.diShu then
    return zhanli;
  end
  if tb_data then
    if isPer then
      zhanli = value/1000*tb_data.attribute/100000*math.pow(tb_data.diShu/100000,-1+self:getGeneralData(generalId).Level);
    else
      zhanli = value*tb_data.attribute/100000;
    end
  end

  return math.ceil(zhanli);
end

function HeroHouseProxy:getZhanliSkillAttach(generalId, generalData)
  local userProxy = Facade.getInstance():retrieveProxy(UserProxy.name);
  if not generalData then
    generalData = self:getGeneralData(generalId);
  end
  local skills = {};
  local value = 0;
  local tb_data = analysisWithCache("Kapai_Kapaiku", generalData.ConfigId);
  skills[1] = tb_data.one;
  skills[2] = tb_data.two;
  skills[3] = tb_data.skill;
  skills[4] = tb_data.skill2;

  value = (self:getSkillLevel(generalId, skills[1], generalData) + self:getSkillLevel(generalId, skills[2], generalData)) * HeroPropConstConfig.XI_SHU_ZHAN_LI_ZHU_DONG
        + (self:getSkillLevel(generalId, skills[3], generalData) + self:getSkillLevel(generalId, skills[4], generalData)) * HeroPropConstConfig.XI_SHU_ZHAN_LI_BEI_DONG;
  
  return math.floor(value);




  -- if 1 == generalData.IsMainGeneral then
  --   local tb_data = analysisWithCache("Zhujiao_Zhujiaozhiye", userProxy:getCareer());
  --   skills[1] = tb_data.zDjiNeng;
  --   skills[2] = tb_data.bDjiNeng;
  -- else
    
  -- end
  -- if 0 ~= skills[1] then
  --   value = self:getSkillLevel(generalId, skills[1], generalData) + value;
  -- end
  -- if 0 ~= skills[2] then
  --   value = self:getSkillLevel(generalId, skills[2], generalData) + value;
  -- end
  -- return 5 * value;
end

--值战力：value*权值/100000
--百分比战力：value/1000*价值/100000*(底数/100000)^(lv-1)
function HeroHouseProxy:getZongZhanli(generalId)
  -- if true then return 0; end
  --TimeCUtil:star();
  local generalData = self:getGeneralData(generalId);
  -- local zhanli_type = {self.getPropValueHeroJiChuAttach,
  --                      self.getPropValueHeroLevelAttach, 
  --                      self.getPropValueHeroGradeAttach, 
  --                      self.getPropValueEquipAttach,
  --                      self.getPropValueGuanzhiAttach, 
  --                      self.getPropValueYuanFenAttach,
  --                      self.getPropValueTongguanxingAttach};
  local funcs = {self.getPropValueHeroJiChuAttach,
                 self.getPropValueHeroLevelAttach,
                 self.getPropValueHeroGradeAttach,
                 self.getPropValueEquipAttach,
                 self.getPropValueGuanzhiAttach,
                 self.getPropValueYuanFenAttach,
                 self.getPropValueTongguanxingAttach};

  local func_strs = {"基础==============================",
                     "等级==============================",
                     "品质==============================",
                     "装备==============================",
                     "官职==============================",
                     "缘分==============================",
                     "通关星============================"};

  local zhanli_prop = {HeroPropConstConfig.GONG_JI,
                       HeroPropConstConfig.NEI_GONG_JI,
                       HeroPropConstConfig.FANG_YU,
                       HeroPropConstConfig.NEI_FANG_YU,
                       HeroPropConstConfig.SHENG_MING,
                       HeroPropConstConfig.HUI_XIN,
                       HeroPropConstConfig.SHAN_BI,
                       HeroPropConstConfig.ZHAO_JIA,
                       HeroPropConstConfig.YU_JIN,
                       HeroPropConstConfig.LIAO_SHANG
                       };

  local zhanli_xishu = {HeroPropConstConfig.XI_SHU_ZHAN_LI_GONG_JI,
                        HeroPropConstConfig.XI_SHU_ZHAN_LI_NEI_GONG_JI,
                        HeroPropConstConfig.XI_SHU_ZHAN_LI_FANG_YU,
                        HeroPropConstConfig.XI_SHU_ZHAN_LI_NEI_FANG_YU,
                        HeroPropConstConfig.XI_SHU_ZHAN_LI_SHENG_MING,
                        HeroPropConstConfig.XI_SHU_ZHAN_LI_HUI_XIN,
                        HeroPropConstConfig.XI_SHU_ZHAN_LI_SHAN_BI,
                        HeroPropConstConfig.XI_SHU_ZHAN_LI_ZHAO_JIA,
                        HeroPropConstConfig.XI_SHU_ZHAN_LI_YU_JIN,
                        HeroPropConstConfig.XI_SHU_ZHAN_LI_LIAO_SHANG};
  -- local logs = {"英雄基础战力:","英雄等级战力:","英雄进阶战力:","装备战力:","官职战力:","缘分战力:","通关星战力:"};
  local logs = {"攻击 " .. HeroPropConstConfig.GONG_JI .. ":",
                "内攻击 " .. HeroPropConstConfig.NEI_GONG_JI .. ":",
                "防御 " .. HeroPropConstConfig.FANG_YU .. ":",
                "内防御 " .. HeroPropConstConfig.NEI_FANG_YU .. ":",
                "生命 " .. HeroPropConstConfig.SHENG_MING .. ":",
                "会心 " .. HeroPropConstConfig.HUI_XIN .. ":",
                "闪避 " .. HeroPropConstConfig.SHAN_BI .. ":",
                "招架 " .. HeroPropConstConfig.ZHAO_JIA .. ":",
                "御劲 " .. HeroPropConstConfig.YU_JIN .. ":",
                "疗伤 " .. HeroPropConstConfig.LIAO_SHANG .. ":"};
  local _zongzhanli = 0;
  local zhanli_log = false;

  for key,value in pairs(funcs) do
    if zhanli_log then log(func_strs[key]); end

    local zhanli = 0;
    for k,v in pairs(zhanli_prop) do
      if 1 == analysisWithCache("Shuxing_Shuju",v,"zhanLi") then
        if zhanli_log then log(logs[k]); end

        local value_jichu = value(self,generalId,v,generalData);
        local value_jichu_per = value(self,generalId,HeroPropConstConfig:getKEY_PER(v),generalData);
        local value_jichu_total = ( 1 + value_jichu_per / 100000 ) * value_jichu;
        if zhanli_log then log("数值:" .. value_jichu .. " 数值%:" .. value_jichu_per .. " 总:" .. value_jichu_total); end

        local zhanli_jichu = math.floor(zhanli_xishu[k] * value_jichu_total);
        if zhanli_log then log("战力:" .. zhanli_jichu); end
        zhanli = zhanli + zhanli_jichu;
      end
    end
    if zhanli_log then log("总战力:" .. zhanli); end
    _zongzhanli = _zongzhanli + zhanli;
  end

  local skillZhanli = self:getZhanliSkillAttach(generalId, generalData);
  if zhanli_log then log("技能战力=========" .. skillZhanli); end
  _zongzhanli = _zongzhanli + skillZhanli;

  return _zongzhanli;


  -- for k,v in pairs(zhanli_prop) do
  --   if zhanli_log then log(logs[k]); end

  --   local zhanli = 0;
  --   local value_jichu = self:getPropValueHeroJiChuAttach(generalId, v, generalData);
  --   if zhanli_log then log("基础:" .. value_jichu); end
  --   local value_jichu_per = self:getPropValueHeroJiChuAttach(generalId, HeroPropConstConfig:getKEY_PER(v), generalData);
  --   if zhanli_log then log("基础%:" .. value_jichu_per); end
  --   local value_jichu_total = ( 1 + value_jichu_per / 100000 ) * value_jichu;
  --   local zhanli_jichu = math.floor(zhanli_xishu[k] * value_jichu_total);
  --   if zhanli_log then log("基础战力%:" .. zhanli_jichu); end
  --   zhanli = zhanli + zhanli_jichu;

  --   local value_level = self:getPropValueHeroLevelAttach(generalId, v, generalData);
  --   if zhanli_log then log("等级:" .. value_level); end
  --   local value_level_per = self:getPropValueHeroLevelAttach(generalId, HeroPropConstConfig:getKEY_PER(v), generalData);
  --   if zhanli_log then log("等级%:" .. value_level_per); end
  --   local value_level_total = ( 1 + value_level_per / 100000 ) * value_level;
  --   local zhanli_level = math.floor(zhanli_xishu[k] * value_level_total);
  --   if zhanli_log then log("等级战力%:" .. zhanli_level); end
  --   zhanli = zhanli + zhanli_level;

  --   local value_grade = self:getPropValueHeroGradeAttach(generalId, v, generalData);
  --   if zhanli_log then log("品质:" .. value_grade); end
  --   local value_grade_per = self:getPropValueHeroGradeAttach(generalId, HeroPropConstConfig:getKEY_PER(v), generalData);
  --   if zhanli_log then log("品质%:" .. value_grade_per); end
  --   local value_grade_total = ( 1 + value_grade_per / 100000 ) * value_grade;
  --   local zhanli_grade = math.floor(zhanli_xishu[k] * value_grade_total);
  --   if zhanli_log then log("品质战力%:" .. zhanli_grade); end
  --   zhanli = zhanli + zhanli_grade;

  --   local value_equip = self:getPropValueEquipAttach(generalId, v);
  --   if zhanli_log then log("装备:" .. value_equip); end
  --   local value_equip_per = self:getPropValueEquipAttach(generalId, HeroPropConstConfig:getKEY_PER(v), generalData);
  --   if zhanli_log then log("装备:" .. value_equip_per); end
  --   local value_equip_total = ( 1 + value_equip_per / 100000 ) * value_equip;
  --   local zhanli_equip = math.floor(zhanli_xishu[k] * value_equip_total);
  --   if zhanli_log then log("装备战力%:" .. zhanli_equip); end
  --   zhanli = zhanli + zhanli_equip;

  --   local value_guanzhi = self:getPropValueGuanzhiAttach(generalId, v);
  --   if zhanli_log then log("官职:" .. value_guanzhi); end
  --   local value_guanzhi_per = self:getPropValueGuanzhiAttach(generalId, HeroPropConstConfig:getKEY_PER(v), generalData);
  --   if zhanli_log then log("官职%:" .. value_guanzhi_per); end
  --   local value_guanzhi_total = ( 1 + value_guanzhi_per / 100000 ) * value_guanzhi;
  --   local zhanli_guanzhi = math.floor(zhanli_xishu[k] * value_guanzhi_total);
  --   if zhanli_log then log("官职战力%:" .. zhanli_guanzhi); end
  --   zhanli = zhanli + zhanli_guanzhi;

  --   local value_yuanfen = self:getPropValueYuanFenAttach(generalId, v);
  --   if zhanli_log then log("缘分:" .. value_yuanfen); end
  --   local value_yuanfen_per = self:getPropValueYuanFenAttach(generalId, HeroPropConstConfig:getKEY_PER(v), generalData);
  --   if zhanli_log then log("缘分%:" .. value_yuanfen_per); end
  --   local value_yuanfen_total = ( 1 + value_yuanfen_per / 100000 ) * value_yuanfen;
  --   local zhanli_yuanfen = math.floor(zhanli_xishu[k] * value_yuanfen_total);
  --   if zhanli_log then log("缘分战力%:" .. zhanli_yuanfen); end
  --   zhanli = zhanli + zhanli_yuanfen;

  --   local value_tongguanxing = self:getPropValueTongguanxingAttach(generalId, v, generalData);
  --   if zhanli_log then log("通关星:" .. value_tongguanxing); end
  --   local value_tongguanxing_per = self:getPropValueTongguanxingAttach(generalId, HeroPropConstConfig:getKEY_PER(v), generalData);
  --   if zhanli_log then log("通关星%:" .. value_tongguanxing_per); end
  --   local value_tongguanxing_total = ( 1 + value_tongguanxing_per / 100000 ) * value_tongguanxing;
  --   local zhanli_tongguanxing = math.floor(zhanli_xishu[k] * value_tongguanxing_total);
  --   if zhanli_log then log("通关星战力%:" .. zhanli_tongguanxing); end
  --   zhanli = zhanli + zhanli_tongguanxing;

  --   _zongzhanli = _zongzhanli + zhanli;
  -- end

  -- local skillZhanli = self:getZhanliSkillAttach(generalId, generalData);
  -- if zhanli_log then log("技能战力=========" .. skillZhanli); end
  -- _zongzhanli = _zongzhanli + skillZhanli;

  -- return _zongzhanli;
end

function HeroHouseProxy:getChengzhangzhi(star_level, propID)
  local value = 0;
  if HeroPropConstConfig.GONG_JI == propID then
    value = 10.2 + star_level * 1.5;
  elseif HeroPropConstConfig.NEI_GONG_JI == propID then
    value = 8.7 + star_level * 1.4;
  elseif HeroPropConstConfig.FANG_YU == propID then
    value = 6.5 + star_level * 1.2;
  elseif HeroPropConstConfig.NEI_FANG_YU == propID then
    value = 7.9 + star_level * 1.3;
  elseif HeroPropConstConfig.SHENG_MING == propID then
    value = 15 + star_level * 3.3;
  end
  return value;
end






--   local _zong_sheng_ming = self:getZongPropValue(generalId, HeroPropConstConfig.SHENG_MING);--log("总生命: " .. _zong_sheng_ming);
--   local _zong_gong_ji = self:getZongPropValue(generalId, HeroPropConstConfig.GONG_JI);--log("总攻击: " .. _zong_gong_ji);
--   local _zong_fang_yu = self:getZongPropValue(generalId, HeroPropConstConfig.FANG_YU);--log("总防御: " .. _zong_fang_yu);
--   local _pre_zhanli = 0;
--   for k,v in pairs(zhanli_type) do
--     local _value = 0;
--     _pre_zhanli = _zongzhanli;

--     _value = v(self,generalId,HeroPropConstConfig.SHENG_MING);
--     -- log(HeroPropConstConfig.SHENG_MING .. "生命: " .. _value);
--     _zongzhanli = self:getZhanliByValue(generalId, HeroPropConstConfig.SHENG_MING, _value) + _zongzhanli;

--     _value = v(self,generalId,HeroPropConstConfig.GONG_JI);
--     -- log(HeroPropConstConfig.GONG_JI .. "攻击: " .. _value);
--     _zongzhanli = self:getZhanliByValue(generalId, HeroPropConstConfig.GONG_JI, _value) + _zongzhanli;

--     _value = v(self,generalId,HeroPropConstConfig.FANG_YU);
--     -- log(HeroPropConstConfig.FANG_YU .. "防御: " .. _value);
--     _zongzhanli = self:getZhanliByValue(generalId, HeroPropConstConfig.FANG_YU, _value) + _zongzhanli;

--     --print("&1->",v(self,generalId,HeroPropConstConfig.SHENG_MING),v(self,generalId,HeroPropConstConfig.GONG_JI),v(self,generalId,HeroPropConstConfig.FANG_YU),_zongzhanli);
    
--     _value = math.ceil(_zong_sheng_ming * (v(self,generalId,HeroPropConstConfig.SHENG_MING_PER) / 100000));
--     -- log(HeroPropConstConfig.SHENG_MING_PER .. "生命%: " .. _value);
--     _zongzhanli = self:getZhanliByValue(generalId, HeroPropConstConfig.SHENG_MING, _value) + _zongzhanli;
    
--     _value = math.ceil(_zong_gong_ji * (v(self,generalId,HeroPropConstConfig.GONG_JI_PER) / 100000));
--     -- log(HeroPropConstConfig.GONG_JI_PER .. "攻击%: " .. _value);
--     _zongzhanli = self:getZhanliByValue(generalId, HeroPropConstConfig.GONG_JI, _value) + _zongzhanli;
    
--     _value = math.ceil(_zong_fang_yu * (v(self,generalId,HeroPropConstConfig.FANG_YU_PER) / 100000));
--     -- log(HeroPropConstConfig.FANG_YU_PER .. "防御%: " .. _value);
--     _zongzhanli = self:getZhanliByValue(generalId, HeroPropConstConfig.FANG_YU, _value) + _zongzhanli;
    
--     -- print("&2->",v(self,generalId,HeroPropConstConfig.SHENG_MING_PER),v(self,generalId,HeroPropConstConfig.GONG_JI_PER),v(self,generalId,HeroPropConstConfig.FANG_YU_PER),_zongzhanli);
    
--     _value = v(self,generalId,HeroPropConstConfig.HUI_XIN_JI_LV_PER);
--     -- log(HeroPropConstConfig.HUI_XIN_JI_LV_PER .. "会心几率%: " .. _value);
--     _zongzhanli = self:getZhanliByValue(generalId, HeroPropConstConfig.HUI_XIN_JI_LV_PER, _value, true) + _zongzhanli;

--     _value = v(self,generalId,HeroPropConstConfig.HUI_XIN);
--     -- log(HeroPropConstConfig.HUI_XIN .. "会心: " .. _value);
--     _zongzhanli = self:getZhanliByValue(generalId, HeroPropConstConfig.HUI_XIN, _value) + _zongzhanli;

--     _value = v(self,generalId,HeroPropConstConfig.HUI_XIN_PER);
--     -- log(HeroPropConstConfig.HUI_XIN_PER .. "会心%: " .. _value);
--     _zongzhanli = self:getZhanliByValue(generalId, HeroPropConstConfig.HUI_XIN_PER, _value, true) + _zongzhanli;

--     _value = v(self,generalId,HeroPropConstConfig.HUI_XIN_DI_KANG);
--     -- log(HeroPropConstConfig.HUI_XIN_DI_KANG .. "会心抵抗: " .. _value);
--     _zongzhanli = self:getZhanliByValue(generalId, HeroPropConstConfig.HUI_XIN_DI_KANG, _value) + _zongzhanli;

--     _value = v(self,generalId,HeroPropConstConfig.JIAN_SHANG_PER);
--     -- log(HeroPropConstConfig.JIAN_SHANG_PER .. "减伤%: " .. _value);
--     _zongzhanli = self:getZhanliByValue(generalId, HeroPropConstConfig.JIAN_SHANG_PER, _value, true) + _zongzhanli;

--     -- print("&3->",v(self,generalId,HeroPropConstConfig.HUI_XIN_JI_LV_PER),v(self,generalId,HeroPropConstConfig.HUI_XIN),v(self,generalId,HeroPropConstConfig.HUI_XIN_PER),v(self,generalId,HeroPropConstConfig.HUI_XIN_DI_KANG),v(self,generalId,HeroPropConstConfig.JIAN_SHANG_PER),_zongzhanli);
    
--     -- log("===========================" .. logs[k] .. (_zongzhanli - _pre_zhanli));
--   end

--   local _skillZhanli = self:getZhanliSkillAttach(generalId);
--   -- log("===========================技能战力: " .. _skillZhanli);
--   _zongzhanli = _skillZhanli + _zongzhanli;

--   local data = self:getGeneralData(generalId);
--   -- log("===========================总战力: " .. generalId .. " " .. data.ConfigId .. " " .. _zongzhanli);
-- --TimeCUtil:getTime("getZongZhanli->")
--   return _zongzhanli;
-- end

-- 2.2.1.1数值类属性价值
-- 属性数值*（属性价值/100000）
-- 适用属性：
-- 1)生命值，7
-- 2)攻击，8
-- 3)会心攻击等级，14
-- 4)防御，20
-- 5)会心抵抗等级，27
-- 2.2.1.2影响数值类属性的百分比数值价值
-- roundup[（属性数值总值*（百分比数值/100000））]*（属性价值/100000）
-- 适用属性：
-- 1)攻击增加百分比，9
-- 2)防御百分比，21
-- 3)生命值百分比，35
-- 2.2.1.3独立百分比数据价值
-- （属性数值/1000）*（属性价值/100000）*底数^(角色等级-1)
-- 适用属性：
-- 1)会心攻击几率，13
-- 2)会心伤害加成，15
-- 3)承受伤害减少，29
-- 2.2.2技能战斗力计算
-- 角色或者卡牌的技能，每升级1级，则增加该角色或者卡牌5点战斗力
-- 2.2.3缘分战斗力
-- 缘分战斗力，只有在对应的缘分处于激活状态的时候，才可以进入战斗力计算，没有激活的缘分是不算战斗力的