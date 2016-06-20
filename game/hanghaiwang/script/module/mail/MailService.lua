-- FileName: MailService.lua
-- Author: Li Cong
-- Date: 13-8-20
-- Purpose: function description of module


module("MailService", package.seeall)
local m_i18n = gi18n
-- 得到收件箱邮件列表数据
-- n_startIndex:开始索引第一次为0，其他情况下是mid
-- n_num:个数
-- older: 是拉取比参照值老的邮件还是新的邮件	 旧邮件是true, 新邮件是false  第一次拉取默认true
-- callbackFunc:回调
function getMailBoxList(n_startIndex, n_num, older, callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		logger:debug ("getMailBoxList---后端数据")
		logger:debug(dictData)
		logger:debug(bRet)
		if(bRet == true)then
			logger:debug(dictData.ret)
			
			-- －－－－－去掉好友申请邮件－－－－－－－－
			local data = {}
			for k,v in pairs(dictData.ret.list) do 
				if( tonumber(v.template_id)~=10 )then 
					table.insert(data,v)
				end 
			end 
			dictData.ret.list = data
			-- dictData.ret.mail_number = table.count(data)
			--－－－－－－－－－ 去掉好友申请邮件－－－－－－－－


			MailData.allMailData = dictData.ret
			--MailData.mail_AllData = dictData.ret.list
			logger:debug(dictData.ret)
			callbackFunc( dictData.ret.list ,dictData.ret.mail_number)
		end
	end
	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(n_startIndex))
	args:addObject(CCInteger:create(n_num))
	args:addObject(CCString:create(older))
	Network.rpc(requestFunc, "mail.getMailBoxList", "mail.getMailBoxList", args, true)
end


-- 得到系统邮件列表数据
-- n_startIndex:开始索引
-- n_num:个数
-- older: 是拉取比参照值老的邮件还是新的邮件	 旧邮件是true, 新邮件是false
-- callbackFunc:回调
function getSysMailList(n_startIndex, n_num, older, callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		logger:debug ("getSysMailList---后端数据")
		if(bRet == true)then
			logger:debug(dictData.ret)
			MailData.systemMailData = dictData.ret
			--callbackFunc( dictData.ret.list )
			callbackFunc( dictData.ret.list ,dictData.ret.mail_number)
		end
	end
	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(n_startIndex))
	args:addObject(CCInteger:create(n_num))
	args:addObject(CCString:create(older))
	Network.rpc(requestFunc, "mail.getSysMailList", "mail.getSysMailList", args, true)
end


-- 得到好友邮件列表数据
-- n_startIndex:开始索引
-- n_num:个数
-- older: 是拉取比参照值老的邮件还是新的邮件	 旧邮件是true, 新邮件是false
-- callbackFunc:回调
function getPlayMailList(n_startIndex, n_num, older, callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		-- logger:debug ("getPlayMailList---后端数据")
		if(bRet == true)then
			-- logger:debug(dictData.ret)
			--－－－－－－－－－－ 去掉好友申请邮件－－－－－－－－－
			local data = {}
			for k,v in pairs(dictData.ret.list) do 
				if( tonumber(v.template_id)~=10 )then 
					table.insert(data,v)
				end 
			end 
			dictData.ret.list = data
			dictData.ret.mail_number = table.count(data)
		--－－－－－－－－－－ 去掉好友申请邮件－－－－－－－－－

			MailData.friendMailData = dictData.ret
			--callbackFunc( dictData.ret.list )
			callbackFunc( dictData.ret.list ,dictData.ret.mail_number)
		end
	end
	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(n_startIndex))
	args:addObject(CCInteger:create(n_num))
	args:addObject(CCString:create(older))
	Network.rpc(requestFunc, "mail.getPlayMailList", "mail.getPlayMailList", args, true)
end


-- 得到战斗邮件列表数据
-- n_startIndex:开始索引
-- n_num:个数
-- older: 是拉取比参照值老的邮件还是新的邮件	 旧邮件是true, 新邮件是false
-- callbackFunc:回调
function getBattleMailList(n_startIndex, n_num, older, callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		-- logger:debug ("getBattleMailList---后端数据")
		if(bRet == true)then
			MailData.battleMailData = dictData.ret
			--callbackFunc( dictData.ret.list )
			callbackFunc( dictData.ret.list ,dictData.ret.mail_number)
		end
	end
	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(n_startIndex))
	args:addObject(CCInteger:create(n_num))
	args:addObject(CCString:create(older))
	Network.rpc(requestFunc, "mail.getBattleMailList", "mail.getBattleMailList", args, true)
end


-- 得到资源矿邮件列表数据
-- n_startIndex:开始索引第一次为0，其他情况下是mid
-- n_num:个数
-- older: 是拉取比参照值老的邮件还是新的邮件	 旧邮件是true, 新邮件是false  第一次拉取默认true
-- callbackFunc:回调
function getMineralMailList(n_startIndex, n_num, older, callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		-- logger:debug ("getMineralMailList---后端数据")
		if(bRet == true)then
			-- logger:debug(dictData.ret)
			MailData.mineralData = dictData.ret
			callbackFunc( dictData.ret.list )
		end
	end
	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(n_startIndex))
	args:addObject(CCInteger:create(n_num))
	args:addObject(CCString:create(older))
	Network.rpc(requestFunc, "mail.getMineralMailList", "mail.getMineralMailList", args, true)
end


-- 根据邮件id来获取邮件信息
-- mid:邮件id
-- callbackFunc:回调
function getMailDetail(mid, callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		-- logger:debug ("getMailDetail---后端数据")
		if(bRet == true)then
			-- logger:debug(dictData.ret)
			MailData.mailData = dictData.ret
			callbackFunc()
		end
	end
	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(mid))
	Network.rpc(requestFunc, "mail.getMailDetail", "mail.getMailDetail", args, true)
end



-- 发送邮件
-- int $reciever_uid: 接受者ID
-- string $subject: 主题
-- string $content: 内容
function sendMail(reciever_uid, subject, content, callbackFunc )
	if(content == "")then
		ShowNotice.showShellInfo(m_i18n[2823])
		return
	end
	local function requestFunc( cbFlag, dictData, bRet )
		-- logger:debug ("sendMail---后端数据")
		if(bRet == true)then
			-- logger:debug(dictData.ret)
			if(dictData.ret == "true")then
				callbackFunc()
			end
		end
	end
	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(reciever_uid))
	args:addObject(CCString:create(subject))
	args:addObject(CCString:create(content))
	
	RequestCenter.mail_sendMail(requestFunc,args)
end


-- 邮件同意操作
--   int $uid: 申请者uid
function setApplyMailAdded(uid, callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		-- logger:debug ("setApplyMailAdded---后端数据")
		if(bRet)then
			logger:debug(dictData.ret)
			local dataRet = dictData.ret
			if(dataRet == "ok")then
				-- 修改邮件显示数据
				logger:debug(uid)
				MailData.updateShowMailData( uid, 1 )
				callbackFunc()
			end
		end
	end
	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(uid))
	Network.rpc(requestFunc, "mail.setApplyMailAdded", "mail.setApplyMailAdded", args, true)
end


-- 邮件拒绝操作
--   int $uid: 申请者uid
function setApplyMailRejected(uid, callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		-- logger:debug ("setApplyMailRejected---后端数据")
		if(bRet == true)then
			-- logger:debug(dictData.ret)
			local dataRet = dictData.ret
			if(dataRet == "ok")then
				-- 修改邮件显示数据
				MailData.updateShowMailData( uid, 2 )
				callbackFunc()
			end
		end
	end
	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(uid))
	Network.rpc(requestFunc, "mail.setApplyMailRejected", "mail.setApplyMailRejected", args, true)
end

-- 同意好友
-- int $fuid: 对方uid( 申请者的uid )
function addFriend(uid, callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		-- logger:debug ("addFriend---后端数据")
		logger:debug(dictData)
		if(bRet == true)then
			-- logger:debug(dictData.ret)
			if(dictData.ret == "ok")then
				callbackFunc()
			end
			if(dictData.ret == "isfriend")then
				local str = gi18n[3664] --"对方已经是您的好友了！"
				ShowNotice.showShellInfo(str)
				return
			end
			if(dictData.ret == "applicant_reach_maxnum")then
				local str = gi18n[3665] --"对方的好友数量已达上限！"
				ShowNotice.showShellInfo(str)
				return
			end
			if(dictData.ret == "accepter_reach_maxnum")then
				local str = gi18n[3666] -- "您的好友已数量达上限！"
				ShowNotice.showShellInfo(str)
				return
			end
		end
	end
	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(uid))
    args:addObject(CCString:create(""))
   -- Network.rpc(requestFunc, "friend_addFriend", "friend_addFriend", args, true)
    RequestCenter.friend_addFriend(requestFunc, args)
end


-- 拒绝好友
-- int $uid: 对方uid( 申请者的uid )
function rejectFriend(uid, callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		-- logger:debug ("rejectFriend---后端数据")
		if(bRet == true)then
			-- logger:debug(dictData.ret)
			local dataRet = dictData.ret
			if(dataRet == "ok")then
				callbackFunc()
			end
			if(dataRet == "isfriend")then
				-- local str = "对方已经是您的好友了！"
				ShowNotice.showShellInfo(m_i18n[3664])
				return
			end
		end
	end
	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(uid))
	--Network.rpc(requestFunc, "friend.rejectFriend", "friend.rejectFriend", args, true)
	RequestCenter.friend_rejectFriend(requestFunc, args)
end


-- 得到玩家的资源矿
-- int $uid: 对方uid( 申请者的uid )
function getDomainIdOfUser(uid, callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		logger:debug ("getDomainIdOfUser---后端数据")
		if(bRet == true)then
			-- logger:debug(dictData.ret)
			local dataRet = dictData.ret
			if(tonumber(dataRet) == 0)then
				-- 报错字符
				local str = "该玩家还没有占领资源矿!"
				ShowNotice.showShellInfo(str)
				return
			end
			callbackFunc(dataRet)
		end
	end
	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(uid))
	--Network.rpc(requestFunc, "mineral.getDomainIdOfUser", "mineral.getDomainIdOfUser", args, true)
end



-- 得到战斗串
--  int $brid: 战报id
function getRecord(bridId, callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		if(bRet == true)then
			-- logger:debug(dictData.ret)
			local dataRet = dictData.ret
			if (dataRet=="" or dataRet==" ") then 
				ShowNotice.showShellInfo(m_i18n[7814])
			else
				callbackFunc( dataRet )
			end 
		end
	end
	-- 参数
	local args = CCArray:create()
	args:addObject(CCString:create(bridId))
	RequestCenter.battle_getRecord(requestFunc,args)
end












