

ShadowProxy=class(Proxy);

function ShadowProxy:ctor()
  self.class=ShadowProxy;
  -- self.YXZStrongPointArray = {};
  self.generalIdArray = {}
  self.newHeroStrongPointId = nil
end

rawset(ShadowProxy,"name","ShadowProxy");

--龙骨
function ShadowProxy:getSkeleton()
  if nil==self.skeleton then
	  self.skeleton = SkeletonFactory.new();
	  self.skeleton:parseDataFromFile("shadow_ui");
  end
  return self.skeleton;
end

function ShadowProxy:getCurStrongPointId(storyLineProxy)
  local luaTable = analysisTotalTableArray("Juqing_Yingxiongzhi")
  local function sortfunction(a, b)
    if a.shunxuID < b.shunxuID then
      return true
    elseif a.shunxuID > b.shunxuID then
      return false
    else
      return false;
    end
  end
  table.sort(luaTable, sortfunction )

  local returnValue = luaTable[1].id;
  for k, v in ipairs(luaTable)do
    local state = storyLineProxy:getStrongPointState(v.id);

    print("v.id, state", v.id, state)

    if state == 3 or state == 1 then
      returnValue = v.id;
    end
  end
  return returnValue;
end

function ShadowProxy:getHeroTableByShili(storyLineProxy, shiliID)
  local function sortFun(a, b)
    local shunxuA = analysis("Juqing_Yingxiongzhi", a, "shunxuID")
    local shunxuB = analysis("Juqing_Yingxiongzhi", b, "shunxuID")
    if shunxuA < shunxuB then
      return true;
    elseif shunxuA > shunxuB then
      return false;
    else
      return false;
    end
  end
  local returnValue = {};
  local tempTables1 = {};
  local tempTables2 = {};
  local yxzTable = {};

  for k, v in pairs(storyLineProxy.strongPointArray) do
    -- print("v.ID", v.ID)
    if analysisHas("Juqing_Yingxiongzhi", v.StrongPointId) and (shiliID == 0 or analysis("Juqing_Yingxiongzhi", v.StrongPointId, "shiliID") == shiliID) then
      table.insert(tempTables1, v.StrongPointId);
      yxzTable[v.StrongPointId] = v
    end
  end
  table.sort(tempTables1, sortFun)

  if shiliID == 0 then
  	for tempInd = 1, 3 do
	  local yingxiongzhis = analysisByName("Juqing_Yingxiongzhi", "shiliID", tempInd)
	  for k, v in pairs(yingxiongzhis) do
	    if not Utils:contain(tempTables1, v.id) then
	       table.insert(tempTables2, v.id);
	    end
	  end
  	end
  else
	  local yingxiongzhis = analysisByName("Juqing_Yingxiongzhi", "shiliID", shiliID)
	  for k, v in pairs(yingxiongzhis) do
	    if not Utils:contain(tempTables1, v.id) then
	       table.insert(tempTables2, v.id);
	    end
	  end
  end

  table.sort(tempTables2, sortFun)

  for k1, v1 in ipairs(tempTables1)do
    table.insert(returnValue, {ID = v1, BooleanValue = 1, Count = yxzTable[v1].Count, TotalCount = yxzTable[v1].TotalCount, StrongPointId = yxzTable[v1].StrongPointId})
  end
  for k1, v1 in ipairs(tempTables2)do
    table.insert(returnValue, {ID = v1, BooleanValue = 0, Count = 0, TotalCount = 0, StrongPointId = 0})
  end
  return returnValue;
end

function ShadowProxy:getNextHeroData(storyLineProxy, strongPointId)

  local shiliID = analysis("Juqing_Yingxiongzhi", strongPointId, "shiliID")
	local heroTable = self:getHeroTableByShili(storyLineProxy, shiliID);
	local isFind
	for k, v in ipairs(heroTable)do
		if isFind then
			return v
		end
		if v.ID == strongPointId then
			isFind = true;
		end
	end
end

function ShadowProxy:getPreHeroData(storyLineProxy, strongPointId)
  local shiliID = analysis("Juqing_Yingxiongzhi", strongPointId, "shiliID")
  local heroTable = self:getHeroTableByShili(storyLineProxy, shiliID);
  local isFind
  for k, v in ipairs(heroTable)do
    if v.ID == strongPointId then
      return heroTable[k-1];
    end
  end
end


function ShadowProxy:getNextPageData(storyLineProxy, strongPointId)
  local heroTable = self:getHeroTableByShili(storyLineProxy, 0);
  local isFind
  for k, v in ipairs(heroTable)do
    if v.ID == strongPointId then
      isFind = true;
    end
  end
end

function ShadowProxy:onRemove()

end