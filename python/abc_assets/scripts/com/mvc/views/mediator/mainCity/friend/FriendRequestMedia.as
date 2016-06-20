package com.mvc.views.mediator.mainCity.friend
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.friend.FriendRequestUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.DisposeDisplay;
   import lzm.starling.swf.display.SwfButton;
   import starling.display.Sprite;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import starling.display.Image;
   import com.common.util.GetCommon;
   import com.common.util.SomeFontHandler;
   import feathers.data.ListCollection;
   import com.mvc.models.proxy.mainCity.friend.FriendPro;
   
   public class FriendRequestMedia extends Mediator
   {
      
      public static const NAME:String = "FriendRequestMedia";
       
      public var friendRequest:FriendRequestUI;
      
      private var index:int;
      
      private var displayVec:Vector.<DisplayObject>;
      
      public function FriendRequestMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("FriendRequestMedia",param1);
         friendRequest = param1 as FriendRequestUI;
         friendRequest.addEventListener("triggered",clickHandler);
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
         if("SHOW_FRIENDREQUEST_LIST" !== _loc2_)
         {
            if("DELETE_FRIENDREQUEST" === _loc2_)
            {
               PlayerVO.friendRequestVec.splice(index,1);
               if(PlayerVO.friendRequestVec.length == 0)
               {
                  sendNotification("HIDE_FRIEND_REQUEST");
               }
            }
         }
         else
         {
            showFriendRQ();
         }
      }
      
      private function showFriendRQ() : void
      {
         var _loc7_:* = 0;
         var _loc8_:* = null;
         var _loc9_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc3_:* = null;
         var _loc10_:* = null;
         var _loc2_:* = null;
         var _loc1_:Array = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         _loc7_ = 0;
         while(_loc7_ < PlayerVO.friendRequestVec.length)
         {
            _loc8_ = friendRequest.getBtn("btn_agree");
            _loc9_ = friendRequest.getBtn("btn_rejuse");
            _loc8_.name = "同意" + _loc7_;
            _loc9_.name = "拒绝" + _loc7_;
            _loc4_ = new Sprite();
            _loc9_.x = 100;
            _loc4_.addChild(_loc8_);
            _loc4_.addChild(_loc9_);
            _loc5_ = new Sprite();
            _loc3_ = GetPlayerRelatedPicFactor.getHeadPic(PlayerVO.friendRequestVec[_loc7_].headPtId);
            _loc5_.addChild(_loc3_);
            if(PlayerVO.friendRequestVec[_loc7_].vipRank > 0)
            {
               _loc10_ = GetCommon.getVipIcon(PlayerVO.friendRequestVec[_loc7_].vipRank);
               _loc10_.x = _loc3_.x - 5;
               _loc10_.y = _loc3_.x - 5;
               _loc5_.addChild(_loc10_);
            }
            _loc2_ = SomeFontHandler.setColoeSize(PlayerVO.friendRequestVec[_loc7_].userName,35,8,false);
            _loc1_.push({
               "icon":_loc5_,
               "label":SomeFontHandler.setLvText(PlayerVO.friendRequestVec[_loc7_].lv) + "  " + _loc2_ + "\n" + PlayerVO.friendRequestVec[_loc7_].checkMsg,
               "accessory":_loc4_
            });
            _loc8_.addEventListener("triggered",friendRequestHandle);
            _loc9_.addEventListener("triggered",friendRequestHandle);
            displayVec.push(_loc5_);
            displayVec.push(_loc4_);
            _loc7_++;
         }
         var _loc6_:ListCollection = new ListCollection(_loc1_);
         friendRequest.friendList.dataProvider = _loc6_;
         if(friendRequest.friendList.dataProvider)
         {
            friendRequest.friendList.scrollToDisplayIndex(0);
         }
      }
      
      private function friendRequestHandle(param1:Event) : void
      {
         LogUtil((param1.target as SwfButton).name);
         var _loc2_:String = (param1.target as SwfButton).name.substr(0,2);
         index = (param1.target as SwfButton).name.substr(2,1);
         var _loc3_:* = _loc2_;
         if("同意" !== _loc3_)
         {
            if("拒绝" === _loc3_)
            {
               (facade.retrieveProxy("FriendPro") as FriendPro).write1407(PlayerVO.friendRequestVec[index].userId,0);
            }
         }
         else
         {
            (facade.retrieveProxy("FriendPro") as FriendPro).write1407(PlayerVO.friendRequestVec[index].userId,1);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_FRIENDREQUEST_LIST","DELETE_FRIENDREQUEST"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         facade.removeMediator("FriendRequestMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
