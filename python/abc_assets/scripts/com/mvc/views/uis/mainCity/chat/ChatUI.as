package com.mvc.views.uis.mainCity.chat
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.display.Quad;
   import starling.text.TextField;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.events.Event;
   import lzm.starling.swf.components.feathers.FeathersButton;
   import com.mvc.views.mediator.mainCity.pvp.PVPBgMediator;
   import com.common.themes.Tips;
   import com.mvc.models.vos.login.PlayerVO;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.mediator.mainCity.chat.WorldChatMedia;
   import com.massage.ane.UmengExtension;
   import com.mvc.views.mediator.mainCity.chat.PrivateChatMedia;
   import com.common.util.xmlVOHandler.GetPrivateDate;
   import com.mvc.views.mediator.mainCity.chat.RoomChatMediaotr;
   import com.mvc.views.mediator.mainCity.chat.UnionChatMedia;
   import com.mvc.views.mediator.mainCity.chat.SystemChatMedia;
   import com.mvc.views.mediator.mainCity.chat.PrivateListMedia;
   import com.mvc.views.mediator.mainCity.friend.FriendMedia;
   import com.common.util.WinTweens;
   import starling.display.Image;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class ChatUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_chatBg:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var tabs:com.mvc.views.uis.mainCity.chat.TabBarUI;
      
      private var contain:Sprite;
      
      public var bg:Quad;
      
      public var notReadW:TextField;
      
      public var notReadP:TextField;
      
      private var delay:uint;
      
      public function ChatUI()
      {
         super();
         bg = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("common"));
         var _loc2_:* = 1.515;
         bg.scaleY = _loc2_;
         bg.scaleX = _loc2_;
         bg.y = -328;
         addChild(bg);
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.8;
         addChild(_loc1_);
         init();
         addTars();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("chat");
         spr_chatBg = swf.createSprite("spr_chatBg");
         btn_close = spr_chatBg.getButton("btn_close");
         addChild(spr_chatBg);
         contain = new Sprite();
         contain.x = 5;
         contain.y = 30;
         spr_chatBg.addChild(contain);
      }
      
      private function addTars() : void
      {
         tabs = new com.mvc.views.uis.mainCity.chat.TabBarUI();
         tabs.x = 15;
         tabs.y = -90;
         spr_chatBg.addChild(tabs);
         tabs.btn_roomChat.addEventListener("triggered",tabs_changeHandler);
         tabs.btn_privateChat.addEventListener("triggered",tabs_changeHandler);
         tabs.btn_world.addEventListener("triggered",tabs_changeHandler);
         tabs.btn_union.addEventListener("triggered",tabs_changeHandler);
         tabs.btn_system.addEventListener("triggered",tabs_changeHandler);
      }
      
      private function tabs_changeHandler(param1:Event) : void
      {
         LogUtil("tabs.selectedIndex=",tabs.selectedIndex);
         if((param1.target as FeathersButton).name == 2 && !PVPBgMediator.isEnterRoom)
         {
            return Tips.show("亲，您当前不在练习赛房间哦");
         }
         if((param1.target as FeathersButton).name == 3 && PlayerVO.unionId == -1)
         {
            return Tips.show("亲，您还没有加入公会");
         }
         tabs.selectedIndex = (param1.target as FeathersButton).name;
         switchNews(tabs.selectedIndex,true);
      }
      
      public function switchNews(param1:int, param2:Boolean = false) : void
      {
         var _loc5_:* = null;
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = null;
         contain.removeChildren(0);
         switch(param1)
         {
            case 0:
               if(!Facade.getInstance().hasMediator("WorldChatMedia"))
               {
                  Facade.getInstance().registerMediator(new WorldChatMedia(new WorldChatUI()));
               }
               _loc5_ = (Facade.getInstance().retrieveMediator("WorldChatMedia") as WorldChatMedia).UI as WorldChatUI;
               contain.addChild(_loc5_);
               UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|世界聊天");
               break;
            case 1:
               if(!Facade.getInstance().hasMediator("PrivateChatMedia"))
               {
                  Facade.getInstance().registerMediator(new PrivateChatMedia(new PrivateChatUI()));
               }
               _loc4_ = (Facade.getInstance().retrieveMediator("PrivateChatMedia") as PrivateChatMedia).UI as PrivateChatUI;
               _loc4_.x = 500;
               _loc4_.bombAni();
               contain.addChild(_loc4_);
               if(GetPrivateDate.privateChatVec.length > 1)
               {
                  _loc4_.btn_left.visible = true;
                  LogUtil("islinkman=",param2);
                  if(param2)
                  {
                     LogUtil("ifClick==",param2);
                     _loc4_.recoverAni();
                     Facade.getInstance().sendNotification("OPEN_PRIVATE_LIST");
                  }
               }
               else
               {
                  if(GetPrivateDate.privateChatVec.length == 1)
                  {
                     GetPrivateDate.privateChatVec[0][0].notReadNum = 0;
                     Facade.getInstance().sendNotification("SEND_PRIVATE_DATA",GetPrivateDate.privateChatVec[0][0]);
                     Facade.getInstance().sendNotification("SHOW_PRIVATE_CHAT");
                  }
                  _loc4_.btn_left.visible = false;
               }
               UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|私聊");
               break;
            case 2:
               if(!Facade.getInstance().hasMediator("RoomChatMediaotr"))
               {
                  Facade.getInstance().registerMediator(new RoomChatMediaotr(new RoomChatUI()));
               }
               _loc3_ = (Facade.getInstance().retrieveMediator("RoomChatMediaotr") as RoomChatMediaotr).UI as RoomChatUI;
               contain.addChild(_loc3_);
               Facade.getInstance().sendNotification("show_room_chat");
               UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|房间");
               break;
            case 3:
               if(!Facade.getInstance().hasMediator("UnionChatMedia"))
               {
                  Facade.getInstance().registerMediator(new UnionChatMedia(new UnionChatUI()));
               }
               _loc6_ = (Facade.getInstance().retrieveMediator("UnionChatMedia") as UnionChatMedia).UI as UnionChatUI;
               contain.addChild(_loc6_);
               break;
            case 4:
               if(!Facade.getInstance().hasMediator("SystemChatMedia"))
               {
                  Facade.getInstance().registerMediator(new SystemChatMedia(new SystemChatUI()));
               }
               _loc7_ = (Facade.getInstance().retrieveMediator("SystemChatMedia") as SystemChatMedia).UI as SystemChatUI;
               contain.addChild(_loc7_);
               UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|公会");
               break;
         }
      }
      
      public function addPrivateChat() : void
      {
         if(!Facade.getInstance().hasMediator("PrivateListMedia"))
         {
            Facade.getInstance().registerMediator(new PrivateListMedia(new PrivateListUI()));
         }
         var _loc1_:PrivateListUI = (Facade.getInstance().retrieveMediator("PrivateListMedia") as PrivateListMedia).UI as PrivateListUI;
         contain.addChild(_loc1_);
         Facade.getInstance().sendNotification("SHOW_CHAT_LIST");
      }
      
      public function openHandle() : void
      {
         switchNews(0);
         tabs.selectedIndex = 0;
      }
      
      public function recoverAni() : void
      {
         this.removeFromParent();
         var _loc1_:Game = Config.starling.root as Game;
         if(Facade.getInstance().hasMediator("FriendMedia"))
         {
            (Facade.getInstance().retrieveMediator("FriendMedia") as FriendMedia).friend.visible = true;
         }
         else
         {
            WinTweens.showCity();
         }
      }
   }
}
