
	-- Copyright @2009-2013 www.happyelements.com, all rights reserved.


StrongPointInfoProxy=class(Proxy);

function StrongPointInfoProxy:ctor()
  self.class=StrongPointInfoProxy;
  
  self.lastStrongPointId = 0  -- 通关过的最远的关卡

  self.lastStoryLineId = 0  -- 通关过的最远的关卡

  self.strongPointTable = {} -- 通关过的所有的区域图 剧情图 关卡
end

rawset(StrongPointInfoProxy,"name","StrongPointInfoProxy");

function StrongPointInfoProxy:setLastStrongPointId(lastStrongPointId)
	self.lastStrongPointId = lastStrongPointId;
	self.lastStoryLineId = analysis("Juqing_Guanka",Juqing_Zhandouguanka,"storyId")
	
end


--龙骨
function StrongPointInfoProxy:getSkeleton()
  if nil==self.quickBattleSkeleton then
    self.quickBattleSkeleton=SkeletonFactory.new();
    self.quickBattleSkeleton:parseDataFromFile("quickBattle_ui");
  end
  return self.quickBattleSkeleton;
end

-- 根据打到的最远的关卡得出来我打过的所有关卡的数据
-- {[areaID]={[storyID1]={[strongID1]=strongID1,[strongID2]=strongID2},[storyID2]={[strongID1]=strongID1,[strongID2]=strongID2}}}


-- 根据剧情图ID取得该区域图已经开启的其他剧情图的IDs
function StrongPointInfoProxy:getStoryLineDaddy(areaParam,storyLineID)
	local storyLineTable = {}
	local areaID = areaParam
	local daddyStoryLineID = storyLineID
	local returnTable = {}
	while areaID == areaParam and daddyStoryLineID and daddyStoryLineID > 0 do
	
		storyLineTable = analysis("Juqing_Juqing",daddyStoryLineID)
		areaID = storyLineTable["spaceId"]
		daddyStoryLineID = storyLineTable["condition"]
		
		local strongPointTable = analysisByName("Juqing_Guanka","storyId",daddyStoryLineID)
		local beatedStrongPointTable = {}
		for k2,v2 in pairs(strongPointTable) do
			beatedStrongPointTable[v2["id"]] = v2["id"]
		end
		if daddyStoryLineID ~= 0 then
		    returnTable[daddyStoryLineID] = beatedStrongPointTable
		end
	end
	
	returnTable[storyLineID] = self:getStongPointDaddy(storyLineID)
	
	return returnTable
end

-- 根据当前剧情图取得最远关卡的父亲们
function StrongPointInfoProxy:getStongPointDaddy(storyLineID)
	local strongPiontTable = {}
	local curentStoryLineID = storyLineID
	local daddyStrongPiontID = self.lastStrongPointId
	local returnTable = {}
	while curentStoryLineID == storyLineID and daddyStrongPiontID and daddyStrongPiontID > 0 do
		returnTable[daddyStrongPiontID] = daddyStrongPiontID
		
		strongPiontTable = analysis("Juqing_Guanka",daddyStrongPiontID)
		daddyStrongPiontID = strongPiontTable["parentId"]
		if daddyStrongPiontID ~= 0 then
		    curentStoryLineID = analysis("Juqing_Guanka",daddyStrongPiontID,"storyId")		
		end		
	end
	return returnTable
end
