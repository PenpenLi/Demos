package com.mvc.views.mediator.login
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.login.startChat.StartChatUI;
   import starling.events.Event;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   import com.common.util.dialogue.StartDialogue;
   import com.mvc.views.uis.login.startChat.SeleSexUI;
   import com.mvc.views.uis.login.startChat.SeleElfUI;
   import com.mvc.views.uis.login.startChat.SeleElfInfoUI;
   import com.common.managers.ElfFrontImageManager;
   
   public class StartChatMedia extends Mediator
   {
      
      public static const NAME:String = "StartChatMedia";
      
      public static var fightResult:int;
       
      public var startChat:StartChatUI;
      
      public function StartChatMedia(param1:Object = null)
      {
         super("StartChatMedia",param1);
         startChat = param1 as StartChatUI;
         startChat.addEventListener("triggered",clickHandler);
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
         if(StartDialogue.getInstance().parent != null)
         {
            StartDialogue.getInstance().remove();
         }
         if(SeleSexUI.getInstance().parent != null)
         {
            SeleSexUI.getInstance().remove();
         }
         if(SeleElfUI.getInstance().parent != null)
         {
            SeleElfUI.getInstance().removeAll();
         }
         if(SeleElfInfoUI.getInstance().parent != null)
         {
            SeleElfInfoUI.getInstance().clean();
            SeleElfInfoUI.getInstance().removeFromParent();
         }
         startChat.removeEvent();
         facade.removeMediator("StartChatMedia");
         UI.removeFromParent(true);
         viewComponent = null;
         ElfFrontImageManager.getInstance().dispose();
      }
   }
}
