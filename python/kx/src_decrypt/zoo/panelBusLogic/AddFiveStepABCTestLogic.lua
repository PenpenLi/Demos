AddFiveStepABCTestLogic = {}

local platform = UserManager.getInstance().platform
local uid = UserManager.getInstance().uid
if not uid then
	uid = "12345"
end
local ABCTestFileKey = "ABCTestFileKey_" .. tostring(platform) .. "_u_".. tostring(uid) .. ".ds"

local TestType = {
	kNormal = "1",
	kCheater = "2",
	kSlowcoach = "3",
}

AddFiveStepABCTestLogic.testType = Localhost:readFromStorage(ABCTestFileKey)
--AddFiveStepABCTestLogic.testType = "2"

if not AddFiveStepABCTestLogic.testType then

	math.randomseed(os.time())
	math.random(3) --注意，这一行是需要的，lua自带的随机方法的第一个参数返回是不准确的，取第二次返回才是正态分布
	AddFiveStepABCTestLogic.testType = tostring( math.random(3) )

	Localhost:writeToStorage( tostring(AddFiveStepABCTestLogic.testType) , ABCTestFileKey )
end

function AddFiveStepABCTestLogic:dcLog(actType , levelId , source , propId)

	if __IOS then
		local usermanager = UserManager.getInstance()
		local userExtend = usermanager.userExtend
		local lastFuuuLogID = FUUUManager:getLastGameFuuuID()
		print("RRR   AddFiveStepABCTestLogic:dcLog   actType = " .. tostring(actType) 
			.. "   levelId = " .. tostring(levelId) 
			.. "   source = " .. tostring(source)
			.. "   testType = " .. tostring(self.testType)
			.. "   payUser = " .. tostring(userExtend.payUser) 
			.. "   lastFuuuLogID = " .. tostring(lastFuuuLogID))
		DcUtil:logAddFiveSteps(actType , levelId , source , self.testType , userExtend.payUser , propId , tostring(lastFuuuLogID))
	end
end

function AddFiveStepABCTestLogic:needShowCountdown()

	print("RRR   AddFiveStepABCTestLogic:needShowCountdown   testType = " .. tostring(self.testType) )

	if __ANDROID then
		return true
	end

	if self.testType == TestType.kSlowcoach then
		return false
	else
		return true
	end
end

function AddFiveStepABCTestLogic:needAutoClosePanel()

	if __ANDROID then
		return true
	end

	print("RRR   AddFiveStepABCTestLogic:needAutoClosePanel   testType = " .. tostring(self.testType) )
	if self.testType == TestType.kNormal then
		return true
	else
		return false
	end
end