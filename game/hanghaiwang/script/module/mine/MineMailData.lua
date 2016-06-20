-- FileName: MineMailData.lua
-- Author:sunyunpeng 
-- Date: 2015-06-01
-- Purpose: 资源矿邮件信息
--[[TODO List]]

module("MineMailData", package.seeall)
local m_i18nString 	= gi18nString
local _menuBtnCanCall = false

-- UI控件引用变量 --

-- 模块局部变量 --

------- MSG -------
_MSG_ = {
	CB_PUSH_MAIL_REVENGETIP	 = "CB_PUSH_MAIL_REVENGETIP",
	CB_PUSH_MAIL_RESOURCETIP = "CB_PUSH_MAIL_RESOURCETIP",
}

--邮件里查看战报和聊天里查看战报的区分枚举
 ReplayType = {
				KTypeMineMail= 10, -- 资源矿邮件
				}

-- 资源矿仇人信息邮件
mineRevengeData = nil
-- 资源矿到期邮件
mineExhaustData = nil
-- 资源矿抢夺信息邮件
mineGrabData = nil
-- 资源矿邮件显示数据
showMineMailData = nil

-- 邮件模板id
MINEMAIlTEMPLATEID = {
	ZYZLWC = 1 ,     				--资源矿占领期完成
	BRQDSB =  2 ,                   --被别人抢夺后（对方失败）
	BRQDCG = 3	,                   --被别人抢夺后（对方成功）
	ZLBRKCG = 4	 ,                  --自己去占领别人的资源矿（成功）
	ZLBRKSB =  5 ,                  --自己去占领别人的资源矿（失败）

	QXBDZSB =  6 ,                  --自己资源矿被强行夺走（成功）
	QXBDZCG =  7 ,                  --自己资源矿被强行夺走（失败）
	QXSBRSB =  8 ,                  --强行夺走别人资源矿（成功）
	QXDBRCG =  9 ,                  --强行夺走别人资源矿（失败）

	ZYKFQ = 34	,                   --资源矿放弃
	ZLSJJS = 35	,                   --占领时间结束
	ZDFQXZ = 36	,                   --主动放弃协助
	ZYKBZL = 37	,                   --资源矿被占领
	ZYKBFQ = 38	 ,                  --协助的资源矿被放弃
	XZBQ = 	39  ,                   --协助被抢夺
	XZSJD = 40	,                   --协助时间结束
	XZBQTS = 41  ,                   --协助被抢夺矿主提示
	BDJL = 	42                      --金币资源矿1小时保底银币奖励

}


-- 每个Tab里面所含有的邮件模板id
MINEMAIlTEMPLATETB = {
	REVENGETEMPLATETB = {3,6,41,42} ,                         --仇人信息模板id
	RESOURCETB = {1,2,4,5,7,8,9,34,35,36,37,38,39,40}             --资源到期模板id
}

--CELL的标题 
TILTLETB = {}
TILTLETB.titel1 = {3,42}   						--守护资源矿失败
TILTLETB.titel2 = {1}							--资源矿到期
TILTLETB.titel3 = {2}							--守护资源矿成功
TILTLETB.titel4 = {4,5,6,7,8,9}					--资源矿抢夺
TILTLETB.titel5 = {34}							--放弃资源矿
TILTLETB.titel6 = {35,36,37,38,39,40,41}		--资源矿协助



-- 富文本格式ccc3(0x00,0x3d,0xc7)   ccc3(0xc8, 0x0b, 0x0b)  ccc3(0x11, 0x42, 0x93) ccc3(0x00, 0x62, 0x0c)  ccc3(0x8a, 0x37, 0x00)时间 )
TEXTCOLORSTYLE = {}
TEXTCOLORSTYLE.NORMAL =  {color={r=0x82;g=0x56;b=0x00}, style = nil}                            -- 普通
TEXTCOLORSTYLE.ZB = {btn = true, font = g_sFontPangWa,size = 30,color={r=0x00;g=0x62;b=0x0c}}   --  战报 
TEXTCOLORSTYLE.NAME = {color={r=0xa1;g=0x15;b=0xb6}, style = nil} 								--  姓名
TEXTCOLORSTYLE.OTHER = {color={r=0x00;g=0x62;b=0x0c}, style = nil} 								--  其他（数字，时间）


-- 得到邮件主题
-- tab = {name = "123",content = {"1","2","3"}}
function getMailTemplateData( template_id )
	local tab = {}
	require "db/DB_Email"
	local data = DB_Email.getDataById( template_id )
	tab.name = data.name
	local str = data.content
	local temTab = string.split(str,"|")
	tab.content = temTab
	return tab
end

-- 邮件的cellTile
MINEMAILTITLE = {}
function initTitleName( ... )
	for i,v in ipairs(TILTLETB.titel1) do
		MINEMAILTITLE[v] = getMailTemplateData(3).name      --"守护资源矿失败"
	end
	for i,v in ipairs(TILTLETB.titel2) do
		MINEMAILTITLE[v] = getMailTemplateData(1).name      --"资源矿到期"
	end
	for i,v in ipairs(TILTLETB.titel3) do
		MINEMAILTITLE[v] = getMailTemplateData(2).name       -- "守护资源矿成功"
	end
	for i,v in ipairs(TILTLETB.titel4) do
		MINEMAILTITLE[v] = getMailTemplateData(4).name       --"资源矿抢夺"
	end
	for i,v in ipairs(TILTLETB.titel5) do
		MINEMAILTITLE[v] = getMailTemplateData(34).name       --"放弃资源矿"
	end
	for i,v in ipairs(TILTLETB.titel6) do
		MINEMAILTITLE[v] = getMailTemplateData(35).name       --"资源矿协助"
	end
end

initTitleName()

local function init(...)

end

function destroy(...)
	package.loaded["MineMailData"] = nil
end

function moduleName()
    return "MineMailData"
end

--更新红点
function updateMailRedPoint( templitID )
	local tempID = tonumber(templitID.template_id)
	for i,v in ipairs(MineMailData.MINEMAIlTEMPLATETB.REVENGETEMPLATETB) do
		if (tempID == tonumber(v))	then		 							-- 仇人信息有新邮件
			g_redPoint.newMineMail.visible = true
			g_redPoint.newMineMail.FirstTabShowRed = true 
			require "script/module/mine/MineModel" 
			GlobalNotify.postNotify(MineModel._MSG_.CB_PUSH_MAIL_TIP)
			GlobalNotify.postNotify(MineMailData._MSG_.CB_PUSH_MAIL_REVENGETIP) -- 通知仇人信息红点
			return
		end
	end
	for i,v in ipairs(MineMailData.MINEMAIlTEMPLATETB.RESOURCETB) do
		if (tempID == tonumber(v))	then									-- 资源到期信息有新邮件
			g_redPoint.newMineMail.visible = true
			g_redPoint.newMineMail.SecondTabShowRed = true 
			require "script/module/mine/MineModel"      
			GlobalNotify.postNotify(MineModel._MSG_.CB_PUSH_MAIL_TIP)
			GlobalNotify.postNotify(MineMailData._MSG_.CB_PUSH_MAIL_RESOURCETIP) -- 通知资源到期信息红点
			return
		end
	end
end


-- 合并显示数据
function addToShowMineMailData( showData, t_data ,nMailCount,mineMailType)
	logger:debug(t_data)
	function inserShowData( value,mineMailType )
		local tempData = {}
		table.hcopy(value, tempData)
		tempData.mailType = mineMailType
		tempData.templateId = value.template_id
		tempData.content = getMailTemplateData(value.template_id).content
		tempData.cellTitle = MINEMAILTITLE[tonumber(value.template_id)]
		return tempData
	end
	
	if(table.count(showData) >= 11 )then
		for k,v in pairs(t_data) do
			if (tonumber(mineMailType) == 1 ) then
				for j = 1,#MINEMAIlTEMPLATETB.REVENGETEMPLATETB do
					local templateId = tonumber(MINEMAIlTEMPLATETB.REVENGETEMPLATETB[j])
					if (tonumber(v.template_id) == templateId) then
						local pos = table.count(showData)	
						logger:debug(k)
						logger:debug(v)	
						table.insert(showData,pos,inserShowData( v,mineMailType ))
					end
				end
			elseif (tonumber(mineMailType) == 2 )  then
				for j = 1,#MINEMAIlTEMPLATETB.RESOURCETB do
					local templateId = tonumber(MINEMAIlTEMPLATETB.RESOURCETB[j])
					if (tonumber(v.template_id) == templateId) then
						local pos = table.count(showData)	
						logger:debug(k)
						logger:debug(v)	
						table.insert(showData,pos,inserShowData( v,mineMailType ))
					end
				end
			end
		end
	end
    

	if((#showData) - 1 >= tonumber(nMailCount)) then
		table.remove(showData,#showData)
		logger:debug(showData)
	end
	-- table.remove()

	return showData
end

-- 得到邮件有效时间 返回一个str 如:"今天"
function getValidTime( timeData )
	local curServerTime = TimeUtil.getSvrTimeByOffset()
	local date = TimeUtil.getLocalOffsetDate("*t", curServerTime)
	local curHour = tonumber(date.hour)
	local curMin = tonumber(date.min)
	local cruSec = tonumber(date.sec)
	-- 今天从0点到现在的所有秒数
	local curTotal = curHour*3600 + curMin*60 + cruSec
	-- 邮件产生时间 跟 现在时间 的时间差
	local subTime = curServerTime - tonumber(timeData)
	-- 判断是否在同一天
	-- 两个时间段相差的秒数
	local overTime =  subTime - curTotal
	-- overTime 大于0表明不是今天
	if( overTime > 0)then
		-- 向上取整 1天前为1
		local num = math.ceil(overTime/(24*3600))
		if(2143 + num > 2157) then
			return  m_i18nString(2157)
		else
			return m_i18nString(2143 + num)
		end
		
	else
		return m_i18nString(2143)
	end

end

-- 得到显示的数据
function getShowRobLogMailData( t_data ,mailType)
	-- 得到全部邮件列表数据
	local tab = t_data
	for i,v in ipairs(tab) do
		v.mailType = mailType
		v.cellTitle = getMailTemplateData(44).name
		v.content = getMailTemplateData(44).content
		v.mineRegionType ,v.mineRegionId= MineUtil.getDomainDescribe(v.domain_id)
		v.mineMineType = MineUtil.getMineTypeDescribe(MineUtil.getMineType(v.domain_id, v.pit_id))--(tonumber(v.pit_id))
	end

	-- --按时间先后排序 时间由大到小排列
	local function timeDownSort( a, b )
		return tonumber(a.rob_time) > tonumber(b.rob_time)
	end
	table.sort( tab, timeDownSort )

	return tab
end


-- 得到显示的数据
function getShowRevengeData( t_data ,mailType)
	-- 得到全部邮件列表数据
	local tab = {}

	for i,v in ipairs(t_data.list) do
	    for j = 1,#MINEMAIlTEMPLATETB.REVENGETEMPLATETB do
	    	local templateId = tonumber(MINEMAIlTEMPLATETB.REVENGETEMPLATETB[j])
			if (tonumber(v.template_id) == templateId) then
				v.mailType = mailType
				v.templateId = templateId
				v.cellTitle = MINEMAILTITLE[tonumber(v.template_id)]
				v.content = getMailTemplateData(v.template_id).content
				table.insert( tab,v )
		    end
		end	
	end

	-- --按时间先后排序 时间由大到小排列
	local function timeDownSort( a, b )
		return tonumber(a.recv_time) > tonumber(b.recv_time)
	end
	table.sort( tab, timeDownSort )
	--一页显示10条 最后一条显示更多按钮
	-- if(tonumber(#t_data) > 9)then
	-- 	local tab1 = {more = true,mailType = mailType}
	-- 	table.insert(tab,tab1)
	-- end

	--一页显示10条 最后一条显示更多按钮

	local revengeTb = {}

	for i,v in ipairs(tab) do
		table.insert(revengeTb,v)
		if (tonumber(i) == 10) then
			local tab1 = {more = true,mailType = mailType}
			table.insert(revengeTb,tab1)
			break
		end
	end

	return revengeTb

end


-- 得到显示的数据
function getShowResourceData( t_data ,mailType)
	-- 得到全部邮件列表数据
	local tab = {}

	for i,v in ipairs(t_data.list) do
		for j = 1,#MINEMAIlTEMPLATETB.RESOURCETB do
	    	local templateId = tonumber(MINEMAIlTEMPLATETB.RESOURCETB[j])
			if (tonumber(v.template_id) == templateId) then
				v.mailType = mailType
				v.templateId = templateId
				v.cellTitle = MINEMAILTITLE[tonumber(v.template_id)]
				v.content = getMailTemplateData(v.template_id).content
				table.insert( tab,v )
		    end
		end	
	end

	-- --按时间先后排序 时间由大到小排列
	local function timeDownSort( a, b )
		return tonumber(a.recv_time) > tonumber(b.recv_time)
	end
	table.sort( tab, timeDownSort )
	--一页显示10条 最后一条显示更多按钮

	local mineExhaustTb = {}

	for i,v in ipairs(tab) do
		table.insert(mineExhaustTb,v)
		if (tonumber(i) == 10) then
			local tab1 = {more = true,mailType = mailType}
			table.insert(mineExhaustTb,tab1)
			break
		end
	end

	return mineExhaustTb
end
function create(...)

end
