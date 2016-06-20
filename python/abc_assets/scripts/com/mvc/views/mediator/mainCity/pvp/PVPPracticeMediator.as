package com.mvc.views.mediator.mainCity.pvp
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.pvp.PVPPracticeUI;
   import starling.display.Image;
   import starling.events.Event;
   import com.common.themes.Tips;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import com.mvc.views.uis.mainCity.pvp.PVPBgUI;
   import com.mvc.views.mediator.mainCity.elfSeries.SelePlayElfMedia;
   import com.mvc.views.uis.mainCity.elfSeries.SelePlayElfUI;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.managers.NpcImageManager;
   import com.common.managers.LoadOtherAssetsManager;
   import com.mvc.models.vos.elf.ElfVO;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.uis.mainCity.pvp.PVPPracticePreUI;
   import starling.display.DisplayObject;
   
   public class PVPPracticeMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "PVPPracticeMediator";
      
      public static var pvpRoomId:String;
      
      public static var myStatus:int;
      
      public static var npcStatus:int;
       
      public var pvpPracticeUI:PVPPracticeUI;
      
      private var myImg:Image;
      
      private var npcImg:Image;
      
      private var npcName:String;
      
      public function PVPPracticeMediator(param1:Object = null)
      {
         super("PVPPracticeMediator",param1);
         pvpPracticeUI = param1 as PVPPracticeUI;
         pvpPracticeUI.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(pvpPracticeUI.beginPlayBtn !== _loc2_)
         {
            if(pvpPracticeUI.prepareBtn !== _loc2_)
            {
               if(pvpPracticeUI.cancelPrepareBtn !== _loc2_)
               {
                  if(pvpPracticeUI.backBtn !== _loc2_)
                  {
                     if(pvpPracticeUI.removeNPCBtn !== _loc2_)
                     {
                        if(pvpPracticeUI.lineupBtn !== _loc2_)
                        {
                           if(pvpPracticeUI.bagBtn !== _loc2_)
                           {
                              if(pvpPracticeUI.fightRulesBtn === _loc2_)
                              {
                                 sendNotification("switch_win",null,"load_pvp_rule");
                              }
                           }
                           else
                           {
                              if(myStatus == 3)
                              {
                                 Tips.show("亲，使用背包要先取消准备哦。");
                                 return;
                              }
                              sendNotification("switch_win",null,"load_pvp_prop");
                           }
                        }
                        else
                        {
                           if(myStatus == 3)
                           {
                              Tips.show("亲，调整阵容要先取消准备哦。");
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
                        if(npcStatus == 0)
                        {
                           Tips.show("亲，对方还没进来哦。");
                           return;
                        }
                        (facade.retrieveProxy("PVPPro") as PVPPro).write6207(2);
                     }
                  }
                  else
                  {
                     if(myStatus == 3)
                     {
                        Tips.show("亲，请先取消准备。");
                        return;
                     }
                     (facade.retrieveProxy("PVPPro") as PVPPro).write6207(1);
                  }
               }
               else
               {
                  (facade.retrieveProxy("PVPPro") as PVPPro).write6206();
               }
            }
            else
            {
               (facade.retrieveProxy("PVPPro") as PVPPro).write6205();
            }
         }
         else
         {
            if(npcStatus == 0)
            {
               Tips.show("亲，对方还没进来哦。");
               return;
            }
            if(npcStatus == 2)
            {
               Tips.show("亲，对方还没准备好哦。");
               return;
            }
            (facade.retrieveProxy("PVPPro") as PVPPro).write6208();
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("update_pvp_myInfo" !== _loc2_)
         {
            if("update_pvp_npcInfo" !== _loc2_)
            {
               if("update_pvp_elfCamp" !== _loc2_)
               {
                  if("update_pvp_my_npc_status" !== _loc2_)
                  {
                     if("remove_pvp_npc" !== _loc2_)
                     {
                        if("add_pvp_practicepre_from_room" === _loc2_)
                        {
                           showPracticePre();
                        }
                     }
                     else
                     {
                        removeNPCImgCamp();
                        updateNpcInfo(null);
                        npcStatus = 0;
                        PVPBgMediator.npcUserId = "";
                        if(param1.getBody() == "updateMyStatus")
                        {
                           updateStatusTf(myStatus,true);
                           updateBtnByMyStatus(myStatus);
                        }
                     }
                  }
                  else if(param1.getBody() == "myStatus")
                  {
                     updateStatusTf(myStatus,true);
                     updateBtnByMyStatus(myStatus);
                  }
                  else if(param1.getBody() == "npcStatus")
                  {
                     updateStatusTf(npcStatus,false);
                  }
               }
               else
               {
                  pvpPracticeUI.showMyElfCamp(PlayerVO.bagElfVec);
               }
            }
            else
            {
               removeNPCImgCamp();
               updateNpcInfo(param1.getBody());
            }
         }
         else
         {
            updateMyInfo(param1.getBody());
         }
      }
      
      private function updateNpcInfo(param1:Object) : void
      {
         if(param1 == null)
         {
            pvpPracticeUI.showName(pvpPracticeUI.npcNameSpr,"？？？？？？",0);
            pvpPracticeUI.npcPointTf.text = "？？？？";
            pvpPracticeUI.npcTotalFightTf.text = "？？？";
            pvpPracticeUI.npcOddsTf.text = "？？";
            pvpPracticeUI.npcStateTf.text = "？";
            pvpPracticeUI.npcTopRankTf.text = "？？？？";
            pvpPracticeUI.npcNowRankTf.text = "？？？？";
            return;
         }
         pvpPracticeUI.showName(pvpPracticeUI.npcNameSpr,PlayerVO.getAreaCodeByUserId(param1.userId) + "区-" + param1.userName,param1.vipRank);
         pvpPracticeUI.npcPointTf.text = param1.fightScore;
         pvpPracticeUI.npcTotalFightTf.text = param1.sumFight;
         pvpPracticeUI.npcTopRankTf.text = param1.pvpBestRanking;
         pvpPracticeUI.npcNowRankTf.text = param1.pvpNowRanking;
         if(param1.sumFight != 0)
         {
            pvpPracticeUI.npcOddsTf.text = (param1.sumWin / param1.sumFight * 100).toFixed(2) + "%";
         }
         else
         {
            pvpPracticeUI.npcOddsTf.text = "0%";
         }
         PVPBgMediator.npcUserId = param1.userId;
         npcStatus = param1.status;
         updateStatusTf(npcStatus,false);
         npcName = "player0" + param1.trainPtId.substr(5);
         NpcImageManager.getInstance().getImg([npcName],addNpcImage);
      }
      
      private function addNpcImage() : void
      {
         npcImg = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(npcName));
         var _loc1_:* = 0.7;
         npcImg.scaleY = _loc1_;
         npcImg.scaleX = _loc1_;
         npcImg.x = 910;
         npcImg.y = 70;
         pvpPracticeUI.spr_practice.addChild(npcImg);
         pvpPracticeUI.showNPCElfCamp(Vector.<ElfVO>([null,null,null,null,null,null]),true);
      }
      
      private function updateMyInfo(param1:Object) : void
      {
         pvpPracticeUI.roomNumTf.text = "房号：" + param1.roomNum;
         pvpPracticeUI.roomNameTf.text = "房名：" + param1.roomName;
         pvpPracticeUI.showName(pvpPracticeUI.myNameSpr,PlayerVO.getAreaCodeByUserId(param1.userId) + "区-" + param1.userName,PlayerVO.vipRank);
         pvpPracticeUI.myPointTf.text = param1.fightScore;
         pvpPracticeUI.myTotalFightTf.text = param1.sumFight;
         pvpPracticeUI.myTopRankTf.text = param1.pvpBestRanking;
         pvpPracticeUI.myNowRankTf.text = param1.pvpNowRanking;
         pvpRoomId = param1.roomId;
         if(param1.sumFight != 0)
         {
            pvpPracticeUI.myOddsTf.text = (param1.sumWin / param1.sumFight * 100).toFixed(2) + "%";
         }
         else
         {
            pvpPracticeUI.myOddsTf.text = "0%";
         }
         myStatus = param1.status;
         updateStatusTf(myStatus,true);
         updateBtnByMyStatus(myStatus);
         if(myImg)
         {
            myImg.removeFromParent(true);
            myImg = null;
         }
         NpcImageManager.getInstance().getImg(["player0" + PlayerVO.trainPtId.substr(5)],addMyImg);
      }
      
      private function addMyImg() : void
      {
         myImg = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("player0" + PlayerVO.trainPtId.substr(5)));
         var _loc1_:* = 0.7;
         myImg.scaleY = _loc1_;
         myImg.scaleX = _loc1_;
         myImg.x = 120;
         myImg.y = 70;
         pvpPracticeUI.spr_practice.addChild(myImg);
      }
      
      private function updateStatusTf(param1:int, param2:Boolean) : void
      {
         if(param2)
         {
            if(param1 == 1)
            {
               pvpPracticeUI.myStateTf.text = "状态：房主";
            }
            if(param1 == 2)
            {
               pvpPracticeUI.myStateTf.text = "状态：准备中";
            }
            if(param1 == 3)
            {
               pvpPracticeUI.myStateTf.text = "状态：准备好";
            }
         }
         else
         {
            if(param1 == 1)
            {
               pvpPracticeUI.npcStateTf.text = "状态：房主";
            }
            if(param1 == 2)
            {
               pvpPracticeUI.npcStateTf.text = "状态：准备中";
            }
            if(param1 == 3)
            {
               pvpPracticeUI.npcStateTf.text = "状态：准备好";
            }
         }
      }
      
      private function updateBtnByMyStatus(param1:int) : void
      {
         switch(param1 - 1)
         {
            case 0:
               pvpPracticeUI.cancelPrepareBtn.visible = false;
               pvpPracticeUI.prepareBtn.visible = false;
               pvpPracticeUI.beginPlayBtn.visible = true;
               pvpPracticeUI.removeNPCBtn.visible = true;
               break;
            case 1:
               pvpPracticeUI.cancelPrepareBtn.visible = false;
               pvpPracticeUI.prepareBtn.visible = true;
               pvpPracticeUI.beginPlayBtn.visible = false;
               pvpPracticeUI.removeNPCBtn.visible = false;
               break;
            case 2:
               pvpPracticeUI.cancelPrepareBtn.visible = true;
               pvpPracticeUI.prepareBtn.visible = false;
               pvpPracticeUI.beginPlayBtn.visible = false;
               pvpPracticeUI.removeNPCBtn.visible = false;
               break;
         }
      }
      
      private function removeNPCImgCamp() : void
      {
         if(npcImg)
         {
            npcImg.removeFromParent(true);
            npcImg = null;
         }
         if(pvpPracticeUI.npcElfCamp)
         {
            pvpPracticeUI.npcElfCamp.removeFromParent(true);
         }
      }
      
      private function showPracticePre() : void
      {
         var _loc1_:* = null;
         pvpPracticeUI.removeFromParent();
         if(Facade.getInstance().hasMediator("PVPPracticePreMediaor"))
         {
            _loc1_ = (Facade.getInstance().retrieveMediator("PVPPracticePreMediaor") as PVPPracticePreMediaor).UI as PVPPracticePreUI;
            _loc1_.addChild(_loc1_.spr_practicePrepare);
         }
         PVPBgMediator.pvpFrom = 1;
         (facade.retrieveProxy("PVPPro") as PVPPro).write6201(PVPPro.pageIndexNow);
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["update_pvp_myInfo","update_pvp_npcInfo","update_pvp_elfCamp","add_pvp_practicepre_from_room","update_pvp_my_npc_status","remove_pvp_npc"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         npcStatus = 0;
         if(myImg)
         {
            myImg.removeFromParent(true);
            myImg = null;
         }
         removeNPCImgCamp();
         facade.removeMediator("PVPPracticeMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
