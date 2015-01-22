-------------------------------------------------------------------------
--  Class include: SensorManager_Android, SensorManager_iOS, SensorManager
-------------------------------------------------------------------------

require "hecore.class"
-- require "zoo.util.AccelerationCallback"

--
-- SensorManager_Android ---------------------------------------------------------
--
local SPEED_SHRESHOLD = 3
local UPDATE_INTERVAL_TIME = 1

-- initialize
local instanceAndroid = nil
SensorManager_Android = {native = nil,
	lastUpdateTime = 0,
	lastX = 0,
	lastY = 0,
	lastZ = 0
}

function SensorManager_Android.getInstance()
	if not instanceAndroid then instanceAndroid = SensorManager_Android end
	return instanceAndroid
end

function SensorManager_Android:startListenerShake(shakeCallback) 
	print("SensorManager_Android:startListenerShake")
	if self.native == nil then
		self.native = luajava.bindClass("com.happyelements.hellolua.share.SensorService"):getInstance()
	end

	local sensorInterface = luajava.createProxy("com.happyelements.hellolua.share.SensorInterface", {
		onSensorChanged = function(x, y, z)
			-- local currentUpdateTime = os.time()
			-- local timeInterval = currentUpdateTime - self.lastUpdateTime

			-- print(string.format("timeInterval:%f", timeInterval))
			-- if (timeInterval < UPDATE_INTERVAL_TIME) then return end
			
			-- local deltaX = x - self.lastX
			-- local deltaY = y - self.lastY
			-- local deltaZ = z - self.lastZ

			-- self.lastX = x
			-- self.lastY = y
			-- self.lastZ = z

			-- local speed = math.sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ)
			-- print(string.format("deltaX:%f, deltaY:%f, deltaZ:%f", deltaX, deltaY, deltaZ))
			-- print(string.format("deltaX:speed:%f",speed))
			-- local THRESHOLD = UIConfigManager:sharedInstance():getConfig().ANDROID_ACCELERATION_THRESHOLD
			-- if speed >= THRESHOLD then
			-- 	print("deltaX:shake")
			-- 	if shakeCallback then shakeCallback() end
			-- end

			-- self.lastUpdateTime = currentUpdateTime


			-- local THRESHOLD = UIConfigManager:sharedInstance():getConfig().ANDROID_ACCELERATION_THRESHOLD
			-- print(string.format("x:%f, y:%f, z:%f", x, y, z))
			-- if math.abs(x) > THRESHOLD or math.abs(y) > THRESHOLD or math.abs(z) > THRESHOLD  then
				if shakeCallback then
					shakeCallback()
					shakeCallback = nil
				end
			-- end
		end
	})

	self.native:startListenerShake(sensorInterface)
end

function SensorManager_Android:stopListenerShake()
	if not self.native then return end
	self.native:stopListenerShake()
end

function SensorManager_Android:startVibrator()
	self.native:startVibrator()
end


--
-- SensorManager_IOS ---------------------------------------------------------
--
-- initialize
local instanceiOS = nil
SensorManager_iOS = {}
function SensorManager_iOS.getInstance()
	if not instanceiOS then instanceiOS = SensorManager_iOS end
	return instanceiOS
end

function SensorManager_iOS:startListenerShake(shakeCallback) 
	waxClass{"AccelerationCallback",NSObject,protocols={"AccelerationDelegate"}}
	function AccelerationCallback:onAccelerationChanged_y_z(x,y,z)
		local THRESHOLD = UIConfigManager:sharedInstance():getConfig().IOS_ACCELERATION_THRESHOLD
		if x > THRESHOLD or y > THRESHOLD or z > THRESHOLD then
			if shakeCallback then shakeCallback() end
		end
	end
	local callback = AccelerationCallback:init()
	SensorManager:getInstance():startMotionDetect(callback)
end

function SensorManager_iOS:stopListenerShake()
	SensorManager:getInstance():stopMotionDetect()
end

function SensorManager_iOS:startVibrator()

end

--
-- SensorManager_WP8 ---------------------------------------------------------
--
-- initialize
local instanceWP8 = nil
SensorManager_WP8 = {}
function SensorManager_WP8.getInstance()
	if not instanceWP8 then instanceWP8 = SensorManager_WP8 end
	return instanceWP8
end

function SensorManager_WP8:startListenerShake(shakeCallback) 
	local function callback(x, y, z)
		print("SensorManager callback " .. x .. " " .. y .. " " .. z)
    local THRESHOLD = 0.1
    if x > THRESHOLD or y > THRESHOLD or z > THRESHOLD then
      if shakeCallback then 
        Wp8Utils:Vibrate(500)
        shakeCallback({x=x, y=y, z=z}) 
      end
    end
	end
	SensorManager:GetInstance():StartListenerShake(callback)
end

function SensorManager_WP8:stopListenerShake()
	SensorManager:GetInstance():StopListenerShake()
end

function SensorManager_WP8:startVibrator()
  Wp8Utils:Vibrate(500)
end

--
-- SensorManager_All ---------------------------------------------------------
--
local instance = nil
SensorManager_All = {sensor = nil}

function SensorManager_All.getInstance()
	if not instance then 
		instance = SensorManager_All 

		if __ANDROID then
			instance.sensor = SensorManager_Android.getInstance()
		end

		if __IOS then
			instance.sensor = SensorManager_iOS.getInstance()
		end
    
		if __WP8 then
			instance.sensor = SensorManager_WP8.getInstance()
		end
	end
	return instance
end

function SensorManager_All:startListenerShake(shakeCallback) 
	print("SensorManager_All:startListenerShake")
	if self.sensor then
		self.sensor:startListenerShake(shakeCallback)
	end
end

function SensorManager_All:stopListenerShake()
	if self.sensor then
		self.sensor:stopListenerShake()
	end
end

function SensorManager_All:startVibrator()
	if self.sensor then
		self.sensor:startVibrator()
	end
end
