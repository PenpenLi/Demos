
require (BATTLE_CLASS_NAME.class)
-- local BAScaleTo = class("BAScaleTo",require(BATTLE_CLASS_NAME.BaseAction))
local BAScaleTo = class("BAScaleTo",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAScaleTo.targets 						= nil 			-- 目标
	BAScaleTo.scaleTo 						= nil 			-- scaleTo
	BAScaleTo.stateData 					= nil			-- 数据
	-- BAScaleTo.tweener 					= nil
	BAScaleTo.total 						= nil			-- 总时间
	BAScaleTo.cost 							= nil			-- 当前耗时
	------------------ functions -----------------------

	function BAScaleTo:ctor(...)
		self.super.ctor(self,...)
 
		frame , scaleTo ,targets= ...
		if(frame and scaleTo and targets) then
			self:createWithFrame(frame,scaleTo,targets)
		end
	end

	function BAScaleTo:start( ... )
		if(self.targets and #self.targets > 0 and self.scaleTo ~= nil) then
			self.stateData = {}
			-- self.tween = (require "script/battle/lib/tween").new(2, self.cameraZ, {value = -500})
			for k,target in pairs(self.targets or {}) do
				local data 	= {}
				data.target = target
				data.from 	= target:getScale()
				data.to 	= self.scaleTo
				data.total 	= self.scaleTo - data.from
				-- data.get
				table.insert(self.stateData,data)
			end
			self.cost   	= 0
			self:addToRender()
		else
			self:complete()
		end
	end

	function resetTargets( list )
		self.targets = {}
		self:addTargets(list)
	end


	function BAScaleTo:addTargets( list )
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


	function BAScaleTo:create(time , scaleTo ,targets)
		assert(time,"time is nil")
		assert(scaleTo,"scaleTo is nil")
		self.total  		= time
		self.scaleTo		= scaleTo 
		if(targets) then
			self.targets = targets
		end
	end

	function BAScaleTo:createWithFrame(frame,scaleTo,targets)
		self:create(tonumber(frame) * BATTLE_CONST.FRAME_TIME,scaleTo,targets)
		-- self:create(tonumber(frame),scaleTo,targets)
	end


	function BAScaleTo:release( ... )
		self.super.release(self)
		self.targets  	= {}
		self.stateData 	= {}
	end


	function BAScaleTo:update(dt)
		 
		-- print("BAScaleTo:",self.cost,self.total)
		
		if(self.cost >= self.total) then
			for k,data in pairs(self.stateData or {}) do
				 data.target:setScale(data.to)
			end
			self:complete()
			self:release()
		else
			for k,data in pairs(self.stateData or {}) do
				 -- print("BAScaleTo set value:",data.from + self.cost/self.total * data.total)
				 data.target:setScale(data.from + self.cost/self.total * data.total)
			end
		end
		self.cost = self.cost + dt
		-- self.cost = self.cost + 1
		
		

	end



return BAScaleTo