
require "main.controller.notification.ShopTwoNotification"
require "main.model.CountControlProxy";
MapOuterLayer = class(Layer);
function MapOuterLayer:ctor()
	self.class = MapOuterLayer;
  self.materialLayer = nil;
  self.roleArray = {};
end

function MapOuterLayer:dispose()
  local familyProxy = Facade.getInstance():retrieveProxy(FamilyProxy.name);
  if familyProxy then
    familyProxy.family_npc_hongdian = nil;
  end
	self:removeAllEventListeners();
	self:removeChildren();
	MapOuterLayer.superclass.dispose(self);
end

function MapOuterLayer:onInit()
    self:initLayer();

    self.materialLayer = Layer.new();
    self.materialLayer:initLayer();
    self:addChild(self.materialLayer);


end


function MapOuterLayer:initProxy()
  local proxyRetriever = ProxyRetriever.new();
  self.storyLineProxy = proxyRetriever:retrieveProxy();
end

function MapOuterLayer:addMainRole()
  if self.mainRole then
    self.materialLayer:removeChild(self.mainRole)
    self.mainRole = nil;
  end
  local key
  local shenti;
  local shuashuai;
  print("self.context.userProxy.transforId", self.context.userProxy.transforId)
  if self.context.userProxy.transforId == 1 or  self.context.userProxy.transforId == 2 then
    local po = analysis("Zhujiao_Zhujiaozhiye",self.context.userProxy:getCareer());
    shenti = po.shenti
    shuashuai = po.shuashuai 

    self.mainRole = getCompositeMainRole(self.context.userProxy:getCareer())
    self.mainRole:setScale(0.8)
  else
    local huanHuaPo = analysis("Zhujiao_Huanhua", self.context.userProxy.transforId) 
    print("huanHuaPo.heroid", huanHuaPo.heroid);
    self.mainRole = getCompositeRole(huanHuaPo.body)
    self.mainRole:setScale(0.8)
    shenti = huanHuaPo.body
    shuashuai = analysis("Kapai_Kapaiku", huanHuaPo.heroid, "shuashuai") 
  end
  key = shenti.."_"..BattleConfig.HOLD;
  local compositeSize = getFrameContentSize(key);
  self.mainRole:addTouchEventListener(DisplayEvents.kTouchTap,self.clickRoleHandler,self,{ConfigId = shenti, compositeRole = self.mainRole, shuashuai=shuashuai, isMainRole = true},compositeSize.width,compositeSize.height)

  self.mainRole:setPositionXY(316,225)
  self:addRoleShadow(self.mainRole)
  self.materialLayer:addChild(self.mainRole)

end

function MapOuterLayer:addGeneralRole()

  if self.context.userProxy.generalArray then
    local index = 1;
    for k, v in pairs(self.context.userProxy.generalArray)do
        local kapaikuPo = analysis("Kapai_Kapaiku", v.ConfigId)
        -- local modelId = analysis("Kapai_Kapaiku", v.ConfigId);--, "material_id"
        -- print("v.ConfigId", v.ConfigId, "modelId", modelId)
        local modelId = kapaikuPo.material_id;
        if modelId then--这个是容错用的
          local compositeRole = getCompositeRole(modelId,true);
          compositeRole:setScaleY(0.8)
          if index == 1 then
            compositeRole:setPositionXY(608,134)
          elseif index == 2 then
            compositeRole:setPositionXY(731,202)
          elseif index == 3 then
            compositeRole:setPositionXY(840,143)
          elseif index == 4 then
            compositeRole:setPositionXY(938,201)
          elseif index == 5 then
            compositeRole:setPositionXY(1059,147)
          end
          self:addRoleShadow(compositeRole)

          local key = modelId.."_"..BattleConfig.HOLD;
          local compositeSize = getFrameContentSize(key);

          compositeRole:addTouchEventListener(DisplayEvents.kTouchTap,self.clickRoleHandler,self,{ConfigId = modelId, compositeRole = compositeRole, shuashuai=kapaikuPo.shuashuai, isMainRole = false},compositeSize.width,compositeSize.height)

          compositeRole:setScaleX(-0.8)
          self.materialLayer:addChild(compositeRole)
          index = index + 1;

          table.insert(self.roleArray, compositeRole);
        end
    end
    -- self.context.userProxy.generalArray = nil;
    return true;
  end
  return false;
end
function MapOuterLayer:setContext(context)
  self.context = context;
end
function MapOuterLayer:setData()
  self:addMainRole()
  if not self:addGeneralRole() then
    self:refreshGeneralRoleData()
  end
end
function MapOuterLayer:refreshGeneralRoleData()
  print("function MapOuterLayer:refreshGeneralRoleData()")
  self:removeGeneralRoleData();
  local index = 1;
  for k, v in pairs(self.context.heroHouseProxy.generalArray)do
    if v.IsPlay == 1 then
      local generalVO = self.context.heroHouseProxy:getGeneralData(v.GeneralId)
      local kapaikuPo = analysis("Kapai_Kapaiku", generalVO.ConfigId);
      local modelId = kapaikuPo.material_id
      local compositeRole = getCompositeRole(modelId,true);
      compositeRole:setScaleY(0.8)
      if index == 1 then
        compositeRole:setPositionXY(608,134)
      elseif index == 2 then
        compositeRole:setPositionXY(731,202)
      elseif index == 3 then
        compositeRole:setPositionXY(840,143)
      elseif index == 4 then
        compositeRole:setPositionXY(938,201)
      elseif index == 5 then
        compositeRole:setPositionXY(1059,147)
      end
      self:addRoleShadow(compositeRole)
      local key = modelId.."_"..BattleConfig.HOLD;
      local compositeSize = getFrameContentSize(key);
      compositeRole:addTouchEventListener(DisplayEvents.kTouchTap,self.clickRoleHandler,self,{ConfigId = modelId, compositeRole = compositeRole, shuashuai=kapaikuPo.shuashuai, isMainRole = false},compositeSize.width,compositeSize.height)

      self.materialLayer:addChild(compositeRole)
      index = index + 1;
      compositeRole:setScaleX(-0.8)
      table.insert(self.roleArray, compositeRole);
    end
  end
end
function MapOuterLayer:removeGeneralRoleData()
    print("self.roleArray", #self.roleArray)
    for key,value in pairs(self.roleArray) do
        self.materialLayer:removeChild(value)
    end
    self.roleArray = {}
end
function MapOuterLayer:addRoleShadow(role)
    local roleShadow = Image.new()
    roleShadow:loadByArtID(StaticArtsConfig.IMAGE_HERO_SHADOW)
    roleShadow:setAnchorPoint(CCPointMake(0.5,0.5));
    -- roleShadow:setPositionXY(role:getPositionX(),role:getPositionY());
    role.roleShadow = roleShadow
    role:addChildAt(roleShadow, 0);
    roleShadow.touchChildren = false;
    roleShadow.touchEnabled = false;
end
function MapOuterLayer:clickRoleHandler(event,compositeRoleData)


  local totalMemoryOk = true;
  if CommonUtils:getCurrentPlatform() == CC_PLATFORM_ANDROID or  CommonUtils:getCurrentPlatform() == CC_PLATFORM_IOS then
    if CommonUtils:getCurrentPlatform() == CC_PLATFORM_ANDROID and MetaInfo:getInstance():getTotalMemory() < 800000 then
      totalMemoryOk = false;
    end
  end
  if totalMemoryOk then
     print("compositeRoleData.shuashuai", compositeRoleData.shuashuai)
     -- if compositeRoleData.shuashuai ~= "" then
     --   local musicArr = StringUtils:lua_string_split(compositeRoleData.shuashuai, ";")
     --   MusicUtils:stopEffect();
     --   if #musicArr > 0 then
     --      local random = math.ceil(math.random(#musicArr));
     --      MusicUtils:playEffect(musicArr[random])
     --   else
     --      MusicUtils:playEffect(compositeRoleData.shuashuai)
     --   end

     -- end
      print("MapOuterLayer:clickRoleHandler", compositeRoleData.shuashuai)
      MusicUtils:playHeroEffect(compositeRoleData.shuashuai); 


     local compositeRole = compositeRoleData.compositeRole;
     local function playCallBack()
        compositeRole:playAndLoop(BattleConfig.HOLD)
     end
     local randomSkill = math.ceil(math.random(3)) + 4
     compositeRole:playAndBack(randomSkill, playCallBack)
  end
end
function MapOuterLayer:addFamilyNpc()

  self.gongGao = Image.new()
  self.gongGao:loadByArtID(1361)
  self.gongGao:setPositionXY(145, 397);
  self.gongGao:setAnchorPoint(ccp(0.5,0.5))
  self.gongGao:addEventListener(DisplayEvents.kTouchTap,self.clickGongGaoTiShi,self)
  self.gongGao:addEventListener(DisplayEvents.kTouchBegin,self.onImageTouchBegin,self)
  self.materialLayer:addChild(self.gongGao);

  self.gongGaoTiShi = Image.new()
  self.gongGaoTiShi:loadByArtID(1651)
  self.gongGaoTiShi:addEventListener(DisplayEvents.kTouchTap,self.clickGongGaoTiShi,self)
  self.gongGaoTiShi:addEventListener(DisplayEvents.kTouchBegin,self.onImageTouchBegin,self)
  self.gongGaoTiShi:setAnchorPoint(ccp(0.5,0.5))
  self.gongGaoTiShi:setPositionXY(143, 540);
  self.materialLayer:addChild(self.gongGaoTiShi);

     
  self.tiShiText=TextField.new(CCLabelTTF:create(self.context.familyProxy.gongGao, GameConfig.DEFAULT_FONT_NAME, 22, CCSizeMake(260,63)));
  
  self.tiShiText:setColor(ccc3(255,168,1))
  self.tiShiText:setPositionXY(10, 32)
  -- 根据名字的宽度定位
  self.tiShiText.touchEnabled = false;
  self.gongGaoTiShi:addChild(self.tiShiText);

  print("addFamilyNpc()")
  local totalTable = analysisTotalTable("Bangpai_Bangpaichangjing")
  for k, v in pairs(totalTable)do
      if v.type == 1 then
        self:addOneFamilyNpc(v);
      end
  end
end
function MapOuterLayer:addOneFamilyNpc(v)
    local modelId = v.artId
    print("self.context.familyProxy.bangZhuConfigId", self.context.familyProxy.bangZhuConfigId)
    if v.id == 1 then
      modelId = analysis("Zhujiao_Huanhua", self.context.familyProxy.bangZhuConfigId, "body")
    end

    local compositeRole = getCompositeRole(modelId,true);
    compositeRole.NpcId = v.id

    self:addRoleShadow(compositeRole)
    local key = modelId.."_"..BattleConfig.HOLD;
    local compositeSize = getFrameContentSize(key);
    compositeRole:addTouchEventListener(DisplayEvents.kTouchTap,self.clickFamilyNpcHandler,self,{NpcId = v.id, compositeRole = compositeRole},compositeSize.width,compositeSize.height, true)

    self.materialLayer:addChild(compositeRole)

    table.insert(self.roleArray, compositeRole);

    local npcName = v.name;
    if v.id == 1 then
      npcName =  npcName .. "：" .. self.context.familyProxy.bangZhuName;
    end
    local npcNameText=TextField.new(CCLabelTTFStroke:create(npcName, GameConfig.DEFAULT_FONT_NAME, 22, 1, ccc3(0,0,0),CCSizeMake(0,0),"left",kCCVerticalTextAlignmentCenter));
    npcNameText:setPositionXY(-npcNameText:getContentSize().width/2, compositeSize.height-10)
    -- 根据名字的宽度定位
    npcNameText.touchEnabled = false;
    compositeRole:addChild(npcNameText);

    local headImage = Image.new()
    headImage:loadByArtID(v.functionArt)
    headImage:setAnchorPoint(CCPointMake(0.5,0.5));

    if 1 == v.id then
      local hongdian = CommonSkeleton:getBoneTextureDisplay("commonImages/common_redIcon");
      hongdian:setPositionXY(35,275);
      compositeRole:addChild(hongdian);

      local familyProxy = Facade.getInstance():retrieveProxy(FamilyProxy.name);
      local heroHouseProxy = Facade.getInstance():retrieveProxy(HeroHouseProxy.name);
      local userProxy = Facade.getInstance():retrieveProxy(UserProxy.name);
      familyProxy.family_npc_hongdian = hongdian;
      familyProxy.family_npc_hongdian:setVisible(heroHouseProxy.Hongidan_Huoyuedu or (heroHouseProxy.Hongidan_Shenqingdu and userProxy:getHasQuanxian(1)));
    end

    headImage:addEventListener(DisplayEvents.kTouchBegin,self.onImageTouchBegin,self)
    headImage:addEventListener(DisplayEvents.kTouchTap,self.clickFamilyNpcHandler,self,{NpcId = v.id, compositeRole = compositeRole})
    compositeRole:addChild(headImage);  
    headImage:setPositionXY(0,compositeSize.height+70);

    local xPos, yPos
    if v.id == 1 then
      xPos, yPos = 766, 310

    elseif v.id == 2 then
      xPos, yPos = 484, 310
    elseif v.id == 3 then
      compositeRole:changeFaceDirect(true);
      xPos, yPos = 1030, 310
    elseif v.id == 5 then
      xPos, yPos = 1293, 310
      compositeRole:changeFaceDirect(true);
    end
    compositeRole:setPositionXY(xPos, yPos)
end
function MapOuterLayer:refreshGongGao(gongGaoContent)
  self.tiShiText:setString(gongGaoContent)
end
function MapOuterLayer:refreshBangZhu(userName, confingId)
  for k, v in pairs(self.roleArray)do
    if v.NpcId == 1 then
      self.materialLayer:removeChild(v);
      self.roleArray[k] = nil;
    end
  end
  local totalTable = analysisTotalTable("Bangpai_Bangpaichangjing")
  for k, v in pairs(totalTable)do
      if v.id == 1 then
        self:addOneFamilyNpc(v);
      end
  end
end
function MapOuterLayer:clickGongGaoTiShi(event)

  self.parent.rolePlayer:setPath({[1] = {x = 170, y = 310}}, self.parent.moveComplete, self.parent, {NpcId = 0})

end
function MapOuterLayer:onImageTouchBegin(event)
  event.target:setScale(0.88)
  event.target:addEventListener(DisplayEvents.kTouchEnd,self.onImageTouchEnd,self)
end
function MapOuterLayer:onImageTouchEnd(event)
  event.target:setScale(1)
  event.target:removeEventListener(DisplayEvents.kTouchEnd,self.onImageTouchEnd)
end
function MapOuterLayer:clickFamilyNpcHandler(event,compositeRoleData)
  print("MapOuterLayer:clickFamilyNpcHandler", compositeRoleData.NpcId)
  local compositeRole = compositeRoleData.compositeRole;
  local xPos = compositeRole:getPositionX();
  local yPos = compositeRole:getPositionY()-50;
  self.parent.rolePlayer:setPath({[1] = {x = xPos, y = yPos}}, self.parent.moveComplete, self.parent, {NpcId = compositeRoleData.NpcId})
end

function MapOuterLayer:onLoadingCall()
  if not self.call_num then
    self.call_num = 0;
  else
    self.call_num = 1 + self.call_num;
  end
  return math.floor(self.call_num/3);
end


function MapOuterLayer:clean()
  self.materialLayer:removeChildren();
end


