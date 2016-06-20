package com.mvc.views.uis.worldHorn
{
   import flash.display.Sprite;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import com.mvc.models.vos.huntingParty.HuntPartyVO;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.mediator.mainCity.scoreShop.ScoreShopMediator;
   import com.mvc.views.uis.mainCity.mining.MiningFrameUI;
   import com.mvc.models.proxy.mainCity.mining.MiningPro;
   import com.common.util.ShowForceTip;
   import com.common.util.AniEffects;
   import com.mvc.models.proxy.mainCity.specialAct.SpecialActPro;
   import com.mvc.views.uis.mainCity.pvp.PVPMatchimgUI;
   import com.mvc.models.vos.mainCity.specialAct.DiaMarkUpVO;
   import com.mvc.views.mediator.mainCity.specialAct.LimitSpecialElfMediaor;
   import com.mvc.views.uis.mainCity.specialAct.limitSpecialElf.LimitSpecialElfUI;
   import com.mvc.views.mediator.mainCity.specialAct.flashElfAct.FlashBaoLiLongMediator;
   import com.mvc.models.proxy.mainCity.auction.AuctionPro;
   import com.common.consts.ConfigConst;
   import com.mvc.models.proxy.mainCity.amuse.AmusePro;
   import com.mvc.models.proxy.mainCity.lotteryUi.LotteryPro;
   import com.mvc.views.mediator.mainCity.amuse.AmuseMedia;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.proxy.mainCity.task.TaskPro;
   
   public class WorldTime extends Sprite
   {
      
      private static var instance:com.mvc.views.uis.worldHorn.WorldTime;
      
      public static var showElfTime:int;
      
      public static var chatTime:int;
      
      public static var unionChatTime:int;
      
      public static var unionHirTime:int;
       
      private var _sevDate:int;
      
      public var _sevDay:int;
      
      public var worldTimer:Timer;
      
      private var date:Date;
      
      private var sendLunch:Boolean;
      
      private var sendDinner:Boolean;
      
      private var getLunch:Boolean;
      
      private var getDinner:Boolean;
      
      private var auctionTime:Array;
      
      private var limitSpecialRefreshTime:int;
      
      private var amusePreRefreshTime:int;
      
      private var lastHour:int;
      
      public function WorldTime()
      {
         worldTimer = new Timer(1000);
         auctionTime = [12,13,18,19,20,21];
         super();
         worldTimer.addEventListener("timer",worldTimerEvent);
         date = new Date();
      }
      
      public static function getInstance() : com.mvc.views.uis.worldHorn.WorldTime
      {
         return instance || new com.mvc.views.uis.worldHorn.WorldTime();
      }
      
      protected function worldTimerEvent(param1:TimerEvent) : void
      {
         var _loc2_:* = 0;
         _sevDate = _sevDate + 1;
         date.setTime(_sevDate * 1000);
         if(HuntPartyVO.scoreLessTime > 0)
         {
            §§dup(HuntPartyVO).scoreLessTime--;
            Facade.getInstance().sendNotification("UPDATE_HUNTSCORE_TIME");
         }
         if(HuntPartyVO.lessCountTime > 0)
         {
            §§dup(HuntPartyVO).lessCountTime--;
            Facade.getInstance().sendNotification("UPDATE_HUNTBUYCOUNT_TIME");
         }
         if(HuntPartyVO.buffObj && HuntPartyVO.buffObj.time > 0)
         {
            §§dup(HuntPartyVO.buffObj).time--;
            Facade.getInstance().sendNotification("UPDATE_HUNTBUFFTIME");
         }
         if(HuntPartyVO.catchElfObj && HuntPartyVO.catchElfObj.lessTime > 0)
         {
            §§dup(HuntPartyVO.catchElfObj).lessTime--;
            Facade.getInstance().sendNotification("UPDATE_GOALELF_CDTIME");
         }
         if(Facade.getInstance().hasMediator("AmuseMedia"))
         {
            amusePreRefreshTime = §§dup(amusePreRefreshTime + 1);
            if(amusePreRefreshTime + 1 == 30)
            {
               amusePreRefreshTime = 0;
               Facade.getInstance().sendNotification("amuse_refresh_preview");
            }
         }
         else
         {
            amusePreRefreshTime = 0;
         }
         if(ScoreShopMediator.disCountActTime > 0)
         {
            §§dup(ScoreShopMediator).disCountActTime--;
            Facade.getInstance().sendNotification("update_score_less_time");
         }
         if((Config.starling.root as Game).page is MiningFrameUI)
         {
            if(MiningPro.pageEndTime - _sevDate > 0)
            {
               Facade.getInstance().sendNotification("mining_update_defend_countdown",MiningPro.pageEndTime - _sevDate);
            }
            else
            {
               Facade.getInstance().sendNotification("mining_update_defend_countdown",-1);
            }
         }
         if(ShowForceTip.instance)
         {
            ShowForceTip.getInstance().showCD();
         }
         if(AniEffects.isGetColor)
         {
            AniEffects.randomColor = "0x" + (Math.random() * 16777215).toString(16);
         }
         if(SpecialActPro.onlineCountdown > 0)
         {
            §§dup(SpecialActPro).onlineCountdown--;
            Facade.getInstance().sendNotification("update_online_countdown");
            if(SpecialActPro.onlineCountdown <= 0)
            {
               Facade.getInstance().sendNotification("show_online_news");
            }
         }
         if(PVPMatchimgUI.instance)
         {
            if(PVPMatchimgUI.getInstance().pvpMatchCD > 0)
            {
               PVPMatchimgUI.getInstance().showCD();
            }
         }
         if(DiaMarkUpVO.lessTime > 0)
         {
            §§dup(DiaMarkUpVO).lessTime--;
            Facade.getInstance().sendNotification("update_diamondup_lesstime");
            if(DiaMarkUpVO.lessTime == 0)
            {
               SpecialActPro.isDiaOpen = false;
               Facade.getInstance().sendNotification("UPDATE_SELETE_BTN");
            }
         }
         if(LimitSpecialElfMediaor.lessTime > 0)
         {
            §§dup(LimitSpecialElfMediaor).lessTime--;
            Facade.getInstance().sendNotification("update_limitspecialelf_lesstime");
            if(Facade.getInstance().hasMediator("LimitSpecialElfMediaor") && ((Facade.getInstance().retrieveMediator("LimitSpecialElfMediaor") as LimitSpecialElfMediaor).UI as LimitSpecialElfUI).parent)
            {
               limitSpecialRefreshTime = §§dup(limitSpecialRefreshTime + 1);
               if(limitSpecialRefreshTime + 1 == 10)
               {
                  limitSpecialRefreshTime = 0;
                  (Facade.getInstance().retrieveProxy("SpecialActivePro") as SpecialActPro).write2505();
               }
            }
            else
            {
               limitSpecialRefreshTime = 0;
            }
         }
         if(FlashBaoLiLongMediator.lessTime > 0)
         {
            §§dup(FlashBaoLiLongMediator).lessTime--;
            Facade.getInstance().sendNotification("update_flashelf_lesstime");
            if(FlashBaoLiLongMediator.lessTime == 0)
            {
               SpecialActPro.isLightOpen = false;
               Facade.getInstance().sendNotification("UPDATE_SELETE_BTN");
            }
         }
         if(chatTime > 0)
         {
            chatTime = chatTime - 1;
         }
         if(unionChatTime > 0)
         {
            unionChatTime = unionChatTime - 1;
         }
         if(unionHirTime > 0)
         {
            unionHirTime = unionHirTime - 1;
         }
         if(Facade.getInstance().hasMediator("AuctionMedia"))
         {
            if(AuctionPro.auctionLessTime > 0)
            {
               §§dup(AuctionPro).auctionLessTime--;
               Facade.getInstance().sendNotification(ConfigConst.SHOW_AUCTION_UPDOWN);
            }
            if(AuctionPro.bidLessTime > 0)
            {
               §§dup(AuctionPro).bidLessTime--;
               Facade.getInstance().sendNotification(ConfigConst.SHOW_BID_UPDOWN);
            }
         }
         if(Facade.getInstance().hasMediator("MainCityMedia"))
         {
            if(!AuctionPro.isOPen && (hour == 12 || hour == 18))
            {
               AuctionPro.isOPen = true;
            }
            if(auctionTime.indexOf(hour) != -1)
            {
               Facade.getInstance().sendNotification("SHOW_UNION_NEWS");
            }
            if(auctionTime.indexOf(hour) == -1)
            {
               Facade.getInstance().sendNotification("HIDE_UNION_NEWS");
            }
         }
         if(showElfTime > 0)
         {
            showElfTime = showElfTime - 1;
         }
         if(AmusePro.discountLessTime > 0)
         {
            §§dup(AmusePro).discountLessTime--;
            Facade.getInstance().sendNotification("amuse_update_act_lesstime");
         }
         if(LotteryPro.LotteryLessTime > 0)
         {
            §§dup(LotteryPro).LotteryLessTime--;
            Facade.getInstance().sendNotification("show_lottery_residue_time");
         }
         if(AmusePro.tenDrawLessTime > 0)
         {
            §§dup(AmusePro).tenDrawLessTime--;
            Facade.getInstance().sendNotification("amuse_update_act_lesstime");
         }
         if(AmusePro.onceTimeVec.length > 0 && !Facade.getInstance().hasMediator("AmuseMedia"))
         {
            _loc2_ = 0;
            while(_loc2_ < AmusePro.onceTimeVec.length)
            {
               if(!AmuseMedia.isFreeDraw)
               {
                  if(AmusePro.onceTimeVec[_loc2_] > 0)
                  {
                     var _loc3_:* = AmusePro.onceTimeVec;
                     var _loc4_:* = _loc2_;
                     var _loc5_:* = _loc3_[_loc4_] - 1;
                     _loc3_[_loc4_] = _loc5_;
                     if(AmusePro.onceTimeVec[_loc2_] <= 0)
                     {
                        if(_loc2_ == 0 && AmusePro.recruitFreeTimes > 0 || _loc2_ == 1 || _loc2_ == 2)
                        {
                           if(Facade.getInstance().hasMediator("MainCityMedia"))
                           {
                              Facade.getInstance().sendNotification("SHOW_FREE_DRAW");
                           }
                           else
                           {
                              AmuseMedia.isFreeDraw = true;
                           }
                        }
                     }
                  }
                  else if(AmusePro.onceTimeVec[_loc2_] <= 0)
                  {
                     if(_loc2_ == 0 && AmusePro.recruitFreeTimes > 0 || _loc2_ == 1 || _loc2_ == 2)
                     {
                        if(Facade.getInstance().hasMediator("MainCityMedia"))
                        {
                           Facade.getInstance().sendNotification("SHOW_FREE_DRAW");
                        }
                        else
                        {
                           AmuseMedia.isFreeDraw = true;
                        }
                     }
                  }
                  _loc2_++;
                  continue;
               }
               break;
            }
         }
         if(PlayerVO.actionCDTime > 0)
         {
            §§dup(PlayerVO).actionCDTime--;
         }
         WorldTimeUI.getInstance().timekeeper(hourStr,minuteStr,secondStr);
         if(hour >= 4 && hour <= 11 && !sendLunch)
         {
            if(TaskPro.lunchTaskVo != null)
            {
               LogUtil("午餐发送",TaskPro.lunchTaskVo.status);
               sendLunch = true;
               getLunch = false;
               if(TaskPro.dateTaskVec.indexOf(TaskPro.dinnerTaskVo) != -1)
               {
                  TaskPro.dateTaskVec.slice(TaskPro.dateTaskVec.indexOf(TaskPro.dinnerTaskVo),1);
                  TaskPro.dinnerTaskVo = null;
               }
               TaskPro.dateTaskVec.push(TaskPro.lunchTaskVo);
               Facade.getInstance().sendNotification("UPDATE_MEALS");
            }
         }
         if(hour >= 12 && hour <= 13 && !getLunch)
         {
            if(TaskPro.lunchTaskVo)
            {
               LogUtil("午餐可以领取了");
               sendLunch = false;
               getLunch = true;
               if(TaskPro.dateTaskVec.indexOf(TaskPro.lunchTaskVo) == -1)
               {
                  TaskPro.lunchTaskVo.status = 1;
                  TaskPro.dateTaskVec.unshift(TaskPro.lunchTaskVo);
               }
               Facade.getInstance().sendNotification("SHOW_TASK_NEWS");
               Facade.getInstance().sendNotification("UPDATE_MEALS");
               Facade.getInstance().sendNotification("SHOW_REWARD_PROMPT");
            }
         }
         if(hour >= 14 && hour <= 17 && !sendDinner)
         {
            if(TaskPro.dinnerTaskVo != null)
            {
               LogUtil("晚餐发送");
               sendDinner = true;
               getDinner = false;
               if(TaskPro.dateTaskVec.indexOf(TaskPro.lunchTaskVo) != -1)
               {
                  TaskPro.dateTaskVec.slice(TaskPro.dateTaskVec.indexOf(TaskPro.lunchTaskVo),1);
                  TaskPro.lunchTaskVo = null;
               }
               TaskPro.dateTaskVec.push(TaskPro.dinnerTaskVo);
               Facade.getInstance().sendNotification("UPDATE_MEALS");
            }
         }
         if(hour >= 18 && hour <= 19 && !getDinner)
         {
            if(TaskPro.dinnerTaskVo)
            {
               LogUtil("晚餐可以领取了");
               sendDinner = false;
               getDinner = true;
               if(TaskPro.dateTaskVec.indexOf(TaskPro.dinnerTaskVo) == -1)
               {
                  TaskPro.dinnerTaskVo.status = 1;
                  TaskPro.dateTaskVec.unshift(TaskPro.dinnerTaskVo);
               }
               Facade.getInstance().sendNotification("SHOW_TASK_NEWS");
               Facade.getInstance().sendNotification("UPDATE_MEALS");
               Facade.getInstance().sendNotification("SHOW_REWARD_PROMPT");
            }
         }
         if(lastHour == 23 && hour == 0)
         {
            (Facade.getInstance().retrieveProxy("SpecialActivePro") as SpecialActPro).write3700();
         }
         lastHour = hour;
      }
      
      public function get month() : int
      {
         return date.getMonth() + 1;
      }
      
      public function get day() : int
      {
         return date.getDate();
      }
      
      public function get hour() : int
      {
         var _loc1_:int = date.hoursUTC + 8 >= 24?date.hoursUTC + 8 - 24:date.hoursUTC + 8;
         return _loc1_;
      }
      
      public function get hourStr() : String
      {
         if(hour < 10)
         {
            return "0" + hour;
         }
         return hour.toString();
      }
      
      public function get minute() : int
      {
         return date.getMinutes();
      }
      
      public function get minuteStr() : String
      {
         if(minute < 10)
         {
            return "0" + minute;
         }
         return minute.toString();
      }
      
      public function get second() : int
      {
         return date.getSeconds();
      }
      
      public function get secondStr() : String
      {
         if(second < 10)
         {
            return "0" + second;
         }
         return second.toString();
      }
      
      public function set serverTime(param1:int) : void
      {
         var _loc2_:Date = new Date();
         _sevDate = param1;
         _loc2_.setTime(_sevDate * 1000);
         _sevDay = _loc2_.getDay();
         worldTimer.start();
      }
      
      public function get serverTime() : int
      {
         return _sevDate;
      }
      
      public function initState() : void
      {
         sendDinner = false;
         sendLunch = false;
         getDinner = false;
         getLunch = false;
      }
   }
}
