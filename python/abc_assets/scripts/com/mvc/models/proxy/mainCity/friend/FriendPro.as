package com.mvc.models.proxy.mainCity.friend
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.common.net.Client;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.vos.mainCity.friend.FriendVO;
   import com.mvc.models.proxy.mainCity.chat.ChatPro;
   import com.common.util.strHandler.StrHandle;
   import com.mvc.views.mediator.mainCity.friend.FriendMedia;
   import com.common.themes.Tips;
   import com.common.util.GetCommon;
   
   public class FriendPro extends Proxy
   {
      
      public static const NAME:String = "FriendPro";
       
      private var client:Client;
      
      public var delIndex:int = -1;
      
      public function FriendPro(param1:Object = null)
      {
         super("FriendPro",param1);
         client = Client.getInstance();
         client.addCallObj("note1401",this);
         client.addCallObj("note1403",this);
         client.addCallObj("note1405",this);
         client.addCallObj("note1406",this);
         client.addCallObj("note1407",this);
      }
      
      public function write1401(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 1401;
         _loc2_.type = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note1401(param1:Object) : void
      {
         var _loc8_:* = null;
         var _loc4_:* = 0;
         var _loc5_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc6_:* = 0;
         var _loc7_:* = null;
         LogUtil("1401=" + JSON.stringify(param1));
         if(param1.result)
         {
            if(param1.type == 0 || param1.type == 2)
            {
               _loc8_ = param1.friendList;
               PlayerVO.friendVec.length = 0;
               _loc4_ = 0;
               while(_loc4_ < _loc8_.length)
               {
                  _loc5_ = new FriendVO();
                  _loc5_.headPtId = _loc8_[_loc4_].headPtId;
                  _loc2_ = new Date();
                  _loc2_.setTime(_loc8_[_loc4_].lastLoginTick * 1000);
                  _loc5_.lastLoginTick = ChatPro.getTime(_loc2_,true);
                  _loc5_.userId = _loc8_[_loc4_].userId;
                  _loc5_.userName = _loc8_[_loc4_].userName;
                  _loc5_.lv = _loc8_[_loc4_].lv;
                  _loc5_.vipRank = _loc8_[_loc4_].vipRank;
                  PlayerVO.friendVec.push(_loc5_);
                  _loc4_++;
               }
            }
            if(param1.type == 1 || param1.type == 2)
            {
               PlayerVO.friendRequestVec = Vector.<FriendVO>([]);
               if(!param1.friendApplyList)
               {
                  return;
               }
               _loc3_ = param1.friendApplyList;
               _loc6_ = 0;
               while(_loc6_ < _loc3_.length)
               {
                  _loc7_ = new FriendVO();
                  _loc7_.headPtId = _loc3_[_loc6_].headPtId;
                  _loc7_.lastLoginTick = _loc3_[_loc6_].lastLoginTick;
                  _loc7_.userId = _loc3_[_loc6_].userId;
                  _loc7_.userName = _loc3_[_loc6_].userName;
                  _loc7_.lv = _loc3_[_loc6_].lv;
                  _loc7_.vipRank = _loc3_[_loc6_].vipRank;
                  if(_loc3_[_loc6_].msg == "null")
                  {
                     _loc7_.checkMsg = StrHandle.lineFeed("验证信息:与我成为好友，一起畅游口袋妖怪的世界吧！",20,"\n",20,false);
                  }
                  else
                  {
                     _loc7_.checkMsg = StrHandle.lineFeed("验证信息:" + _loc3_[_loc6_].msg,20,"\n");
                  }
                  PlayerVO.friendRequestVec.push(_loc7_);
                  _loc6_++;
               }
               if(PlayerVO.friendRequestVec.length > 0)
               {
                  FriendMedia.isNew = true;
               }
            }
         }
      }
      
      public function write1403(param1:String) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 1403;
         _loc2_.userName = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note1403(param1:Object) : void
      {
         var _loc2_:* = null;
         LogUtil("1403=" + JSON.stringify(param1));
         var _loc3_:* = param1.result;
         if(0 !== _loc3_)
         {
            if(1 !== _loc3_)
            {
               if(2 === _loc3_)
               {
                  Tips.show("服务器故障");
               }
            }
            else
            {
               Tips.show("搜索成功");
               _loc2_ = new FriendVO();
               LogUtil(param1.friendInfo.headPtId,param1.friendInfo.lastLoginTick,param1.friendInfo.userId,param1.friendInfo.userName);
               _loc2_.headPtId = param1.friendInfo.headPtId;
               _loc2_.lastLoginTick = param1.friendInfo.lastLoginTick;
               _loc2_.userId = param1.friendInfo.userId;
               _loc2_.userName = param1.friendInfo.userName;
               _loc2_.lv = param1.friendInfo.lv;
               _loc2_.vipRank = param1.friendInfo.vipRank;
               sendNotification("SHOW_FRIENDSEARCH_LIST",_loc2_);
            }
         }
         else
         {
            Tips.show("玩家不存在或者已下线");
         }
      }
      
      public function write1405(param1:String, param2:int) : void
      {
         delIndex = param2;
         var _loc3_:Object = {};
         _loc3_.msgId = 1405;
         _loc3_.userId = param1;
         client.sendBytes(_loc3_);
      }
      
      public function note1405(param1:Object) : void
      {
         var _loc2_:* = null;
         LogUtil("1405=" + JSON.stringify(param1),"delIndex=",delIndex);
         var _loc3_:* = param1.result;
         if(0 !== _loc3_)
         {
            if(1 !== _loc3_)
            {
               if(2 !== _loc3_)
               {
                  if(3 === _loc3_)
                  {
                     Tips.show("服务器故障");
                  }
               }
               else
               {
                  Tips.show("玩家不存在");
               }
            }
            else
            {
               _loc2_ = param1.delUserId;
               if(delIndex == -1)
               {
                  delIndex = getIndex(_loc2_);
                  LogUtil("delUseId==",delIndex);
                  Tips.show("玩家【" + PlayerVO.friendVec[delIndex].userName + "】解除了和你的好友关系");
               }
               if(facade.hasMediator("FriendMedia") && !GetCommon.isIOSDied())
               {
                  sendNotification("SHOW_DEL_FRIEND",delIndex);
               }
               else
               {
                  PlayerVO.friendVec.splice(delIndex,1);
               }
            }
         }
         else
         {
            Tips.show("失败");
         }
      }
      
      public function write1406(param1:String, param2:String = "") : void
      {
         var _loc3_:Object = {};
         _loc3_.msgId = 1406;
         LogUtil("好友id=" + param1,"msg=" + param2);
         _loc3_.userId = param1;
         if(param2 != "")
         {
            _loc3_.msg = param2;
         }
         client.sendBytes(_loc3_);
      }
      
      public function note1406(param1:Object) : void
      {
         LogUtil("1406=" + JSON.stringify(param1));
         var _loc2_:* = param1.result;
         if(1 !== _loc2_)
         {
            if(2 !== _loc2_)
            {
               if(3 !== _loc2_)
               {
                  if(4 !== _loc2_)
                  {
                     if(5 !== _loc2_)
                     {
                        if(6 !== _loc2_)
                        {
                           if(7 !== _loc2_)
                           {
                              if(8 === _loc2_)
                              {
                                 Tips.show("亲，该玩家好友已达上限，加不了的哦");
                              }
                           }
                           else
                           {
                              Tips.show("唉，不能加自己为好友哦");
                           }
                        }
                        else
                        {
                           Tips.show("亲，您们已经是好友了呢");
                        }
                     }
                     else
                     {
                        Tips.show("亲，您的好友达到上限，不能加了哦");
                     }
                  }
                  else
                  {
                     Tips.show("服务器故障");
                  }
               }
               else
               {
                  Tips.show("玩家不存在");
               }
            }
            else
            {
               Tips.show("亲，您已经发送过好友请求了");
            }
         }
         else
         {
            Tips.show("请求已发送");
            if(param1.frdUserName)
            {
               Tips.show("【" + param1.frdUserName + "】请求加你为好友");
               sendNotification("SHOW_FRIEND_REQUEST");
               sendNotification("SHOW_FRIEND_NEWS");
               write1401(1);
            }
         }
      }
      
      public function write1407(param1:String, param2:int) : void
      {
         var _loc3_:Object = {};
         _loc3_.msgId = 1407;
         _loc3_.userId = param1;
         _loc3_.type = param2;
         client.sendBytes(_loc3_);
      }
      
      public function note1407(param1:Object) : void
      {
         LogUtil("1407=" + JSON.stringify(param1));
         if(param1.type == 0)
         {
            var _loc2_:* = param1.result;
            if(1 !== _loc2_)
            {
               if(4 === _loc2_)
               {
                  Tips.show("服务器故障");
               }
            }
            else
            {
               sendNotification("DELETE_FRIENDREQUEST");
               sendNotification("SHOW_FRIENDREQUEST_LIST");
            }
         }
         else if(param1.type == 1)
         {
            _loc2_ = param1.result;
            if(1 !== _loc2_)
            {
               if(2 !== _loc2_)
               {
                  if(3 !== _loc2_)
                  {
                     if(4 === _loc2_)
                     {
                        Tips.show("服务器故障");
                     }
                  }
                  else
                  {
                     Tips.show("亲，该玩家的好友达到上限咯");
                  }
               }
               else
               {
                  Tips.show("好友达到上限");
               }
            }
            else if(param1.frdUserName)
            {
               FriendMedia.isNewFriend = true;
               write1401(0);
               sendNotification("SHOW_NEW_FRIEND");
               Tips.show("【" + param1.frdUserName + "】已成为你的好友");
               if(GetCommon.isIOSDied())
               {
                  return;
               }
               sendNotification("SHOW_FRIEND_NEWS");
               sendNotification("DELETE_FRIENDREQUEST");
               sendNotification("SHOW_FRIENDREQUEST_LIST");
            }
         }
      }
      
      private function getIndex(param1:String) : int
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < PlayerVO.friendVec.length)
         {
            if(PlayerVO.friendVec[_loc2_].userId == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return null;
      }
   }
}
