--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

require "main.view.chat.ChatPopupMediator";

Handler_11_2 = class(Command);

function Handler_11_2:execute()
  print(".11.2.",recvTable["MsgRecordArray"]);
  for k,v in pairs(recvTable["MsgRecordArray"]) do
    print(".11.2..",v.State);
  end
  local chatListProxy=self:retrieveProxy(ChatListProxy.name);
  chatListProxy:refreshRecord(recvTable["MsgRecordArray"]);
  self:refreshBuddyChatRecord();
end

--更新好友留言
function Handler_11_2:refreshBuddyChatRecord()
  print("refreshBuddyChatRecord");
  local chatListProxy=self:retrieveProxy(ChatListProxy.name);
  local buddyListProxy=self:retrieveProxy(BuddyListProxy.name);
  local userProxy=self:retrieveProxy(UserProxy.name);
  local msgRecordArray=chatListProxy:getRecord();
  if nil==msgRecordArray then
    return;
  end

  --UserName,Level,ChatContent,MainType,SubType,TargetUserName
  --UserId,State,MsgHistoryContentArray
  --Content
  --UserName,State,SendMsgArray,RevMsgArray
  --Content,DateTime
  local chatContents={};

  local function cf(a, b)
    if a.msg.DateTime<b.msg.DateTime then
      return true;
    end
    return false;
  end

  for k,v in pairs(msgRecordArray) do
    local contents={};
    for k,v in pairs(v.SendMsgArray) do
      table.insert(contents,{msg=v,isSend=true});
    end
    for k,v in pairs(v.RevMsgArray) do
      table.insert(contents,{msg=v,isSend=false});
    end
    table.sort(contents,cf);
    local buddyData=buddyListProxy:getBuddyData(v.UserName);
    if not buddyData then
      error("");
    end
    for k_,v_ in pairs(contents) do
      local data={};
      data.UserId=true==v_.isSend and userProxy:getUserID() or buddyData.UserId;
      data.UserName=true==v_.isSend and ConstConfig.USER_NAME or buddyData.UserName;
      data.Level=buddyData.Level;
      data.ChatContentArray=v_.msg.ChatContentArray;
      data.MainType=ConstConfig.MAIN_TYPE_BUDDY;
      data.SubType=0;
      data.TargetUserId=true==v_.isSend and buddyData.UserId or userProxy:getUserID();
      data.TargetUserName=true==v_.isSend and buddyData.UserName or ConstConfig.USER_NAME;
      data.DateTime=v_.msg.DateTime;
      data.State=v.State;
      table.insert(chatContents,data);
    end
  end

  for k,v in pairs(chatContents) do
    chatListProxy:refreshData(v);
  end
end

Handler_11_2.new():execute();