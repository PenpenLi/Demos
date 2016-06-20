
require (BATTLE_CLASS_NAME.class)
local BAFadeTo = class("BAFadeTo",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAFadeTo.targets 					= nil 			-- 目标
	BAFadeTo.alphaTo 					= nil 			-- alphato
	BAFadeTo.stateData 					= nil			-- 数据
	-- BAFadeTo.tweener 					= nil
	BAFadeTo.total 						= nil			-- 总时间
	BAFadeTo.cost 						= nil			-- 当前耗时
	------------------ functions -----------------------

	function BAFadeTo:ctor(...)
		self.super.ctor(self,...)

		-- local temp = {...}
		-- for k,data in pairs(temp) do
		-- 	print("--- BAFadeTo:",tostring(data))
		-- end
		time,alphaTo,targets = ...
		if(time > 0 and alphaTo ~= nil and targets ~= nil) then

			self:createWithFrame(time,alphaTo,targets)
		end
	end

	function BAFadeTo:start( ... )

		-- print("--- BAFadeTo star:",1)
		if(self.targets and #self.targets > 0 and self.alphaTo ~= nil and self.disposed ~= true) then
			self.stateData = {}
			-- print("--- BAFadeTo star:",2)
			-- self.tween = (require "script/battle/lib/tween").new(2, self.cameraZ, {value = -500})
			for k,target in pairs(self.targets or {}) do
				local data 	= {}
				if(target and target.getOpacity) then
					data.target = target
					data.from 	= target:getOpacity()/255
					data.to 	= self.alphaTo
					data.total 	= self.alphaTo - data.from
					-- data.get
					table.insert(self.stateData,data)
				end
			end
			self.cost   	= 0
			self:addToRender()
		else
			-- print("--- BAFadeTo star:",3)
			self:complete()
		end
	end

	function BAFadeTo:resetTargets( list )
		self.targets = {}
		self:addTargets(list)
	end


	function BAFadeTo:addTargets( list )
		if(self.targets == nil) then
			self.targets = {}
		end
		for k,data in pairs(list or {}) do
			table.insert(self.targets,data)
		end

	end

	function addTarget( target )
		
		if(target) then
			
			if(self.targets == nil) then
				self.targets = {}
			end
			table.insert(self.targets,data)
		end
	end


	function BAFadeTo:create(time , alphaTo ,targets)
		assert(time,"time is nil")
		assert(alphaTo,"alphaTo is nil")
		
		-- print("--- BAFadeTo create:",time,alphaTo)
		self.total  		= time
		self.alphaTo		= alphaTo 
		if(targets) then
			self.targets = targets
		end
	end

	function BAFadeTo:createWithFrame(frame,alphaTo,targets)
		-- print("--- BAFadeTo createWithFrame:",tostring(frame),tostring(alphaTo),tostring(targets))
		self:create(tonumber(frame) * BATTLE_CONST.FRAME_TIME,alphaTo,targets)
		-- self:create(tonumber(frame),alphaTo,targets)
	end


	function BAFadeTo:release( ... )
		self.super.release(self)
		self.targets  	= {}
		self.stateData 	= {}
	end


	function BAFadeTo:update(dt)
		
		-- self.cost = self.cost + 1
		
		-- print("-- BAFadeTo update",self.cost,self.total)
		local num 
		if(self.cost >= self.total) then
			for k,data in pairs(self.stateData or {}) do
				num = data.to
				if(num > 1) then num = 1 end
				if(num < 0) then num = 0 end
				 data.target:setOpacity(num * 255)
			end
			self:complete()
			self:release()
		else
			
			for k,data in pairs(self.stateData or {}) do
				
				-- print("-- BAFadeTo ",data.from,self.cost,self.total)
				num = data.from + self.cost/self.total * data.total
				if(num > 1) then num = 1 end
				if(num < 0 ) then num = 0 end

				-- print("-- BAFadeTo ",num * 255)
				 data.target:setOpacity( num * 255)
			end
		end
		
		self.cost = self.cost + dt
		
		

	end



return BAFadeTo