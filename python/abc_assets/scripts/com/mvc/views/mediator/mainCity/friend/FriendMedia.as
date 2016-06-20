package com.mvc.views.mediator.mainCity.friend
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.friend.FriendUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.mvc.models.vos.login.PlayerVO;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.GetCommon;
   import starling.display.DisplayObject;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class FriendMedia extends Mediator
   {
      
      public static const NAME:String = "FriendMedia";
      
      public static var isNew:Boolean;
      
      public static var isNewFriend:Boolean;
       
      public var friend:FriendUI;
      
      public function FriendMedia(param1:Object = null)
      {
         super("FriendMedia",param1);
         friend = param1 as FriendUI;
         friend.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(friend.btn_close === _loc2_)
         {
            friend.contain.removeChildren(0);
            WinTweens.closeWin(friend.spr_friendBg,remove);
         }
      }
      
      private function remove() : void
      {
         if(PlayerVO.friendRequestVec.length == 0)
         {
            isNew = false;
            sendNotification("HIDE_FRIEND_NEWS");
         }
         friend.removeFromParent();
         sendNotification("switch_win",null);
         dispose();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = param1.getName();
         if("SHOW_FRIEND_MENU" !== _loc3_)
         {
            if("SHOW_NEW_FRIEND" !== _loc3_)
            {
               if("HIDE_NEW_FRIEND" !== _loc3_)
               {
                  if("SHOW_FRIEND_REQUEST" !== _loc3_)
                  {
                     if("HIDE_FRIEND_REQUEST" === _loc3_)
                     {
                        friend.reFriendNew.visible = false;
                     }
                  }
                  else
                  {
                     if(GetCommon.isIOSDied())
                     {
                        return;
                     }
                     friend.reFriendNew.visible = true;
                  }
               }
               else
               {
                  friend.friendNew.visible = false;
               }
            }
            else
            {
               friend.friendNew.visible = true;
            }
         }
         else
         {
            _loc2_ = param1.getBody() as int;
            if(_loc2_ == 0 && PlayerVO.friendVec.length == 0)
            {
               _loc2_++;
               if(_loc2_ == 1 && PlayerVO.friendRequestVec.length == 0)
               {
                  _loc2_++;
               }
            }
            friend.currentTab = _loc2_;
            friend.tabs.selectedIndex = friend.currentTab;
            friend.switchNews(friend.currentTab);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_FRIEND_MENU","SHOW_NEW_FRIEND","HIDE_NEW_FRIEND","SHOW_FRIEND_REQUEST","HIDE_FRIEND_REQUEST"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         if(PVPPro.isAcceptPvpInvite)
         {
            if(PlayerVO.friendRequestVec.length == 0)
            {
               isNew = false;
               sendNotification("HIDE_FRIEND_NEWS");
            }
         }
         if(facade.hasMediator("FriendAddMedia"))
         {
            (facade.retrieveMediator("FriendAddMedia") as FriendAddMedia).dispose();
         }
         if(facade.hasMediator("FriendListMedia"))
         {
            (facade.retrieveMediator("FriendListMedia") as FriendListMedia).dispose();
         }
         if(facade.hasMediator("FriendRequestMedia"))
         {
            (facade.retrieveMediator("FriendRequestMedia") as FriendRequestMedia).dispose();
         }
         if(facade.hasMediator("FriendSearchMedia"))
         {
            (facade.retrieveMediator("FriendSearchMedia") as FriendSearchMedia).dispose();
         }
         WinTweens.showCity();
         facade.removeMediator("FriendMedia");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.friendAssets);
      }
   }
}
