require "main.model.StoryLineProxy";

StoryLineDataInitialize=class(Command);

function StoryLineDataInitialize:ctor()
	self.class=StoryLineDataInitialize;
end

function StoryLineDataInitialize:execute()
	--
  local storyLineProxy=StoryLineProxy.new();
  self:registerProxy(storyLineProxy:getProxyName(),storyLineProxy);
end