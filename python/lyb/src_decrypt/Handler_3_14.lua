
Handler_3_14 = class(MacroCommand);

function Handler_3_14:execute()
  
    self.dataAccumulateProxy = self:retrieveProxy(UserDataAccumulateProxy.name);
    self.huoDongProxy = self:retrieveProxy(HuoDongProxy.name);
    local userDataAccumulateArray = recvTable["UserDataAccumulateArray"];

    if next(userDataAccumulateArray) == nil then return;end;
    for k,v  in pairs(userDataAccumulateArray) do
        
        local dataType = v.Type;
        local dataParam = v.Param;
        local dataValue = v.Value;
        self.dataAccumulateProxy:addItem(dataType, dataParam, dataValue);
        if dataType == GameConfig.ACCUMULATE_TYPE_1 then

        elseif dataType == GameConfig.ACCUMULATE_TYPE_4 then
            self:handlerActivity(dataValue)
        elseif dataType == GameConfig.ACCUMULATE_TYPE_6 then
            self:arenaAccumulate(dataValue)
        elseif dataType == GameConfig.ACCUMULATE_TYPE_8 then
            self:littleHelperNotice()
        elseif dataType == GameConfig.ACCUMULATE_TYPE_9 then
            self:handlerLittleHelper(dataValue)   
        elseif dataType == GameConfig.ACCUMULATE_TYPE_28 then
              print("UserDataAccumulateArray 28 ", dataParam, dataValue)     
        elseif dataType == GameConfig.ACCUMULATE_TYPE_52 then
            self:firstChargeDoubleHandler()
            self.huoDongProxy.havdCharged = true;
        end
        print(dataType)
    end 
end
function Handler_3_14:handlerLittleHelper(dataValue)
  local littleHelperMediator=self:retrieveMediator(LittleHelperMediator.name);
  if nil~=littleHelperMediator then
    littleHelperMediator:refreshFunctionData();
  end

--   local canGetCount = dataValue / 20
--   -- print("Handler_3_14----------dataValue="..dataValue.."canGetCount=="..canGetCount)

--   -- 小秘里面是否有礼包可以领
--   for i = 1,canGetCount do
--     local countControlProxy=self:retrieveProxy(CountControlProxy.name);
--     local remainCount = countControlProxy:getRemainCountByID(CountControlConfig.Activity,i) 

--     if remainCount > 0 then
--         local littleHelperProxy = self:retrieveProxy(LittleHelperProxy.name);
--         if not littleHelperProxy then
--         littleHelperProxy = LittleHelperProxy.new()
--         self:registerProxy(LittleHelperProxy.name, littleHelperProxy);
--         end      
--         littleHelperProxy.notice = true

--         local mainMediator = self:retrieveMediator(MainSceneMediator.name)
--         if mainMediator then
--            mainMediator:setIconEffectLittlHelper();
--         end
--     end
--   end
end
function Handler_3_14:handlerActivity(value)
  if AmassFortunesMediator then
      local amassMediator=self:retrieveMediator(AmassFortunesMediator.name);
      if nil~=amassMediator then
        amassMediator:refreshAmassFortunesCount(value);
      end
  end
end

function Handler_3_14:arenaAccumulate(value)
    local arenaProxy=self:retrieveProxy(ArenaProxy.name);
    arenaProxy.victorTimes = value;
end


function Handler_3_14:littleHelperNotice()
	require "main.controller.command.littleHelper.LittleHelperNoticeCommand"
	self:addSubCommand(LittleHelperNoticeCommand);
	self:complete();
end

function Handler_3_14:firstChargeDoubleHandler()
  local mediator = self:retrieveMediator(VipMediator.name);
  if mediator then
    mediator:onUpdateView();
  end
end

Handler_3_14.new():execute();