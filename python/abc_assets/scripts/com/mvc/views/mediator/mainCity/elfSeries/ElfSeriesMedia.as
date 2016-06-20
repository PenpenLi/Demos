package com.mvc.views.mediator.mainCity.elfSeries
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.elfSeries.ElfSeriesUI;
   import starling.events.Event;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import com.mvc.views.uis.mainCity.elfSeries.SeriesHelpUI;
   import com.common.util.WinTweens;
   import com.mvc.models.proxy.mainCity.elfSeries.ElfSeriesPro;
   import com.mvc.views.mediator.mainCity.scoreShop.ScoreShopMediator;
   import com.mvc.views.uis.mainCity.elfSeries.RankPanleUI;
   import com.common.events.EventCenter;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.mvc.views.uis.mainCity.elfSeries.SelectFormationUI;
   import com.mvc.models.vos.mainCity.elfSeries.SeriesVO;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.mainCity.elfSeries.RivalVO;
   import com.mvc.views.uis.mainCity.elfSeries.SelePlayElfUI;
   import starling.display.DisplayObject;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import org.puremvc.as3.patterns.facade.Facade;
   
   public class ElfSeriesMedia extends Mediator
   {
      
      public static const NAME:String = "ElfSeriesMedia";
      
      public static var isNew:Boolean;
       
      public var elfSeries:ElfSeriesUI;
      
      public function ElfSeriesMedia(param1:Object = null)
      {
         super("ElfSeriesMedia",param1);
         elfSeries = param1 as ElfSeriesUI;
         elfSeries.addEventListener("triggered",clickHandler);
         SeriesVO.initFeedElfVec();
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc6_:* = param1.target;
         if(elfSeries.btn_close !== _loc6_)
         {
            if(elfSeries.btn_rule !== _loc6_)
            {
               if(elfSeries.btn_exChangeScore !== _loc6_)
               {
                  if(elfSeries.btn_pvpRecord !== _loc6_)
                  {
                     if(elfSeries.btn_rank !== _loc6_)
                     {
                        if(elfSeries.btn_change !== _loc6_)
                        {
                           if(elfSeries.btn_reStart !== _loc6_)
                           {
                              if(elfSeries.btn_formation !== _loc6_)
                              {
                                 if(elfSeries.btn_buyCount === _loc6_)
                                 {
                                    _loc2_ = Alert.show("你是否花费50钻购买5次竞技场挑战次数？剩余购买次数" + SeriesVO.remainCount + "/5","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                                    _loc2_.addEventListener("close",buyCountSureHandler);
                                 }
                              }
                              else
                              {
                                 elfSeries.spr_mainPage.removeFromParent();
                                 if(!facade.hasMediator("SelectFormationMedia"))
                                 {
                                    facade.registerMediator(new SelectFormationMedia(new SelectFormationUI()));
                                 }
                                 sendNotification("selectformation_init_type",PlayerVO.FormationElfVec,"联盟");
                                 sendNotification("switch_win",elfSeries,"LOAD_SERIES_FORMATION");
                              }
                           }
                           else
                           {
                              _loc3_ = Alert.show("需要消耗50颗钻石! 你确定要重置吗？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                              _loc3_.addEventListener("close",leveSureHandler);
                           }
                        }
                        else
                        {
                           (facade.retrieveProxy("ElfSeriesPro") as ElfSeriesPro).write5010();
                        }
                     }
                     else
                     {
                        if(!facade.hasMediator("RankPanleMedia"))
                        {
                           facade.registerMediator(new RankPanleMedia(new RankPanleUI()));
                        }
                        _loc5_ = (facade.retrieveMediator("RankPanleMedia") as RankPanleMedia).UI as RankPanleUI;
                        elfSeries.parent.addChild(_loc5_);
                        WinTweens.openWin(_loc5_.spr_rankPanleBg);
                        if(!Config.isOpenAni)
                        {
                           (facade.retrieveProxy("ElfSeriesPro") as ElfSeriesPro).write5005();
                        }
                        EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadRankAfter);
                     }
                  }
                  else
                  {
                     (facade.retrieveProxy("ElfSeriesPro") as ElfSeriesPro).write5006();
                  }
               }
               else
               {
                  elfSeries.spr_mainPage.removeFromParent();
                  ScoreShopMediator.nowType = "ElfSeriesMedia";
                  sendNotification("switch_win",elfSeries,"load_score_shop");
               }
            }
            else
            {
               if(!facade.hasMediator("SeriesHelpMedia"))
               {
                  facade.registerMediator(new SeriesHelpMedia(new SeriesHelpUI()));
               }
               _loc4_ = (facade.retrieveMediator("SeriesHelpMedia") as SeriesHelpMedia).UI as SeriesHelpUI;
               elfSeries.parent.addChild(_loc4_);
               WinTweens.openWin(_loc4_.spr_seriesHelp);
               (facade.retrieveProxy("ElfSeriesPro") as ElfSeriesPro).write5007();
            }
         }
         else
         {
            if(GetElfFactor.seriesElfNum(PlayerVO.FormationElfVec) == 0)
            {
               return Tips.show("至少设置一只精灵作为防守");
            }
            sendNotification("switch_page","load_maincity_page");
         }
      }
      
      private function loadRankAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadRankAfter);
         (facade.retrieveProxy("ElfSeriesPro") as ElfSeriesPro).write5005();
         RankPanleMedia.openF5 = true;
      }
      
      private function buyCountSureHandler(param1:Event, param2:Object) : void
      {
         if(param2.label == "确定")
         {
            (facade.retrieveProxy("ElfSeriesPro") as ElfSeriesPro).write5012();
         }
      }
      
      private function leveSureHandler(param1:Event, param2:Object) : void
      {
         if(param2.label == "确定")
         {
            (facade.retrieveProxy("ElfSeriesPro") as ElfSeriesPro).write5004();
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.getName();
         if("SHOW_ELFSERIES" !== _loc3_)
         {
            if("SHOW_RIVAL" !== _loc3_)
            {
               if("SEND_RESTAR" !== _loc3_)
               {
                  if("RESTAR_RESULT" !== _loc3_)
                  {
                     if("SEND_FORMATION_MAIN" !== _loc3_)
                     {
                        if("ADD_ELFSERIES_MAIN" !== _loc3_)
                        {
                           if("REMOVE_ELFSERIES_MAIN" !== _loc3_)
                           {
                              if("UPDATE_SERIES_COUNT" !== _loc3_)
                              {
                                 if("CLICK_CHANLLENGE" !== _loc3_)
                                 {
                                    if("SHOW_SERIES_NEWS" !== _loc3_)
                                    {
                                       if("HIDE_SERIES_NEWS" !== _loc3_)
                                       {
                                          if("show_elfseries_after_shop" === _loc3_)
                                          {
                                             elfSeries.spr_elfSeriesBg.addChild(elfSeries.spr_mainPage);
                                          }
                                       }
                                       else
                                       {
                                          elfSeries.pvpNews.visible = false;
                                       }
                                    }
                                    else
                                    {
                                       LogUtil("有人来挑战2");
                                       elfSeries.pvpNews.visible = true;
                                    }
                                 }
                                 else
                                 {
                                    _loc2_ = param1.getBody() as RivalVO;
                                    if(SeriesVO.surplusTime > 0)
                                    {
                                       Tips.show("冷却时间未过");
                                       return;
                                    }
                                    if(SeriesVO.fightTime == 0)
                                    {
                                       Tips.show("已经没有挑战次数了");
                                       return;
                                    }
                                    sendNotification("REMOVE_ELFSERIES_MAIN");
                                    if(!facade.hasMediator("SelePlayElfMedia"))
                                    {
                                       facade.registerMediator(new SelePlayElfMedia(new SelePlayElfUI()));
                                    }
                                    sendNotification("SEND_RIVAL_DATA",_loc2_,"联盟大赛");
                                    sendNotification("switch_win",null,"LOAD_SERIES_PLAYELF");
                                 }
                              }
                              else
                              {
                                 elfSeries.updateCount();
                              }
                           }
                           else
                           {
                              elfSeries.spr_mainPage.removeFromParent();
                           }
                        }
                        else
                        {
                           elfSeries.addChild(elfSeries.spr_mainPage);
                        }
                     }
                     else
                     {
                        show();
                     }
                  }
               }
               else
               {
                  elfSeries.stopCD();
               }
            }
            else
            {
               elfSeries.showRival();
            }
         }
         else
         {
            elfSeries.showSeries();
         }
      }
      
      private function show() : void
      {
         var _loc1_:* = 0;
         updateElf();
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.FormationElfVec.length)
         {
            if(PlayerVO.FormationElfVec[_loc1_] != null)
            {
               elfSeries.formationConVec[_loc1_].myElfVo = PlayerVO.FormationElfVec[_loc1_];
               elfSeries.formationConVec[_loc1_].switchContain(true);
            }
            else
            {
               elfSeries.formationConVec[_loc1_].hideImg();
               elfSeries.formationConVec[_loc1_].switchContain(false);
            }
            _loc1_++;
         }
         elfSeries.powerNum.text = GetElfFactor.powerFormation(PlayerVO.FormationElfVec);
      }
      
      public function updateElf() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.FormationElfVec.length)
         {
            if(PlayerVO.FormationElfVec[_loc1_] != null)
            {
               _loc2_ = 0;
               while(_loc2_ < PlayerVO.bagElfVec.length)
               {
                  if(PlayerVO.bagElfVec[_loc2_] != null)
                  {
                     if(PlayerVO.FormationElfVec[_loc1_].id == PlayerVO.bagElfVec[_loc2_].id)
                     {
                        PlayerVO.FormationElfVec[_loc1_] = PlayerVO.bagElfVec[_loc2_];
                        break;
                     }
                  }
                  _loc2_++;
               }
            }
            _loc1_++;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_ELFSERIES","SEND_RESTAR","RESTAR_RESULT","UPDATE_SERIES_COUNT","SEND_FORMATION_MAIN","SHOW_RIVAL","ADD_ELFSERIES_MAIN","REMOVE_ELFSERIES_MAIN","CLICK_CHANLLENGE","SHOW_SERIES_NEWS","HIDE_SERIES_NEWS","show_elfseries_after_shop"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         if(PVPPro.isAcceptPvpInvite)
         {
            elfSeries.spr_mainPage.removeFromParent(true);
         }
         if(facade.hasMediator("SelePlayElfMedia"))
         {
            sendNotification("REMOVE_SELEPLAYELF_MEDIA");
         }
         sendNotification("HIDE_SERIES_NEWS");
         if(Facade.getInstance().hasMediator("RivalInfoMedia"))
         {
            (Facade.getInstance().retrieveMediator("RivalInfoMedia") as RivalInfoMedia).dispose();
         }
         if(Facade.getInstance().hasMediator("ScoreShopMediator"))
         {
            (Facade.getInstance().retrieveMediator("ScoreShopMediator") as ScoreShopMediator).dispose();
         }
         elfSeries.removeTime();
         ElfSeriesPro.pvpVec = Vector.<RivalVO>([]);
         ElfSeriesPro.rankVec = Vector.<RivalVO>([]);
         facade.removeMediator("ElfSeriesMedia");
         LogUtil("解除绑定 ============ ");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
