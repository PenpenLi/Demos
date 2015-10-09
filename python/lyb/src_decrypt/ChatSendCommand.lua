--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-22

	yanchuan.xie@happyelements.com
]]

ChatSendCommand=class(Command);

function ChatSendCommand:ctor()
	self.class=ChatSendCommand;
end

function ChatSendCommand:execute(notification)
  local data=notification:getData();
  print("chatSend",data.UserId,data.UserName,data.MainType,data.SubType,data.ChatContentArray);
  print("len",table.getn(data.ChatContentArray));
  if(connectBoo) then
  	local chatContentArray=data.ChatContentArray;
  	local ids={};
    local hero_ids={};
  	for k,v in pairs(chatContentArray) do
  		if ConstConfig.CHAT_CONTENT_ARRAY_TYPE_FONT==v.Type then
  			if ""~=v.ParamStr2 then
  				local a=StringUtils:lua_string_split(v.ParamStr2,",");
  				if ConstConfig.CHAT_EQUIP==tonumber(a[1]) then
  					table.insert(ids,{GeneralId=tonumber(a[2]),ItemId=tonumber(a[3])});--ids[a[2]]=a[2];
          elseif ConstConfig.CHAT_HERO==tonumber(a[1]) then
            hero_ids[a[2]]=a[2];
  				end
  			end
  		end
  	end

  	local idArray={ShareEquipArray={}};
  	for k,v in pairs(ids) do
  		table.insert(idArray.ShareEquipArray,v);
  	end
    if 0<table.getn(idArray.ShareEquipArray) then
  	  sendMessage(11,7,idArray);
      sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_136));
    end

    local heroIDArray={IDArray={}};
    for k,v in pairs(hero_ids) do
      table.insert(heroIDArray.IDArray,{ID=tonumber(v)});
    end
    if 0<table.getn(heroIDArray.IDArray) then
      sendMessage(11,10,heroIDArray);
    end

    sendMessage(11,3,data);
  end
end