
require "main.config.ConstConfig";

ChatListProxy=class(Proxy);

function ChatListProxy:ctor()
  self.class=ChatListProxy;
  self.data={};
  self.data.chatData={};
  self.data.buddyData={};
  self.data.insertData=nil;
  self.msgRecordArray=nil;
  self.skeleton=nil;

  self.buddy_feed_array={};
  self.buddy_feed_exp=0;
  self.hasNewGantanhao=false;
end

rawset(ChatListProxy,"name","ChatListProxy");

function ChatListProxy:deleteRecordByUserName(userName)
  if self.msgRecordArray then
    for k,v in pairs(self.msgRecordArray) do
      if userName==v.UserName then
        table.remove(self.msgRecordArray,k);
        break;
      end
    end
  end
end

function ChatListProxy:refreshData(data, bool)
  if bool then
    self.data.insertData=data;
  elseif ConstConfig.MAIN_TYPE_CHAT==data.MainType then
    self:refreshChatData(data);
  elseif ConstConfig.MAIN_TYPE_BUDDY==data.MainType then
    self:refreshBuddyData(data);
  end
end

function ChatListProxy:refreshChatData(data)
  if ConstConfig.SUB_TYPE_WORLD==data.SubType or ConstConfig.SUB_TYPE_HELP_BUDDY==data.SubType then

  else
    self:refreshChatDataBySubType(data.SubType,data);
  end
  self:refreshChatDataBySubType(ConstConfig.SUB_TYPE_WORLD,data);
end

function ChatListProxy:refreshChatDataBySubType(subType, data)
  if not self.data.chatData[subType] then
    self.data.chatData[subType]={};
  end
  table.insert(self.data.chatData[subType],data);
  if ConstConfig.CHAT_MAX_ITEM<table.getn(self.data.chatData[subType]) then
    table.remove(self.data.chatData[subType],1);
  end
end

function ChatListProxy:refreshBuddyData(data)
  local name=data.UserName==ConstConfig.USER_NAME and data.TargetUserName or data.UserName;
  if not self.data.buddyData[name] then
    self.data.buddyData[name]={};
  end
  table.insert(self.data.buddyData[name],data);
  if ConstConfig.CHAT_MAX_ITEM<table.getn(self.data.buddyData[name]) then
    table.remove(self.data.buddyData[name],1);
  end
end

function ChatListProxy:refreshRecord(msgRecordArray)
  self.msgRecordArray=msgRecordArray;
end

function ChatListProxy:getChatData(subType)
  if self.data.chatData[subType] then
    return self.data.chatData[subType];
  end
  return {};
end

function ChatListProxy:getBuddyData(userName)
  if self.data.buddyData[userName] then
    return self.data.buddyData[userName];
  end
  return {};
end

function ChatListProxy:getInsertData()
  return self.data.insertData;
end

function ChatListProxy:getRecord()
  return self.msgRecordArray;
end

function ChatListProxy:getRecordNumber()
  local a=0;
  if self.msgRecordArray then
    for k,v in pairs(self.msgRecordArray) do
      if 1==v.State then
        a=table.getn(v.SendMsgArray)+table.getn(v.RevMsgArray)+a;
      end
    end
  end
  return a;
end

function ChatListProxy:getRecordNumberByUserName(userName)
  if self.msgRecordArray then
    for k,v in pairs(self.msgRecordArray) do
      if userName==v.UserName and 1==v.State then
        return table.getn(v.SendMsgArray)+table.getn(v.RevMsgArray);
      end
    end
  end
  return 0;
end

function ChatListProxy:refreshBuddyFeed(data)
  table.insert(self.buddy_feed_array,data);
  if ConstConfig.CHAT_MAX_FEED_ITEM<table.getn(self.buddy_feed_array) then
    table.remove(self.buddy_feed_array,1);
  end
end

function ChatListProxy:refreshBuddyFeedArray(friendLogArray)
  for k,v in pairs(friendLogArray) do
    self:refreshBuddyFeed(v);
  end
end

function ChatListProxy:refreshBuddyFeedEXP(value)
  self.buddy_feed_exp=value;
end

function ChatListProxy:getBuddyFeedArray()
  return self.buddy_feed_array;
end

function ChatListProxy:getBuddyFeedEXP()
  return self.buddy_feed_exp;
end

function ChatListProxy:getBuddyFeedEXPFull(generalListProxy)
  return self.buddy_feed_exp>=analysis("Wujiang_Wujiangshengji",generalListProxy:getLevel(),"expball");
end

--龙骨
function ChatListProxy:getSkeleton()
  if nil==self.skeleton then
    self.skeleton=SkeletonFactory.new();
    self.skeleton:parseDataFromFile("chat_ui");
  end
  return self.skeleton;
end