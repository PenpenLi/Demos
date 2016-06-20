package com.mvc.views.mediator.mainCity.pvp
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.xmlVOHandler.GetElfFromSever;
   import com.mvc.views.uis.mainCity.pvp.PVPBgUI;
   import starling.events.Event;
   import com.common.themes.Tips;
   import com.massage.ane.UmengExtension;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.uis.mainCity.pvp.PVPCRoomUI;
   import com.mvc.views.uis.mainCity.pvp.PVPCheckPswUI;
   import com.mvc.views.uis.mainCity.pvp.PVPRankUI;
   import com.mvc.views.uis.mainCity.pvp.PVPRankPlayerInfoUI;
   import com.mvc.views.uis.mainCity.pvp.PVPRuleUI;
   import com.mvc.views.uis.mainCity.pvp.PVPPropUI;
   import com.mvc.views.mediator.mainCity.scoreShop.FreeSelectElfMediator;
   import com.mvc.views.uis.mainCity.scoreShop.FreeSelectElfUI;
   import com.mvc.views.mediator.mainCity.scoreShop.ScoreGoodsInfoMediator;
   import com.mvc.views.uis.mainCity.scoreShop.ScoreGoodInfoUI;
   import com.mvc.views.mediator.mainCity.scoreShop.ScoreShopMediator;
   import com.mvc.views.uis.mainCity.scoreShop.ScoreShopUI;
   import starling.display.DisplayObject;
   import com.mvc.views.uis.mainCity.pvp.PVPMatchimgUI;
   import com.common.managers.NpcImageManager;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class PVPBgMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "PVPBgMediator";
      
      private static var temBagElfVec:Vector.<ElfVO> = new Vector.<ElfVO>([]);
      
      public static var npcUserId:String;
      
      public static var npcElfVOVec:Vector.<ElfVO> = new Vector.<ElfVO>([]);
      
      public static var pvpReward:Object;
      
      public static var pvpFrom:int = 1;
      
      public static var isEnterRoom:Boolean;
       
      private var pvpBgUI:PVPBgUI;
      
      private var delay:uint;
      
      public function PVPBgMediator(param1:Object = null)
      {
         super("PVPBgMediator",param1);
         pvpBgUI = param1 as PVPBgUI;
         pvpBgUI.addEventListener("triggered",triggeredHandler);
         temGetBagElf();
      }
      
      public static function temGetBagElf() : void
      {
         var _loc1_:* = 0;
         temBagElfVec = Vector.<ElfVO>([]);
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            temBagElfVec.push(PlayerVO.bagElfVec[_loc1_]);
            _loc1_++;
         }
      }
      
      public static function recoverElfData() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            PlayerVO.bagElfVec[_loc1_] = null;
            LogUtil("temBagElfVec: " + temBagElfVec.length);
            PlayerVO.bagElfVec[_loc1_] = temBagElfVec[_loc1_];
            _loc1_++;
         }
      }
      
      public static function collectNpcElf(param1:Array) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = null;
         PVPBgMediator.npcElfVOVec = Vector.<ElfVO>([]);
         var _loc2_:* = param1;
         _loc3_ = 0;
         while(_loc3_ < 6)
         {
            if(_loc2_[_loc3_] != null)
            {
               _loc4_ = GetElfFromSever.getElfInfo(_loc2_[_loc3_]);
               _loc4_.camp = "camp_of_computer";
               PVPBgMediator.npcElfVOVec.push(_loc4_);
            }
            else
            {
               PVPBgMediator.npcElfVOVec.push(null);
            }
            _loc3_++;
         }
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.target;
         if(pvpBgUI.closeBtn !== _loc3_)
         {
            if(pvpBgUI.challengeGameBtn !== _loc3_)
            {
               if(pvpBgUI.practiceGameBtn !== _loc3_)
               {
                  if(pvpBgUI.btn_friend !== _loc3_)
                  {
                     if(pvpBgUI.btn_laba === _loc3_)
                     {
                        if(PVPChallengeMediator.isMatchComplete || PVPPracticeMediator.myStatus == 3 || PVPPracticeMediator.npcStatus == 3)
                        {
                           Tips.show("亲，当前不能点击喇叭按钮。");
                           return;
                        }
                        if(GetPropFactor.getProp(153) != null)
                        {
                           sendNotification("switch_win",null,"LOAD_HORN_INPUT");
                        }
                        else
                        {
                           if(PlayerVO.diamond < 50)
                           {
                              Tips.show("【小喇叭】不足，钻石不足，无法使用世界喇叭！");
                              return;
                           }
                           _loc2_ = Alert.show("【小喇叭】不足，是否消耗50颗钻石使用世界喇叭？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                           _loc2_.addEventListener("close",bugHorneHandler);
                        }
                     }
                  }
                  else
                  {
                     if(PVPChallengeMediator.isMatchComplete || PVPPracticeMediator.myStatus == 3 || PVPPracticeMediator.npcStatus == 3)
                     {
                        Tips.show("亲，当前不能点击好友按钮。");
                        return;
                     }
                     sendNotification("switch_win",null,"LOAD_FRIEND");
                  }
               }
               else
               {
                  if(PVPChallengeMediator.isMatchComplete)
                  {
                     Tips.show("亲，真的勇士敢于直面惨淡的人生，战斗吧！");
                     return;
                  }
                  pvpBgUI.showChallengeOrPractice(false);
                  BeginnerGuide.playBeginnerGuide();
                  UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|pvp练习赛");
               }
            }
            else
            {
               if(isEnterRoom)
               {
                  Tips.show("亲，请先退出房间。");
                  return;
               }
               pvpBgUI.showChallengeOrPractice(true);
               UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|pvp挑战赛");
            }
         }
         else
         {
            if(PVPChallengeMediator.isMatchComplete)
            {
               Tips.show("亲，真的勇士敢于直面惨淡的人生，战斗吧！");
               return;
            }
            if(isEnterRoom)
            {
               Tips.show("亲，请先退出房间。");
               return;
            }
            sendNotification("switch_page","load_maincity_page");
            recoverElfData();
            npcUserId = "";
         }
      }
      
      private function bugHorneHandler(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            clearTimeout(delay);
            delay = setTimeout(loadHorn,300);
         }
      }
      
      private function loadHorn() : void
      {
         sendNotification("switch_win",null,"LOAD_HORN_INPUT");
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("jump_pvp_game" !== _loc2_)
         {
            if("add_pvp" !== _loc2_)
            {
               if("close_friend_crroom_password_before_pvp" === _loc2_)
               {
                  if(Facade.getInstance().hasMediator("PVPCRoomMediator") && ((Facade.getInstance().retrieveMediator("PVPCRoomMediator") as PVPCRoomMediator).UI as PVPCRoomUI).parent)
                  {
                     ((Facade.getInstance().retrieveMediator("PVPCRoomMediator") as PVPCRoomMediator).UI as PVPCRoomUI).removeFromParent();
                  }
                  if(Facade.getInstance().hasMediator("PVPCheckPswMediator") && ((Facade.getInstance().retrieveMediator("PVPCheckPswMediator") as PVPCheckPswMediator).UI as PVPCheckPswUI).parent)
                  {
                     ((Facade.getInstance().retrieveMediator("PVPCheckPswMediator") as PVPCheckPswMediator).UI as PVPCheckPswUI).removeFromParent();
                  }
                  if(Facade.getInstance().hasMediator("PVPRankMediator") && ((Facade.getInstance().retrieveMediator("PVPRankMediator") as PVPRankMediator).UI as PVPRankUI).parent)
                  {
                     ((Facade.getInstance().retrieveMediator("PVPRankMediator") as PVPRankMediator).UI as PVPRankUI).removeFromParent();
                     if(PVPRankPlayerInfoUI.instance)
                     {
                        PVPRankPlayerInfoUI.getInstance().removeFromParent();
                     }
                  }
                  if(Facade.getInstance().hasMediator("PVPRuleMediator") && ((Facade.getInstance().retrieveMediator("PVPRuleMediator") as PVPRuleMediator).UI as PVPRuleUI).parent)
                  {
                     ((Facade.getInstance().retrieveMediator("PVPRuleMediator") as PVPRuleMediator).UI as PVPRuleUI).removeFromParent();
                  }
                  if(Facade.getInstance().hasMediator("PVPPropMediator") && ((Facade.getInstance().retrieveMediator("PVPPropMediator") as PVPPropMediator).UI as PVPPropUI).parent)
                  {
                     ((Facade.getInstance().retrieveMediator("PVPPropMediator") as PVPPropMediator).UI as PVPPropUI).removeFromParent();
                  }
                  if(Facade.getInstance().hasMediator("FreeSelectElfMediator") && ((Facade.getInstance().retrieveMediator("FreeSelectElfMediator") as FreeSelectElfMediator).UI as FreeSelectElfUI).parent)
                  {
                     ((Facade.getInstance().retrieveMediator("FreeSelectElfMediator") as FreeSelectElfMediator).UI as FreeSelectElfUI).removeFromParent();
                  }
                  if(Facade.getInstance().hasMediator("ScoreGoodsInfoMediator") && ((Facade.getInstance().retrieveMediator("ScoreGoodsInfoMediator") as ScoreGoodsInfoMediator).UI as ScoreGoodInfoUI).parent)
                  {
                     ((Facade.getInstance().retrieveMediator("ScoreGoodsInfoMediator") as ScoreGoodsInfoMediator).UI as ScoreGoodInfoUI).removeFromParent();
                  }
                  if(Facade.getInstance().hasMediator("ScoreShopMediator") && ((Facade.getInstance().retrieveMediator("ScoreShopMediator") as ScoreShopMediator).UI as ScoreShopUI).parent)
                  {
                     ((Facade.getInstance().retrieveMediator("ScoreShopMediator") as ScoreShopMediator).UI as ScoreShopUI).removeFromParent();
                  }
                  pvpBgUI.addChild(pvpBgUI.spr_pvpBg);
               }
            }
            else
            {
               pvpBgUI.addChild(pvpBgUI.spr_pvpBg);
            }
         }
         else
         {
            pvpBgUI.showChallengeOrPractice(param1.getBody());
            if(!param1.getBody() && !PVPPro.isAcceptPvpInvite)
            {
               (facade.retrieveProxy("PVPPro") as PVPPro).write6209();
            }
            if(PVPPro.isAcceptPvpInvite)
            {
               (facade.retrieveProxy("PVPPro") as PVPPro).inviteAddRoom(PVPPro.addRoomObject);
               PVPPro.isAcceptPvpInvite = false;
            }
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["add_pvp","jump_pvp_game","close_friend_crroom_password_before_pvp"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         if(facade.hasMediator("SelePlayElfMedia"))
         {
            sendNotification("REMOVE_SELEPLAYELF_MEDIA");
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
         if(Facade.getInstance().hasMediator("PVPPracticePreMediaor"))
         {
            (Facade.getInstance().retrieveMediator("PVPPracticePreMediaor") as PVPPracticePreMediaor).dispose();
         }
         if(Facade.getInstance().hasMediator("PVPPracticeMediator"))
         {
            (Facade.getInstance().retrieveMediator("PVPPracticeMediator") as PVPPracticeMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("PVPChallengeMediator"))
         {
            (Facade.getInstance().retrieveMediator("PVPChallengeMediator") as PVPChallengeMediator).dispose();
         }
         isEnterRoom = false;
         if(PVPMatchimgUI.instance)
         {
            PVPMatchimgUI.getInstance().disposeSelf();
         }
         if(PVPRankPlayerInfoUI.instance)
         {
            PVPRankPlayerInfoUI.getInstance().disposeSelf();
         }
         NpcImageManager.getInstance().dispose();
         facade.removeMediator("PVPBgMediator");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.pvpAssets);
      }
   }
}
