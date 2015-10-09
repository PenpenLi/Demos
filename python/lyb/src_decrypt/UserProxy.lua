--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.


]]

UserProxy=class(Proxy);

function UserProxy:ctor()

  self.class=UserProxy;
  self.sceneType = GameConfig.SCENE_TYPE_1;
  self.storyLineId=nil;
  self.userId = nil;
  self.userName = nil;
  self.state = GameConfig.STATE_TYPE_1;--1正常状态,2副本状态,3挂机状态
  self.career = nil;
  self.itemIdHead = nil;
  self.itemIdBody = nil;
  self.itemIdWeapon = nil;
  self.userState = nil;
  self.isFinishFistBattle = nil;
  self.imageID = nil
  self.hasInit = false;
  self.vip = 0;
  self.vipLevel = 0;
  self.vipLevelMax = 0;
  self.enableTitleIDs=nil;
  self.outFromBattle = false;
  self.familyId=0;
  self.familyPositionId=0;
  self.familyName = "";
  self.nobility=0;  --爵位等级;
  self.nobilityNoticed = false; --声望足够提升时,感叹号提示状态

  self.guangboData={};

  self.userInviteFinished = false; --邀请好友功能是否全完成
  self.mainGeneralLevel = nil;
  self.generalArray = {};

  self.level = 0;
  self.experience = 0;
  self.transforId = 0;
  self.zodiacId = 0;
  self.tianXiangZuIds = {};
  self.tianXiangIds = {};
end

rawset(UserProxy,"name","UserProxy");

function UserProxy:refreshVipLevel()
  local vipTable=analysisTotalTable("Huiyuan_Huiyuandengji");
  table.remove(vipTable,1);
  if 0==self.vipLevelMax then
    --self.vipLevelMax=table.getn(vipTable);
    for k,v in pairs(vipTable) do
      self.vipLevelMax=1+self.vipLevelMax;
    end
  end
  if self.vip == 0 then return; end
  for k,v in pairs(vipTable) do
    if self.vip>=v.min and self.vip<=v.max then
      self.vipLevel=tonumber(string.sub(k,4));
      return;
    end
  end
  self.vipLevel=self.vipLevelMax;
end

function UserProxy:getCareer()
  return self.career;
end

function UserProxy:changeTitleID(id, enable)
  if nil==self.enableTitleIDs then
    self.enableTitleIDs={};
  end
  if 1==enable then
    if self:isTitleIDEnable(id) then
      error("wrong invoke");
    end
    table.insert(self.enableTitleIDs,{EnableTitleId=id});
  else
    for k,v in pairs(self.enableTitleIDs) do
      if id==v.EnableTitleId then
        table.remove(self.enableTitleIDs,k);
        return;
      end
    end
  end
end

function UserProxy:isTitleIDEnable(id)
  if self.enableTitleIDs then
    for k,v in pairs(self.enableTitleIDs) do
      if id==v.EnableTitleId then
        return true;
      end
    end
  end
  return false;
end

function UserProxy:getEnableTitleArray()
  local a=self.enableTitleIDs;
  local b={};
  if a then
    for k,v in pairs(a) do
      table.insert(b,v.EnableTitleId);
    end
  end
  return b;
end

function UserProxy:getEnableTitleIDs()
  return self.enableTitleIDs;
end

function UserProxy:setEnableTitleIDs(ids)
  self.enableTitleIDs=ids;
end

function UserProxy:getEnableTitleIDNumber()
  if nil==self.enableTitleIDs then
    return 0;
  end
  return table.getn(self.enableTitleIDs);
end

function UserProxy:isFreshman()
  -- if GameVar.tutorStage then
  --    return GameVar.tutorStage <= TutorConfig.STAGE_3000;
  -- else
  --   return false;
  -- end
  return false;
end

function UserProxy:getUserID()
  return self.userId;
end

function UserProxy:getUserName()
  return self.userName;
end

--vip经验
function UserProxy:getVip()
  return self.vip;
end

--vip等级
function UserProxy:getVipLevel()
  return self.vipLevel;
end

function UserProxy:getIsVip()
  return 0~=self:getVipLevel();
end

function UserProxy:getVipLevelMax()
  return self.vipLevelMax;
end

function UserProxy:getFamilyID()
  return self.familyId;
end

function UserProxy:getHasFamily()
  return 0 ~= self.familyId;
end

function UserProxy:getFamilyPositionID()
  return self.familyPositionId;
end

function UserProxy:getIsFamilyLeader()
  return 1==self.familyPositionId;
end

function UserProxy:getFamilyName()
  return self.familyName;
end

function UserProxy:getIsDeputyLeader()
  return 2==self.familyPositionId;
end

function UserProxy:getHasQuanxian(quanxianid)
  if not self:getHasFamily() then
    return false;
  end
  local ss = StringUtils:lua_string_split(analysis("Bangpai_Zhiweidengjibiao",self.familyPositionId,"quanxian"),",");
  for k,v in pairs(ss) do
    if quanxianid == tonumber(v) then
      return true;
    end
  end
  return false;
end

function UserProxy:getHandofMidasSkeleton()
  if nil==self.handofMidasSkeleton then
    self.handofMidasSkeleton = SkeletonFactory.new();
    self.handofMidasSkeleton:parseDataFromFile("handofMidas_ui");
  end
  return self.handofMidasSkeleton;
end

function UserProxy:setNobility(nobility)
  if nobility < 0 then
    nobility = 0;
  end
  self.nobility = nobility;
end

function UserProxy:getNobility()
  return self.nobility;
end

function UserProxy:onRemove()

end

function UserProxy:getLevel()
  return self.level;
end

function UserProxy:getExperience()
  return self.experience;
end
function UserProxy:getHeadArtId()
  local headArtId;
  if self.transforId == 0 then
    headArtId = analysis("Zhujiao_Zhujiaozhiye",self:getCareer(),"art3") 
  else
    headArtId = analysis("Zhujiao_Huanhua",self.transforId,"head")  
  end
  return headArtId;
end

function UserProxy:checkIsNextTianXiang(tianXiangId)

  if self.zodiacId == 0 then
    if tianXiangId == 10001 then
      return true;
    end
    return false;
  end

  local nextId = analysis("Zhujiao_Tianxiangshouhudian", self.zodiacId, "id2")

  if nextId == tianXiangId then
    return true;
  end
  return false;
end
function UserProxy:getNextTianXiang()
  local value1 = analysis("Zhujiao_Tianxiangshouhudian", self.zodiacId, "id2");
  return value1;
end
