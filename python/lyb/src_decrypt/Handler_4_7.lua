
--返回领取满星宝箱 并更新数据
Handler_4_7 = class(MacroCommand);

function Handler_4_7:execute()
  local storyLineId = recvTable["StoryLineId"]; 
  local awardTable = {{StoryLineId=storyLineId}}

  local storyLineProxy = self:retrieveProxy(StoryLineProxy.name);
  storyLineProxy:upDataAward(awardTable)

  local storyLineMediator = self:retrieveMediator(StoryLineMediator.name)
  if storyLineMediator then
  	storyLineMediator:refreshStarBox()
  end
end

Handler_4_7.new():execute();