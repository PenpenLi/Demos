require "zoo.data.DataRef"

DailyDataLocalLogic = class()

--http://svn.happyelements.net/repos/svndata2/animal/java/trunk/animal-service/src/main/java/com/happyelements/animal/service/impl/DailyDataServiceImpl.java
function DailyDataLocalLogic:isFirstDailyDigg( uid )
	local user = UserService.getInstance().user
	return user.dailyData.diggerCount == 0
end

function DailyDataLocalLogic:getDailyDiggCount( uid )
	local user = UserService.getInstance().user
	return user.dailyData.diggerCount
end