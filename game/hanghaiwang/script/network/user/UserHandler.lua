-- Filename: UserHandler.lua
-- Author: fang
-- Date: 2013-05-30
-- Purpose: 该文件用于登陆数据模型

require "script/network/Network"
require "script/utils/LuaUtil"
module ("UserHandler", package.seeall)

local m_ExpCollect = ExceptionCollect:getInstance()

isNewUser = false

-- 玩家登陆到游戏服务器
function login(cbName, dictData, bRet)
	if (cbName ~= "user.login") then
		m_ExpCollect:info("user_login", "cbName = " .. cbName)
		return
	end
	if (bRet) then
		m_ExpCollect:finish("user_login")

		if (dictData.ret == "ok") then
			m_ExpCollect:info("user_login", "ok")

			m_ExpCollect:start("user_getUsers")
			RequestCenter.user_getUsers(fnGetUsers)
		elseif (dictData.ret == "timeout") then
			m_ExpCollect:info("user_login", "timeout")
			LoginHelper.fnServerIsTimeout()
		elseif (dictData.ret == "full") then
			m_ExpCollect:info("user_login", "full")
			LoginHelper.fnServerIsFull()
		elseif (dictData.ret == "ban") then
			m_ExpCollect:info("user_login", "banned")
			LoginHelper.fnIsBanned(dictData.info)
		else
			m_ExpCollect:info("user_login", "dictData.ret = " .. tostring(dictData.ret))
		end
	else
		m_ExpCollect:info("user_login", "bRet false: dictData.ret = " .. tostring(dictData.ret))
	end
end


-- 得到玩家所有的用户（支持一个帐户有多个角色）
function fnGetUsers(cbName, dictData, bRet)
	logger:debug({fnGetUsers_dictData = dictData})

	if (bRet) then
		m_ExpCollect:finish("user_getUsers")

		local ret = dictData.ret

		if (#ret > 0) then
			local dictUserInfo = ret[1]
			local ccsUid = dictUserInfo.uid

			m_ExpCollect:start("user_userLogin")
			local args = CCArray:createWithObject(CCString:create(ccsUid))
			RequestCenter.user_userLogin(fnUserLogin, args)
		else
			--LayerManager.removeLoginLoading()
			LayerManager.removeRegistLoading()

			isNewUser = true -- 新号未创建角色
			
			-- zhangqi, 2016-01-06, 如果是在创建角色界面重连成功，则删除重连Loading
			-- 然后可以直接创建角色进入游戏
			if (LayerManager.curModuleName() == "UserNameView") then
				LayerManager.removeLoginLoading()
				return
			end

			require "script/module/login/UserNameView"
			local layName = UserNameView.create()
			LayerManager.changeModule(layName, UserNameView.moduleName(), {}, true)
		end
	else
		m_ExpCollect:info("user_getUsers", "bRet false: dictData.ret = " .. tostring(dictData.ret))
	end
end

-- 使用uid用户进入游戏
function fnUserLogin(cbName, dictData, bRet)
	if (bRet) then
		m_ExpCollect:finish("user_userLogin")

		local ret = dictData.ret
		if (ret == "ok") then
			logger:debug("玩家角色登录成功")

			m_ExpCollect:start("user_getUser")
			require "script/network/RequestCenter"
			RequestCenter.user_getUser(fnGetUser, nil)
		else
			m_ExpCollect:info("user_userLogin", "fnUserLogin error: dictData.ret = " .. tostring(dictData.ret))
		end
	else
		m_ExpCollect:info("user_userLogin", "bRet false: dictData.ret = " .. tostring(dictData.ret))
	end
end

-- 得到用户信息
function fnGetUser(cbName, dictData, bRet)
	logger:debug({fnGetUser_bRet = bRet})

	if (bRet) then
		require "script/model/user/UserModel"
		UserModel.setUserInfo(dictData.ret)

		m_ExpCollect:finish("user_getUser")

		-- 2013-03-27, 平台统计需求，创建新角色且拉到玩家信息后调用
		if (Platform.isPlatform() and isNewUser) then
			Platform.sendInformationToPlatform(Platform.kCreateNewRole)
		end

		LoginHelper.startPreRequest()
	else
		m_ExpCollect:info("user_getUser", "bRet false")
	end
end
