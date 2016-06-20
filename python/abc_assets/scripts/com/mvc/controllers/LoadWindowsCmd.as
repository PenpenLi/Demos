package com.mvc.controllers
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.massage.ane.UmengExtension;
   import com.common.events.EventCenter;
   import com.common.managers.LoadOtherAssetsManager;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.views.mediator.mainCity.specialAct.flashElfAct.FlashBaoLiLongMediator;
   import com.mvc.views.mediator.mainCity.perter.PreferMedia;
   import com.mvc.views.mediator.huntingParty.HuntingBagMedia;
   import com.mvc.views.uis.huntingParty.HuntingBagUI;
   import com.common.util.WinTweens;
   import com.mvc.views.mediator.huntingParty.HuntBuyCountMedia;
   import com.mvc.views.uis.huntingParty.HuntBuyCountUI;
   import com.mvc.views.mediator.huntingParty.HuntAdventureMedia;
   import com.mvc.views.uis.huntingParty.HuntAdventureUI;
   import com.mvc.views.mediator.huntingParty.BuffMedia;
   import com.mvc.views.uis.huntingParty.BuffUI;
   import com.mvc.views.mediator.huntingParty.HuntingRewardMedia;
   import com.mvc.views.uis.huntingParty.HuntingRewardUI;
   import com.common.util.xmlVOHandler.GetHuntingParty;
   import com.mvc.models.proxy.huntingParty.HuntingPartyPro;
   import com.mvc.views.mediator.huntingParty.HuntingRankMedia;
   import com.mvc.views.uis.huntingParty.HuntingRankUI;
   import com.mvc.views.mediator.huntingParty.HuntingTaskMedia;
   import com.mvc.views.uis.huntingParty.HuntingTaskUI;
   import com.mvc.views.mediator.mainCity.specialAct.ActPreviewMediator;
   import com.mvc.views.uis.mainCity.specialAct.actPreview.ActPreviewUI;
   import com.common.consts.ConfigConst;
   import com.mvc.views.mediator.mainCity.mining.MiningDefendRecordMediator;
   import com.mvc.views.uis.mainCity.mining.MiningDefendRecordUI;
   import com.mvc.models.proxy.mainCity.mining.MiningPro;
   import com.mvc.views.mediator.mainCity.mining.MiningSelectMemberMediator;
   import com.mvc.views.uis.mainCity.mining.MiningSelectMemberUI;
   import com.mvc.models.proxy.union.UnionPro;
   import com.mvc.views.mediator.mainCity.mining.MiningInviteMediator;
   import com.mvc.views.uis.mainCity.mining.MiningInviteUI;
   import com.mvc.views.mediator.mainCity.mining.MiningCheckFormatMediator;
   import com.mvc.views.uis.mainCity.mining.MiningCheckFormatUI;
   import com.mvc.views.mediator.mainCity.mining.MiningSelectTypeMediator;
   import com.mvc.views.uis.mainCity.mining.MiningSelectTypeUI;
   import com.mvc.views.mediator.union.unionMedal.MedalMedia;
   import com.mvc.views.uis.union.unionMedal.MedalUI;
   import com.mvc.views.uis.mainCity.perfer.PreferUI;
   import com.mvc.models.proxy.mainCity.specialAct.SpecialActPro;
   import com.mvc.views.uis.mainCity.specialAct.flashElfAct.FlashBaoLiLongUI;
   import com.mvc.views.mediator.union.unionStudy.StudyChildMedia;
   import com.mvc.views.uis.union.unionStudy.StudyChildUI;
   import com.mvc.views.mediator.union.unionStudy.UnionStudyMedia;
   import com.mvc.views.uis.union.unionStudy.UnionStudyUI;
   import com.mvc.views.mediator.union.unionTrain.OtherTrainMedia;
   import com.mvc.views.uis.union.unionTrain.OtherTrainUI;
   import com.mvc.views.mediator.union.unionTrain.UnionTrainMedia;
   import com.mvc.views.uis.union.unionTrain.UnionTrainUI;
   import com.mvc.views.mediator.union.unionHall.UnionHallMedia;
   import com.mvc.views.uis.union.unionHall.UnionHallUI;
   import com.mvc.views.mediator.mainCity.laboratory.ResetCharacterMediator;
   import com.mvc.views.uis.mainCity.laboratory.ResetCharacterUI;
   import com.mvc.views.mediator.mainCity.laboratory.ReCallSkillMedia;
   import com.mvc.views.uis.mainCity.laboratory.RecallSkillUI;
   import com.mvc.views.mediator.mainCity.hunting.HuntingSelectTickMediator;
   import com.mvc.views.uis.mainCity.hunting.HuntingSelectTickUI;
   import com.mvc.views.mediator.mainCity.specialAct.diamondUp.DiamondUpMediator;
   import com.mvc.views.uis.mainCity.specialAct.diamondUp.DiamondUpUI;
   import com.mvc.views.mediator.mainCity.specialAct.dayRecharge.DayRechargeMediator;
   import com.mvc.views.uis.mainCity.specialAct.dayRecharge.DayRechargeUI;
   import com.mvc.views.mediator.mainCity.specialAct.LimitSpecialElfMediaor;
   import com.mvc.views.uis.mainCity.specialAct.limitSpecialElf.LimitSpecialElfUI;
   import com.mvc.views.mediator.mainCity.growthPlan.GrowthPlanMediator;
   import com.mvc.views.uis.mainCity.growthPlan.GrowthPlanUI;
   import com.mvc.models.proxy.mainCity.growthPlan.GrowthPlanPro;
   import com.mvc.views.mediator.mainCity.Ranklist.RanklistMedia;
   import com.mvc.views.uis.mainCity.Ranklist.RanklistUI;
   import com.mvc.models.proxy.mainCity.rankList.RankListPro;
   import com.mvc.views.mediator.mainCity.scoreShop.FreeSelectElfMediator;
   import com.mvc.views.uis.mainCity.scoreShop.FreeSelectElfUI;
   import com.common.util.ElfSortHandler;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.views.mediator.mainCity.laboratory.ResetElfMediator;
   import com.mvc.views.uis.mainCity.laboratory.ResetElfUI;
   import com.mvc.views.mediator.mainCity.laboratory.ResetSelectElfMediator;
   import com.mvc.views.uis.mainCity.laboratory.ResetSelectElfUI;
   import com.mvc.views.mediator.mainCity.miracle.MiracleSelectElfMediator;
   import com.mvc.views.uis.mainCity.miracle.MiracleSelectElfUI;
   import com.mvc.views.mediator.mainCity.miracle.MiracleMediator;
   import com.mvc.views.uis.mainCity.miracle.MiracleUI;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import com.mvc.views.mediator.mainCity.train.SeleTrainElfMedia;
   import com.mvc.views.uis.mainCity.train.SeleTrainElfUI;
   import com.mvc.views.mediator.login.LoginWidowMedia;
   import com.mvc.views.uis.login.LoginWindowUI;
   import com.mvc.views.mediator.mainCity.sign.SignMedia;
   import com.mvc.views.uis.mainCity.sign.SignUI;
   import com.mvc.models.proxy.mainCity.sign.SignPro;
   import com.common.themes.Tips;
   import com.mvc.views.mediator.mainCity.trial.TrialBossInfoMediator;
   import com.mvc.views.uis.mainCity.trial.TrialBossInfoUI;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.mvc.views.mediator.mainCity.trial.TrialSelectDifficultyModiator;
   import com.mvc.views.uis.mainCity.trial.TrialSelectDifficultyUI;
   import com.mvc.views.mediator.mainCity.trial.TrialSelectBossMediator;
   import com.mvc.views.uis.mainCity.trial.TrialSelectBossUI;
   import com.mvc.views.mediator.mainCity.scoreShop.ScoreGoodsInfoMediator;
   import com.mvc.views.uis.mainCity.scoreShop.ScoreGoodInfoUI;
   import com.mvc.views.mediator.mainCity.scoreShop.ScoreShopMediator;
   import com.mvc.views.uis.mainCity.scoreShop.ScoreShopUI;
   import com.mvc.views.uis.mainCity.MainCityUI;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import com.mvc.models.proxy.mainCity.kingKwan.KingKwanPro;
   import com.mvc.models.proxy.mainCity.elfSeries.ElfSeriesPro;
   import com.mvc.models.proxy.mainCity.home.HomePro;
   import com.mvc.models.proxy.mainCity.shop.ShopPro;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.views.mediator.mainCity.pvp.PVPPropMediator;
   import com.mvc.views.uis.mainCity.pvp.PVPPropUI;
   import com.mvc.views.mediator.mainCity.pvp.PVPRankMediator;
   import com.mvc.views.uis.mainCity.pvp.PVPRankUI;
   import com.mvc.views.mediator.mainCity.pvp.PVPRuleMediator;
   import com.mvc.views.uis.mainCity.pvp.PVPRuleUI;
   import com.mvc.views.mediator.mainCity.pvp.PVPBgMediator;
   import com.mvc.views.mediator.mainCity.pvp.PVPCheckPswMediator;
   import com.mvc.views.uis.mainCity.pvp.PVPCheckPswUI;
   import com.mvc.views.mediator.mainCity.pvp.PVPCRoomMediator;
   import com.mvc.views.uis.mainCity.pvp.PVPCRoomUI;
   import com.mvc.views.mediator.mainCity.train.TrainMedia;
   import com.mvc.views.uis.mainCity.train.TrainUI;
   import com.mvc.models.proxy.mainCity.train.TrainPro;
   import com.mvc.views.mediator.mainCity.laboratory.TrainRoomMedia;
   import com.mvc.views.uis.mainCity.laboratory.TrainRoomUI;
   import com.mvc.views.mediator.mainCity.laboratory.SetNameMedia;
   import com.mvc.views.uis.mainCity.laboratory.SetNameUI;
   import com.mvc.views.mediator.mainCity.laboratory.HJCompoundMediator;
   import com.mvc.views.uis.mainCity.laboratory.HJCompoundUI;
   import com.mvc.views.mediator.mainCity.active.ActiveMeida;
   import com.mvc.views.uis.mainCity.active.ActiveUI;
   import com.mvc.models.proxy.mainCity.active.ActivePro;
   import com.mvc.views.mediator.mainCity.chat.HornMedia;
   import com.mvc.views.uis.mainCity.chat.HornUI;
   import com.mvc.views.mediator.mainCity.firstRecharge.FirstRchargeMediator;
   import com.mvc.views.uis.mainCity.firstRecharge.FirstRechargeUI;
   import com.mvc.views.mediator.mainCity.elfSeries.SelePlayElfMedia;
   import com.mvc.views.uis.mainCity.elfSeries.SelePlayElfUI;
   import com.mvc.views.mediator.mainCity.elfSeries.RivalInfoMedia;
   import com.mvc.views.uis.mainCity.elfSeries.RivalInfoUI;
   import com.mvc.views.mediator.mainCity.elfSeries.SelectFormationMedia;
   import com.mvc.views.uis.mainCity.elfSeries.SelectFormationUI;
   import com.mvc.views.mediator.mainCity.elfSeries.PvpRecordMedia;
   import com.mvc.views.uis.mainCity.elfSeries.PvpRecordUI;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.mediator.mainCity.chat.ChatMedia;
   import com.mvc.views.uis.mainCity.chat.ChatUI;
   import com.mvc.views.mediator.mainCity.information.InformationMedia;
   import com.mvc.views.uis.mainCity.information.InformationUI;
   import com.mvc.views.uis.worldHorn.WorldHorn;
   import com.mvc.views.mediator.mainCity.MenuMedia;
   import com.mvc.views.mediator.mainCity.friend.FriendMedia;
   import com.mvc.views.uis.mainCity.friend.FriendUI;
   import com.mvc.views.mediator.mainCity.task.TaskMedia;
   import com.mvc.views.uis.mainCity.task.TaskUI;
   import com.mvc.models.proxy.mainCity.task.TaskPro;
   import com.mvc.views.mediator.mainCity.kingKwan.GetPropMedia;
   import com.mvc.views.uis.mainCity.kingKwan.GetPropUI;
   import com.mvc.views.mediator.mainCity.friend.FriendAddMedia;
   import com.mvc.views.uis.mainCity.friend.FriendAddUI;
   import com.mvc.views.mediator.mapSelect.ExtenAdventureWinMedia;
   import com.mvc.views.uis.mapSelect.ExtenAdventureWinUI;
   import starling.display.DisplayObject;
   import com.mvc.views.mediator.mapSelect.MainAdventureWinMedia;
   import com.mvc.views.uis.mapSelect.MainAdventureWinUI;
   import com.mvc.views.mediator.login.ServerListMedia;
   import com.mvc.views.uis.login.ServerListUI;
   import com.mvc.views.mediator.mainCity.amuse.AmuseElfInfoMedia;
   import com.mvc.views.uis.mainCity.amuse.AmuseElfInfoUI;
   import com.mvc.views.mediator.mainCity.amuse.AmuseScoreRechargeMediator;
   import com.mvc.views.uis.mainCity.amuse.AmuseScoreRechargeUI;
   import starling.core.Starling;
   import com.mvc.views.mediator.mainCity.Illustrations.IllustrationsMedia;
   import com.mvc.views.uis.mainCity.Illustrations.IllustrationsUI;
   import com.mvc.models.proxy.Illustrations.IllustrationsPro;
   import com.common.util.xmlVOHandler.GetMapFactor;
   import com.mvc.views.mediator.mainCity.amuse.SetElfNameMedia;
   import com.mvc.views.uis.mainCity.amuse.SetElfNameUI;
   import com.mvc.views.mediator.mainCity.myElf.EvolveMcMediator;
   import com.mvc.views.uis.mainCity.myElf.EvolveMcUI;
   import com.mvc.views.mediator.mainCity.home.ElfDetailInfoMedia;
   import com.mvc.views.uis.mainCity.home.ElfDetailInfoUI;
   import com.mvc.views.mediator.mainCity.chat.ChatPlayerMedia;
   import com.mvc.views.uis.mainCity.chat.ChatPlayerUI;
   import com.mvc.views.mediator.mainCity.shop.BuySureMedia;
   import com.mvc.views.uis.mainCity.shop.BuySureUI;
   import com.mvc.views.mediator.mainCity.backPack.SkillPanelMedia;
   import com.mvc.views.uis.mainCity.backPack.SkillPanelUI;
   import com.mvc.views.mediator.mainCity.backPack.PlayElfMedia;
   import com.mvc.views.uis.mainCity.backPack.PlayElfUI;
   import com.mvc.views.mediator.mainCity.playerInfo.infoPanel.InfoPanelMediator;
   import com.mvc.views.uis.mainCity.playerInfo.infoPanel.InfoPanelUI;
   import com.mvc.models.proxy.mainCity.playerInfo.PlayInfoPro;
   import com.mvc.views.mediator.mainCity.playerInfo.buyDiamond.BuyDiamondMediator;
   import com.mvc.views.uis.mainCity.playerInfo.buyDiamond.BuyDiamondUI;
   import com.mvc.views.mediator.mainCity.playerInfo.buyPower.BuyPowerMediator;
   import com.mvc.views.uis.mainCity.playerInfo.buyPower.BuyPowerUI;
   import com.mvc.views.mediator.mainCity.playerInfo.buyMoney.BuyMoneyMediator;
   import com.mvc.views.uis.mainCity.playerInfo.buyMoney.BuyMoneyUI;
   import com.mvc.views.mediator.mainCity.playerInfo.infoPanel.ChangeHeadMediator;
   import com.mvc.views.uis.mainCity.playerInfo.infoPanel.ChangeHeadUI;
   import com.mvc.views.mediator.mainCity.playerInfo.infoPanel.ChangeTrainerMediator;
   import com.mvc.views.uis.mainCity.playerInfo.infoPanel.ChangeTrainerUI;
   import com.mvc.views.mediator.mainCity.myElf.MyElfMedia;
   import com.mvc.views.uis.mainCity.myElf.MyElfUI;
   import com.mvc.views.uis.mainCity.myElf.EvoStoneGuideUI;
   import com.mvc.views.uis.mainCity.myElf.CompChildUI;
   import com.mvc.models.proxy.mainCity.elfCenter.ElfCenterPro;
   import com.mvc.models.proxy.mainCity.backPack.BackPackPro;
   import com.mvc.views.mediator.mainCity.backPack.BackPackMedia;
   import com.mvc.views.uis.mainCity.backPack.BackPackUI;
   
   public class LoadWindowsCmd extends SimpleCommand
   {
      
      public static var currentPage:String;
       
      private var rootClass:Game;
      
      public function LoadWindowsCmd()
      {
         super();
         rootClass = Config.starling.root as Game;
      }
      
      override public function execute(param1:INotification) : void
      {
         if(param1.getBody() == null)
         {
            currentPage = null;
            LogUtil(currentPage + "空了么");
         }
         var _loc2_:* = param1.getType();
         if("LOAD_LOGINWINDOW_WIN" !== _loc2_)
         {
            if("LOAD_ELF_WIN" !== _loc2_)
            {
               if("LOAD_BACKPACK_WIN" !== _loc2_)
               {
                  if("LOAD_PLAYELF_WIN" !== _loc2_)
                  {
                     if("load_money_panel" !== _loc2_)
                     {
                        if("load_diamond_panel" !== _loc2_)
                        {
                           if("load_power_panel" !== _loc2_)
                           {
                              if("load_play_info_panel" !== _loc2_)
                              {
                                 if("load_headPic_panel" !== _loc2_)
                                 {
                                    if("load_trainerPic_panel" !== _loc2_)
                                    {
                                       if("LOAD_SKILL_WIN" !== _loc2_)
                                       {
                                          if("LOAD_BUYSURE_WIN" !== _loc2_)
                                          {
                                             if("LOAD_OTHERPLAYER_WIN" !== _loc2_)
                                             {
                                                if("LOAD_ELFDETAILINFO_WIN" !== _loc2_)
                                                {
                                                   if("load_elfEvolveMc" !== _loc2_)
                                                   {
                                                      if("LOAD_ELFNAME_WIN" !== _loc2_)
                                                      {
                                                         if("LOAD_ILLUSTRATION_WIN" !== _loc2_)
                                                         {
                                                            if("LOAD_AMUSEELFINFO_WIN" !== _loc2_)
                                                            {
                                                               if("load_amuse_score_win" !== _loc2_)
                                                               {
                                                                  if("LOAD_SERVER" !== _loc2_)
                                                                  {
                                                                     if("load_main_map_win" !== _loc2_)
                                                                     {
                                                                        if("load_exten_map_win" !== _loc2_)
                                                                        {
                                                                           if("LOAD_ADD_FRIEND" !== _loc2_)
                                                                           {
                                                                              if("LOAD_DROP_PROP" !== _loc2_)
                                                                              {
                                                                                 if("LOAD_TASK" !== _loc2_)
                                                                                 {
                                                                                    if("LOAD_FRIEND" !== _loc2_)
                                                                                    {
                                                                                       if("LOAD_INFORMATION" !== _loc2_)
                                                                                       {
                                                                                          if("LOAD_CHAT" !== _loc2_)
                                                                                          {
                                                                                             if("LOAD_SERIES_PVP" !== _loc2_)
                                                                                             {
                                                                                                if("LOAD_SERIES_FORMATION" !== _loc2_)
                                                                                                {
                                                                                                   if("LOAD_RIVAL_INFO" !== _loc2_)
                                                                                                   {
                                                                                                      if("LOAD_SERIES_PLAYELF" !== _loc2_)
                                                                                                      {
                                                                                                         if("LOAD_HORN_INPUT" !== _loc2_)
                                                                                                         {
                                                                                                            if("load_firstRecharge" !== _loc2_)
                                                                                                            {
                                                                                                               if("LOAD_ACTIVITY" !== _loc2_)
                                                                                                               {
                                                                                                                  if("LOAD_SETNAME" !== _loc2_)
                                                                                                                  {
                                                                                                                     if("LOAD_HJCOMPOUND" !== _loc2_)
                                                                                                                     {
                                                                                                                        if("LOAD_TRAINROOM" !== _loc2_)
                                                                                                                        {
                                                                                                                           if("LOAD_TRAINELF" !== _loc2_)
                                                                                                                           {
                                                                                                                              if("LOAD_SELETRAINELF" !== _loc2_)
                                                                                                                              {
                                                                                                                                 if("load_resetcharacter" !== _loc2_)
                                                                                                                                 {
                                                                                                                                    if("LOAD_RECALLSKILL" !== _loc2_)
                                                                                                                                    {
                                                                                                                                       if("load_pvp_croom" !== _loc2_)
                                                                                                                                       {
                                                                                                                                          if("load_pvp_check_psw" !== _loc2_)
                                                                                                                                          {
                                                                                                                                             if("load_pvp_rule" !== _loc2_)
                                                                                                                                             {
                                                                                                                                                if("load_pvp_rank" !== _loc2_)
                                                                                                                                                {
                                                                                                                                                   if("load_pvp_prop" !== _loc2_)
                                                                                                                                                   {
                                                                                                                                                      if("load_score_shop" !== _loc2_)
                                                                                                                                                      {
                                                                                                                                                         if("load_score_goods" !== _loc2_)
                                                                                                                                                         {
                                                                                                                                                            if("LOAD_SIGN" !== _loc2_)
                                                                                                                                                            {
                                                                                                                                                               if("load_trial_select_boss" !== _loc2_)
                                                                                                                                                               {
                                                                                                                                                                  if("load_trial_select_difficulty" !== _loc2_)
                                                                                                                                                                  {
                                                                                                                                                                     if("load_trial_boss_info" !== _loc2_)
                                                                                                                                                                     {
                                                                                                                                                                        if("load_miralce" !== _loc2_)
                                                                                                                                                                        {
                                                                                                                                                                           if("load_miracle_select_com_elf" !== _loc2_)
                                                                                                                                                                           {
                                                                                                                                                                              if("load_resetelf_select_com_elf" !== _loc2_)
                                                                                                                                                                              {
                                                                                                                                                                                 if("load_resetelf_win" !== _loc2_)
                                                                                                                                                                                 {
                                                                                                                                                                                    if("load_freeshop_select_com_elf" !== _loc2_)
                                                                                                                                                                                    {
                                                                                                                                                                                       if("LOAD_RANKLIST_WIN" !== _loc2_)
                                                                                                                                                                                       {
                                                                                                                                                                                          if("load_growthplan" !== _loc2_)
                                                                                                                                                                                          {
                                                                                                                                                                                             if("load_hunting_select_tick" !== _loc2_)
                                                                                                                                                                                             {
                                                                                                                                                                                                if("load_diamondup" !== _loc2_)
                                                                                                                                                                                                {
                                                                                                                                                                                                   if("load_dayrecharge" !== _loc2_)
                                                                                                                                                                                                   {
                                                                                                                                                                                                      if("load_flash_baolilong" !== _loc2_)
                                                                                                                                                                                                      {
                                                                                                                                                                                                         if("load_limit_specialelf" !== _loc2_)
                                                                                                                                                                                                         {
                                                                                                                                                                                                            if("LOAD_UNIONHALL_WIN" !== _loc2_)
                                                                                                                                                                                                            {
                                                                                                                                                                                                               if("LOAD_UNIONTRAIN_WIN" !== _loc2_)
                                                                                                                                                                                                               {
                                                                                                                                                                                                                  if("LOAD_OTHERTRAIN_WIN" !== _loc2_)
                                                                                                                                                                                                                  {
                                                                                                                                                                                                                     if("LOAD_UNIONSTUDY_WIN" !== _loc2_)
                                                                                                                                                                                                                     {
                                                                                                                                                                                                                        if("LOAD_STUDYCHILD_WIN" !== _loc2_)
                                                                                                                                                                                                                        {
                                                                                                                                                                                                                           if("LOAD_PREFER_WIN" !== _loc2_)
                                                                                                                                                                                                                           {
                                                                                                                                                                                                                              if("LOAD_MEDAL_WIN" !== _loc2_)
                                                                                                                                                                                                                              {
                                                                                                                                                                                                                                 if("mining_load_select_type_win" !== _loc2_)
                                                                                                                                                                                                                                 {
                                                                                                                                                                                                                                    if("mining_load_view_camp_win" !== _loc2_)
                                                                                                                                                                                                                                    {
                                                                                                                                                                                                                                       if("mining_load_invite_win" !== _loc2_)
                                                                                                                                                                                                                                       {
                                                                                                                                                                                                                                          if("mining_load_select_member_win" !== _loc2_)
                                                                                                                                                                                                                                          {
                                                                                                                                                                                                                                             if("mining_load_fight_record_win" !== _loc2_)
                                                                                                                                                                                                                                             {
                                                                                                                                                                                                                                                if("LOAD_HUNTINGTASK_WIN" !== _loc2_)
                                                                                                                                                                                                                                                {
                                                                                                                                                                                                                                                   if("load_actpreview_win" !== _loc2_)
                                                                                                                                                                                                                                                   {
                                                                                                                                                                                                                                                      if("LOAD_HUNTINGRANK_WIN" !== _loc2_)
                                                                                                                                                                                                                                                      {
                                                                                                                                                                                                                                                         if("LOAD_HUNTINGREWARD_WIN" !== _loc2_)
                                                                                                                                                                                                                                                         {
                                                                                                                                                                                                                                                            if("LOAD_HUNTINGBUFF_WIN" !== _loc2_)
                                                                                                                                                                                                                                                            {
                                                                                                                                                                                                                                                               if("LOAD_HUNTADVENTURE_WIN" !== _loc2_)
                                                                                                                                                                                                                                                               {
                                                                                                                                                                                                                                                                  if("LOAD_HUNTBUYCOUNT_WIN" !== _loc2_)
                                                                                                                                                                                                                                                                  {
                                                                                                                                                                                                                                                                     if("LOAD_HUNTBAG_WIN" === _loc2_)
                                                                                                                                                                                                                                                                     {
                                                                                                                                                                                                                                                                        loadHuntBag();
                                                                                                                                                                                                                                                                     }
                                                                                                                                                                                                                                                                  }
                                                                                                                                                                                                                                                                  else
                                                                                                                                                                                                                                                                  {
                                                                                                                                                                                                                                                                     loadBuyCount();
                                                                                                                                                                                                                                                                  }
                                                                                                                                                                                                                                                               }
                                                                                                                                                                                                                                                               else
                                                                                                                                                                                                                                                               {
                                                                                                                                                                                                                                                                  loadAdventure();
                                                                                                                                                                                                                                                               }
                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                            else
                                                                                                                                                                                                                                                            {
                                                                                                                                                                                                                                                               loadBuff();
                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                         }
                                                                                                                                                                                                                                                         else
                                                                                                                                                                                                                                                         {
                                                                                                                                                                                                                                                            loadHuntingReward();
                                                                                                                                                                                                                                                         }
                                                                                                                                                                                                                                                      }
                                                                                                                                                                                                                                                      else
                                                                                                                                                                                                                                                      {
                                                                                                                                                                                                                                                         loadHuntingRank();
                                                                                                                                                                                                                                                      }
                                                                                                                                                                                                                                                   }
                                                                                                                                                                                                                                                   else
                                                                                                                                                                                                                                                   {
                                                                                                                                                                                                                                                      loadActPreview();
                                                                                                                                                                                                                                                   }
                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                else
                                                                                                                                                                                                                                                {
                                                                                                                                                                                                                                                   loadHuntingTask();
                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                             }
                                                                                                                                                                                                                                             else
                                                                                                                                                                                                                                             {
                                                                                                                                                                                                                                                loadMiningDefendRecord();
                                                                                                                                                                                                                                             }
                                                                                                                                                                                                                                          }
                                                                                                                                                                                                                                          else
                                                                                                                                                                                                                                          {
                                                                                                                                                                                                                                             loadMiningSelectMember();
                                                                                                                                                                                                                                          }
                                                                                                                                                                                                                                       }
                                                                                                                                                                                                                                       else
                                                                                                                                                                                                                                       {
                                                                                                                                                                                                                                          loadMiningInvite();
                                                                                                                                                                                                                                       }
                                                                                                                                                                                                                                    }
                                                                                                                                                                                                                                    else
                                                                                                                                                                                                                                    {
                                                                                                                                                                                                                                       loadMiningCheckFormat();
                                                                                                                                                                                                                                    }
                                                                                                                                                                                                                                 }
                                                                                                                                                                                                                                 else
                                                                                                                                                                                                                                 {
                                                                                                                                                                                                                                    loadMiningSelectType();
                                                                                                                                                                                                                                 }
                                                                                                                                                                                                                              }
                                                                                                                                                                                                                              else
                                                                                                                                                                                                                              {
                                                                                                                                                                                                                                 loadMedal();
                                                                                                                                                                                                                                 UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|训练师称号");
                                                                                                                                                                                                                              }
                                                                                                                                                                                                                           }
                                                                                                                                                                                                                           else
                                                                                                                                                                                                                           {
                                                                                                                                                                                                                              if(!facade.hasMediator("PreferMedia"))
                                                                                                                                                                                                                              {
                                                                                                                                                                                                                                 EventCenter.addEventListener("load_swf_asset_complete",loadPrefer);
                                                                                                                                                                                                                                 LoadSwfAssetsManager.getInstance().addAssets(PreferMedia.assets);
                                                                                                                                                                                                                              }
                                                                                                                                                                                                                              UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|特惠大礼包");
                                                                                                                                                                                                                           }
                                                                                                                                                                                                                        }
                                                                                                                                                                                                                        else
                                                                                                                                                                                                                        {
                                                                                                                                                                                                                           loadStudyChild();
                                                                                                                                                                                                                        }
                                                                                                                                                                                                                     }
                                                                                                                                                                                                                     else
                                                                                                                                                                                                                     {
                                                                                                                                                                                                                        if(!facade.hasMediator("UnionStudyMedia"))
                                                                                                                                                                                                                        {
                                                                                                                                                                                                                           EventCenter.addEventListener("load_swf_asset_complete",loadUnionStudy);
                                                                                                                                                                                                                           LoadSwfAssetsManager.getInstance().addAssets(Config.unionStudyAssets);
                                                                                                                                                                                                                        }
                                                                                                                                                                                                                        UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|公会研究所");
                                                                                                                                                                                                                     }
                                                                                                                                                                                                                  }
                                                                                                                                                                                                                  else
                                                                                                                                                                                                                  {
                                                                                                                                                                                                                     loadOtherTrain();
                                                                                                                                                                                                                  }
                                                                                                                                                                                                               }
                                                                                                                                                                                                               else
                                                                                                                                                                                                               {
                                                                                                                                                                                                                  if(!facade.hasMediator("UnionTrainMedia"))
                                                                                                                                                                                                                  {
                                                                                                                                                                                                                     EventCenter.addEventListener("load_swf_asset_complete",loadUnionTrain);
                                                                                                                                                                                                                     LoadSwfAssetsManager.getInstance().addAssets(Config.unionTrainAssets);
                                                                                                                                                                                                                  }
                                                                                                                                                                                                                  UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|公会训练");
                                                                                                                                                                                                               }
                                                                                                                                                                                                            }
                                                                                                                                                                                                            else
                                                                                                                                                                                                            {
                                                                                                                                                                                                               if(!facade.hasMediator("UnionHallMedia"))
                                                                                                                                                                                                               {
                                                                                                                                                                                                                  EventCenter.addEventListener("load_swf_asset_complete",loadUnionHall);
                                                                                                                                                                                                                  LoadSwfAssetsManager.getInstance().addAssets(Config.unionHallAssets);
                                                                                                                                                                                                               }
                                                                                                                                                                                                               UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|公会大厅");
                                                                                                                                                                                                            }
                                                                                                                                                                                                         }
                                                                                                                                                                                                         else
                                                                                                                                                                                                         {
                                                                                                                                                                                                            if(!facade.hasMediator("LimitSpecialElfMediaor"))
                                                                                                                                                                                                            {
                                                                                                                                                                                                               EventCenter.addEventListener("load_swf_asset_complete",loadLimitSpecialElf);
                                                                                                                                                                                                               LoadSwfAssetsManager.getInstance().addAssets(Config.limitSpecialElfAssets);
                                                                                                                                                                                                            }
                                                                                                                                                                                                            else
                                                                                                                                                                                                            {
                                                                                                                                                                                                               loadLimitSpecialElf();
                                                                                                                                                                                                            }
                                                                                                                                                                                                            UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|限时神兽");
                                                                                                                                                                                                         }
                                                                                                                                                                                                      }
                                                                                                                                                                                                      else
                                                                                                                                                                                                      {
                                                                                                                                                                                                         if(!facade.hasMediator("FlashBaoLiLongMediator"))
                                                                                                                                                                                                         {
                                                                                                                                                                                                            LogUtil("act_flash" + FlashBaoLiLongMediator.bgFlag);
                                                                                                                                                                                                            EventCenter.addEventListener("load_other_asset_complete",loadFlashBaoLiLong);
                                                                                                                                                                                                            LoadOtherAssetsManager.getInstance().addActivityBgAssets("act_flash" + FlashBaoLiLongMediator.bgFlag);
                                                                                                                                                                                                         }
                                                                                                                                                                                                         UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|闪光来袭");
                                                                                                                                                                                                      }
                                                                                                                                                                                                   }
                                                                                                                                                                                                   else
                                                                                                                                                                                                   {
                                                                                                                                                                                                      if(!facade.hasMediator("DayRechargeMediator"))
                                                                                                                                                                                                      {
                                                                                                                                                                                                         EventCenter.addEventListener("load_swf_asset_complete",loadDayRecharge);
                                                                                                                                                                                                         LoadSwfAssetsManager.getInstance().addAssets(Config.dayRechargeAssets);
                                                                                                                                                                                                      }
                                                                                                                                                                                                      UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|天天充值");
                                                                                                                                                                                                   }
                                                                                                                                                                                                }
                                                                                                                                                                                                else
                                                                                                                                                                                                {
                                                                                                                                                                                                   if(!facade.hasMediator("DiamondUpMediator"))
                                                                                                                                                                                                   {
                                                                                                                                                                                                      EventCenter.addEventListener("load_swf_asset_complete",loadDiamondUp);
                                                                                                                                                                                                      LoadSwfAssetsManager.getInstance().addAssets(Config.diamondUpAssets);
                                                                                                                                                                                                   }
                                                                                                                                                                                                   UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|钻石增值");
                                                                                                                                                                                                }
                                                                                                                                                                                             }
                                                                                                                                                                                             else
                                                                                                                                                                                             {
                                                                                                                                                                                                loadHuntingSelectTick();
                                                                                                                                                                                             }
                                                                                                                                                                                          }
                                                                                                                                                                                          else
                                                                                                                                                                                          {
                                                                                                                                                                                             if(!facade.hasMediator("GrowthPlanMediator"))
                                                                                                                                                                                             {
                                                                                                                                                                                                EventCenter.addEventListener("load_swf_asset_complete",loadGrowthPlan);
                                                                                                                                                                                                LoadSwfAssetsManager.getInstance().addAssets(Config.growthPlanAssets);
                                                                                                                                                                                             }
                                                                                                                                                                                             else
                                                                                                                                                                                             {
                                                                                                                                                                                                loadGrowthPlan();
                                                                                                                                                                                             }
                                                                                                                                                                                             UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|成长计划");
                                                                                                                                                                                          }
                                                                                                                                                                                       }
                                                                                                                                                                                       else
                                                                                                                                                                                       {
                                                                                                                                                                                          if(!facade.hasMediator("RanklistMedia"))
                                                                                                                                                                                          {
                                                                                                                                                                                             EventCenter.addEventListener("load_swf_asset_complete",loadRanklist);
                                                                                                                                                                                             LoadSwfAssetsManager.getInstance().addAssets(Config.ranklistAssets);
                                                                                                                                                                                          }
                                                                                                                                                                                          else
                                                                                                                                                                                          {
                                                                                                                                                                                             loadRanklist();
                                                                                                                                                                                          }
                                                                                                                                                                                          UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|排行榜");
                                                                                                                                                                                       }
                                                                                                                                                                                    }
                                                                                                                                                                                    else
                                                                                                                                                                                    {
                                                                                                                                                                                       loadFreeSelectComElf();
                                                                                                                                                                                    }
                                                                                                                                                                                 }
                                                                                                                                                                                 else
                                                                                                                                                                                 {
                                                                                                                                                                                    loadRestElf();
                                                                                                                                                                                    UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|精灵重置");
                                                                                                                                                                                 }
                                                                                                                                                                              }
                                                                                                                                                                              else
                                                                                                                                                                              {
                                                                                                                                                                                 loadResetElfSelectComElf();
                                                                                                                                                                              }
                                                                                                                                                                           }
                                                                                                                                                                           else
                                                                                                                                                                           {
                                                                                                                                                                              loadSelectComElf();
                                                                                                                                                                           }
                                                                                                                                                                        }
                                                                                                                                                                        else
                                                                                                                                                                        {
                                                                                                                                                                           if(!facade.hasMediator("MiracleMediator"))
                                                                                                                                                                           {
                                                                                                                                                                              EventCenter.addEventListener("load_swf_asset_complete",laodMiracle);
                                                                                                                                                                              LoadSwfAssetsManager.getInstance().addAssets(Config.miracleAssets);
                                                                                                                                                                           }
                                                                                                                                                                           else
                                                                                                                                                                           {
                                                                                                                                                                              laodMiracle();
                                                                                                                                                                           }
                                                                                                                                                                           UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|奇迹交换");
                                                                                                                                                                        }
                                                                                                                                                                     }
                                                                                                                                                                     else
                                                                                                                                                                     {
                                                                                                                                                                        laodTrialBossInfo();
                                                                                                                                                                     }
                                                                                                                                                                  }
                                                                                                                                                                  else
                                                                                                                                                                  {
                                                                                                                                                                     laodTrialSelectDifficulty();
                                                                                                                                                                  }
                                                                                                                                                               }
                                                                                                                                                               else
                                                                                                                                                               {
                                                                                                                                                                  laodTrialSelectBoss();
                                                                                                                                                               }
                                                                                                                                                            }
                                                                                                                                                            else
                                                                                                                                                            {
                                                                                                                                                               if(!facade.hasMediator("ActiveMeida"))
                                                                                                                                                               {
                                                                                                                                                                  EventCenter.addEventListener("load_swf_asset_complete",loadSign);
                                                                                                                                                                  LoadSwfAssetsManager.getInstance().addAssets(Config.signAssets);
                                                                                                                                                               }
                                                                                                                                                               else
                                                                                                                                                               {
                                                                                                                                                                  loadSign();
                                                                                                                                                               }
                                                                                                                                                               UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|签到");
                                                                                                                                                            }
                                                                                                                                                         }
                                                                                                                                                         else
                                                                                                                                                         {
                                                                                                                                                            loadScoreGoods();
                                                                                                                                                         }
                                                                                                                                                      }
                                                                                                                                                      else
                                                                                                                                                      {
                                                                                                                                                         if(!facade.hasMediator("ScoreShopMediator"))
                                                                                                                                                         {
                                                                                                                                                            EventCenter.addEventListener("load_swf_asset_complete",loadScoreShop);
                                                                                                                                                            LoadSwfAssetsManager.getInstance().addAssets(Config.scoreShopAssets);
                                                                                                                                                         }
                                                                                                                                                         else
                                                                                                                                                         {
                                                                                                                                                            loadScoreShop();
                                                                                                                                                         }
                                                                                                                                                         UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|积分商店");
                                                                                                                                                      }
                                                                                                                                                   }
                                                                                                                                                   else
                                                                                                                                                   {
                                                                                                                                                      loadPVPProp();
                                                                                                                                                   }
                                                                                                                                                }
                                                                                                                                                else
                                                                                                                                                {
                                                                                                                                                   loadPVPRank();
                                                                                                                                                }
                                                                                                                                             }
                                                                                                                                             else
                                                                                                                                             {
                                                                                                                                                loadPVPRule();
                                                                                                                                             }
                                                                                                                                          }
                                                                                                                                          else
                                                                                                                                          {
                                                                                                                                             loadPVPCheckPsw();
                                                                                                                                          }
                                                                                                                                       }
                                                                                                                                       else
                                                                                                                                       {
                                                                                                                                          loadPVPCRoom();
                                                                                                                                       }
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                       loadReCallSkill();
                                                                                                                                       UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|研修所-回忆技能");
                                                                                                                                    }
                                                                                                                                 }
                                                                                                                                 else
                                                                                                                                 {
                                                                                                                                    loadResetCharacter();
                                                                                                                                    UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|研修所-性格洗练");
                                                                                                                                 }
                                                                                                                              }
                                                                                                                              else
                                                                                                                              {
                                                                                                                                 loadSeleTrainElf();
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
                                                                                                                           loadTrainRoom();
                                                                                                                           UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|研修所-培养室");
                                                                                                                        }
                                                                                                                     }
                                                                                                                     else
                                                                                                                     {
                                                                                                                        loadHJCompound();
                                                                                                                        UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|研修所-合成号角");
                                                                                                                     }
                                                                                                                  }
                                                                                                                  else
                                                                                                                  {
                                                                                                                     loadSetName();
                                                                                                                     UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|研修所-修改昵称");
                                                                                                                  }
                                                                                                               }
                                                                                                               else
                                                                                                               {
                                                                                                                  if(!facade.hasMediator("ActiveMeida"))
                                                                                                                  {
                                                                                                                     EventCenter.addEventListener("load_swf_asset_complete",loadActivity);
                                                                                                                     LoadSwfAssetsManager.getInstance().addAssets(Config.activityAssets);
                                                                                                                  }
                                                                                                                  else
                                                                                                                  {
                                                                                                                     loadActivity();
                                                                                                                  }
                                                                                                                  UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|活动");
                                                                                                               }
                                                                                                            }
                                                                                                            else
                                                                                                            {
                                                                                                               if(!facade.hasMediator("FirstRchargeMediator"))
                                                                                                               {
                                                                                                                  EventCenter.addEventListener("load_swf_asset_complete",loadFirstRecharge);
                                                                                                                  LoadSwfAssetsManager.getInstance().addAssets(Config.firstRechargeAssets);
                                                                                                               }
                                                                                                               else
                                                                                                               {
                                                                                                                  loadFirstRecharge();
                                                                                                               }
                                                                                                               UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|首充");
                                                                                                            }
                                                                                                         }
                                                                                                         else
                                                                                                         {
                                                                                                            loadHorn();
                                                                                                            UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|世界喇叭");
                                                                                                         }
                                                                                                      }
                                                                                                      else
                                                                                                      {
                                                                                                         PlayerVO.isAcceptPvp = false;
                                                                                                         loadSelePlayElf();
                                                                                                      }
                                                                                                   }
                                                                                                   else
                                                                                                   {
                                                                                                      loadRivalInfo();
                                                                                                   }
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                   PlayerVO.isAcceptPvp = false;
                                                                                                   loadFormation();
                                                                                                }
                                                                                             }
                                                                                             else
                                                                                             {
                                                                                                loadSeriesPvp();
                                                                                             }
                                                                                          }
                                                                                          else
                                                                                          {
                                                                                             loadChat();
                                                                                          }
                                                                                       }
                                                                                       else
                                                                                       {
                                                                                          if(!facade.hasMediator("InformationMedia"))
                                                                                          {
                                                                                             EventCenter.addEventListener("load_swf_asset_complete",loadInformation);
                                                                                             LoadSwfAssetsManager.getInstance().addAssets(Config.informationAssets);
                                                                                          }
                                                                                          else
                                                                                          {
                                                                                             loadInformation();
                                                                                          }
                                                                                          UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|消息");
                                                                                       }
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                       if(!facade.hasMediator("FriendMedia"))
                                                                                       {
                                                                                          EventCenter.addEventListener("load_swf_asset_complete",loadFriend);
                                                                                          LoadSwfAssetsManager.getInstance().addAssets(Config.friendAssets);
                                                                                       }
                                                                                       else
                                                                                       {
                                                                                          loadFriend();
                                                                                       }
                                                                                       UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|好友");
                                                                                    }
                                                                                 }
                                                                                 else
                                                                                 {
                                                                                    if(!facade.hasMediator("TaskMedia"))
                                                                                    {
                                                                                       EventCenter.addEventListener("load_swf_asset_complete",loadTask);
                                                                                       LoadSwfAssetsManager.getInstance().addAssets(Config.taskAssets);
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                       loadTask();
                                                                                    }
                                                                                    UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|任务");
                                                                                 }
                                                                              }
                                                                              else
                                                                              {
                                                                                 loadDropProp();
                                                                              }
                                                                           }
                                                                           else
                                                                           {
                                                                              loadAddFriend();
                                                                           }
                                                                        }
                                                                        else
                                                                        {
                                                                           loadExtenMapWin();
                                                                           UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|野外冒险");
                                                                        }
                                                                     }
                                                                     else
                                                                     {
                                                                        loadMainMapWin();
                                                                        UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|节点冒险");
                                                                     }
                                                                  }
                                                                  else
                                                                  {
                                                                     loadServer();
                                                                  }
                                                               }
                                                               else
                                                               {
                                                                  loadAmuseScoreRecharge();
                                                               }
                                                            }
                                                            else
                                                            {
                                                               loadAmuseElfInfo();
                                                            }
                                                         }
                                                         else
                                                         {
                                                            if(!facade.hasMediator("IllustrationsMedia"))
                                                            {
                                                               EventCenter.addEventListener("load_swf_asset_complete",loadIllustration);
                                                               LoadSwfAssetsManager.getInstance().addAssets(Config.IllustrationsAssets);
                                                            }
                                                            else
                                                            {
                                                               loadIllustration();
                                                            }
                                                            UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|精灵图鉴");
                                                         }
                                                      }
                                                      else
                                                      {
                                                         loadElfName();
                                                      }
                                                   }
                                                   else if(!facade.hasMediator("EvolveMcMediator"))
                                                   {
                                                      EventCenter.addEventListener("load_swf_asset_complete",loadElfEvolveMc);
                                                      LoadOtherAssetsManager.getInstance().addEvolveAssets(Config.elfEvolveMusicAssets);
                                                   }
                                                   else
                                                   {
                                                      loadElfEvolveMc();
                                                   }
                                                }
                                                else
                                                {
                                                   loadElfDetail();
                                                }
                                             }
                                             else
                                             {
                                                loadOtherPlayer();
                                             }
                                          }
                                          else
                                          {
                                             loadBuySure();
                                          }
                                       }
                                       else
                                       {
                                          loadSkillPanel();
                                       }
                                    }
                                    else
                                    {
                                       loadTrainerPicPanel();
                                    }
                                 }
                                 else
                                 {
                                    loadHeadPicPanel();
                                    UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|更改头像");
                                 }
                              }
                              else
                              {
                                 loadPlayInfoPanel();
                                 UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|个人信息");
                              }
                           }
                           else
                           {
                              loadPowerPanel();
                              UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|购买体力");
                           }
                        }
                        else
                        {
                           loadDiamondPanel();
                           UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|购买钻石");
                        }
                     }
                     else
                     {
                        loadMoneyPanel();
                        UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|购买金币");
                     }
                  }
                  else
                  {
                     loadPlayElf();
                  }
               }
               else
               {
                  loadBackPack();
                  UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|背包");
               }
            }
            else
            {
               loadElf();
               UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|精灵背包");
            }
         }
         else
         {
            loadLoginWindow();
         }
      }
      
      private function loadHuntBag() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadHuntBag);
         if(!facade.hasMediator("HuntingBagMedia"))
         {
            facade.registerMediator(new HuntingBagMedia(new HuntingBagUI()));
         }
         var _loc1_:HuntingBagUI = (facade.retrieveMediator("HuntingBagMedia") as HuntingBagMedia).UI as HuntingBagUI;
         _loc1_.name = "HuntingBagMedia";
         WinTweens.hideCity();
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadHuntBagAfter);
         WinTweens.openWin(_loc1_.spr_bag);
      }
      
      private function loadHuntBagAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadHuntBagAfter);
         sendNotification("SHOW_HUNTBAG_UI");
      }
      
      private function loadBuyCount() : void
      {
         if(!facade.hasMediator("HuntBuyCountMedia"))
         {
            facade.registerMediator(new HuntBuyCountMedia(new HuntBuyCountUI()));
         }
         var _loc1_:HuntBuyCountUI = (facade.retrieveMediator("HuntBuyCountMedia") as HuntBuyCountMedia).UI as HuntBuyCountUI;
         _loc1_.name = "HuntBuyCountMedia";
         rootClass.addChild(_loc1_);
         sendNotification("SHOW_HUNTBUYCOUNT_UI");
      }
      
      private function loadAdventure() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadAdventure);
         if(!facade.hasMediator("HuntAdventureMedia"))
         {
            facade.registerMediator(new HuntAdventureMedia(new HuntAdventureUI()));
         }
         var _loc1_:HuntAdventureUI = (facade.retrieveMediator("HuntAdventureMedia") as HuntAdventureMedia).UI as HuntAdventureUI;
         _loc1_.name = "HuntAdventureMedia";
         rootClass.addChild(_loc1_);
         sendNotification("SHOW_HUNTADVENTURE_UI");
      }
      
      private function loadBuff() : void
      {
         if(!facade.hasMediator("BuffMedia"))
         {
            facade.registerMediator(new BuffMedia(new BuffUI()));
         }
         var _loc1_:BuffUI = (facade.retrieveMediator("BuffMedia") as BuffMedia).UI as BuffUI;
         _loc1_.name = "BuffMedia";
         rootClass.addChild(_loc1_);
         sendNotification("SHOW_HUNTBUFF_UI");
      }
      
      private function loadHuntingReward() : void
      {
         if(!facade.hasMediator("HuntingRewardMedia"))
         {
            facade.registerMediator(new HuntingRewardMedia(new HuntingRewardUI()));
         }
         var _loc1_:HuntingRewardUI = (facade.retrieveMediator("HuntingRewardMedia") as HuntingRewardMedia).UI as HuntingRewardUI;
         _loc1_.name = "HuntingRewardMedia";
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadHuntingRewardAfter);
         WinTweens.openWin(_loc1_.spr_reward);
      }
      
      private function loadHuntingRewardAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadHuntingRewardAfter);
         if(GetHuntingParty.rewardVec.length == 0)
         {
            GetHuntingParty.GetHuntPartyReward();
         }
         (facade.retrieveProxy("HuntingPartyPro") as HuntingPartyPro).write4104();
      }
      
      private function loadHuntingRank() : void
      {
         if(!facade.hasMediator("HuntingRankMedia"))
         {
            facade.registerMediator(new HuntingRankMedia(new HuntingRankUI()));
         }
         var _loc1_:HuntingRankUI = (facade.retrieveMediator("HuntingRankMedia") as HuntingRankMedia).UI as HuntingRankUI;
         _loc1_.name = "HuntingRankMedia";
         WinTweens.hideCity();
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadHuntingRankAfter);
         WinTweens.openWin(_loc1_.spr_rank);
      }
      
      private function loadHuntingRankAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadHuntingRankAfter);
         (facade.retrieveProxy("HuntingPartyPro") as HuntingPartyPro).write4109();
      }
      
      private function loadHuntingTask() : void
      {
         if(!facade.hasMediator("HuntingTaskMedia"))
         {
            facade.registerMediator(new HuntingTaskMedia(new HuntingTaskUI()));
         }
         var _loc1_:HuntingTaskUI = (facade.retrieveMediator("HuntingTaskMedia") as HuntingTaskMedia).UI as HuntingTaskUI;
         _loc1_.name = "HuntingTaskMedia";
         WinTweens.hideCity();
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadHuntingTaskAfter);
         WinTweens.openWin(_loc1_.spr_task);
      }
      
      private function loadHuntingTaskAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadHuntingTaskAfter);
         sendNotification("SHOW_GOALELF_UI");
      }
      
      private function loadActPreview() : void
      {
         if(!facade.hasMediator("ActPreviewMediator"))
         {
            facade.registerMediator(new ActPreviewMediator(new ActPreviewUI()));
         }
         var _loc1_:ActPreviewUI = (facade.retrieveMediator("ActPreviewMediator") as ActPreviewMediator).UI as ActPreviewUI;
         _loc1_.name = "ActPreviewMediator";
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadActPreviewAfter);
         WinTweens.openWin(_loc1_.spr_actPreview);
      }
      
      private function loadActPreviewAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadActPreviewAfter);
         sendNotification(ConfigConst.SHOW_ACTPREVIEW_IMAGE);
      }
      
      private function loadMiningDefendRecord() : void
      {
         if(!facade.hasMediator("MiningDefendRecordMediator"))
         {
            facade.registerMediator(new MiningDefendRecordMediator(new MiningDefendRecordUI()));
         }
         var _loc1_:MiningDefendRecordUI = (facade.retrieveMediator("MiningDefendRecordMediator") as MiningDefendRecordMediator).UI as MiningDefendRecordUI;
         _loc1_.name = "MiningDefendRecordMediator";
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadMiningDefendRecordAfter);
         WinTweens.openWin(_loc1_.spr_fightRecord);
      }
      
      private function loadMiningDefendRecordAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadMiningDefendRecordAfter);
         (facade.retrieveProxy("Miningpro") as MiningPro).write3905();
      }
      
      private function loadMiningSelectMember() : void
      {
         if(!facade.hasMediator("MiningSelectMemberMediator"))
         {
            facade.registerMediator(new MiningSelectMemberMediator(new MiningSelectMemberUI()));
         }
         var _loc1_:MiningSelectMemberUI = (facade.retrieveMediator("MiningSelectMemberMediator") as MiningSelectMemberMediator).UI as MiningSelectMemberUI;
         _loc1_.name = "MiningSelectMemberMediator";
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadMiningSelectMemberAfter);
         WinTweens.openWin(_loc1_.spr_selectMember);
      }
      
      private function loadMiningSelectMemberAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadMiningSelectMemberAfter);
         (facade.retrieveProxy("UnionPro") as UnionPro).write3410();
      }
      
      private function loadMiningInvite() : void
      {
         if(!facade.hasMediator("MiningInviteMediator"))
         {
            facade.registerMediator(new MiningInviteMediator(new MiningInviteUI()));
         }
         var _loc1_:MiningInviteUI = (facade.retrieveMediator("MiningInviteMediator") as MiningInviteMediator).UI as MiningInviteUI;
         _loc1_.name = "MiningInviteMediator";
         rootClass.addChild(_loc1_);
         WinTweens.openWin(_loc1_.spr_invite);
         sendNotification("mining_update_invite_minename");
      }
      
      private function loadMiningCheckFormat() : void
      {
         if(!facade.hasMediator("MiningCheckFormatMediator"))
         {
            facade.registerMediator(new MiningCheckFormatMediator(new MiningCheckFormatUI()));
         }
         var _loc1_:MiningCheckFormatUI = (facade.retrieveMediator("MiningCheckFormatMediator") as MiningCheckFormatMediator).UI as MiningCheckFormatUI;
         _loc1_.name = "MiningCheckFormatMediator";
         rootClass.addChild(_loc1_);
         WinTweens.openWin(_loc1_.spr_campInfo);
      }
      
      private function loadMiningSelectType() : void
      {
         if(!facade.hasMediator("MiningSelectTypeMediator"))
         {
            facade.registerMediator(new MiningSelectTypeMediator(new MiningSelectTypeUI()));
         }
         var _loc1_:MiningSelectTypeUI = (facade.retrieveMediator("MiningSelectTypeMediator") as MiningSelectTypeMediator).UI as MiningSelectTypeUI;
         _loc1_.name = "MiningSelectTypeMediator";
         rootClass.addChild(_loc1_);
         WinTweens.openWin(_loc1_.spr_miningSelect);
      }
      
      private function loadMedal() : void
      {
         if(!facade.hasMediator("MedalMedia"))
         {
            facade.registerMediator(new MedalMedia(new MedalUI()));
         }
         var _loc1_:MedalUI = (facade.retrieveMediator("MedalMedia") as MedalMedia).UI as MedalUI;
         _loc1_.name = "MedalMedia";
         WinTweens.hideCity();
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadMedalAfter);
         WinTweens.openWin(_loc1_.spr_medal);
      }
      
      private function loadMedalAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadMedalAfter);
         sendNotification("SHOW_MEDAL_LIST");
      }
      
      private function loadPrefer() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadPrefer);
         if(!facade.hasMediator("PreferMedia"))
         {
            facade.registerMediator(new PreferMedia(new PreferUI()));
         }
         var _loc1_:PreferUI = (facade.retrieveMediator("PreferMedia") as PreferMedia).UI as PreferUI;
         _loc1_.name = "PreferMedia";
         WinTweens.hideCity();
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadPreferStudyAfter);
         WinTweens.openWin(_loc1_.spr_prefer);
      }
      
      private function loadPreferStudyAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadPreferStudyAfter);
         (facade.retrieveProxy("SpecialActivePro") as SpecialActPro).write1912();
      }
      
      private function loadFlashBaoLiLong() : void
      {
         EventCenter.removeEventListener("load_other_asset_complete",loadFlashBaoLiLong);
         if(!facade.hasMediator("FlashBaoLiLongMediator"))
         {
            facade.registerMediator(new FlashBaoLiLongMediator(new FlashBaoLiLongUI()));
         }
         var _loc1_:FlashBaoLiLongUI = (facade.retrieveMediator("FlashBaoLiLongMediator") as FlashBaoLiLongMediator).UI as FlashBaoLiLongUI;
         _loc1_.name = "FlashBaoLiLongMediator";
         rootClass.addChild(_loc1_);
         sendNotification(ConfigConst.UPDATE_FLASHELF_INFO,FlashBaoLiLongMediator.lightElfInfoObj);
      }
      
      private function loadStudyChild() : void
      {
         if(!facade.hasMediator("StudyChildMedia"))
         {
            facade.registerMediator(new StudyChildMedia(new StudyChildUI()));
         }
         var _loc1_:StudyChildUI = (facade.retrieveMediator("StudyChildMedia") as StudyChildMedia).UI as StudyChildUI;
         _loc1_.name = "StudyChildMedia";
         rootClass.addChild(_loc1_);
         (facade.retrieveProxy("UnionPro") as UnionPro).write3421(StudyChildMedia.typePage);
      }
      
      private function loadUnionStudy() : void
      {
         WinTweens.hideCity();
         EventCenter.removeEventListener("load_swf_asset_complete",loadUnionStudy);
         if(!facade.hasMediator("UnionStudyMedia"))
         {
            facade.registerMediator(new UnionStudyMedia(new UnionStudyUI()));
         }
         var _loc1_:UnionStudyUI = (facade.retrieveMediator("UnionStudyMedia") as UnionStudyMedia).UI as UnionStudyUI;
         _loc1_.name = "UnionStudyMedia";
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadUnionStudyAfter);
         WinTweens.openWin(_loc1_.spr_study);
      }
      
      private function loadUnionStudyAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadUnionStudyAfter);
         facade.sendNotification(ConfigConst.SHOW_UNIONSTUDY_BTN);
      }
      
      private function loadOtherTrain() : void
      {
         if(!facade.hasMediator("OtherTrainMedia"))
         {
            facade.registerMediator(new OtherTrainMedia(new OtherTrainUI()));
         }
         var _loc1_:OtherTrainUI = (facade.retrieveMediator("OtherTrainMedia") as OtherTrainMedia).UI as OtherTrainUI;
         _loc1_.name = "OtherTrainMedia";
         rootClass.addChild(_loc1_);
         sendNotification(ConfigConst.SHOW_OTHERTRAIN_LIST);
      }
      
      private function loadUnionTrain() : void
      {
         WinTweens.hideCity();
         EventCenter.removeEventListener("load_swf_asset_complete",loadUnionTrain);
         if(!facade.hasMediator("UnionTrainMedia"))
         {
            facade.registerMediator(new UnionTrainMedia(new UnionTrainUI()));
         }
         var _loc1_:UnionTrainUI = (facade.retrieveMediator("UnionTrainMedia") as UnionTrainMedia).UI as UnionTrainUI;
         _loc1_.name = "UnionTrainMedia";
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadUnionTrainAfter);
         WinTweens.openWin(_loc1_.spr_unionTrain);
      }
      
      private function loadUnionTrainAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadUnionTrainAfter);
         (facade.retrieveProxy("UnionPro") as UnionPro).write3418();
      }
      
      private function loadUnionHall() : void
      {
         WinTweens.hideCity();
         EventCenter.removeEventListener("load_swf_asset_complete",loadUnionHall);
         if(!facade.hasMediator("UnionHallMedia"))
         {
            facade.registerMediator(new UnionHallMedia(new UnionHallUI()));
         }
         var _loc1_:UnionHallUI = (facade.retrieveMediator("UnionHallMedia") as UnionHallMedia).UI as UnionHallUI;
         _loc1_.name = "UnionHallMedia";
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadUnionHallAfter);
         WinTweens.openWin(_loc1_.spr_unionHall);
      }
      
      private function loadUnionHallAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadUnionHallAfter);
         (facade.retrieveProxy("UnionPro") as UnionPro).write3410();
      }
      
      private function loadResetCharacter() : void
      {
         if(!facade.hasMediator("ResetCharacterMediator"))
         {
            facade.registerMediator(new ResetCharacterMediator(new ResetCharacterUI()));
         }
         var _loc1_:ResetCharacterUI = (facade.retrieveMediator("ResetCharacterMediator") as ResetCharacterMediator).UI as ResetCharacterUI;
         _loc1_.name = "ResetCharacterMediator";
         rootClass.addChild(_loc1_);
         WinTweens.openWin(_loc1_.spr_character);
      }
      
      private function loadReCallSkill() : void
      {
         if(!facade.hasMediator("ReCallSkillMedia"))
         {
            facade.registerMediator(new ReCallSkillMedia(new RecallSkillUI()));
         }
         var _loc1_:RecallSkillUI = (facade.retrieveMediator("ReCallSkillMedia") as ReCallSkillMedia).UI as RecallSkillUI;
         _loc1_.name = "ReCallSkillMedia";
         rootClass.addChild(_loc1_);
      }
      
      private function loadHuntingSelectTick() : void
      {
         if(!facade.hasMediator("HuntingSelectTickMediator"))
         {
            facade.registerMediator(new HuntingSelectTickMediator(new HuntingSelectTickUI()));
         }
         var _loc1_:HuntingSelectTickUI = (facade.retrieveMediator("HuntingSelectTickMediator") as HuntingSelectTickMediator).UI as HuntingSelectTickUI;
         _loc1_.name = "HuntingSelectTickMediator";
         WinTweens.hideCity();
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadHuntingSelectTickAfter);
         WinTweens.openWin(_loc1_.mySpr);
      }
      
      private function loadHuntingSelectTickAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadHuntingSelectTickAfter);
         sendNotification("update_hunting_select_prop");
      }
      
      private function loadDiamondUp() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadDiamondUp);
         if(!facade.hasMediator("DiamondUpMediator"))
         {
            facade.registerMediator(new DiamondUpMediator(new DiamondUpUI()));
         }
         var _loc1_:DiamondUpUI = (facade.retrieveMediator("DiamondUpMediator") as DiamondUpMediator).UI as DiamondUpUI;
         _loc1_.name = "DiamondUpMediator";
         WinTweens.hideCity();
         rootClass.addChild(_loc1_);
         sendNotification("UPDATE_DIAMONDUP_INFO");
      }
      
      private function loadDayRecharge() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadDayRecharge);
         if(!facade.hasMediator("DayRechargeMediator"))
         {
            facade.registerMediator(new DayRechargeMediator(new DayRechargeUI()));
         }
         var _loc1_:DayRechargeUI = (facade.retrieveMediator("DayRechargeMediator") as DayRechargeMediator).UI as DayRechargeUI;
         _loc1_.name = "DayRechargeMediator";
         WinTweens.hideCity();
         rootClass.addChild(_loc1_);
         (facade.retrieveProxy("SpecialActivePro") as SpecialActPro).write1908();
      }
      
      private function loadLimitSpecialElf() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadLimitSpecialElf);
         if(!facade.hasMediator("LimitSpecialElfMediaor"))
         {
            facade.registerMediator(new LimitSpecialElfMediaor(new LimitSpecialElfUI()));
         }
         var _loc1_:LimitSpecialElfUI = (facade.retrieveMediator("LimitSpecialElfMediaor") as LimitSpecialElfMediaor).UI as LimitSpecialElfUI;
         _loc1_.name = "LimitSpecialElfMediaor";
         WinTweens.hideCity();
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadLimitSpecialElfAfter);
         WinTweens.openWin(_loc1_.spr_limitSpecialElf);
      }
      
      private function loadLimitSpecialElfAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadLimitSpecialElfAfter);
         (facade.retrieveProxy("SpecialActivePro") as SpecialActPro).write2505();
      }
      
      private function loadGrowthPlan() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadGrowthPlan);
         if(!facade.hasMediator("GrowthPlanMediator"))
         {
            facade.registerMediator(new GrowthPlanMediator(new GrowthPlanUI()));
         }
         var _loc1_:GrowthPlanUI = (facade.retrieveMediator("GrowthPlanMediator") as GrowthPlanMediator).UI as GrowthPlanUI;
         _loc1_.name = "GrowthPlanMediator";
         WinTweens.hideCity();
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadGrowthPlanAfter);
         WinTweens.openWin(_loc1_.spr_growthPlan);
      }
      
      private function loadGrowthPlanAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadGrowthPlanAfter);
         (facade.retrieveProxy("GrowthPlanPro") as GrowthPlanPro).write1904();
      }
      
      private function loadRanklist() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadRanklist);
         if(!facade.hasMediator("RanklistMedia"))
         {
            facade.registerMediator(new RanklistMedia(new RanklistUI()));
         }
         var _loc1_:RanklistUI = (facade.retrieveMediator("RanklistMedia") as RanklistMedia).UI as RanklistUI;
         _loc1_.name = "RanklistMedia";
         WinTweens.hideCity();
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadRankAfter);
         WinTweens.openWin(_loc1_.spr_rank);
      }
      
      private function loadRankAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadRankAfter);
         sendNotification("SHOW_RANK_MENU");
         (facade.retrieveProxy("RankListPro") as RankListPro).write2701(0);
      }
      
      private function loadFreeSelectComElf() : void
      {
         if(!facade.hasMediator("FreeSelectElfMediator"))
         {
            facade.registerMediator(new FreeSelectElfMediator(new FreeSelectElfUI()));
         }
         var _loc1_:FreeSelectElfUI = (facade.retrieveMediator("FreeSelectElfMediator") as FreeSelectElfMediator).UI as FreeSelectElfUI;
         _loc1_.name = "FreeSelectElfMediator";
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadFreeSelectComElfAfter);
         WinTweens.openWin(_loc1_.spr_selectElf);
      }
      
      private function loadFreeSelectComElfAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadFreeSelectComElfAfter);
         var _loc1_:Vector.<ElfVO> = ElfSortHandler.getPlayerELF(false,true,false);
         sendNotification("freeshop_update_elf_list",_loc1_);
         _loc1_ = Vector.<ElfVO>([]);
         _loc1_ = null;
      }
      
      private function loadRestElf() : void
      {
         if(!facade.hasMediator("ResetElfMediator"))
         {
            facade.registerMediator(new ResetElfMediator(new ResetElfUI()));
         }
         var _loc1_:ResetElfUI = (facade.retrieveMediator("ResetElfMediator") as ResetElfMediator).UI as ResetElfUI;
         _loc1_.name = "ResetElfMediator";
         rootClass.addChild(_loc1_);
         WinTweens.openWin(_loc1_.spr_resetElf);
      }
      
      private function loadResetElfSelectComElf() : void
      {
         if(!facade.hasMediator("ResetSelectElfMediator"))
         {
            facade.registerMediator(new ResetSelectElfMediator(new ResetSelectElfUI()));
         }
         var _loc1_:ResetSelectElfUI = (facade.retrieveMediator("ResetSelectElfMediator") as ResetSelectElfMediator).UI as ResetSelectElfUI;
         _loc1_.name = "ResetSelectElfMediator";
         WinTweens.hideCity();
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadResetElfSelectComElfAfter);
         WinTweens.openWin(_loc1_.spr_selectElf);
      }
      
      private function loadResetElfSelectComElfAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadResetElfSelectComElfAfter);
         var _loc1_:Vector.<ElfVO> = ElfSortHandler.getPlayerELF(false,true,false);
         sendNotification("resetelf_update_list",_loc1_.sort(ElfSortHandler.sortLvDecrease));
      }
      
      private function loadSelectComElf() : void
      {
         if(!facade.hasMediator("MiracleSelectElfMediator"))
         {
            facade.registerMediator(new MiracleSelectElfMediator(new MiracleSelectElfUI()));
         }
         var _loc1_:MiracleSelectElfUI = (facade.retrieveMediator("MiracleSelectElfMediator") as MiracleSelectElfMediator).UI as MiracleSelectElfUI;
         _loc1_.name = "MiracleSelectElfMediator";
         rootClass.addChild(_loc1_);
         WinTweens.openWin(_loc1_.spr_selectElf);
      }
      
      private function laodMiracle() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",laodMiracle);
         if(!facade.hasMediator("MiracleMediator"))
         {
            facade.registerMediator(new MiracleMediator(new MiracleUI()));
         }
         var _loc1_:MiracleUI = (facade.retrieveMediator("MiracleMediator") as MiracleMediator).UI as MiracleUI;
         _loc1_.name = "MiracleMediator";
         WinTweens.hideCity();
         rootClass.addChild(_loc1_);
         WinTweens.openWin(_loc1_.spr_miracle);
         BeginnerGuide.playBeginnerGuide();
      }
      
      private function loadSeleTrainElf() : void
      {
         if(!facade.hasMediator("SeleTrainElfMedia"))
         {
            facade.registerMediator(new SeleTrainElfMedia(new SeleTrainElfUI()));
         }
         var _loc1_:SeleTrainElfUI = (facade.retrieveMediator("SeleTrainElfMedia") as SeleTrainElfMedia).UI as SeleTrainElfUI;
         _loc1_.name = "SeleTrainElfMedia";
         rootClass.addChild(_loc1_);
         sendNotification("SHOW_SELETRAINELF");
      }
      
      private function loadLoginWindow() : void
      {
         if(!facade.hasMediator("LoginWidowMedia"))
         {
            facade.registerMediator(new LoginWidowMedia(new LoginWindowUI()));
         }
         var _loc1_:LoginWindowUI = (facade.retrieveMediator("LoginWidowMedia") as LoginWidowMedia).UI as LoginWindowUI;
         _loc1_.name = "LoginWidowMedia";
         rootClass.addChild(_loc1_);
      }
      
      private function loadSign() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadSign);
         if(!facade.hasMediator("SignMedia"))
         {
            facade.registerMediator(new SignMedia(new SignUI()));
         }
         var _loc1_:SignUI = (facade.retrieveMediator("SignMedia") as SignMedia).UI as SignUI;
         _loc1_.name = "SignMedia";
         WinTweens.hideCity();
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadSignAfter);
         WinTweens.openWin(_loc1_.spr_sign);
      }
      
      private function loadSignAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadSignAfter);
         if(SignPro.addUpVec.length != 0)
         {
            sendNotification("SEND_SIGN_REWARDF");
         }
         else
         {
            Tips.show("没有数据哦");
         }
      }
      
      private function laodTrialBossInfo() : void
      {
         if(!facade.hasMediator("TrialBossInfoMediator"))
         {
            facade.registerMediator(new TrialBossInfoMediator(new TrialBossInfoUI()));
         }
         var _loc1_:TrialBossInfoUI = (facade.retrieveMediator("TrialBossInfoMediator") as TrialBossInfoMediator).UI as TrialBossInfoUI;
         _loc1_.name = "TrialBossInfoMediator";
         rootClass.addChild(_loc1_);
         WinTweens.openWin(_loc1_.spr_bossInfo);
      }
      
      private function laodTrialSelectDifficulty() : void
      {
         FightingConfig.selectMap = null;
         if(!facade.hasMediator("TrialSelectDifficultyModiator"))
         {
            facade.registerMediator(new TrialSelectDifficultyModiator(new TrialSelectDifficultyUI()));
         }
         var _loc1_:TrialSelectDifficultyUI = (facade.retrieveMediator("TrialSelectDifficultyModiator") as TrialSelectDifficultyModiator).UI as TrialSelectDifficultyUI;
         _loc1_.name = "TrialSelectDifficultyModiator";
         rootClass.addChild(_loc1_);
         WinTweens.openWin(_loc1_.spr_select_difficulty);
      }
      
      private function laodTrialSelectBoss() : void
      {
         if(!facade.hasMediator("TrialSelectBossMediator"))
         {
            facade.registerMediator(new TrialSelectBossMediator(new TrialSelectBossUI()));
         }
         var _loc1_:TrialSelectBossUI = (facade.retrieveMediator("TrialSelectBossMediator") as TrialSelectBossMediator).UI as TrialSelectBossUI;
         _loc1_.name = "TrialSelectBossMediator";
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadSelectBossAfter);
         WinTweens.openWin(_loc1_.spr_select_boss);
      }
      
      private function loadSelectBossAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadSelectBossAfter);
         if(TrialSelectBossMediator.isAllBossLoaded)
         {
            sendNotification("trial_update_boss_list");
         }
      }
      
      private function loadScoreGoods() : void
      {
         if(!facade.hasMediator("ScoreGoodsInfoMediator"))
         {
            facade.registerMediator(new ScoreGoodsInfoMediator(new ScoreGoodInfoUI()));
         }
         var _loc1_:ScoreGoodInfoUI = (facade.retrieveMediator("ScoreGoodsInfoMediator") as ScoreGoodsInfoMediator).UI as ScoreGoodInfoUI;
         _loc1_.name = "ScoreGoodsInfoMediator";
         rootClass.addChild(_loc1_);
         WinTweens.openWin(_loc1_.spr_goodsInfo);
      }
      
      private function loadScoreShop() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadScoreShop);
         if(!facade.hasMediator("ScoreShopMediator"))
         {
            facade.registerMediator(new ScoreShopMediator(new ScoreShopUI()));
         }
         var _loc1_:ScoreShopUI = (facade.retrieveMediator("ScoreShopMediator") as ScoreShopMediator).UI as ScoreShopUI;
         _loc1_.name = "ScoreShopMediator";
         if(rootClass.page is MainCityUI)
         {
            WinTweens.hideCity();
         }
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadScoreShopAfter);
         WinTweens.openWin(_loc1_.spr_pvpShop);
      }
      
      private function loadScoreShopAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadScoreShopAfter);
         var _loc1_:* = ScoreShopMediator.nowType;
         if("PVPBgMediator" !== _loc1_)
         {
            if("KingKwanMedia" !== _loc1_)
            {
               if("ElfSeriesMedia" !== _loc1_)
               {
                  if("MainCityMedia" !== _loc1_)
                  {
                     if("ShopMedia" === _loc1_)
                     {
                        (facade.retrieveProxy("ShopPro") as ShopPro).write3601();
                     }
                  }
                  else
                  {
                     (facade.retrieveProxy("HomePro") as HomePro).write2801();
                  }
               }
               else
               {
                  (facade.retrieveProxy("ElfSeriesPro") as ElfSeriesPro).write5020();
               }
            }
            else
            {
               (facade.retrieveProxy("KingKwanPro") as KingKwanPro).write2310();
            }
         }
         else
         {
            (facade.retrieveProxy("PVPPro") as PVPPro).write6250();
         }
      }
      
      private function loadPVPProp() : void
      {
         if(!GetPropFactor.getCarry() && !GetPropFactor.getHagberry())
         {
            Tips.show("背包暂时没有PVP可用道具");
            return;
         }
         if(!facade.hasMediator("PVPPropMediator"))
         {
            facade.registerMediator(new PVPPropMediator(new PVPPropUI()));
         }
         var _loc1_:PVPPropUI = (facade.retrieveMediator("PVPPropMediator") as PVPPropMediator).UI as PVPPropUI;
         _loc1_.name = "PVPPropMediator";
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadPVPPropAfter);
         WinTweens.openWin(_loc1_.mySpr);
      }
      
      private function loadPVPPropAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadPVPPropAfter);
         sendNotification("update_pvp_prop");
      }
      
      private function loadPVPRank() : void
      {
         if(!facade.hasMediator("PVPRankMediator"))
         {
            facade.registerMediator(new PVPRankMediator(new PVPRankUI()));
         }
         var _loc1_:PVPRankUI = (facade.retrieveMediator("PVPRankMediator") as PVPRankMediator).UI as PVPRankUI;
         _loc1_.name = "PVPRankMediator";
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadPVPRankAfter);
         WinTweens.openWin(_loc1_.spr_rankPanleBg);
      }
      
      private function loadPVPRankAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadPVPRankAfter);
         (facade.retrieveProxy("PVPPro") as PVPPro).write6012();
      }
      
      private function loadPVPRule() : void
      {
         if(!facade.hasMediator("PVPRuleMediator"))
         {
            facade.registerMediator(new PVPRuleMediator(new PVPRuleUI()));
         }
         var _loc1_:PVPRuleUI = (facade.retrieveMediator("PVPRuleMediator") as PVPRuleMediator).UI as PVPRuleUI;
         _loc1_.name = "PVPRuleMediator";
         _loc1_.setRule(!PVPBgMediator.isEnterRoom);
         rootClass.addChild(_loc1_);
         WinTweens.openWin(_loc1_.spr_rule);
      }
      
      private function loadPVPCheckPsw() : void
      {
         if(!facade.hasMediator("PVPCheckPswMediator"))
         {
            facade.registerMediator(new PVPCheckPswMediator(new PVPCheckPswUI()));
         }
         var _loc1_:PVPCheckPswUI = (facade.retrieveMediator("PVPCheckPswMediator") as PVPCheckPswMediator).UI as PVPCheckPswUI;
         _loc1_.name = "PVPCheckPswMediator";
         rootClass.addChild(_loc1_);
         WinTweens.openWin(_loc1_.spr_inputPsw);
      }
      
      private function loadPVPCRoom() : void
      {
         if(!facade.hasMediator("PVPCRoomMediator"))
         {
            facade.registerMediator(new PVPCRoomMediator(new PVPCRoomUI()));
         }
         var _loc1_:PVPCRoomUI = (facade.retrieveMediator("PVPCRoomMediator") as PVPCRoomMediator).UI as PVPCRoomUI;
         _loc1_.name = "PVPCRoomMediator";
         rootClass.addChild(_loc1_);
         WinTweens.openWin(_loc1_.spr_createRoom);
         BeginnerGuide.playBeginnerGuide();
      }
      
      private function loadTrainElf() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadTrainElf);
         if(!facade.hasMediator("TrainMedia"))
         {
            facade.registerMediator(new TrainMedia(new TrainUI()));
         }
         var _loc1_:TrainUI = (facade.retrieveMediator("TrainMedia") as TrainMedia).UI as TrainUI;
         _loc1_.name = "TrainMedia";
         WinTweens.hideCity();
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadTrainAfter);
         WinTweens.openWin(_loc1_.spr_train);
      }
      
      private function loadTrainAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadTrainAfter);
         (facade.retrieveProxy("TrainPro") as TrainPro).write3500(1);
      }
      
      private function loadTrainRoom() : void
      {
         if(!facade.hasMediator("TrainRoomMedia"))
         {
            facade.registerMediator(new TrainRoomMedia(new TrainRoomUI()));
         }
         var _loc1_:TrainRoomUI = (facade.retrieveMediator("TrainRoomMedia") as TrainRoomMedia).UI as TrainRoomUI;
         _loc1_.name = "TrainRoomMedia";
         rootClass.addChild(_loc1_);
      }
      
      private function loadSetName() : void
      {
         if(!facade.hasMediator("SetNameMedia"))
         {
            facade.registerMediator(new SetNameMedia(new SetNameUI()));
         }
         var _loc1_:SetNameUI = (facade.retrieveMediator("SetNameMedia") as SetNameMedia).UI as SetNameUI;
         _loc1_.name = "SetNameMedia";
         rootClass.addChild(_loc1_);
      }
      
      private function loadHJCompound() : void
      {
         if(!facade.hasMediator("HJCompoundMediator"))
         {
            facade.registerMediator(new HJCompoundMediator(new HJCompoundUI()));
         }
         var _loc1_:HJCompoundUI = (facade.retrieveMediator("HJCompoundMediator") as HJCompoundMediator).UI as HJCompoundUI;
         _loc1_.name = "HJCompoundMediator";
         rootClass.addChild(_loc1_);
      }
      
      private function loadActivity() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadActivity);
         if(!facade.hasMediator("ActiveMeida"))
         {
            facade.registerMediator(new ActiveMeida(new ActiveUI()));
         }
         var _loc1_:ActiveUI = (facade.retrieveMediator("ActiveMeida") as ActiveMeida).UI as ActiveUI;
         WinTweens.hideCity();
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadActivityAfter);
         WinTweens.openWin(_loc1_.spr_bg);
      }
      
      private function loadActivityAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadActivityAfter);
         (facade.retrieveProxy("ActivePro") as ActivePro).write1901();
      }
      
      private function loadHorn() : void
      {
         if(!facade.hasMediator("HornMedia"))
         {
            facade.registerMediator(new HornMedia(new HornUI()));
         }
         var _loc1_:HornUI = (facade.retrieveMediator("HornMedia") as HornMedia).UI as HornUI;
         _loc1_.name = "HornMedia";
         rootClass.addChild(_loc1_);
         WinTweens.openWin(_loc1_.spr_horn);
      }
      
      private function loadFirstRecharge() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadFirstRecharge);
         if(!facade.hasMediator("FirstRchargeMediator"))
         {
            facade.registerMediator(new FirstRchargeMediator(new FirstRechargeUI()));
         }
         var _loc1_:FirstRechargeUI = (facade.retrieveMediator("FirstRchargeMediator") as FirstRchargeMediator).UI as FirstRechargeUI;
         _loc1_.name = "FirstRchargeMediator";
         rootClass.addChild(_loc1_);
         WinTweens.openWin(_loc1_.firstRchargeSpr);
      }
      
      private function loadSelePlayElf() : void
      {
         if(!facade.hasMediator("SelePlayElfMedia"))
         {
            facade.registerMediator(new SelePlayElfMedia(new SelePlayElfUI()));
         }
         var _loc1_:SelePlayElfUI = (facade.retrieveMediator("SelePlayElfMedia") as SelePlayElfMedia).UI as SelePlayElfUI;
         _loc1_.name = "SelePlayElfMedia";
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadSelePlayElfAfter);
         FightingConfig.temGetBagElf();
         rootClass.addChild(_loc1_);
         WinTweens.openWin(_loc1_.spr_allelf);
      }
      
      private function loadSelePlayElfAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadSelePlayElfAfter);
         sendNotification("SHOW_COMPLAY_ELF");
         sendNotification("SHOW_PLAY_ELF");
      }
      
      private function loadRivalInfo() : void
      {
         if(!facade.hasMediator("RivalInfoMedia"))
         {
            facade.registerMediator(new RivalInfoMedia(new RivalInfoUI()));
         }
         var _loc1_:RivalInfoUI = (facade.retrieveMediator("RivalInfoMedia") as RivalInfoMedia).UI as RivalInfoUI;
         _loc1_.name = "RivalInfoMedia";
         rootClass.addChild(_loc1_);
      }
      
      private function loadFormation() : void
      {
         if(!facade.hasMediator("SelectFormationMedia"))
         {
            facade.registerMediator(new SelectFormationMedia(new SelectFormationUI()));
         }
         var _loc1_:SelectFormationUI = (facade.retrieveMediator("SelectFormationMedia") as SelectFormationMedia).UI as SelectFormationUI;
         _loc1_.name = "SelectFormationMedia";
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadFormationAfter);
         WinTweens.openWin(_loc1_.spr_allelf);
      }
      
      private function loadFormationAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadFormationAfter);
         sendNotification("SHOW_ALL_ELF");
         sendNotification("SEND_FORMATION");
      }
      
      private function loadSeriesPvp() : void
      {
         if(!facade.hasMediator("PvpRecordMedia"))
         {
            facade.registerMediator(new PvpRecordMedia(new PvpRecordUI()));
         }
         var _loc1_:PvpRecordUI = (facade.retrieveMediator("PvpRecordMedia") as PvpRecordMedia).UI as PvpRecordUI;
         _loc1_.name = "PvpRecordMedia";
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadSeriesPvpAfter);
         WinTweens.openWin(_loc1_.spr_pvpRecordBg);
      }
      
      private function loadSeriesPvpAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadSeriesPvpAfter);
         sendNotification("SHOW_SERIES_PVP");
      }
      
      private function loadChat() : void
      {
         if(!Facade.getInstance().hasMediator("ChatMedia"))
         {
            Facade.getInstance().registerMediator(new ChatMedia(new ChatUI()));
         }
         var _loc1_:ChatUI = (Facade.getInstance().retrieveMediator("ChatMedia") as ChatMedia).UI as ChatUI;
         _loc1_.name = "ChatMedia";
         WinTweens.hideCity();
         rootClass.addChild(_loc1_);
         _loc1_.openHandle();
         sendNotification("SHOW_WORLD_LIST");
         sendNotification("SHOW_UNION_CHAT");
         sendNotification("SHOW_SYSTEM_NOTICE");
      }
      
      private function loadInformation() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadInformation);
         if(!facade.hasMediator("InformationMedia"))
         {
            facade.registerMediator(new InformationMedia(new InformationUI()));
         }
         var _loc1_:InformationUI = (facade.retrieveMediator("InformationMedia") as InformationMedia).UI as InformationUI;
         _loc1_.name = "InformationMedia";
         WinTweens.hideCity();
         WorldHorn.getIntance().isNotShow = true;
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadInformationAfter);
         WinTweens.openWin(_loc1_.spr_informationBg);
      }
      
      private function loadInformationAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadInformationAfter);
         if((facade.retrieveMediator("MenuMedia") as MenuMedia).menu.infoNews.visible && !InformationMedia.isFirstOpenNews)
         {
            sendNotification("SHOW_INFORMATION_MENU",2);
         }
         else
         {
            InformationMedia.isFirstOpenNews = false;
            sendNotification("SHOW_INFORMATION_MENU");
         }
      }
      
      private function loadFriend() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadFriend);
         if(!facade.hasMediator("FriendMedia"))
         {
            facade.registerMediator(new FriendMedia(new FriendUI()));
         }
         var _loc1_:FriendUI = (facade.retrieveMediator("FriendMedia") as FriendMedia).UI as FriendUI;
         _loc1_.name = "FriendMedia";
         WinTweens.hideCity();
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadFriendAfter);
         WinTweens.openWin(_loc1_.spr_friendBg);
      }
      
      private function loadFriendAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadFriendAfter);
         sendNotification("SHOW_FRIEND_MENU",0);
      }
      
      private function loadTask() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadTask);
         if(!facade.hasMediator("TaskMedia"))
         {
            facade.registerMediator(new TaskMedia(new TaskUI()));
         }
         var _loc1_:TaskUI = (facade.retrieveMediator("TaskMedia") as TaskMedia).UI as TaskUI;
         _loc1_.name = "TaskMedia";
         currentPage = "TaskMedia";
         WinTweens.hideCity();
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadTaskAfter);
         WinTweens.openWin(_loc1_.spr_taskBg);
      }
      
      private function loadTaskAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadTaskAfter);
         (facade.retrieveProxy("TaskPro") as TaskPro).write1801();
      }
      
      private function loadDropProp() : void
      {
         if(!facade.hasMediator("GetPropMedia"))
         {
            facade.registerMediator(new GetPropMedia(new GetPropUI()));
         }
         var _loc1_:GetPropUI = (facade.retrieveMediator("GetPropMedia") as GetPropMedia).UI as GetPropUI;
         _loc1_.name = "GetPropMedia";
         rootClass.addChild(_loc1_);
         WinTweens.openWin(_loc1_.spr_getRewardBg);
      }
      
      private function loadAddFriend() : void
      {
         if(!facade.hasMediator("FriendAddMedia"))
         {
            facade.registerMediator(new FriendAddMedia(new FriendAddUI()));
         }
         var _loc1_:FriendAddUI = (facade.retrieveMediator("FriendAddMedia") as FriendAddMedia).UI as FriendAddUI;
         _loc1_.name = "FriendAddMedia";
         rootClass.addChild(_loc1_);
      }
      
      private function loadExtenMapWin() : void
      {
         if(!facade.hasMediator("ExtenMapWinMedia"))
         {
            facade.registerMediator(new ExtenAdventureWinMedia(new ExtenAdventureWinUI()));
         }
         var _loc1_:DisplayObject = (facade.retrieveMediator("ExtenMapWinMedia") as ExtenAdventureWinMedia).UI;
         _loc1_.name = "ExtenMapWinMedia";
         rootClass.addChild(_loc1_);
         WinTweens.openWin((_loc1_ as ExtenAdventureWinUI).mySpr);
         BeginnerGuide.playBeginnerGuide();
         EventCenter.dispatchEvent("SENCOND_SWITCH");
      }
      
      private function loadMainMapWin() : void
      {
         LogUtil("-------------------加载主线冒险窗口---------------------");
         if(!facade.hasMediator("MainMapWinMedia"))
         {
            facade.registerMediator(new MainAdventureWinMedia(new MainAdventureWinUI()));
         }
         var _loc1_:DisplayObject = (facade.retrieveMediator("MainMapWinMedia") as MainAdventureWinMedia).UI;
         _loc1_.name = "MainMapWinMedia";
         rootClass.addChild(_loc1_);
         WinTweens.openWin((_loc1_ as MainAdventureWinUI).mySpr);
         EventCenter.dispatchEvent("SENCOND_SWITCH");
      }
      
      private function loadServer() : void
      {
         if(!facade.hasMediator("ServerListMedia"))
         {
            facade.registerMediator(new ServerListMedia(new ServerListUI()));
         }
         var _loc1_:ServerListUI = (facade.retrieveMediator("ServerListMedia") as ServerListMedia).UI as ServerListUI;
         _loc1_.name = "ServerListMedia";
         rootClass.addChild(_loc1_);
         WinTweens.openWin(_loc1_.spr_server);
      }
      
      private function loadAmuseElfInfo() : void
      {
         if(!facade.hasMediator("AmuseElfInfoMedia"))
         {
            facade.registerMediator(new AmuseElfInfoMedia(new AmuseElfInfoUI()));
         }
         var _loc1_:AmuseElfInfoUI = (facade.retrieveMediator("AmuseElfInfoMedia") as AmuseElfInfoMedia).UI as AmuseElfInfoUI;
         _loc1_.name = "AmuseElfInfoMedia";
         WinTweens.hideCity();
         rootClass.addChild(_loc1_);
         BeginnerGuide.playBeginnerGuide();
      }
      
      private function loadAmuseScoreRecharge() : void
      {
         if(!facade.hasMediator("AmuseScoreRechargeMediator"))
         {
            facade.registerMediator(new AmuseScoreRechargeMediator(new AmuseScoreRechargeUI()));
         }
         var _loc1_:AmuseScoreRechargeUI = (facade.retrieveMediator("AmuseScoreRechargeMediator") as AmuseScoreRechargeMediator).UI as AmuseScoreRechargeUI;
         _loc1_.name = "AmuseScoreRechargeMediator";
         WinTweens.hideCity();
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadAmuseScoreRechargeAfter);
         WinTweens.openWin(_loc1_.spr_scoreRecharge);
      }
      
      private function loadAmuseScoreRechargeAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadAmuseScoreRechargeAfter);
         Starling.juggler.delayCall(function():void
         {
            sendNotification("amuse_load_complete_switch_index");
         },0.05);
      }
      
      private function loadIllustration() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadIllustration);
         if(!facade.hasMediator("IllustrationsMedia"))
         {
            facade.registerMediator(new IllustrationsMedia(new IllustrationsUI()));
         }
         var _loc1_:IllustrationsUI = (facade.retrieveMediator("IllustrationsMedia") as IllustrationsMedia).UI as IllustrationsUI;
         _loc1_.name = "IllustrationsMedia";
         WinTweens.hideCity();
         rootClass.addChild(_loc1_);
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadIllustrationAfter);
         WinTweens.openWin(_loc1_.spr_background);
      }
      
      private function loadIllustrationAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadIllustrationAfter);
         if(IllustrationsMedia.ifNew || IllustrationsPro.markStr == null)
         {
            IllustrationsMedia.ifNew = false;
            (facade.retrieveProxy("IllustrationsPro") as IllustrationsPro).write1301();
         }
         else
         {
            sendNotification("SHOW_ILLUSTRATIONS_ELF",IllustrationsPro.markStr);
         }
         if(!GetMapFactor.allElfBirthPllace)
         {
            GetMapFactor.getElfBirthplace();
         }
      }
      
      private function loadElfName() : void
      {
         if(!facade.hasMediator("SetElfNameMedia"))
         {
            facade.registerMediator(new SetElfNameMedia(new SetElfNameUI()));
         }
         var _loc1_:SetElfNameUI = (facade.retrieveMediator("SetElfNameMedia") as SetElfNameMedia).UI as SetElfNameUI;
         _loc1_.name = "SetElfNameMedia";
         rootClass.addChild(_loc1_);
         WinTweens.openWin(_loc1_.spr_setNameBg);
      }
      
      private function loadElfEvolveMc() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadElfEvolveMc);
         if(!facade.hasMediator("EvolveMcMediator"))
         {
            facade.registerMediator(new EvolveMcMediator(new EvolveMcUI()));
         }
         var _loc1_:EvolveMcUI = (facade.retrieveMediator("EvolveMcMediator") as EvolveMcMediator).UI as EvolveMcUI;
         _loc1_.name = "EvolveMcMediator";
         rootClass.addChild(_loc1_);
         sendNotification("send_elf_to_evolveMc");
      }
      
      private function loadElfDetail() : void
      {
         if(!facade.hasMediator("ElfDetailInfoMedia"))
         {
            facade.registerMediator(new ElfDetailInfoMedia(new ElfDetailInfoUI()));
         }
         var _loc1_:ElfDetailInfoUI = (facade.retrieveMediator("ElfDetailInfoMedia") as ElfDetailInfoMedia).UI as ElfDetailInfoUI;
         _loc1_.name = "ElfDetailInfoMedia";
         _loc1_.btn_makeFree.visible = ElfDetailInfoMedia.showFreeBtn;
         _loc1_.btn_setNiceName.visible = ElfDetailInfoMedia.showSetNameBtn;
         rootClass.addChild(_loc1_);
      }
      
      private function loadOtherPlayer() : void
      {
         if(!facade.hasMediator("ChatPlayerMedia"))
         {
            facade.registerMediator(new ChatPlayerMedia(new ChatPlayerUI()));
         }
         var _loc1_:ChatPlayerUI = (facade.retrieveMediator("ChatPlayerMedia") as ChatPlayerMedia).UI as ChatPlayerUI;
         _loc1_.name = "ChatPlayerMedia";
         rootClass.addChild(_loc1_);
         WinTweens.openWin(_loc1_.spr_playerBg);
      }
      
      private function loadBuySure() : void
      {
         if(!facade.hasMediator("BuySureMedia"))
         {
            facade.registerMediator(new BuySureMedia(new BuySureUI()));
         }
         var _loc1_:BuySureUI = (facade.retrieveMediator("BuySureMedia") as BuySureMedia).UI as BuySureUI;
         _loc1_.name = "BuySureMedia";
         rootClass.addChild(_loc1_);
         WinTweens.openWin(_loc1_.spr_sureBg);
      }
      
      private function loadSkillPanel() : void
      {
         if(!facade.hasMediator("SkillPanelMedia"))
         {
            facade.registerMediator(new SkillPanelMedia(new SkillPanelUI()));
         }
         var _loc1_:SkillPanelUI = (facade.retrieveMediator("SkillPanelMedia") as SkillPanelMedia).UI as SkillPanelUI;
         _loc1_.name = "SkillPanelMedia";
         _loc1_.propmt();
         rootClass.addChild(_loc1_);
      }
      
      private function loadPlayElf() : void
      {
         if(!facade.hasMediator("PlayElfMedia"))
         {
            facade.registerMediator(new PlayElfMedia(new PlayElfUI()));
         }
         var _loc1_:PlayElfUI = (facade.retrieveMediator("PlayElfMedia") as PlayElfMedia).UI as PlayElfUI;
         _loc1_.name = "PlayElfMedia";
         currentPage = "PlayElfMedia";
         rootClass.addChild(_loc1_);
         _loc1_.visible = true;
         if(rootClass.getChildIndex(rootClass.page) == rootClass.numChildren - 2)
         {
            LogUtil("playElfUI.mySpr==",_loc1_.mySpr.y);
            EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadPlayElfAfter);
            WinTweens.openWin(_loc1_.mySpr);
         }
         else
         {
            (facade.retrieveMediator("PlayElfMedia") as PlayElfMedia).addElf();
         }
         BeginnerGuide.playBeginnerGuide();
      }
      
      private function loadPlayElfAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadPlayElfAfter);
         (facade.retrieveMediator("PlayElfMedia") as PlayElfMedia).addElf();
      }
      
      private function loadPlayInfoPanel() : void
      {
         if(!facade.hasMediator("InfoPanelMediator"))
         {
            facade.registerMediator(new InfoPanelMediator(new InfoPanelUI()));
         }
         var _loc1_:InfoPanelUI = (facade.retrieveMediator("InfoPanelMediator") as InfoPanelMediator).UI as InfoPanelUI;
         _loc1_.name = "InfoPanelMediator";
         rootClass.addChild(_loc1_);
         (facade.retrieveProxy("PlayInfoPro") as PlayInfoPro).write1101();
         WinTweens.openWin(_loc1_.personalInfoSpr);
      }
      
      private function loadDiamondPanel() : void
      {
         if(!facade.hasMediator("BuyDiamondMediator"))
         {
            facade.registerMediator(new BuyDiamondMediator(new BuyDiamondUI()));
         }
         var _loc1_:BuyDiamondUI = (facade.retrieveMediator("BuyDiamondMediator") as BuyDiamondMediator).UI as BuyDiamondUI;
         _loc1_.name = "BuyDiamondMediator";
         rootClass.addChild(_loc1_);
         sendNotification("update_diamond_recharge");
         WinTweens.openWin(_loc1_.buyDiamondSpr);
      }
      
      private function loadPowerPanel() : void
      {
         if(!facade.hasMediator("buyPowerMediator"))
         {
            facade.registerMediator(new BuyPowerMediator(new BuyPowerUI()));
         }
         var _loc1_:BuyPowerUI = (facade.retrieveMediator("buyPowerMediator") as BuyPowerMediator).UI as BuyPowerUI;
         _loc1_.name = "buyPowerMediator";
         _loc1_.remainTimeTf.text = PlayerVO.vipInfoVO.remainBuyAcFr;
         _loc1_.totalTimeTf.text = PlayerVO.vipInfoVO.buyAcFr;
         _loc1_.calculatePayAndGet(BuyPowerMediator.useTimes);
         rootClass.addChild(_loc1_);
         WinTweens.openWin(_loc1_.buyPowerSpr);
      }
      
      private function loadMoneyPanel() : void
      {
         if(!facade.hasMediator("BuyMoneyMediator"))
         {
            facade.registerMediator(new BuyMoneyMediator(new BuyMoneyUI()));
         }
         var _loc1_:BuyMoneyUI = (facade.retrieveMediator("BuyMoneyMediator") as BuyMoneyMediator).UI as BuyMoneyUI;
         _loc1_.name = "BuyMoneyMediator";
         _loc1_.remainTimeTf.text = PlayerVO.vipInfoVO.remainGoldFinger;
         _loc1_.totalTimeTf.text = PlayerVO.vipInfoVO.goldFinger;
         _loc1_.calculatePayAndGet(BuyMoneyMediator.useTimes);
         rootClass.addChild(_loc1_);
         WinTweens.openWin(_loc1_.buyMoneySpr);
      }
      
      private function loadHeadPicPanel() : void
      {
         if(!facade.hasMediator("ChangeHeadMediator"))
         {
            facade.registerMediator(new ChangeHeadMediator(new ChangeHeadUI()));
         }
         var _loc1_:ChangeHeadUI = (facade.retrieveMediator("ChangeHeadMediator") as ChangeHeadMediator).UI as ChangeHeadUI;
         _loc1_.name = "ChangeHeadMediator";
         rootClass.addChild(_loc1_);
         if(_loc1_.ptNum != PlayerVO.headArr.length)
         {
            sendNotification("update_headpic_panel");
         }
      }
      
      private function loadTrainerPicPanel() : void
      {
         if(!facade.hasMediator("ChangeTrainerMediator"))
         {
            facade.registerMediator(new ChangeTrainerMediator(new ChangeTrainerUI()));
         }
         var _loc1_:ChangeTrainerUI = (facade.retrieveMediator("ChangeTrainerMediator") as ChangeTrainerMediator).UI as ChangeTrainerUI;
         _loc1_.name = "ChangeTrainerMediator";
         rootClass.addChild(_loc1_);
         WinTweens.openWin(_loc1_.changeTrainerSpr);
      }
      
      private function loadElf() : void
      {
         if(!facade.hasMediator("MyElfMedia"))
         {
            facade.registerMediator(new MyElfMedia(new MyElfUI()));
         }
         var _loc1_:MyElfUI = (facade.retrieveMediator("MyElfMedia") as MyElfMedia).UI as MyElfUI;
         _loc1_.name = "MyElfMedia";
         WinTweens.hideCity();
         rootClass.addChild(_loc1_);
         if(PlayerVO.trainElfArr.length > 0)
         {
            EventCenter.addEventListener("UPDATE_TRAINELF_OVER",updateOver);
            (facade.retrieveProxy("TrainPro") as TrainPro).write3500(2);
         }
         else
         {
            updateOver();
         }
         if(MyElfMedia.isJumpPage || EvoStoneGuideUI.parentPage != "")
         {
            if(CompChildUI.getInstance().parent)
            {
               CompChildUI.getInstance().upDdateChild1();
            }
         }
         MyElfMedia.isJumpPage = false;
      }
      
      private function updateOver() : void
      {
         LogUtil("----------------------------更新完训练位中背包的精灵------------------------------");
         EventCenter.removeEventListener("UPDATE_TRAINELF_OVER",updateOver);
         (facade.retrieveProxy("PlayInfoPro") as PlayInfoPro).write1108();
         (facade.retrieveProxy("ElfCenterPro") as ElfCenterPro).write2007("myElf");
      }
      
      private function loadBackPack() : void
      {
         var _loc3_:* = false;
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < BackPackPro.bagPropVecArr.length)
         {
            if(BackPackPro.bagPropVecArr[_loc2_].length > 0)
            {
               _loc3_ = true;
               break;
            }
            _loc2_++;
         }
         if(!_loc3_)
         {
            Tips.show("暂时还没有道具可用哦");
            return;
         }
         if(!facade.hasMediator("BackPackMedia"))
         {
            facade.registerMediator(new BackPackMedia(new BackPackUI()));
         }
         var _loc1_:BackPackUI = (facade.retrieveMediator("BackPackMedia") as BackPackMedia).UI as BackPackUI;
         _loc1_.name = "BackPackMedia";
         WinTweens.hideCity();
         rootClass.addChild(_loc1_);
         if(EvoStoneGuideUI.parentPage == "BackPackMedia")
         {
            sendNotification("SHOW_BACKPACK");
            return;
         }
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadBackPackAfter);
         WinTweens.openWin(_loc1_.mySpr);
      }
      
      private function loadBackPackAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadBackPackAfter);
         if(Config.isOpenBeginner)
         {
            sendNotification("SHOW_BACKPACK",1);
         }
         else
         {
            sendNotification("SHOW_BACKPACK");
         }
      }
   }
}
