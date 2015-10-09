--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-4

	yanchuan.xie@happyelements.com
]]

RankListProxy=class(Proxy);

function RankListProxy:ctor()
  self.class=RankListProxy;
  self.data={};
  self.skeleton=nil;
end

rawset(RankListProxy,"name","RankListProxy");

--更新
function RankListProxy:refresh(type, rankArray)
  if nil==self.data[type] then
    self.data[type]=rankArray;
    return;
  end
  for k,v in pairs(rankArray) do
    self:refreshItem(type,v);
  end
end

function RankListProxy:refreshItem(type, rankData)
  local a=self.data[type];
  for k,v in pairs(a) do
    if rankData.Ranking==v.Ranking then
      for k_,v_ in pairs(v) do
        v[k_]=rankData[k_];
        return;
      end
    end
  end
  table.insert(a,rankData);
end

function RankListProxy:getData()
  return self.data;
end

function RankListProxy:getDataByType(type)
    return self.data[type];
end

function RankListProxy:getDataByTypeAndRanking(type, ranking)
  local a=self.data[type];
  for k,v in pairs(a) do
  	if ranking==v.Ranking then
  		return v;
  	end
  end
end

function RankListProxy:getSkeleton()
  if nil==self.skeleton then
    self.skeleton=SkeletonFactory.new();
    self.skeleton:parseDataFromFile("rank_list_ui");
  end
  return self.skeleton;
end