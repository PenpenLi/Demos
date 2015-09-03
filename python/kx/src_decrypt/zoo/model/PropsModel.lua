require "zoo.model.PropItemData"

PropsModel = class(EventDispatcher)

function PropsModel:ctor()
end

local __instance = nil

function PropsModel:instance()
	if not __instance then
		__instance = PropsModel.new()
	end

	return __instance
end

kSpringPropItemID = 9999

local kAddStepItems = {10004}
local kMaxItemIdAvailable = 10064
local kPreUsedPropItems = {10018, 10015, 10019}
local kTempPropMapping = {}
kTempPropMapping["10025"] = 10001
kTempPropMapping["10015"] = 10001
kTempPropMapping["10016"] = 10002
kTempPropMapping["10028"] = 10003
kTempPropMapping["10017"] = 10003
kTempPropMapping["10027"] = 10005
kTempPropMapping["10019"] = 10005
kTempPropMapping["10026"] = 10010
kTempPropMapping["10024"] = 10010
kTempPropMapping["10018"] = 10004
kTempPropMapping["10053"] = 10052
kTempPropMapping["10057"] = 10056

PropsModel.kTempPropMapping = kTempPropMapping

local function isAddStepItem( item )
	local itemId = item.itemId
	for j, k in ipairs(kAddStepItems) do
		if k == itemId then return true end
	end


	return false
end

local function isValidItem( item )
	if item.itemId == kSpringPropItemID then return true end
	local itemId = item.itemId
	if itemId > kMaxItemIdAvailable then return false end

	for i,v in ipairs(kPreUsedPropItems) do
		if v == itemId then return false end
	end
	return true
end

function PropsModel:init(levelId, selectedItemsData, hasOctopus)
	self:_createPropsInGame(levelId, selectedItemsData, hasOctopus)
	self:_separateProps()
end

function PropsModel:_createPropsInGame(levelId, selectedItemsData, hasOctopus)
	local addToBarProps		= {}
	local notAddToBarPros		= {}
	self.addToBarProps 	= addToBarProps
	self.notAddToBarPros	= notAddToBarPros

	for k,v in ipairs(selectedItemsData) do
		local tmpItem = PropItemData:create(tonumber(v.id))

		if PublishActUtil:isGroundPublish() then 
			if v.id==10007 then
				tmpItem.itemNum	= 1 
			else
				tmpItem.itemNum	= PublishActUtil:getTempPropNum()
			end
		else
			tmpItem.itemNum		= 1
		end
		tmpItem.temporary	= 1
		
		local preGamePropType = ItemType:getPrePropType(tonumber(v.id))

		if PrePropType.ADD_TO_BAR == preGamePropType then
			table.insert(addToBarProps, tmpItem)

		elseif PrePropType.ADD_STEP == preGamePropType or
			PrePropType.REDUCE_TARGET == preGamePropType or
			PrePropType.TAKE_EFFECT_IN_BOARD == preGamePropType then

			table.insert(notAddToBarPros, tmpItem)
		end
	end
	-- ---------------
	-- In Game Props
	-- ---------------
	local levelModeTypeId 	= MetaModel:sharedInstance():getLevelModeTypeId(levelId)
	if LevelType:isSummerMatchLevel( levelId ) then
		levelModeTypeId = GameModeTypeId.SUMMER_WEEKLY
	end
	
	local inGameProp = {}
	
	-- 做一份拷贝
	for k, v in pairs(MetaManager.getInstance().gamemode_prop[levelModeTypeId].ingameProps) do
		inGameProp[k] = v
	end

	-- 如果有章鱼就加入章鱼冰道具
	if hasOctopus and levelId > 181 then
		table.insert(inGameProp, GamePropsType.kOctopusForbid)
	end

	for k,v in ipairs(inGameProp) do
		local itemId = tonumber(v)
		if not ItemType:isTimeProp(itemId) then
			local inGameItem = PropItemData:create(itemId)
			inGameItem.itemNum	= UserManager.getInstance():getUserPropNumber(itemId)
			inGameItem.temporary	= 0
			table.insert(addToBarProps, inGameItem)
		end
	end

	-- timeProps
	local timeProps = UserManager:getInstance():getAndUpdateTimeProps()
	if #timeProps > 0 then
		for _,v in pairs(timeProps) do
			if table.exist(inGameProp, v.itemId) then
				local expireItem = PropItemData:create(v.itemId)
				expireItem.realItemId = ItemType:getRealIdByTimePropId( v.itemId )
				expireItem.itemNum = v.num 
				expireItem.expireTime = v.expireTime
				expireItem.temporary = 0
				expireItem.isTimeProp = true
				table.insert(addToBarProps, expireItem)
			end
		end
	end
	local levelMeta = LevelMapManager.getInstance():getMeta(levelId)
	self.levelModeType = levelMeta.gameData.gameModeName

	-- 春节爆竹必须要在第三个
	if self.levelModeType == 'MaydayEndless' then
		local springItem = PropItemData:create(kSpringPropItemID)
		springItem.itemNum = 0
		springItem.temporary = 0
		table.insert(addToBarProps, 3, springItem)
	end
end

function PropsModel:_separateProps()
	
	self.propItems = {}
	self.addStepItems = {}
	self.temporaryPops = {}
	self.timeProps = {}

	  --there is no temporary prop at the beginning of a round
	if self.addToBarProps and #self.addToBarProps > 0 then
	    for i, v in ipairs(self.addToBarProps) do
	    	if v.temporary == 1 then
	        	table.insert(self.temporaryPops, v)
	      	elseif v.isTimeProp then
	        	table.insert(self.timeProps, v)
	      	else 
	        	if isValidItem(v) then
	          		if isAddStepItem(v) then
	          			table.insert(self.addStepItems, v)
	          		else 
	          			table.insert(self.propItems, v) 
	          		end
	        	else 
	        		print("item not supported or already uses as pre-prop, id:"..v.itemId) 
	        	end
	      	end
	    end
	end
end

function PropsModel:getTimePropsByItemId(itemId)
	local ret = {}
	if self.timeProps and #self.timeProps > 0 then
		for _,v in pairs(self.timeProps) do
		  	if v.realItemId == itemId then
		  		table.insert(ret, v)
			end
		end
	end

	return ret
end

function PropsModel:findItemIndex( item )
	for i,v in ipairs(self.propItems) do
		if v == item then return i end
	end

	return -1
end

function PropsModel:removeItem( removedItem )
	local removedIndex = self:findItemIndex(removedItem.prop)
	if removedIndex > 0 then 
		table.remove(self.propItems, removedIndex) 
	end
end

function PropsModel:addItem(item)
	table.insert(self.propItems, item)
end

function PropsModel:addTimeProp(propId, num, expireTime)
	local expireItem = PropItemData:create(propId)
	expireItem.realItemId = ItemType:getRealIdByTimePropId( propId )
	expireItem.itemNum = num 
	expireItem.expireTime = expireTime
	expireItem.temporary = 0
	expireItem.isTimeProp = true
	
	table.insert(self.timeProps, expireItem)
end

function PropsModel:addStepItemExist()
	return	self.addStepItems and #self.addStepItems > 0
end

function PropsModel:temporaryPopsExist()
	return self.temporaryPops and #self.temporaryPops > 0 
end

function PropsModel:clearTemporaryPops()
	self.temporaryPops = nil
end
