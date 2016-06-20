package com.mvc.controllers
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import starling.display.DisplayObject;
   import com.mvc.views.mediator.fighting.CampOfComputerMedia;
   import com.mvc.views.mediator.fighting.CampOfPlayerMedia;
   import com.mvc.views.uis.mainCity.kingKwan.KingKwanUI;
   import com.mvc.views.uis.mainCity.mining.MiningFrameUI;
   import com.mvc.models.vos.fighting.FightingConfig;
   import starling.display.Image;
   import com.common.managers.LoadSwfAssetsManager;
   import lzm.starling.swf.Swf;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.fighting.NPCVO;
   import com.mvc.models.vos.elf.SkillVO;
   import org.puremvc.as3.interfaces.INotification;
   import com.massage.ane.UmengExtension;
   import com.mvc.views.uis.login.startChat.StartChatUI;
   import com.mvc.views.uis.mainCity.chat.ChatBtnUI;
   import com.mvc.views.mediator.mainCity.backPack.BackPackMedia;
   import com.mvc.views.uis.mainCity.backPack.BackPackUI;
   import com.common.util.IsAllElfDie;
   import com.mvc.views.uis.mainCity.pvp.PVPBgUI;
   import com.common.util.Finger;
   import com.common.managers.ElfFrontImageManager;
   import com.common.managers.NpcImageManager;
   import com.mvc.models.proxy.fighting.FightingPro;
   import com.common.events.EventCenter;
   import com.common.managers.LoadOtherAssetsManager;
   import com.mvc.models.proxy.mapSelect.MapPro;
   import com.mvc.models.proxy.mainCity.amuse.AmusePro;
   import com.mvc.views.uis.mainCity.MainCityUI;
   import com.mvc.views.mediator.huntingParty.HuntingPartyMedia;
   import com.mvc.views.uis.huntingParty.HuntingPartyUI;
   import com.common.util.xmlVOHandler.GetHuntingParty;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.proxy.huntingParty.HuntingPartyPro;
   import com.mvc.views.mediator.mainCity.mining.MiningFrameMediator;
   import com.common.util.RewardHandle;
   import com.mvc.views.mediator.mainCity.exChange.ExChangeMedia;
   import com.mvc.views.uis.mainCity.exChange.ExChangeUI;
   import com.mvc.models.proxy.mainCity.exChange.ExChangePro;
   import com.mvc.views.mediator.union.unionList.UnionListMedia;
   import com.mvc.views.uis.union.unionList.UnionListUI;
   import com.mvc.models.proxy.union.UnionPro;
   import com.mvc.views.mediator.mainCity.auction.AuctionMedia;
   import com.mvc.views.uis.mainCity.auction.AuctionUI;
   import com.mvc.models.proxy.mainCity.auction.AuctionPro;
   import com.mvc.views.mediator.mapSelect.CityMapMeida;
   import com.mvc.views.uis.mainCity.myElf.EvoStoneGuideUI;
   import com.mvc.views.mediator.mapSelect.WorldMapMedia;
   import com.mvc.views.mediator.fighting.FightingMedia;
   import com.common.util.dialogue.Dialogue;
   import com.mvc.views.mediator.login.StartChatMedia;
   import com.common.util.dialogue.StartDialogue;
   import com.mvc.views.uis.mainCity.elfSeries.ElfSeriesUI;
   import com.mvc.models.proxy.mainCity.elfSeries.ElfSeriesPro;
   import com.mvc.models.proxy.mainCity.kingKwan.KingKwanPro;
   import com.common.util.fighting.GotoChallenge;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import com.mvc.views.mediator.mainCity.pvp.PVPBgMediator;
   import com.mvc.views.uis.mainCity.trial.TrialUI;
   import com.mvc.models.proxy.mainCity.trial.TrialPro;
   import com.mvc.views.mediator.mainCity.trial.TrialBossInfoMediator;
   import com.mvc.views.uis.mainCity.hunting.HuntingUI;
   import com.mvc.models.proxy.mainCity.mining.MiningPro;
   import com.mvc.views.uis.mapSelect.CityMapUI;
   import com.mvc.views.mediator.fighting.FightingLogicFactor;
   import com.mvc.views.mediator.mainCity.train.TrainMedia;
   import com.mvc.views.uis.mainCity.train.TrainUI;
   import com.mvc.models.proxy.mainCity.train.TrainPro;
   import com.mvc.views.uis.ShowBagElfUI;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import com.mvc.views.mediator.mainCity.hunting.HuntingMediator;
   import com.mvc.models.proxy.mainCity.hunting.HuntingPro;
   import com.mvc.views.mediator.mainCity.trial.TrialMediator;
   import com.mvc.views.mediator.mainCity.laboratory.LaboratoryMedia;
   import com.mvc.views.uis.mainCity.laboratory.LaboratoryUI;
   import com.common.util.loading.GameLoading;
   import extend.SoundEvent;
   import com.mvc.views.mediator.mainCity.home.HomeMedia;
   import com.mvc.views.uis.mainCity.home.HomeUI;
   import com.mvc.views.mediator.mainCity.elfCenter.ElfCenterMedia;
   import com.mvc.views.uis.mainCity.elfCenter.ElfCenterUI;
   import com.mvc.models.proxy.mainCity.elfCenter.ElfCenterPro;
   import com.mvc.views.mediator.mainCity.elfSeries.ElfSeriesMedia;
   import com.mvc.views.mediator.mainCity.amuse.AmuseMedia;
   import com.mvc.views.uis.mainCity.amuse.AmuseUI;
   import com.mvc.views.uis.mainCity.amuse.AddAmuseMcUI;
   import com.mvc.views.mediator.mainCity.amuse.AddAmuseMcMedia;
   import com.mvc.models.proxy.mainCity.lotteryUi.LotteryPro;
   import com.mvc.views.mediator.mainCity.lottery.LotteryMedia;
   import com.mvc.views.uis.mainCity.lottery.LotteryUI;
   import com.mvc.views.mediator.mainCity.kingKwan.KingKwanMedia;
   import com.common.util.loading.NETLoading;
   import com.mvc.views.mediator.mainCity.shop.ShopMedia;
   import com.mvc.views.uis.mainCity.shop.ShopUI;
   import com.mvc.views.uis.mainCity.shop.SaleTrashyProp;
   import com.mvc.models.proxy.mainCity.shop.ShopPro;
   import com.mvc.views.mediator.union.unionWorld.UnionWorldMedia;
   import com.mvc.views.uis.union.unionWorld.UnionWorldUI;
   import com.common.util.xmlVOHandler.GetUnionMedal;
   import com.mvc.views.uis.mapSelect.WorldMapUI;
   import com.mvc.views.mediator.mapSelect.WorldMapTwoMedia;
   import com.mvc.views.uis.mapSelect.WorldMapTwoUI;
   import com.mvc.views.mediator.mainCity.MainCityMedia;
   import com.mvc.views.mediator.mainCity.playerInfo.PlayInfoBarMediator;
   import com.mvc.GameFacade;
   import com.mvc.views.mediator.mainCity.MenuMedia;
   import com.mvc.views.uis.login.LoginUI;
   import com.mvc.views.mediator.login.LoginMedia;
   import com.common.net.CheckNetStatus;
   import lzm.util.LSOManager;
   import com.mvc.views.uis.fighting.FightVS;
   import com.mvc.views.uis.fighting.FightingUI;
   import com.mvc.views.uis.worldHorn.WorldTime;
   import com.common.util.ShowForceTip;
   import com.mvc.views.uis.mainCity.playerInfo.PlayInfoBarUI;
   import com.mvc.views.mediator.huntingParty.HuntingBagMedia;
   import com.mvc.views.mediator.huntingParty.HuntAdventureMedia;
   import com.mvc.views.mediator.huntingParty.HuntBuyCountMedia;
   import com.mvc.views.mediator.huntingParty.HuntingRankMedia;
   import com.mvc.views.mediator.huntingParty.HuntingRewardMedia;
   import com.mvc.views.mediator.huntingParty.HuntingTaskMedia;
   import com.mvc.views.mediator.huntingParty.BuffMedia;
   import com.mvc.views.mediator.mainCity.laboratory.SetNameMedia;
   import com.mvc.views.mediator.mainCity.laboratory.ResetElfMediator;
   import com.mvc.views.mediator.mainCity.laboratory.ReCallSkillMedia;
   import com.mvc.views.mediator.mainCity.laboratory.HJCompoundMediator;
   import com.mvc.views.mediator.mainCity.laboratory.ResetCharacterMediator;
   import com.mvc.views.mediator.mainCity.shop.BuySureMedia;
   import com.mvc.views.mediator.mainCity.amuse.AmuseElfInfoMedia;
   import com.mvc.views.mediator.mainCity.amuse.SetElfNameMedia;
   import com.mvc.views.mediator.mainCity.Illustrations.IllustrationsMedia;
   import com.mvc.views.mediator.mainCity.amuse.AmuseScoreRechargeMediator;
   import com.mvc.views.mediator.mainCity.elfSeries.SelectFormationMedia;
   import com.mvc.views.mediator.mainCity.elfSeries.PvpRecordMedia;
   import com.mvc.views.mediator.mainCity.elfSeries.RankPanleMedia;
   import com.mvc.views.mediator.mainCity.elfSeries.SeriesHelpMedia;
   import com.mvc.views.mediator.mainCity.kingKwan.KingHelpMedia;
   import com.mvc.views.mediator.mainCity.home.BagElfMedia;
   import com.mvc.views.mediator.mainCity.home.ComElfMedia;
   import com.mvc.views.mediator.mainCity.home.HomeElfInfoMedia;
   import com.mvc.views.mediator.mapSelect.MainAdventureWinMedia;
   import com.mvc.views.mediator.mapSelect.ExtenAdventureWinMedia;
   import com.mvc.views.uis.fighting.FightFailUI;
   import com.mvc.views.mediator.mainCity.backPack.PlayElfMedia;
   import com.common.util.loading.PVPLoading;
   import com.common.managers.SoundManager;
   import com.mvc.models.proxy.mainCity.backPack.BackPackPro;
   import com.mvc.views.mediator.login.LoginWidowMedia;
   import com.mvc.views.mediator.login.ServerListMedia;
   import com.mvc.views.mediator.mainCity.chat.HornMedia;
   import com.mvc.views.mediator.mainCity.chat.ChatPlayerMedia;
   import com.mvc.views.mediator.mainCity.chat.PrivateListMedia;
   import com.mvc.views.mediator.mainCity.chat.WorldChatMedia;
   import com.mvc.views.mediator.mainCity.chat.UnionChatMedia;
   import com.mvc.views.mediator.mainCity.chat.SystemChatMedia;
   import com.mvc.views.mediator.mainCity.chat.PrivateChatMedia;
   import com.mvc.views.mediator.mainCity.chat.RoomChatMediaotr;
   import com.mvc.views.mediator.mainCity.chat.ChatMedia;
   
   public class LoadPageCmd extends SimpleCommand
   {
      
      public static var lastPage:DisplayObject;
      
      public static var tempAutoFight:Boolean;
      
      public static var tempIsOpenFightingAni:Boolean;
      
      private static var tempDialogueDelay:Number;
      
      private static var isMiningFight:Boolean;
       
      private var rootClass:Game;
      
      private var gameBg:Image;
      
      private var secondOpen:String;
      
      public function LoadPageCmd()
      {
         super();
         rootClass = Config.starling.root as Game;
      }
      
      public static function fightResult() : int
      {
         var _loc1_:* = 0;
         if(CampOfComputerMedia.isAllElfDie)
         {
            LogUtil("对方精灵全死，胜");
            _loc1_ = 1;
         }
         if(CampOfPlayerMedia.isAllElfDie && !(lastPage is KingKwanUI) && !(lastPage is MiningFrameUI))
         {
            LogUtil("我方精灵全死不在王者之路，或不在挖矿，输");
            _loc1_ = 0;
         }
         if(FightingConfig.isGoOut)
         {
            LogUtil("我方逃跑，输");
            _loc1_ = 0;
            FightingConfig.isGoOut = false;
         }
         if(FightingConfig.isWin)
         {
            LogUtil("结果胜利，胜");
            _loc1_ = 1;
            FightingConfig.isWin = false;
         }
         return _loc1_;
      }
      
      private function addGameBg() : void
      {
         var _loc1_:* = null;
         if(gameBg)
         {
            _loc1_ = LoadSwfAssetsManager.getInstance().assets.getSwf("comment");
            gameBg = _loc1_.createImage("img_comBg");
         }
         rootClass.addChild(gameBg);
      }
      
      private function romoveGameBg() : void
      {
         if(gameBg && gameBg.parent)
         {
            gameBg.removeFromParent();
         }
      }
      
      private function getSkillAssets() : void
      {
         var _loc1_:* = 0;
         var _loc3_:* = null;
         var _loc2_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc1_] != null)
            {
               _loc3_ = PlayerVO.bagElfVec[_loc1_];
               if(Config.isOpenFightingAni)
               {
                  pushSkillAssets(_loc3_.currentSkillVec);
                  pushSkillMusicAssets(_loc3_.totalSkillVec);
               }
               if(FightingConfig.elfBackAssets.indexOf(_loc3_.imgName.substr(4) + "_b") == -1)
               {
                  FightingConfig.elfBackAssets.push(_loc3_.imgName.substr(4) + "_b");
               }
               if(FightingConfig.elfFrontAssets.indexOf(_loc3_.imgName) == -1)
               {
                  FightingConfig.elfFrontAssets.push(_loc3_.imgName);
               }
            }
            _loc1_++;
         }
         if(NPCVO.name != null)
         {
            _loc2_ = 0;
            while(_loc2_ < NPCVO.bagElfVec.length)
            {
               if(Config.isOpenFightingAni)
               {
                  pushSkillAssets(NPCVO.bagElfVec[_loc2_].currentSkillVec);
               }
               if(FightingConfig.elfFrontAssets.indexOf(NPCVO.bagElfVec[_loc2_].imgName) == -1)
               {
                  FightingConfig.elfFrontAssets.push(NPCVO.bagElfVec[_loc2_].imgName);
               }
               if(FightingConfig.elfBackAssets.indexOf(NPCVO.bagElfVec[_loc2_].imgName.substr(4) + "_b") == -1)
               {
                  FightingConfig.elfBackAssets.push(NPCVO.bagElfVec[_loc2_].imgName.substr(4) + "_b");
               }
               _loc2_++;
            }
         }
         else
         {
            LogUtil(FightingConfig.computerElfVO);
            if(FightingConfig.elfFrontAssets.indexOf(FightingConfig.computerElfVO.imgName) == -1)
            {
               FightingConfig.elfFrontAssets.push(FightingConfig.computerElfVO.imgName);
            }
            if(FightingConfig.elfBackAssets.indexOf(FightingConfig.computerElfVO.imgName.substr(4) + "_b") == -1)
            {
               FightingConfig.elfBackAssets.push(FightingConfig.computerElfVO.imgName.substr(4) + "_b");
            }
            if(Config.isOpenFightingAni)
            {
               pushSkillAssets(FightingConfig.computerElfVO.currentSkillVec);
            }
         }
         FightingConfig.elfBackAssets.push("avatars_b");
         FightingConfig.elfFrontAssets.push("img_avatars");
      }
      
      private function pushSkillMusicAssets(param1:Vector.<SkillVO>) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = "skill" + param1[_loc3_].id;
            if(FightingConfig.skillMusicAssets.indexOf(param1[_loc3_].soundName) == -1)
            {
               FightingConfig.skillMusicAssets.push(param1[_loc3_].soundName);
            }
            _loc3_++;
         }
      }
      
      private function pushSkillAssets(param1:Vector.<SkillVO>) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            LogUtil("技能的id" + param1[_loc3_].id);
            _loc2_ = "skill" + param1[_loc3_].id;
            if(FightingConfig.skillMusicAssets.indexOf(param1[_loc3_].soundName) == -1)
            {
               FightingConfig.skillMusicAssets.push(param1[_loc3_].soundName);
            }
            _loc3_++;
         }
      }
      
      override public function execute(param1:INotification) : void
      {
         note = param1;
         var _loc3_:* = note.getBody() as String;
         if("load_login_page" !== _loc3_)
         {
            if("load_fighting_page" !== _loc3_)
            {
               if("load_maincity_page" !== _loc3_)
               {
                  if("LOAD_UNIONWORLD_PAGE" !== _loc3_)
                  {
                     if("load_world_map_page" !== _loc3_)
                     {
                        if("LOAD_WORLD_MAPTWO_PAGE" !== _loc3_)
                        {
                           if("load_city_map_page" !== _loc3_)
                           {
                              if("load_shop_page" !== _loc3_)
                              {
                                 if("LOAD_KING_PAGE" !== _loc3_)
                                 {
                                    if("LOAD_AMUSE_PAGE" !== _loc3_)
                                    {
                                       if("LOAD_LOTTERY" !== _loc3_)
                                       {
                                          if("load_amuse_mc" !== _loc3_)
                                          {
                                             if("LOAD_ELFSERIES_PAGE" !== _loc3_)
                                             {
                                                if("LOAD_ELFCENTER_PAGE" !== _loc3_)
                                                {
                                                   if("LOAD_HOME" !== _loc3_)
                                                   {
                                                      if("LOAD_START_CHAT" !== _loc3_)
                                                      {
                                                         if("load_pvp_page" !== _loc3_)
                                                         {
                                                            if("LOAD_LABORATORY_PAGE" !== _loc3_)
                                                            {
                                                               if("load_trial_page" !== _loc3_)
                                                               {
                                                                  if("load_hunting_page" !== _loc3_)
                                                                  {
                                                                     if("LOAD_TRAIN_PAGE" !== _loc3_)
                                                                     {
                                                                        if("LOAD_AUCTION_PAGE" !== _loc3_)
                                                                        {
                                                                           if("LOAD_UNIONLIST_PAGE" !== _loc3_)
                                                                           {
                                                                              if("LOAD_EXCHANGE_WIN" !== _loc3_)
                                                                              {
                                                                                 if("load_mining_page" !== _loc3_)
                                                                                 {
                                                                                    if("LOAD_HUNTINGPARTY_PAGE" !== _loc3_)
                                                                                    {
                                                                                       if("DISPOSE_ALL" !== _loc3_)
                                                                                       {
                                                                                          if("RETURN_LAST" !== _loc3_)
                                                                                          {
                                                                                             if("SHOW_PLAYERINFO" === _loc3_)
                                                                                             {
                                                                                                if(note.getType() == "0")
                                                                                                {
                                                                                                   showPlayInfoBar(true,false,false);
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                   showPlayInfoBar(true);
                                                                                                }
                                                                                             }
                                                                                          }
                                                                                          else
                                                                                          {
                                                                                             LogUtil("note.getType()===",note.getType());
                                                                                             loadLastPage(note.getType());
                                                                                          }
                                                                                       }
                                                                                       else
                                                                                       {
                                                                                          LogUtil("释放所有页面资源");
                                                                                          disposeAll();
                                                                                       }
                                                                                    }
                                                                                    else if(!facade.hasMediator("HuntingPartyMedia"))
                                                                                    {
                                                                                       EventCenter.addEventListener("load_swf_asset_complete",loadHuntingParty);
                                                                                       LoadSwfAssetsManager.getInstance().addAssets(Config.huntingPartyAssets);
                                                                                       UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|捕虫大会");
                                                                                    }
                                                                                 }
                                                                                 else
                                                                                 {
                                                                                    FightingConfig.selectMap = null;
                                                                                    if(!facade.hasMediator("MiningFrameMediator"))
                                                                                    {
                                                                                       EventCenter.addEventListener("load_swf_asset_complete",loadMining);
                                                                                       LoadSwfAssetsManager.getInstance().addAssets(Config.miningAssets);
                                                                                    }
                                                                                    UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|挖矿");
                                                                                 }
                                                                              }
                                                                              else
                                                                              {
                                                                                 if(!facade.hasMediator("ExChangeMedia"))
                                                                                 {
                                                                                    EventCenter.addEventListener("load_swf_asset_complete",loadExChange);
                                                                                    LoadSwfAssetsManager.getInstance().addAssets(Config.exChangeAssets);
                                                                                 }
                                                                                 UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|固定交换");
                                                                              }
                                                                           }
                                                                           else
                                                                           {
                                                                              if(!facade.hasMediator("UnionListMedia"))
                                                                              {
                                                                                 EventCenter.addEventListener("load_swf_asset_complete",loadUnionList);
                                                                                 LoadSwfAssetsManager.getInstance().addAssets(Config.unionAssets);
                                                                              }
                                                                              UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|公会选择");
                                                                           }
                                                                        }
                                                                        else
                                                                        {
                                                                           if(!facade.hasMediator("AuctionMedia"))
                                                                           {
                                                                              EventCenter.addEventListener("load_swf_asset_complete",loadAuction);
                                                                              LoadSwfAssetsManager.getInstance().addAssets(Config.auctionAssets);
                                                                           }
                                                                           UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|拍卖场");
                                                                        }
                                                                     }
                                                                     else
                                                                     {
                                                                        if(!facade.hasMediator("TrainMedia"))
                                                                        {
                                                                           EventCenter.addEventListener("load_swf_asset_complete",loadTrainElf);
                                                                           LoadSwfAssetsManager.getInstance().addAssets(Config.trainAssets);
                                                                        }
                                                                        else
                                                                        {
                                                                           loadTrainElf();
                                                                        }
                                                                        UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|训练");
                                                                     }
                                                                  }
                                                                  else
                                                                  {
                                                                     if(!facade.hasMediator("HuntingMediator"))
                                                                     {
                                                                        LogUtil("加载精灵狩猎场界面");
                                                                        EventCenter.addEventListener("load_swf_asset_complete",loadHunting);
                                                                        LoadSwfAssetsManager.getInstance().addAssets(Config.huntingAssets);
                                                                     }
                                                                     else
                                                                     {
                                                                        loadHunting();
                                                                     }
                                                                     UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|狩猎场");
                                                                  }
                                                               }
                                                               else
                                                               {
                                                                  if(!facade.hasMediator("TrialMediator"))
                                                                  {
                                                                     LogUtil("加载试炼界面");
                                                                     EventCenter.addEventListener("load_swf_asset_complete",loadTrial);
                                                                     LoadSwfAssetsManager.getInstance().addAssets(Config.trialAssets);
                                                                  }
                                                                  else
                                                                  {
                                                                     loadTrial();
                                                                  }
                                                                  UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|试炼");
                                                               }
                                                            }
                                                            else if(!facade.hasMediator("LaboratoryMedia"))
                                                            {
                                                               LogUtil("加载研究所界面");
                                                               EventCenter.addEventListener("load_swf_asset_complete",loadLab);
                                                               LoadSwfAssetsManager.getInstance().addAssets(Config.laboratoryAssets);
                                                            }
                                                            else
                                                            {
                                                               loadLab();
                                                            }
                                                         }
                                                         else
                                                         {
                                                            if(!facade.hasMediator("PVPBgMediator"))
                                                            {
                                                               LogUtil("加载pvp界面");
                                                               var startLoadPvp:Function = function():void
                                                               {
                                                                  LogUtil("开始加载pvp");
                                                                  EventCenter.removeEventListener("load_swf_asset_complete",startLoadPvp);
                                                                  EventCenter.addEventListener("load_swf_asset_complete",loadPVP);
                                                                  LoadSwfAssetsManager.getInstance().addAssets(Config.pvpAssets);
                                                               };
                                                               if(LoadSwfAssetsManager.getInstance().assets.isLoading)
                                                               {
                                                                  EventCenter.addEventListener("load_swf_asset_complete",startLoadPvp);
                                                               }
                                                               else
                                                               {
                                                                  startLoadPvp();
                                                               }
                                                            }
                                                            else
                                                            {
                                                               loadPVP();
                                                            }
                                                            UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|pvp挑战赛");
                                                         }
                                                      }
                                                      else
                                                      {
                                                         if(rootClass.page.name == "LoginMedia")
                                                         {
                                                            disposeLogin();
                                                         }
                                                         if(!facade.hasMediator("StartChatMedia"))
                                                         {
                                                            LogUtil("加载开始对话的界面ziyaun");
                                                            EventCenter.addEventListener("load_swf_asset_complete",loadStartChat);
                                                            var addStartChatAssets:Function = function():void
                                                            {
                                                               LoadSwfAssetsManager.getInstance().addAssets(Config.startChatAssets);
                                                            };
                                                            var loadOtherComplete:Function = function():void
                                                            {
                                                               EventCenter.removeEventListener("load_other_asset_complete",loadOtherComplete);
                                                               NpcImageManager.getInstance().getImg(["player01","player04"],addStartChatAssets);
                                                            };
                                                            EventCenter.addEventListener("load_other_asset_complete",loadOtherComplete);
                                                            LoadOtherAssetsManager.getInstance().addAssets(["music/startDia","music/beginGuideVoice"]);
                                                         }
                                                         else
                                                         {
                                                            loadStartChat();
                                                         }
                                                         UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|创建角色");
                                                      }
                                                   }
                                                   else
                                                   {
                                                      if(!facade.hasMediator("HomeMedia"))
                                                      {
                                                         EventCenter.addEventListener("load_swf_asset_complete",loadHome);
                                                         LoadSwfAssetsManager.getInstance().addAssets(Config.homeAssets);
                                                      }
                                                      else
                                                      {
                                                         loadHome();
                                                      }
                                                      UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|玩家的家");
                                                   }
                                                }
                                                else
                                                {
                                                   if(!facade.hasMediator("ElfCenterMedia"))
                                                   {
                                                      EventCenter.addEventListener("load_swf_asset_complete",loadElfCenter);
                                                      LoadSwfAssetsManager.getInstance().addAssets(Config.elfCenterAssets);
                                                   }
                                                   else
                                                   {
                                                      loadElfCenter();
                                                   }
                                                   UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|精灵中心");
                                                }
                                             }
                                             else
                                             {
                                                if(!facade.hasMediator("ElfSeriesMedia"))
                                                {
                                                   EventCenter.addEventListener("load_swf_asset_complete",loadElfSeries);
                                                   LoadSwfAssetsManager.getInstance().addAssets(Config.elfSeriesAssets);
                                                }
                                                else
                                                {
                                                   loadElfSeries();
                                                }
                                                UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|联盟大赛");
                                             }
                                          }
                                          else
                                          {
                                             LogUtil("ConfigConst.LOAD_AMUSE_MC");
                                             if(!facade.hasMediator("addAmuseMcMedia"))
                                             {
                                                LogUtil("弹出扭蛋精灵球爆开动画");
                                                EventCenter.addEventListener("load_swf_asset_complete",loadAmuseMc);
                                                LoadSwfAssetsManager.getInstance().addAssets(Config.amuseMcAssets,false,60);
                                             }
                                             else
                                             {
                                                loadAmuseMc();
                                             }
                                          }
                                       }
                                       else
                                       {
                                          if(!facade.hasMediator("LotteryMedia"))
                                          {
                                             EventCenter.addEventListener("load_swf_asset_complete",loadLottery);
                                             LoadSwfAssetsManager.getInstance().addAssets(Config.lotteryAssets);
                                          }
                                          else
                                          {
                                             loadLottery();
                                          }
                                          UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|抽奖");
                                       }
                                    }
                                    else
                                    {
                                       if(!AmusePro.amusePreviewArr)
                                       {
                                          AmusePro.getAmusePreviewElfVo();
                                       }
                                       if(!facade.hasMediator("AmuseMedia"))
                                       {
                                          EventCenter.addEventListener("load_swf_asset_complete",loadAmuse);
                                          LoadSwfAssetsManager.getInstance().addAssets(Config.amuseAssets);
                                       }
                                       else
                                       {
                                          loadAmuse();
                                       }
                                       UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|扭蛋机");
                                    }
                                 }
                                 else
                                 {
                                    if(!facade.hasMediator("KingKwanMedia"))
                                    {
                                       EventCenter.addEventListener("load_swf_asset_complete",loadKingKwan);
                                       LoadSwfAssetsManager.getInstance().addAssets(Config.kingKwanAssets);
                                    }
                                    else
                                    {
                                       loadKingKwan();
                                    }
                                    UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|王者之路");
                                 }
                              }
                              else
                              {
                                 if(!facade.hasMediator("ShopMedia"))
                                 {
                                    EventCenter.addEventListener("load_swf_asset_complete",loadShop);
                                    LoadSwfAssetsManager.getInstance().addAssets(Config.shopAssets);
                                 }
                                 else
                                 {
                                    loadShop();
                                 }
                                 UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|商店");
                              }
                           }
                           else if(!facade.hasMediator("MapMeida"))
                           {
                              EventCenter.addEventListener("load_swf_asset_complete",loadCityMap);
                              LoadOtherAssetsManager.getInstance().addCityAssets();
                           }
                           else
                           {
                              LoadOtherAssetsManager.getInstance().removeAsset([Config.cityScene],false);
                              EventCenter.addEventListener("load_other_asset_complete",loadCitySceneComplete);
                              LoadOtherAssetsManager.getInstance().addCityAssets(false);
                           }
                        }
                        else
                        {
                           if(FightingConfig.openCity == -1)
                           {
                              (facade.retrieveProxy("MapPro") as MapPro).write1705();
                              return;
                           }
                           if(!facade.hasMediator("WorldMapTwoMedia"))
                           {
                              EventCenter.addEventListener("load_swf_asset_complete",loadWorldMapTwo);
                              LoadSwfAssetsManager.getInstance().addAssets(Config.worldMapTwoAssets,false,30);
                           }
                           else
                           {
                              loadWorldMapTwo();
                           }
                        }
                     }
                     else
                     {
                        if(FightingConfig.openCity == -1)
                        {
                           (facade.retrieveProxy("MapPro") as MapPro).write1705();
                           return;
                        }
                        if(!facade.hasMediator("BigMapMedia"))
                        {
                           EventCenter.addEventListener("load_swf_asset_complete",loadWorldMap);
                           LoadSwfAssetsManager.getInstance().addAssets(Config.worldMapAssets,false,30);
                        }
                        else
                        {
                           loadWorldMap();
                        }
                     }
                  }
                  else if(!facade.hasMediator("UnionWorldMedia"))
                  {
                     EventCenter.addEventListener("load_swf_asset_complete",loadUnionWorld);
                     LoadSwfAssetsManager.getInstance().addAssets(Config.unionWorldAssets);
                     UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|公会");
                  }
               }
               else
               {
                  if(rootClass.page.name == "LoginMedia")
                  {
                     disposeLogin();
                  }
                  if(!facade.hasMediator("MainCityMedia"))
                  {
                     EventCenter.addEventListener("load_swf_asset_complete",loadMainCity);
                     LoadSwfAssetsManager.getInstance().addAssets(Config.mainCityAssets);
                  }
                  else
                  {
                     loadMainCity();
                  }
               }
            }
            else
            {
               if(!(rootClass.page is StartChatUI))
               {
                  ChatBtnUI.getInstance().remove();
               }
               if(!facade.hasMediator("BackPackMedia"))
               {
                  facade.registerMediator(new BackPackMedia(new BackPackUI()));
               }
               if(!IsAllElfDie.isAllElfDie())
               {
                  if(rootClass.page is PVPBgUI)
                  {
                     tempIsOpenFightingAni = Config.isOpenFightingAni;
                     Config.isOpenFightingAni = true;
                  }
                  if(Finger.getInstance().parent)
                  {
                     LogUtil("手指指向动画");
                     Finger.getInstance().removeFromParent();
                  }
                  ElfFrontImageManager.getInstance().dispose();
                  NpcImageManager.getInstance().dispose();
                  FightingConfig.skillMusicAssets = [];
                  FightingConfig.elfBackAssets = [];
                  if(FightingConfig.selectMap)
                  {
                     FightingConfig.FSceneAssets = [FightingConfig.selectMap.sceneName];
                  }
                  else
                  {
                     FightingConfig.FSceneAssets = [FightingConfig.sceneName];
                  }
                  getSkillAssets();
                  disposeMainCity();
                  disposeWorldMap();
                  disposeWorldMapTwoMedia();
                  FightingConfig.initPvpAllConfig();
                  (facade.retrieveProxy("FightingPro") as FightingPro).write3100();
                  EventCenter.addEventListener("load_swf_asset_complete",loadFighting);
                  LoadOtherAssetsManager.getInstance().addFightingAssets();
               }
               UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|战斗");
            }
         }
         else
         {
            loadLogin();
            UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|登录");
         }
      }
      
      private function loadHuntingParty() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadHuntingParty);
         if(rootClass.page is MainCityUI)
         {
            removePage(false);
         }
         else
         {
            removePage(true);
         }
         if(!facade.hasMediator("HuntingPartyMedia"))
         {
            facade.registerMediator(new HuntingPartyMedia(new HuntingPartyUI()));
         }
         rootClass.page = (facade.retrieveMediator("HuntingPartyMedia") as HuntingPartyMedia).UI;
         rootClass.addChild(rootClass.page);
         rootClass.page.name = "HuntingPartyMedia";
         ChatBtnUI.getInstance().remove();
         rootClass.page.touchable = false;
         showPlayInfoBar(false,true,true,true);
         rootClass.removePageChangeBg(loadHuntingPaertAfter);
      }
      
      private function loadHuntingPaertAfter() : void
      {
         if(GetHuntingParty.nodeVec.length == 0)
         {
            GetHuntingParty.GetHuntPartyNode();
         }
         if(GetHuntingParty.buffVec.length == 0)
         {
            GetHuntingParty.getAllBuff();
         }
         GetPropFactor.getHuntPartProp();
         rootClass.page.touchable = true;
         HuntingPartyMedia.isHuntParty = true;
         (facade.retrieveProxy("HuntingPartyPro") as HuntingPartyPro).write4101();
      }
      
      private function loadMining() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadMining);
         if(rootClass.page is MainCityUI)
         {
            removePage(false);
         }
         else
         {
            removePage(true);
         }
         disposeCityAndMap();
         if(!facade.hasMediator("MiningFrameMediator"))
         {
            facade.registerMediator(new MiningFrameMediator(new MiningFrameUI()));
         }
         rootClass.page = (facade.retrieveMediator("MiningFrameMediator") as MiningFrameMediator).UI;
         rootClass.page.name = "MiningFrameMediator";
         rootClass.addChild(rootClass.page);
         ChatBtnUI.getInstance().remove();
         sendNotification("mining_init_page");
         if(MiningFrameMediator.miningReward)
         {
            RewardHandle.Reward(MiningFrameMediator.miningReward);
            MiningFrameMediator.miningReward = null;
         }
         EventCenter.dispatchEvent("SENCOND_SWITCH");
      }
      
      private function loadExChange() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadExChange);
         removePage(false);
         if(!facade.hasMediator("ExChangeMedia"))
         {
            facade.registerMediator(new ExChangeMedia(new ExChangeUI()));
         }
         rootClass.page = (facade.retrieveMediator("ExChangeMedia") as ExChangeMedia).UI;
         rootClass.page.name = "ExChangeMedia";
         rootClass.addChild(rootClass.page);
         ChatBtnUI.getInstance().remove();
         (facade.retrieveProxy("ExChangePro") as ExChangePro).write3802();
      }
      
      private function loadUnionList() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadUnionList);
         if(rootClass.page is MainCityUI)
         {
            removePage(false);
         }
         else
         {
            removePage(true);
         }
         if(!facade.hasMediator("UnionListMedia"))
         {
            facade.registerMediator(new UnionListMedia(new UnionListUI()));
         }
         rootClass.page = (facade.retrieveMediator("UnionListMedia") as UnionListMedia).UI;
         rootClass.page.name = "UnionListMedia";
         rootClass.addChild(rootClass.page);
         ChatBtnUI.getInstance().remove();
         (facade.retrieveProxy("UnionPro") as UnionPro).write3400(UnionListMedia.currentPage);
      }
      
      private function loadAuction() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadAuction);
         removePage(false);
         if(!facade.hasMediator("AuctionMedia"))
         {
            facade.registerMediator(new AuctionMedia(new AuctionUI()));
         }
         rootClass.page = (facade.retrieveMediator("AuctionMedia") as AuctionMedia).UI;
         rootClass.page.name = "AuctionMedia";
         rootClass.addChild(rootClass.page);
         (facade.retrieveProxy("AuctionPro") as AuctionPro).write3201();
         showPlayInfoBar(false);
         ChatBtnUI.getInstance().remove();
      }
      
      private function loadCitySceneComplete() : void
      {
         trace("=============加载城市场景完成");
         EventCenter.removeEventListener("load_other_asset_complete",loadCitySceneComplete);
         CityMapMeida.recordMainAdvance = null;
         CityMapMeida.recordExtenAdvance = null;
         EvoStoneGuideUI.cityID = WorldMapMedia.mapVO.id;
         sendNotification("update_city_map_show",WorldMapMedia.mapVO);
         if(EvoStoneGuideUI.isEvoStoneGuide)
         {
            sendNotification("open_main_advance_list_by_evoStone",EvoStoneGuideUI.isHard);
         }
         rootClass.removePageChangeBg();
         (facade.retrieveProxy("MapPro") as MapPro).write1710(MapPro._mapVo.id);
      }
      
      private function loadLastPage(param1:String) : void
      {
         FightingMedia.isFighting = false;
         Dialogue.initAll();
         if(param1)
         {
            LogUtil("_secondOpen===",param1);
            secondOpen = param1;
            EventCenter.addEventListener("SENCOND_SWITCH",secondOpenWin);
         }
         if(lastPage is StartChatUI)
         {
            sendNotification("switch_page","LOAD_START_CHAT");
            StartChatMedia.fightResult = fightResult();
            StartDialogue.getInstance().playDialogue();
         }
         if(lastPage is ElfSeriesUI)
         {
            Config.isAutoFighting = tempAutoFight;
            sendNotification("switch_page","LOAD_ELFSERIES_PAGE");
            (facade.retrieveProxy("ElfSeriesPro") as ElfSeriesPro).write5002(NPCVO.useId,fightResult());
         }
         if(lastPage is KingKwanUI)
         {
            Config.isAutoFighting = tempAutoFight;
            (facade.retrieveProxy("KingKwanPro") as KingKwanPro).write2303(fightResult());
            sendNotification("switch_page","LOAD_KING_PAGE");
         }
         if(lastPage is PVPBgUI)
         {
            Config.isAutoFighting = tempAutoFight;
            Config.isOpenFightingAni = tempIsOpenFightingAni;
            Config.dialogueDelay = tempDialogueDelay;
            LogUtil("出来后的延迟时间" + Config.dialogueDelay);
            GotoChallenge.updateBagElfVecAfterPVP();
            (Facade.getInstance().retrieveProxy("PVPPro") as PVPPro).write6106(fightResult(),2,PVPBgMediator.pvpFrom);
         }
         if(lastPage is TrialUI)
         {
            (Facade.getInstance().retrieveProxy("TrialPro") as TrialPro).write2202(fightResult(),TrialBossInfoMediator.difficultyId,TrialBossInfoMediator.bossId);
         }
         if(lastPage is HuntingUI)
         {
            GotoChallenge.updateBagElfVecAfterPVP();
            sendNotification("switch_page","load_hunting_page");
         }
         if(lastPage is MiningFrameUI)
         {
            isMiningFight = true;
            (Facade.getInstance().retrieveProxy("Miningpro") as MiningPro).write3912(fightResult());
         }
         if(lastPage is CityMapUI)
         {
            sendNotification("switch_page","load_city_map_page");
         }
         if(lastPage is HuntingPartyUI)
         {
            GotoChallenge.updateBagElfVecAfterPVP();
            sendNotification("switch_page","LOAD_HUNTINGPARTY_PAGE");
         }
         FightingLogicFactor.isPVP = false;
         NPCVO.bagElfVec = Vector.<ElfVO>([]);
         NPCVO.unionAttackAdd = 1;
         NPCVO.unionDefenseAdd = 1;
      }
      
      private function secondOpenWin() : void
      {
         LogUtil("二次打开窗口",secondOpen);
         EventCenter.removeEventListener("SENCOND_SWITCH",secondOpenWin);
         sendNotification("switch_win",null,"LOAD_ELF_WIN");
         sendNotification("OPEN_CHILD_PAGE",secondOpen);
      }
      
      private function loadTrainElf() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadTrainElf);
         removePage(false);
         if(!facade.hasMediator("TrainMedia"))
         {
            facade.registerMediator(new TrainMedia(new TrainUI()));
         }
         var _loc1_:TrainUI = (facade.retrieveMediator("TrainMedia") as TrainMedia).UI as TrainUI;
         _loc1_.name = "TrainMedia";
         rootClass.addChild(_loc1_);
         (facade.retrieveProxy("TrainPro") as TrainPro).write3500(1);
         ShowBagElfUI.getInstance().remove();
         ChatBtnUI.getInstance().remove();
         BeginnerGuide.playBeginnerGuide();
      }
      
      private function loadHunting() : void
      {
         FightingConfig.selectMap = null;
         EventCenter.removeEventListener("load_swf_asset_complete",loadHunting);
         if(rootClass.page is MainCityUI)
         {
            removePage(false);
         }
         else
         {
            removePage(true);
         }
         if(!facade.hasMediator("HuntingMediator"))
         {
            facade.registerMediator(new HuntingMediator(new HuntingUI()));
         }
         rootClass.page = (facade.retrieveMediator("HuntingMediator") as HuntingMediator).UI;
         rootClass.addChild(rootClass.page);
         rootClass.page.name = "HuntingMediator";
         hidePlayInfoBar();
         (facade.retrieveProxy("HuntingPro") as HuntingPro).write2900();
         BeginnerGuide.playBeginnerGuide();
      }
      
      private function loadTrial() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadTrial);
         if(rootClass.page is MainCityUI)
         {
            removePage(false);
         }
         else
         {
            removePage(true);
         }
         disposeCityAndMap();
         if(!facade.hasMediator("TrialMediator"))
         {
            facade.registerMediator(new TrialMediator(new TrialUI()));
         }
         rootClass.page = (facade.retrieveMediator("TrialMediator") as TrialMediator).UI;
         rootClass.addChild(rootClass.page);
         rootClass.page.name = "TrialMediator";
         showPlayInfoBar();
         if(TrialMediator.trialReward != null)
         {
            LogUtil("有奖励吗。");
            RewardHandle.Reward(TrialMediator.trialReward);
            TrialMediator.trialReward = null;
         }
         (facade.retrieveProxy("TrialPro") as TrialPro).write2206();
         BeginnerGuide.playBeginnerGuide();
         EventCenter.dispatchEvent("SENCOND_SWITCH");
      }
      
      private function loadLab() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadLab);
         removePage(false);
         if(!facade.hasMediator("LaboratoryMedia"))
         {
            facade.registerMediator(new LaboratoryMedia(new LaboratoryUI()));
         }
         rootClass.page = (facade.retrieveMediator("LaboratoryMedia") as LaboratoryMedia).UI;
         rootClass.addChild(rootClass.page);
         rootClass.page.name = "LaboratoryMedia";
         showPlayInfoBar();
      }
      
      private function loadStartChat() : void
      {
         LogUtil("加载开始对话界面");
         EventCenter.removeEventListener("load_swf_asset_complete",loadStartChat);
         removePage(true);
         GameLoading.getIntance().removeLoading();
         if(!facade.hasMediator("StartChatMedia"))
         {
            facade.registerMediator(new StartChatMedia(new StartChatUI()));
         }
         rootClass.page = (facade.retrieveMediator("StartChatMedia") as StartChatMedia).UI as StartChatUI;
         rootClass.page.name = "StartChatMedia";
         rootClass.addChild(rootClass.page);
         SoundEvent.dispatchEvent("PLAY_BACKGROUND_MUSIC","mainCity");
      }
      
      private function loadHome() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadHome);
         if(rootClass.page is MainCityUI)
         {
            removePage(false);
         }
         else
         {
            removePage(true);
         }
         if(!facade.hasMediator("HomeMedia"))
         {
            facade.registerMediator(new HomeMedia(new HomeUI()));
         }
         rootClass.page = (facade.retrieveMediator("HomeMedia") as HomeMedia).UI;
         rootClass.page.name = "HomeMedia";
         rootClass.addChild(rootClass.page);
         sendNotification("SHOW_COM_ELF");
         sendNotification("SHOW_BAG_ELF");
         ShowBagElfUI.getInstance().remove();
         ChatBtnUI.getInstance().remove();
         if(PlayerVO.trainElfArr.length > 0)
         {
            EventCenter.addEventListener("UPDATE_TRAINELF_OVER",updateOver);
            (facade.retrieveProxy("TrainPro") as TrainPro).write3500(1);
         }
         BeginnerGuide.playBeginnerGuide();
      }
      
      private function updateOver() : void
      {
         LogUtil("----------------------------更新完训练位中背包的精灵------------------------------");
         EventCenter.removeEventListener("UPDATE_TRAINELF_OVER",updateOver);
         sendNotification("SHOW_COM_ELF");
         sendNotification("SHOW_BAG_ELF");
      }
      
      private function loadElfCenter() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadElfCenter);
         if(rootClass.page is MainCityUI)
         {
            removePage(false);
         }
         else
         {
            removePage(true);
         }
         disposeCityAndMap();
         disposeFighting();
         if(!facade.hasMediator("ElfCenterMedia"))
         {
            facade.registerMediator(new ElfCenterMedia(new ElfCenterUI()));
         }
         rootClass.page = (facade.retrieveMediator("ElfCenterMedia") as ElfCenterMedia).UI;
         rootClass.addChild(rootClass.page);
         rootClass.page.name = "ElfCenterMedia";
         (facade.retrieveProxy("ElfCenterPro") as ElfCenterPro).write2007("elfCenter");
         SoundEvent.dispatchEvent("PLAY_BACKGROUND_MUSIC","elfCenter");
         showPlayInfoBar();
         ShowBagElfUI.getInstance().remove();
         ChatBtnUI.getInstance().remove();
         BeginnerGuide.playBeginnerGuide();
      }
      
      private function loadElfSeries() : void
      {
         FightingConfig.selectMap = null;
         EventCenter.removeEventListener("load_swf_asset_complete",loadElfSeries);
         if(rootClass.page is MainCityUI)
         {
            removePage(false);
         }
         else
         {
            removePage(true);
         }
         disposeCityAndMap();
         if(!facade.hasMediator("ElfSeriesMedia"))
         {
            facade.registerMediator(new ElfSeriesMedia(new ElfSeriesUI()));
         }
         rootClass.page = (facade.retrieveMediator("ElfSeriesMedia") as ElfSeriesMedia).UI;
         sendNotification("SEND_FORMATION_MAIN");
         rootClass.addChild(rootClass.page);
         rootClass.page.name = "ElfSeriesMedia";
         (facade.retrieveProxy("ElfSeriesPro") as ElfSeriesPro).write5000();
         showPlayInfoBar();
         ShowBagElfUI.getInstance().remove();
         ChatBtnUI.getInstance().remove();
         BeginnerGuide.playBeginnerGuide();
         if(ElfSeriesMedia.isNew)
         {
            LogUtil("有人来挑战");
            ElfSeriesMedia.isNew = false;
            sendNotification("SHOW_SERIES_NEWS");
         }
         EventCenter.dispatchEvent("SENCOND_SWITCH");
      }
      
      private function loadAmuse() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadAmuse);
         if(rootClass.page is MainCityUI)
         {
            removePage(false);
         }
         else
         {
            removePage(true);
         }
         disposeCityAndMap();
         if(!facade.hasMediator("AmuseMedia"))
         {
            facade.registerMediator(new AmuseMedia(new AmuseUI()));
         }
         disposeFighting();
         rootClass.page = (facade.retrieveMediator("AmuseMedia") as AmuseMedia).UI;
         rootClass.addChild(rootClass.page);
         rootClass.page.name = "AmuseMedia";
         (facade.retrieveProxy("AmusePro") as AmusePro).write2500();
         showPlayInfoBar(false,true);
         ShowBagElfUI.getInstance().remove();
         ChatBtnUI.getInstance().remove();
         BeginnerGuide.playBeginnerGuide();
      }
      
      private function loadAmuseMc() : void
      {
         if(rootClass.page is AddAmuseMcUI)
         {
            sendNotification("send_rewardArr",AmuseMedia.rewardArr);
            return;
         }
         EventCenter.removeEventListener("load_swf_asset_complete",loadAmuseMc);
         removePage(false);
         if(!facade.hasMediator("addAmuseMcMedia"))
         {
            facade.registerMediator(new AddAmuseMcMedia(new AddAmuseMcUI()));
         }
         rootClass.page = (facade.retrieveMediator("addAmuseMcMedia") as AddAmuseMcMedia).UI as AddAmuseMcUI;
         rootClass.addChild(rootClass.page);
         rootClass.page.name = "addAmuseMcMedia";
         sendNotification("send_rewardArr",AmuseMedia.rewardArr);
      }
      
      private function loadLottery() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadLottery);
         if(rootClass.page is MainCityUI)
         {
            removePage(false);
         }
         else
         {
            removePage(true);
         }
         disposeCityAndMap();
         (facade.retrieveProxy("LotteryPro") as LotteryPro).write4001();
         if(!facade.hasMediator("LotteryMedia"))
         {
            facade.registerMediator(new LotteryMedia(new LotteryUI()));
         }
         rootClass.page = (facade.retrieveMediator("LotteryMedia") as LotteryMedia).UI as LotteryUI;
         rootClass.page.name = "LotteryMedia";
         rootClass.addChild(rootClass.page);
         hidePlayInfoBar();
         ShowBagElfUI.getInstance().remove();
         ChatBtnUI.getInstance().remove();
      }
      
      private function loadKingKwan() : void
      {
         FightingConfig.selectMap = null;
         EventCenter.removeEventListener("load_swf_asset_complete",loadKingKwan);
         if(rootClass.page is MainCityUI)
         {
            removePage(false);
         }
         else
         {
            removePage(true);
         }
         disposeCityAndMap();
         if(!facade.hasMediator("KingKwanMedia"))
         {
            facade.registerMediator(new KingKwanMedia(new KingKwanUI()));
         }
         rootClass.page = (facade.retrieveMediator("KingKwanMedia") as KingKwanMedia).UI;
         rootClass.addChild(rootClass.page);
         rootClass.page.name = "KingKwanMedia";
         if(KingKwanPro.kingVec.length == 0 || !PlayerVO.kingIsOpen)
         {
            (facade.retrieveProxy("KingKwanPro") as KingKwanPro).write2300();
         }
         else
         {
            sendNotification("SHOW_KING_LIST");
         }
         hidePlayInfoBar();
         ShowBagElfUI.getInstance().remove();
         ChatBtnUI.getInstance().remove();
         BeginnerGuide.playBeginnerGuide();
         EventCenter.dispatchEvent("SENCOND_SWITCH");
         NETLoading.addLoading2();
      }
      
      private function loadShop() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadShop);
         if(rootClass.page is MainCityUI)
         {
            removePage(false);
         }
         else if(rootClass.page is CityMapUI)
         {
            removePage(true);
         }
         disposeCityAndMap();
         if(!facade.hasMediator("ShopMedia"))
         {
            facade.registerMediator(new ShopMedia(new ShopUI()));
         }
         rootClass.page = (facade.retrieveMediator("ShopMedia") as ShopMedia).UI;
         if(lastPage is CityMapUI)
         {
            (facade.retrieveMediator("ShopMedia") as ShopMedia).switchBuyGoods(2);
         }
         else
         {
            (facade.retrieveMediator("ShopMedia") as ShopMedia).switchBuyGoods(0);
         }
         rootClass.addChild(rootClass.page);
         rootClass.page.name = "ShopMedia";
         showPlayInfoBar();
         ShowBagElfUI.getInstance().remove();
         ChatBtnUI.getInstance().remove();
         if(PlayerVO.trashyPropVec.length != 0)
         {
            SaleTrashyProp.getInstance().showWin();
         }
         (facade.retrieveProxy("ShopPro") as ShopPro).write3301();
      }
      
      private function loadUnionWorld() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadUnionWorld);
         if(rootClass.page is MainCityUI)
         {
            removePage(false);
         }
         else
         {
            removePage(true);
         }
         removePage(false);
         if(!facade.hasMediator("UnionWorldMedia"))
         {
            facade.registerMediator(new UnionWorldMedia(new UnionWorldUI()));
         }
         rootClass.page = (facade.retrieveMediator("UnionWorldMedia") as UnionWorldMedia).UI;
         rootClass.addChild(rootClass.page);
         rootClass.page.name = "UnionWorldMedia";
         ChatBtnUI.getInstance().remove();
         rootClass.page.touchable = false;
         showPlayInfoBar(true);
         rootClass.removePageChangeBg(loadUnionWorldAfter);
         ShowBagElfUI.getInstance().remove();
      }
      
      private function loadUnionWorldAfter() : void
      {
         ChatBtnUI.getInstance().show();
         (Facade.getInstance().retrieveProxy("UnionPro") as UnionPro).write3413();
         rootClass.page.touchable = true;
         if(GetUnionMedal.medalNameArr.length == 0)
         {
            GetUnionMedal.getAllInfo();
         }
      }
      
      private function loadWorldMap() : void
      {
         var _loc1_:* = false;
         EventCenter.removeEventListener("load_swf_asset_complete",loadWorldMap);
         if(rootClass.page is MainCityUI)
         {
            removePage(false);
            _loc1_ = true;
         }
         else
         {
            removePage(true);
         }
         if(!facade.hasMediator("BigMapMedia"))
         {
            facade.registerMediator(new WorldMapMedia(new WorldMapUI()));
         }
         rootClass.page = (facade.retrieveMediator("BigMapMedia") as WorldMapMedia).UI;
         rootClass.addChild(rootClass.page);
         rootClass.page.name = "BigMapMedia";
         if(_loc1_)
         {
            rootClass.removePageChangeBg();
         }
         showPlayInfoBar(true);
         ShowBagElfUI.getInstance().show();
         ChatBtnUI.getInstance().remove();
      }
      
      private function loadWorldMapTwo() : void
      {
         var _loc1_:* = false;
         EventCenter.removeEventListener("load_swf_asset_complete",loadWorldMapTwo);
         if(rootClass.page is MainCityUI)
         {
            removePage(false);
            _loc1_ = true;
         }
         else
         {
            removePage(true);
         }
         if(!facade.hasMediator("WorldMapTwoMedia"))
         {
            facade.registerMediator(new WorldMapTwoMedia(new WorldMapTwoUI()));
         }
         rootClass.page = (facade.retrieveMediator("WorldMapTwoMedia") as WorldMapTwoMedia).UI;
         rootClass.addChild(rootClass.page);
         rootClass.page.name = "WorldMapTwoMedia";
         if(_loc1_)
         {
            rootClass.removePageChangeBg();
         }
         showPlayInfoBar(true);
         ShowBagElfUI.getInstance().show();
         ChatBtnUI.getInstance().remove();
      }
      
      private function loadCityMap() : void
      {
         var _loc1_:* = false;
         trace("==============加载城市地图" + NPCVO.name);
         EventCenter.removeEventListener("load_swf_asset_complete",loadCityMap);
         if(rootClass.page is WorldMapUI || rootClass.page is MainCityUI || rootClass.page is WorldMapTwoUI)
         {
            _loc1_ = true;
            removePage(false);
         }
         else
         {
            removePage(true);
         }
         if(!facade.hasMediator("MapMeida"))
         {
            facade.registerMediator(new CityMapMeida(new CityMapUI()));
         }
         disposeMainCity();
         rootClass.page = (facade.retrieveMediator("MapMeida") as CityMapMeida).UI;
         rootClass.addChild(rootClass.page);
         rootClass.page.name = "MapMeida";
         ShowBagElfUI.getInstance().show();
         ChatBtnUI.getInstance().remove();
         showPlayInfoBar(true);
         EvoStoneGuideUI.cityID = WorldMapMedia.mapVO.id;
         sendNotification("update_city_map_show",WorldMapMedia.mapVO);
         if(EvoStoneGuideUI.isEvoStoneGuide)
         {
            sendNotification("open_main_advance_list_by_evoStone",EvoStoneGuideUI.isHard);
         }
         if(_loc1_)
         {
            rootClass.removePageChangeBg();
         }
         (facade.retrieveProxy("MapPro") as MapPro).write1710(MapPro._mapVo.id);
         EventCenter.dispatchEvent("SENCOND_SWITCH");
      }
      
      private function loadMainCity() : void
      {
         var _loc1_:* = false;
         NETLoading.removeLoading(true);
         GameLoading.getIntance().removeLoading();
         EventCenter.removeEventListener("load_swf_asset_complete",loadMainCity);
         removePage();
         disposeCityMap();
         disposeWorldMap();
         disposeWorldMapTwoMedia();
         LogUtil("lastPage===",lastPage);
         if(lastPage is UnionWorldUI)
         {
            _loc1_ = true;
         }
         if(!facade.hasMediator("MainCityMedia"))
         {
            facade.registerMediator(new MainCityMedia(new MainCityUI()));
         }
         rootClass.page = (facade.retrieveMediator("MainCityMedia") as MainCityMedia).UI;
         rootClass.addChild(rootClass.page);
         rootClass.page.name = "MainCityMedia";
         showPlayInfoBar(true);
         if(_loc1_)
         {
            ChatBtnUI.getInstance().remove();
            rootClass.removePageChangeBg(addChat);
         }
         else
         {
            ChatBtnUI.getInstance().show();
         }
         if(PlayInfoBarMediator.isFirstLoadMainCity)
         {
            PlayInfoBarMediator.isFirstLoadMainCity = false;
            sendNotification("update_play_info_bar");
         }
         SoundEvent.dispatchEvent("PLAY_BACKGROUND_MUSIC","mainCity");
         (rootClass.page as MainCityUI).scene.scrollContainer.horizontalScrollPosition = MainCityMedia.position;
         (rootClass.page as MainCityUI).advanceBtn.visible = true;
         (GameFacade.getInstance().retrieveMediator("MenuMedia") as MenuMedia).menu.spr_menu_row.visible = true;
         (GameFacade.getInstance().retrieveMediator("MenuMedia") as MenuMedia).menu.leftIntermittentSpr.visible = true;
         (rootClass.page as MainCityUI).scene.scrollContainer.isEnabled = true;
         BeginnerGuide.playBeginnerGuide();
         ShowBagElfUI.getInstance().remove();
         Facade.getInstance().sendNotification("TIP_GET_MAIL");
         EvoStoneGuideUI.cityID = -1;
         EventCenter.dispatchEvent("CREATE_CITY_COMPLETE");
         sendNotification("UPDATE_MAINCITYCHAT_NEWS");
         sendNotification("UPDATE_SELETE_BTN");
      }
      
      private function addChat() : void
      {
         (Facade.getInstance().retrieveProxy("UnionPro") as UnionPro).write3413(false);
         ChatBtnUI.getInstance().show();
      }
      
      private function loadLogin() : void
      {
         LogUtil("rootClass.page=",rootClass.page);
         if(rootClass.page is LoginUI)
         {
            removePage(false);
         }
         if(!facade.hasMediator("LoginMedia"))
         {
            facade.registerMediator(new LoginMedia(new LoginUI()));
         }
         rootClass.page = (facade.retrieveMediator("LoginMedia") as LoginMedia).UI;
         rootClass.addChild(rootClass.page);
         rootClass.page.name = "LoginMedia";
         if(!Config.isOpenNatice && Pocketmon.sdkTool.token == null)
         {
            Pocketmon.sdkTool.login();
         }
         SoundEvent.dispatchEvent("PLAY_BACKGROUND_MUSIC","login");
         if(!CheckNetStatus._isUseLogin)
         {
            EventCenter.dispatchEvent("SERVER_LIST",{
               "userId":Pocketmon.sdkTool.userId,
               "token":Pocketmon.sdkTool.token,
               "platform":Pocketmon.sdkTool.platform
            });
         }
      }
      
      private function loadFighting() : void
      {
         GameLoading.getIntance().removeLoading();
         EventCenter.removeEventListener("load_swf_asset_complete",loadFighting);
         if(rootClass.page is StartChatUI)
         {
            Config.isAutoFighting = false;
            LSOManager.put("isAutoFightSave",false);
            removePage(false);
         }
         else
         {
            removePage(true);
         }
         hidePlayInfoBar();
         ShowBagElfUI.getInstance().remove();
         LogUtil("加载战斗界面");
         SoundEvent.dispatchEvent("PLAY_BACKGROUND_MUSIC",FightingConfig.fightMusicAssets[0]);
         if(FightingConfig.selectMap != null && (FightingConfig.selectMap.isClub == 1 || FightingConfig.selectMap.id >= 292 && FightingConfig.selectMap.id <= 296))
         {
            FightVS.getInstance().show(NPCVO.imageName,showFighting);
            return;
         }
         showFighting();
         if(lastPage is KingKwanUI || lastPage is PVPBgUI || lastPage is ElfSeriesUI)
         {
            tempAutoFight = Config.isAutoFighting;
            Config.isAutoFighting = false;
            if(lastPage is PVPBgUI)
            {
               tempDialogueDelay = Config.dialogueDelay;
               Config.dialogueDelay = 0.5;
            }
         }
      }
      
      private function showFighting() : void
      {
         if(!facade.hasMediator("FightingMedia"))
         {
            facade.registerMediator(new FightingMedia(new FightingUI()));
         }
         rootClass.page = (facade.retrieveMediator("FightingMedia") as FightingMedia).UI;
         rootClass.addChild(rootClass.page);
         rootClass.page.name = "FightingMedia";
         sendNotification("update_fighting_ele",FightingConfig.computerElfVO,"camp_of_computer");
      }
      
      private function loadPVP() : void
      {
         FightingConfig.selectMap = null;
         EventCenter.removeEventListener("load_swf_asset_complete",loadPVP);
         if(rootClass.page is MainCityUI)
         {
            removePage(false);
         }
         else
         {
            removePage(true);
         }
         disposeAmuse();
         disposeAddAmuseMcMedia();
         disposeCityAndMap();
         if(!facade.hasMediator("PVPBgMediator"))
         {
            facade.registerMediator(new PVPBgMediator(new PVPBgUI()));
         }
         rootClass.page = (facade.retrieveMediator("PVPBgMediator") as PVPBgMediator).UI as PVPBgUI;
         rootClass.page.name = "PVPBgMediator";
         rootClass.addChild(rootClass.page);
         if(PVPBgMediator.pvpFrom == 1)
         {
            sendNotification("jump_pvp_game",true);
         }
         else if(PVPBgMediator.pvpFrom == 2)
         {
            sendNotification("jump_pvp_game",false);
         }
         if(PVPBgMediator.pvpReward != null)
         {
            LogUtil("有奖励吗。");
            RewardHandle.Reward(PVPBgMediator.pvpReward);
            PVPBgMediator.pvpReward = null;
         }
         ChatBtnUI.getInstance().show();
         ShowBagElfUI.getInstance().remove();
         BeginnerGuide.playBeginnerGuide();
         if(WorldTime.getInstance().day != LSOManager.get("DAY"))
         {
            ShowForceTip.getInstance().show(0,"11:00~14:00和18:00~22:00计算匹配次数和积分，其余在时间在开放时间内无限匹配次数但不计算积分。");
         }
      }
      
      private function showPlayInfoBar(param1:Boolean = false, param2:Boolean = false, param3:Boolean = true, param4:Boolean = false) : void
      {
         LogUtil("sdcscfsdfsdfsdfsdfsdfsd");
         if(!facade.hasMediator("PlayInfoBarMediator"))
         {
            facade.registerMediator(new PlayInfoBarMediator(new PlayInfoBarUI()));
         }
         var _loc5_:PlayInfoBarUI = (facade.retrieveMediator("PlayInfoBarMediator") as PlayInfoBarMediator).UI as PlayInfoBarUI;
         _loc5_.headBtn.removeFromParent();
         if(PlayerVO.vipRank)
         {
            if(PlayInfoBarMediator.isFirstShowVipBar)
            {
               PlayInfoBarMediator.isFirstShowVipBar = false;
               _loc5_.moneyBarSpr.x = _loc5_.moneyBarSpr.x + 50;
               _loc5_.diamondBarSpr.x = _loc5_.diamondBarSpr.x + 50;
               _loc5_.powerBarSpr.x = _loc5_.powerBarSpr.x + 50;
            }
            if(rootClass.page.name == "MainCityMedia" || rootClass.page.name == "MapMeida" || rootClass.page.name == "BigMapMedia")
            {
               _loc5_.addChild(_loc5_.vipSpr);
            }
            else
            {
               _loc5_.vipSpr.removeFromParent();
            }
         }
         _loc5_.addChild(_loc5_.moneyBarSpr);
         _loc5_.addChild(_loc5_.diamondBarSpr);
         _loc5_.addChild(_loc5_.powerBarSpr);
         _loc5_.name = "playerInfo";
         if(param3)
         {
            rootClass.addChild(_loc5_);
         }
         if(param1)
         {
            if(_loc5_.headBtn.parent == null)
            {
               _loc5_.addChild(_loc5_.headBtn);
            }
         }
         if(param2)
         {
            _loc5_.powerBarSpr.removeFromParent();
         }
         if(param4)
         {
            _loc5_.moneyBarSpr.removeFromParent();
            LogUtil("jinbiqidsfdfsdfsdf");
         }
      }
      
      private function hidePlayInfoBar() : void
      {
         if(!facade.hasMediator("PlayInfoBarMediator"))
         {
            return;
         }
         var _loc1_:PlayInfoBarUI = (facade.retrieveMediator("PlayInfoBarMediator") as PlayInfoBarMediator).UI as PlayInfoBarUI;
         _loc1_.removeFromParent();
      }
      
      private function disposeAll() : void
      {
         Dialogue.removeFormParent(true);
         CityMapMeida.recordMainAdvance = null;
         CityMapMeida.recordExtenAdvance = null;
         NPCVO.name = null;
         NPCVO.dialougBeforeFighting = [];
         NPCVO.dialougAfterFighting = [];
         NPCVO.isUseProp = false;
         NPCVO.isChangeElf = false;
         NPCVO.isSpecial = false;
         NPCVO.bagElfVec = Vector.<ElfVO>([]);
         NPCVO.unionAttackAdd = 1;
         NPCVO.unionDefenseAdd = 1;
         disposeWorldMap();
         disposeFighting();
         disposeCityMap();
         disposeMainCity();
         disposeHome();
         disposeKingKwan();
         disposeElfSeries();
         disposeElfCenter();
         disposeAmuse();
         disposeAddAmuseMcMedia();
         disposeShop();
         disposeStartChat();
         disposeLaboratory();
         disposePVP();
         disposeHunting();
         disposeAuction();
         disposeUnionList();
         disposeUnionWorld();
         disposeMining();
         disposeWorldMapTwoMedia();
         disposeHuntingParty();
      }
      
      private function removePage(param1:Boolean = true, param2:Boolean = true) : void
      {
         if(rootClass.page == null || rootClass.page.parent == null)
         {
            return;
         }
         hidePlayInfoBar();
         rootClass.removeChild(rootClass.page);
         if(facade.hasMediator("MainCityMedia"))
         {
            MainCityMedia.position = (facade.retrieveMediator("MainCityMedia") as MainCityMedia).mainCity.scene.scrollContainer.horizontalScrollPosition;
         }
         if(param1)
         {
            var _loc3_:* = rootClass.page.name;
            if("LoginMedia" !== _loc3_)
            {
               if("BigMapMedia" !== _loc3_)
               {
                  if("FightingMedia" !== _loc3_)
                  {
                     if("MapMeida" !== _loc3_)
                     {
                        if("MainCityMedia" !== _loc3_)
                        {
                           if("HomeMedia" !== _loc3_)
                           {
                              if("KingKwanMedia" !== _loc3_)
                              {
                                 if("LotteryMedia" !== _loc3_)
                                 {
                                    if("ElfSeriesMedia" !== _loc3_)
                                    {
                                       if("ElfCenterMedia" !== _loc3_)
                                       {
                                          if("AmuseMedia" !== _loc3_)
                                          {
                                             if("addAmuseMcMedia" !== _loc3_)
                                             {
                                                if("ShopMedia" !== _loc3_)
                                                {
                                                   if("StartChatMedia" !== _loc3_)
                                                   {
                                                      if("LaboratoryMedia" !== _loc3_)
                                                      {
                                                         if("PVPBgMediator" !== _loc3_)
                                                         {
                                                            if("TrialMediator" !== _loc3_)
                                                            {
                                                               if("HuntingMediator" !== _loc3_)
                                                               {
                                                                  if("TrainMedia" !== _loc3_)
                                                                  {
                                                                     if("AuctionMedia" !== _loc3_)
                                                                     {
                                                                        if("UnionListMedia" !== _loc3_)
                                                                        {
                                                                           if("UnionWorldMedia" !== _loc3_)
                                                                           {
                                                                              if("ExChangeMedia" !== _loc3_)
                                                                              {
                                                                                 if("MiningFrameMediator" !== _loc3_)
                                                                                 {
                                                                                    if("WorldMapTwoMedia" !== _loc3_)
                                                                                    {
                                                                                       if("HuntingPartyMedia" === _loc3_)
                                                                                       {
                                                                                          disposeHuntingParty();
                                                                                       }
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                       disposeWorldMapTwoMedia();
                                                                                    }
                                                                                 }
                                                                                 else
                                                                                 {
                                                                                    disposeMining();
                                                                                 }
                                                                              }
                                                                              else
                                                                              {
                                                                                 disposeExChange();
                                                                              }
                                                                           }
                                                                           else
                                                                           {
                                                                              disposeUnionWorld();
                                                                           }
                                                                        }
                                                                        else
                                                                        {
                                                                           disposeUnionList();
                                                                        }
                                                                     }
                                                                     else
                                                                     {
                                                                        disposeAuction();
                                                                     }
                                                                  }
                                                                  else
                                                                  {
                                                                     disposeTrain();
                                                                  }
                                                               }
                                                               else
                                                               {
                                                                  disposeHunting();
                                                               }
                                                            }
                                                            else
                                                            {
                                                               disposeTrial();
                                                            }
                                                         }
                                                         else
                                                         {
                                                            disposePVP();
                                                         }
                                                      }
                                                      else
                                                      {
                                                         disposeLaboratory();
                                                      }
                                                   }
                                                   else
                                                   {
                                                      disposeStartChat();
                                                   }
                                                }
                                                else
                                                {
                                                   disposeShop();
                                                }
                                             }
                                             else
                                             {
                                                disposeAddAmuseMcMedia();
                                             }
                                          }
                                          else
                                          {
                                             disposeAmuse();
                                          }
                                       }
                                       else
                                       {
                                          disposeElfCenter();
                                       }
                                    }
                                    else
                                    {
                                       disposeElfSeries();
                                    }
                                 }
                                 else
                                 {
                                    disposeLottery();
                                 }
                              }
                              else
                              {
                                 disposeKingKwan();
                              }
                           }
                           else
                           {
                              disposeHome();
                           }
                        }
                        else
                        {
                           disposeMainCity();
                        }
                     }
                     else
                     {
                        disposeCityMap();
                     }
                  }
                  else
                  {
                     disposeFighting();
                  }
               }
               else
               {
                  disposeWorldMap();
               }
            }
            else
            {
               disposeLogin();
            }
         }
         if(param2)
         {
            lastPage = rootClass.page;
            lastPage.name = rootClass.page.name;
            LogUtil(lastPage.name + " dwwwwwww");
         }
         rootClass.page = null;
      }
      
      private function disposeHuntingParty() : void
      {
         if(facade.hasMediator("HuntingPartyMedia"))
         {
            if(facade.hasMediator("HuntingBagMedia"))
            {
               (facade.retrieveMediator("HuntingBagMedia") as HuntingBagMedia).dispose();
            }
            if(facade.hasMediator("HuntAdventureMedia"))
            {
               (facade.retrieveMediator("HuntAdventureMedia") as HuntAdventureMedia).dispose();
            }
            if(facade.hasMediator("HuntBuyCountMedia"))
            {
               (facade.retrieveMediator("HuntBuyCountMedia") as HuntBuyCountMedia).dispose();
            }
            if(facade.hasMediator("HuntingRankMedia"))
            {
               (facade.retrieveMediator("HuntingRankMedia") as HuntingRankMedia).dispose();
            }
            if(facade.hasMediator("HuntingRewardMedia"))
            {
               (facade.retrieveMediator("HuntingRewardMedia") as HuntingRewardMedia).dispose();
            }
            if(facade.hasMediator("HuntingTaskMedia"))
            {
               (facade.retrieveMediator("HuntingTaskMedia") as HuntingTaskMedia).dispose();
            }
            if(facade.hasMediator("BuffMedia"))
            {
               (facade.retrieveMediator("BuffMedia") as BuffMedia).dispose();
            }
            HuntingPartyMedia.isHuntParty = false;
            (facade.retrieveMediator("HuntingPartyMedia") as HuntingPartyMedia).dispose();
            LoadSwfAssetsManager.getInstance().removeAsset(Config.huntingPartyAssets);
         }
      }
      
      private function disposeWorldMapTwoMedia() : void
      {
         if(facade.hasMediator("WorldMapTwoMedia"))
         {
            (facade.retrieveMediator("WorldMapTwoMedia") as WorldMapTwoMedia).dispose();
         }
      }
      
      private function disposeMining() : void
      {
         if(facade.hasMediator("MiningFrameMediator"))
         {
            (facade.retrieveMediator("MiningFrameMediator") as MiningFrameMediator).dispose();
         }
      }
      
      private function disposeExChange() : void
      {
         if(facade.hasMediator("ExChangeMedia"))
         {
            (facade.retrieveMediator("ExChangeMedia") as ExChangeMedia).dispose();
         }
      }
      
      private function disposeUnionWorld() : void
      {
         if(facade.hasMediator("UnionWorldMedia"))
         {
            (facade.retrieveMediator("UnionWorldMedia") as UnionWorldMedia).dispose();
         }
      }
      
      private function disposeUnionList() : void
      {
         if(facade.hasMediator("UnionListMedia"))
         {
            (facade.retrieveMediator("UnionListMedia") as UnionListMedia).dispose();
         }
      }
      
      private function disposeAuction() : void
      {
         if(facade.hasMediator("AuctionMedia"))
         {
            (facade.retrieveMediator("AuctionMedia") as AuctionMedia).dispose();
         }
      }
      
      private function disposeTrain() : void
      {
         if(facade.hasMediator("TrainMedia"))
         {
            (facade.retrieveMediator("TrainMedia") as TrainMedia).dispose();
         }
      }
      
      private function disposeLottery() : void
      {
         if(facade.hasMediator("LotteryMedia"))
         {
            (facade.retrieveMediator("LotteryMedia") as LotteryMedia).dispose();
         }
      }
      
      private function disposePVP() : void
      {
         if(facade.hasMediator("PVPBgMediator"))
         {
            (facade.retrieveMediator("PVPBgMediator") as PVPBgMediator).dispose();
         }
         NpcImageManager.getInstance().dispose();
      }
      
      private function disposeHunting() : void
      {
         if(facade.hasMediator("HuntingMediator"))
         {
            (facade.retrieveMediator("HuntingMediator") as HuntingMediator).dispose();
         }
      }
      
      private function disposeTrial() : void
      {
         if(facade.hasMediator("TrialMediator"))
         {
            (facade.retrieveMediator("TrialMediator") as TrialMediator).dispose();
         }
      }
      
      private function disposeLaboratory() : void
      {
         if(facade.hasMediator("SetNameMedia"))
         {
            (facade.retrieveMediator("SetNameMedia") as SetNameMedia).dispose();
         }
         if(facade.hasMediator("ResetElfMediator"))
         {
            (facade.retrieveMediator("ResetElfMediator") as ResetElfMediator).dispose();
         }
         if(facade.hasMediator("ReCallSkillMedia"))
         {
            (facade.retrieveMediator("ReCallSkillMedia") as ReCallSkillMedia).dispose();
         }
         if(facade.hasMediator("HJCompoundMediator"))
         {
            (facade.retrieveMediator("HJCompoundMediator") as HJCompoundMediator).dispose();
         }
         if(facade.hasMediator("ResetCharacterMediator"))
         {
            (facade.retrieveMediator("ResetCharacterMediator") as ResetCharacterMediator).dispose();
         }
         if(facade.hasMediator("LaboratoryMedia"))
         {
            (facade.retrieveMediator("LaboratoryMedia") as LaboratoryMedia).dispose();
         }
      }
      
      private function disposeStartChat() : void
      {
         LogUtil("释放创建角色资源");
         if(facade.hasMediator("StartChatMedia"))
         {
            (facade.retrieveMediator("StartChatMedia") as StartChatMedia).dispose();
            LoadSwfAssetsManager.getInstance().removeAsset(["startChat"]);
         }
         NpcImageManager.getInstance().dispose();
      }
      
      private function disposeShop() : void
      {
         LogUtil("释放商店资源");
         if(facade.hasMediator("BuySureMedia"))
         {
            (facade.retrieveMediator("BuySureMedia") as BuySureMedia).dispose();
         }
         if(facade.hasMediator("ShopMedia"))
         {
            (facade.retrieveMediator("ShopMedia") as ShopMedia).dispose();
            LoadSwfAssetsManager.getInstance().removeAsset(Config.shopAssets);
         }
      }
      
      private function disposeAddAmuseMcMedia() : void
      {
         LogUtil("释放扭蛋机动画资源");
         if(facade.hasMediator("addAmuseMcMedia"))
         {
            (facade.retrieveMediator("addAmuseMcMedia") as AddAmuseMcMedia).dispose();
            LoadSwfAssetsManager.getInstance().removeAsset(Config.amuseMcAssets);
         }
         if(lastPage is MainCityUI)
         {
            if(facade.hasMediator("AmuseElfInfoMedia"))
            {
               (facade.retrieveMediator("AmuseElfInfoMedia") as AmuseElfInfoMedia).dispose();
            }
            if(facade.hasMediator("SetElfNameMedia"))
            {
               (facade.retrieveMediator("SetElfNameMedia") as SetElfNameMedia).dispose();
            }
            LoadSwfAssetsManager.getInstance().removeAsset(Config.amuseAssets);
            IllustrationsMedia.ifNew = true;
         }
      }
      
      private function disposeAmuse() : void
      {
         LogUtil("释放扭蛋机资源");
         if(facade.hasMediator("AmuseElfInfoMedia"))
         {
            (facade.retrieveMediator("AmuseElfInfoMedia") as AmuseElfInfoMedia).dispose();
         }
         if(facade.hasMediator("SetElfNameMedia"))
         {
            (facade.retrieveMediator("SetElfNameMedia") as SetElfNameMedia).dispose();
         }
         if(facade.hasMediator("AmuseScoreRechargeMediator"))
         {
            (facade.retrieveMediator("AmuseScoreRechargeMediator") as AmuseScoreRechargeMediator).dispose();
         }
         if(facade.hasMediator("AmuseMedia"))
         {
            (facade.retrieveMediator("AmuseMedia") as AmuseMedia).dispose();
            LoadSwfAssetsManager.getInstance().removeAsset(Config.amuseAssets);
            IllustrationsMedia.ifNew = true;
         }
      }
      
      private function disposeElfCenter() : void
      {
         LogUtil("释放精灵中心资源");
         if(facade.hasMediator("ElfCenterMedia"))
         {
            (facade.retrieveMediator("ElfCenterMedia") as ElfCenterMedia).dispose();
            LoadSwfAssetsManager.getInstance().removeAsset(Config.elfCenterAssets);
         }
      }
      
      private function disposeElfSeries() : void
      {
         LogUtil("释放联盟大赛资源");
         if(facade.hasMediator("SelectFormationMedia"))
         {
            (facade.retrieveMediator("SelectFormationMedia") as SelectFormationMedia).dispose();
         }
         if(facade.hasMediator("PvpRecordMedia"))
         {
            (facade.retrieveMediator("PvpRecordMedia") as PvpRecordMedia).dispose();
         }
         if(facade.hasMediator("RankPanleMedia"))
         {
            (facade.retrieveMediator("RankPanleMedia") as RankPanleMedia).dispose();
         }
         if(facade.hasMediator("SeriesHelpMedia"))
         {
            (facade.retrieveMediator("SeriesHelpMedia") as SeriesHelpMedia).dispose();
         }
         if(facade.hasMediator("ElfSeriesMedia"))
         {
            (facade.retrieveMediator("ElfSeriesMedia") as ElfSeriesMedia).dispose();
            LoadSwfAssetsManager.getInstance().removeAsset(Config.elfSeriesAssets);
         }
      }
      
      private function disposeKingKwan() : void
      {
         LogUtil("释放王者之路资源");
         if(facade.hasMediator("KingHelpMedia"))
         {
            (facade.retrieveMediator("KingHelpMedia") as KingHelpMedia).dispose();
         }
         if(facade.hasMediator("KingKwanMedia"))
         {
            (facade.retrieveMediator("KingKwanMedia") as KingKwanMedia).dispose();
            LoadSwfAssetsManager.getInstance().removeAsset(Config.kingKwanAssets);
         }
      }
      
      private function disposeHome() : void
      {
         LogUtil("释放玩家的家资源");
         if(facade.hasMediator("BagElfMedia"))
         {
            (facade.retrieveMediator("BagElfMedia") as BagElfMedia).dispose();
         }
         if(facade.hasMediator("ComElfMedia"))
         {
            (facade.retrieveMediator("ComElfMedia") as ComElfMedia).dispose();
         }
         if(facade.hasMediator("HomeElfInfoMedia"))
         {
            (facade.retrieveMediator("HomeElfInfoMedia") as HomeElfInfoMedia).dispose();
         }
         if(facade.hasMediator("HomeMedia"))
         {
            (facade.retrieveMediator("HomeMedia") as HomeMedia).dispose();
            LoadSwfAssetsManager.getInstance().removeAsset(Config.homeAssets);
         }
      }
      
      private function disposeCityMap() : void
      {
         LogUtil("释放城市地图资源");
         ElfFrontImageManager.getInstance().dispose();
         if(facade.hasMediator("MainMapWinMedia"))
         {
            (facade.retrieveMediator("MainMapWinMedia") as MainAdventureWinMedia).dispose();
         }
         if(facade.hasMediator("ExtenMapWinMedia"))
         {
            (facade.retrieveMediator("ExtenMapWinMedia") as ExtenAdventureWinMedia).dispose();
         }
         if(facade.hasMediator("MapMeida"))
         {
            (facade.retrieveMediator("MapMeida") as CityMapMeida).dispose();
            LoadSwfAssetsManager.getInstance().removeAsset(Config.cityMapAssets);
            LoadOtherAssetsManager.getInstance().removeAsset([Config.cityScene],false);
         }
      }
      
      private function disposeFighting() : void
      {
         LogUtil("释放战斗资源");
         if(NPCVO.name != null)
         {
            LoadOtherAssetsManager.getInstance().removeAsset([NPCVO.imageName],false);
         }
         NpcImageManager.getInstance().dispose();
         if(FightVS.instance != null)
         {
            FightVS.getInstance().disposeSelf(false);
         }
         if(FightFailUI.instance != null)
         {
            FightFailUI.getInstance().remove();
         }
         FightingConfig.moneyFromFighting = "0";
         FightingConfig.isPlayerActAfterChangeElf = false;
         if(LoadWindowsCmd.currentPage == "PlayElfMedia")
         {
            (facade.retrieveMediator("PlayElfMedia") as PlayElfMedia).closeWin();
         }
         PVPLoading.removeLoading(true);
         if(LoadWindowsCmd.currentPage == "PlayElfMedia")
         {
            (facade.retrieveMediator("PlayElfMedia") as PlayElfMedia).closeWin();
         }
         PVPLoading.removeLoading(true);
         if(facade.hasMediator("FightingMedia"))
         {
            (facade.retrieveMediator("CampOfPlayerMedia") as CampOfPlayerMedia).dispose();
            (facade.retrieveMediator("CampOfComputerMedia") as CampOfComputerMedia).dispose();
            (facade.retrieveMediator("FightingMedia") as FightingMedia).dispose();
            IllustrationsMedia.ifNew = true;
            SoundManager.getInstance().stopMusic();
            SoundEvent.dispatchEvent("PLAY_BACKGROUND_MUSIC","mainCity");
         }
         if(FightingConfig.elfFrontAssets.length > 0)
         {
            LoadSwfAssetsManager.getInstance().removeAsset(Config.fightingAssets);
            Config.fightingAssets.splice(2,1);
            LoadSwfAssetsManager.getInstance().removeAsset(FightingConfig.skillAssetsOfDisposeAtOnce);
            LoadSwfAssetsManager.getInstance().removeAsset(FightingConfig.skillAssetsOfUse);
            LoadOtherAssetsManager.getInstance().removeAsset(FightingConfig.skillMusicAssets,true);
            LoadOtherAssetsManager.getInstance().removeAsset(FightingConfig.elfBackAssets,false);
            LoadOtherAssetsManager.getInstance().removeAsset(FightingConfig.elfFrontAssets,false);
            if(!isMiningFight)
            {
               LoadOtherAssetsManager.getInstance().removeAsset(FightingConfig.FSceneAssets,false);
            }
            LoadOtherAssetsManager.getInstance().removeAsset(FightingConfig.fightMusicAssets,true);
            FightingConfig.skillMusicAssets = [];
            FightingConfig.elfBackAssets = [];
            FightingConfig.elfFrontAssets = [];
            FightingConfig.FSceneAssets = [];
            FightingConfig.skillAssetsOfUse = [];
            FightingConfig.skillAssetsOfDisposeAtOnce = [];
         }
         LSOManager.put("isAutoFightSave",Config.isAutoFighting);
         Dialogue.removeFormParent(true);
         FightingMedia.isFighting = false;
         FightingLogicFactor.isPVP = false;
         FightingLogicFactor.isPlayBack = false;
         FightingLogicFactor.isPlayBackFromPvp = false;
         FightingPro.isPvpOver = false;
         BackPackPro.littleMistNum = 0;
         BackPackPro.middleMistNum = 0;
         BackPackPro.heightMistNum = 0;
         isMiningFight = false;
         FightingConfig.selfOrderVec = Vector.<Object>([]);
         FightingConfig.otherOrderVec = Vector.<Object>([]);
      }
      
      private function disposeWorldMap() : void
      {
         LogUtil("释放世界地图资源");
         if(facade.hasMediator("BigMapMedia"))
         {
            (facade.retrieveMediator("BigMapMedia") as WorldMapMedia).dispose();
            LoadSwfAssetsManager.getInstance().removeAsset(Config.worldMapAssets);
         }
      }
      
      private function disposeLogin() : void
      {
         LogUtil("释放登录资源");
         if(facade.hasMediator("LoginWidowMedia"))
         {
            (facade.retrieveMediator("LoginWidowMedia") as LoginWidowMedia).dispose();
         }
         if(facade.hasMediator("ServerListMedia"))
         {
            (facade.retrieveMediator("ServerListMedia") as ServerListMedia).dispose();
         }
         if(facade.hasMediator("LoginMedia"))
         {
            (facade.retrieveMediator("LoginMedia") as LoginMedia).dispose();
            LoadOtherAssetsManager.getInstance().removeAsset(["login"],true);
            LoadSwfAssetsManager.getInstance().removeAsset(["login"]);
         }
      }
      
      private function disposeMainCity() : void
      {
         LogUtil("释放主城资源");
         if(facade.hasMediator("MainCityMedia"))
         {
            if(facade.hasMediator("MenuMedia"))
            {
               (facade.retrieveMediator("MenuMedia") as MenuMedia).dispose();
            }
            if(facade.hasMediator("MainCityMedia"))
            {
               (facade.retrieveMediator("MainCityMedia") as MainCityMedia).dispose();
               LoadSwfAssetsManager.getInstance().removeAsset(Config.mainCityAssets);
            }
            if(facade.hasMediator("HornMedia"))
            {
               (facade.retrieveMediator("HornMedia") as HornMedia).dispose();
            }
            if(facade.hasMediator("ChatPlayerMedia"))
            {
               (facade.retrieveMediator("ChatPlayerMedia") as ChatPlayerMedia).dispose();
            }
            if(facade.hasMediator("PrivateListMedia"))
            {
               (facade.retrieveMediator("PrivateListMedia") as PrivateListMedia).dispose();
            }
            if(facade.hasMediator("WorldChatMedia"))
            {
               (facade.retrieveMediator("WorldChatMedia") as WorldChatMedia).dispose();
            }
            if(facade.hasMediator("UnionChatMedia"))
            {
               (facade.retrieveMediator("UnionChatMedia") as UnionChatMedia).dispose();
            }
            if(facade.hasMediator("SystemChatMedia"))
            {
               (facade.retrieveMediator("SystemChatMedia") as SystemChatMedia).dispose();
            }
            if(facade.hasMediator("PrivateChatMedia"))
            {
               (facade.retrieveMediator("PrivateChatMedia") as PrivateChatMedia).dispose();
            }
            if(facade.hasMediator("RoomChatMediaotr"))
            {
               (facade.retrieveMediator("RoomChatMediaotr") as RoomChatMediaotr).dispose();
            }
            if(facade.hasMediator("ChatMedia"))
            {
               (facade.retrieveMediator("ChatMedia") as ChatMedia).dispose();
            }
         }
      }
      
      public function disposeCityAndMap() : void
      {
         CityMapMeida.recordMainAdvance = null;
         CityMapMeida.recordExtenAdvance = null;
         disposeCityMap();
         disposeWorldMap();
         disposeWorldMapTwoMedia();
      }
   }
}
