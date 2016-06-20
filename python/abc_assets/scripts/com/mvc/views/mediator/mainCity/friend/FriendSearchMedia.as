package com.mvc.views.mediator.mainCity.friend
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.friend.FriendSearchUI;
   import com.mvc.models.vos.mainCity.friend.FriendVO;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.proxy.mainCity.friend.FriendPro;
   import com.common.themes.Tips;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.DisposeDisplay;
   import lzm.starling.swf.display.SwfButton;
   import starling.display.Sprite;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import starling.display.Image;
   import com.common.util.GetCommon;
   import com.common.util.SomeFontHandler;
   import feathers.data.ListCollection;
   
   public class FriendSearchMedia extends Mediator
   {
      
      public static const NAME:String = "FriendSearchMedia";
       
      public var friendSearch:FriendSearchUI;
      
      private var friend:FriendVO;
      
      private var displayVec:Vector.<DisplayObject>;
      
      public function FriendSearchMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("FriendSearchMedia",param1);
         friendSearch = param1 as FriendSearchUI;
         friendSearch.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(friendSearch.btn_search === _loc2_)
         {
            if(friendSearch.com_searchInput.text != "")
            {
               LogUtil(friendSearch.com_searchInput.text);
               if(friendSearch.com_searchInput.text != PlayerVO.nickName)
               {
                  (facade.retrieveProxy("FriendPro") as FriendPro).write1403(friendSearch.com_searchInput.text);
               }
               else
               {
                  Tips.show("不能搜索自己");
               }
            }
            else
            {
               Tips.show("请输入好友昵称");
            }
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SHOW_FRIENDSEARCH_LIST" === _loc2_)
         {
            friend = param1.getBody() as FriendVO;
            showFriend();
         }
      }
      
      private function showFriend() : void
      {
         var _loc7_:* = null;
         var _loc1_:Array = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         var _loc6_:SwfButton = friendSearch.getBtn("btn_addFriend");
         var _loc4_:Sprite = new Sprite();
         var _loc3_:Image = GetPlayerRelatedPicFactor.getHeadPic(friend.headPtId,0.75);
         _loc4_.addChild(_loc3_);
         if(friend.vipRank > 0)
         {
            _loc7_ = GetCommon.getVipIcon(friend.vipRank,0.75);
            _loc7_.x = _loc3_.x - 3;
            _loc7_.y = _loc3_.y - 3;
            _loc4_.addChild(_loc7_);
         }
         var _loc2_:String = SomeFontHandler.setColoeSize(friend.userName,35,8,false);
         _loc1_.push({
            "icon":_loc4_,
            "label":SomeFontHandler.setLvText(friend.lv) + "  " + _loc2_,
            "accessory":_loc6_
         });
         _loc6_.addEventListener("triggered",searchResult);
         displayVec.push(_loc4_);
         displayVec.push(_loc6_);
         var _loc5_:ListCollection = new ListCollection(_loc1_);
         friendSearch.friendList.dataProvider = _loc5_;
      }
      
      private function searchResult(param1:Event) : void
      {
         sendNotification("switch_win",friendSearch.parent.parent.parent,"LOAD_ADD_FRIEND");
         sendNotification("SEND_SEARCH_FRIEND",friend);
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_FRIENDSEARCH_LIST"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         facade.removeMediator("FriendSearchMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
