package com.mvc.views.mediator.mainCity.kingKwan
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.kingKwan.KingHelpUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   
   public class KingHelpMedia extends Mediator
   {
      
      public static const NAME:String = "KingHelpMedia";
       
      public var kingHelp:KingHelpUI;
      
      public function KingHelpMedia(param1:Object = null)
      {
         super("KingHelpMedia",param1);
         kingHelp = param1 as KingHelpUI;
         kingHelp.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(kingHelp.btn_helpClose === _loc2_)
         {
            WinTweens.closeWin(kingHelp.spr_helpSpr,remove);
         }
      }
      
      private function remove() : void
      {
         kingHelp.removeFromParent();
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
         facade.removeMediator("KingHelpMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
