package com.common.net
{
   import air.net.URLMonitor;
   import flash.net.URLRequest;
   import flash.events.StatusEvent;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.mvc.GameFacade;
   import starling.events.Event;
   import com.common.util.loading.NETLoading;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.login.LoginPro;
   import flash.desktop.NativeApplication;
   import com.massage.ane.UmengExtension;
   import com.common.events.EventCenter;
   import com.mvc.views.mediator.mainCity.kingKwan.GetPropMedia;
   import com.mvc.views.mediator.mainCity.sign.SignMedia;
   import com.mvc.views.mediator.mainCity.myElf.MyElfMedia;
   import com.mvc.views.mediator.mainCity.backPack.BackPackMedia;
   import com.mvc.views.mediator.mainCity.Illustrations.IllustrationsMedia;
   import com.mvc.views.mediator.mainCity.task.TaskMedia;
   import com.mvc.views.mediator.mainCity.friend.FriendMedia;
   import com.mvc.views.mediator.mainCity.information.InformationMedia;
   import com.mvc.views.mediator.mainCity.active.ActiveMeida;
   import com.mvc.views.mediator.mainCity.firstRecharge.FirstRchargeMediator;
   import com.mvc.views.mediator.mainCity.myElf.EvolveMcMediator;
   import com.mvc.views.mediator.mainCity.amuse.SetElfNameMedia;
   import com.mvc.views.mediator.mainCity.miracle.MiracleMediator;
   import com.mvc.views.mediator.mainCity.elfSeries.SelePlayElfMedia;
   import com.mvc.views.mediator.mainCity.growthPlan.GrowthPlanMediator;
   import com.mvc.views.mediator.mainCity.scoreShop.ScoreShopMediator;
   import com.mvc.views.mediator.mainCity.train.TrainMedia;
   import com.mvc.views.mediator.mainCity.Ranklist.RanklistMedia;
   import com.mvc.views.mediator.mainCity.chat.HornMedia;
   import com.mvc.views.mediator.mainCity.chat.ChatPlayerMedia;
   import com.mvc.views.mediator.mainCity.backPack.PlayElfMedia;
   import com.mvc.views.mediator.mainCity.backPack.SkillPanelMedia;
   import com.mvc.views.mediator.mainCity.home.ElfDetailInfoMedia;
   import com.mvc.views.mediator.mainCity.specialAct.diamondUp.DiamondUpMediator;
   import com.mvc.views.mediator.union.unionStudy.StudyChildMedia;
   import com.mvc.views.mediator.union.unionStudy.UnionStudyMedia;
   import com.mvc.views.mediator.union.unionTrain.OtherTrainMedia;
   import com.mvc.views.mediator.union.unionTrain.UnionTrainMedia;
   import com.mvc.views.mediator.union.unionHall.UnionHallMedia;
   import com.mvc.views.mediator.union.unionMedal.MedalMedia;
   import com.mvc.views.mediator.mainCity.laboratory.ReCallSkillMedia;
   import com.mvc.views.mediator.mainCity.hunting.HuntingSelectTickMediator;
   import com.mvc.views.mediator.mainCity.scoreShop.FreeSelectElfMediator;
   import com.mvc.views.mediator.mainCity.laboratory.ResetElfMediator;
   import com.mvc.views.mediator.mainCity.miracle.MiracleSelectElfMediator;
   import com.mvc.views.mediator.mainCity.train.SeleTrainElfMedia;
   import com.mvc.views.mediator.login.LoginWidowMedia;
   import com.mvc.views.mediator.mainCity.trial.TrialBossInfoMediator;
   import com.mvc.views.mediator.mainCity.trial.TrialSelectDifficultyModiator;
   import com.mvc.views.mediator.mainCity.trial.TrialSelectBossMediator;
   import com.mvc.views.mediator.mainCity.scoreShop.ScoreGoodsInfoMediator;
   import com.mvc.views.mediator.mainCity.pvp.PVPPropMediator;
   import com.mvc.views.mediator.mainCity.pvp.PVPRankMediator;
   import com.mvc.views.mediator.mainCity.pvp.PVPRuleMediator;
   import com.mvc.views.mediator.mainCity.pvp.PVPCheckPswMediator;
   import com.mvc.views.mediator.mainCity.pvp.PVPCRoomMediator;
   import com.mvc.views.mediator.mainCity.laboratory.TrainRoomMedia;
   import com.mvc.views.mediator.mainCity.laboratory.SetNameMedia;
   import com.mvc.views.mediator.mainCity.laboratory.HJCompoundMediator;
   import com.mvc.views.mediator.mainCity.elfSeries.RivalInfoMedia;
   import com.mvc.views.mediator.mainCity.elfSeries.SelectFormationMedia;
   import com.mvc.views.mediator.mainCity.elfSeries.PvpRecordMedia;
   import com.mvc.views.mediator.mainCity.friend.FriendAddMedia;
   import com.mvc.views.mediator.mapSelect.ExtenAdventureWinMedia;
   import com.mvc.views.mediator.mapSelect.MainAdventureWinMedia;
   import com.mvc.views.mediator.login.ServerListMedia;
   import com.mvc.views.mediator.mainCity.amuse.AmuseElfInfoMedia;
   import com.mvc.views.mediator.mainCity.shop.BuySureMedia;
   import com.mvc.views.mediator.mainCity.specialAct.dayRecharge.DayRechargeMediator;
   import com.mvc.views.mediator.mainCity.amuse.AmuseScoreRechargeMediator;
   import com.mvc.views.mediator.mainCity.specialAct.LimitSpecialElfMediaor;
   import com.mvc.views.mediator.mainCity.specialAct.flashElfAct.FlashBaoLiLongMediator;
   import com.mvc.views.mediator.mainCity.laboratory.ResetCharacterMediator;
   import com.mvc.views.mediator.mainCity.specialAct.ActPreviewMediator;
   import com.mvc.views.mediator.mainCity.mining.MiningDefendRecordMediator;
   import com.mvc.views.mediator.mainCity.mining.MiningSelectMemberMediator;
   import com.mvc.views.mediator.mainCity.mining.MiningInviteMediator;
   import com.mvc.views.mediator.mainCity.mining.MiningCheckFormatMediator;
   import com.mvc.views.mediator.mainCity.mining.MiningSelectTypeMediator;
   import com.mvc.views.mediator.mainCity.lottery.LotteryMedia;
   import com.mvc.views.uis.mainCity.miracle.MiracleMcUI;
   import com.mvc.views.uis.mainCity.shop.SaleTrashyProp;
   import com.mvc.views.uis.mapSelect.ExtendElfUnitTips;
   import com.mvc.views.uis.ShowBagElfUI;
   import com.mvc.views.uis.mainCity.chat.ChatBtnUI;
   import com.common.util.Finger;
   import com.mvc.views.uis.mainCity.backPack.ComposeUI;
   import com.mvc.views.uis.mainCity.firstRecharge.FirstRchRewardTips;
   import com.mvc.views.uis.fighting.FightFailUI;
   import com.mvc.views.uis.mainCity.backPack.NewSkillAlert;
   import com.mvc.views.uis.mainCity.chat.FaceUI;
   import com.mvc.views.uis.mainCity.myElf.BreakSuccessUI;
   import com.mvc.views.uis.mainCity.myElf.CarryThingUI;
   import com.mvc.views.uis.mainCity.myElf.CompChildUI;
   import com.mvc.views.uis.mainCity.myElf.EvolveSeleteUI;
   import com.mvc.views.uis.mainCity.myElf.EvolveUI;
   import com.mvc.views.uis.mainCity.myElf.EvoStoneGuideUI;
   import com.mvc.views.uis.mainCity.myElf.HagberryUI;
   import com.mvc.views.uis.mainCity.myElf.StarSuccessUI;
   import com.mvc.views.uis.mainCity.playerInfo.PlayerUpdateUI;
   import com.mvc.views.uis.mainCity.pvp.PVPMatchimgUI;
   import com.mvc.views.uis.mainCity.amuse.AmusePreviewUI;
   import com.mvc.views.uis.union.unionHall.Setting;
   import com.mvc.views.uis.union.unionStudy.MarkUpUI;
   import com.mvc.views.uis.union.unionList.CreateUnionUI;
   import com.mvc.views.uis.union.unionHall.UnionHelpUI;
   import com.mvc.views.uis.union.unionWorld.UnionNoticeUI;
   import com.mvc.views.uis.mainCity.exChange.ExSeleElfUI;
   import com.mvc.views.uis.mainCity.exChange.GotoExChange;
   import com.mvc.views.uis.mainCity.mining.MiningRule;
   import com.mvc.views.uis.mapSelect.SeleLocalUI;
   import com.mvc.views.uis.mainCity.myElf.ElfSpeciesTipsUI;
   import com.mvc.views.mediator.mainCity.playerInfo.buyDiamond.BuyDiamondMediator;
   import com.mvc.views.mediator.mainCity.playerInfo.buyMoney.BuyMoneyMediator;
   import com.mvc.views.mediator.mainCity.playerInfo.buyPower.BuyPowerMediator;
   import com.mvc.views.mediator.mainCity.playerInfo.infoPanel.ChangeHeadMediator;
   import com.mvc.views.mediator.mainCity.playerInfo.infoPanel.ChangeNameMediator;
   import com.mvc.views.mediator.mainCity.playerInfo.infoPanel.ChangeTrainerMediator;
   import com.mvc.views.mediator.mainCity.playerInfo.infoPanel.GameSettingMediator;
   import com.mvc.views.mediator.mainCity.playerInfo.infoPanel.InfoPanelMediator;
   import com.mvc.views.mediator.mainCity.playerInfo.PlayInfoBarMediator;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import com.common.util.loading.GameLoading;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.dialogue.Dialogue;
   import com.common.util.dialogue.NPCDialogue;
   import com.mvc.models.vos.fighting.NPCVO;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.managers.LoadOtherAssetsManager;
   import com.mvc.views.mediator.mainCity.chat.ChatMedia;
   import com.mvc.views.uis.mainCity.chat.ChatUI;
   import com.mvc.views.uis.mainCity.pvp.PVPBgUI;
   import com.common.util.WinTweens;
   
   public class CheckNetStatus
   {
      
      public static var monitor:URLMonitor;
      
      private static var client:com.common.net.Client;
      
      public static var reCheck:uint;
      
      public static var isHaveConnect:Boolean;
      
      public static var _isUseLogin:Boolean = true;
       
      public function CheckNetStatus()
      {
         super();
         init();
      }
      
      public static function init() : void
      {
         if(monitor != null)
         {
            return;
         }
         LogUtil("初始化检查网络");
         var _loc1_:URLRequest = new URLRequest("http://www.baidu.com");
         _loc1_.method = "HEAD";
         monitor = new URLMonitor(_loc1_);
         monitor.addEventListener("status",announceStatus);
         monitor.pollInterval = 1000;
         client = com.common.net.Client.getInstance();
      }
      
      protected static function announceStatus(param1:StatusEvent) : void
      {
         LogUtil("event",param1.code);
         LogUtil("是服务器断开, 或者因来电断开，或者网络，一律重连");
         if(monitor.available)
         {
            client.newSocket();
            client.connect(client._host,client._port);
            monitor.stop();
         }
      }
      
      public static function reConnect() : void
      {
         isHaveConnect = true;
         var _loc1_:Alert = Alert.show("亲，网络已断开, 是否重新连接？","",new ListCollection([{"label":"重连"}]));
         _loc1_.addEventListener("close",reLoginHandler);
         GameFacade.getInstance().sendNotification("pvp_timer_stop");
      }
      
      private static function reLoginHandler(param1:Event, param2:Object) : void
      {
         if(param2.label == "重连")
         {
            if(!client.connected)
            {
               NETLoading.addLoading();
               clearTimeout(reCheck);
               reCheck = setTimeout(CheckState,3000);
               return;
            }
            (Facade.getInstance().retrieveProxy("LoginPro") as LoginPro).write1009();
         }
      }
      
      private static function CheckState() : void
      {
         NETLoading.removeLoading();
         var _loc1_:Alert = Alert.show("亲，你的网络还没连上, 是否再次连接？","",new ListCollection([{"label":"重连"}]));
         _loc1_.addEventListener("close",reLoginHandler);
      }
      
      public static function otherLogin(param1:String = "你的账号在别的地方登陆") : void
      {
         var _loc2_:Alert = Alert.show(param1,"",new ListCollection([{"label":"确定"}]));
         _loc2_.addEventListener("close",exitHandle);
      }
      
      private static function exitHandle() : void
      {
         NativeApplication.nativeApplication.exit();
         UmengExtension.getInstance().UMAnalysic("exit");
      }
      
      private static function removeEvents() : void
      {
         EventCenter.removeEventListeners("ACTIVE_REWARD_SUCCESS");
         EventCenter.removeEventListeners("amuse_send_reward");
         EventCenter.removeEventListeners("BOKEN_COMPOSE_SUCCES");
         EventCenter.removeEventListeners("close_alert");
         EventCenter.removeEventListeners("CREATE_CITY_COMPLETE");
         EventCenter.removeEventListeners("CREATE_SET_NAME");
         EventCenter.removeEventListeners("elf_evolve_mc_complete");
         EventCenter.removeEventListeners("HABIT_SUCCESS");
         EventCenter.removeEventListeners("hp_change_pro");
         EventCenter.removeEventListeners("LOAD_LOGIN_ASSET_COMPLETE");
         EventCenter.removeEventListeners("load_other_asset_complete");
         EventCenter.removeEventListeners("load_swf_asset_complete");
         EventCenter.removeEventListeners("npc_dialogue_end");
         EventCenter.removeEventListeners("NPC_DIALOGUE_EVENT");
         EventCenter.removeEventListeners("UNLOCK_SUCCESS");
         EventCenter.removeEventListeners("UPDATE_BAG_SUCCESS");
         EventCenter.removeEventListeners("WIN_PLAY_COMPLETE");
      }
      
      private static function alertHandle() : void
      {
         if(Config.stage.getChildByName("alert") != null)
         {
            Config.stage.getChildByName("alert").removeFromParent(true);
         }
      }
      
      private static function disposeWin() : void
      {
         if(Facade.getInstance().hasMediator("GetPropMedia"))
         {
            (Facade.getInstance().retrieveMediator("GetPropMedia") as GetPropMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("SignMedia"))
         {
            (Facade.getInstance().retrieveMediator("SignMedia") as SignMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("MyElfMedia"))
         {
            (Facade.getInstance().retrieveMediator("MyElfMedia") as MyElfMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("BackPackMedia"))
         {
            (Facade.getInstance().retrieveMediator("BackPackMedia") as BackPackMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("IllustrationsMedia"))
         {
            (Facade.getInstance().retrieveMediator("IllustrationsMedia") as IllustrationsMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("TaskMedia"))
         {
            (Facade.getInstance().retrieveMediator("TaskMedia") as TaskMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("FriendMedia"))
         {
            (Facade.getInstance().retrieveMediator("FriendMedia") as FriendMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("InformationMedia"))
         {
            (Facade.getInstance().retrieveMediator("InformationMedia") as InformationMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("ActiveMeida"))
         {
            (Facade.getInstance().retrieveMediator("ActiveMeida") as ActiveMeida).dispose();
         }
         if(Facade.getInstance().hasMediator("FirstRchargeMediator"))
         {
            (Facade.getInstance().retrieveMediator("FirstRchargeMediator") as FirstRchargeMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("EvolveMcMediator"))
         {
            (Facade.getInstance().retrieveMediator("EvolveMcMediator") as EvolveMcMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("SetElfNameMedia"))
         {
            (Facade.getInstance().retrieveMediator("SetElfNameMedia") as SetElfNameMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("MiracleMediator"))
         {
            (Facade.getInstance().retrieveMediator("MiracleMediator") as MiracleMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("SelePlayElfMedia"))
         {
            (Facade.getInstance().retrieveMediator("SelePlayElfMedia") as SelePlayElfMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("GrowthPlanMediator"))
         {
            (Facade.getInstance().retrieveMediator("GrowthPlanMediator") as GrowthPlanMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("ScoreShopMediator"))
         {
            (Facade.getInstance().retrieveMediator("ScoreShopMediator") as ScoreShopMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("TrainMedia"))
         {
            (Facade.getInstance().retrieveMediator("TrainMedia") as TrainMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("RanklistMedia"))
         {
            (Facade.getInstance().retrieveMediator("RanklistMedia") as RanklistMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("HornMedia"))
         {
            (Facade.getInstance().retrieveMediator("HornMedia") as HornMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("ChatPlayerMedia"))
         {
            (Facade.getInstance().retrieveMediator("ChatPlayerMedia") as ChatPlayerMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("PlayElfMedia"))
         {
            (Facade.getInstance().retrieveMediator("PlayElfMedia") as PlayElfMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("SkillPanelMedia"))
         {
            (Facade.getInstance().retrieveMediator("SkillPanelMedia") as SkillPanelMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("ElfDetailInfoMedia"))
         {
            (Facade.getInstance().retrieveMediator("ElfDetailInfoMedia") as ElfDetailInfoMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("DiamondUpMediator"))
         {
            (Facade.getInstance().retrieveMediator("DiamondUpMediator") as DiamondUpMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("StudyChildMedia"))
         {
            (Facade.getInstance().retrieveMediator("StudyChildMedia") as StudyChildMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("UnionStudyMedia"))
         {
            (Facade.getInstance().retrieveMediator("UnionStudyMedia") as UnionStudyMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("OtherTrainMedia"))
         {
            (Facade.getInstance().retrieveMediator("OtherTrainMedia") as OtherTrainMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("UnionTrainMedia"))
         {
            (Facade.getInstance().retrieveMediator("UnionTrainMedia") as UnionTrainMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("UnionHallMedia"))
         {
            (Facade.getInstance().retrieveMediator("UnionHallMedia") as UnionHallMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("MedalMedia"))
         {
            (Facade.getInstance().retrieveMediator("MedalMedia") as MedalMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("ReCallSkillMedia"))
         {
            (Facade.getInstance().retrieveMediator("ReCallSkillMedia") as ReCallSkillMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("HuntingSelectTickMediator"))
         {
            (Facade.getInstance().retrieveMediator("HuntingSelectTickMediator") as HuntingSelectTickMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("FreeSelectElfMediator"))
         {
            (Facade.getInstance().retrieveMediator("FreeSelectElfMediator") as FreeSelectElfMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("ResetElfMediator"))
         {
            (Facade.getInstance().retrieveMediator("ResetElfMediator") as ResetElfMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("MiracleSelectElfMediator"))
         {
            (Facade.getInstance().retrieveMediator("MiracleSelectElfMediator") as MiracleSelectElfMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("SeleTrainElfMedia"))
         {
            (Facade.getInstance().retrieveMediator("SeleTrainElfMedia") as SeleTrainElfMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("LoginWidowMedia"))
         {
            (Facade.getInstance().retrieveMediator("LoginWidowMedia") as LoginWidowMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("TrialBossInfoMediator"))
         {
            (Facade.getInstance().retrieveMediator("TrialBossInfoMediator") as TrialBossInfoMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("TrialSelectDifficultyModiator"))
         {
            (Facade.getInstance().retrieveMediator("TrialSelectDifficultyModiator") as TrialSelectDifficultyModiator).dispose();
         }
         if(Facade.getInstance().hasMediator("TrialSelectBossMediator"))
         {
            (Facade.getInstance().retrieveMediator("TrialSelectBossMediator") as TrialSelectBossMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("ScoreGoodsInfoMediator"))
         {
            (Facade.getInstance().retrieveMediator("ScoreGoodsInfoMediator") as ScoreGoodsInfoMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("ScoreShopMediator"))
         {
            (Facade.getInstance().retrieveMediator("ScoreShopMediator") as ScoreShopMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("PVPPropMediator"))
         {
            (Facade.getInstance().retrieveMediator("PVPPropMediator") as PVPPropMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("PVPRankMediator"))
         {
            (Facade.getInstance().retrieveMediator("PVPRankMediator") as PVPRankMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("PVPRuleMediator"))
         {
            (Facade.getInstance().retrieveMediator("PVPRuleMediator") as PVPRuleMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("PVPCheckPswMediator"))
         {
            (Facade.getInstance().retrieveMediator("PVPCheckPswMediator") as PVPCheckPswMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("PVPCRoomMediator"))
         {
            (Facade.getInstance().retrieveMediator("PVPCRoomMediator") as PVPCRoomMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("TrainRoomMedia"))
         {
            (Facade.getInstance().retrieveMediator("TrainRoomMedia") as TrainRoomMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("SetNameMedia"))
         {
            (Facade.getInstance().retrieveMediator("SetNameMedia") as SetNameMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("HJCompoundMediator"))
         {
            (Facade.getInstance().retrieveMediator("HJCompoundMediator") as HJCompoundMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("RivalInfoMedia"))
         {
            (Facade.getInstance().retrieveMediator("RivalInfoMedia") as RivalInfoMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("SelectFormationMedia"))
         {
            (Facade.getInstance().retrieveMediator("SelectFormationMedia") as SelectFormationMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("PvpRecordMedia"))
         {
            (Facade.getInstance().retrieveMediator("PvpRecordMedia") as PvpRecordMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("FriendAddMedia"))
         {
            (Facade.getInstance().retrieveMediator("FriendAddMedia") as FriendAddMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("ExtenMapWinMedia"))
         {
            (Facade.getInstance().retrieveMediator("ExtenMapWinMedia") as ExtenAdventureWinMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("MainMapWinMedia"))
         {
            (Facade.getInstance().retrieveMediator("MainMapWinMedia") as MainAdventureWinMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("ServerListMedia"))
         {
            (Facade.getInstance().retrieveMediator("ServerListMedia") as ServerListMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("AmuseElfInfoMedia"))
         {
            (Facade.getInstance().retrieveMediator("AmuseElfInfoMedia") as AmuseElfInfoMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("BuySureMedia"))
         {
            (Facade.getInstance().retrieveMediator("BuySureMedia") as BuySureMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("DayRechargeMediator"))
         {
            (Facade.getInstance().retrieveMediator("DayRechargeMediator") as DayRechargeMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("AmuseScoreRechargeMediator"))
         {
            (Facade.getInstance().retrieveMediator("AmuseScoreRechargeMediator") as AmuseScoreRechargeMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("LimitSpecialElfMediaor"))
         {
            (Facade.getInstance().retrieveMediator("LimitSpecialElfMediaor") as LimitSpecialElfMediaor).dispose();
         }
         if(Facade.getInstance().hasMediator("FlashBaoLiLongMediator"))
         {
            (Facade.getInstance().retrieveMediator("FlashBaoLiLongMediator") as FlashBaoLiLongMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("ResetCharacterMediator"))
         {
            (Facade.getInstance().retrieveMediator("ResetCharacterMediator") as ResetCharacterMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("ActPreviewMediator"))
         {
            (Facade.getInstance().retrieveMediator("ActPreviewMediator") as ActPreviewMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("MiningDefendRecordMediator"))
         {
            (Facade.getInstance().retrieveMediator("MiningDefendRecordMediator") as MiningDefendRecordMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("MiningSelectMemberMediator"))
         {
            (Facade.getInstance().retrieveMediator("MiningSelectMemberMediator") as MiningSelectMemberMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("MiningInviteMediator"))
         {
            (Facade.getInstance().retrieveMediator("MiningInviteMediator") as MiningInviteMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("MiningCheckFormatMediator"))
         {
            (Facade.getInstance().retrieveMediator("MiningCheckFormatMediator") as MiningCheckFormatMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("MiningSelectTypeMediator"))
         {
            (Facade.getInstance().retrieveMediator("MiningSelectTypeMediator") as MiningSelectTypeMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("LotteryMedia"))
         {
            (Facade.getInstance().retrieveMediator("LotteryMedia") as LotteryMedia).dispose();
         }
         if(MiracleMcUI.callBack)
         {
            MiracleMcUI.getInstances().disposeMiracleMc();
         }
         if(SaleTrashyProp.instance)
         {
            SaleTrashyProp.getInstance().closeWin();
         }
         if(ExtendElfUnitTips.instance)
         {
            ExtendElfUnitTips.getInstance().removeElfTips();
         }
         if(ShowBagElfUI.instance)
         {
            ShowBagElfUI.getInstance().remove();
         }
         if(ChatBtnUI.instance)
         {
            ChatBtnUI.getInstance().remove();
         }
         if(Finger.instance)
         {
            Finger.getInstance().remove();
         }
         if(ComposeUI.instance)
         {
            ComposeUI.getInstance().close();
         }
         if(FirstRchRewardTips.instance)
         {
            FirstRchRewardTips.getInstance().removePropTips();
         }
         if(FightFailUI.instance)
         {
            FightFailUI.getInstance().remove();
         }
         if(NewSkillAlert.instance)
         {
            NewSkillAlert.getInstance().remove();
         }
         if(FaceUI.instance)
         {
            FaceUI.getInstance().remove();
         }
         if(BreakSuccessUI.instance)
         {
            BreakSuccessUI.getInstance().onclose();
         }
         if(CarryThingUI.instance)
         {
            CarryThingUI.getInstance().onClose();
         }
         if(CompChildUI.instance)
         {
            CompChildUI.getInstance().remove();
         }
         if(EvolveSeleteUI.instance)
         {
            EvolveSeleteUI.getInstance().remove();
         }
         if(EvolveUI.instance)
         {
            EvolveUI.getInstance().remove();
         }
         if(EvoStoneGuideUI.instance)
         {
            EvoStoneGuideUI.getInstance().remove();
         }
         if(HagberryUI.instance)
         {
            HagberryUI.getInstance().onClose();
         }
         if(StarSuccessUI.instance)
         {
            StarSuccessUI.getInstance().onclose();
         }
         if(PlayerUpdateUI.instance)
         {
            PlayerUpdateUI.getInstance().remove();
         }
         if(PVPMatchimgUI.instance)
         {
            PVPMatchimgUI.getInstance().disposeSelf();
         }
         if(AmusePreviewUI.instance)
         {
            AmusePreviewUI.getInstance().removeSelf();
         }
         if(Setting.instance)
         {
            Setting.getInstance().remove();
         }
         if(MarkUpUI.instance)
         {
            MarkUpUI.getInstance().remove();
         }
         if(CreateUnionUI.instance)
         {
            CreateUnionUI.getInstance().remove();
         }
         if(UnionHelpUI.instance)
         {
            UnionHelpUI.getInstance().remove();
         }
         if(UnionNoticeUI.instance)
         {
            UnionNoticeUI.getInstance().remove();
         }
         if(ExSeleElfUI.instance)
         {
            ExSeleElfUI.getInstance().remove();
         }
         if(GotoExChange.instance)
         {
            GotoExChange.getInstance().remove();
         }
         if(MiningRule.instance)
         {
            MiningRule.getInstance().removeSelf();
         }
         if(SeleLocalUI.instance)
         {
            SeleLocalUI.getInstance().remove();
         }
         if(ElfSpeciesTipsUI.instance)
         {
            ElfSpeciesTipsUI.getInstance().removeSelf();
         }
      }
      
      private static function disposePlayInfo(param1:Boolean = true) : void
      {
         if(Facade.getInstance().hasMediator("BuyDiamondMediator"))
         {
            (Facade.getInstance().retrieveMediator("BuyDiamondMediator") as BuyDiamondMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("BuyMoneyMediator"))
         {
            (Facade.getInstance().retrieveMediator("BuyMoneyMediator") as BuyMoneyMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("buyPowerMediator"))
         {
            (Facade.getInstance().retrieveMediator("buyPowerMediator") as BuyPowerMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("ChangeHeadMediator"))
         {
            (Facade.getInstance().retrieveMediator("ChangeHeadMediator") as ChangeHeadMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("ChangeNameMediator"))
         {
            (Facade.getInstance().retrieveMediator("ChangeNameMediator") as ChangeNameMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("ChangeTrainerMediator"))
         {
            (Facade.getInstance().retrieveMediator("ChangeTrainerMediator") as ChangeTrainerMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("GameSettingMediator"))
         {
            (Facade.getInstance().retrieveMediator("GameSettingMediator") as GameSettingMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("InfoPanelMediator"))
         {
            (Facade.getInstance().retrieveMediator("InfoPanelMediator") as InfoPanelMediator).dispose();
         }
         if(param1)
         {
            if(Facade.getInstance().hasMediator("PlayInfoBarMediator"))
            {
               (Facade.getInstance().retrieveMediator("PlayInfoBarMediator") as PlayInfoBarMediator).dispose();
            }
         }
         BeginnerGuide.dispose();
         Config.isOpenBeginner = false;
      }
      
      private static function loadLogin() : void
      {
         EventCenter.removeEventListener("LOAD_LOGIN_ASSET_COMPLETE",loadLogin);
         Facade.getInstance().sendNotification("switch_page","load_login_page");
         Pocketmon.sdkTool.login();
      }
      
      public static function reLogin() : void
      {
         if(client)
         {
            client.close();
         }
         exitHandle();
         UmengExtension.getInstance().UMSwitch("4|0");
      }
      
      public static function pvpInviteHandler() : void
      {
         Dialogue.removeFormParent(true);
         alertHandle();
         disposeWin();
         disposePlayInfo(false);
         if(Facade.getInstance().hasMediator("ChatMedia") && ((Facade.getInstance().retrieveMediator("ChatMedia") as ChatMedia).UI as ChatUI).parent)
         {
            Facade.getInstance().sendNotification("close_chat_before_pvp");
         }
         if((Config.starling.root as Game).page is PVPBgUI)
         {
            Facade.getInstance().sendNotification("close_friend_crroom_password_before_pvp");
         }
         if(WinTweens.isHideAll)
         {
            WinTweens.showCity();
         }
      }
      
      public static function miningDefendInviteHandler() : void
      {
         Dialogue.removeFormParent(true);
         alertHandle();
         disposeWin();
         disposePlayInfo(false);
         if(Facade.getInstance().hasMediator("ChatMedia") && ((Facade.getInstance().retrieveMediator("ChatMedia") as ChatMedia).UI as ChatUI).parent)
         {
            Facade.getInstance().sendNotification("close_chat_before_pvp");
         }
         if(WinTweens.isHideAll)
         {
            WinTweens.showCity();
         }
      }
   }
}
