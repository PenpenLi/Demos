package com.mvc.views.mediator.mainCity.chat
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.chat.ChatPlayerUI;
   import starling.events.Event;
   import com.mvc.models.vos.mainCity.friend.FriendVO;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import com.common.util.xmlVOHandler.GetPrivateDate;
   import com.common.util.WinTweens;
   import com.mvc.views.mediator.mainCity.pvp.PVPBgMediator;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.mainCity.chat.ChatVO;
   import starling.display.DisplayObject;
   
   public class ChatPlayerMedia extends Mediator
   {
      
      public static const NAME:String = "ChatPlayerMedia";
       
      public var chatPlayer:ChatPlayerUI;
      
      public function ChatPlayerMedia(param1:Object = null)
      {
         super("ChatPlayerMedia",param1);
         chatPlayer = param1 as ChatPlayerUI;
         chatPlayer.addEventListener("triggered",clickHandler);
         chatPlayer.btn_shielding.addEventListener("triggered",clickHandler);
         chatPlayer.btn_cancelShielding.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc5_:* = param1.target;
         if(chatPlayer.btn_addfri !== _loc5_)
         {
            if(chatPlayer.btn_chat !== _loc5_)
            {
               if(chatPlayer.btn_close !== _loc5_)
               {
                  if(chatPlayer.btn_pvp !== _loc5_)
                  {
                     if(chatPlayer.btn_shielding !== _loc5_)
                     {
                        if(chatPlayer.btn_cancelShielding === _loc5_)
                        {
                           if(GetPrivateDate.shieldingArr.indexOf(chatPlayer.myChatVO.userId) != -1)
                           {
                              GetPrivateDate.shieldingArr.splice(GetPrivateDate.shieldingArr.indexOf(chatPlayer.myChatVO.userId),1);
                           }
                           chatPlayer.bagElfCotain.removeChildren(0,-1,true);
                           WinTweens.closeWin(chatPlayer.spr_playerBg,remove);
                        }
                     }
                     else
                     {
                        _loc2_ = "<font size=\'30\'>亲，您确定要屏蔽【" + chatPlayer.myChatVO.userName + "】么？</font>\n<font size=\'25\' color=\'#1c6b04\'>（重启游戏会恢复正常）</font>";
                        _loc3_ = Alert.show(_loc2_,"温馨提示",new ListCollection([{"label":"确定"},{"label":"放过他吧"}]));
                        _loc3_.addEventListener("close",AlertHander);
                     }
                  }
                  else
                  {
                     if(chatPlayer.myChatVO.userId == PlayerVO.userId)
                     {
                        Tips.show("亲，不能邀请自己哦。");
                        return;
                     }
                     if(chatPlayer.myChatVO.lv < 35)
                     {
                        Tips.show("亲，对方玩家尚未解锁pvp哦。");
                        return;
                     }
                     if(!PVPBgMediator.isEnterRoom)
                     {
                        Tips.show("亲，先到pvp里面创建房间吧！");
                        return;
                     }
                     if(PVPBgMediator.npcUserId)
                     {
                        Tips.show("亲，当前不能发送邀请哦。");
                        return;
                     }
                     if(PVPPro.nowInviteUserId && PVPPro.nowInviteUserId != chatPlayer.myChatVO.userId)
                     {
                        Tips.show("亲，您正在邀请一位玩家，请稍后再邀请。");
                        return;
                     }
                     if(PVPPro.nowInviteUserId == chatPlayer.myChatVO.userId)
                     {
                        Tips.show("亲，您已经发送过邀请了，请耐心等候。");
                        return;
                     }
                     (facade.retrieveProxy("PVPPro") as PVPPro).write6020(chatPlayer.myChatVO.userId);
                  }
               }
               else
               {
                  chatPlayer.bagElfCotain.removeChildren(0,-1,true);
                  WinTweens.closeWin(chatPlayer.spr_playerBg,remove);
               }
            }
            else if(chatPlayer.myChatVO.userId == PlayerVO.userId)
            {
               Tips.show("亲，不能跟自己聊天哦");
            }
            else
            {
               chatPlayer.removeFromParent();
               GetPrivateDate.addChatList(chatPlayer.myChatVO);
               sendNotification("SEND_PRIVATE_DATA",chatPlayer.myChatVO);
               sendNotification("SHOW_CHAT_INDEX",1);
               if(GetPrivateDate.getChatVec(chatPlayer.myChatVO.userId) != -1)
               {
                  sendNotification("SHOW_PRIVATE_CHAT");
               }
            }
         }
         else
         {
            _loc4_ = new FriendVO();
            _loc4_.userName = chatPlayer.myChatVO.userName;
            _loc4_.userId = chatPlayer.myChatVO.userId;
            _loc4_.headPtId = chatPlayer.myChatVO.headPtId;
            _loc4_.lv = chatPlayer.myChatVO.lv;
            _loc4_.vipRank = chatPlayer.myChatVO.vipRank;
            sendNotification("switch_win",null,"LOAD_ADD_FRIEND");
            sendNotification("SEND_SEARCH_FRIEND",_loc4_);
         }
      }
      
      private function AlertHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            if(GetPrivateDate.shieldingArr.indexOf(chatPlayer.myChatVO.userId) == -1)
            {
               GetPrivateDate.shieldingArr.push(chatPlayer.myChatVO.userId);
            }
            sendNotification("SHIELDING_UPDATE");
            chatPlayer.bagElfCotain.removeChildren(0,-1,true);
            WinTweens.closeWin(chatPlayer.spr_playerBg,remove);
            ChatMedia.shieldingUpdate();
         }
      }
      
      private function remove() : void
      {
         sendNotification("switch_win",null);
         chatPlayer.removeFromParent();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SEND_PLAYER_CHAT" === _loc2_)
         {
            chatPlayer.myChatVO = param1.getBody() as ChatVO;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SEND_PLAYER_CHAT"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("ChatPlayerMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
