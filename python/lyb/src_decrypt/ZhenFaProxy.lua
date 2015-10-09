
ZhenFaProxy=class(Proxy);

function ZhenFaProxy:ctor()
  self.class=ZhenFaProxy;
  
end

rawset(ZhenFaProxy,"name","ZhenFaProxy");

--龙骨
function ZhenFaProxy:getSkeleton()
  if nil==self.skeleton then
	  self.skeleton = SkeletonFactory.new();
	  self.skeleton:parseDataFromFile("zhenfa_ui");
  end
  return self.skeleton;
end

function ZhenFaProxy:setData(formationArray)
  self.formationArray = formationArray;
end

function ZhenFaProxy:getData()
  return self.formationArray;
end

function ZhenFaProxy:getLevelByID(id)
	for k,v in pairs(self.formationArray) do
		if id == v.ID then
			return v.Level;
		end
	end
end
function ZhenFaProxy:refreshData(id,level)
	local hasdata = false
	for k,v in pairs(self.formationArray) do
		if v.ID == id  then
			v.Level = level
			hasdata = true
			break;
		end
	end

	if not hasdata then
		local dataTable = {}
		dataTable["ID"] = id
		dataTable["Level"] = level
		table.insert(self.formationArray,dataTable)
	end

end

-- 检查该阵法够不够升级条件 红点
function ZhenFaProxy:checkCanUpdate(id,bagProxy,userCurrencyProxy)
	if not self.formationArray then return false end;


	local id = id 
	local level = 1
	for k,v in pairs(self.formationArray) do
		if v.ID == id then
			level = v.Level + 1
		end
	end

	local itemStr,sliverStr = "",""
	local idTable = analysisByName("Zhenfa_Zhenfashengji","formId",id);
	for k,v in pairs(idTable) do
		if v.level == level then
		   itemStr,sliverStr = v.cost,v.money
		end
	end

	local itemCan,moneyCan = false,false
	local itemTable = StringUtils:lua_string_split(itemStr, ';');
	local sliverTable = StringUtils:lua_string_split(sliverStr, ';');

	for k,v in pairs(itemTable) do
		local itemTable1 = StringUtils:lua_string_split(v, ',');
		local itemCount = bagProxy:getItemNum(itemTable1[1])
		if itemCount >= tonumber(itemTable1[2]) then
			itemCan = true
		end
	end
	for k,v in pairs(sliverTable) do
		local itemTable1 = StringUtils:lua_string_split(v, ',');
		local silverCount = userCurrencyProxy:getMoneyByItemID(tonumber(itemTable1[1]))
		if silverCount >= tonumber(itemTable1[2]) then
			moneyCan = true
		end
	end	

	return itemCan and moneyCan

end