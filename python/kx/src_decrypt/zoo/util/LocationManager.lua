-------------------------------------------------------------------------
--  Class include: LocationManager_Android, LocationManager_iOS, LocationManager
-------------------------------------------------------------------------

require "hecore.class"

--
-- LocationManager_Android ---------------------------------------------------------
--
-- initialize
local instanceAndroid = nil
LocationManager_Android = {native = nil,longitude = 0,latitude = 0}

function LocationManager_Android.getInstance()
	if not instanceAndroid then instanceAndroid = LocationManager_Android end
	return instanceAndroid
end

-- function LocationManager_Android:initLocationManager()
-- 	self.native = luajava.bindClass("com.happyelements.hellolua.share.LocationService"):getInstance()
-- end

-- function LocationManager_Android:startUpdatingLocation()
-- 	local locationInterface = luajava.createProxy("com.happyelements.hellolua.share.LocationInterface", {
--     	onLocationChanged = function(longitude,latitude)
--         	self.longitude = longitude
--         	self.latitude = latitude
--       	end
--     })
-- 	self.native:requestLocationUpdate(locationInterface)
-- end

function LocationManager_Android:initLocationManager()
	self.native = luajava.bindClass("com.happyelements.hellolua.baidu.location.BDLocationService"):getInstance()
end

function LocationManager_Android:startUpdatingLocation()
	local locationInterface = luajava.createProxy("com.happyelements.hellolua.baidu.location.BDLocationInterface", {
			onReceiveLocation = function(longitude,latitude)
				self.longitude = longitude
				self.latitude = latitude
				print(string.format("self.longitude:%f",self.longitude))
				print(string.format("self.latitude:%f",self.latitude))
			end
		})

	self.native:requestLocation(locationInterface)
end

function LocationManager_Android:stopUpdatingLocation()
	self.native:stop()
end

function LocationManager_Android:getLongitude()
	return self.longitude
end

function LocationManager_Android:getLatitude()
	return self.latitude
end


--
-- LocationManager_iOS ---------------------------------------------------------
--
-- initialize
local instanceiOS = nil
LocationManager_iOS = {}

function LocationManager_iOS.getInstance()
	if not instanceiOS then instanceiOS = LocationManager_iOS end
	return instanceiOS
end

function LocationManager_iOS:initLocationManager()
	LocationManager:getInstance():initLocationManager()
end

function LocationManager_iOS:startUpdatingLocation()
	LocationManager:getInstance():startUpdatingLocation()
end

function LocationManager_iOS:stopUpdatingLocation()
	LocationManager:getInstance():stopUpdatingLocation()
end

function LocationManager_iOS:getLongitude()
	return LocationManager:getInstance():getLongitude()
end

function LocationManager_iOS:getLatitude()
	return LocationManager:getInstance():getLatitude()
end

--
-- LocationManager_WP8 ---------------------------------------------------------
--
-- initialize
local instanceWp8 = nil
LocationManager_WP8 = {}

function LocationManager_WP8.getInstance()
	if not instanceWp8 then 
    instanceWp8 = LocationManager_WP8 
  end
	return instanceWp8
end

function LocationManager_WP8:initLocationManager()
  -- do nothing
end

function LocationManager_WP8:startUpdatingLocation()
	LocationManager:GetInstance():StartUpdatingLocation(false)
end

function LocationManager_WP8:stopUpdatingLocation()
	-- do nothing
end

function LocationManager_WP8:getLongitude()
	return LocationManager:GetInstance():GetLongitude()
end

function LocationManager_WP8:getLatitude()
	return LocationManager:GetInstance():GetLatitude()
end

--
-- LocationManager ---------------------------------------------------------
--
local instance = nil
LocationManager_All = {location = nil}

function LocationManager_All.getInstance()
	if not instance then 
		instance = LocationManager_All 
		if __IOS then
			instance.location = LocationManager_iOS.getInstance()
		end

		if __ANDROID then
			instance.location = LocationManager_Android.getInstance()
		end
    
		if __WP8 then
			instance.location = LocationManager_WP8.getInstance()
		end
	end
	return instance
end

function LocationManager_All:initLocationManager()
	if self.location then
		self.location:initLocationManager()
	end
end

function LocationManager_All:startUpdatingLocation()
	if self.location then
		self.location:startUpdatingLocation()
	end
end

function LocationManager_All:stopUpdatingLocation()
	if self.location then
		self.location:stopUpdatingLocation()
	end
end

function LocationManager_All:getLongitude()
	if self.location then
		return self.location:getLongitude()
	end
end

function LocationManager_All:getLatitude()
	if self.location then
		return self.location:getLatitude()
	end
end


