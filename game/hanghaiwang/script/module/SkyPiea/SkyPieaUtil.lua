-- FileName: SkyPieaUtil.lua
-- Author: huxiaozhou
-- Date: 2015-01-08
-- Purpose: 空岛工具类
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("SkyPieaUtil", package.seeall)

require "script/module/SkyPiea/SkyPieaModel"
require "script/module/SkyPiea/MainSkyPieaView"
require "db/DB_Sky_piea_buff"
local m_i18nString = gi18nString

--爬塔开始发奖的时间戳
m_nStartTimeInt = 0
--爬塔发奖结束的时间戳
m_nEndTimeInt  = 0


function getLuFeiIcon( ... )
	local path = "images/base/hero/body_img/body_elite_lufei.png "

	local lufeiItem = ImageView:create()
	lufeiItem:loadTexture(path)

	lufeiItem:setAnchorPoint(ccp(0.5,0.5))
	return lufeiItem
end

--获取免费宝箱的奖励信息
function getFreeBoxReward(callBack)
	local curLayerNum = SkyPieaModel.getCurFloor()
	local args = CCArray:create()
	args:addObject(CCInteger:create(curLayerNum))
	args:addObject(CCInteger:create(0))
	RequestCenter.skyPieaDealChest(callBack,args)
end

--获取db所有id
local function getBuffDbIds()
	local ids = {}
	for keys,val in pairs(DB_Sky_piea_buff.Sky_piea_buff) do
		local keyArr = lua_string_split(keys, "_")
		table.insert(ids,tonumber(keyArr[2]))
	end
	return ids
end

function getAffixDataById( _affixId )

	logger:debug(_affixId)
	local tbIds = getBuffDbIds()

	for i,v in ipairs(tbIds) do
		local tbBuffInfo  = DB_Sky_piea_buff.getDataById(v)
		local buffValue = tbBuffInfo.buff

		local affixBuffs = lua_string_split(buffValue,",")
		for ii,vv in ipairs(affixBuffs) do
			local affixBuff = lua_string_split(vv,"|")
			local affixId = affixBuff[2]
			if(tonumber(_affixId) == tonumber(affixId) and tonumber(affixBuff[1]) == SkyPieaModel.BUFFTYPE.ATTR_BUFF) then
				return tbBuffInfo
			end
		end

	end
	return {}
end

--获取已经购买的属性buff的信息
function getOwnBuffDataByAffixId(_affixId)
	local buffItem = {}

	local tb_DBInfo = {}

	tb_DBInfo = getAffixDataById(_affixId)
	if(table.count(tb_DBInfo) > 0 ) then
		buffItem.smallIconImg 	 	= "images/skypieaBuff/small_buff_icon/" .. tb_DBInfo.icon  					--已购买的属性buff的图片
		buffItem.smallNameImg 	 	= "images/skypieaBuff/small_buff_name/" .. tb_DBInfo.icon  					--已购买的属性buff的名字图片
	end
	return buffItem
end

--判断是否至少有一个死亡武将
function isHeroDead( ... )
	local tbHeroInfo = SkyPieaModel.getHeroInfo()
	logger:debug(tbHeroInfo)
	-- 伙伴形象，1-6为阵容上的，7-9为替补
	local tbFormationInfo = SkyPieaModel.getFormationInfo()
	logger:debug(tbFormationInfo)


	for pos, hid in pairs(tbFormationInfo) do

		if (hid > 0 and tonumber(tbHeroInfo[tostring(hid)].currHp) == 0) then
			return true
		end
	end

	return false
end

--判断是否至少有一个伙伴需要加血
function isSomeHeroNeedHP( ... )
	local tbHeroInfo = SkyPieaModel.getHeroInfo()
	logger:debug(tbHeroInfo)
	-- 伙伴形象，1-6为阵容上的，7-9为替补
	local tbFormationInfo = SkyPieaModel.getFormationInfo()

	for pos, hid in pairs(tbFormationInfo) do
		if (hid > 0 ) then
			local curPercent = tonumber(tbHeroInfo[tostring(hid)].currHp) / SkyPieaModel.getPercentBase() * 100
			logger:debug(curPercent)
			if(curPercent < 100 and curPercent > 0)  then
				return true
			end
		end
	end

	return false
end

--继续挑战
function fnContinue( ... )
	local nCurFloor = SkyPieaModel.getCurFloor()
	logger:debug("当前的爬塔层数为:" .. nCurFloor)
	SkyPieaModel.setCurFloor(nCurFloor + 1)
	-- MainSkyPieaView.setFloorUI()
	LayerManager.removeLayout()
end

--[[desc:判断当前服务器时间是发奖时间范围内  zhangjunwu 2015-3-6
    arg1: 
    return: 是否有返回值，返回值说明  
—]]
function isRewardTime()
	-- 当前服务器时间
	local curServerTime = TimeUtil.getSvrTimeByOffset()

	logger:debug("开始发奖的时间为%s:" , TimeUtil.getTimeFormatYMDHMS(m_nStartTimeInt))
	logger:debug("j结束的时间戳为%s:" , TimeUtil.getTimeFormatYMDHMS(m_nEndTimeInt))
	logger:debug("当前的时间为%s:" , TimeUtil.getTimeFormatYMDHMS(curServerTime))
	logger:debug("开始的时间戳为:%s -- j结束的时间戳为:%s ========当前的时间为: %s" , m_nStartTimeInt,m_nEndTimeInt,curServerTime)

	if( m_nStartTimeInt <= curServerTime and curServerTime <= m_nEndTimeInt) then
		return true
	end

	return false
end

--[[desc:判断当前服务器时间是超过了发奖时间范围之外 zhangjunwu 2015-3-6
    arg1: 
    return: 是否有返回值，返回值说明  
—]]
function isResetTime()
	-- 当前服务器时间
	local curServerTime = TimeUtil.getSvrTimeByOffset()

	logger:debug("开始发奖的时间为%s:" , TimeUtil.getTimeFormatYMDHMS(m_nStartTimeInt))
	logger:debug("j结束的时间戳为%s:" , TimeUtil.getTimeFormatYMDHMS(m_nEndTimeInt))
	logger:debug("当前的时间为%s:" , TimeUtil.getTimeFormatYMDHMS(curServerTime))
	logger:debug("上次刷新的时间为%s:" , SkyPieaModel.getRefrshTime())
	logger:debug("上次刷新的时间为%s:" , TimeUtil.getTimeFormatYMDHMS(SkyPieaModel.getRefrshTime()))
	logger:debug("开始的时间戳为:%s -- j结束的时间戳为:%s ========当前的时间为: %s" , m_nStartTimeInt,m_nEndTimeInt,curServerTime)

	if( m_nEndTimeInt <= curServerTime and  (m_nEndTimeInt > SkyPieaModel.getRefrshTime())) then
		return true
	end

	return false
end

local function addAlertDlg( _str )
	local alert = UIHelper.createCommonDlg(_str, nil, function (  sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("退到爬塔主界面")
			LayerManager.removeLayout()
			LayerManager.removeLayout()
		end
	end, 1)

	LayerManager.addLayout(alert)
end

--是否需要展示推出爬塔的面板
function isShowRewardTimeAlert()
	if(isRewardTime()) then
		addAlertDlg(m_i18nString(5454))
		return true
	elseif(isResetTime()) then
		local alert = UIHelper.createCommonDlg(m_i18nString(5461), nil, function (  sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				logger:debug("退到爬塔主界面")
				LayerManager.removeLayout()

				local layActivity = MainActivityCtrl.create()
				LayerManager.changeModule(layActivity, MainActivityCtrl.moduleName(), {1,3}, true)
				PlayerPanel.addForActivity()


			end
		end, 1)

		LayerManager.addLayout(alert)

		return true
	end

	return false
end

--设置用户的爬塔开始发奖时间和结束发奖时间
function setUserRewardTime( ... )
	local _userInfo = UserModel.getUserInfo()
	local nStarSecond = tonumber(_userInfo.timeConf.pass.handsOffBeginTime)
	local nDurSecond = tonumber(_userInfo.timeConf.pass.handsOffLastSeconds)

	-- 当前服务器 000000的 时间
	local nTimeIntZero = TimeUtil.getIntervalByTime(000000)

	m_nStartTimeInt = nTimeIntZero + nStarSecond
	m_nEndTimeInt = m_nStartTimeInt + nDurSecond
end


