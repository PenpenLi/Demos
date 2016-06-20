-- FileName: GuildCopyMapCtrl.lua
-- Author: liweidong
-- Date: 2015-06-01
-- Purpose: 公会副本地图ctrl
--[[TODO List]]

module("GuildCopyMapCtrl", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local function init(...)

end

function destroy(...)
	package.loaded["GuildCopyMapCtrl"] = nil
end

function moduleName()
    return "GuildCopyMapCtrl"
end

function create(...)
	local function getDataCallBack( cbFlag, dictData, bRet )
		if(bRet == true)then
			DataCache.setGuildCopyData(dictData.ret)
			require "script/module/guildCopy/GuildCopyMapView"
			GuildCopyMapView.create()
		end
	end
	RequestCenter.getGuildCopyAllInfo(getDataCallBack)
end
--重新加载地图
function onReloadMap()
	local function getDataCallBack( cbFlag, dictData, bRet )
		if(bRet == true)then
			DataCache.setGuildCopyData(dictData.ret)
			require "script/module/guildCopy/GuildCopyMapView"
			GuildCopyMapView.updateUI()
		end
	end
	RequestCenter.getGuildCopyAllInfo(getDataCallBack)
end
--点击入口
function onClickEnterence(sender, eventType )
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	AudioHelper.playCommonEffect() 
	require "script/module/guildCopy/GuildCopyModel"
	local cross,promptStr = GuildCopyModel.getCopyOpenStatus(sender:getTag())
	if (cross==1) then
		require "script/module/guildCopy/GCEnterCtrl"
		local enter =  GCEnterCtrl.create(sender:getTag())
		LayerManager.addLayoutNoScale(enter)
	else
		local identity = GuildDataModel.getUserGuildIdentity()
		if (identity==0) then
			ShowNotice.showShellInfo(m_i18n[5932]) --TODO
		else
			if (cross==3) then
				ShowNotice.showShellInfo(promptStr)
			else
				--弹出开启
				require "script/module/guildCopy/GCConfirmOpenCtrl"
				LayerManager.addLayout(GCConfirmOpenCtrl.create(sender:getTag()))
			end
		end
	end
end
--点击普通副本
function onNormallCoyp()
	-- MainScene.onCopy(nil,TOUCH_EVENT_ENDED)
	require "script/module/copy/MainCopy"
	if (MainCopy.moduleName() ~= LayerManager.curModuleName() or MainCopy.isInExploreMap()) then
		MainCopy.destroy()
		LayerManager.changeModule(Layout:create(), "ExploreAndCopyChange", {}, true)
		local timeTemp = os.clock()
		local timeS = os.time()
		print("begin clock : %s", timeTemp)
		local layCopy = MainCopy.create()
		if (layCopy) then
			LayerManager.changeModule(layCopy, MainCopy.moduleName(), {3}, true)
			PlayerPanel.addForCopy()
			MainCopy.updateBGSize()
			MainCopy.setFogLayer()
			print("end clock : %s", os.clock() - timeTemp)
			print("end time : %s", os.time() - timeS)
			MainCopy.normalCopyAction("images/copy/ncopy/into_nor_copy.png")
		end
		MainScene.updateBgLightOfMenu() -- zhangqi, 刷新背景光晕的显示
	end
end
--点击说明
function onExplore()
	local layoutMain = g_fnLoadUI("ui/union_copy_explain.json")
	UIHelper.registExitAndEnterCall(layoutMain,
			function()
				
			end,
			function()
			end
		)
	require "db/DB_Legion_copy_build"
	local guildDb=DB_Legion_copy_build.getDataById(1)
	local guildCopyInfo = DataCache.getGuildCopyData()
	-- local vir = tolua.cast(layoutMain.TFD_MAIN:getVirtualRenderer(), "CCLabelTTF")

	layoutMain.TFD_MAIN:setText(m_i18n[5926])
	layoutMain.TFD_ACTIVE:setText(m_i18n[5958]) --TODO
	layoutMain.TFD_MAIN:setSizeType(SIZE_ABSOLUTE)
	-- vir:setString(m_i18n[5926])
	layoutMain.TFD_MAIN:setSize(CCSizeMake(layoutMain.TFD_MAIN:getContentSize().width,layoutMain.TFD_MAIN:getContentSize().height+120))
	-- layoutMain.TFD_MAIN:ignoreContentAdaptWithSize(true)
	layoutMain.TFD_ACTIVE_NUM:setText(guildCopyInfo.today_contri .."/"..guildDb.vital_day_limit)
	layoutMain.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)
	LayerManager.addLayout(layoutMain)
	
end
--点击返回按钮
function onReturnGuild()
	require "script/module/guild/MainGuildCtrl"
	MainGuildCtrl.create()
end
--点击分配记录
function onSharedRecord( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then 
		AudioHelper.playCommonEffect()
		require "script/module/guildCopy/GCSharedRecordCtrl"
		GCSharedRecordCtrl.create()
	end 
end


-------------------用于获取途径,判定当前是否弹开分配记录--------------

local _guildType = 0
--[[desc:_guildType＝1 当前是否点开分配记录面板
	_guildType＝2 当前在上海排行榜
	_guildType＝0  其它
    return:    
—]]
function getGuildType( ... )
	return _guildType
end

function setGuildType( type )
	_guildType = type
end

