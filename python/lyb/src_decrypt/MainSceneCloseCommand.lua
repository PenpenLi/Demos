
-- close mainmediator


MainSceneCloseCommand=class(Command);

function MainSceneCloseCommand:ctor()
	self.class=MainSceneCloseCommand;
end

function MainSceneCloseCommand:execute(notification)
	
	sharedMainLayerManager():disposeMainLayerManager();
	local mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);
    if mainSceneMediator then
		mainSceneMediator:getViewComponent():cleanSceneAllChildren();
    end
	self:removeMediator(MainSceneMediator.name);

	if ChatPopupMediator and self:retrieveMediator(ChatPopupMediator.name) then
		ChatCloseCommand.new():execute();
	end
	--gameSceneIns = nil;
	SmallChatCloseCommand.new():execute();

	ToRemoveButtonGroupCommand.new():execute();
	ToRemoveLeftButtonGroupCommand.new():execute();

	self:removeCommand(MainSceneNotifications.TO_ROLENAME,MainSceneToRoleNameCommand);
	
	self:removeCommand(MainSceneNotifications.TO_LITTLEHELPER,MainSceneToLittleHelperCommand);
	self:removeCommand(MainSceneNotifications.TO_TASK,MainSceneToTaskSceneCommand);
	self:removeCommand(MainSceneNotifications.TO_BAG,MainSceneToBagCommand);
	self:removeCommand(MainSceneNotifications.TO_CHEAT,ToCheatCommand);
	self:removeCommand(MainSceneNotifications.TO_STRENGTHEN,MainSceneToStrengthenCommand);
	self:removeCommand(MainSceneNotifications.TO_CHAT,MainSceneToChatCommand);
	self:removeCommand(MainSceneNotifications.TO_BUDDY,MainSceneToBuddyCommand);
	self:removeCommand(MainSceneNotifications.TO_BAG,MainSceneToBagCommand);
	self:removeCommand(MainSceneNotifications.TO_PET,MainSceneToPetCommand);
	self:removeCommand(MainSceneNotifications.TO_CHALLENGE,ToChallengeCommand);
	self:removeCommand(MainSceneNotifications.TO_LOOK_INTO_PLAYER,MainSceneToLookIntoPlayerCommand);
	self:removeCommand(ArenaNotifications.TO_RANK_LIST, MainSceneToRankListCommand);
	self:removeCommand(MainSceneNotifications.TO_SYSTEM_MARK, MainSceneToSystemMarkCommand);
	self:removeCommand(MainSceneNotifications.TO_TITLE, MainSceneToTitleCommand);
	self:removeCommand(MainSceneNotifications.TO_LOGIN_LOTTERY, MainSceneToLoginLotteryCommand);
	self:removeCommand(MainSceneNotifications.TO_ACTIVITY, MainSceneToActivityCommand);
	self:removeCommand(MainSceneNotifications.TO_SMALL_CHAT, MainSceneToSmallChatCommand);
	self:removeCommand(MainSceneNotifications.TO_OPERATION, ToOperationCommand);
	self:removeCommand(MainSceneNotifications.TO_CLOSE_MAINSCENE, MainSceneCloseCommand);
	self:removeCommand(MainSceneNotifications.MAIN_SCENE_TO_FAMILY, MainSceneToFamilyCommand);
	self:removeCommand(MainSceneNotifications.MAIN_SCENE_TO_FAMILY_TASK, MainSceneToFamilyTaskCommand);
	self:removeCommand(MainSceneNotifications.MAIN_SCENE_TO_FIRST_SEVEN, MainSceneToFirstSevenCommand);
	self:removeCommand(MainSceneNotifications.MAIN_SCENE_TO_POSSESSION_BATTLE, MainSceneToPossessionBattleCommand);

	self:removeCommand(MainSceneNotifications.MAIN_SCENE_TO_CHANGE_NAME, MainSceneToNameChangeCommand);
	self:removeCommand(ChatNotifications.CHAT_ADD_BUDDY,ChatAddBuddyCommand);
	self:removeCommand(ChatNotifications.CHAT_PRIVATE_TO_PLAYER,ChatPrivateToPlayerCommand);
	self:removeCommand(ChatNotifications.CHAT_SEND,ChatSendCommand);
	
	self:removeCommand(GameInitNotifications.GAME_INIT, GameInitCommand);

	self:removeCommand(TaskNotifications.OPEN_MODAL_DIALOG_COMMOND, ModalDialogCommand);

	-- self:removeCommand(MainSceneNotifications.MAIN_SCENE_TO_MONSTER_BATTLE, MainSceneToMonsterBattleCommand);

	self:removeCommand(StrongPointInfoNotifications.OPEN_QUICK_BATTLE_UI_COMMOND, OpenQuickBattleUICommand);
	--self:removeCommand(TipNotifications.OPEN_TIP_COMMOND, OpenItemTipCommand);--注释原因战场结束道具tips展示  fjm
	--self:removeCommand(TipNotifications.REMOVE_TIP_COMMOND, RemoveTipCommand);
	--self:removeCommand(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID, OpenFunctionUICommand);

	-- self:removeCommand(ObtainSilverNotifications.OPEN_OBTAIN_SILVER_UI, OpenObtainSilverUICommand);
	-- self:removeCommand(ShopNotifications.OPEN_SHOP_UI, OpenShopUICommand);
	self:removeCommand(ShopTwoNotifications.OPEN_SHOPTWO_UI, OpenShopTwoUICommand)
	self:removeCommand(QianDaoNotifications.OPEN_QIANDAO_UI, OpenQianDaoUICommand)
    -- self:removeCommand(FamilyNotifications.FAMILY_INVITE,FamilyInviteCommand);
    -- self:removeCommand(MainSceneNotifications.REFRESH_CHAT_ICON_EFFECT, MainSceneChatIconEffectRefreshCommand);

    -- self:removeCommand(MainSceneNotifications.MAIN_SCENE_TO_FIRST_CHARGE_UI, MainSceneToFirstChargeCommand);
    -- self:removeCommand(MainSceneNotifications.MAIN_SCENE_TO_OPERATION_BONUS, MainSceneToOperationBonusCommand);
    -- self:removeCommand(MainSceneNotifications.MAIN_SCENE_TO_AMASS_FORTUNES, MainSceneToAmassFortunesCommand);
    -- self:removeCommand(TurntableNotifications.OPEN_UI, TurntableCommand);

    self:removeCommand(MainSceneNotifications.MAIN_SCENE_TO_MAIL, MainSceneToMailCommand);

	self:removeCommand(MainSceneNotifications.TO_HEROHOUSE,MainSceneToHeroHouseCommand);
	self:removeCommand(MainSceneNotifications.TO_HEROJINJIE,MainSceneToHeroJinJieCommand);
	self:removeCommand(MainSceneNotifications.TO_HEROPRO,MainSceneToHeroProCommand);
	-- self:removeCommand(MainSceneNotifications.TO_HEROSKILL,MainSceneToHeroSkillCommand);
	self:removeCommand(MainSceneNotifications.TO_VIP,MainSceneToVipCommand);
	
	self:removeCommand(MainSceneNotifications.TO_HEROTEAMMAIN,MainSceneToHeroTeamMainCommand);
	self:removeCommand(MainSceneNotifications.TO_HEROTEAMSUB,MainSceneToHeroTeamSubCommand);
	self:removeCommand(MainSceneNotifications.TO_ARENA,ToArenaCommand);
	self:removeCommand(MainSceneNotifications.TO_HEROCHANGEEQUIPE,MainSceneToHeroChangeEquipeCommand);

	self:removeCommand(MainSceneNotifications.TO_RANK_LIST, MainSceneToRankListCommand)
	self:removeCommand(MainSceneNotifications.MAIN_SCENE_TO_GUANZHI, MainSceneToGuanzhiCommand)
	self:removeCommand(HeroHouseNotifications.HERO_RED_DOT_REFRESH, HeroRedDotRefreshCommand);
	self:removeCommand(HuiGuNotifications.TO_HUIGU_COMMAND,ToHuiGuCommand);
	self:removeCommand(FactionNotifications.TO_TREASURY_COMMAND,ToTreasuryCommand);
	self:removeCommand(MainSceneNotifications.TO_YONG_BING,MainSceneToYongbingCommand);
end