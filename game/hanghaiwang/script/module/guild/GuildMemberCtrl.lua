-- FileName: GuildMemberCtrl.lua
-- Author: zhangqi
-- Date: 2014-09-19
-- Purpose: 联盟成员主控制模块
--[[TODO List]]

module("GuildMemberCtrl", package.seeall)

require "script/module/guild/GuildDataModel"
require "script/module/guild/GuildMemberView"

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_verifyUid -- 审核执行同意或拒绝操作的当前uid
local m_verifyUname -- 审核执行同意或拒绝操作的当前uid
local m_tbVerify -- 待审核的列表DataSources

local m_tbMembers

local function init(...)
	m_verifyUid = nil
	m_verifyUname = nil
	m_tbVerify = nil
	m_tbMembers = nil
end

function destroy(...)
	m_verifyUid = nil
	m_verifyUname = nil
	m_tbVerify = nil
	m_tbMembers = nil
	package.loaded["GuildMemberCtrl"] = nil
end

function moduleName()
	return "GuildMemberCtrl"
end


local function sortMembers( tbMembers )
	logger:debug(tbMembers)
	local function fnSort( usr1, usr2 )
		-- 自己排前面
		if (UserModel.getUserUid() == tonumber(usr1.uid)) then
			return true
		end
		if (UserModel.getUserUid() == tonumber(usr2.uid)) then
			return false
		end

		-- 在线的排前面
		if (usr1.status == "1" and usr2.status == "2") then
			return true
		end
		if (usr1.status == "2" and usr2.status == "1") then
			return false
		end

		-- 团长和副团在前面
		if (usr1.member_type == "1") then
			return true
		end
		if (usr2.member_type == "1") then
			return false
		end
		if (usr1.member_type == "2" and usr2.member_type == "0") then
			return true
		end
		if (usr1.member_type == "0" and usr2.member_type == "2") then
			return false
		end

		-- 等级>战斗力>贡献度>竞技排名
		if (tonumber(usr1.level) == tonumber(usr2.level)) then
			if (tonumber(usr1.fight_force) == tonumber(usr2.fight_force)) then
				if (tonumber(usr1.contri_total) == tonumber(usr2.contri_total)) then
					return (tonumber(usr1.position) or 100000) < (tonumber(usr2.position) or 100000)
				end
				return tonumber(usr1.contri_total) > tonumber(usr2.contri_total)
			end
			return tonumber(usr1.fight_force) > tonumber(usr2.fight_force)
		end
		return tonumber(usr1.level) > tonumber(usr2.level)
	end

	table.sort(tbMembers, fnSort)
end


-- 等待有数据回调
function getMemberInfoDelegate()
	local memberListInfo = GuildDataModel.getMemberInfoList()

	m_tbMembers = {}
	for k,v in pairs(GuildDataModel.getMemberInfoList().data) do
		table.insert(m_tbMembers, v)
	end

	sortMembers(m_tbMembers)

	local tbInfo = {data = m_tbMembers}
	GuildMemberView.initMemberList(tbInfo, 1)
end


function create(nFlag)
	local flag = nFlag or 1
	if (GuildMemberView.isOn()) then
		logger:debug("已经在成员模块")
		GuildMemberView.changeByFlag(flag)
		return
	end

	init()
	local tbInfo = {onMember = loadMemberList, onVerify = loadVerifyList}
	LayerManager.changeModule(GuildMemberView.create(tbInfo, flag), GuildMemberView.moduleName(), {1}, true)
end

function refreshMemberList( num )
	m_tbMembers = {}

	for k,v in pairs(GuildDataModel.getMemberInfoList().data) do
		table.insert(m_tbMembers, v)
	end

	sortMembers(m_tbMembers)

	GuildMemberView.refreshMembers(m_tbMembers, num)
end



--弹劾联盟长，任命副联盟长，罢免职务，转让联盟长。数据同步
function reloadMemberList( )
	GuildDataModel.sendRequestForMemberList(function ( ... )
		refreshMemberList(1)
	end)
end


function loadMemberList( ... )
	GuildDataModel.sendRequestForMemberList(getMemberInfoDelegate)
end

function loadVerifyList( ... )
	local args = Network.argsHandler(0, 99)
	RequestCenter.guild_getGuildApplyList(onApplyListCallback, args)
end

--[[desc: 从审核列表删除一条记录
    bAgree: true, 审核通过的删除，需要加到成员列表；nil 或false, 拒绝的删除
    return: 是否有返回值，返回值说明
—]]
local function removeFromVerify( bAgree )
	local idx = 0
	for i, usr in ipairs(m_tbVerify) do
		if (tonumber(usr.uid) == m_verifyUid) then
			idx = i
			break
		end
	end

	m_verifyUname = (m_tbVerify[idx].name)

	table.remove(m_tbVerify, idx)

	GuildMemberView.refreshVerify(m_tbVerify, 1, bAgree) -- 第二个参数表示每次只删除1个,第三个表示是不是同意
end
-- 同意申请回调
function agreeApplyCallback( cbFlag, dictData, bRet )
	if(dictData.ret == "ok" or dictData.ret == "failed" )then
		removeFromVerify(true) -- 从当前审核列表删除

		GuildDataModel.addGuildMemberNum(1) -- 增加会员数
		reloadMemberList()  --成员列表数据重新拉


		if (dictData.ret == "ok") then
			ShowNotice.showShellInfo(m_i18n[3579])
		end
		if (dictData.ret == "failed")then
			ShowNotice.showShellInfo(m_i18n[3566]) -- 已不在申请列表（取消了申请）
		end
	elseif(dictData.ret == "exceed")then
		ShowNotice.showShellInfo(m_i18n[3583])
	elseif(dictData.ret == "limited")then
		ShowNotice.showShellInfo(m_i18n[3565])
	end
end

-- 拒绝申请回调
function refuseApplyCallback( cbFlag, dictData, bRet )
	if(dictData.ret == "ok"  or dictData.ret == "failed")then
		removeFromVerify() -- 从当前审核列表删除
		reloadMemberList()  --成员列表数据重新拉

		if (dictData.ret == "ok") then
			ShowNotice.showShellInfo(gi18nString(3688, m_verifyUname))
		end
		if(dictData.ret == "failed")then
			ShowNotice.showShellInfo(m_i18n[3566])
		end
	end
end

-- 一键拒绝网络回调
function refuseAllApplyCallback( cbFlag, dictData, bRet )
	if(dictData.err == "ok" or dictData.err == "failed")then
		if (dictData.ret == "ok") then
			ShowNotice.showShellInfo(m_i18n[3689])
		end
		if(dictData.ret == "failed")then
			ShowNotice.showShellInfo(m_i18n[3564])
		end
		m_tbVerify = {}
		GuildMemberView.refreshVerify(m_tbVerify)
	end
end

function onApplyListCallback( cbFlag, dictData, bRet )
	if (bRet) then
		m_tbVerify = {}
		for k, v in pairs(dictData.ret.data) do
			local usr = {}
			usr.uid = v.uid
			usr.utid = v.utid
			usr.htid = v.figure
			usr.name = v.uname
			usr.level = v.level
			usr.vip = v.vip
			usr.arenaRank = v.position -- 竞技场排名
			usr.fight = v.fight_force -- 战斗力
			usr.applyTime = v.apply_time -- 申请时间

			usr.onAgree = function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					m_verifyUid = sender:getTag()
					local args = Network.argsHandler(m_verifyUid)
					RequestCenter.guild_agreeApply(agreeApplyCallback, args)
				end
			end

			usr.onRefuse = function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					m_verifyUid = sender:getTag()
					local args = Network.argsHandler(m_verifyUid)
					RequestCenter.guild_refuseApply(refuseApplyCallback, args)
				end
			end

			table.insert(m_tbVerify, usr)
		end
		-- 按最近申请时间递减排序
		table.sort(m_tbVerify, function ( usr1, usr2 )
			return tonumber(usr1.applyTime) > tonumber(usr2.applyTime)
		end)

		function noVerifyTip( data )
			if (table.isEmpty(data))then
				require "script/module/public/ShowNotice"
				ShowNotice.showShellInfo(m_i18n[3564])
				return true
			end
			return false
		end

		local tbInfo = {data = m_tbVerify}
		tbInfo.onSort = function ( ... )
			if (noVerifyTip(tbInfo.data)) then
				return
			end
			GuildMemberView.showSortDlg(m_tbVerify)
		end

		tbInfo.onRefuseAll = function ( ... )
			if (noVerifyTip(tbInfo.data)) then
				return
			end

			local dlg = UIHelper.createCommonDlg( m_i18n[3553], nil,
				function ( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						AudioHelper.playCommonEffect()
						LayerManager.removeLayout()
						RequestCenter.guild_refuseAllApply(refuseAllApplyCallback)
					end
				end,
				2)
			LayerManager.addLayout(dlg)
		end

		GuildMemberView.initVerifyList(tbInfo, 2)
	end
end
