-- FileName: ExceptionCollect.lua
-- Author: MaBingtao
-- Date: 2014-12-24
-- Purpose: function description of module
require "script/module/public/class"
ExceptionCollect = class("ExceptionCollect")
ExceptionCollect._index = ExceptionCollect

local EC_instance = nil


---self.all_action = {  actionName = { params = {} , statusList = {} , info = {} }  }

-- 模块局部变量 --
function ExceptionCollect:getInstance()
	if EC_instance == nil then
	 	EC_instance = ExceptionCollect:new()
	end
	return EC_instance
end

function ExceptionCollect:ctor()
	logger:trace("ExceptionCollect:ctor")
	self.filePath = CCFileUtils:sharedFileUtils():getWritablePath() .. "ExceptionCollect.txt"
	self.all_action = {}
end

---
-- 检测上次存在的未完成动作，发送给服务器
-- 如果一个记录的action有start没有finish 则认这个action失败
---
function ExceptionCollect:checkLastException()
	logger:trace("ExceptionCollect:checkLastException")
	if (g_debug_mode) then
		return
	end

	logger:debug({ExceptionCollect_filePath = self.filePath})

	-- 读取文件
	local e_str = io.readfile( self.filePath )
	if (e_str == nil) then
		return
	end
	logger:debug("e_str : %s" , e_str)
	--- 载入成为lua table
	local all_info = table.loadstring(e_str)
	logger:debug(all_info)
	
	--- 是否存在只有start没有finish的
	-- local needSendInfo = true
	
	-- zhangqi, 2015-05-18, 有时因为异常信息文件写入问题导致Lua格式错误, 最终导致语法错误
	-- 格式错误时 all_info 为 nil, 添加 "or {}" 做一个容错处理，避免 nil 报错
	-- for k, action_info in pairs(all_info or {}) do
	-- 	local statusList = action_info.statusList
	-- 	--- 每个action的最后一个status 是不是finish
	-- 	if ( statusList[#statusList] ~= "finish") then
	-- 		needSendInfo = true
	-- 		break
	-- 	end
	-- end

	-- zhangqi, 2016-01-17, 检查异常信息中是否有没有finish的
	local needSendInfo = self:hasNoFinish(all_info)

	if (needSendInfo == true) then
		logger:debug("send ExceptionCollect info")
		loggerHttp:fatal( e_str ) -- loggerHttp，全局的logger, 通过http协议把异常信息发送到web服务
	end
	--删除文件
	os.remove(self.filePath)
	logger:debug("remove ExceptionCollect file:" .. self.filePath)
end

-- zhangqi, 2016-01-17, 从传入的all_action删除finish的action
-- return: 如果all_action中有没有finish的项就返回true，否则返回false
function ExceptionCollect:hasNoFinish( all_action )
	local needSendInfo = false

	for k, action_info in pairs(all_action or {}) do
		local statusList = action_info.statusList
		--- 每个action的最后一个status 是不是finish
		if ( statusList[#statusList] == "finish") then
			all_action[k] = nil
		else
			needSendInfo = true
		end
	end

	return needSendInfo
end

function ExceptionCollect:writeFile()
	if (self.filePath) then
		self:hasNoFinish(self.all_action) -- zhangqi, 2016-01-17, 先删除finish的表元素，减少需要写入的内容
		local str = table.tostring( self.all_action )
		io.writefile( self.filePath, str, "w+" )
	end
end


-- 动作开始
-- params 可以是nil 动作开始的参数 比如登陆动作的用户信息或者pid或者环境信息
function ExceptionCollect:start( _action_name , _params)
	if (g_debug_mode) then
		return
	end

	if ( _action_name == nil ) then
		logger:fatal("ExceptionCollect:start : _action_name == nil")
		return
	end

	local actionTbl = {}
	
	actionTbl.statusList = { "start" }
	actionTbl.info = {}
	actionTbl.time = os.time()
	actionTbl.index=#self.all_action
	if ( _params ~= nil) then
		actionTbl.params = _params
	end

	self.all_action[_action_name] = actionTbl

	self:writeFile()
end

---动作结束
function ExceptionCollect:finish( _action_name )
	if (g_debug_mode) then
		return
	end

	if (_action_name == nil) then
		logger:warn("ExceptionCollect:finish : _action_name == nil")
		return
	end
	
	if ( self.all_action[_action_name] == nil) then
		logger:warn("not found action for name : %s" , _action_name)
		return
	end
	local list = self.all_action[_action_name].statusList

	table.insert(list , "finish")
	
	self:writeFile()
end

-- 动作中间信息 
-- _info  这个动作在发生中间产生的信息
function ExceptionCollect:info( _action_name  , _info )
	if (g_debug_mode) then
		return
	end
	
	if (_action_name == nil) then
		logger:warn("ExceptionCollect:info : _action_name == nil")
		return
	end
	
	if ( self.all_action[_action_name] == nil) then
		logger:warn("not found action for name : %s" , _action_name)
		return
	end
	local info = self.all_action[_action_name].info

	table.insert(info , _info)

	self:writeFile()
end
