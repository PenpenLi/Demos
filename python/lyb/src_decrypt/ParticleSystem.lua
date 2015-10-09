-----------
--particleSystem
-----------
ParticleSystem = {};

--粒子系统类型
--雪花
local _PARTICLE_SYSTEM_TYPE1 = "1";
--梨花或桃花朵
local _PARTICLE_SYSTEM_TYPE2 = "2";
--竹叶
local _PARTICLE_SYSTEM_TYPE3 = "3";
--枫叶
local _PARTICLE_SYSTEM_TYPE4 = "4";
--蒲公英
local _PARTICLE_SYSTEM_TYPE5 = "5";
--梨花或桃花瓣
local _PARTICLE_SYSTEM_TYPE6 = "6";

--城区与剧情用
function ParticleSystem:initParticleLayer(cityNeedLayer,storyNeedLayer)
  self.cityNeedLayer = cityNeedLayer;
  self.storyNeedLayer = storyNeedLayer;
  self.cityParticle = nil;
  self.storyParticle = nil;
end

--城区与剧情用
function ParticleSystem:particleRunByCity(parent,typeName,randomN)
    if self.cityNeedLayer.name == parent.name or self.storyNeedLayer.name == parent.name then
        if self.storyParticle then
            self.storyNeedLayer.sprite:removeChild(self.storyParticle);
            self.storyParticle = nil;
        end
        if self.cityParticle then
            self.cityNeedLayer.sprite:removeChild(self.cityParticle);
            self.cityParticle = nil;
        end
    end
    self:particleRunByType(parent,typeName,randomN,true)
end

--战场用
-- 1,雪花
-- 2，梨花或桃花朵
-- 3,竹叶
-- 4，枫叶
-- 5，蒲公英
-- 6，梨花或桃花瓣
function ParticleSystem:particleRunByType(parent,typeName,randomN,flag)
    local typeArr = StringUtils:lua_string_split(typeName, ",")
    local num = math.random(100);
    randomN = tonumber(randomN)/1000
    if num > randomN then 
      return;
    end
    num = math.random(#typeArr)
    local typeNum = typeArr[num]
    if typeNum == _PARTICLE_SYSTEM_TYPE1  then
        self:ByTypeReadPlist(parent,"rain1",flag)
    elseif typeNum == _PARTICLE_SYSTEM_TYPE2  then
        self:ByTypeReadPlist(parent,"flower2",flag);
    elseif typeNum == _PARTICLE_SYSTEM_TYPE3  then
        self:ByTypeReadPlist(parent,"leaf6",flag);
    elseif typeNum == _PARTICLE_SYSTEM_TYPE4  then
        self:ByTypeReadPlist(parent,"leaf",flag);
    elseif typeNum == _PARTICLE_SYSTEM_TYPE5  then
        self:ByTypeReadPlist(parent,"flower8",flag);
    elseif typeNum == _PARTICLE_SYSTEM_TYPE6  then
        self:ByTypeReadPlist(parent,"flower7",flag);
    end
end

--没有随机值，一直有粒子用
function ParticleSystem:particleRunForEver(parent,typeName)
    self:forEverReadPlist(parent,typeName);
end
--没有随机值，一直有粒子用
function ParticleSystem:forEverReadPlist(parent,typeName)
    local particleSystem = CCParticleSystemQuad:create("resource/image/arts/particle"..typeName..".plist")
    particleSystem:setBlendAdditive(true)
    parent.sprite:addChild(particleSystem);
end

--城区与战场用
function ParticleSystem:ByTypeReadPlist(parent,typeName,flag)
    local particleSystem = CCParticleSystemQuad:create("resource/image/arts/particle"..typeName..".plist")
    particleSystem:setBlendAdditive(true)
    parent.sprite:addChild(particleSystem);
    if flag then
      if self.cityNeedLayer.name == parent.name then
          self.cityParticle = particleSystem;
      elseif self.storyNeedLayer.name == parent.name then
          self.storyParticle = particleSystem;
      end
    end
end

--战斗掉落
function ParticleSystem:adddDropDaojuPlist(parent,itemType)
    local particleSystem = CCParticleSystemQuad:create("resource/image/arts/1162.plist")
    particleSystem:setBlendAdditive(true)
    -- if itemType ~= "silver" then
        particleSystem:setPosition(ccp(50,50));
    -- end
    parent.sprite:addChild(particleSystem);
end

--主场景树叶
function ParticleSystem:adddMainSceneLeafPlist(parent)
    local particleSystem = CCParticleSystemQuad:create("resource/image/arts/".. StaticArtsConfig.ZHUCHENGSHUYE ..".plist")
    particleSystem:setBlendAdditive(true)
    particleSystem:setPosition(ccp(450,500));
    parent.sprite:addChild(particleSystem);
end

function ParticleSystem:adddMainSceneXiXianPlist(parent)
    local particleSystem = CCParticleSystemQuad:create("resource/image/arts/".. StaticArtsConfig.XIXIAN ..".plist")
    particleSystem:setBlendAdditive(true)
    particleSystem:setPosition(ccp(600,500));
    parent.sprite:addChild(particleSystem);
end

function ParticleSystem:adddMainSceneYuShuiPlist(parent)
    local particleSystem = CCParticleSystemQuad:create("resource/image/arts/".. StaticArtsConfig.YUSHUI ..".plist")
    particleSystem:setBlendAdditive(true)
    particleSystem:setPosition(ccp(600,500));
    parent.sprite:addChild(particleSystem);
end

--新手战斗场景用
function ParticleSystem:adddScreenPlist(parent,typeName)
    if not parent.sprite then return end
    local particleSystem = CCParticleSystemQuad:create("resource/image/arts/"..typeName..".plist")
    particleSystem:setBlendAdditive(true)
    particleSystem:setPosition(ccp(0,GameConfig.STAGE_HEIGHT+GameData.uiOffsetY));
    parent.sprite:addChild(particleSystem);
    return particleSystem
end

--开场动画用
function ParticleSystem:adddLeafPlist(parent)
    local particleSystem = CCParticleSystemQuad:create("resource/image/arts/particleleaf.plist")
    particleSystem:setBlendAdditive(true)
    parent.sprite:addChild(particleSystem);
end

--其它UI界面调用
function ParticleSystem:addParticleByUI(parent,typeName,position)
    local particleSystem = CCParticleSystemQuad:create("resource/image/arts/particle"..typeName..".plist")
    particleSystem:setBlendAdditive(true)
    particleSystem:setPosition(position);
    parent.sprite:addChild(particleSystem);
    return particleSystem
end
--其它UI界面调用
function ParticleSystem:removeParticleByUI(parent)
    parent.sprite:removeAllChildrenWithCleanup(true);
end
function ParticleSystem:dispose()
      self.cityNeedLayer = nil;
      self.storyNeedLayer = nil;
      self.cityParticle = nil;
      self.storyParticle = nil;
end
