
--返回 关卡数据,为了提高用户体验，，，打开界面的时候不发命令。直接刷新界面
Handler_4_6 = class(MacroCommand);

function Handler_4_6:execute()
    

    self.storyLineProxy = self:retrieveProxy(StoryLineProxy.name);
    -- local openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name);

    local userProxy = self:retrieveProxy(UserProxy.name)

    local strongPointArray = recvTable["StrongPointIdCountArray"]; 

    for i_k, i_v in pairs(strongPointArray) do  
      local key = "key_" .. i_v.StrongPointId;
      -- log("key==========="..key)
      -- log("i_v.StarLevel==========="..i_v.StarLevel)
      local oldStrongPointData = self.storyLineProxy.strongPointArray[key];
      if not oldStrongPointData then
        oldStrongPointData = {};
        oldStrongPointData.StrongPointId = i_v.StrongPointId;
        self.storyLineProxy.strongPointArray[key] = oldStrongPointData;
      end
      oldStrongPointData.Count = i_v.Count;
    
      oldStrongPointData.StarLevel = i_v.StarLevel;

    end

    local storyLineAwardArray = recvTable["StoryLineIdArray"]; 
    self.storyLineProxy:upDataAward(storyLineAwardArray)

end

Handler_4_6.new():execute();