package com.mvc.views.mediator.mainCity.chat
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.chat.SystemChatUI;
   import starling.events.Event;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.GetCommon;
   import com.mvc.models.proxy.mainCity.chat.ChatPro;
   import feathers.data.ListCollection;
   import starling.display.DisplayObject;
   
   public class SystemChatMedia extends Mediator
   {
      
      public static const NAME:String = "SystemChatMedia";
       
      public var systemChat:SystemChatUI;
      
      public function SystemChatMedia(param1:Object = null)
      {
         super("SystemChatMedia",param1);
         systemChat = param1 as SystemChatUI;
         systemChat.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if("" !== _loc2_)
         {
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SHOW_SYSTEM_NOTICE" === _loc2_)
         {
            if(GetCommon.isIOSDied())
            {
               return;
            }
            showSystem();
            scrollList();
         }
      }
      
      private function showSystem() : void
      {
         var _loc4_:* = 0;
         var _loc2_:* = null;
         var _loc5_:* = null;
         var _loc1_:Array = [];
         _loc4_ = 0;
         while(_loc4_ < ChatPro.systemChatVec.length)
         {
            _loc2_ = "<font color=\'#ff0000\' size=\'20\'>【系统公告】: </font>";
            _loc5_ = "<font color=\'#ffffff\' size=\'20\'>" + ChatPro.systemChatVec[_loc4_] + "</font>";
            _loc1_.unshift({"label":_loc2_ + _loc5_});
            _loc4_++;
         }
         var _loc3_:ListCollection = new ListCollection(_loc1_);
         systemChat.systemChatList.dataProvider = _loc3_;
      }
      
      private function scrollList() : void
      {
         if(systemChat.systemChatList.dataProvider)
         {
            systemChat.systemChatList.scrollToDisplayIndex(ChatPro.systemChatVec.length - 1);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_SYSTEM_NOTICE"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("SystemChatMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
