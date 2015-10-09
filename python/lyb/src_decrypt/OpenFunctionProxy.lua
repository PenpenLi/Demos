OpenFunctionProxy=class(Proxy);

function OpenFunctionProxy:ctor()
	print("\n\n\n\n\nfunction OpenFunctionProxy:ctor()")
  self.class=OpenFunctionProxy;
  self.openedFunctionTable = {}
  self.constEverydayTaskFunction=4;--4是日常
  --小秘12， 充值10
  self.newOpenFunctionId=0;
  self.openPanelByLoadSceneComplete=nil;
  self.closeFunctionTable = {};
end

function OpenFunctionProxy:getSkeleton()
    if nil == self.skeleton then
      self.skeleton=SkeletonFactory.new();
      self.skeleton:parseDataFromFile("functionOpen_ui");
    end
    return self.skeleton;
end


function OpenFunctionProxy:getOpenedHMenu2()

	   -- print("----------------===================")
    -- for k,v in pairs(self.openedFunctionTable) do
    --   print(k,v)
    -- end
    -- print("end ============")

   local returnValue = {};
   for i_k, i_v in pairs(self.openedFunctionTable) do
		if Utils:contain(FunctionConfig.menu_Hfunctions2, i_v) then
			-- print("functionID = ", i_v);
		   returnValue[i_v] = i_v;
		end		
	end
	for k,v in pairs(self.closeFunctionTable) do
		returnValue[v] = nil;
	end
	-- returnValue[11] = nil;
	-- returnValue[41] = nil;
	returnValue[53] = nil;
	
	return returnValue;
end

function OpenFunctionProxy:closeButton( FUNCTION_ID )
	table.remove(self.openedFunctionTable, FUNCTION_ID);
	table.remove(FunctionConfig.menu_Hfunctions2, FUNCTION_ID);
	table.insert(self.closeFunctionTable, FUNCTION_ID);
end

function OpenFunctionProxy:getOpenedLeftMenu()
   local returnValue = {};
   for i_k, i_v in pairs(self.openedFunctionTable) do
		if Utils:contain(FunctionConfig.menu_Leftfunctions, i_v) then
		   returnValue[i_v] = i_v;
		end		
	end

	return returnValue;
end


function OpenFunctionProxy:getOpenedHMenu1()
   local returnValue = {};
   for i_k, i_v in pairs(self.openedFunctionTable) do
		if Utils:contain(FunctionConfig.menu_Hfunctions1, i_v) then
		   returnValue[i_v] = i_v;
		end		
	end
	return returnValue;
end

function OpenFunctionProxy:getOpenedVMenu()
   local returnValue = {};
   for i_k, i_v in pairs(self.openedFunctionTable) do
		if Utils:contain(FunctionConfig.menu_Vfunctions, i_v)then
		   returnValue[i_v] = i_v;
		end		
	end
    
	print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@getOpenedVMenu")
	-- for k,v in pairs(returnValue) do
	-- 	print(v)
	-- end
	return returnValue;
end

-- 根据不同类型判断是否有功能开启
--因为升级一个等级可能会开启好几个功能，所以必须返回table
-- 1 升级
-- 2 开启任务
-- 3 完成任务
function OpenFunctionProxy:checkOpenFunction(openType,value)
	local returnValue = {};
	local paramName
	if openType == 1 then --级别
		paramName = "generals"
	elseif openType == 2 then -- 开启关卡
		paramName = "guanqiaid"
	elseif openType == 3 then
		paramName = "guanzhiid"
	end
	
	local functionTable = analysisByName("Gongnengkaiqi_Gongnengkaiqi",paramName,value)
	
	if next(functionTable) ~= nil then
		for i_k, i_v in pairs(functionTable) do
            local functionID = i_v.id;
			local pos = string.find(i_v.interface, "_");
			local interface
			if not pos then
               interface = tonumber(i_v.interface);
			else
               interface = i_v.interface;
			end

			if not Utils:contain(self.openedFunctionTable, functionID) then
			   self.openedFunctionTable[functionID] = functionID;
			   table.insert(returnValue, functionID);
			end		
		end
	end
	
	return returnValue;
end
-- 获得功能开启的按钮(入口)
function OpenFunctionProxy:getOpenFunctionButton(openType, value)
   local openFunctions = self:checkOpenFunction(openType, value);
   for i_k, i_v in pairs(openFunctions) do 
        local functionPo = analysis("Gongnengkaiqi_Gongnengkaiqi", i_v);--, "interface"
        local pos = string.find(functionPo.interface, "_");
        local arr
        if pos then
        	arr = StringUtils:lua_string_split(functionPo.interface, "_");
        end
        if functionPo.kaiqi ~= 0 then
			if not pos then
	           return i_v;
	        elseif arr then
	           return i_v
			end
		end
   end
   return 0;
end
-- 登录时检查功能开启了哪些
function OpenFunctionProxy:checkAllOpenFunctions(level, strongPointArray, nobility)
	
	self:checkOpenFunctionsByLevel(level)
	self:checkOpenFunctionsByNobility(nobility)
	self:checkOpenFunctionsByStrongPoint(strongPointArray)
end


function OpenFunctionProxy:checkOpenFunctionsByLevel(level)
	if level == nil then level = 1 end
	-- 该级别开的功能
	for i = 1,level do
		self:checkOpenFunction(1,i)
	end
end
function OpenFunctionProxy:checkOpenFunctionsByNobility(nobility)
	if nobility == nil then nobility = 1 end
	-- 该级别开的功能
	for i = 1,nobility do
		self:checkOpenFunction(3,i)
	end
end
function OpenFunctionProxy:checkOpenFunctionsByStrongPoint(strongPointArray)
	for k, v in pairs(strongPointArray) do
		if v.State == 1 then
		  self:checkOpenFunction(2,v.StrongPointId)
		end
	end
end

-- 判断某功能是否开启
function OpenFunctionProxy:checkIsOpenFunction(functionID)

	for k,v in pairs(self.openedFunctionTable) do
		-- print("v",v,functionID)
		if functionID == v then
			return true
		end
	end
	
	return false
end
-- 判断某tab是否开启，tabID是1_1,1_2
-- function OpenFunctionProxy:checkIsOpenTab(tabID)


-- end
rawset(OpenFunctionProxy,"name","OpenFunctionProxy");

function OpenFunctionProxy:getOpenPanelByLoadSceneComplete()
	local id=self.openPanelByLoadSceneComplete;
	self.openPanelByLoadSceneComplete=nil;
	return id;
end

function OpenFunctionProxy:setOpenPanelByLoadSceneComplete(id)
	self.openPanelByLoadSceneComplete=id;
end