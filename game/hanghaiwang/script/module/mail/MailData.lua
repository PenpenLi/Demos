-- FileName: MailData.lua
-- Author: Li Cong
-- Date: 13-8-20
-- Purpose: function description of module



module("MailData", package.seeall)

local m_i18nString 	= gi18nString
-- 全局变量

--邮件里查看战报和聊天里查看战报的区分枚举

 ReplayType = {
				KTypeMailBattle= 1, -- 邮件
				KTypeChatBattle = 2,	--聊天
				}


-- 全部邮件数据
allMailData = nil
-- 战斗邮件
battleMailData = nil
-- 好友邮件
friendMailData = nil
-- 系统邮件
systemMailData = nil
-- 资源矿邮件
mineralData = nil
-- 邮件内容
mailData = nil
-- 是否有新邮件
isHaveNewMail = false
-- 邮件显示数据
showMailData = nil
-- 有按钮的邮件模板id
tArrId = {
	-- 同意,拒绝按钮
	{10},
	-- 回复按钮
	{14},
	-- 反击按钮
	{ 3, 41,42},
	-- 去竞技场
	{15, 16, 24},
	-- 去比武
	{26,27},
	-- 去抢夺
	{23,25,29},
	--去切磋
	{45,46}
}

-- 内容结构分类
tStrId = {
	-- 1. str1..data1
	{22},
	-- 2. str1..data1..str2
	{8,9,16,11,12,13,19,20,30,31,33,45,46},
	-- 3. str1..data1..str2..data2
	{1,4,5,10,15,17,18,34,35,36 ,41},
	-- 4. str1..data1..str2..data2..str3
	{21,23,27,28,29,32,43,37,38 , 39,40},
	-- 5. data1..str1..data2
	{2,7,14},
	-- 6. data1..str1..data2..str2..data3..str3..data4
	{3,6,42},
	-- 7.str1..data1..str2..data2..str3..data3..str4
	{24,25,26},
	-- 8.特殊需求邮件 模板id为0 标题subject 内容content  没有模板内容
	{0}
}
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
		--return tDay[1]
		return m_i18nString(2143)
	end

end


--得到table的大小
function tableCount(ht)
	if(ht == nil) then
		return 0
	end
	local n = 0;
	for _, v in pairs(ht) do
		n = n + 1;
	end
	return n;
end


-- 得到显示的数据
function getShowMailData( t_data )
	-- 得到全部邮件列表数据
	local tab = t_data.list
	-- 按时间先后排序 时间由大到小排列
	-- local function timeDownSort( a, b )
	-- 	return tonumber(a.recv_time) > tonumber(b.recv_time)
	-- end
	-- table.sort( tab, timeDownSort )
	-- 一页显示10条 最后一条显示更多按钮
	if(tonumber(t_data.mail_number) > 10)then
		local tab1 = {more = true}
		table.insert(tab,tab1)
	end
	return tab
end


-- 合并显示数据
function addToShowMailData( showData, t_data ,nMailCount)
	logger:debug(#t_data)
	logger:debug(#showData)
	logger:debug(t_data)
	logger:debug(showData)
	logger:debug(nMailCount)

	-- if(table.count(showData) >= 11 )then
		for k,v in pairs(t_data) do
			local pos = table.count(showData)
			-- 从第pos位开始插入
			table.insert(showData,pos,v)
		end
	-- end
	if((#showData) - 1 >= tonumber(nMailCount)) then
		table.remove(showData,#showData)
		logger:debug(showData)
	end
	-- table.remove()
	return showData
end



------------------------------------------------------ 所有资源矿邮件数据 ------------------------------------------------
-- 全部邮件数据
-- mail_AllData = nil
-- 资源矿相关的邮件模板id
-- local tId = {1,2,3,4,5,6,7,8,9}

-- -- 得到资源矿邮件数据
-- function getMailData( mail_Data )
-- 	if( mail_Data == nil )then
-- 		return nil
-- 	end
-- 	local tab = {}
-- 	-- 遍历所有邮件找到资源矿相关邮件
-- 	for i=1, #mail_Data do
-- 		for j=1, #tId do
-- 			if ( tonumber(mail_Data[i].template_id) == tId[j]) then
-- 				table.insert(tab,mail_Data[i])
-- 				break
-- 			end
-- 		end
-- 	end
-- 	-- 按时间先后排序 时间由大到小排列
-- 	local function timeDownSort( a, b )
-- 		return tonumber(a.recv_time) > tonumber(b.recv_time)
-- 	end
-- 	table.sort( tab, timeDownSort )
-- 	-- logger:debug("资源矿邮件排序。。。。")
-- 	-- logger:debug(tab)
-- 	return tab
-- end
----------------------------------------------------------------------------------------------------------------------

-- 更新显示申请好友邮件数据
function updateShowMailData( uid, num )
	logger:debug(showMailData)
	if(showMailData == nil)then
		return
	end
	for k,v in pairs(showMailData) do
		if( tonumber(v.sender_uid) == tonumber(uid) and tonumber(v.template_id) == 10 )then
			v.va_extra.status = num
			logger:debug("num is " .. num)
		end
	end
end









