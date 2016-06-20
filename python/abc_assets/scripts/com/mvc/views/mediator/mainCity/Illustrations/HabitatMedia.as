package com.mvc.views.mediator.mainCity.Illustrations
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.Illustrations.HabitatUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   
   public class HabitatMedia extends Mediator
   {
      
      public static const NAME:String = "HabitatMedia";
       
      public var habitat:HabitatUI;
      
      public function HabitatMedia(param1:Object = null)
      {
         super("HabitatMedia",param1);
         habitat = param1 as HabitatUI;
         habitat.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(habitat.btn_close === _loc2_)
         {
            WinTweens.closeWin(habitat.spr_mapBg,remove);
         }
      }
      
      private function remove() : void
      {
         habitat.removeFromParent();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SEND_HABITAT" !== _loc2_)
         {
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SEND_HABITAT"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("HabitatMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
