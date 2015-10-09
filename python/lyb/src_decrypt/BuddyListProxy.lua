--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-15

	yanchuan.xie@happyelements.com
]]

BuddyListProxy=class(Proxy);

function BuddyListProxy:ctor()
  self.class=BuddyListProxy;
  self.data={};
  self.data_online=nil;
  self.flower = flower;

  self.gantanhaos={};
  self.lookIntoData = nil;
  self.idArray = nil;
  -- {UserName="名字五个字",Level=1,UserId=1},
  -- {UserName="名字五个字",Level=1,UserId=1},
  -- {UserName="名字五个字",Level=1,UserId=1},
  -- {UserName="名字五个字",Level=1,UserId=1},
  -- {UserName="名字五个字",Level=1,UserId=1},
  -- {UserName="名字五个字",Level=1,UserId=1},
  -- {UserName="名字五个字",Level=1,UserId=1},
  -- {UserName="名字五个字",Level=1,UserId=1},
  -- {UserName="名字五个字",Level=1,UserId=1},
  -- {UserName="名字五个字",Level=1,UserId=1},
  -- {UserName="名字五个字",Level=1,UserId=1},
  self.haoyou_ids = {};
end

rawset(BuddyListProxy,"name","BuddyListProxy");

function BuddyListProxy:refreshHaoyouIDs(idArray)
  self.haoyou_ids = idArray;
end

function BuddyListProxy:refreshHaoyouIDsByUserRelationArray(userRelationArray)
  for k,v in pairs(userRelationArray) do
    self:addHaoyouID(v.UserId);
  end
end

function BuddyListProxy:addHaoyouID(id)
  for k,v in pairs(self.haoyou_ids) do
    if id == v.ID then
      return;
    end
  end
  table.insert(self.haoyou_ids,{ID = id});
end

function BuddyListProxy:deleteHaoyouID(id)
  for k,v in pairs(self.haoyou_ids) do
    if id == v.ID then
      table.remove(self.haoyou_ids,k);
      break;
    end
  end
end

function BuddyListProxy:getIsHaoyou(id)
  for k,v in pairs(self.haoyou_ids) do
    print("========",id,v.ID,id == v.ID);
    if id == v.ID then
      return true;
    end
  end
  return false;
end

function BuddyListProxy:getBuddyNum()
  if self.haoyou_ids then
    return table.getn(self.haoyou_ids);
  end
  return 0;
end

function BuddyListProxy:getBuddyNumMax()
  local userProxy = Facade:getInstance():retrieveProxy(UserProxy.name);
  local vipLevel = userProxy:getVipLevel();
  return analysis("Huiyuan_Huiyuantequan",8,"vip" .. vipLevel);
end

function BuddyListProxy:getBuddyNumFull()
  return self:getBuddyNumMax()<=self:getBuddyNum();
end

function BuddyListProxy:addBuddys(userRelationArray)
  for k,v in pairs(userRelationArray) do
    table.insert(self.data,v);
  end
  self:sortBuddyData();
end

function BuddyListProxy:addBuddy(userName, level, userID)
  local a={UserName=userName,Level=level,UserId=userID};
  table.insert(self.data,a);
end

function BuddyListProxy:deleteBuddy(userName, userID)
  for k,v in pairs(self.data) do
    if userID == v.UserId then
      table.remove(self.data,k);
      break;
    end
  end
  -- if self.data then
  --   for k,v in pairs(self.data) do
  --     if userName==v.UserName then
  --       table.remove(self.data,k);
  --       break;
  --     end
  --   end
  -- end
  -- if self.data_online then
  --   for k,v in pairs(self.data_online) do
  --     if userName==v.UserName then
  --       table.remove(self.data_online,k);
  --       break;
  --     end
  --   end
  -- end
end

function BuddyListProxy:sortBuddyData()
  local function sort(data_a, data_b)
    if data_a.BooleanValue > data_b.BooleanValue then
      return true;
    elseif data_a.BooleanValue < data_b.BooleanValue then
      return false;
    elseif data_a.Level > data_b.Level then
      return true;
    elseif data_a.Level < data_b.Level then
      return false;
    elseif data_a.Zhanli > data_b.Zhanli then
      return true;
    else
      return false;
    end
  end
  table.sort(self.data,sort);
end

function BuddyListProxy:refresh(userRelationArray, flower)
  self.flower = flower;
  if nil==self.data then
    self.data=userRelationArray;
    self:sortBuddyData();
    return;
  end
  for k,v in pairs(userRelationArray) do
    self:refreshItem(v);
  end
  self:sortBuddyData();
  -- self.data_online=userRelationArray;
end

function BuddyListProxy:refreshItem(userRelation)
  for k,v in pairs(self.data) do
    if userRelation.UserId==v.UserId then
      for k_,v_ in pairs(v) do
        v[k_]=userRelation[k_];
      end
      return;
    end
  end
  table.insert(self.data,userRelation);
end

function BuddyListProxy:getBuddyData(userName)
  if self.data then
    for k,v in pairs(self.data) do
      if userName==v.UserName then
        return v;
      end
    end
  end
end

function BuddyListProxy:getBuddyDataByUserID(userID)
  if self.data then
    for k,v in pairs(self.data) do
      if userID==v.UserId then
        return v;
      end
    end
  end
end

function BuddyListProxy:getBuddyOnlineData(userName)
  if self.data_online then
    for k,v in pairs(self.data_online) do
      if userName==v.UserName then
        return v;
      end
    end
  end
end

function BuddyListProxy:getData()
  return self.data;
end

function BuddyListProxy:getDataOnline()
  return self.data_online;
end

function BuddyListProxy:deleteGantanhao(name)
  for k,v in pairs(self.gantanhaos) do
    if name==v.UserName then
      table.remove(self.gantanhaos,k);
      return;
    end
  end
end

function BuddyListProxy:refreshGantanhaos(name, level, userID)
  local data={UserName=name,Level=tonumber(level),UserId=tonumber(userID)};
  for k,v in pairs(self.gantanhaos) do
    if data.UserName==v.UserName then
      return;
    end
  end
  table.insert(self.gantanhaos,data);
  if 50<table.getn(self.gantanhaos) then
    table.remove(self.gantanhaos,1);
  end
end

function BuddyListProxy:getGantanhaos()
  return self.gantanhaos;
end

function BuddyListProxy:getFlowerCount()
  return self.flower;
end

function BuddyListProxy:getSkeleton()
  if nil==self.skeleton then
    self.skeleton=SkeletonFactory.new();
    self.skeleton:parseDataFromFile("buddy_ui");
  end
  return self.skeleton;
end

function BuddyListProxy:setShezhi(idArray)
  self.idArray = idArray;
end

function BuddyListProxy:getShezhiByID(id)
  if self.idArray then
    for k,v in pairs(self.idArray) do
      if id == v.ID then
        return true;
      end
    end
  end
end