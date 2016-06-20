package com.mvc.views.mediator.mainCity.elfSeries
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.elfSeries.RivalInfoUI;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.mainCity.elfSeries.RivalVO;
   import starling.display.DisplayObject;
   
   public class RivalInfoMedia extends Mediator
   {
      
      public static const NAME:String = "RivalInfoMedia";
       
      public var rivalInfo:RivalInfoUI;
      
      public function RivalInfoMedia(param1:Object = null)
      {
         super("RivalInfoMedia",param1);
         rivalInfo = param1 as RivalInfoUI;
         rivalInfo.closeBtn.addEventListener("triggered",touchHandler);
      }
      
      private function touchHandler() : void
      {
         remove();
      }
      
      private function remove() : void
      {
         sendNotification("switch_win",null);
         rivalInfo.removeFromParent();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SEND_RIVAL_INFO" === _loc2_)
         {
            rivalInfo.myRival = param1.getBody() as RivalVO;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SEND_RIVAL_INFO"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("RivalInfoMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
