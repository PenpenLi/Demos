package com.mvc.views.mediator.huntingParty
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.huntingParty.HuntBuyCountUI;
   import starling.events.Event;
   import feathers.controls.Alert;
   import com.mvc.models.vos.huntingParty.HuntPartyVO;
   import feathers.data.ListCollection;
   import com.mvc.models.proxy.huntingParty.HuntingPartyPro;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   
   public class HuntBuyCountMedia extends Mediator
   {
      
      public static const NAME:String = "HuntBuyCountMedia";
       
      public var huntBuyCount:HuntBuyCountUI;
      
      public function HuntBuyCountMedia(param1:Object = null)
      {
         super("HuntBuyCountMedia",param1);
         huntBuyCount = param1 as HuntBuyCountUI;
         huntBuyCount.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.target;
         if(huntBuyCount.btn_cancle !== _loc3_)
         {
            if(huntBuyCount.btn_use === _loc3_)
            {
               _loc2_ = Alert.show("购买10点行动次数需要" + HuntPartyVO.buyCountDia + "钻石，确定购买？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
               _loc2_.addEventListener("close",alertHander);
            }
         }
         else
         {
            dispose();
         }
      }
      
      private function alertHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            (facade.retrieveProxy("HuntingPartyPro") as HuntingPartyPro).write4111(false);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_HUNTBUYCOUNT_UI"];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SHOW_HUNTBUYCOUNT_UI" === _loc2_)
         {
            huntBuyCount.setInfo();
         }
      }
      
      private function removeHandle() : void
      {
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("HuntBuyCountMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
