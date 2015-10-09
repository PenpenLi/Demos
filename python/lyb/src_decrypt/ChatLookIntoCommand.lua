--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

ChatLookIntoCommand=class(Command);

function ChatLookIntoCommand:ctor()
	self.class=ChatLookIntoCommand;
end

function ChatLookIntoCommand:execute(notification)
  local data=notification:getData();
	print("chatLookIntoCommand",data.TYPE,data.PARAM);
  	if(connectBoo) then
  	  if ConstConfig.CHAT_EQUIP==data.TYPE then
        print(data.PARAM[1],data.PARAM[2]);
        sendMessage(11,8,{GeneralId=data.PARAM[1],ItemId=data.PARAM[2]});
      elseif ConstConfig.CHAT_PHOTO==data.TYPE then
        
      elseif ConstConfig.CHAT_RECORD==data.TYPE then

      elseif ConstConfig.CHAT_HERO==data.TYPE then
        sendMessage(11,11,{GeneralId=data.PARAM});
      end
  	end
end