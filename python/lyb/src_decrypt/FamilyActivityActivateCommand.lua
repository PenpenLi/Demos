--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyActivityActivateCommand=class(MacroCommand);

function FamilyActivityActivateCommand:ctor()
	self.class=FamilyActivityActivateCommand;
end

function FamilyActivityActivateCommand:execute(notification)
  require "main.config.FamilyConstConfig";
  require "main.controller.command.chat.ChatSendCommand";
  local data=notification:getData();
  print("familyActivityActivateCommand",data.ID);
  if(connectBoo) then
  	if FamilyConstConfig.ACTIVITY_2==data.ID then
      sendMessage(27,45);
      sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_176)); 
      local userProxy = self:retrieveProxy(UserProxy.name);
      local sendTbl = {};
      sendTbl.UserId = userProxy:getUserID();
      sendTbl.UserName = userProxy:getUserName();
      sendTbl.MainType = ConstConfig.MAIN_TYPE_CHAT;
      sendTbl.SubType = ConstConfig.SUB_TYPE_FACTION;
      sendTbl.ChatContentArray = {};
      sendTbl.ChatContentArray[1] = {};
      sendTbl.ChatContentArray[1].Type = 1;
      sendTbl.ChatContentArray[1].ParamStr1 = "F1FF00";
      sendTbl.ChatContentArray[1].ParamStr2 = "";
      sendTbl.ChatContentArray[1].ParamStr3 = "";
      local ChatText = analysis("Tishi_Xiaoxibiao",31,"text");
      -- sendTbl.ChatContentArray[1].ParamStr4 = "哥哥开启了家族BOSS,小的们快上啊~";
      sendTbl.ChatContentArray[1].ParamStr4 = ChatText;
      self:addSubCommand(ChatSendCommand);
      self:complete(Notification.new(_,sendTbl)); --蛋疼
    --[[elseif FamilyConstConfig.ACTIVITY_4==data.ID then
      sendMessage(27,32);]]
  	end
  end
end