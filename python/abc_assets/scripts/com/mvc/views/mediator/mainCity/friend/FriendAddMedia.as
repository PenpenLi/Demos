package com.mvc.views.mediator.mainCity.friend
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.friend.FriendAddUI;
   import starling.events.Event;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.strHandler.CheckSensitiveWord;
   import com.common.themes.Tips;
   import com.mvc.models.proxy.mainCity.friend.FriendPro;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.mainCity.friend.FriendVO;
   import starling.display.DisplayObject;
   
   public class FriendAddMedia extends Mediator
   {
      
      public static const NAME:String = "FriendAddMedia";
       
      public var friendAdd:FriendAddUI;
      
      public function FriendAddMedia(param1:Object = null)
      {
         super("FriendAddMedia",param1);
         friendAdd = param1 as FriendAddUI;
         friendAdd.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(friendAdd.btn_addClose !== _loc2_)
         {
            if(friendAdd.btn_addFri === _loc2_)
            {
               if(friendAdd.myFriendVo.userId != PlayerVO.userId)
               {
                  if(CheckSensitiveWord.checkSensitiveWord(friendAdd.inputCheck.text))
                  {
                     Tips.show("不能有敏感词哦。");
                     return;
                  }
                  if(friendAdd.inputCheck.text != "与我成为好友，一起畅游口袋妖怪的世界吧！")
                  {
                     (facade.retrieveProxy("FriendPro") as FriendPro).write1406(friendAdd.myFriendVo.userId,friendAdd.inputCheck.text);
                  }
                  else
                  {
                     (facade.retrieveProxy("FriendPro") as FriendPro).write1406(friendAdd.myFriendVo.userId);
                  }
               }
               else
               {
                  Tips.show("不能加自己为好友");
               }
               remove();
            }
         }
         else
         {
            remove();
         }
      }
      
      private function remove() : void
      {
         sendNotification("switch_win",null);
         friendAdd.removeFromParent();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SEND_SEARCH_FRIEND" === _loc2_)
         {
            friendAdd.myFriendVo = param1.getBody() as FriendVO;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SEND_SEARCH_FRIEND"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("FriendAddMedia");
         UI.dispose();
         viewComponent = null;
      }
   }
}
