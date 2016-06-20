package com.mvc.views.uis.mainCity.friend
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.TabBar;
   import lzm.starling.swf.display.SwfImage;
   import com.mvc.views.mediator.mainCity.friend.FriendMedia;
   import com.common.managers.LoadSwfAssetsManager;
   import feathers.data.ListCollection;
   import starling.events.Event;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import com.mvc.views.mediator.mainCity.friend.FriendListMedia;
   import com.mvc.views.mediator.mainCity.friend.FriendRequestMedia;
   import com.mvc.views.mediator.mainCity.friend.FriendSearchMedia;
   import starling.display.Image;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class FriendUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_friendBg:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var tabs:TabBar;
      
      public var contain:Sprite;
      
      public var currentTab:int = 0;
      
      public var friendNew:SwfImage;
      
      public var reFriendNew:SwfImage;
      
      public function FriendUI()
      {
         super();
         var _loc1_:Image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("common"));
         var _loc2_:* = 1.515;
         _loc1_.scaleY = _loc2_;
         _loc1_.scaleX = _loc2_;
         _loc1_.y = -328;
         addChild(_loc1_);
         init();
         addTars();
         addNewFriends();
         addRefriend();
      }
      
      private function addRefriend() : void
      {
         reFriendNew = swf.createImage("img_promptImg");
         reFriendNew.x = 292;
         reFriendNew.y = 95;
         spr_friendBg.addChild(reFriendNew);
         reFriendNew.visible = FriendMedia.isNew;
      }
      
      private function addNewFriends() : void
      {
         friendNew = swf.createImage("img_promptImg");
         friendNew.x = 140;
         friendNew.y = 95;
         spr_friendBg.addChild(friendNew);
         friendNew.visible = FriendMedia.isNewFriend;
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("friend");
         spr_friendBg = swf.createSprite("spr_friendBg");
         btn_close = spr_friendBg.getButton("btn_close");
         spr_friendBg.x = 1136 - spr_friendBg.width >> 1;
         spr_friendBg.y = 640 - spr_friendBg.height >> 1;
         addChild(spr_friendBg);
         contain = new Sprite();
         contain.x = 20;
         contain.y = 160;
         spr_friendBg.addChild(contain);
      }
      
      private function addTars() : void
      {
         tabs = new TabBar();
         tabs.dataProvider = new ListCollection([{"label":"好友列表"},{"label":"好友请求"},{"label":"搜索好友"}]);
         tabs.x = 20;
         tabs.y = 90;
         spr_friendBg.addChild(tabs);
         tabs.addEventListener("change",tabs_changeHandler);
      }
      
      private function tabs_changeHandler(param1:Event) : void
      {
         Facade.getInstance().sendNotification("HIDE_NEW_FRIEND");
         var _loc2_:TabBar = TabBar(param1.currentTarget);
         if(_loc2_.selectedIndex == 0 && PlayerVO.friendVec.length == 0)
         {
            Tips.show("亲，您已经帅到没好友啦");
            _loc2_.selectedIndex = currentTab;
            return;
         }
         if(_loc2_.selectedIndex == 1 && PlayerVO.friendRequestVec.length == 0)
         {
            _loc2_.selectedIndex = currentTab;
            Tips.show("亲，还没人找你做好友哦");
            return;
         }
         if(_loc2_.selectedIndex != currentTab)
         {
            switchNews(_loc2_.selectedIndex);
         }
         currentTab = _loc2_.selectedIndex;
      }
      
      public function switchNews(param1:int) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         contain.removeChildren(0);
         switch(param1)
         {
            case 0:
               if(!Facade.getInstance().hasMediator("FriendListMedia"))
               {
                  Facade.getInstance().registerMediator(new FriendListMedia(new FriendListUI()));
               }
               _loc4_ = (Facade.getInstance().retrieveMediator("FriendListMedia") as FriendListMedia).UI as FriendListUI;
               contain.addChild(_loc4_);
               Facade.getInstance().sendNotification("SHOW_FRIEND_LIST");
               break;
            case 1:
               if(!Facade.getInstance().hasMediator("FriendRequestMedia"))
               {
                  Facade.getInstance().registerMediator(new FriendRequestMedia(new FriendRequestUI()));
               }
               _loc3_ = (Facade.getInstance().retrieveMediator("FriendRequestMedia") as FriendRequestMedia).UI as FriendRequestUI;
               contain.addChild(_loc3_);
               Facade.getInstance().sendNotification("SHOW_FRIENDREQUEST_LIST");
               break;
            case 2:
               if(!Facade.getInstance().hasMediator("FriendSearchMedia"))
               {
                  Facade.getInstance().registerMediator(new FriendSearchMedia(new FriendSearchUI()));
               }
               _loc2_ = (Facade.getInstance().retrieveMediator("FriendSearchMedia") as FriendSearchMedia).UI as FriendSearchUI;
               contain.addChild(_loc2_);
               break;
         }
      }
   }
}
