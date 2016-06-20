package com.mvc.views.mediator.mainCity.pvp
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.pvp.PVPChallengeUI;
   import starling.display.Image;
   import flash.utils.Timer;
   import starling.events.Event;
   import com.mvc.models.proxy.fighting.FightingPro;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import com.mvc.views.uis.mainCity.pvp.PVPBgUI;
   import com.mvc.views.mediator.mainCity.scoreShop.ScoreShopMediator;
   import com.common.themes.Tips;
   import com.mvc.views.mediator.mainCity.elfSeries.SelePlayElfMedia;
   import com.mvc.views.uis.mainCity.elfSeries.SelePlayElfUI;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.managers.NpcImageManager;
   import com.common.managers.LoadOtherAssetsManager;
   import flash.events.TimerEvent;
   import lzm.util.TimeUtil;
   import flash.utils.setInterval;
   import com.mvc.views.uis.mainCity.pvp.PVPMatchimgUI;
   import flash.utils.clearInterval;
   import starling.display.DisplayObject;
   
   public class PVPChallengeMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "PVPChallengeMediator";
      
      public static var isBeginPlay:Boolean;
      
      public static var isMatchComplete:Boolean;
       
      public var pvpChallengeUI:PVPChallengeUI;
      
      private var myImg:Image;
      
      private var npcImg:Image;
      
      private var countTimes:int;
      
      private var timer:Timer;
      
      private var npcObject:Object;
      
      private var intervalId:uint;
      
      private var matchTime:int;
      
      public function PVPChallengeMediator(param1:Object = null)
      {
         super("PVPChallengeMediator",param1);
         pvpChallengeUI = param1 as PVPChallengeUI;
         pvpChallengeUI.addEventListener("triggered",triggeredHandler);
         timer = new Timer(1000);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(pvpChallengeUI.onlineMatchBtn !== _loc2_)
         {
            if(pvpChallengeUI.beginPlayBtn !== _loc2_)
            {
               if(pvpChallengeUI.rankBtn !== _loc2_)
               {
                  if(pvpChallengeUI.cashRewardsBtn !== _loc2_)
                  {
                     if(pvpChallengeUI.lineupBtn !== _loc2_)
                     {
                        if(pvpChallengeUI.bagBtn !== _loc2_)
                        {
                           if(pvpChallengeUI.matchRulesBtn === _loc2_)
                           {
                              sendNotification("switch_win",null,"load_pvp_rule");
                           }
                        }
                        else
                        {
                           if(isMatchComplete)
                           {
                              Tips.show("亲，匹配完成不能再使用背包哦。");
                              return;
                           }
                           sendNotification("switch_win",null,"load_pvp_prop");
                        }
                     }
                     else
                     {
                        if(isMatchComplete)
                        {
                           Tips.show("亲，匹配完成不能再更改阵容哦。");
                           return;
                        }
                        ((facade.retrieveMediator("PVPBgMediator") as PVPBgMediator).UI as PVPBgUI).spr_pvpBg.removeFromParent();
                        if(!facade.hasMediator("SelePlayElfMedia"))
                        {
                           facade.registerMediator(new SelePlayElfMedia(new SelePlayElfUI()));
                        }
                        sendNotification("SEND_RIVAL_DATA",null,"PVP");
                        sendNotification("switch_win",null,"LOAD_SERIES_PLAYELF");
                     }
                  }
                  else
                  {
                     ((facade.retrieveMediator("PVPBgMediator") as PVPBgMediator).UI as PVPBgUI).spr_pvpBg.removeFromParent();
                     ScoreShopMediator.nowType = "PVPBgMediator";
                     sendNotification("switch_win",pvpChallengeUI,"load_score_shop");
                  }
               }
               else
               {
                  sendNotification("switch_win",pvpChallengeUI,"load_pvp_rank");
               }
            }
            else
            {
               if(!PVPChallengeMediator.isMatchComplete)
               {
                  return;
               }
               (facade.retrieveProxy("PVPPro") as PVPPro).write6104();
            }
         }
         else
         {
            (facade.retrieveProxy("FightingPro") as FightingPro).write3100();
            (facade.retrieveProxy("PVPPro") as PVPPro).write6102();
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = false;
         var _loc4_:* = param1.getName();
         if("update_pvpChallenge_info" !== _loc4_)
         {
            if("update_pvpChallenge_npcinfo" !== _loc4_)
            {
               if("update_pvp_elfCamp" !== _loc4_)
               {
                  if("update_pvpChallenge_state" !== _loc4_)
                  {
                     if("stop_pvp_countdown" === _loc4_)
                     {
                        timer.removeEventListener("timer",countDownTf_TimerHandler);
                        timer.stop();
                     }
                  }
                  else
                  {
                     _loc2_ = param1.getBody();
                     if(_loc2_)
                     {
                        isMatchComplete = true;
                        updateState(true);
                        countTimes = 15;
                        timer.addEventListener("timer",countDownTf_TimerHandler);
                        timer.start();
                        Tips.show("亲，请在倒计时结束前点击开始对战按钮，不然会视为逃跑哦。");
                     }
                     else
                     {
                        isBeginPlay = false;
                        isMatchComplete = false;
                        updateState(false);
                        timer.removeEventListener("timer",countDownTf_TimerHandler);
                        timer.stop();
                        clearNPCData();
                        (facade.retrieveProxy("PVPPro") as PVPPro).write6106(true,1);
                     }
                  }
               }
               else
               {
                  pvpChallengeUI.showMyElfCamp(PlayerVO.bagElfVec);
               }
            }
            else
            {
               npcObject = param1.getBody();
               pvpChallengeUI.showName(pvpChallengeUI.npcNameSpr,PlayerVO.getAreaCodeByUserId(npcObject.oppPlayerInfo.userId) + "区-" + npcObject.oppPlayerInfo.userName,npcObject.oppPlayerInfo.vipRank);
               pvpChallengeUI.npcPointTf.text = npcObject.oppPlayerInfo.fightScore;
               pvpChallengeUI.npcTotalFightTf.text = npcObject.oppPlayerInfo.sumFight;
               pvpChallengeUI.npcTopRankTf.text = npcObject.oppPlayerInfo.pvpBestRanking;
               pvpChallengeUI.npcNowRankTf.text = npcObject.oppPlayerInfo.pvpNowRanking;
               if(npcObject.oppPlayerInfo.sumFight != 0)
               {
                  pvpChallengeUI.npcOddsTf.text = (npcObject.oppPlayerInfo.sumWin / npcObject.oppPlayerInfo.sumFight * 100).toFixed(2) + "%";
               }
               else
               {
                  pvpChallengeUI.npcOddsTf.text = "0%";
               }
               matchTime = npcObject.matchTimes;
               pvpChallengeUI.matchTimesTf.text = "匹配次数" + matchTime + "/10";
               PVPBgMediator.npcUserId = npcObject.oppPlayerInfo.userId;
               NpcImageManager.getInstance().getImg(["player0" + npcObject.oppPlayerInfo.trainPtId.substr(5)],addNpcImage);
            }
         }
         else
         {
            _loc3_ = param1.getBody();
            pvpChallengeUI.showName(pvpChallengeUI.myNameSpr,PlayerVO.getAreaCodeByUserId(PlayerVO.userId) + "区-" + PlayerVO.nickName,PlayerVO.vipRank);
            pvpChallengeUI.myPointTf.text = _loc3_.fightScore;
            pvpChallengeUI.myTotalFightTf.text = _loc3_.sumFight;
            pvpChallengeUI.myTopRankTf.text = _loc3_.pvpBestRanking;
            pvpChallengeUI.myNowRankTf.text = _loc3_.pvpNowRanking;
            if(_loc3_.sumFight != 0)
            {
               pvpChallengeUI.myOddsTf.text = (_loc3_.sumWin / _loc3_.sumFight * 100).toFixed(2) + "%";
            }
            else
            {
               pvpChallengeUI.myOddsTf.text = "0%";
            }
            matchTime = _loc3_.matchTimes;
            matchTime = matchTime < 0?0:matchTime;
            pvpChallengeUI.matchTimesTf.text = "匹配次数" + matchTime + "/10";
            if(myImg)
            {
               myImg.removeFromParent(true);
               myImg = null;
            }
            NpcImageManager.getInstance().getImg(["player0" + PlayerVO.trainPtId.substr(5)],addMyNpcImage);
         }
      }
      
      private function addNpcImage() : void
      {
         npcImg = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("player0" + npcObject.oppPlayerInfo.trainPtId.substr(5)));
         var _loc1_:* = 0.7;
         npcImg.scaleY = _loc1_;
         npcImg.scaleX = _loc1_;
         npcImg.x = 910;
         npcImg.y = 70;
         pvpChallengeUI.addChild(npcImg);
         showNPCElfCamp(npcObject.oppPlayerInfo.poke);
      }
      
      private function addMyNpcImage() : void
      {
         myImg = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("player0" + PlayerVO.trainPtId.substr(5)));
         var _loc1_:* = 0.7;
         myImg.scaleY = _loc1_;
         myImg.scaleX = _loc1_;
         myImg.x = 120;
         myImg.y = 70;
         pvpChallengeUI.addChild(myImg);
      }
      
      private function updateState(param1:Boolean) : void
      {
         pvpChallengeUI.onlineMatchBtn.visible = !param1;
         pvpChallengeUI.beginPlayBtn.visible = param1;
         pvpChallengeUI.countdownTf.visible = param1;
      }
      
      private function clearNPCData() : void
      {
         pvpChallengeUI.showName(pvpChallengeUI.npcNameSpr,"？？？？？？",0);
         pvpChallengeUI.npcPointTf.text = "？？？？";
         pvpChallengeUI.npcTotalFightTf.text = "？？？";
         pvpChallengeUI.npcOddsTf.text = "？？";
         pvpChallengeUI.npcTopRankTf.text = "？？？？";
         pvpChallengeUI.npcNowRankTf.text = "？？？？";
         removeNPCImgCamp();
      }
      
      private function removeNPCImgCamp() : void
      {
         if(npcImg)
         {
            npcImg.removeFromParent(true);
            npcImg = null;
         }
         if(pvpChallengeUI.npcElfCamp)
         {
            pvpChallengeUI.npcElfCamp.removeFromParent(true);
         }
      }
      
      protected function countDownTf_TimerHandler(param1:TimerEvent) : void
      {
         countTimes = countTimes - 1;
         pvpChallengeUI.countdownTf.text = TimeUtil.convertStringToDate(countTimes);
         if(countTimes <= 0)
         {
            clearNPCData();
            updateState(false);
            isMatchComplete = false;
            intervalId = setInterval(judgeFightResult,1500);
            timer.removeEventListener("timer",countDownTf_TimerHandler);
            timer.stop();
         }
      }
      
      private function judgeFightResult() : void
      {
         LogUtil("不点击“开始战斗”倒计时结束判断输赢");
         if(isBeginPlay)
         {
            isBeginPlay = false;
            (facade.retrieveProxy("PVPPro") as PVPPro).write6106(true,1);
            PVPMatchimgUI.getInstance().removeMatchimg();
         }
         else
         {
            (facade.retrieveProxy("PVPPro") as PVPPro).write6106(false,1);
         }
      }
      
      private function showNPCElfCamp(param1:Array) : void
      {
         PVPBgMediator.collectNpcElf(param1);
         pvpChallengeUI.showNPCElfCamp(PVPBgMediator.npcElfVOVec);
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["update_pvpChallenge_info","update_pvpChallenge_npcinfo","update_pvp_elfCamp","update_pvpChallenge_state","stop_pvp_countdown"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         if(myImg)
         {
            myImg.removeFromParent(true);
         }
         removeNPCImgCamp();
         isBeginPlay = false;
         isMatchComplete = false;
         timer.removeEventListener("timer",countDownTf_TimerHandler);
         timer.stop();
         timer = null;
         npcObject = null;
         facade.removeMediator("PVPChallengeMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
