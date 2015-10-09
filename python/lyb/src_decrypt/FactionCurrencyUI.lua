
require "main.config.XiShuConfig";
FactionCurrencyUI=class(LayerProxyRetrievable);

function FactionCurrencyUI:ctor()
  self.class=FactionCurrencyUI;
end

function FactionCurrencyUI:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	FactionCurrencyUI.superclass.dispose(self);
end

function FactionCurrencyUI:initialize()
    self:initLayer();
   local winSize = Director:sharedDirector():getWinSize();
    -- local layerColor = LayerColor.new();
    -- layerColor:initLayer();
    -- layerColor:changeWidthAndHeight(winSize.width,54);
    -- layerColor:setColor(ccc3(0,0,0));
    -- layerColor:setOpacity(125);
    -- layerColor:setPositionXY(-GameData.uiOffsetX,66+winSize.height - 118 -GameData.uiOffsetY)
    -- self:addChild(layerColor)

    local proxyRetriever  = ProxyRetriever.new();
    self.userCurrencyProxy=proxyRetriever:retrieveProxy(UserCurrencyProxy.name);
    self.userProxy=proxyRetriever:retrieveProxy(UserProxy.name);

    local huobiGroup = MovieClip.new();
    huobiGroup:initFromFile("faction_ui", "huobiGroup");
    huobiGroup:gotoAndPlay("f1");


    huobiGroup.layer:setPositionXY(0,winSize.height - 60 -GameData.uiOffsetY)    

    self:addChild(huobiGroup.layer);
    huobiGroup:update();
    self.huobiGroup = huobiGroup;
      
    self.shengwangTextBone = huobiGroup.armature:getBone("shengwangText")
    self.shengwang_bantouDO = huobiGroup.armature:getBone("shengwang_bantou"):getDisplay()

    self.tiliTextBone = huobiGroup.armature:getBone("tiliText")
    self.tili_bantouDO = huobiGroup.armature:getBone("tili_bantou"):getDisplay()
    self.jia_tiliDO = huobiGroup.armature:getBone("jia_tili"):getDisplay()


    local shengguan = huobiGroup.armature:getBone("shengguan"):getDisplay();
    -- local shengguanPos = convertBone2LB4Button(shengguan);
    shengguan.parent:removeChild(shengguan);
    
    -- self.shengguanDO = CommonButton.new();
    -- self.shengguanDO:initialize("common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
    -- self.shengguanDO.name = "shengguan"
    -- self.shengguanDO:setPosition(shengguanPos);
    -- self.shengguanDO:initializeBMText("升官", "anniutuzi");

    -- huobiGroup.layer:addChild(self.shengguanDO)



    -- self.boneLightCartoon = BoneCartoon.new()
    -- self.boneLightCartoon:create(StaticArtsConfig.BONE_EFFECT_SHENGGUAN_BUTTON,0);
    -- self.boneLightCartoon:setMyBlendFunc()
    -- huobiGroup.layer:addChild(self.boneLightCartoon);

    -- self.boneLightCartoon:setPositionXY(218, 33)



    -- self:refreshRedDot();
    
    self.guanzhiTextBone = huobiGroup.armature:getBone("guanzhiText")

    self.guanzhi_bantouDO = huobiGroup.armature:getBone("guanzhi_bantou"):getDisplay()
  


    self.yinliangTextBone = huobiGroup.armature:getBone("yinliangText")


    self.jia_yingliangDO = huobiGroup.armature:getBone("jia_yingliang"):getDisplay()
    self.yingliang_bantouDO = huobiGroup.armature:getBone("yingliang_bantou"):getDisplay()

    self.tili_bantouDO = huobiGroup.armature:getBone("tili_bantou"):getDisplay()

    self.shengwang_bantouDO = huobiGroup.armature:getBone("shengwang_bantou"):getDisplay()
    

    print("@@@@@@@@@@@@@@@@@@@@FactionCurrencyUI:initialize()");

    self:setHuobiText()
end

-- function FactionCurrencyUI:refreshRedDot()
   
--     local shengwanggou
--     if analysisHas("Shili_Guanzhi",self.userProxy:getNobility() + 1) then
--       shengwanggou = analysis("Shili_Guanzhi",self.userProxy:getNobility() + 1,"prestige") <= self.userCurrencyProxy:getPrestige()
--     end
--     local guanzhiCanRed = not GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_33] and shengwanggou    
--     self.redDot = CommonSkeleton:getBoneTextureDisplay("commonImages/common_redIcon");
--     self.redDot:setPositionXY(105,30)
--     -- self.shengguanDO:addChild(self.redDot)
--     if guanzhiCanRed then
--       self.redDot:setVisible(true)
--     else
--       self.redDot:setVisible(false)
--     end
-- end

function FactionCurrencyUI:setHuobiText()

  local tili = self.userCurrencyProxy.tili.."/" .. analysis("Xishuhuizong_Xishubiao",XiShuConfig.TYPE_1014,"constant");
  if not self.tiliText then
    self.tiliTextBone.textData.y = self.tiliTextBone.textData.y;
    self.tiliText = createTextFieldWithTextData(self.tiliTextBone.textData,tili);
    self.tiliText.touchEnabled = false;
    self.huobiGroup.layer:addChild(self.tiliText)
  else
    self.tiliText:setString(tili);
  end


  local prestige = self.userCurrencyProxy:getPrestige()
  if prestige >= 1000000 then
    prestige = math.floor(prestige / 10000) .. " 万";
  end   
  if not self.shengwangText then
    self.shengwangText = createTextFieldWithTextData(self.shengwangTextBone.textData,prestige)
    self.shengwangText.touchEnabled = false;
    self.huobiGroup.layer:addChild(self.shengwangText)
  else
    self.shengwangText:setString(prestige);
  end
  
  -- print("self.userCurrencyProxy:getPrestige()", self.userCurrencyProxy:getPrestige())
  -- local function shortFun(a,b)
  --   return a.prestige < b.prestige;
  -- end
  -- local guanzhiTables = analysisTotalTableArray("Shili_Guanzhi")
  -- table.sort(guanzhiTables, shortFun)
  -- local nobilityId = 0;
  -- for k, v in pairs(guanzhiTables) do
  --   if self.userCurrencyProxy:getPrestige() < v.prestige then
  --     break;
  --   end
  --   nobilityId = nobilityId + 1;
  -- end
  local nobility = analysis("Shili_Guanzhi",self.userProxy.nobility,"title")

  if not self.guanzhiText then
    self.guanzhiText = createTextFieldWithTextData(self.guanzhiTextBone.textData,nobility)
    self.guanzhiText.touchEnabled = false;
    self.huobiGroup.layer:addChild(self.guanzhiText)
  else
    self.guanzhiText:setString(nobility)
  end
 
  local sliver_wan = self.userCurrencyProxy.silver
  if sliver_wan >= 1000000 then
    sliver_wan = math.floor(sliver_wan / 10000) .. " 万";
  end 

  if not self.sliverText then

    self.sliverText = createTextFieldWithTextData(self.yinliangTextBone.textData,sliver_wan)
    self.sliverText.touchEnabled = false;
    self.huobiGroup.layer:addChild(self.sliverText)
  else
    self.sliverText:setString(sliver_wan)
  end

end
