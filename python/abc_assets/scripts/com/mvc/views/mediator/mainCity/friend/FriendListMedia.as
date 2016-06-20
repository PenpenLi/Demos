package com.mvc.views.mediator.mainCity.friend
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.friend.FriendListUI;
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
   import com.mvc.models.vos.mainCity.chat.ChatVO;
   import com.common.util.xmlVOHandler.GetPrivateDate;
   import com.common.themes.Tips;
   import com.mvc.views.mediator.mainCity.pvp.PVPBgMediator;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import feathers.controls.Alert;
   import com.mvc.models.proxy.mainCity.friend.FriendPro;
   
   public class FriendListMedia extends Mediator
   {
      
      public static const NAME:String = "FriendListMedia";
       
      public var friendList:FriendListUI;
      
      private var index:int;
      
      private var displayVec:Vector.<DisplayObject>;
      
      public function FriendListMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("FriendListMedia",param1);
         friendList = param1 as FriendListUI;
         friendList.addEventListener("triggered",clickHandler);
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
         var _loc2_:* = 0;
         var _loc3_:* = param1.getName();
         if("SHOW_FRIEND_LIST" !== _loc3_)
         {
            if("SHOW_DEL_FRIEND" !== _loc3_)
            {
               if("UPDATA_FRIEND_LIST" !== _loc3_)
               {
               }
            }
            else
            {
               _loc2_ = param1.getBody() as int;
               PlayerVO.friendVec.splice(_loc2_,1);
               showFriend();
               if(friendList.friList.dataProvider)
               {
                  friendList.friList.scrollToDisplayIndex(_loc2_);
               }
            }
         }
         else
         {
            showFriend();
         }
      }
      
      private function showFriend() : void
      {
         var _loc8_:* = 0;
         var _loc10_:* = null;
         var _loc9_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc3_:* = null;
         var _loc11_:* = null;
         var _loc2_:* = null;
         var _loc1_:Array = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         _loc8_ = 0;
         while(_loc8_ < PlayerVO.friendVec.length)
         {
            _loc10_ = friendList.getBtn("btn_privateChat");
            _loc9_ = friendList.getBtn("btn_pvp");
            _loc4_ = friendList.getBtn("btn_delete");
            _loc10_.name = "私聊" + _loc8_;
            _loc9_.name = "对战" + _loc8_;
            _loc4_.name = "删除" + _loc8_;
            _loc5_ = new Sprite();
            _loc10_.x = 0;
            _loc9_.x = 100;
            _loc4_.x = 200;
            _loc5_.addChild(_loc10_);
            _loc5_.addChild(_loc9_);
            _loc5_.addChild(_loc4_);
            _loc6_ = new Sprite();
            _loc3_ = GetPlayerRelatedPicFactor.getHeadPic(PlayerVO.friendVec[_loc8_].headPtId);
            _loc6_.addChild(_loc3_);
            if(PlayerVO.friendVec[_loc8_].vipRank > 0)
            {
               _loc11_ = GetCommon.getVipIcon(PlayerVO.friendVec[_loc8_].vipRank);
               _loc11_.x = _loc3_.x - 5;
               _loc11_.y = _loc3_.y - 5;
               _loc6_.addChild(_loc11_);
            }
            _loc2_ = SomeFontHandler.setColoeSize(PlayerVO.friendVec[_loc8_].userName,35,8,false);
            _loc1_.push({
               "icon":_loc6_,
               "label":SomeFontHandler.setLvText(PlayerVO.friendVec[_loc8_].lv) + "  " + _loc2_ + "\n\n上次登录时间: " + PlayerVO.friendVec[_loc8_].lastLoginTick,
               "accessory":_loc5_
            });
            _loc10_.addEventListener("triggered",friendHandle);
            _loc9_.addEventListener("triggered",friendHandle);
            _loc4_.addEventListener("triggered",friendHandle);
            displayVec.push(_loc6_);
            displayVec.push(_loc5_);
            _loc8_++;
         }
         var _loc7_:ListCollection = new ListCollection(_loc1_);
         friendList.friList.dataProvider = _loc7_;
         if(friendList.friList.dataProvider)
         {
            friendList.friList.scrollToDisplayIndex(0);
         }
      }
      
      private function friendHandle(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc4_:* = null;
         var _loc3_:String = (param1.target as SwfButton).name.substr(0,2);
         index = (param1.target as SwfButton).name.substr(2);
         LogUtil("index=======",_loc3_,index);
         var _loc5_:* = _loc3_;
         if("私聊" !== _loc5_)
         {
            if("对战" !== _loc5_)
            {
               if("删除" === _loc5_)
               {
                  _loc4_ = Alert.show("你确定要删除【" + PlayerVO.friendVec[index].userName + "】吗？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                  _loc4_.addEventListener("close",leveSureHandler);
               }
            }
            else
            {
               if(PlayerVO.friendVec[index].lv < 35)
               {
                  Tips.show("亲，对方玩家尚未解锁pvp哦。");
                  return;
               }
               if(PlayerVO.friendVec[index].userId == PlayerVO.userId)
               {
                  Tips.show("亲，不能邀请自己哦。");
                  return;
               }
               if(!PVPBgMediator.isEnterRoom)
               {
                  Tips.show("亲，先到pvp里面创建房间吧！");
                  return;
               }
               if(PVPBgMediator.npcUserId)
               {
                  Tips.show("亲，当前不可以发送邀请哦。");
                  return;
               }
               if(PVPPro.nowInviteUserId && PVPPro.nowInviteUserId != PlayerVO.friendVec[index].userId)
               {
                  Tips.show("亲，您正在邀请一位玩家，请稍后再邀请。");
                  return;
               }
               if(PVPPro.nowInviteUserId == PlayerVO.friendVec[index].userId)
               {
                  Tips.show("亲，您已经发送过邀请了，请耐心等候。");
                  return;
               }
               (facade.retrieveProxy("PVPPro") as PVPPro).write6020(PlayerVO.friendVec[index].userId);
            }
         }
         else
         {
            _loc2_ = new ChatVO();
            _loc2_.userId = PlayerVO.friendVec[index].userId;
            _loc2_.userName = PlayerVO.friendVec[index].userName;
            _loc2_.headPtId = PlayerVO.friendVec[index].headPtId;
            _loc2_.vipRank = PlayerVO.friendVec[index].vipRank;
            sendNotification("SEND_PRIVATE_DATA",_loc2_);
            GetPrivateDate.addChatList(_loc2_);
            sendNotification("switch_win",null,"LOAD_CHAT");
            sendNotification("SHOW_CHAT_INDEX",1);
            if(GetPrivateDate.getChatVec(_loc2_.userId) != -1)
            {
               sendNotification("SHOW_PRIVATE_CHAT");
            }
         }
      }
      
      private function leveSureHandler(param1:Event, param2:Object) : void
      {
         if(param2.label == "确定")
         {
            (facade.retrieveProxy("FriendPro") as FriendPro).write1405(PlayerVO.friendVec[index].userId,index);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_FRIEND_LIST","SHOW_DEL_FRIEND","UPDATA_FRIEND_LIST"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         facade.removeMediator("FriendListMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
