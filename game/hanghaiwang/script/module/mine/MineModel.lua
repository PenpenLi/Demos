-- FileName: MineModel.lua
-- Author: zhangqi
-- Date: 2015-04-10
-- Purpose: 资源矿数据模块，包括配置信息读取处理以及其他数据的准备和读取方法
--[[TODO List]]

module("MineModel", package.seeall)

require "db/DB_Res"
require "db/DB_Normal_config"

local DB_Res 		= DB_Res
local DB_Normal_config	= DB_Normal_config

------- MSG -------
_MSG_ = {
	CB_GET_DOMAIN_INFO 	= "CB_GETDOMAIN_INFO",
	CB_GET_SELFPITS 	= "CB_GET_SELFPITS",
	CB_EXPLORE			= "CB_EXPLORE",
	CB_BROADCAST		= "CB_BROADCAST",
	CB_GETREWARD		= "CB_GETREWARD",
	CB_RECREWARD		= "CB_RECREWARD",
	CB_PUSH_REWARD		= "CB_PUSH_REWARD",
	CB_PUSH_MAIL_TIP	= "CB_PUSH_MAIL_TIP",
	CB_REFRESH_TIP		= "CB_REFRESH_TIP",
	CB_SWITCH_AREA		= "CB_SWITCH_AREA",
}
------- MSG -------

AREA_NORMAL = 2 	--普通区域
AREA_HIGH 	= 1 	--高级区域
AREA_GOLD 	= 3 	--金币区域

------------------------- 属性 -------------------------
local _nCurPage = 1 			-- 当前页码
local _nCurArea = AREA_NORMAL	-- 当前区域
local _tbDBMineInfo	= {}		-- 矿坑信息 保存当前大区域DB信息
local _tbDBExploreInfo = {}		-- 不同区域的不同探索类型
local _tbDBPitInfo	= {}		-- 矿坑的信息 key{类型} value{类型nType 图片strImg 描述strDes}

local _tbOccupyInfo = {}	-- 占领信息 保存当前页面的占领信息
local _tbSelfInfo	= {		-- 个人信息 
	tNormal 	= {},		-- 普通矿
	tGold 		= {},		-- 金矿
	tHelp		= {},		-- 协助
}
local _tbExploreInfo = {}	-- 一键找矿信息
local _tbBroardcast	 = {}	-- 广播队列
local _tbGainInfo	 = {	-- 奖励信息
	nSilver		= 0,		-- 贝里
}

local _tbSwitchs	= {			-- 一堆的开关
	isReloadInfoView = false,	-- 是否刷新信息界面
	isCheckMine		 = 0,		-- 是否打开对应矿坑的窗口
	isPause			 = false,	-- 是否暂停主页面的刷新
}

function setPage( page )
	_nCurPage = page
end

function getPage( ... )
	return _nCurPage
end

function setArea( area )
	_nCurArea = area
end

function getArea( ... )
	return _nCurArea
end

function setDBMineInfo( info )
	_tbDBMineInfo = info
end

function getDBMineInfo( ... )
	return _tbDBMineInfo
end

function getDBExploreInfo( ... )
	return _tbDBExploreInfo
end

function setOccupyInfo( info )
	_tbOccupyInfo = info
end

function getOccupyInfo( ... )
	return _tbOccupyInfo
end
-- type: 1-普通矿信息 2-金币矿信息 3-协助矿信息
function setSelfInfo( info, type )
	if (tonumber(type) == 1) then
		_tbSelfInfo.tNormal = info
	elseif (tonumber(type) == 2) then
		_tbSelfInfo.tGold = info
	elseif (tonumber(type) == 3) then
		_tbSelfInfo.tHelp = info
	end

	if (type == nil) then
		_tbSelfInfo = info
	end
end

function getSelfInfo( type )
	return _tbSelfInfo
end

function getSelfInfo_Normal( ... )
	return _tbSelfInfo.tNormal
end

function getSelfInfo_Gold( ... )
	return _tbSelfInfo.tGold
end

function getSelfInfo_Help( ... )
	return _tbSelfInfo.tHelp
end

function setExploreInfo( info )
	_tbExploreInfo = info
end

function getExploreInfo( ... )
	return _tbExploreInfo
end

function setBroardcast( info )
	_tbBroardcast = info
end

function getBroardcast(  )
	return _tbBroardcast
end

function setGainInfo( info )
	_tbGainInfo = info
end

function getGainInfo( ... )
	return _tbGainInfo
end

function setSwitch( info )
	_tbSwitchs = info
end

function getSwitch( ... )
	return _tbSwitchs
end

-- 获取自己协助的开始时间点
function getSelfGuardStartTime(  )
	local tGuard = getSelfInfo_Help().arrGuard
	for i, tGuarder in ipairs(tGuard or {}) do
		if tonumber(tGuarder.uid) == tonumber(UserModel.getUserUid()) then
			return tGuarder.guard_time
		end
	end
end

-- 获取所有占领信息 本页和自己的
function getAllOccupyInfo( ... )
	local data = {}
	table.hcopy(_tbOccupyInfo, data)
	table.insert(data, _tbSelfInfo.tNormal)
	table.insert(data, _tbSelfInfo.tGold)
	table.insert(data, _tbSelfInfo.tHelp)
	return data
end

function getCurDomainId( ... )
	assert(getDBMineInfo())

	return getDBMineInfo()[getPage()].id
end

------------------------- 整理DB数据 -------------------------
-- 获取区域的探索类型
function handleExploreDatas()
	_tbDBExploreInfo = {}
	local dbNormalConfig = DB_Normal_config.getDataById(1)
	-- "1|2|3,2|3|4,3|4|5"
	local types = dbNormalConfig.res_type
	local datas = lua_string_split(types, ",")
	for k, str in pairs(datas) do
		local data = lua_string_split(str, "|")
		_tbDBExploreInfo[tonumber(k)] = data
	end
end

-- 获取矿坑类型信息
function handlePitTypeInfo( ... )
	_tbDBPitInfo = {}
	local db_res = DB_Res
	for k, info in pairs(db_res.Res) do
		local data = db_res.getDataById(info[1])
		for i = 1, 5 do
			local type = tonumber(data["res_type"..i])
			if (_tbDBPitInfo[type] == nil) then
				local info = {}
				info.nType = type
				info.strImg = data["res_icon"..i]
				info.strDes = data["res_name"..i]
				_tbDBPitInfo[type] = info
			end
		end
	end
	
end

-- 处理当前大区域的数据
function handleDatas( area )
	local tb = {}
	for k, info in pairs(DB_Res.Res) do
		local data = DB_Res.getDataById(info[1])
		if (area == data.type) then	-- 指定区域
			table.insert(tb, data)
		end
	end
	-- 按照id升序
	table.sort(tb, function ( data1, data2 )
		return data1.id < data2.id
	end)

	setDBMineInfo(tb)
end

------------------------- 方法 -------------------------
-- 更新矿坑信息并刷新
function updateMine( data )
	if (table.isEmpty(data)) then
		return
	end
	if (_tbSwitchs.isPause) then
		logger:debug("MINEVIEW PAUSE!")
		return
	end
	logger:debug(data)
	logger:debug(getOccupyInfo())
	local isReloadMine = false 	-- 是否刷新标记
	local isReloadSelf = false 	-- 是否刷新标记
	local domainId = tonumber(data.domain_id)
	local pit_id = tonumber(data.pit_id)
	local area = convertDomainToArea(domainId)
	local page = convertDomainToPage(domainId)
	local uid = tonumber(UserModel.getUserUid())
	-- 矿主不存在，为[放弃矿]
	local isGiveUp = (data.uid == nil)
	------------- 刷新占领信息 -------------
	if (area == getArea() and page == getPage()) then
		isReloadMine = true
		if (isGiveUp) then
			-- 删除占领信息
			local tb = {}
			for k,v in pairs(_tbOccupyInfo or {}) do
				if (k ~= pit_id) then
					tb[k] = v
				end
			end
			_tbOccupyInfo = tb
		else
			_tbOccupyInfo[pit_id] = data
		end
	end

	------------- 刷新个人信息 -------------
	function _fClearSelfInfo( _data )
		if (table.isEmpty(_data)) then
			return {}
		end
		if (tonumber(_data.domain_id) == domainId and 
			tonumber(_data.pit_id) == pit_id) then
			return {}
		end
		return _data
	end
	if (isGiveUp) then
		isReloadSelf = true
		if (area ~= AREA_GOLD) then
			_tbSelfInfo.tNormal = _fClearSelfInfo(_tbSelfInfo.tNormal)	-- 自己的普通矿
		else
			_tbSelfInfo.tGold = _fClearSelfInfo(_tbSelfInfo.tGold)		-- 自己的金矿
		end
		_tbSelfInfo.tHelp = _fClearSelfInfo(_tbSelfInfo.tHelp)			-- 自己帮忙的矿
	else
		-- [矿主是自己] 刷新个人信息显示
		if (tonumber(data.uid) == uid) then
			isReloadSelf = true
			if (area ~= AREA_GOLD) then
				_tbSelfInfo.tNormal = data
			else
				_tbSelfInfo.tGold = data
			end	
		else
			-- 拥有的矿的*矿主不是自己* 则[被人抢夺了] 清空数据
			if (table.isEmpty(_tbSelfInfo.tNormal) == false and 
				tonumber(_tbSelfInfo.tNormal.domain_id) == domainId and tonumber(_tbSelfInfo.tNormal.pit_id) == pit_id) then
				isReloadSelf = true
				_tbSelfInfo.tNormal = _fClearSelfInfo(_tbSelfInfo.tNormal)
			end
			if (table.isEmpty(_tbSelfInfo.tGold) == false and 
				tonumber(_tbSelfInfo.tGold.domain_id) == domainId and tonumber(_tbSelfInfo.tGold.pit_id) == pit_id) then
				isReloadSelf = true
				_tbSelfInfo.tGold = _fClearSelfInfo(_tbSelfInfo.tGold)
			end

			-- [是协助军]
			if (isHelperWithGuard(data.arrGuard, uid)) then
				isReloadSelf = true
				_tbSelfInfo.tHelp = data
			-- 不是协助军，但是自己的协助数据与指定的数据相同，则[放弃协助军]
			elseif (table.isEmpty(_tbSelfInfo.tHelp) == false and tonumber(_tbSelfInfo.tHelp.domain_id) == domainId and tonumber(_tbSelfInfo.tHelp.pit_id) == pit_id) then
				isReloadSelf = true
				_tbSelfInfo.tHelp = {}
			end
		end
	end	

	logger:debug(getOccupyInfo())
	logger:debug(getSelfInfo())
	------------- 刷新界面 -------------
	if (isReloadMine) then
		GlobalNotify.postNotify(_MSG_.CB_GET_DOMAIN_INFO)	-- 发送通知，放置直接调用已销毁的界面
	end

	if (isReloadSelf) then
		GlobalNotify.postNotify(_MSG_.CB_GET_SELFPITS)		-- 发送通知，放置直接调用已销毁的界面
	end
end

--
function convertDomainToArea( domainId )
	if (tonumber(domainId) < 50000) then
		return AREA_NORMAL
	elseif (tonumber(domainId) < 60000) then
		return AREA_HIGH
	else
		return AREA_GOLD
	end
end

--
function convertDomainToPage( domainId )
	return domainId % 10000
end

-- 获取指定矿区id的信息
function getMineDBInfoWithDomainId( domainId )
	local info = {}
	for k, v in pairs(DB_Res.Res) do
		local rdata = DB_Res.getDataById(v[1])
		if (tonumber(rdata.id) == tonumber(domainId)) then	-- 指定区域
			info = rdata
			break
		end
	end
	return info
end

-- 指定uid是否在指定协助军队伍中
function isHelperWithGuard( arrGuard, uid )
	for k,v in pairs(arrGuard or {}) do
		if (tonumber(v.uid) == tonumber(uid)) then
			return true
		end
	end
	return false
end

-- 指定uid是否是指定坑的协助军
function isHelperWithPit( domainId, pitId, uid )
	if (_tbSelfInfo.tHelp == nil or table.isEmpty(_tbSelfInfo.tHelp)) then
		return false
	end
	logger:debug(_tbSelfInfo)
	if (tonumber(_tbSelfInfo.tHelp.domain_id) == tonumber(domainId) and tonumber(_tbSelfInfo.tHelp.pit_id) == tonumber(pitId)) then
		return isHelperWithGuard(_tbSelfInfo.tHelp.arrGuard, uid)
	end
	
	return false
end

function getHelperInfo( arrGuard, uid )
	for k,v in pairs(arrGuard or {}) do
		if (tonumber(v.uid) == tonumber(uid)) then
			return v
		end
	end
	return nil
end

-- 当前页面矿坑状态
function getMineState( domainId, pitId, area )
	-- 
	local data = getAllOccupyInfo() or {}

	for k, v in pairs(data) do
		if (tonumber(v.domain_id) == tonumber(domainId) and tonumber(v.pit_id) == tonumber(pitId)) then
			if (tonumber(v.uid) == UserModel.getUserUid()) then
				if (area ~= AREA_GOLD) then
					return MineConst.MineInfoType.MINE_SELF 		-- 自己的普通矿
				else
					return MineConst.MineInfoType.MINE_SELF_GOLD	-- 自己的金矿
				end
			else
				if (isHelperWithPit(domainId, pitId, UserModel.getUserUid())) then
					return MineConst.MineInfoType.MINE_SELF_GOURD	-- 自己协助的矿
				elseif (area ~= AREA_GOLD) then
					return MineConst.MineInfoType.MINE_OTHER 		-- 他人的普通矿
				else
					return MineConst.MineInfoType.MINE_OTHER_GOLD	-- 他人的金矿
				end
			end
		end
	end

	return convertDomainToArea(domainId) ~= AREA_GOLD and MineConst.MineInfoType.MINE_NONE or MineConst.MineInfoType.MINE_NONE_GOLD -- 空矿还是空金矿
end

-- 获取矿山图片
-- type：类型
-- isSmall：是否小图
-- percent：矿的进度百分比
function getMineImg( type, isSmall, percent )
	local _type = tonumber(type)
	if (_tbDBPitInfo[_type] ~= nil) then
		if (isSmall) then
			if (percent < 30) then
				return "images/resource/small_res/res_empty.png"
			end
			local index = 1
			if (percent >= 30 and percent < 60) then
				index = 1
			elseif (percent >= 60 and percent < 90) then
				index = 2
			elseif (percent >= 90) then
				index = 3
			end
			return string.format("images/resource/small_res/res_%d_%d.png", _type, index)
		else
			return "images/resource/normal_res/".._tbDBPitInfo[_type].strImg
		end
	end
end

-- 拼接广播串
function getBroardcastContent( data )
	local newUser = data.now_capture	-- 新矿主
	local oldUser = data.pre_capture	-- 原矿主
	local area = convertDomainToArea(tostring(data.domain_id))	-- 区域
	local page = convertDomainToPage(tostring(data.domain_id))	-- 号
	local dbinfo = getMineDBInfoWithDomainId(data.domain_id)
	local mineType = dbinfo["res_type"..tostring(data.pit_id)]	-- 矿的类型
	local areaDes, pageDes = MineUtil.getDomainDescribe(data.domain_id)	-- 文字描述
	local mineDes = MineUtil.getMineTypeDescribe(mineType)				-- 文字描述
	------ 正式数据 ------
 	local tTxt = {newUser, gi18n[5669], oldUser, gi18n[5670], areaDes..pageDes, gi18n[5671], mineDes}
 	local strTxt = string.format("%sgi18n[5669]%sgi18n[5670]%sgi18n[5671]%s", newUser, oldUser, areaDes..pageDes, mineDes)
 	------ 测试数据 ------
 	-- local strTxt = "玩家1抢夺了玩家2在普通区12号资源区的金矿"
	-- local tTxt = {"玩家1","抢夺了","玩家2","在","普通区12号","资源区的","金矿"}
	return tTxt, strTxt
end

-- 获取占领信息 空矿return nil
function getOccupyInfoWithId( domainId, pitId )
	for k, v in pairs(_tbOccupyInfo) do
		if (tonumber(v.domain_id) == tonumber(domainId) and tonumber(v.pit_id) == tonumber(pitId)) then
			return v
		end
	end
	return nil
end

-- 根据协助uid获取协助角标的图片
function getHelperPeopleImg( uid )
	if (uid == nil) then
		return "images/resource/people/res_people_1.png"	-- 灰图
	elseif (tonumber(uid) == UserModel.getUserUid()) then
		return "images/resource/people/res_people_3.png"	-- 绿图
	else
		return "images/resource/people/res_people_2.png"	-- 黄图
	end
end

-- 计算协助军增加的百分比
function calc_armyPercent( armyCount )
	local dbNormalConfig = DB_Normal_config.getDataById(1)
	return armyCount * dbNormalConfig.oneHelpArmyEnhance
end

-- 计算片计量	
function calc_lsvOffset( listView, aimPos )
	local cell = listView:getItem(aimPos - 1)
	local listPos=listView:getWorldPosition()
	local listRect=CCRectMake(listPos.x,listPos.y,listView:getViewSize().width,listView:getViewSize().height)
	local leftBorder = listRect.origin.x
	local rightBorder = listRect.origin.x + listView:getViewSize().width
	if cell then
		local cellPos=cell:getWorldPosition()

		local cellRight = cellPos.x+cell:getSize().width
		local cellLeft = cellPos.x

		-- 如果在cell 在 listview 外部 右边外部 左边外部不用处理
		if cellLeft >= rightBorder then
			local offset = listView:getContentOffset()
			return ccp(offset-cellRight+rightBorder,0)
		end
		if cellRight <= leftBorder then
			local offset = listView:getContentOffset()
			return ccp(offset-cellLeft+leftBorder*2,0)
		end

		if listRect:containsPoint(cellPos) and listRect:containsPoint(ccp(cellPos.x+cell:getSize().width, cellPos.y))then
			return ccp(listView:getContentOffset(), 0)
		end
		
		if listRect:containsPoint(cellPos) and not listRect:containsPoint(ccp(cellPos.x+cell:getSize().width, cellPos.y)) then
			local offset = listView:getContentOffset()
			return ccp(offset-cellRight+rightBorder,0)
		end

		if not listRect:containsPoint(cellPos) and listRect:containsPoint(ccp(cellPos.x+cell:getSize().width, cellPos.y)) then
			local offset = listView:getContentOffset()
			return ccp(offset+leftBorder-cellLeft,0)
		end
	end
	return ccp(listView:getContentOffset(), 0)
end

--[[desc:根据类型获取矿山特效json文件
    arg1: effectType：1,2表示铜铁矿，3表示银矿，4表示金矿，5表示蓝宝石矿，6表示红宝石矿，7表示绿宝石矿，8表示钻石矿，shui表示水波特效
    arg2: field:island表示矿区特效，其他表示其他位置
    return: 对应特效的json路径
—]]
function getEffectPath( field , effectType )
	if (field == "island") then
		local strType = nil 
		if ((effectType == 1) or (effectType == 2)) then
			strType = "tongtie"
		elseif (effectType == 3) then
			strType = "ying"
		elseif (effectType == 4) then
			strType = "jin"
		elseif (effectType == 5) then
			strType = "lan"
		elseif (effectType == 6) then
			strType = "hong"
		elseif (effectType == 7) then
			strType = "lv" 
		elseif (effectType == 8) then
			strType = "zi"
		else 
			strType = effectType
		end

		return string.format("images/effect/resource/res_island_%s/res_island_%s.ExportJson",strType,strType)
	else
		return string.format("images/effect/resource/res_%s/res_%s.ExportJson",field,field)
	end
end

--[[desc:根据资源矿类型返回特效名
    arg1: type：1,2表示铜铁矿，3表示银矿，4表示金矿，5表示蓝宝石矿，6表示红宝石矿，7表示绿宝石矿，8表示钻石矿，shui表示水波特效
    return: 是否有返回值，返回值说明  
—]]
function getEffectName( effectType , water )
	local strType = nil 
	if (effectType == 1) then 
		strType = "tie"
	elseif (effectType == 2) then
		strType = "tong"
	elseif (effectType == 3) then
		strType = "ying"
	elseif (effectType == 4) then
		strType = "jin"
	elseif (effectType == 5) then
		strType = "lan"
	elseif (effectType == 6) then
		strType = "hong"
	elseif (effectType == 7) then
		strType = "lv" 
	elseif (effectType == 8) then
		strType = "zi"
	end

	if (water) then
		if (effectType == 1) then
			strType = "shui_5"
		elseif (effectType == 2) then
			strType = "shui_4"
		elseif (effectType == 3 or effectType == 4) then
			strType = "shui_3"
		elseif (effectType == 5 or effectType == 6) then
			strType = "shui_2"
		elseif (effectType == 7 or effectType == 8) then
			strType = "shui_1"
		end
	end

	return "res_island_" .. strType
end

function getFloatAction( ... )
	local actions = CCArray:create()
	actions:addObject(CCMoveBy:create(1, ccp(0, 3)))
	actions:addObject(CCMoveBy:create(1, ccp(0, -3)))
	return CCRepeatForever:create(CCSequence:create(actions))
end

function getShipTinyImg( ... )
	local sid = UIHelper.getHomeShipID()
	local img = ImageView:create()
	img:loadTexture("images/resource/ship_tiny/ship"..sid..".png")
	return img
end

-- 第0 帧 位置 0，0 旋转 0
-- 第15 帧 位置 0，0.5 旋转 1.5
-- 第30 帧 位置 0，1 旋转 0.3
-- 第45 帧 位置 0，0.5 旋转 -1
-- 第60 帧 位置 0，0 旋转 0
-- 1s为一周，需要循环播放
-- 获取小船的动作
function getShipEffect( ... )
	local actions = CCArray:create()
	actions:addObject(CCSpawn:createWithTwoActions(CCMoveTo:create(0, ccp(0, 0)), 
													CCRotateTo:create(0, 0)))

	actions:addObject(CCSpawn:createWithTwoActions(CCMoveTo:create(15/60, ccp(0, 0.5)), 
													CCRotateTo:create(15/60, 1.5)))

	actions:addObject(CCSpawn:createWithTwoActions(CCMoveTo:create(15/60, ccp(0, 1)), 
													CCRotateTo:create(15/60, 0.3)))

	actions:addObject(CCSpawn:createWithTwoActions(CCMoveTo:create(15/60, ccp(0, 0.5)), 
													CCRotateTo:create(15/60, -1)))

	actions:addObject(CCSpawn:createWithTwoActions(CCMoveTo:create(15/60, ccp(0, 0)), 
													CCRotateTo:create(15/60, 0)))

	return CCRepeatForever:create(CCSequence:create(actions))
end

-- ship1.png使用的特效子文件为small_ship_2特效，ship2.png及以后所有的船都使用small_ship_1特效
function getShipWaveEffect( ... )
	local sid = UIHelper.getHomeShipID()
	local animationName = sid == 1 and "small_ship_2" or "small_ship_1"
	return UIHelper.createArmatureNode({
				filePath = "images/effect/resource/small_ship.ExportJson",
				animationName = animationName,
				loop = 1,
				bRetain = true,
			})
end

-- 是否有红点
function isTips( ... )
	logger:debug(_tbSelfInfo)
	logger:debug(_tbGainInfo)
	-- 未开启
	if (not SwitchModel.getSwitchOpenState(ksSwitchResource,false)) then
		return false
	end
	-- 普通或高级未占矿时
	if (table.isEmpty(_tbSelfInfo.tNormal)) then
		return true
	end
	-- 有奖励时
	if (_tbGainInfo.nSilver > 0) then
		return true
	end
	-- 有未读邮件时
	if (g_redPoint.newMineMail.visible) then
		return true
	end
	return false
end

------------------- 创建方法 -----------------------
local function init(...)

end

function destroy(...)
	logger:debug("MineModel destroy")
	_tbDBMineInfo = nil
	_tbDBExploreInfo = nil
	_tbDBPitInfo = nil
	--_tbOccupyInfo = nil
	-- _tbSelfInfo.tNormal = nil
	-- _tbSelfInfo.tGold = nil
	-- _tbSelfInfo.tHelp = nil
	-- _tbSelfInfo = nil
	_tbExploreInfo = nil
	package.loaded["MineModel"] = nil
end

function moduleName()
    return "MineModel"
end

function create(...)

end

