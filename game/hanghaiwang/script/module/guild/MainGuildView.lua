-- FileName: MainGuildView.lua
-- Author: huxiaozhou
-- Date: 2014-09-15
-- Purpose: function description of module
--[[TODO List]]
--  已加入联盟后 现实的界面

module("MainGuildView", package.seeall)
require "script/module/guild/GuildMenuCtrl"
require "script/module/guild/GuildUtil"
-- UI控件引用变量 --
local m_mainWidget
local m_mainMenu
local m_lay_leader
local m_lay_member


-- 模块局部变量 --
local jsonMain = "ui/union_main.json"
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnLoadUI = g_fnLoadUI

local va_guanyu_index 		= 3 	-- 人鱼咖啡厅的下标
local va_shop_index			= 4		-- 肥皂泡泡商店下标
local va_copy_index			= 5		-- 士兵船坞下标

local m_i18n = gi18n
local m_i18nString = gi18nString

local m_tbBtn
local m_tbTfd
local m_tbEvent


local _guildInfo
local _sigleGuildInfo



local function init(...)
	GuildDataModel.setIsInGuildFunc(true)
	m_tbBtn = {}
	m_tbTfd = {}
	_guildInfo = GuildDataModel.getGuildInfo()
	_sigleGuildInfo = GuildDataModel.getMineSigleGuildInfo()
end

function destroy(...)
	package.loaded["MainGuildView"] = nil
end

function moduleName()
	return "MainGuildView"
end

function loadUI(  )
	local IMG_BG = m_fnGetWidget(m_mainWidget, "IMG_BG")
	IMG_BG:setScale(g_fScaleX)

	local LAY_ANNOUNCEMENT = m_fnGetWidget(m_mainWidget, "LAY_ANNOUNCEMENT")
	LAY_ANNOUNCEMENT:setSize(CCSizeMake(LAY_ANNOUNCEMENT:getSize().width*g_fScaleX, LAY_ANNOUNCEMENT:getSize().height*g_fScaleX))

	local IMG_ANN_BG = m_fnGetWidget(m_mainWidget, "IMG_ANN_BG")
	IMG_ANN_BG:setScale(g_fScaleX)

	local BTN_CLOSE = m_fnGetWidget(m_mainWidget, "BTN_CLOSE") -- 返回
	BTN_CLOSE:addTouchEventListener(m_tbEvent.fnBack)
	UIHelper.titleShadow(BTN_CLOSE,m_i18n[1019])

	local BTN_OTHER_UNION = m_fnGetWidget(m_mainWidget, "BTN_OTHER_UNION") -- 其他联盟
	BTN_OTHER_UNION:addTouchEventListener(m_tbEvent.fnShowList)

	local BTN_MAIN = m_fnGetWidget(m_mainWidget, "BTN_MAIN")  --军团大厅
	local BTN_MAIN_UP = m_fnGetWidget(BTN_MAIN, "BTN_MAIN_UP") -- 大厅升级按钮
	BTN_MAIN:addTouchEventListener(m_tbEvent.fnGuildMain)
	BTN_MAIN_UP:addTouchEventListener(m_tbEvent.fnGuildMainUp)

	local BTN_SHOP = m_fnGetWidget(m_mainWidget, "BTN_SHOP")
	BTN_SHOP:addTouchEventListener(m_tbEvent.fnGuildShop)

	local BTN_SOLDIER = m_fnGetWidget(m_mainWidget, "BTN_SOLDIER")
	local BTN_SOLDIER_UP = m_fnGetWidget(BTN_SOLDIER, "BTN_SOLDIER_UP") --士兵船坞升级按钮
	BTN_SOLDIER:addTouchEventListener(m_tbEvent.fnGuildSoldier)
	BTN_SOLDIER_UP:addTouchEventListener(m_tbEvent.fnGuildSoldierUp)

	
	local BTN_CAFE = m_fnGetWidget(m_mainWidget, "BTN_CAFE") -- 关公店
	local BTN_CAFE_UP = m_fnGetWidget(BTN_CAFE, "BTN_CAFE_UP") -- 关公殿升级按钮
	local BTN_SHOP_UP = m_fnGetWidget(BTN_SHOP, "BTN_SHOP_UP")

	BTN_SHOP_UP:addTouchEventListener(m_tbEvent.fnGuildShopUp)
	BTN_CAFE:addTouchEventListener(m_tbEvent.fnGuildCafe)
	BTN_CAFE_UP:addTouchEventListener(m_tbEvent.fnGuildCafeUp)
	
	

	m_tbBtn.BTN_CAFE_UP = BTN_CAFE_UP
	m_tbBtn.BTN_MAIN_UP = BTN_MAIN_UP
	m_tbBtn.BTN_SHOP_UP = BTN_SHOP_UP
	m_tbBtn.BTN_SOLDIER_UP = BTN_SOLDIER_UP

	local TFD_MAIN_LV = m_fnGetWidget(BTN_MAIN, "TFD_MAIN_LV")
	local TFD_CAFE_LV = m_fnGetWidget(BTN_CAFE, "TFD_CAFE_LV")
	local TFD_SHOP_LV = m_fnGetWidget(BTN_SHOP, "TFD_SHOP_LV")
	local TFD_SOLDIER_LV = m_fnGetWidget(BTN_SOLDIER, "TFD_SOLDIER_LV")


	TFD_MAIN_LV:setText("Lv" .. GuildDataModel.getGuildHallLevel())
	TFD_CAFE_LV:setText("Lv" .. GuildDataModel.getGuanyuTempleLevel())
	TFD_SHOP_LV:setText("Lv" .. GuildDataModel.getShopLevel())
	TFD_SOLDIER_LV:setText("Lv" .. GuildDataModel.getGuildCopyLv())


	UIHelper.labelAddStroke(BTN_MAIN.TFD_MAIN_NAME, m_i18n[3701], ccc3(0x28,0x00,0x00))
	UIHelper.labelAddStroke(BTN_CAFE.TFD_CAFE_NAME, m_i18n[3721], ccc3(0x28,0x00,0x00))
	UIHelper.labelAddStroke(BTN_SOLDIER.TFD_SOLDIER_NAME, m_i18n[5955], ccc3(0x28,0x00,0x00))
	UIHelper.labelAddStroke(BTN_SHOP.TFD_SHOP_NAME, m_i18n[3808], ccc3(0x28,0x00,0x00))

	UIHelper.labelNewStroke(TFD_MAIN_LV, ccc3(0x28,0x00,0x00))
	UIHelper.labelNewStroke(TFD_CAFE_LV, ccc3(0x28,0x00,0x00))
	UIHelper.labelNewStroke(TFD_SHOP_LV, ccc3(0x28,0x00,0x00))
	UIHelper.labelNewStroke(TFD_SOLDIER_LV, ccc3(0x28,0x00,0x00))

	m_tbTfd.TFD_MAIN_LV = TFD_MAIN_LV
	m_tbTfd.TFD_CAFE_LV = TFD_CAFE_LV
	m_tbTfd.TFD_SHOP_LV = TFD_SHOP_LV
	m_tbTfd.TFD_SOLDIER_LV = TFD_SOLDIER_LV


	local BTN_CHANGE = m_fnGetWidget(m_mainWidget, "BTN_CHANGE") --修改按钮
	local IMG_FLAG = m_fnGetWidget(m_mainWidget, "IMG_FLAG") -- 联盟icon

	if( tonumber(_sigleGuildInfo.member_type) == 1 or  tonumber(_sigleGuildInfo.member_type) == 2)then
		-- 管理
		-- 工会会长
		BTN_CHANGE:setTouchEnabled(true)
		BTN_CHANGE:addTouchEventListener(m_tbEvent.fnChange)

		IMG_FLAG:setTouchEnabled(true)
		IMG_FLAG:addTouchEventListener(m_tbEvent.iconChange)
	else
		--  普通成员
		BTN_CHANGE:setTouchEnabled(false)
		IMG_FLAG:setTouchEnabled(false)

	end


	local BTN_LABORATORY = m_fnGetWidget(m_mainWidget, "BTN_LABORATORY")
	BTN_LABORATORY:addTouchEventListener(m_tbEvent.fnGuildBuilding)
	-- local BTN_TEMPORARY = m_fnGetWidget(m_mainWidget, "BTN_TEMPORARY")
	-- BTN_TEMPORARY:addTouchEventListener(m_tbEvent.fnGuildBuilding)


	local tfd_people = m_fnGetWidget(m_mainWidget, "tfd_people")
	tfd_people:setText(m_i18n[3506])
	UIHelper.labelNewStroke(tfd_people, ccc3(0x28,0x00,0x00))


	local tfd_personal = m_fnGetWidget(m_mainWidget, "tfd_personal")
	tfd_personal:setText(m_i18n[3747])
	UIHelper.labelNewStroke(tfd_personal, ccc3(0x28,0x00,0x00))
	
	local tfd_total = m_fnGetWidget(m_mainWidget, "tfd_total")
	tfd_total:setText(m_i18n[3748])
	UIHelper.labelNewStroke(tfd_total, ccc3(0x28,0x00,0x00))
	-- local tfd_gonggao = m_fnGetWidget(m_mainWidget, "tfd_gonggao")
	-- tfd_gonggao:setText(m_i18n[3749])

	local IMG_TIP_CAFE = m_fnGetWidget(m_mainWidget, "IMG_TIP_CAFE") -- 喝咖啡红点
	local IMG_TIP_HALL = m_fnGetWidget(m_mainWidget, "IMG_TIP_HALL") -- 大厅红点
	local IMG_SOLDIER_TIP = m_fnGetWidget(m_mainWidget, "IMG_SOLDIER_TIP") -- 工会副本红点
	IMG_TIP_HALL:setEnabled(GuildUtil.isCanContri())
	IMG_TIP_CAFE:setEnabled(GuildUtil.isCanBaiGuangong())

end

-- 刷新是否显示建筑升级按钮
function updateUpLevelBtn(  )
	logger:debug(_sigleGuildInfo)
	if(tonumber(_sigleGuildInfo.member_type) == 0 )then
		m_tbBtn.BTN_CAFE_UP:setEnabled(false)
		m_tbBtn.BTN_MAIN_UP:setEnabled(false)
		m_tbBtn.BTN_SHOP_UP:setEnabled(false)
		m_tbBtn.BTN_SOLDIER_UP:setEnabled(false)
		return
	end

	-- 联盟大厅
	local hallNeedExp = GuildUtil.getNeedExpByLv(tonumber(_guildInfo.guild_level) +1 )
	if(tonumber(_guildInfo.curr_exp)>= tonumber(hallNeedExp) and tonumber(_guildInfo.guild_level) < GuildUtil.getMaxGuildLevel() )then
		m_tbBtn.BTN_MAIN_UP:setEnabled(true)
	else
		m_tbBtn.BTN_MAIN_UP:setEnabled(false)
	end

	--人鱼咖啡厅
	local guanyuNeedExp = GuildUtil.getGuanyuNeedExpByLv(tonumber(_guildInfo.va_info[va_guanyu_index].level) + 1)
	if( tonumber(_guildInfo.curr_exp)>= tonumber(guanyuNeedExp) and tonumber(_guildInfo.va_info[va_guanyu_index].level) < math.ceil(tonumber(_guildInfo.guild_level)*DB_Legion_feast.getDataById(1).levelRatio/100) )then
		m_tbBtn.BTN_CAFE_UP:setEnabled(true)
	else
		m_tbBtn.BTN_CAFE_UP:setEnabled(false)
	end

	-- 肥皂泡泡商店
	local shopNeedExp = GuildUtil.getShopNeedExpByLv(tonumber(_guildInfo.va_info[va_shop_index].level) + 1)
	if( tonumber(_guildInfo.curr_exp)>= tonumber(shopNeedExp) and tonumber(_guildInfo.va_info[va_shop_index].level) < math.ceil(tonumber(_guildInfo.guild_level)*DB_Legion_feast.getDataById(1).levelRatio/100) )then
		m_tbBtn.BTN_SHOP_UP:setEnabled(true)
	else
		m_tbBtn.BTN_SHOP_UP:setEnabled(false)
	end

	logger:debug("asdfasdf")
	updateGuildCopyBuildInfo()

end

--更新工会副本建筑的信息，红点，是否升级按钮
function updateGuildCopyBuildInfo()
	logger:debug("asdfasdf")
	--是否开启了工会副本
	local isOpenCopy = GuildUtil.isGuildCopyOpen()
	local BTN_SOLDIER = m_fnGetWidget(m_mainWidget, "BTN_SOLDIER")
	local IMG_SOLDIER_TIP = m_fnGetWidget(m_mainWidget, "IMG_SOLDIER_TIP") -- 工会副本红点
	local img_soldier_lvbg = m_fnGetWidget(m_mainWidget, "img_soldier_lvbg") --
	BTN_SOLDIER:setBright(isOpenCopy)
	IMG_SOLDIER_TIP:setEnabled(isOpenCopy)
	m_tbBtn.BTN_SOLDIER_UP:setEnabled(isOpenCopy)
	m_tbTfd.TFD_SOLDIER_LV:setEnabled(isOpenCopy)
	img_soldier_lvbg:setEnabled(isOpenCopy)

	-- 士兵船坞升级按钮显示逻辑
	local isLeader = tonumber(_sigleGuildInfo.member_type) == 1 or  tonumber(_sigleGuildInfo.member_type) == 2
	local copyNeedExp = GuildUtil.getCopyNeedExpByLv(tonumber(_guildInfo.va_info[va_copy_index].level) + 1)
	local isExpEnough = tonumber(_guildInfo.curr_exp)>= tonumber(copyNeedExp) and tonumber(_guildInfo.va_info[va_copy_index].level) < math.ceil(tonumber(_guildInfo.guild_level)*DB_Legion_feast.getDataById(1).levelRatio/100)  

	if(isExpEnough and isOpenCopy and isLeader)then
		m_tbBtn.BTN_SOLDIER_UP:setEnabled(true)
	else
		m_tbBtn.BTN_SOLDIER_UP:setEnabled(false)
	end


	require "script/module/guildCopy/GCItemModel"
	local attackNum = GCItemModel.getAtackNum()
	logger:debug("工会副本的攻打次数为：" .. attackNum)
	local LABN_SOLDIER_TIP = m_fnGetWidget(m_mainWidget, "LABN_SOLDIER_TIP") -- 工会副本红点
	if(attackNum > 0 and isOpenCopy and GuildCopyModel.isHaveAttackingCopy()) then
		IMG_SOLDIER_TIP:setEnabled(true)
		LABN_SOLDIER_TIP:setStringValue(attackNum)
	else
		IMG_SOLDIER_TIP:setEnabled(false)
	end
end
-- 更新建筑等级
function updateConstructLevel( ... )
	m_tbTfd.TFD_MAIN_LV:setText("Lv" .. GuildDataModel.getGuildHallLevel())
	m_tbTfd.TFD_CAFE_LV:setText("Lv" .. GuildDataModel.getGuanyuTempleLevel())
	m_tbTfd.TFD_SHOP_LV:setText("Lv" .. GuildDataModel.getShopLevel())
	m_tbTfd.TFD_SOLDIER_LV:setText("Lv" .. GuildDataModel.getGuildCopyLv())
end

-- 更新 一些显示信息
function updateUI( ... )
	local i18nTFD_UNION_NAME = m_fnGetWidget(m_mainWidget, "TFD_UNION_NAME") -- 联盟名称
	i18nTFD_UNION_NAME:setText(GuildDataModel.getGildName())
	local TFD_UNION_LV = m_fnGetWidget(m_mainWidget, "TFD_UNION_LV") -- 联盟等级
	TFD_UNION_LV:setText(_guildInfo.guild_level)


	local  LABN_MEMBERS1 = m_fnGetWidget(m_mainWidget, "TFD_MEMBERS1")
	LABN_MEMBERS1:setText(_guildInfo.member_num)
	local  LABN_MEMBERS2 = m_fnGetWidget(m_mainWidget, "TFD_MEMBERS2")
	LABN_MEMBERS2:setText(_guildInfo.member_limit)

	local LABN_MY_CONTRIBUTION = m_fnGetWidget(m_mainWidget, "TFD_MY_CONTRIBUTION") -- 个人贡献度
	LABN_MY_CONTRIBUTION:setText(_sigleGuildInfo.contri_point)

	local LABN_UNION_CONTRIBUTION = m_fnGetWidget(m_mainWidget, "tfd_total_0") --军团建设
	LABN_UNION_CONTRIBUTION:setText(_guildInfo.curr_exp)

	local TFD_ANN_CONTENT = m_fnGetWidget(m_mainWidget, "TFD_ANN_CONTENT") -- 军团公告
	TFD_ANN_CONTENT:setText(GuildDataModel.getPost())
end

-- 更新公告
function updatePost( ... )
	if m_mainWidget then
		local TFD_ANN_CONTENT = m_fnGetWidget(m_mainWidget, "TFD_ANN_CONTENT") -- 军团公告
		TFD_ANN_CONTENT:setText(GuildDataModel.getPost())
	end
end


function updateLogo( logoId )
	if m_mainWidget then
		local IMG_FLAG = m_fnGetWidget(m_mainWidget, "IMG_FLAG") -- 联盟icon
		local tbIcon = GuildUtil.getLogoDataById(logoId)
		local sIconPath =  "images/union/flag/"
		local imgPath = sIconPath .. tbIcon.img
		IMG_FLAG:loadTexture(imgPath)
	end
end


function updateAll(  )
	updateUI()
	updateUpLevelBtn()
	updateConstructLevel()
	updateGuildCopyBuildInfo()
end

function playUpdgradeEffect( sType)
	local building = nil
	local posx, posy = 0, 0
	if sType == "hall" then
		building = m_fnGetWidget(m_mainWidget, "BTN_MAIN")

		posx = 0
		posy = -building:getSize().height/4
	elseif(sType == "guanyu") then
		building = m_fnGetWidget(m_mainWidget, "BTN_CAFE")
		posx = -building:getSize().width/9
		posy = -building:getSize().height/4
	elseif(sType == "shop") then
		building = m_fnGetWidget(m_mainWidget, "BTN_SHOP")
		-- posx = -building:getSize().width/9
		-- posy = -building:getSize().height/4
	elseif(sType == "copy") then
		building = m_fnGetWidget(m_mainWidget, "BTN_SOLDIER")
		-- posx = -building:getSize().width/9
		-- posy = -building:getSize().height/4
	end


	local function animationCallBack( armature,movementType,movementID )
		if(movementType == 1) then

			if sType == "hall" then
				ShowNotice.showShellInfo(m_i18nString(3580,m_i18n[3701],GuildDataModel.getGuildHallLevel()))
			elseif(sType == "guanyu") then
				ShowNotice.showShellInfo(m_i18nString(3580,m_i18n[3721],GuildDataModel.getGuanyuTempleLevel()))
			elseif(sType == "copy") then
				ShowNotice.showShellInfo(m_i18nString(3580,m_i18n[5955],GuildDataModel.getGuildCopyLv()))
			end

			armature:removeFromParentAndCleanup(true)
		end
	end
	local  animation = UIHelper.createArmatureNode({
		filePath = "images/effect/guild/lmup.ExportJson",
		animationName = "lmup",
		loop = 0,
		fnMovementCall = animationCallBack,
	})

	building:addNode(animation)
	animation:setPosition(posx,posy)
end


-- 升级回调
function afterUpgradeDelegate( sType )
	if m_mainWidget then
		playUpdgradeEffect(sType)
		updateAll()
	end
end

function create(tbEvent)
	init()
	m_tbEvent = tbEvent
	m_mainWidget = m_fnLoadUI(jsonMain)
	UIHelper.registExitAndEnterCall(m_mainWidget,function (  )
		m_mainWidget = nil
	end)

	m_mainWidget:setSize(g_winSize)

	m_mainWidget:addChild(GuildMenuCtrl.create())
	loadUI()
	updateUI()
	updateUpLevelBtn()
	updateGuildCopyBuildInfo()
	logger:debug("GuildDataModel.getGuildIconId() = %s",GuildDataModel.getGuildIconId())
	updateLogo(GuildDataModel.getGuildIconId())
	return m_mainWidget
end
