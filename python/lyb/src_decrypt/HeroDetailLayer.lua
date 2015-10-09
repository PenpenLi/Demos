HeroDetailLayer=class(Layer);

function HeroDetailLayer:ctor()
  self.class=HeroDetailLayer;
end

function HeroDetailLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  self.armature:dispose();
  HeroDetailLayer.superclass.dispose(self);
end

function HeroDetailLayer:onLayerCallBack(event)
	self.parent:removeChild(self);
end

function HeroDetailLayer:initialize()
  self:initLayer();
  local layer = LayerColorBackGround:getOpacityBackGround();
  layer:addEventListener(DisplayEvents.kTouchBegin, self.onLayerCallBack, self);
  self:addChild(layer);
end

function HeroDetailLayer:initializeZhuanDetail(context, configID)
  self.context = context;
  self:initialize();
  local armature=self.context.skeleton:buildArmature("zhuan_detail_layer");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature=armature;
  self.armature.display:addEventListener(DisplayEvents.kTouchBegin, self.onLayerCallBack, self);
  self.armature.display:setPositionXY(160,100);
  self:addChild(self.armature.display);

  local text = analysis("Kapai_Kapaiku",configID,"name");
  local descb_1= createTextFieldWithTextData(armature:getBone("descb_1").textData,text);
  self.armature.display:addChild(descb_1);

  text = "........................................................";
  local descb_2= createTextFieldWithTextData(armature:getBone("descb_2").textData,text);
  self.armature.display:addChild(descb_2);

  text = analysis("Kapai_Kapaiku",configID,"bewrite");
  local descb_3= createTextFieldWithTextData(armature:getBone("descb_3").textData,text);
  self.armature.display:addChild(descb_3);
end

function HeroDetailLayer:initializeWuxingDetail(context, configID)
  self.context = context;
  self:initialize();
  local armature=self.context.skeleton:buildArmature("wuxing_detail_layer");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature=armature;
  self.armature.display:addEventListener(DisplayEvents.kTouchBegin, self.onLayerCallBack, self);
  self.armature.display:setPositionXY(135,430);
  self:addChild(self.armature.display);
  print("========++++++++++++->>>>>>",configID);
  local text = "<content><font color='#FFFF00'>职业说明   </font><font color='#FFFFFF'>" .. analysis("Shuxing_Zhiyeshuoming",configID,"occupation") .. "</font></content>";
  local descb_1= createRichMultiColoredLabelWithTextData(armature:getBone("descb_1").textData,text);
  self.armature.display:addChild(descb_1);

  -- local kezhiID = analysis("Shuxing_Wuxing",configID,"keZhi");
  -- local str = StringUtils:lua_string_split(kezhiID,",");
  -- local kezhiStr = "";
  -- for k,v in pairs(str) do
  --   if "" ~= v then
  --     kezhiStr = kezhiStr .. analysis("Shuxing_Wuxing",v,"wuXing");
  --     if str[1+k] then
  --       kezhiStr = kezhiStr .. ",";
  --     end
  --   end
  -- end

  -- local beikezhiStr = "";
  -- local sign = false;
  -- for i=1,6 do
  --   local kezhiStr = analysis("Shuxing_Wuxing",i,"keZhi");
  --   kezhiStr = StringUtils:lua_string_split(kezhiStr,",");
  --   for k,v in pairs(kezhiStr) do
  --     if configID == tonumber(v) then
  --       if sign then
  --         beikezhiStr = beikezhiStr .. ",";
  --       end
  --       beikezhiStr = beikezhiStr .. analysis("Shuxing_Wuxing",i,"wuXing");
  --       sign = true;
  --       break;
  --     end
  --   end
  -- end

  -- text = "克制   " .. kezhiStr .. "\n" .. analysis("Shuxing_Wuxing",configID,"info1") .. 
  --        "\n被克制   " .. beikezhiStr .. "\n" .. analysis("Shuxing_Wuxing",configID,"info2");
  text = analysis("Shuxing_Zhiyeshuoming",configID,"info");
  local descb_2= createTextFieldWithTextData(armature:getBone("descb_2").textData,text);
  self.armature.display:addChild(descb_2);
end

function HeroDetailLayer:initializeJinengDetail(context, type, skillConfigId, skillLevel, generalId)
  self.context = context;
  self.type = type;
  self:initialize();
  local armature=self.context.skeleton:buildArmature("jineng_detail_layer");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature=armature;
  self.armature.display:addEventListener(DisplayEvents.kTouchBegin, self.onLayerCallBack, self);
  if 1 == self.type then
    self.armature.display:setPositionXY(380,350);
  elseif 2 == self.type then
    self.armature.display:setPositionXY(380,200);
  elseif 3 == self.type then
    self.armature.display:setPositionXY(380,50);
  end
  self:addChild(self.armature.display);

  local text = "";
  if 1 == self.type then
    text = analysis("Jineng_Jineng", skillConfigId, "name");
  elseif 2 == self.type then
    text = analysis2key("Kapai_Tianfu", "tianFuId", skillConfigId, "level", 1).name;
  else
    text = analysis("Jineng_Wuxingjineng", skillConfigId, "name");
  end
  local descb_1= createTextFieldWithTextData(armature:getBone("descb_1").textData,text);
  self.armature.display:addChild(descb_1);

  text = "........................................................";
  local descb_2= createTextFieldWithTextData(armature:getBone("descb_2").textData,text);
  self.armature.display:addChild(descb_2);

  if 3 == self.type then
    text = analysis("Jineng_Wuxingjineng",skillConfigId,"Show");
    text = string.gsub(text,"@1",analysis("Jineng_Wuxingjinengkezhi",skillLevel,"XiaoGuo")/1000);
  elseif 2 == self.type then
    local data = analysis2key("Kapai_Tianfu", "tianFuId", skillConfigId, "level", skillLevel);
    if not data then
      text = "天赋尚未激活";
    else
      text = data.miaoShu;
    end
  else
    local tb_data = analysis("Jineng_Jineng", skillConfigId);
    text = tb_data.describe;
    local chuShiFuJiaGongJi = tb_data.chuShiFuJiaGongJi;
    local chengZhangFuJiaGongJi = tb_data.chengZhangFuJiaGongJi;
    local chuShiJiaChen = tb_data.chuShiJiaChen;
    local jiaChenZenJia = tb_data.jiaChenZenJia;

    --@2
    local prop = chuShiFuJiaGongJi + (-1 + skillLevel) * chengZhangFuJiaGongJi;
    print("???->",chuShiFuJiaGongJi,skillLevel,chengZhangFuJiaGongJi);
    --@1
    local prop_attach = math.floor(prop * (chuShiJiaChen + (-1 + skillLevel) * jiaChenZenJia) / 100000);

    --@3
    local effect = tb_data.effectAmount + (-1 + skillLevel) * tb_data.effectUp;

    --（1+@1/100）*人物攻击+@2=@4
    local value = self.context.heroHouseProxy:getZongPropValueWithPer(generalId,HeroPropConstConfig.GONG_JI);
    --@5
    local effect_new = effect/1000;
    -- print("chuShiFuJiaGongJi",chuShiFuJiaGongJi);
    -- print("skillLevel",skillLevel);
    -- print("chengZhangFuJiaGongJi",chengZhangFuJiaGongJi);
    -- print("chuShiJiaChen",chuShiJiaChen);
    -- print("jiaChenZenJia",jiaChenZenJia);
    -- print("value",value);
    -- print("total_value",total_value);
    --@4
    -- local total_value = math.floor((1 + prop_attach/100) * value + prop);
    
    local total_value = (value+(-1 + skillLevel)* chengZhangFuJiaGongJi+ chuShiFuJiaGongJi)*(1+ (chuShiJiaChen + (-1 + skillLevel) * jiaChenZenJia)/ 100000);
    total_value = math.floor(total_value);
    
    text = string.gsub(text,"@1",prop_attach);
    text = string.gsub(text,"@2",prop);
    text = string.gsub(text,"@3",effect);
    text = string.gsub(text,"@4",total_value);
    text = string.gsub(text,"@5",effect_new);
  end
  local descb_3= createTextFieldWithTextData(armature:getBone("descb_3").textData,text);
  self.armature.display:addChild(descb_3);
end