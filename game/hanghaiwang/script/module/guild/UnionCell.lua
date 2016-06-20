-- FileName: UnionCell.lua
-- Author:zhangjunwu
-- Date: 2014-09-15
-- Purpose: 联盟列表Cell
--[[TODO List]]
-- 模块局部变量 --
require "script/module/public/class"
require "script/module/public/Cell/Cell"
require "script/module/guild/message/CommunicationCtrl"

-- UI控件引用变量 -
-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18nString = gi18nString
local m_requestNewMailNum = 6
local m_TagRichText = 100

UnionCell = class("UnionCell")


function UnionCell:ctor(...)
	local layCell = ...
	self.cell = tolua.cast(layCell, "Layout")
	self.tbMaskRect = {}
	self.tbBtnEvent = {} -- 保存需要屏蔽cell touch 事件的按钮的事件，便于在cell touch中激发按钮事件
end

function UnionCell:init( tbData )
	local widget = self.cell
	if (widget) then
		self.mlaycell = widget:clone()
		self.mlaycell:setPosition(ccp(0,0))
		self.mlaycell:setEnabled(true)
	end
end

function UnionCell:addMaskButton(btn, sName, fnBtnEvent)
	if ( not self.tbMaskRect[sName]) then
		local x, y = btn:getPosition()
		local size = btn:getSize()
		logger:debug("UnionCell:addMaskButton:%s  x = %f, y = %f, w = %f, h = %f", btn:getName(), x, y, size.width, size.height)

		-- 坐标和size都乘以满足屏宽的缩放比率
		local szParent = tolua.cast(btn:getParent(), "Widget"):getSize()
		local posPercent = btn:getPositionPercent()
		local xx, yy = szParent.width*g_fScaleX*posPercent.x, szParent.height*g_fScaleX*posPercent.y
		self.tbMaskRect[sName] = fnRectAnchorCenter(xx, yy, size)
		self.tbBtnEvent[sName] = {sender = btn, event = fnBtnEvent}
	end
end

-- 如果point在所有检测范围内，则是点在按钮上，返回true，用以屏蔽CellTouch事件
function UnionCell:touchMask(point)
	logger:debug("UnionCell:touchMask point.x = %f, point.y = %f", point.x, point.y)
	if ((not self.tbMaskRect) or (point.x < 0.1 and point.y < 0.1)) then
		return nil
	end

	for name, rect in pairs(self.tbMaskRect) do
		logger:debug(name)
		logger:debug("UnionCell:touchMask rect:x = %f,x = %f,x = %f,x = %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
		if (rect:containsPoint(point)) then
			logger:debug("UnionCell:touchMask hitted button:", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
			return self.tbBtnEvent[name]
				-- return true
		end
	end
end


function UnionCell:getGroup()
	if (self.mlaycell) then
		return self.mlaycell
	end
	return nil
end
-- 创建cell
function UnionCell:refresh(tCellValue)
	logger:debug(self.mlaycell)
	logger:debug("tCellValue")
	logger:debug(tCellValue.more)
	self.tbMaskRect = {}
	self.tbBtnEvent = {} -- 保存需要屏蔽cell touch 事件的按钮的事件，便于在cell touch中激发按钮事件
	if(self.mlaycell)then
		local LAY_MORE = m_fnGetWidget(self.mlaycell,"LAY_MORE")
		LAY_MORE:setEnabled(false)

		local LAY_UNION = m_fnGetWidget(self.mlaycell,"LAY_UNION")
		LAY_UNION:setEnabled(true)
		if(tCellValue.more == true)then
			-- 创建更多联盟按钮
			LAY_MORE:setEnabled(true)
			LAY_UNION:setEnabled(false)
			local BTN_MORE = m_fnGetWidget(self.mlaycell,"BTN_MORE")
			BTN_MORE:setTag(tCellValue.offset)
			self:addMaskButton(BTN_MORE, "BTN_MORE", moreMenuItemCallFun)
			return
		end


		--是否显示推荐tt图标

		local IMG_RECOMMAND = m_fnGetWidget(self.mlaycell,"IMG_RECOMMAND")
		IMG_RECOMMAND:removeAllNodes()
		if(tCellValue.push) then
		     local effect = UIHelper.createArmatureNode({
									filePath = "images/effect/newhero/new.ExportJson",
									animationName = "new",
	                    })
	        -- effect:setPosition(ccp(0.05 * IMG_RECOMMAND:getSize().width,0.8 * IMG_RECOMMAND:getSize().height))
	        IMG_RECOMMAND:addNode(effect)
	    end

		-- 军团名字
		local strUnionName = tCellValue.guild_name or " "
		local TFD_UNION_NAME = m_fnGetWidget(self.mlaycell,"TFD_UNION_NAME")
		TFD_UNION_NAME:setText(strUnionName)

		-- 军团等级
		local strUnionLv = tCellValue.guild_level or " "
		local TFD_UNION_LV = m_fnGetWidget(self.mlaycell,"TFD_UNION_LV")
		TFD_UNION_LV:setText(strUnionLv)

		-- 军团排名
		local rank_data = tCellValue.rank or " "

		-- local LABN_UNION_RANK = m_fnGetWidget(self.mlaycell,"LABN_UNION_RANK")
		local TFD_UNION_RANK = m_fnGetWidget(self.mlaycell,"TFD_UNION_RANK")
		-- LABN_UNION_RANK:setStringValue(tonumber(tCellValue.rank))
		TFD_UNION_RANK:setText(tonumber(tCellValue.rank) .. " ")

		--成员数量和上限
		local str1 = tCellValue.member_num or " "
		local str2 = tCellValue.member_limit or " "

		local TFD_MEMBERS_OWN = m_fnGetWidget(self.mlaycell,"TFD_MEMBERS_OWN")
		TFD_MEMBERS_OWN:setText(tostring(str1))

		local TFD_MEMBERS_TOTAL = m_fnGetWidget(self.mlaycell,"TFD_MEMBERS_TOTAL")
		TFD_MEMBERS_TOTAL:setText(tostring(str2))



		-- 军团总战斗力
		local rank_data = tCellValue.fight_force or " "
		local TFD_UNION_FIGHT = m_fnGetWidget(self.mlaycell,"TFD_UNION_FIGHT")
		TFD_UNION_FIGHT:setText(tostring(tCellValue.fight_force))


		-- 军团宣言
		local str = tCellValue.slogan or " "
		local TFD_DECLARE = m_fnGetWidget(self.mlaycell,"TFD_DECLARE")
		TFD_DECLARE:setText(str)

		--军团长的等级
		local strLeaderLv = tCellValue.leader_level or " "
		-- local LABN_LEADER_LV = m_fnGetWidget(self.mlaycell,"LABN_LEADER_LV")
		-- LABN_LEADER_LV:setStringValue(tonumber(strLeaderLv))

		--团长名字
		local leadUid = tonumber(tCellValue.leader_uid)   --团长的uid
		local leader_name = tCellValue.leader_name or " "
		local TFD_LEADER_NAME = m_fnGetWidget(self.mlaycell,"TFD_LEADER_NAME")
		TFD_LEADER_NAME:setText(leader_name)

		--团长的名字的颜色
		
		local name_color =  UserModel.getPotentialColor({htid = tCellValue.leader_figure,bright = false}) 
		TFD_LEADER_NAME:setColor(name_color)

		--聊天按钮
		local BTN_COMMUNICATE_LEADER  = m_fnGetWidget(self.mlaycell,"BTN_COMMUNICATE_LEADER")
		BTN_COMMUNICATE_LEADER:setTag(tCellValue.leader_uid)
		self:addMaskButton(BTN_COMMUNICATE_LEADER, "BTN_COMMUNICATE_LEADER", onChatIcon)


		-- 没有加入军团时显示申请按钮或者撤销申请按钮
		local BTN_CANCEL = m_fnGetWidget(self.mlaycell,"BTN_CANCEL")   --撤销申请
		BTN_CANCEL:setEnabled(false)
		BTN_CANCEL:setTag(tCellValue.guild_id)
		UIHelper.titleShadow(BTN_CANCEL,m_i18nString(3508))

		local BTN_APPLY = m_fnGetWidget(self.mlaycell,"BTN_APPLY")      --申请按钮
		BTN_APPLY:setEnabled(false)
		BTN_APPLY:setTag(tCellValue.guild_id)
		UIHelper.titleShadow(BTN_APPLY,m_i18nString(3507))

		local imgLogo = m_fnGetWidget(self.mlaycell, "IMG_FLAG")
		local sIconPath = "images/union/flag/"
		local tbIcon = GuildUtil.getLogoDataById(tCellValue.guild_logo)
		local imgPath = sIconPath .. tbIcon.img
		logger:debug(imgPath)
		imgLogo:loadTexture(imgPath)

		local uninInfoBg = m_fnGetWidget(self.mlaycell, "img_union_infobg")
		if(GuildDataModel.getIsHasInGuild() == true) then
			uninInfoBg:setSize(CCSizeMake(450,uninInfoBg:getSize().height))
		else
			uninInfoBg:setSize(CCSizeMake(320,uninInfoBg:getSize().height))
		end
		--没有加入任何军团
		if(GuildDataModel.getIsHasInGuild() == false) then
			local isHaveApply = GuildListCtrl.isHaveApplyGuildByGuildID( tCellValue.guild_id )
			logger:debug(isHaveApply)
			if( isHaveApply )then
				BTN_CANCEL:setEnabled(true)
				self:addMaskButton(BTN_CANCEL, "BTN_CANCEL", applyCancleCallFun)
			else
				BTN_APPLY:setEnabled(true)
				self:addMaskButton(BTN_APPLY, "BTN_APPLY", applyCallFun)
			end
		end
		
	end
end

-- 申请按钮回调
function applyCallFun(sender, eventType)
	if (eventType == TOUCH_EVENT_ENDED) then
		logger:debug("申请按钮回调")
		-- 音效
		AudioHelper.playCommonEffect()
		--军团id
		local tag = sender:getTag()
		-- 已经申请3个了不可以申请
		local applyTab = GuildListCtrl.getApplyGuildData()
		if(table.count(applyTab) >= 5)then
			local str = m_i18nString(3511) --"您当前申请的军团已达到上限！"
			ShowNotice.showShellInfo(str)
			return
		end
		-- 冷却时间中 不能申请
		local myData = GuildDataModel.getMineSigleGuildInfo()
		-- 当前服务器时间  当前时间大于cd时间戳时是可以进行申请操作的
		local curServerTime = TimeUtil.getSvrTimeByOffset()
		logger:debug("冷却时间..."  .. curServerTime)
		logger:debug(myData)
		if(table.count(myData) >0 )then
			if(myData.rejoin_cd)then
				if( curServerTime < tonumber(myData.rejoin_cd) ) then
					-- local str = "申请军团冷却时间未到..."
					-- ShowNotice.showShellInfo(str)
					return
				end
			end
		end
		-- 申请军团请求回调
		local function getApplyCallback(  cbFlag, dictData, bRet  )
			if(dictData.err == "ok")then
				logger:debug("申请军团列表信息:")
				logger:debug(dictData.ret)
				if( dictData.ret == "ok")then
					-- 修改申请后列表数据
					GuildListCtrl.AfterApplyServiceData( tag )
					-- 更新军团列表
					GuildListView.updataUnionDataAndUI()


					local str = m_i18nString(3514) --"申请联盟成功，请等待审核~"
					ShowNotice.showShellInfo(str)
				end
			end
		end
		-- 申请接口参数
		local args = CCArray:create()
		args:addObject(CCInteger:create(tag))
		RequestCenter.guild_applyGuild(getApplyCallback,args)
	end
end
-- 撤销申请按钮回调
function applyCancleCallFun(sender, eventType)
	if (eventType == TOUCH_EVENT_ENDED) then
		logger:debug("撤销申请按钮回调")
		-- 音效
		AudioHelper.playCommonEffect()
		--军团id
		local tag = sender:getTag()
		-- 取消接口参数
		-- 取消申请军团请求回调
		local function getCancelApplyCallback(  cbFlag, dictData, bRet  )
			if(dictData.err == "ok")then
				logger:debug("取消申请后再次拉取的军团列表信息:")
				logger:debug(dictData.ret)
				if( bRet)then
					GuildListCtrl.m_isSerch = false
					GuildListView.resetSearchBox() 	--设置输入框为原始状态
					-- 军团请求回调
					local function getNewGuildListCallback(  cbFlag, dictData, bRet  )
						if(dictData.err == "ok")then
							logger:debug("取消申请军团后重新拉取得数据:")
							logger:debug(dictData.ret)
							if(not table.isEmpty(dictData.ret))then
								-- 军团总个数
								GuildListCtrl.m_guildCount = tonumber( dictData.ret.count )
								-- 军团前10条数据
								GuildListCtrl.setGuildListData( dictData.ret.data, dictData.ret.offset )
								-- 设置已经申请的军团数据
								GuildListCtrl.setApplyedGuildData( dictData.ret.appnum )
								-- 更新军团列表
								local unionData = GuildListCtrl.getGuildListData()
								GuildListView.updataUnionDataAndUI(unionData)

							end
						end
					end
					-- 列表数据
					local args = CCArray:create()
					args:addObject(CCInteger:create(0))
					args:addObject(CCInteger:create(10))
					RequestCenter.guild_getGuildList(getNewGuildListCallback,args)
				end
			end
		end
		logger:debug("撤销申请的网络回调：")
		local args = CCArray:create()
		args:addObject(CCInteger:create(tag))
		RequestCenter.guild_cancelApply(getCancelApplyCallback,args)

	end
end

-- 更多军团请求回调
function getMoreGuildListCallback(  cbFlag, dictData, bRet  )
	if(dictData.err == "ok")then
		if(not table.isEmpty(dictData.ret))then
			--新军团的个数
			local newDataCount =  table.count(dictData.ret.data)
			-- 军团总个数
			GuildListCtrl.m_guildCount = tonumber( dictData.ret.count )
			-- 军团10条数据
			GuildListCtrl.setGuildListData( dictData.ret.data, dictData.ret.offset )
			-- 更新军团列表
			local unionData = GuildListCtrl.getGuildListData()
			GuildListView.updataDataAndUIByMore(unionData,newDataCount)
		end
	end
end
-- 更多军团按钮回调
function moreMenuItemCallFun( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		logger:debug("更多军团按钮回调")
		-- 音效
		AudioHelper.playCommonEffect()

		local tag = sender:getTag()
		-- GuildListCtrl.m_isSerch
		if(GuildListCtrl.m_isSerch)then
			-- 搜索请求回调
			local function searchGuildCallback(  cbFlag, dictData, bRet  )
				if(dictData.err == "ok")then
					print("搜索返回得数据:")
					print_t(dictData.ret)
					if(not table.isEmpty(dictData.ret))then
						--新军团的个数
						local newDataCount =  table.count(dictData.ret.data)
						-- 军团总个数
						GuildListCtrl.m_guildCount = tonumber( dictData.ret.count )
						-- 军团10条数据
						GuildListCtrl.setGuildListData( dictData.ret.data, dictData.ret.offset )
						-- 更新军团列表
						local unionData = GuildListCtrl.getGuildListData()
						GuildListView.updataDataAndUIByMore(unionData,newDataCount)
					end
				end
			end
			-- 列表数据
			local args = CCArray:create()
			args:addObject(CCInteger:create(tag))
			args:addObject(CCInteger:create(10))
			args:addObject(CCString:create(GuildListCtrl.m_serchName))
			RequestCenter.guild_getGuildListByName(searchGuildCallback,args)
		else
			-- 列表数据
			local args = CCArray:create()
			args:addObject(CCInteger:create(tag))
			args:addObject(CCInteger:create(10))
			RequestCenter.guild_getGuildList(getMoreGuildListCallback,args)
		end
	end
end

function onChatIcon( sender,eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		local uid = sender:getTag()

		AudioHelper.playCommonEffect()
		
		local bFirend = false
		function requestFunc(cbFlag, dictData, bRet)
			if(bRet == true)then
				local dataRet = dictData.ret
				if(dataRet == "true" or dataRet == true )then
					bFirend = true
				end
				if(dataRet == "false" or dataRet == false  )then
					bFirend = false
				end
			end
			logger:debug(bFirend)
			local tbLeaderInfo  = GuildListView.getCurUnionDatabyUid(uid)
			logger:debug("UnionCell-onChatIcon-tbLeaderInfo")
			logger:debug(tbLeaderInfo)
			if(tbLeaderInfo) then
				--构造交流界面所需要的数据
				local tbUserInfo 		= {}
				tbUserInfo.isFriend	 	= bFirend
				tbUserInfo.uname 		= tbLeaderInfo.leader_name
				tbUserInfo.utid     	= tbLeaderInfo.leader_utid
				tbUserInfo.level 		= tbLeaderInfo.leader_level
				tbUserInfo.fight_force  = tbLeaderInfo.leader_force
				tbUserInfo.type 		= "1"
				tbUserInfo.dress      	= tbLeaderInfo.leader_dress
				tbUserInfo.uid 			= uid
				tbUserInfo.figure 		= tbLeaderInfo.leader_figure
				CommunicationCtrl.create(tbUserInfo)
			end

		end

		local args = CCArray:create()
		args:addObject(CCInteger:create(tonumber(uid)))
		Network.rpc(requestFunc, "friend.isFriend", "friend.isFriend", args, true)
	end
end
