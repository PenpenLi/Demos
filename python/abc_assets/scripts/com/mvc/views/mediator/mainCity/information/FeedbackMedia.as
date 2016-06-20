package com.mvc.views.mediator.mainCity.information
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.information.FeedbackUI;
   import starling.events.Event;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   
   public class FeedbackMedia extends Mediator
   {
      
      public static const NAME:String = "FeedbackMedia";
       
      public var feedback:FeedbackUI;
      
      public function FeedbackMedia(param1:Object = null)
      {
         super("FeedbackMedia",param1);
         feedback = param1 as FeedbackUI;
         feedback.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if("" !== _loc2_)
         {
         }
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
         facade.removeMediator("FeedbackMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
