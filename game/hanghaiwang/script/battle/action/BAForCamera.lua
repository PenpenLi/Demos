

-- 用于 BSTree(行为选择树) 内部结束回调的节点
-- blackBoard.treeComplete 为回调函数
require (BATTLE_CLASS_NAME.class)
local BAForCamera = class("BAForCamera",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForCamera.pullUp 			= true
	BAForCamera.totalTime 		= 60
	BAForCamera.current 		= 0
	BAForCamera.zRaw			= 0
	BAForCamera.zTo				= 0
	BAForCamera.cameraZ			= 0
	BAForCamera.camera 			= nil
	BAForCamera.tween 			= nil
	------------------ functions -----------------------
 	function BAForCamera:start()
 		self.current = 0
 		local scene = CCDirector:sharedDirector():getRunningScene()
 		self.camera = scene:getCamera()
 		self.zRaw = 1
 		self.zTo  = 10 * 120


 		self.cameraZ = { value = 0}

 		self.tween = (require "script/battle/lib/tween").new(2, self.cameraZ, {value = -500})
		self:addToRender()
	end

	function BAForCamera:update( dt )
		
		local isComplete = self.tween:update(dt)
		Logger.debug("BAForCamera:update=" .. tostring(dt) .. " z=" .. tostring(self.cameraZ.value) .. " isComplete:" .. tostring(isComplete))
		if(self.cameraZ.value == 0) then self.cameraZ.value = 0.01 end
		
		self.camera:setEyeXYZ(0,0,self.cameraZ.value)
		self.camera:setCenterXYZ(0,0,self.cameraZ.value)
		if(isComplete) then
			self:complete()
		end
	end
return BAForCamera