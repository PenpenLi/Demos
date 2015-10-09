require "main.view.mainScene.guangbo.GuangboMediator"

-- 推送信息
Handler_11_6 = class(MacroCommand);

function Handler_11_6:execute()

	local userProxy=self:retrieveProxy(UserProxy.name);
	if userProxy:isFreshman() then	
	  return;
	end
  -- chatListProxy:refreshRecord();
	local id = recvTable["ID"]
	local content = recvTable["Content"]
	
	local contentTable = analysis("Tishi_Xiaoxibiao",id)
	local contentType = contentTable.subID1	
	if ""~=content then
	
	else
		content = contentTable.text
	end

	local param1 = recvTable["ParamStr1"]
	local param2 = recvTable["ParamStr2"]
	local param3 = recvTable["ParamStr3"]
	print("Handler_11_6");
	print("id:",id);
	print("param1:",type(param1),param1);
	print("param2:",type(param2),param2);
	print("param3:",type(param3),param3);
	print("param4:",type(param4),param4);
	print("content:",type(content),content);
	
	local mainMediator = self:retrieveMediator(MainSceneMediator.name)
	
	local dataTable = {}
	
	-- 按类型区分
	--2 感叹号
	--3 广播
	--1 聊天
	-- 还是要特殊处理
	if contentType == 1 then
		self:refreshChat();
	elseif contentType == 2 then
		
		dataTable["button1"] = contentTable.button1
		dataTable["button2"] = contentTable.button2
		dataTable["uiid"] = contentTable.uiid
		
		if id == 3 then
			if userProxy.userName == param1 then -- 不能添加自己好友
				local tips = CommonPopup.new();
				tips:initialize("不能添加自己为好友!",self,nil,nil,nil,nil,true,nil);
				sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(tips)
			end		
			local buddyListProxy=self:retrieveProxy(BuddyListProxy.name);
			buddyListProxy:refreshGantanhaos(recvTable["ParamStr1"],recvTable["ParamStr2"],recvTable["ParamStr3"]);
			if mainMediator and userProxy.state ~= GameConfig.STATE_TYPE_2 then
				mainMediator:refreshBuddyCommendButton();
			end
			return;
		else
			dataTable["id"] = id
			dataTable["content"] = content		
		end

		local openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name);
		if not userProxy.gantanhaoData then
			userProxy.gantanhaoData = {};
		end
		--去重
		local has = false;
		for k,v in pairs(userProxy.gantanhaoData) do
			if dataTable["id"] == v["id"] and dataTable["content"] == v["content"] 
				and dataTable["param1"]==v["param1"] and dataTable["param2"]==v["param2"] and dataTable["param3"]==v["param3"]then
				has = true;
			end
		end
		-- print(dataTable["uiid"],openFunctionProxy:checkIsOpenFunction(dataTable["uiid"]))
		if not has then
			--此处不能进行功能开启判断,因为有些感叹号是客户端模拟的,在3_2命令之前就触发了,此处只进行数据记录
			--是否显示感叹号在后面会做判断
			-- if dataTable["uiid"] == 0 or openFunctionProxy:checkIsOpenFunction(dataTable["uiid"]) then
				table.insert(userProxy.gantanhaoData,dataTable);
			-- end
		end
		
		if mainMediator and userProxy.state ~= GameConfig.STATE_TYPE_2 then
			if dataTable["uiid"] == 0 or openFunctionProxy:checkIsOpenFunction(dataTable["uiid"]) then
				mainMediator:setGantanhao(dataTable);		
			end
		end
	elseif contentType == 3 then
		if id == 8 then
			content = string.gsub(content,"@1",param1)
			content = string.gsub(content,"@2",analysis("Kapai_Kapaiku",param2, "name"))
		elseif id == 9 then
			content = string.gsub(content,"@1",param1)
		elseif id == 10 then
			content = string.gsub(content,"@1",param1)
		elseif id == 11 then
			content = string.gsub(content,"@1",param1)
		elseif id == 12 then
			content = string.gsub(content,"@1",param1)
		elseif id == 13 then
			content = string.gsub(content,"@1",param1)
		elseif id == 14 then
			content = string.gsub(content,"@1",param1)
			content = string.gsub(content,"@2",analysis("Shili_Guanzhi",param2, "title"))
		elseif id == 19 then
			content = string.gsub(content,"@1",param1)
			content = string.gsub(content,"@2",analysis("Bangpai_Bangpaijiuyan", param2, "name"))
		elseif id == 9999 then

		end

		local userProxy=self:retrieveProxy(UserProxy.name);
		table.insert(userProxy.guangboData,content);

	local scene = Director.sharedDirector():getRunningScene();
	local parent4u=nil;
	if scene then
		if scene.name ~= GameConfig.BATTLE_SCENE then
			require "main.controller.command.mainScene.ToAddGuangboCommand";
			ToAddGuangboCommand.new():execute();
		end
	end
	elseif contentType == 4 then

	elseif contentType == 5 then
	end
	if ShopMediator then
		local shopMediator = self:retrieveMediator(ShopMediator.name);
		if shopMediator then
			shopMediator:refreshData();
		end
	end	
end

function Handler_11_6:refreshChat()
	local a=StringUtils:getBroadData(recvTable["ID"],recvTable["ParamStr1"],recvTable["ParamStr2"],recvTable["ParamStr3"],recvTable["ParamStr4"],recvTable["Content"]);
	if not a or 0==table.getn(a) then
		return;
	end
	recvTable["UserId"]=0;
	recvTable["UserName"]="";
	recvTable["Level"]=0;
	recvTable["ConfigId"]=0;
	recvTable["Vip"]=0;
	recvTable["VipLevel"]=0;
	recvTable["FamilyName"]="";
	recvTable["ChatContentArray"]=a;
	recvTable["MainType"]=ConstConfig.MAIN_TYPE_CHAT;
	recvTable["SubType"]=self:getSubType();
	recvTable["TargetUserId"]=0;
	recvTable["TargetUserName"]="";
	recvTable["DateTime"]=0;
	recvMessage(1011,1);
end

function Handler_11_6:getSubType()
	-- if 52==recvTable["ID"] or 53==recvTable["ID"] or 19==recvTable["ID"] or 20==recvTable["ID"] or 22==recvTable["ID"] then
	-- 	return ConstConfig.SUB_TYPE_FACTION;
	-- else
		return ConstConfig.SUB_TYPE_BROAD;
	-- end
end


Handler_11_6.new():execute();