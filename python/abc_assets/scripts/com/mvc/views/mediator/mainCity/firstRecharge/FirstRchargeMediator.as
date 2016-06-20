package com.mvc.views.mediator.mainCity.firstRecharge
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.firstRecharge.FirstRechargeUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class FirstRchargeMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "FirstRchargeMediator";
       
      private var firstRechargeUI:FirstRechargeUI;
      
      public function FirstRchargeMediator(param1:Object = null)
      {
         super("FirstRchargeMediator",param1);
         firstRechargeUI = param1 as FirstRechargeUI;
         firstRechargeUI.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(firstRechargeUI.closeBtn !== _loc2_)
         {
            if(firstRechargeUI.rechargeBtn === _loc2_)
            {
               sendNotification("switch_win",null,"load_diamond_panel");
               dispose();
            }
         }
         else
         {
            WinTweens.closeWin(firstRechargeUI.firstRchargeSpr,removeWindow);
         }
      }
      
      private function removeWindow() : void
      {
         dispose();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("" !== _loc2_)
         {
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return [];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         UI.removeFromParent(true);
         viewComponent = null;
         facade.removeMediator("FirstRchargeMediator");
         LoadSwfAssetsManager.getInstance().removeAsset(Config.firstRechargeAssets);
      }
   }
}
