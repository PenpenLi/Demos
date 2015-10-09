require "main.config.ConstConfig";
require "main.controller.notification.MainSceneNotification";
--基本信息
Handler_3_1 = class(MacroCommand);

function Handler_3_1:execute()

    local userProxy = self:retrieveProxy(UserProxy.name);
    local familyProxy = self:retrieveProxy(FamilyProxy.name);
	self.storyLineProxy = self:retrieveProxy(StoryLineProxy.name);
    
    userProxy.userId = recvTable["UserId"];
    userProxy.career = recvTable["Career"];
    userProxy.userName = recvTable["UserName"];
    GameData.userName = userProxy.userName
    userProxy.familyId = recvTable["FamilyId"];
    userProxy.familyName = recvTable["FamilyName"];
    userProxy.familyPositionId = recvTable["FamilyPositionId"];
	  userProxy.vip = recvTable["Vip"];
    userProxy.nobility = recvTable["Nobility"];
    print("Nobility", recvTable["Nobility"])
    self.storyLineProxy.lastStrongPointId = recvTable["LastStrongPointId"];
    self.storyLineProxy.lastStrongPointState = recvTable["State"];
    userProxy.mainGeneralLevel = recvTable["Level"];
    userProxy.level = recvTable["Level"];
    userProxy.experience = recvTable["Experience"];
    print("Experience", recvTable["Experience"])
    userProxy.transforId = recvTable["TransforId"];
    print("userProxy.transforId", userProxy.transforId)

    userProxy.zodiacId = recvTable["ZodiacId"];
    print("userProxy.zodiacId", userProxy.zodiacId)

    familyProxy:setFamilyLevel(recvTable["FamilyLevel"]);
    print("FamilyLevel", recvTable["FamilyLevel"])

    print("userProxy.mainGeneralLevel", userProxy:getLevel())
    GameVar.tutorStage = recvTable["Stage"];
    GameVar.tutorSmallStep = recvTable["Step"];

    GameVar.tuturReaccess = true;

    log("GameVar.tutorStage,GameVar.tutorSmallStep:".. GameVar.tutorStage .. "," .. GameVar.tutorSmallStep)

    print("storyLineProxy.lastStrongPointId,storyLineProxy.lastStrongPointState",self.storyLineProxy.lastStrongPointId, self.storyLineProxy.lastStrongPointState)
    self:setOpenedStoryLines();

    -- self:checkBattleStrongPointId(self.storyLineProxy.lastStrongPointId);

    GameData.userID = userProxy.userId

    userProxy:refreshVipLevel();

    if "" == userProxy.userName then
        userProxy.userName = "侠士";
    end
    ConstConfig.USER_NAME = userProxy.userName;

    userProxy.generalArray = {};
    local generalArray = recvTable["GeneralIdTableArray"];
    for k,v in pairs(recvTable["GeneralIdTableArray"]) do
       table.insert(userProxy.generalArray, v);
    end

    self:checkTianXiangId();

    self:refreshGuanzhi();

    -- GameVar.tutorStage = 1014
    -- GameVar.tutorStage = 1010
    -- GameVar.tutorSmallStep = 0
    -- GameVar.tutorStage = 1017 ---- 99999
    -- self.openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name);
    -- self.openFunctionProxy.newOpenFunctionId = 45;
    --  GameVar.tutorStage = 2010
   --  GameVar.tutorSmallStep = 200605
    -- GameVar.tutorStage = 2006--99999
    -- sendServerTutorMsg({})

    -- self:checkRedDot() -- 检查小红点

end

-- function Handler_3_1:checkRedDot()
--   local functionId = 0

--   if 
--   -- 检查是否有需要刷新红点的
--   self:addSubCommand(JudgeReddotCommand);
--   self:complete({data={type=FunctionConfig.FUNCTION_ID_68}}); 
-- end

function Handler_3_1:setOpenedStoryLines()
    local userProxy = self:retrieveProxy(UserProxy.name);
   if self.storyLineProxy.lastStrongPointId ~= 0 then
      self.storyLineProxy.storyLineId = analysis("Juqing_Guanka", self.storyLineProxy.lastStrongPointId, "storyId")
      self.storyLineProxy:setPassStrongPointData();
      self.storyLineProxy.openedStorylineIds = {};
      local currentStoryLineId = self.storyLineProxy.storyLineId;

      while (currentStoryLineId ~= 0 and currentStoryLineId) do
        table.insert(self.storyLineProxy.openedStorylineIds, 1, currentStoryLineId)

        if analysisHas("Juqing_Juqing", currentStoryLineId) then
          currentStoryLineId = analysis("Juqing_Juqing", currentStoryLineId, "parent")
          if currentStoryLineId ~= 0 then
            local strongPoints = analysisByName("Juqing_Guanka", "storyId", currentStoryLineId)
            for k, v in pairs(strongPoints)do
              local strongPointData = {StrongPointId = v.id, State= 1};
              local key = "key_" .. v.id;
              self.storyLineProxy.strongPointArray[key] = strongPointData;
            end
          end
        else
          break;
        end
      end
    else
        self.storyLineProxy.openedStorylineIds = {};
        self.storyLineProxy.storyLineId = 10001;
        self.storyLineProxy.openedStorylineIds[1] = 10001;
        self.storyLineProxy:setAllStrongPointNotOpen();

    end

    -- for k, v in pairs(self.storyLineProxy.strongPointArray) do
    --   print("k, v ", k, v.StrongPointId, v.State)
    -- end
end


-- function Handler_3_1:checkBattleStrongPointId(strongPointId)
--   if GameVar.tutorStage == 0 or GameVar.tutorStage == TutorConfig.STAGE_99999 then
--     return;
--   elseif strongPointId == 10001001 then
--     if GameVar.tutorStage ~= TutorConfig.STAGE_1002 then
--       GameVar.tutorStage = TutorConfig.STAGE_2000;
--     end
--     return;
--   end


--   local parentStrongPointId
--   local parentPo = analysis("Juqing_Guanka", strongPointId);--, "parentId"
--   if parentPo.parentId == 0 then
--     local parentStoryLineId = analysis("Juqing_Juqing", parentPo.storyId, "parent")
--     local strongPoints = analysisByName("Juqing_Guanka", "storyId", parentStoryLineId)
--     local biggestStrongPointId
--     for k, v in pairs(strongPoints) do
--       if not biggestStrongPointId then
--         biggestStrongPointId = v.id;
--       elseif v.id > biggestStrongPointId then
--         biggestStrongPointId = v.id;
--       end
--     end

--     parentStrongPointId = biggestStrongPointId;
--   else
--     parentStrongPointId = parentPo.parentId
--   end
--   print("parentStrongPointId", parentStrongPointId)

--   local xinshouPos = analysisByName("Xinshouyindao_Xinshou","jieduan", GameVar.tutorStage)
--   local tempStrongPointId;
--   for k, v in pairs(xinshouPos) do
--     if v.guanqiaid ~= 0 then
--       tempStrongPointId = v.guanqiaid;
--       break;
--     end
--   end
--   if tempStrongPointId ~= parentStrongPointId then
--     GameVar.tutorStage = TutorConfig.STAGE_2000
--   end
-- end
function Handler_3_1:setActiveTianXiangData()
   local strongPoints = analysisByName("Juqing_Guanka", "storyId", self.storyLineId)
   local tempTables = {};
   for k, v in pairs(strongPoints) do
      table.insert(tempTables, v)
   end
   local function sortFun(a, b)
      if a.order< b.order then
        return true;
      else
        return false;
      end
   end
   table.sort(tempTables, sortFun)

   local lastStrongPointPo = analysis("Juqing_Guanka", self.lastStrongPointId)  
   for i = #tempTables, 1, -1 do
      local tempStrongPointId = tempTables[i].id;
      local tempState;
      if tempTables[i].order < lastStrongPointPo.order then
        tempState = 1;
      elseif tempTables[i].order > lastStrongPointPo.order then
        tempState = 2;
      else
        tempState = self.lastStrongPointState;
      end
      local strongPointData = {StrongPointId = tempStrongPointId, State = tempState};
      self.strongPointArray["key_" .. tempStrongPointId] = strongPointData
   end

end
function Handler_3_1:checkTianXiangId()
    -- if userProxy.zodiacId 
    local userProxy = self:retrieveProxy(UserProxy.name);
    if not userProxy.zodiacId then userProxy.zodiacId = 0 end
    if userProxy.zodiacId == 0 then 
      table.insert(userProxy.tianXiangZuIds, 1);
      return
    end
    local tianxiangPo = analysis("Zhujiao_Tianxiangshouhudian",userProxy.zodiacId)
    local tianxiangPos = analysisByName("Zhujiao_Tianxiangshouhudian", "group", tianxiangPo.group);

    local isLast = true;
    for k, v in pairs(tianxiangPos) do
        if v.id <= userProxy.zodiacId then
            table.insert(userProxy.tianXiangIds, v.id);
        else
            isLast = false;
        end
    end

    for i = 1, tianxiangPo.group - 1, 1 do
        table.insert(userProxy.tianXiangZuIds, i);
        local tempPos = analysisByName("Zhujiao_Tianxiangshouhudian", "group", i);
        for k, v in pairs(tempPos) do
            table.insert(userProxy.tianXiangIds, v.id);
        end
    end

    table.insert(userProxy.tianXiangZuIds, tianxiangPo.group);
    if isLast and analysis("Zhujiao_Tianxiangshouhudian",userProxy.zodiacId, "id2") ~= 0  then
        table.insert(userProxy.tianXiangZuIds, tianxiangPo.group + 1);
    end
    for k, v in pairs(userProxy.tianXiangZuIds)do
        print("ZuId", v)
    end
end
function Handler_3_1:refreshGuanzhi()
    if GuanzhiPopupMediator then
        local mediator = self:retrieveMediator(GuanzhiPopupMediator.name);
        if mediator then
            mediator:refreshUpdate();
        end
    end
end

Handler_3_1.new():execute();