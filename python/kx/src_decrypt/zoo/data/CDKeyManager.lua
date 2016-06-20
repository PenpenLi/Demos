
CDKeyManager = class()
local _instance

ExchangeCodeInfo = class()
function ExchangeCodeInfo:ctor( data )
	-- body
	data = data or {}
	self.phone = data.phone or nil
	self.address = data.address or nil
	self.name = data.name or nil
end

function ExchangeCodeInfo:isInfoFull( )
	-- body
	if self.address and self.phone and self.name then
		return true
	else
		return false
	end 
end

ActualExchangeCode = class()
function ActualExchangeCode:ctor( data )
	-- body
	self.exchangeCode = data.exchangeCode or nil
	self.startTime = data.startTime and data.startTime / 1000 or nil
	self.endTime = data.startTime and data.endTime / 1000 or nil
	self.rewards = data.rewards or nil
	self.type = data.type or nil
	self.materialDesc = data.materialDesc or nil
end

function ActualExchangeCode:getMaterialDesc( ... )
	-- body
	return self.materialDesc or nil
end
---------------------
--eg. 2015年11月11日
---------------------
function ActualExchangeCode:getEndTimeString( ... )
	-- body
	if not self.endTime then return nil end
	local t = os.date("*t", tonumber(self.endTime))
	local dataString = 
		tostring(t.year).."年"..
		tostring(t.month).."月"..
		tostring(t.day).."日"
	return dataString
end



function CDKeyManager:getInstance( ... )
	-- body
	if not _instance then
		_instance = CDKeyManager.new()
		_instance:init()
	end
	return _instance
end

function CDKeyManager:init( ... )
	-- body
	self.actualExchangeCodes = {}
end

function CDKeyManager:initData( contact, actualExchangeCodes)
	-- body

	--test
	-- actualExchangeCodes = {
	-- 	{materialDesc = "小黄鸡",endTime = "1420045261"},
	-- 	{materialDesc = "小绿鸡",endTime = "1420048861"},
	-- 	{materialDesc = "小紫鸡",endTime = "1422727261"},
	-- }
	-- contact = {phone = "13426016917", name = "lyh", address = "北京海淀区苏州街维亚大厦20F"}
	actualExchangeCodes = actualExchangeCodes or {}
	self.actualExchangeCodes = {}
	self.exchangeCodeInfo = ExchangeCodeInfo.new(contact)

	for k, v in pairs(actualExchangeCodes) do 
		local item = ActualExchangeCode.new(v)
		table.insert(self.actualExchangeCodes, item)
	end
end

function CDKeyManager:updateExchangeCodeInfo( data )
	-- body
	self.exchangeCodeInfo.phone = data.phone
	self.exchangeCodeInfo.name = data.name
	self.exchangeCodeInfo.address = data.address
end

function CDKeyManager:getExchangeInfoByIndex( index )
	-- body
	if index == 1 then
		return self.exchangeCodeInfo.name
	elseif index == 2 then 
		return self.exchangeCodeInfo.phone
	elseif index == 3 then 
		return self.exchangeCodeInfo.address
	else
		return nil
	end

end

function CDKeyManager:hasReward( ... )
	-- body
	if self.actualExchangeCodes and type(self.actualExchangeCodes) == "table" and 
		#self.actualExchangeCodes > 0 then
		return true
	end

	return false 
end

function CDKeyManager:showRewardInfoPanel( ... )
	-- body
	local s = CDkeyRewardPanel:create()
	s:popout()
	return s
end

function CDKeyManager:showCollectInfoPanel( acExchangeCodeInfo, closeCallback )
	-- body
	local item = nil
	if acExchangeCodeInfo then 
		item = ActualExchangeCode.new(acExchangeCodeInfo)
		table.insert(self.actualExchangeCodes, item)
	end
	local s = CollectInfoPanel:create(item, closeCallback)
	s:popout()
	return s
end

function CDKeyManager:isInfoFull( ... )
	-- body
	if self.exchangeCodeInfo and self.exchangeCodeInfo:isInfoFull() then
		return true
	end

	return false
end

function CDKeyManager:getAllRewards( ... )
	-- body
	-- return {
	-- 	{itemId = 1, itemName = "dd", itemLimit = 123},
	-- 	{itemId = 1, itemName = "ff", itemLimit = 123},
	-- 	{itemId = 1, itemName = "ee", itemLimit = 123},
	-- 	{itemId = 1, itemName = "gg", itemLimit = 123},
	-- }
	return self.actualExchangeCodes
end

function CDKeyManager:showDotTipStatus( ... )
	-- body
	if self:hasReward() and not self:isInfoFull() then
		return true
	end

	return false
end

