

require (BATTLE_CLASS_NAME.class)
local BAMoveBy = class("BAMoveBy",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAMoveBy.changed 						= nil -- 总改变量
	BAMoveBy.targets 						= nil -- 目标
	BAMoveBy.stateData 						= nil			-- 数据
	BAMoveBy.total 							= nil			-- 总时间
	BAMoveBy.cost 							= nil			-- 当前耗时
	BAMoveBy.moveBy							= nil 
	BAMoveBy.updateWithFrame 				= false
	------------------ functions -----------------------

	function BAMoveBy:ctor(...)
		self.super.ctor(self,...)
 		self.updateWithFrame = false
		frame,moveBy,targets,updateWithFrame = ...
		if(frame and moveBy and targets) then
			-- print("--BAMoveBy 1:",frame)
			self:createWithFrame(frame,moveBy,targets,updateWithFrame)
		end
	end

	function BAMoveBy:start( ... )
		-- print("--BAMoveBy 1.1",self.targets,#self.targets,self.moveBy)
		if(self.targets and #self.targets > 0 and self.moveBy ~= nil) then
			self.stateData = {}
			-- print("--BAMoveBy 1.2",self.targets,self.moveBy)
			-- self.tween = (require "script/battle/lib/tween").new(2, self.cameraZ, {value = -500})
			for k,target in pairs(self.targets or {}) do
				local data 	= {}
				data.target = target
				data.from 	= {target:getPositionX(),target:getPositionY()}
				data.to 	= {data.from[1] + self.moveBy[1],data.from[2] + self.moveBy[2]}
				data.total 	= self.moveBy
				-- data.get
				table.insert(self.stateData,data)
			end
			self.cost   	= 0
			self:addToRender()
		else
			-- print("--BAMoveBy 1.3",self.targets,self.moveBy)
			self:complete()
		end
	end

	function resetTargets( list )
		self.targets = {}
		self:addTargets(list)
	end


	function BAMoveBy:addTargets( list )
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


	function BAMoveBy:create(time , moveBy ,targets)
		assert(time,"time is nil")
		assert(moveBy,"moveBy is nil")

		assert(moveBy[1],"moveBy[1] is nil")
		assert(moveBy[2],"moveBy[2] is nil")

		self.total  		= time
		self.moveBy			= moveBy 
		if(targets) then
			self.targets = targets
		end
	end

	function BAMoveBy:createWithFrame(frame,moveBy,targets,updateWithFrame)
		self.updateWithFrame = updateWithFrame or false
		self:create(tonumber(frame) * BATTLE_CONST.FRAME_TIME,moveBy,targets)
		-- self:create(tonumber(frame),moveBy,targets)
	end


	function BAMoveBy:release( ... )
		self.super.release(self)
		self.targets  	= {}
		self.stateData 	= {}
	end


	function BAMoveBy:update(dt)
		-- self.cost = self.cost + 1 
		if(self.updateWithFrame == true) then
			dt = BATTLE_CONST.FRAME_TIME
		end
		if(self.cost >= self.total) then
			for k,data in pairs(self.stateData or {}) do
				 data.target:setPosition(data.to[1],data.to[2])
			end
			self:complete()
			self:release()
		else
			for k,data in pairs(self.stateData or {}) do
				 local percent = self.cost/self.total
				 -- print("BAMoveBy:update:",data.from[1] + percent * data.total[1],data.from[2] + percent * data.total[2])
				 data.target:setPosition(data.from[1] + percent * data.total[1],data.from[2] + percent * data.total[2])
			end
		end
		self.cost = self.cost + dt
		-- self.cost = self.cost + dt 

		
		

	end
return BAMoveBy