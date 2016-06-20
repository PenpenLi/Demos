require "zoo.scenes.CheckPlayScene"
local mime = require("mime.core")
local simplejson = require("cjson")

CheckPlay = {}

--[[

checkPlayDataForm

[
	{
		"level":8,
		"replaySteps":[
			{"x2":4,"x1":3,"y2":3,"y1":3},
			{"x2":7,"x1":6,"y2":7,"y1":7},
			{"x2":5,"x1":4,"y2":4,"y1":4},
			{"x2":5,"x1":4,"y2":6,"y1":6},
			{"x2":4,"x1":4,"y2":6,"y1":5}
		],
		"hasDropBuff":false,
		"randomSeed":1388138716,
		"selectedItemsData":{}
	}
]


]]

CheckPlay.RESULT_ID = {
	
	kSuccess = 200 ,
	kCrash = -1 ,
	kUnknow = 0 ,
	kSwapFail = 1 ,
	kNotEnd = 2 ,
	--kNotEnd = 2 ,
}

CheckPlay.runningPlayDiffData = nil
CheckPlay.runningCheckId = 0
CheckPlay.checkIdLogMap = {}

CheckPlay.repeatForever = false

function CheckPlay:getCheckScene( playData )

	if not playData then return nil end

	print("RRR   CheckPlay:getCheckScene  playData.level = " , playData.level)
	print("RRR   CheckPlay:getCheckScene  playData = " , table.tostring(playData))
	-----------------------------兼容PlayDemo模式------------------------------
	local levelMeta = LevelMapManager.getInstance():getMeta( playData.level )
	if not levelMeta then 
		local testConfStr = DevTestLevelMapManager.getInstance():getConfig("test1.json")
		local testConf = table.deserialize(testConfStr)
		testConf.totalLevel = levelId
		LevelMapManager:getInstance():addDevMeta(testConf)
	end
	--------------------------------------------------------------------------

	local levelConfig = LevelDataManager.sharedLevelData():getLevelConfigByID( playData.level )

	print("RRR   CheckPlay:getCheckScene  222222222222222")
	return CheckPlayScene:createWithLevelConfig( levelConfig , playData )

end

function CheckPlay:getCheckPlayDiffTable()

	if self.checkIdLogMap[self.runningCheckId] then
		return nil
	else
		if not self.runningPlayDiffData then
			self.runningPlayDiffData = {}
		end

		self.checkIdLogMap[self.runningCheckId] = true

		return self.runningPlayDiffData
	end
end


function CheckPlay:check( checkId , diffData , playData )
	-- body
	print("RRR   CheckPlay:check  ====================================================================")
	print("RRR   CheckPlay:check  ====================================================================")
	print("RRR   CheckPlay:check  =========================       START       ========================")
	print("RRR   CheckPlay:check  ====================================================================")
	print("RRR   CheckPlay:check  ====================================================================")

	self.runningPlayDiffData = diffData
	self.runningPlayData = playData
	self.runningCheckId = checkId

	--local scene = ReplayGameScene:create(levelId, self.replayTable[target:getTag()])
	print("RRR   CheckPlay:check  111111111111111111")
	local scene = CheckPlay:getCheckScene( playData )
	print("RRR   CheckPlay:check  222222222222222222")
	scene:startCheckReplay()
	--Director:sharedDirector():pushScene(scene)

end

--[[


]]

function CheckPlay:checkResult( resultId , resultData )
	-- body
	self.checkIdLogMap[self.runningCheckId] = nil

	if CheckPlay.repeatForever then --这里面都是测试代码

		if resultData and resultData.totalScore and resultData.totalScore ~= 36055 then
			setTimeOut( function ()
				self:check( self.runningCheckId , self.runningPlayDiffData , self.runningPlayData )
			end , 5 )
		end
	end

	self:sendToServer(resultId,resultData)

	-- 等一会再收一条
	setTimeOut(function() 
		StartupConfig:getInstance():receive()
	end,3)
end


function CheckPlay:initParam(clientId,checkId,diff,gameData,clientMd5,score,version)
	self.clientId = clientId
	self.checkId = checkId
	self.clientMd5 = clientMd5
	self.score = score
	self.version = version
end


-- {
-- 	"cmd" : "heartbeat",
-- 	"argv": {"clientId": 1, "version": "1.32", "clientMd5": "7d0965ec2948b17d1f363c5e3b7275d5", "taskId": "56ea5eb3a82622ebdb1a2e4a"}
-- }
function CheckPlay:heardBeat()
	local ret = {}
	ret["cmd"] = "heartbeat"
	local tArgv = {}
	tArgv["clientId"] = self.clientId
	tArgv["version"] = self.version
	tArgv["clientMd5"] = self.clientMd5
	tArgv["taskId"] = self.checkId
	ret["argv"] = tArgv

	local tmp = simplejson.encode(ret)
	print("heardBeat sendToServer",tmp)
	StartupConfig:getInstance():send(tmp)
end

-- {
-- 	"cmd" : "report",
-- 	"argv": {"clientId": 1, "taskId": "56ea5eb3a82622ebdb1a2e4a", "resultCode" : 0, "resultMsg": ""}
-- }
function CheckPlay:sendToServer(resultId,resultData)
	print(">>>>>>>> check result >>>>>>>>",resultId,resultData)

	local ret = {}
	ret["cmd"] = "report"
	local tArgv = {}
	tArgv["clientId"] = self.clientId
	tArgv["taskId"] = self.checkId
	tArgv["resultCode"] = resultId
	tArgv["resultMsg"] = "yahoo!"
	ret["argv"] = tArgv

	local tmp = simplejson.encode(ret)
	print("report sendToServer",tmp)
	StartupConfig:getInstance():send(tmp)
end


-- ========= call from cpp =============
	-- std::string s_pid(pid);
	-- std::string s_diff(diff);
	-- std::string s_oplog(oplog);
	-- std::string s_clientMd5(clientMd5);
	-- std::string s_score(score);
	-- std::string s_version(version);
function checkInLua(clientId,checkId,diff,gameData,clientMd5,score,version)
	print(">>>>>>>>> start check in lua >>>>>>>>>>>>>>>>>>>")
	print("clientId",clientId)
	print("checkId",checkId)
	-- print("diff",diff)
	print("gameData",gameData)
	print("clientMd5",clientMd5)
	print("score",score)
	print("version",version)
	

	CheckPlay:initParam(clientId,checkId,diff,gameData,clientMd5,score,version)

	local dst = mime.unb64(diff)
	local diffJson
	if dst then
	    local filePath = HeResPathUtils:getUserDataPath() .. "/testlevel.inf"
	    local file, err = io.open(filePath, "wb")

	    if file and not err then
	        file:write(dst)
            file:flush()
            file:close()
        end
		local decodeContent = HeFileUtils:decodeFile(filePath)
		diffJson = table.deserialize(decodeContent)
		os.remove(filePath)
	end
	-- gameData
    local data = "{\"level\":1,\"replaySteps\":[{\"x2\":4,\"x1\":3,\"y2\":5,\"y1\":5},{\"x2\":4,\"x1\":4,\"y2\":6,\"y1\":5},{\"x2\":5,\"x1\":5,\"y2\":7,\"y1\":6},{\"x2\":3,\"x1\":2,\"y2\":3,\"y1\":3}],\"hasDropBuff\":false,\"randomSeed\":1461830956,\"selectedItemsData\":{}}"
    tData = simplejson.decode(gameData)

    CheckPlay:check(checkId,diffJson,tData)

	return true
end
