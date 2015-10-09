--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

require "main.view.chat.ChatPopupMediator";

Handler_11_1 = class(Command);

function Handler_11_1:execute()
  print(".11.1..","UserId",recvTable["UserId"]);
  print(".11.1..","UserName",recvTable["UserName"]);
  print(".11.1..","Level",recvTable["Level"]);
  print(".11.1..","ConfigId",recvTable["ConfigId"]);
  print(".11.1..","Vip",recvTable["Vip"]);
  print(".11.1..","FamilyName",recvTable["FamilyName"]);
  print(".11.1..","ChatContentArray",recvTable["ChatContentArray"]);
  print(".11.1..","MainType",recvTable["MainType"]);
  print(".11.1..","SubType",recvTable["SubType"]);
  print(".11.1..","TargetUserId",recvTable["TargetUserId"]);
  print(".11.1..","TargetUserName",recvTable["TargetUserName"]);
  print(".11.1..","DateTime",recvTable["DateTime"]);

  local data={};
  data.UserId=recvTable["UserId"];
  data.UserName=recvTable["UserName"];
  data.Level=recvTable["Level"];
  data.ConfigId=recvTable["ConfigId"];
  data.Vip=recvTable["Vip"];
  data.VipLevel=data.Vip;
  data.FamilyName=recvTable["FamilyName"];
  data.ChatContentArray=recvTable["ChatContentArray"];
  data.MainType=recvTable["MainType"];
  data.SubType=recvTable["SubType"];
  data.TargetUserId=recvTable["TargetUserId"];
  data.TargetUserName=recvTable["TargetUserName"];
  data.DateTime=recvTable["DateTime"];
  
  --self:getVipLevel(data.Vip);

  --ChatListProxy
  local chatListProxy=self:retrieveProxy(ChatListProxy.name);
  chatListProxy:refreshData(data);

  --ChatPopupMediator
  local chatPopupMediator=self:retrieveMediator(ChatPopupMediator.name);
  if chatPopupMediator then
    chatPopupMediator:refreshChatContent(data);
  else
    local insertData=chatListProxy:getInsertData();
    if insertData then
      if ConstConfig.USER_NAME~=data.UserName then
        if ConstConfig.MAIN_TYPE_CHAT==data.MainType then
          if ConstConfig.SUB_TYPE_PRIVATE==data.SubType then
            insertData.chatDataNum=1+insertData.chatDataNum;
          end
        elseif ConstConfig.MAIN_TYPE_BUDDY==data.MainType then
          insertData.buddyDataNum=1+insertData.buddyDataNum;
          if insertData.buddyNameNum[data.UserName] then
            insertData.buddyNameNum[data.UserName]=1+insertData.buddyNameNum[data.UserName];
          end
        end
      end
    end
    
  end

  --SmallChatProxy
  local smallChatProxy=self:retrieveProxy(SmallChatProxy.name);
  smallChatProxy:setData(data);

  --SmallChatMediator
  local smallChatMediator=self:retrieveMediator(SmallChatMediator.name);
  if nil~=smallChatMediator then
    smallChatMediator:refresh(chatPopupMediator and chatPopupMediator:getViewComponent():isVisible());
  end

  --MainSceneMediator
  local mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);
  if nil~=mainSceneMediator and (chatPopupMediator and not chatPopupMediator:getViewComponent():isVisible()) and data.UserName~=ConstConfig.USER_NAME then
    if ConstConfig.MAIN_TYPE_CHAT==data.MainType and ConstConfig.SUB_TYPE_PRIVATE==data.SubType or ConstConfig.MAIN_TYPE_BUDDY==data.MainType then
      mainSceneMediator:refreshChatNumber();
    end
  end
end

function Handler_11_1:getVipLevel(vip)
  local userProxy=self:retrieveProxy(UserProxy.name);
  local vipLevel=0;

  local vipTable=analysisTotalTable("Huiyuan_Huiyuandengji");
  table.remove(vipTable,1);
  if vip == 0 then return vipLevel; end
  for k,v in pairs(vipTable) do
    if vip>=v.min and vip<=v.max then
      vipLevel=tonumber(string.sub(k,4));
      return vipLevel;
    end
  end
  return userProxy.vipLevelMax;
end

Handler_11_1.new():execute();