-- FileName: GuildListCtrl.lua
-- Author: zhangjunwu
-- Date: 2014-09-15
-- Purpose: 联盟列表
--[[TODO List]]
-- 未创建军团 进入的界面

module("GuildListCtrl", package.seeall)
require "script/module/guild/GuildListView"
require "script/module/guild/GuildCreateCtrl"
require "script/module/guild/GuildMenuCtrl"
-- UI控件引用变量 --

-- 模块局部变量 --
local tbEvents = {}
local m_tbGuildListInfo 			= nil	-- 军团列表缓存信息
local m_i18nString 					= gi18nString

m_guildCount 						= 0 	-- 军团总个数
local _applyTab 				= {} 	-- 已经申请的军团tab
m_isSerch						= nil 	-- 是否是搜索
m_serchName						= nil 	-- 搜索名字

local function init(...)
	m_tbGuildListInfo = nil
	GuildDataModel.setIsInGuildFunc(true)
end

function destroy(...)
	package.loaded["GuildListCtrl"] = nil
end

function moduleName()
	return "GuildListCtrl"
end

function create(...)
	logger:debug("GuildListCtrl create")
	tbEvents = {}
	-- 创建 军团 按钮事件
	tbEvents.fnCreateGuild = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnCreateGuild")
			AudioHelper.playCommonEffect()

			local view = GuildCreateCtrl.create()
			LayerManager.addLayout(view)
		end
	end
	-- 搜索 军团 按钮事件
	tbEvents.fnSearchGuild = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnSearchGuild")
			AudioHelper.playCommonEffect()

			searchGuildCallFun()

		end
	end
	-- 返回按钮事件
	tbEvents.fnBack = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnBack")
			AudioHelper.playBackEffect()
			--如果是索搜联盟的状态下，按下返回则重新加载列表
			if(m_isSerch == true) then
				local function searchGuildCallback(  cbFlag, dictData, bRet  )
					if(bRet)then
						-- 军团总个数
						m_guildCount = tonumber( dictData.ret.count )
						-- 军团10条数据
						setGuildListData( dictData.ret.data, dictData.ret.offset )

						-- 更新军团列表
						local unionData = getGuildListData()
						GuildListView.updataUnionDataAndUI(unionData)  --重新加载列表
						GuildListView.resetSearchBox() 	--设置输入框为原始状态
						m_isSerch = false
					end
				end
				-- 列表数据
				local args = CCArray:create()
				args:addObject(CCInteger:create(0))
				args:addObject(CCInteger:create(10))
				logger:debug(args)
				RequestCenter.guild_getGuildList(searchGuildCallback,args)

			elseif(GuildDataModel.getIsHasInGuild() == true) then
				MainGuildCtrl.getGuildInfo(true)
			else
				GuildDataModel.setIsInGuildFunc(false)
				require "script/module/main/MainScene"
 				MainScene.homeCallback()
			end
		end
	end

	-- 列表数据
	local args = CCArray:create()
	args:addObject(CCInteger:create(0))
	args:addObject(CCInteger:create(10))
	logger:debug(args)
	RequestCenter.guild_getGuildList(getGuildListCallback,args)

	-- local view = GuildListView.create(tbEvents)
	-- return view
end
-- 军团请求回调
function getGuildListCallback(  cbFlag, dictData, bRet  )
	if(dictData.err == "ok")then
		if(not table.isEmpty(dictData.ret))then
			-- 军团总个数
			m_guildCount = tonumber( dictData.ret.count )
			-- 军团10条数据
			setGuildListData( dictData.ret.data, dictData.ret.offset )

			-- -- 设置已经申请的军团数据
			setApplyedGuildData( dictData.ret.appnum )
			-- -- 创建军团列表


			local view = GuildListView.create(tbEvents)
			if(GuildDataModel.getIsHasInGuild() == true) then
				view:addChild(GuildMenuCtrl.create())
				LayerManager.changeModule(view, GuildListCtrl.moduleName(), {1}, true)
			else
				LayerManager.changeModule(view, GuildListCtrl.moduleName(), {1, 3}, true)
			end
		end
	end
end
-- 搜索军团按钮回调
function searchGuildCallFun( ... )
	local name = GuildListView:getSearchMessage()
	logger:debug(string.len(name))
	if(name == "")then
		local str = m_i18nString(3512) --"请输入要搜索军团的名称!"
		ShowNotice.showShellInfo(str)
		return
	end
	m_isSerch = true
	-- 搜索请求回调
	local function searchGuildCallback(  cbFlag, dictData, bRet  )
		if(dictData.err == "ok")then
			logger:debug("搜索返回得数据:")
			logger:debug(dictData.ret)

			-- 军团总个数
			m_guildCount = tonumber( dictData.ret.count )
			-- 军团10条数据
			setGuildListData( dictData.ret.data, dictData.ret.offset )

			-- 更新军团列表
			local unionData = getGuildListData()
			GuildListView.updataUnionDataAndUI(unionData)

			if(table.isEmpty(dictData.ret.data))then
				local str = m_i18nString(3513) --"您搜索的军团不存在！"
				ShowNotice.showShellInfo(str)
				return
			end
		end
	end
	-- 列表数据
	local args = CCArray:create()
	args:addObject(CCInteger:create(0))
	args:addObject(CCInteger:create(10))
	m_serchName = name
	args:addObject(CCString:create(name))
	RequestCenter.guild_getGuildListByName(searchGuildCallback,args)
end
---------------------------------------------------------------------------------------
-- 军团列表数据

-- 得到军团列表数据
function getGuildListData( ... )
	return m_tbGuildListInfo
end

-- 设置军团列表数据
function setGuildListData( listData, offset )
	local _offset = tonumber(offset)
	-- 总数
	local all_count = m_guildCount
	-- 如果数量不超过10个则不用添加更多按钮
	if( all_count <= 10 )then
		m_tbGuildListInfo = listData
	else
		if( (_offset+10) >= all_count )then
			-- 当数据不满_offset+10时不用加更多按钮
			-- 删除tab中最后位置的更多按钮
			table.remove(m_tbGuildListInfo)
			for i,v in ipairs(listData) do
				table.insert( m_tbGuildListInfo, v)
			end
		else
			if(_offset <= 0)then
				m_tbGuildListInfo = listData
				-- 在数据最后添加 更多好友 标识
				local temTab = { more = true, offset = _offset+10 }
				table.insert(m_tbGuildListInfo,temTab)
				print(" m_tbGuildListInfo 1111")
				print_t(m_tbGuildListInfo)
			else
				-- 删除tab中最后位置的更多按钮
				table.remove(m_tbGuildListInfo)
				for i,v in ipairs(listData) do
					table.insert( m_tbGuildListInfo, v)
				end
				-- 在数据最后添加 更多好友 标识
				local temTab = { more = true, offset = _offset+10 }
				table.insert(m_tbGuildListInfo,temTab)
			end
		end
	end
end


-- 设置已经申请的军团
function setApplyedGuildData( num )
	_applyTab = {}
	local data = getGuildListData()
	if( tonumber(num) <= 0  )then
		return
	end
	for i=1,tonumber(num) do
		_applyTab[#_applyTab+1] = data[i]
	end
end

-- 添加申请军团的数据
function addApplyedGuildData( data )
	if(data)then
		table.insert(_applyTab,1,data)
	end
end

-- 得到已经申请的军团数据
function getApplyGuildData( ... )
	return _applyTab
end

-- 判断是否已申请改军团
function isHaveApplyGuildByGuildID( id )
	local isHaveApply = false
	local applyTab = getApplyGuildData()
	if(not table.isEmpty(applyTab))then
		for k,v in pairs(applyTab) do
			if( tonumber(v.guild_id) == tonumber(id) )then
				isHaveApply = true
				break
			end
		end
	end
	return isHaveApply
end

-- 根据军团id得到该军团在列表数据中的位置和数据
function getGuildDataAndPosByGuildID( id )
	-- print("id++++++++++++++" ..  id)
	local data = {}
	local pos = nil
	local guildData = getGuildListData()
	local count = 0
	for i = 1,#guildData do
		-- print("i...........",i)
		-- print_t(guildData[i])
		if(tonumber(id) == tonumber(guildData[i].guild_id))then
			data = guildData[i]
			pos = i
			break
		end
	end
	return data,pos
end

-- 申请军团后数据修改
-- 根据军团id把申请的军团放到列表第一个
function AfterApplyServiceData( id )
	local thisData,tishPos = getGuildDataAndPosByGuildID(id)
	logger:debug("tishPos" .. tishPos)
	-- 添加到军团已申请表中
	addApplyedGuildData(thisData)
	-- 先删除原来位置上的数据
	table.remove(m_tbGuildListInfo,tishPos)
	-- print_t(m_tbGuildListInfo)
	-- 把申请的数据放到顶层
	table.insert(m_tbGuildListInfo,1,thisData)
	logger:debug("-------------- 申请联盟后把申请的联盟放在第一个后得联盟列表数据是：")
	logger:debug(m_tbGuildListInfo)
end

