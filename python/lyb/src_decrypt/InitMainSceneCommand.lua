
--init mainmediator

-- notifications
require "main.controller.notification.ArenaNotification";
require "main.controller.notification.QianDaoNotification";
require "main.controller.notification.HuoDongNotification";
require "main.controller.notification.BangDingNotification";
require "main.controller.notification.FirstPayNotification";
require "main.controller.notification.ZhenFaNotification";
require "main.controller.notification.ChatNotification";
require "main.controller.notification.TutorNotification";
require "main.controller.notification.ShadowNotification";
require "main.controller.notification.LangyalingNotification";
require "main.controller.notification.HuiGuNotification";
require "main.controller.notification.SevenDaysNotification";
require "main.controller.notification.XunbaoNotification";
require "main.controller.notification.SecondPayNotification"

-- commands
require "main.controller.command.bagPopup.BagFullEffectCommand";
require "main.controller.command.shopTwo.OpenShopTwoUICommand"
require "main.controller.command.qiandao.OpenQianDaoUICommand"
require "main.controller.command.huoDong.OpenHuoDongUICommand"
require "main.controller.command.chat.ChatPrivateToPlayerCommand";
require "main.controller.command.chat.ChatSendCommand";
require "main.controller.command.tutor.TutorCloseCommand";
require "main.controller.command.shadow.OpenStrongPointInfoUICommand"
require "main.controller.command.shadow.OpenHeroImageUICommand"
require "main.controller.command.storyLine.OpenStoryLineUICommand"
require "main.controller.command.langyaling.PopupLanyalingCommand"
require "main.controller.command.langyaling.CloseLanyalingCommand"
require "main.controller.command.mainScene.MainSceneToHeroHouseCommand"
require "main.controller.command.mainScene.MainSceneToHeroJinJieCommand"
require "main.controller.command.mainScene.MainSceneToHeroProCommand"
require "main.controller.command.mainScene.MainSceneToHeroChangeEquipeCommand"
require "main.controller.command.mainScene.MainSceneToHeroTeamMainCommand"
require "main.controller.command.mainScene.MainSceneToHeroTeamSubCommand"
require "main.controller.command.mainScene.ToAddButtonGroupCommand"
require "main.controller.command.mainScene.ToAddLeftButtonGroupCommand"
require "main.controller.command.mainScene.ToAddCurrencyGroupCommand"
require "main.controller.command.mainScene.ToAddHButtonGroupCommand"
require "main.controller.command.mainScene.ToRemoveButtonGroupCommand"
require "main.controller.command.mainScene.ToOpenMenuCommand"
require "main.controller.command.mainScene.ToArenaCommand"
require "main.controller.command.task.ModalDialogCommand"
require "main.controller.command.mainScene.ToCteateRoleCommand"
require "main.controller.command.mainScene.MainSceneToGuanzhiCommand"
require "main.controller.command.handofMidas.OpenHandofMidasUICommand"
require "main.controller.command.mainScene.ToAddFunctionOpenCommand"
require "main.controller.command.mainScene.JudgeReddotCommand"
require "main.controller.command.mainScene.ToRefreshReddotCommand"
require "main.controller.command.hero.HeroRedDotRefreshCommand"
require "main.controller.command.mainScene.ToHuiGuCommand"
require "main.controller.command.trackItem.OpenTrackItemUICommand"
require "main.controller.command.family.FamilyBanquetCommand";
require "main.controller.command.family.FamilyHoldBanquetCommand";
require "main.controller.command.yongbing.MainSceneToYongbingCommand";
require "main.controller.command.monthCard.MonthCardCommand";
require "main.controller.command.huoDong.BangDingCommand";
require "main.controller.command.firstPay.FirstPayCommand";
require "main.controller.command.zhenFa.ZhenFaCommand";
require "main.controller.command.tianXiang.TianXiangCommand";
require "main.controller.command.mainScene.ToTreasuryCommand";
require "main.controller.command.SevenDays.OpenSevenDaysUICommand"
require "main.controller.command.secondPay.SecondPayCommnd"

InitMainSceneCommand=class(MacroCommand);

function InitMainSceneCommand:ctor()
	self.class=InitMainSceneCommand;
end

function InitMainSceneCommand:execute(notification)
	local mainSceneMediator = self:retrieveMediator(MainSceneMediator.name)
	if mainSceneMediator then

	else
		log("---------------------InitMainSceneCommand----registerd");
		self:registerCommand(FamilyNotifications.FAMILY_BANQUET_COMMAND,FamilyBanquetCommand);
		self:registerCommand(FamilyNotifications.FAMILY_HOLD_BANQUET_COMMAND,FamilyHoldBanquetCommand);
		mainSceneMediator = MainSceneMediator.new();
		self:registerMediator(mainSceneMediator:getMediatorName(),mainSceneMediator);
		self:registerCommand(MainSceneNotifications.TO_BAG,MainSceneToBagCommand);
		self:registerCommand(MainSceneNotifications.TO_STRENGTHEN,MainSceneToStrengthenCommand);
		self:registerCommand(MainSceneNotifications.TO_CHAT,MainSceneToChatCommand);
		self:registerCommand(MainSceneNotifications.TO_BAG,MainSceneToBagCommand);
		self:registerCommand(MainSceneNotifications.TO_SMALL_CHAT, MainSceneToSmallChatCommand);
		self:registerCommand(MainSceneNotifications.TO_OPERATION, ToOperationCommand);
		self:registerCommand(MainSceneNotifications.TO_CLOSE_MAINSCENE, MainSceneCloseCommand);
		self:registerCommand(ChatNotifications.CHAT_SEND,ChatSendCommand);
		self:registerCommand(GameInitNotifications.GAME_INIT, GameInitCommand);
		self:registerCommand(StrongPointInfoNotifications.OPEN_QUICK_BATTLE_UI_COMMOND, OpenQuickBattleUICommand);
		self:registerCommand(TipNotifications.OPEN_TIP_COMMOND, OpenItemTipCommand);
		self:registerCommand(TipNotifications.REMOVE_TIP_COMMOND, RemoveTipCommand);
		
		if not self:hasCommand(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID, OpenFunctionUICommand) then
			self:registerCommand(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID, OpenFunctionUICommand);			
		end

		self:registerCommand(ShopTwoNotifications.OPEN_SHOPTWO_UI, OpenShopTwoUICommand);
        self:registerCommand(QianDaoNotifications.OPEN_QIANDAO_UI, OpenQianDaoUICommand)
        self:registerCommand(HuoDongNotifications.OPEN_HUODONG_UI, OpenHuoDongUICommand)        
        self:registerCommand(MonthCardNotifications.MONTH_CARD, MonthCardCommand)
        self:registerCommand(FirstPayNotifications.FIRST_PAY, FirstPayCommand)
        -- add by mohai.wu 
        -- print(" registerCommand SecondPayCommnd")SecondPayCommand
        self:registerCommand(SecondPayNotifications.SECOND_PAY, SecondPayCommand);

        self:registerCommand(BangDingNotifications.BANG_DING, BangDingCommand)
        self:registerCommand(ZhenFaNotifications.ZHEN_FA, ZhenFaCommand)
        self:registerCommand(FactionNotifications.TO_SHOP_COMMAND,OpenShopUICommand);
		self:registerCommand(MainSceneNotifications.TO_OPEN_TUTOR_UI, OpenTutorUICommand);  
		self:registerCommand(TutorNotifications.TUTOR_UI_CLOSE, TutorCloseCommand);
        self:registerCommand(SmallChatNotifications.SMALL_CHAT_VISIBLE, SmallChatVisibleCommand);
		-- self:registerCommand(MainSceneNotifications.REFRESH_CHAT_ICON_EFFECT, MainSceneChatIconEffectRefreshCommand)
		self:registerCommand(ShadowNotifications.OPEN_STRONGPOINT_INFO_UI_COMMAND, OpenStrongPointInfoUICommand)
		--OpenHeroImageUICommand这个不能删除
		self:registerCommand(ShadowNotifications.OPEN_HEROIMAGE_UI_COMMAND, OpenHeroImageUICommand)
		self:registerCommand(StrongPointInfoNotifications.OPEN_STORYLINE_UI_COMMOND, OpenStoryLineUICommand)
		self:registerCommand(MainSceneNotifications.MAIN_SCENE_TO_MAIL, MainSceneToMailCommand);
		self:registerCommand(MainSceneNotifications.TO_ARENA,ToArenaCommand);
		-- 琅琊令
		self:registerCommand(LangyalingNotifications.POPUP_UI_LANGYALING, PopupLanyalingCommand)
		self:registerCommand(LangyalingNotifications.CLOSE_UI_LANGYALING, CloseLanyalingCommand)
        --MainSceneToHeroHouseCommand这个不能删除
		self:registerCommand(MainSceneNotifications.TO_HEROHOUSE,MainSceneToHeroHouseCommand);
		self:registerCommand(MainSceneNotifications.TO_HEROPRO,MainSceneToHeroProCommand);
		self:registerCommand(MainSceneNotifications.TO_VIP,MainSceneToVipCommand);
		self:registerCommand(MainSceneNotifications.TO_HEROTEAMMAIN,MainSceneToHeroTeamMainCommand);
		self:registerCommand(MainSceneNotifications.TO_HEROTEAMSUB,MainSceneToHeroTeamSubCommand);
		self:registerCommand(MainSceneNotifications.TO_ADD_BUTTON_GROUP_COMMAND, ToAddButtonGroupCommand)
		self:registerCommand(MainSceneNotifications.TO_ADD_LEFT_BUTTON_GROUP_COMMAND, ToAddLeftButtonGroupCommand)
		self:registerCommand(MainSceneNotifications.TO_ADD_CURRENCY_GROUP_COMMAND, ToAddCurrencyGroupCommand)
		self:registerCommand(MainSceneNotifications.TO_ADD_HBUTTON_GROUP_COMMAND, ToAddHButtonGroupCommand)
		self:registerCommand(TaskNotifications.OPEN_MODAL_DIALOG_COMMOND, ModalDialogCommand);
		self:registerCommand(FactionNotifications.OPEN_FACTION_UI, OpenFactionCommand)
		self:registerCommand(FactionNotifications.TO_FACTION_CURRENCY_UI, OpenFactionCurrencyCommand)
		self:registerCommand(FactionNotifications.FACTION_CURRENCY_UI_CLOSE, FactionCurrencyCloseCommand)
		self:registerCommand(MainSceneNotifications.TO_OPEN_MENU_COMMAND, ToOpenMenuCommand)
		self:registerCommand(MainSceneNotifications.MAIN_SCENE_TO_FAMILY, MainSceneToFamilyCommand);
		self:registerCommand(MainSceneNotifications.TO_TASK, MainSceneToTaskSceneCommand);
		self:registerCommand(MainSceneNotifications.TO_RANK_LIST, MainSceneToRankListCommand)
		self:registerCommand(MainSceneNotifications.MAIN_SCENE_TO_GUANZHI, MainSceneToGuanzhiCommand)
		self:registerCommand(MainSceneNotifications.TO_OPEN_HAND_OF_MIDAS_UI,OpenHandofMidasUICommand);
		self:registerCommand(MainSceneNotifications.TO_ADD_FUNCTION_OPEN_UI, ToAddFunctionOpenCommand);
		self:registerCommand(MainSceneNotifications.TO_REFRESH_REDDOT, ToRefreshReddotCommand);
		self:registerCommand(HeroHouseNotifications.HERO_RED_DOT_REFRESH, HeroRedDotRefreshCommand);
		self:registerCommand(HuiGuNotifications.TO_HUIGU_COMMAND,ToHuiGuCommand);
		self:registerCommand(MainSceneNotifications.TO_TRACK_ITEM_UI_COMMAND, OpenTrackItemUICommand)
		self:registerCommand(FactionNotifications.TO_TREASURY_COMMAND,ToTreasuryCommand);
		self:registerCommand(MainSceneNotifications.TO_YONG_BING,MainSceneToYongbingCommand);
		self:registerCommand(MainSceneNotifications.TO_TIANXIANG_UI_COMMAND, TianXiangCommand)
		self:registerCommand(MainSceneNotifications.TO_BUDDY, MainSceneToBuddyCommand);
		--开服七天活动 2015-07-20 add by mohai.wu 
		self:registerCommand(SevenDaysNotifications.OPEN_SEVENDAYS_UI, OpenSevenDaysUICommand);
		
	end

    self:addSubCommand(BagFullEffectCommand);
		self:activityCheck();
    self:addSubCommand(MainSceneIconEffectCommand);
    self:addSubCommand(MainSceneGantanhaoCommand);
    self:addSubCommand(MainSceneIconRefreshCommand);
    self:complete();
end

function InitMainSceneCommand:activityCheck()
	require "main.config.ActivityConstConfig";
	for k,v in pairs(ActivityConstConfig.activities) do
		local functionID;
		if ActivityConstConfig.ID_2 == v then
			functionID = FunctionConfig.FUNCTION_ID_85;
		elseif ActivityConstConfig.ID_4 == v then
			functionID = FunctionConfig.FUNCTION_ID_83;
		elseif ActivityConstConfig.ID_5 == v then 
			functionID = FunctionConfig.FUNCTION_ID_79;
		elseif ActivityConstConfig.ID_6 == v then 
			functionID = FunctionConfig.FUNCTION_ID_84;
		elseif ActivityConstConfig.ID_7 == v then 
			functionID = FunctionConfig.FUNCTION_ID_122;
		elseif ActivityConstConfig.ID_10 == v then
			functionID = FunctionConfig.FUNCTION_ID_125;
		end
		if self:retrieveProxy(OpenFunctionProxy.name):checkIsOpenFunction(functionID)then

		else
			ActivityConstConfig.activities[v] = nil;
		-- break;
		end
	end
end