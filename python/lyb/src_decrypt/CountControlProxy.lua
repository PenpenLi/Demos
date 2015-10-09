--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-22

	yanchuan.xie@happyelements.com
]]

CountControlProxy=class(Proxy);

function CountControlProxy:ctor()
  self.class=CountControlProxy;
  self.data=nil;
end

rawset(CountControlProxy,"name","CountControlProxy");

function CountControlProxy:refresh(userCountControlArray)
  if nil==self.data then
    self.data=userCountControlArray;
    return;
  end
  for k,v in pairs(userCountControlArray) do
    self:refreshItem(v);
  end
end

function CountControlProxy:refreshItem(userCountControl)
  for k,v in pairs(self.data) do
    if userCountControl.ID==v.ID then
      for k_,v_ in pairs(v) do
        v[k_]=userCountControl[k_];
      end
      return;
    end
  end
  table.insert(self.data,userCountControl);

end

-- 取得使用过的次数
function CountControlProxy:getCurrentCountByID(countType,param)
    if nil==self.data then
		return 0,0;
	end

	if not param then
		param = 0
	end
  
	local idTable = analysisByName("Cishukongzhi_Cishukongzhi","type",countType)
	local id
	for kID,vID in pairs(idTable) do
		if vID.parameter == param then
			id = vID.id
		end
	end
  
	if not id then
		return 0,0
	end
	
	for k,v in pairs(self.data) do
		if id==v.ID then
			return v.CurrentCount,v.TotalCount
		end
	end
	return 0,0;
end

function CountControlProxy:getJibencishu(countType, param)
	if nil==self.data then
		return 0;
	end

	if not param then
		param = 0
	end
  
	local idTable = analysisByName("Cishukongzhi_Cishukongzhi","type",countType)
	for kID,vID in pairs(idTable) do
		if vID.parameter == param then
			return vID.jibencishu;
		end
	end
	return 0;
end

function CountControlProxy:getItemAddLimitCountByID(id)
  if nil==self.data then
    return 0;
  end
  for k,v in pairs(self.data) do
    if id==v.ID then
      return v.AddCount;
    end
  end
  return 0;
end

-- 取得剩余次数
function CountControlProxy:getRemainCountByID(countType,param)
	if nil==self.data then
		return 0,0;
	end

	if not param then
		param = 0
	end
  
	local idTable = analysisByName("Cishukongzhi_Cishukongzhi","type",countType)
	local id
	for kID,vID in pairs(idTable) do
		if vID.parameter == param then
			id = vID.id
		end
	end
  
	if not id then
		return 0,0;
	end
	
	for k,v in pairs(self.data) do
		if id==v.ID then
			local remainCount = v.TotalCount - v.CurrentCount --+ v.ItemAddLimitCount;
			if remainCount < 0 then
				remainCount = 0
			end
			return remainCount,v.TotalCount
		end
	end
	return 0,0;
end

-- 取得剩余可增加的次数
function CountControlProxy:getRemainLimitedCountByID(countType,param)
	if nil==self.data then
		return 0;
	end
  
	if not param then
		param = 0
	end
  
	local idTable = analysisByName("Cishukongzhi_Cishukongzhi","type",countType)
	local id
	for kID,vID in pairs(idTable) do
		if vID.parameter == param then
			id = vID.id
		end
	end
  
	if not id then
		return 0
	end
	
	for k,v in pairs(self.data) do
		if id==v.ID then
			local remainCount = v.MaxAddCount - v.AddCount;
			if remainCount < 0 then
				remainCount = 0
			end
			return remainCount
		end
	end
	return 0;
end
--获得增加次数需要的元宝
function CountControlProxy:getAddCountNeedGold(countType,param,force)
 if nil==self.data then
		return 0;
	end

	if not param then
		param = 0
	end
  
	local idTable = analysisByName("Cishukongzhi_Cishukongzhi","type",countType)
	local id
	local cishuPO
	for kID,vID in pairs(idTable) do
		if vID.parameter == param then
			id = vID.id;
			cishuPO = vID;
		end
	end
  
	if not id then
		return 0
	end
	
	for k,v in pairs(self.data) do
		if id==v.ID then
			if not force and cishuPO.jibencishu > v.CurrentCount then
				return 0
			end
			local needGoldTable = StringUtils:lua_string_split(v.BuyCountNeedGold, ",");
		    local needGold = needGoldTable[v.AddCount + 1]
			return tonumber(needGold);
		end
	end
	return 0;
end

function CountControlProxy:getRemainCountByFunctionID(functionID, everydayTaskProxy, generalListProxy, taskProxy, userCurrencyProxy)
	if FunctionConfig.FUNCTION_ID_66==functionID then
		return self:getRemainCountByID(CountControlConfig.JueZhanDianFeng);
	elseif FunctionConfig.FUNCTION_ID_72==functionID then
		return self:getRemainCountByID(CountControlConfig.WanYaoJu);
	elseif FunctionConfig.FUNCTION_ID_75==functionID then
		if nil==taskProxy:getEverydayTaskData() then
			return 0;
		else
			return 11-everydayTaskProxy:getCount();
		end
	elseif FunctionConfig.FUNCTION_ID_71==functionID then
		return self:getRemainCountByID(CountControlConfig.eighteenCopper);
	elseif FunctionConfig.FUNCTION_ID_65==functionID then
		return self:getRemainCountByID(CountControlConfig.YongChuangTianGuan);
	elseif FunctionConfig.FUNCTION_ID_74==functionID then
		local a=0;
		local tili=userCurrencyProxy:getTili();
		if 20<=generalListProxy:getLevel() then
			a=self:getRemainCountByID(CountControlConfig.Shadow,1)+a;
		end
		if 30<=generalListProxy:getLevel() then
			a=self:getRemainCountByID(CountControlConfig.Shadow,2)+a;
		end
		if 40<=generalListProxy:getLevel() then
			a=self:getRemainCountByID(CountControlConfig.Shadow,3)+a;
		end
		if 50<=generalListProxy:getLevel() then
			a=self:getRemainCountByID(CountControlConfig.Shadow,4)+a;
		end
		if 60<=generalListProxy:getLevel() then
			a=self:getRemainCountByID(CountControlConfig.Shadow,5)+a;
		end
		if 70<=generalListProxy:getLevel() then
			a=self:getRemainCountByID(CountControlConfig.Shadow,6)+a;
		end
		if 35<=generalListProxy:getLevel() then
			a=math.min(self:getRemainCountByID(CountControlConfig.Shadow,7),math.floor(tili/10))+a;
		end
		if 25<=generalListProxy:getLevel() then
			a=math.min(self:getRemainCountByID(CountControlConfig.Shadow,8),math.floor(tili/10))+a;
		end
		return a;
	end
	return 0;
end

function CountControlProxy:getTotalCount(openFunctionProxy, everydayTaskProxy, generalListProxy, taskProxy, userCurrencyProxy)
	local a=0;
	if openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_66) then
		a=self:getRemainCountByFunctionID(FunctionConfig.FUNCTION_ID_66,everydayTaskProxy,generalListProxy,taskProxy,userCurrencyProxy)+a;
	end
	if openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_72) then
		a=self:getRemainCountByFunctionID(FunctionConfig.FUNCTION_ID_72,everydayTaskProxy,generalListProxy,taskProxy,userCurrencyProxy)+a;
	end
	if openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_75) then
		a=self:getRemainCountByFunctionID(FunctionConfig.FUNCTION_ID_75,everydayTaskProxy,generalListProxy,taskProxy,userCurrencyProxy)+a;
	end
	if openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_71) then
		a=self:getRemainCountByFunctionID(FunctionConfig.FUNCTION_ID_71,everydayTaskProxy,generalListProxy,taskProxy,userCurrencyProxy)+a;
	end
	if openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_65) then
		a=self:getRemainCountByFunctionID(FunctionConfig.FUNCTION_ID_65,everydayTaskProxy,generalListProxy,taskProxy,userCurrencyProxy)+a;
	end
	if openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_74) then
		a=self:getRemainCountByFunctionID(FunctionConfig.FUNCTION_ID_74,everydayTaskProxy,generalListProxy,taskProxy,userCurrencyProxy)+a;
	end
	return a;
end