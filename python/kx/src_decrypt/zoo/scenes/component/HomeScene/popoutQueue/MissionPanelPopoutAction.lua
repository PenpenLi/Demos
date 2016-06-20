MissionPanelPopoutAction = class(HomeScenePopoutAction)

function MissionPanelPopoutAction:ctor()
    print('MissionPanelPopoutAction')
end

function MissionPanelPopoutAction:popout( ... )
    local function closeCallback()
        self:next()
    end

	local configKey = "mission.todayAutoPopout.ds"

	local uid = UserManager.getInstance().uid
	if not uid then
		uid = "12345"
	end
	local data = Localhost:readFromStorage(configKey)

	if not data then
		data = {}
	end

	if not data["user_" .. uid] then
		data["user_" .. uid] = {}
	end 

	local nowDate = os.date("%x", Localhost:timeInSec())

	if not data["user_" .. uid]["time_" .. tostring(nowDate)] then

		local missionAutoLaunch = UserManager.getInstance().global.missionAutoLaunch or 0
		data["user_" .. uid]["time_" .. tostring(nowDate)] = tonumber(missionAutoLaunch)

	end

	local leftCount = data["user_" .. uid]["time_" .. tostring(nowDate)]

	--print("RRR    UserManager.getInstance().global.missionAutoLaunch " , UserManager.getInstance().global.missionAutoLaunch)
	--print("RRR   FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF   issionPanelPopoutAction:popout    leftCount = " , leftCount)

	if leftCount <= 0 then

		self:placeholder()
		closeCallback()

	else
		data["user_" .. uid]["time_" .. tostring(nowDate)] = leftCount - 1
		Localhost:writeToStorage( data , configKey )

		--print("RRR    getTopLevelId = " , UserManager:getInstance():getUserRef():getTopLevelId() , "  " , MaintenanceManager:getInstance():isEnabled("DaliyMission"))
		if UserManager:getInstance():getUserRef():getTopLevelId() >= 62 and MaintenanceManager:getInstance():isEnabled("DaliyMission") then
			MissionPanelLogic:tryCreateMission( 
				function () 
					MissionPanelLogic:openPanel( closeCallback )
				end , 
				function () 
					CommonTip:showTip(Localization:getInstance():getText("dis.connect.warning.tips")) 
				end , 
				false )
		else
			self:placeholder()
			closeCallback()
		end
	end

   
    --[[
    local panel = HomeScene:sharedInstance():tryPopoutMarkPanel(false, closeCallback)
    if not panel then
        self:placeholder()
        self:next()
    end
    ]]
end


function MissionPanelPopoutAction:getConditions( ... )
    return {"enter","enterForground","preActionNext"}
end