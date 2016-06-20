package com.mvc.views.mediator.mainCity.growthPlan
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.growthPlan.GrowthPlanUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.mvc.models.proxy.mainCity.growthPlan.GrowthPlanPro;
   import org.puremvc.as3.interfaces.INotification;
   import lzm.starling.swf.display.SwfButton;
   import starling.display.Image;
   import starling.display.DisplayObject;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import com.common.util.DisposeDisplay;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class GrowthPlanMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "GrowthPlanMediator";
      
      public static var isGet:Boolean;
      
      public static var nextGrade:int;
      
      public static var isBuy:Boolean;
       
      public var growthPlanUI:GrowthPlanUI;
      
      public function GrowthPlanMediator(param1:Object = null)
      {
         super("GrowthPlanMediator",param1);
         growthPlanUI = param1 as GrowthPlanUI;
         growthPlanUI.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = param1.target;
         if(growthPlanUI.btn_close !== _loc4_)
         {
            if(growthPlanUI.btn_buy === _loc4_)
            {
               if(PlayerVO.vipRank < 2)
               {
                  Tips.show("亲，购买需要VIP2以上哦。");
                  return;
               }
               if(PlayerVO.diamond < 1000)
               {
                  _loc2_ = Alert.show("亲，钻石不足，是否充值？","",new ListCollection([{"label":"好的"},{"label":"太客气了"}]));
                  _loc2_.addEventListener("close",isRechargeAlert_closeHandler);
               }
               else
               {
                  _loc3_ = Alert.show("花费1000钻购买成长计划？","",new ListCollection([{"label":"好的"},{"label":"太客气了"}]));
                  _loc3_.addEventListener("close",isBuyAlert_closeHandler);
               }
            }
         }
         else
         {
            growthPlanUI.planList.removeFromParent();
            WinTweens.closeWin(growthPlanUI.spr_growthPlan,removeWindow);
         }
      }
      
      private function isRechargeAlert_closeHandler(param1:Event) : void
      {
         if(param1.data.label == "好的")
         {
            sendNotification("switch_win",null,"load_diamond_panel");
         }
      }
      
      private function isBuyAlert_closeHandler(param1:Event) : void
      {
         if(param1.data.label == "好的")
         {
            (facade.retrieveProxy("GrowthPlanPro") as GrowthPlanPro).write1903();
         }
      }
      
      private function removeWindow() : void
      {
         showTipHandler();
         sendNotification("switch_win",null);
         dispose();
      }
      
      private function showTipHandler() : void
      {
         var _loc1_:* = 0;
         isGet = false;
         _loc1_ = 0;
         while(_loc1_ < growthPlanUI.getSprVec.length)
         {
            if(growthPlanUI.getSprVec[_loc1_].getChildAt(0).visible)
            {
               isGet = true;
            }
            if(growthPlanUI.getSprVec[_loc1_].getImage("notGetImg").visible)
            {
               nextGrade = 30 + _loc1_ * 5;
               break;
            }
            _loc1_++;
         }
         if(!isBuy && PlayerVO.vipRank >= 2)
         {
            isGet = true;
         }
         if(isGet)
         {
            sendNotification("SHOW_GROWTHPLAN");
         }
         else
         {
            sendNotification("HIDE_GROWTHPLAN");
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc5_:* = null;
         var _loc4_:* = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc6_:* = param1.getName();
         if("growthplan_update_list" !== _loc6_)
         {
            if("growthplan_get_foundation_success" === _loc6_)
            {
               _loc4_ = param1.getBody();
               _loc2_ = growthPlanUI.getSprVec[_loc4_].getChildAt(0) as SwfButton;
               _loc2_.visible = false;
               _loc3_ = growthPlanUI.getSprVec[_loc4_].getImage("alreadyGetImg");
               _loc3_.visible = true;
            }
         }
         else
         {
            growthPlanUI.spr_growthPlan.addChild(growthPlanUI.planList);
            _loc5_ = param1.getBody();
            if(_loc5_.isBuy)
            {
               isBuy = true;
               growthPlanUI.btn_buy.visible = false;
               growthPlanUI.img_alearyBuyImg.visible = true;
            }
            else
            {
               growthPlanUI.btn_buy.visible = true;
               growthPlanUI.img_alearyBuyImg.visible = false;
            }
            updateGetSpr(_loc5_.growFoundation);
         }
      }
      
      private function updateGetSpr(param1:Array) : void
      {
         var _loc6_:* = 0;
         var _loc2_:* = null;
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc5_:int = param1.length;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc2_ = growthPlanUI.getSprVec[_loc6_].getChildAt(0) as SwfButton;
            _loc4_ = growthPlanUI.getSprVec[_loc6_].getImage("notGetImg");
            _loc3_ = growthPlanUI.getSprVec[_loc6_].getImage("alreadyGetImg");
            if(param1[_loc6_] == 0)
            {
               _loc2_.visible = false;
               _loc4_.visible = true;
               _loc3_.visible = false;
            }
            else if(param1[_loc6_] == 1)
            {
               _loc2_.visible = true;
               _loc4_.visible = false;
               _loc3_.visible = false;
            }
            else if(param1[_loc6_] == 2)
            {
               _loc2_.visible = false;
               _loc4_.visible = false;
               _loc3_.visible = true;
            }
            _loc6_++;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["growthplan_update_list","growthplan_get_foundation_success"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         if(PVPPro.isAcceptPvpInvite)
         {
            showTipHandler();
         }
         WinTweens.showCity();
         DisposeDisplay.dispose(growthPlanUI.displayVec);
         growthPlanUI.displayVec = null;
         facade.removeMediator("GrowthPlanMediator");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.growthPlanAssets);
      }
   }
}
