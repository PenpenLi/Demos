

require (BATTLE_CLASS_NAME.class)
-- local BARotationXBy = class("BARotationXBy",require(BATTLE_CLASS_NAME.BaseAction))
local BARotationXBy = class("BARotationXBy",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BARotationXBy.targets 						= nil 			-- 目标
	BARotationXBy.rotationBy 					= nil 			-- 角速度
	BARotationXBy.stateData 					= nil 			 
	-- BARotationXBy.tweener 					= nil
	BARotationXBy.total 						= nil			-- 总时间
	BARotationXBy.cost 							= nil			-- 当前耗时
	BARotationXBy.updateWithFrame 				= false
	------------------ functions -----------------------

	function BARotationXBy:ctor(...)
		self.super.ctor(self,...)
		frame , rotationBy ,targets ,updateWithFrame= ...
 		-- print("BARotationXBy:ctor",frame , rotationBy ,targets)
		if(frame and rotationBy and targets) then
			self:createWithFrame(frame,rotationBy,targets,updateWithFrame)
		end
	end

	function BARotationXBy:start( ... )
		if(self.targets and #self.targets > 0 and self.rotationBy ~= nil) then
			self.stateData = {}
			-- self.tween = (require "script/battle/lib/tween").new(2, self.cameraZ, {value = -500})
			for k,target in pairs(self.targets or {}) do
				local data 			= {}
				data.target 		= target
				data.from 			= target:getRotation()
				data.totalChange 	= self.rotationBy
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


	function BARotationXBy:addTargets( list )
		if(self.targets == nil) then
			self.targets = {}
		end
		for k,data in pairs(list or {}) do
			table.insert(self.targets,data)
		end

	end

	function BARotationXBy:create(time , rotationBy ,targets)
		assert(time,"time is nil")
		assert(rotationBy,"rotationBy is nil")
		-- print("BARotationXBy:create",time , rotationBy,targets)
		self.total  		= time
		self.rotationBy		= rotationBy 
		if(targets) then
			self.targets = targets
		end
	end

	function BARotationXBy:createWithFrame(frame,rotationBy,targets,updateWithFrame)
		self.updateWithFrame = updateWithFrame or false
		self:create(tonumber(frame) * BATTLE_CONST.FRAME_TIME,rotationBy,targets)
		-- self:create(tonumber(frame),scaleTo,targets)
	end


	function BARotationXBy:release( ... )
		self.super.release(self)
		self.targets  	= {}
		self.stateData 	= {}
	end


	function BARotationXBy:update(dt)
		 
		if(self.updateWithFrame == true) then
			dt = BATTLE_CONST.FRAME_TIME
		end
		
		if(self.cost >= self.total) then
			for k,data in pairs(self.stateData or {}) do
				 data.target:setRotation(data.from + data.totalChange)

			end
			self:complete()
			self:release()
		else
			for k,data in pairs(self.stateData or {}) do
				 data.target:setRotation(data.from + self.cost/self.total * data.totalChange )
				 -- print("BARotationXBy:",self.cost,self.total,data.from,data.totalChange)
			end
		end
		self.cost = self.cost + dt
		
		

	end



return BARotationXBy