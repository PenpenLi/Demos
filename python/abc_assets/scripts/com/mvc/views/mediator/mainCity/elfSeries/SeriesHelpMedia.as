package com.mvc.views.mediator.mainCity.elfSeries
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.elfSeries.SeriesHelpUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   
   public class SeriesHelpMedia extends Mediator
   {
      
      public static const NAME:String = "SeriesHelpMedia";
       
      public var seriesHelp:SeriesHelpUI;
      
      public function SeriesHelpMedia(param1:Object = null)
      {
         super("SeriesHelpMedia",param1);
         seriesHelp = param1 as SeriesHelpUI;
         seriesHelp.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(seriesHelp.btn_helpClose === _loc2_)
         {
            WinTweens.closeWin(seriesHelp.spr_seriesHelp,remove);
         }
      }
      
      private function remove() : void
      {
         seriesHelp.removeFromParent();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("CHECK_REWARD" === _loc2_)
         {
            seriesHelp.upDate();
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["CHECK_REWARD"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("SeriesHelpMedia");
         UI.dispose();
         viewComponent = null;
      }
   }
}
