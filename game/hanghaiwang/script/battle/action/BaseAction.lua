require (BATTLE_CLASS_NAME.class)
local BaseAction = class("BaseAction")

 
	------------------ properties ----------------------
	
	BaseAction.calllerBacker		= nil -- 回调
	BaseAction.blockBoard			= nil -- 黑板数据	
	BaseAction.totalTime			= 0	  -- 总时间
	BaseAction.costTime				= 0
	BaseAction.handMode				= false   -- 手动更新模式,如果等于true 则需要外部调用update函数,不会自己更新
	BaseAction.weight 				= 0
	BaseAction.disposed 			= false
	------------------ functions -----------------------

	function BaseAction:ctor()
		--BaseAction.super:ctor()
		ObjectTool.setProperties(self)
		--__instanceName					= 1
		self.calllerBacker			= require(BATTLE_CLASS_NAME.BattelEvtCallBacker).new()	
	end

	function BaseAction:init( data )
		
		if data.weight ~= nil then 
			self.weight = data.weight
		else
			self.weight = 0
		end

	end

	-- 运行函数
	function BaseAction:start(data)


	end

 
	-- 更新函数
	function BaseAction:update(dt)
		
	end

	function BaseAction:runCompleteCall(data)
		-- --print("BaseAction:runCompleteCall：",data)
		self.calllerBacker:runCompleteCallBack(self,data)
	end

	function BaseAction:addCallBacker(target,callFunction)
		assert(self.calllerBacker,"== actionName:" .. tostring(self.name))
		self.calllerBacker:addCallBacker(target,callFunction)
	end

	-- function BaseAction:runKeyFrameCall(data)
	-- 	self.calllerBacker:runKeyFrameCallBack(self,data)
	-- end

	function BaseAction:isOK( ... )
		return self.disposed ~= true
	end


	function BaseAction:complete()
		-- if(self.disposed ~= true) then
			self:removeFromRender()					-- 执行
			self:runCompleteCall()					-- 执行完毕回调
		-- end
	end
	
	function BaseAction:addToRender()
		if self.handMode == false then BattleActionRender.addAction(self) end
	end
	
	function BaseAction:removeFromRender()
		BattleActionRender.removeAction(self)
	end

	function BaseAction:sortByWeight(list)
		  
		    table.sort(
		    			list, function (a,b) return tonumber(a.weight) < tonumber(b.weight) end
		        	   )

	end
 

	function BaseAction:release()
			-- 释放函数
		self.disposed 	= true
		self:removeFromRender()					-- 执行
		self.calllerBacker:clearAll()
		self.blockBoard	= nil
	end

return BaseAction

