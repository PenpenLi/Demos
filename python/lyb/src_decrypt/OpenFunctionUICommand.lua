-- require "main.controller.command.avatar.AvatarCloseCommand"

 OpenFunctionUICommand = class(MacroCommand);
function OpenFunctionUICommand:ctor()
  self.class = OpenFunctionUICommand;
end
require "main.controller.command.shop.OpenShopUICommand"
function OpenFunctionUICommand:execute(notification)
	print("openFunctionId __",notification.data.functionid);
	print("param1", notification.data.param1)
	if(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_1) then
		self:addSubCommand(MainSceneToVipCommand)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_2) then
		self:addSubCommand(MainSceneToVipCommand)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_3) then

		self:addSubCommand(OpenShopTwoUICommand)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_4) then
		self:addSubCommand(MainSceneToChatCommand)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_5) then
		self:addSubCommand(MainSceneToMailCommand)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_6) then
		self:addSubCommand(MainSceneToBagCommand)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_7) then
		self:addSubCommand(ToOperationCommand)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_8) then

	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_9) then
		self:addSubCommand(OpenShopUICommand)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_10) then
		self:addSubCommand(OpenShopUICommand)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_11) then
		self:addSubCommand(MainSceneToRankListCommand)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_12) then
  
		self:addSubCommand(PopupLanyalingCommand)
		local data=LangyalingNotification.new(LangyalingNotifications.POPUP_UI_LANGYALING)
		self:complete(data);
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_13) then
		self:addSubCommand(MainSceneToHeroHouseCommand)
		self:complete();

	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_14) then
		self:addSubCommand(MainSceneToHeroProCommand)
		self:complete(MainSceneNotification.new("",{TAB_ID = 2,GeneralId = notification.data.GeneralId}));
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_15) then
		self:addSubCommand(MainSceneToHeroProCommand)
		self:complete(MainSceneNotification.new("",{GeneralId = notification.data.GeneralId}));
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_16) then
		self:addSubCommand(MainSceneToHeroProCommand)
		self:complete(MainSceneNotification.new("",{GeneralId = notification.data.GeneralId}));
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_17) then
		self:addSubCommand(MainSceneToHeroProCommand)
		self:complete(MainSceneNotification.new("",{GeneralId = notification.data.GeneralId}));

	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_18) then
		self:addSubCommand(OpenShopUICommand)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_19) then
		self:addSubCommand(MainSceneToHeroProCommand)
		self:complete(MainSceneNotification.new("",{GeneralId = notification.data.GeneralId}));
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_20) then
		self:addSubCommand(OpenShopUICommand)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_21) then
		self:addSubCommand(OpenShopUICommand)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_22) then
		local param=notification.data.param1
		local storyLineProxy = self:retrieveProxy(StoryLineProxy.name);
		if storyLineProxy:getStrongPointState(param) == 1 or storyLineProxy:getStrongPointState(param) == 3 then
			local data = ShadowNotification.new(ShadowNotifications.OPEN_HEROIMAGE_UI_COMMAND,{strongPointId = param})
			OpenHeroImageUICommand.new():execute(data);
		else
			self:addSubCommand(OpenHeroImageUICommand)
			self:complete();
		end
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_23) then
		self:addSubCommand(MainSceneToHeroHouseCommand)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_24) then
		self:addSubCommand(OpenStoryLineUICommand)
		if notification.data.param2 then--满星宝箱
			local storyLineId = notification.data.param1;
			local data = ShadowNotification.new(ShadowNotifications.OPEN_STORYLINE_UI_COMMOND,{storyLineId = storyLineId, popUpFullStar = true})
			self:complete(data);
		else
			local strongPointId = notification.data.param1;
			local storyLineId;
			if strongPointId == 0 then
				local storyLineProxy = self:retrieveProxy(StoryLineProxy.name);
				strongPointId = storyLineProxy:getLastStrongPointId();
				local strongPointPo = analysis("Juqing_Guanka", strongPointId)
				storyLineId = strongPointPo.storyId--, "storyId"parentId
				strongPointId = strongPointPo.parentId
			end
			print("strongPointId,storyLineId",strongPointId,storyLineId)
			local data = ShadowNotification.new(ShadowNotifications.OPEN_STORYLINE_UI_COMMOND,{strongPointId = strongPointId, storyLineId = storyLineId})
			self:complete(data);
		end
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_25) then
		self:addSubCommand(OpenShopUICommand)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_26) then
		self:addSubCommand(ToArenaCommand)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_27) then
		self:addSubCommand(OpenHandofMidasUICommand)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_28) then
		self:addSubCommand(OpenShopUICommand)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_29) then
		self:addSubCommand(OpenShopUICommand)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_30) then
		self:addSubCommand(OpenShopUICommand)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_30) then
		self:addSubCommand(MainSceneToFamilyCommand)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_31) then
		self:addSubCommand(OpenShopUICommand)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_32) then
		self:addSubCommand(OpenFactionCommand)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_33) then
		self:addSubCommand(MainSceneToGuanzhiCommand)
		setFactionCurrencyVisible(true)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_34) then
		self:addSubCommand(ToTenCountryCommand)
		setFactionCurrencyVisible(true)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_35) then
		require "main.controller.command.mainScene.ToMeetingCommand"
		self:addSubCommand(ToMeetingCommand)
		setFactionCurrencyVisible(true)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_36) then
		require "main.controller.command.mainScene.ToTreasuryCommand"
		self:addSubCommand(ToTreasuryCommand)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_37) then
		self:addSubCommand(OpenShopUICommand)
		setFactionCurrencyVisible(true)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_37) then
		self:addSubCommand(OpenShopUICommand)
		setFactionCurrencyVisible(true)
		self:complete();
	elseif(tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_44) then
		sendMessage(8,6)
	elseif tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_58 then
	elseif tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_60 then
		self:addSubCommand(ToHuiGuCommand)
		self:complete();
	elseif tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_61 then
		self:addSubCommand(ZhenFaCommand)
		self:complete();
	elseif tonumber(notification.data.functionid)==FunctionConfig.FUNCTION_ID_68 then
		self:addSubCommand(TianXiangCommand)
		self:complete();
	end





end
