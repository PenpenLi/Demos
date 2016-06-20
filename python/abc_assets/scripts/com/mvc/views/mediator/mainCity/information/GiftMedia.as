package com.mvc.views.mediator.mainCity.information
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.information.GiftUI;
   import starling.events.Event;
   import com.mvc.models.proxy.mainCity.information.InformationPro;
   import com.common.themes.Tips;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   
   public class GiftMedia extends Mediator
   {
      
      public static const NAME:String = "GiftMedia";
       
      public var gift:GiftUI;
      
      public function GiftMedia(param1:Object = null)
      {
         super("GiftMedia",param1);
         gift = param1 as GiftUI;
         gift.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(gift.btn_sure === _loc2_)
         {
            if(gift.giftIdInput.text != "")
            {
               (facade.retrieveProxy("InformationPro") as InformationPro).write4301(gift.giftIdInput.text);
               gift.giftIdInput.text = "";
            }
            else
            {
               Tips.show("请先填写礼包码");
            }
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SEND_GIFT" === _loc2_)
         {
            gift.giftList = param1.getBody() as Array;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SEND_GIFT"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("GiftMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
