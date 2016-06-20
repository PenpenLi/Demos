-- FileName: GlobalNotify.lua
-- Author: zhangqi
-- Date: 2014-05-18
-- Purpose: 参考何超在英灵项目里的实现，创建一个全局的通知中心, 类似 cocos2d-x 的 CCNotificationCenter
--          提供注册、删除， 触发通知的方法
--[[ChangList List
2014-09-07, 增加一个事件可以注册多个监听者的处理 
]]

module("GlobalNotify", package.seeall)

-- 模块全局变量，供外部访问 --
LEVEL_UP = "LEVEL_UP" -- 玩家升级

BEGIN_BATTLE = "BEGIN_BATTLE" --开始战斗
END_BATTLE = "END_BATTLE" -- 战斗结束

BEGIN_EXPLORE = "BEGIN_EXPLORE" -- 开始探索
END_EXPLORE = "END_EXPLORE"  -- 结束探索

RECONN_OK = "RECONN_OK" -- 原地重连成功(包括进游戏服的成功状态)
RECONN_FAILED = "RECONN_FAILED" -- 连接失败

NETWORK_FAILED = "NETWORK_FAILED" -- 与游戏服断开连接

USER_RECONN_OK = "USER_RECONN_OK" -- 非登陆的原地重连成功，2015-05-13

BAG_CHANGED = "BAG_CHANGED" -- 背包发生变化，2015-09-26

BAG_PUSH_CALL = "BAG_PUSH_CALL" -- 背包推送回调通知，2015-10-26

TREAS_FRAG_CHANGED = "TREAS_FRAG_CHANGED" -- 饰品碎片发生变化，2015-10-21
TREAS_CHANGED = "TREAS_CHANGED" -- 饰品背包发生变化，2015-11-19

PUSHNEWACHIEVE = "PUSHNEWACHIEVE" -- 新成就通知  2015-11-30

CHAT_BUBBLE = "CHAT_BUBBLE"  --主页面聊天气泡推送

VIP_LEVEL_UP = "VIP_LEVEL_UP"  -- vip等级提升的推送 2016-1-25

-- CCNotificationCenter 相关
m_ccNc = CCNotificationCenter:sharedNotificationCenter()
NC_BACKGROUND = "applicationDidEnterBackground" -- 游戏被切到后台的事件通知注册名称
NC_FOREGROUND = "applicationWillEnterForeground" -- 游戏被切到前台的事件通知注册名称
m_NcObserver = {} -- 由于注册的回调中要被外部访问，所以不能定义为local


-- 模块局部变量 --
local m_tbNotifyList
local m_tbKept

local m_tbNextList -- zhangqi, 2015-10-26, 临时存放正在postNotify过程中注册的通知
local m_bPostLock = false -- zhangqi, 2015-10-26, postNotify过程中的锁标记，避免post中add的新的通知

local tbEventType = { LEVEL_UP, BEGIN_BATTLE, END_BATTLE, RECONN_OK, RECONN_FAILED, NETWORK_FAILED,}

function init(...)
	m_tbNotifyList = {}
	for _, eventName in ipairs(tbEventType) do
		m_tbNotifyList[eventName] = {}
	end

	m_tbKept = {}

	m_tbNextList = {} -- 2015-10-26

	m_NcObserver[NC_BACKGROUND] = {}
	m_NcObserver[NC_FOREGROUND] = {}
end

function destroy(...)
	m_NcObserver = nil
	m_tbNotifyList = nil
	m_tbKept = nil
	package.loaded["GlobalNotify"] = nil
end

function moduleName()
	return "GlobalNotify"
end

-- zhangqi, 2015-10-26
local function addNextObserver( sEventName, fnCallback, bOnce, sObsvName )
	local tbObserver = {eventName = sEventName, func = fnCallback, once = bOnce, obsvName = sObsvName}
	m_tbNextList[#m_tbNextList + 1] = tbObserver
	logger:debug({addNextObserver_m_tbNextList = m_tbNextList})
end

-- zhangqi, 2015-10-26
local function nextListMoveToNotifyList( ... )
	if (#m_tbNextList == 0) then
		return
	end

	-- 2015-10-26, 将下次通知列表中的回调注册到当前通知列表
	for i, obsv in ipairs(m_tbNextList) do
		addObserver(obsv.eventName, obsv.func, obsv.once, obsv.obsvName)
	end
	m_tbNextList = {}
end

--注册一个通知
--[[desc: zhangqi, 20140518, 添加一个全局的通知回调
	args:
		sEventName: 事件类型
    	fnCallback: 回调的函数
    	bOnce: 是否只通知 1 次, 如果为nil或false始终保留；true, 调用一次后从通知列表中删除
    	sObsvName: 通知名称标识，避免重复注册; bOnce 为 true 时可以不指定 sObsvName
    return: 是否有返回值，返回值说明
—]]
function addObserver(sEventName, fnCallback, bOnce, sObsvName )
	assert(type(fnCallback) == "function", "observer callback must a function")
	if (not bOnce) then
		assert(sObsvName and sObsvName ~= "", "observer name needn't be nil and empty string")
	end

	logger:debug("addObserver: %s - %s - Lock = %s", sEventName, sObsvName, tostring(m_bPostLock))

	if (m_bPostLock) then
		addNextObserver(sEventName, fnCallback, bOnce, sObsvName)
		return -- 如果正在 postNofity 过程中将新的通知注册到下一个通知列表后直接返回
	end

	if (not m_tbNotifyList[sEventName]) then
		m_tbNotifyList[sEventName] = {}
	end

	local obsvrName = sObsvName or (sEventName .. table.count(m_tbNotifyList[sEventName]))
	if (m_tbNotifyList[sEventName][obsvrName]) then
		logger:debug("observer %s exist, return", obsvrName)
		return -- zhangqi, 2015-08-27, 如果指定了观察者名称且已存在同名的观察者回调则不重复添加
	end
	m_tbNotifyList[sEventName][obsvrName] = fnCallback
	m_tbKept[fnCallback] = bOnce

	logger:debug({addObserver_m_tbNotifyList = m_tbNotifyList})
end

--解除注册
function removeObserver( sEventName, sObsvName)
	if (m_tbNotifyList and m_tbNotifyList[sEventName]) then
		local func = m_tbNotifyList[sEventName][sObsvName]
		if (func) then
			logger:debug("removeObserver %s - %s", sEventName, sObsvName)
			m_tbKept[func] = nil
			m_tbNotifyList[sEventName][sObsvName] = nil
		end
	end
end

-- 触发注册的通知事件, 可以传递任意参数给注册的回调函数
function postNotify( sEventName, ... )
	logger:debug("postNotify: %s", tostring(sEventName))
	if (not m_tbNotifyList[sEventName]) then
		logger:debug("not found evnet %s", sEventName)
		logger:debug(m_tbNotifyList)
		return
	end

	m_bPostLock = true -- 2015-10-26, 开始通知回调时加锁

	logger:debug({["postNotify_" .. sEventName] = m_tbNotifyList[sEventName], m_bPostLock = tostring(m_bPostLock)})

	for name, func in pairs(m_tbNotifyList[sEventName]) do
		if (func and type(func) == "function") then
			func(...)
			if (m_tbKept[func]) then
				m_tbKept[func] = nil
				m_tbNotifyList[sEventName][name] = nil
			end
		end
	end
	logger:debug({postNotify_m_tbNotifyList = m_tbNotifyList})

	m_bPostLock = false -- 2015-10-26, 通知结束后解锁

	nextListMoveToNotifyList() -- 2015-10-26, 将下次通知列表中的回调注册到当前通知列表
end

-- 注册一个通知到 CCNotificationCenter
-- return: unregister 这个通知的方法
function addObserverToNotificationCenter( sObsvName, fnCallback )
	local obj = CCNode:create()
	obj:retain()

	m_ccNc:registerScriptObserver(obj, fnCallback, sObsvName)
	return function ( ... )
		logger:debug("CCNotificationCenter:unregister: %s", sObsvName)
		m_ccNc:unregisterScriptObserver(obj, sObsvName)
		obj:release()
	end
end

-- 给注册到CCNotificationCenter的某个observer发通知，sObsvName 为 observer 名称
function notifyNcObserver( sObsvName )
	return function ( ... )
		for obsName, func in pairs(m_NcObserver[sObsvName] or {}) do
			if (type(func) == "function") then
				logger:debug("notifyNcObserver: " .. sObsvName .. "-" .. obsName)
				func()
			end
		end
	end
end

-- 注册app切入后台和切回前台的通知到CCNotificationCenter
function addObserverForBackAndForegroud( ... )
	addObserverToNotificationCenter(NC_BACKGROUND, notifyNcObserver(NC_BACKGROUND))
	addObserverToNotificationCenter(NC_FOREGROUND, notifyNcObserver(NC_FOREGROUND))
end

-- 注册程序切换到后台的通知回调
function addObserverForBackground( sObsvName, fnCallback )
	m_NcObserver[NC_BACKGROUND][sObsvName] = fnCallback
	return function ( ... )
		m_NcObserver[NC_BACKGROUND][sObsvName] = nil
	end
end

-- 注册程序切换到前台的通知回调
function addObserverForForeground( sObsvName, fnCallback )
	m_NcObserver[NC_FOREGROUND][sObsvName] = fnCallback
	return function ( ... )
		m_NcObserver[NC_FOREGROUND][sObsvName] = nil
	end
end

		
