package com.mvc.models.proxy.mainCity.chat
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.mvc.models.vos.mainCity.chat.ChatVO;
   import com.common.net.Client;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.xmlVOHandler.GetPrivateDate;
   import com.common.themes.Tips;
   import com.mvc.views.uis.worldHorn.WorldTime;
   import com.common.util.xmlVOHandler.GetElfFromSever;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.views.mediator.mainCity.chat.ChatMedia;
   import com.common.util.GetCommon;
   import com.mvc.views.uis.worldHorn.WorldHorn;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.massage.ane.UmengExtension;
   import starling.core.Starling;
   import com.mvc.views.uis.mainCity.pvp.PVPBgUI;
   import com.mvc.views.mediator.mainCity.pvp.PVPBgMediator;
   import com.mvc.views.mediator.mainCity.chat.PrivateChatMedia;
   import com.mvc.views.uis.mainCity.chat.PrivateChatUI;
   import com.mvc.views.mediator.mainCity.chat.PrivateListMedia;
   import com.mvc.views.uis.mainCity.chat.PrivateListUI;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.mediator.mainCity.chat.RoomChatMediaotr;
   import com.mvc.views.uis.mainCity.chat.RoomChatUI;
   import com.mvc.views.uis.mainCity.chat.ChatBtnUI;
   import com.mvc.views.uis.ShowBagElfUI;
   import com.mvc.views.uis.mainCity.chat.ChatUI;
   
   public class ChatPro extends Proxy
   {
      
      public static const NAME:String = "ChatPro";
      
      public static var worldChatVec:Vector.<ChatVO> = new Vector.<ChatVO>([]);
      
      public static var unionChatVec:Vector.<ChatVO> = new Vector.<ChatVO>([]);
      
      public static var worldHornVec:Vector.<ChatVO> = new Vector.<ChatVO>([]);
      
      public static var systemChatVec:Array = [];
       
      private var client:Client;
      
      private var _chatVo:ChatVO;
      
      private var chatState:int;
      
      public function ChatPro(param1:Object = null)
      {
         super("ChatPro",param1);
         client = Client.getInstance();
         client.addCallObj("note9000",this);
         client.addCallObj("note9001",this);
         client.addCallObj("note9002",this);
         client.addCallObj("note9003",this);
         client.addCallObj("note9004",this);
         client.addCallObj("note9005",this);
         client.addCallObj("note9006",this);
         client.addCallObj("note9007",this);
         client.addCallObj("note9011",this);
      }
      
      public static function getTime(param1:Date, param2:Boolean = false) : String
      {
         var _loc4_:String = "";
         var _loc3_:String = "";
         var _loc5_:String = "";
         if(param2)
         {
            _loc5_ = param1.getMonth() + 1 + "月" + param1.getDate() + "日  ";
         }
         if(param1.getHours() < 10)
         {
            _loc3_ = "0" + param1.getHours();
         }
         else
         {
            _loc3_ = param1.getHours();
         }
         if(param1.getMinutes() < 10)
         {
            _loc4_ = "0" + param1.getMinutes();
         }
         else
         {
            _loc4_ = param1.getMinutes();
         }
         return _loc5_ + _loc3_ + ":" + _loc4_;
      }
      
      public function note9000(param1:Object) : void
      {
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = false;
         var _loc7_:* = 0;
         var _loc8_:* = null;
         LogUtil("note9000=" + JSON.stringify(param1));
         if(param1.type == 4 && PlayerVO.unionId != param1.guildId)
         {
            return;
         }
         if(GetPrivateDate.shieldingArr.indexOf(param1.userId) != -1)
         {
            return;
         }
         var _loc4_:ChatVO = new ChatVO();
         _loc4_.belong = 2;
         _loc4_.userId = param1.userId;
         _loc4_.userName = param1.userName;
         _loc4_.vipRank = param1.vipRank;
         _loc4_.sex = param1.sex;
         if(param1.spiritInfo)
         {
            if(_loc4_.userId == PlayerVO.userId)
            {
               Tips.show("展示精灵到世界聊天成功!");
               WorldTime.showElfTime = 20;
            }
            LogUtil("object.spiritInfo=" + param1.spiritInfo);
            _loc5_ = param1.spiritInfo;
            _loc6_ = GetElfFromSever.getElfInfo(_loc5_);
            _loc6_.position = _loc5_.position;
            _loc6_.master = _loc4_.userName;
            _loc4_.msg = "展示了[" + _loc6_.name + "]";
            _loc4_.ifShow = true;
            _loc4_.elfVO = _loc6_;
         }
         else
         {
            _loc4_.msg = param1.msg;
         }
         _loc4_.headPtId = param1.headPtId;
         _loc4_.lv = param1.lv;
         _loc4_.hornRollTimes = param1.hornRollTimes;
         _loc4_.showPlace = param1.showPlace;
         var _loc9_:* = param1.type;
         if(1 !== _loc9_)
         {
            if(3 !== _loc9_)
            {
               if(4 === _loc9_)
               {
                  _loc8_ = new Date();
                  _loc8_.setTime(param1.postTime * 1000);
                  _loc4_.postTime = getTime(_loc8_);
                  _loc4_.newTime = param1.postTime;
                  setChatVo(_loc4_,param1);
                  LogUtil("显示公会发送时间",_loc4_.postTime);
                  if(unionChatVec.length > 20)
                  {
                     unionChatVec.splice(unionChatVec.length - 1,1);
                  }
                  unionChatVec.unshift(_loc4_);
                  sendNotification("SHOW_UNION_CHAT");
               }
            }
            else
            {
               if(_loc4_.userName == "系统公告")
               {
                  if(systemChatVec.length > 50)
                  {
                     systemChatVec.splice(systemChatVec.length - 1,1);
                  }
                  systemChatVec.unshift(_loc4_.msg);
                  sendNotification("SHOW_SYSTEM_NOTICE");
               }
               if(_loc4_.showPlace == 2)
               {
                  _loc3_ = true;
                  worldHornVec = Vector.<ChatVO>([]);
               }
               _loc7_ = 0;
               while(_loc7_ < param1.hornRollTimes)
               {
                  worldHornVec.push(_loc4_);
                  _loc7_++;
               }
               if(GetCommon.isIOSDied())
               {
                  return;
               }
               WorldHorn.getIntance().playText(_loc3_);
               LogUtil("worldHornVec=",worldHornVec.length);
            }
         }
         else
         {
            _loc2_ = new Date();
            _loc2_.setTime(param1.postTime * 1000);
            _loc4_.postTime = getTime(_loc2_);
            _loc4_.newTime = param1.postTime;
            setChatVo(_loc4_,param1);
            LogUtil("显示发送时间",_loc4_.postTime);
            worldChatVec.unshift(_loc4_);
            if(worldChatVec.length > 20)
            {
               worldChatVec.splice(worldChatVec.length - 1,1);
            }
            LogUtil("来自9000的消息");
            ChatMedia.getChatVec(_loc4_);
            sendNotification("SHOW_WORLD_LIST");
            sendNotification("UPDATE_MAINCITYCHAT_NEWS");
         }
      }
      
      public function note9001(param1:Object) : void
      {
         LogUtil("note9001=" + JSON.stringify(param1));
         var _loc3_:ChatVO = new ChatVO();
         _loc3_.userId = param1.id;
         _loc3_.msg = param1.msg;
         var _loc2_:Date = new Date();
         _loc2_.setTime(param1.postTime * 1000);
         _loc3_.postTime = getTime(_loc2_);
         _loc3_.newTime = param1.postTime;
         _loc3_.hornRollTimes = param1.hornRollTimes;
      }
      
      public function write9002(param1:int, param2:String) : void
      {
         LogUtil("type=" + param1,"msg=" + param2);
         var _loc3_:Object = {};
         _loc3_.msgId = 9002;
         _loc3_.type = param1;
         _loc3_.msg = param2;
         _loc3_.time = WorldTime.getInstance().serverTime;
         client.sendBytes(_loc3_);
      }
      
      public function write2009(param1:int, param2:int) : void
      {
         LogUtil("type=" + param1,"broadcastId=","spId=" + param2);
         var _loc3_:Object = {};
         _loc3_.msgId = 9002;
         _loc3_.type = param1;
         _loc3_.spId = param2;
         _loc3_.msg = "";
         _loc3_.time = WorldTime.getInstance().serverTime;
         client.sendBytes(_loc3_);
      }
      
      public function note9002(param1:Object) : void
      {
         LogUtil("note9002=" + JSON.stringify(param1));
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
                           if(0 !== _loc2_)
                           {
                              Tips.show("发送失败");
                           }
                           else
                           {
                              Tips.show("无在线人员");
                           }
                        }
                        else
                        {
                           Tips.show("亲，活跃点不够哦，请继续玩游戏获得活跃点");
                        }
                     }
                     else
                     {
                        Tips.show("15秒内不能发相同内容");
                     }
                  }
                  else
                  {
                     Tips.show("5秒内不能发多次");
                  }
               }
               else
               {
                  Tips.show("类型错误");
               }
            }
            else
            {
               Tips.show("钻石不足");
            }
         }
         else
         {
            _loc2_ = param1.type;
            if(1 !== _loc2_)
            {
               if(3 === _loc2_)
               {
                  if(GetPropFactor.getProp(153) != null)
                  {
                     GetPropFactor.addOrLessProp(GetPropFactor.getPropVO(153),false);
                  }
                  else
                  {
                     UmengExtension.getInstance().UMAnalysic("buy|153|1|50");
                     sendNotification("update_play_diamond_info",PlayerVO.diamond - 50);
                  }
               }
            }
            else if(PlayerVO.lv >= 15)
            {
               WorldTime.chatTime = 5;
            }
            else if(PlayerVO.lv < 15 && PlayerVO.lv >= 10)
            {
               WorldTime.chatTime = 30;
            }
            else if(PlayerVO.lv < 10)
            {
               WorldTime.chatTime = 50;
            }
         }
      }
      
      public function write9003(param1:ChatVO, param2:String) : void
      {
         LogUtil("对方的名字 == " + param1.userId);
         _chatVo = param1;
         var _loc3_:Object = {};
         _loc3_.msgId = 9003;
         _loc3_.userId = param1.userId;
         _loc3_.msg = param2;
         client.sendBytes(_loc3_);
      }
      
      public function note9003(param1:Object) : void
      {
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc5_:* = null;
         var _loc3_:* = null;
         var _loc7_:* = null;
         var _loc6_:* = null;
         var _loc8_:* = null;
         LogUtil("note9003=" + JSON.stringify(param1));
         var _loc9_:* = param1.result;
         if(1 !== _loc9_)
         {
            if(0 !== _loc9_)
            {
               if(2 === _loc9_)
               {
                  Tips.show("不能发给自己");
               }
            }
            else
            {
               _loc7_ = new ChatVO();
               _loc7_.userId = PlayerVO.userId;
               _loc7_.userName = PlayerVO.nickName;
               _loc7_.vipRank = PlayerVO.vipRank;
               _loc7_.sex = PlayerVO.sex;
               _loc7_.msg = param1.msg;
               _loc7_.headPtId = PlayerVO.headPtId;
               _loc6_ = new Date();
               _loc6_.setTime(param1.postTime * 1000);
               _loc7_.postTime = getTime(_loc6_);
               _loc7_.newTime = param1.postTime;
               _loc7_.lv = PlayerVO.lv;
               setChatVo(_loc7_,param1);
               _loc8_ = new Date();
               _loc8_.setTime(param1.postTime * 1000);
               _chatVo.postTime = getTime(_loc8_);
               _chatVo.newTime = param1.postTime;
               sendNotification("SEND_PRIVATE_DATA",_chatVo);
               GetPrivateDate.getprivateChatVec(_loc7_);
               sendNotification("SHOW_PRIVATE_CHAT");
               sendNotification("SEND_LEAVE_WORD");
            }
         }
         else
         {
            _loc4_ = new ChatVO();
            _loc4_.belong = 1;
            _loc4_.userId = PlayerVO.userId;
            _loc4_.userName = PlayerVO.nickName;
            _loc4_.vipRank = PlayerVO.vipRank;
            _loc4_.sex = PlayerVO.sex;
            _loc4_.msg = param1.msg;
            _loc4_.headPtId = PlayerVO.headPtId;
            _loc2_ = new Date();
            _loc2_.setTime(param1.postTime * 1000);
            _loc4_.postTime = getTime(_loc2_);
            _loc4_.newTime = param1.postTime;
            _loc4_.lv = PlayerVO.lv;
            setChatVo(_loc4_,param1);
            _loc5_ = new ChatVO();
            _loc5_.userId = param1.userId;
            _loc5_.userName = param1.userName;
            _loc5_.vipRank = param1.vipRank;
            _loc5_.sex = param1.sex;
            _loc5_.headPtId = param1.headPtId;
            _loc3_ = new Date();
            _loc3_.setTime(param1.postTime * 1000);
            _loc5_.postTime = getTime(_loc3_);
            _loc5_.newTime = param1.postTime;
            _loc5_.lv = PlayerVO.lv;
            LogUtil("发给谁=",_loc5_.userName);
            if((Starling.current.root as Game).page is PVPBgUI && PVPBgMediator.isEnterRoom && PVPBgMediator.npcUserId == param1.userId)
            {
               GetPrivateDate.getRoomChatVoVec(_loc4_);
               sendNotification("show_room_chat");
            }
            sendNotification("SEND_PRIVATE_DATA",_loc5_);
            GetPrivateDate.getprivateChatVec(_loc4_);
            ChatMedia.getChatVec(_loc4_);
            sendNotification("SHOW_PRIVATE_CHAT");
            sendNotification("UPDATE_MAINCITYCHAT_NEWS");
         }
      }
      
      public function note9004(param1:Object) : void
      {
         var _loc5_:* = false;
         var _loc4_:* = 0;
         LogUtil("note9004=" + JSON.stringify(param1));
         if(GetPrivateDate.shieldingArr.indexOf(param1.userId) != -1)
         {
            _loc4_ = 0;
            while(_loc4_ < PlayerVO.friendVec.length)
            {
               if(param1.userId == PlayerVO.friendVec[_loc4_].userId)
               {
                  _loc5_ = true;
                  break;
               }
               _loc4_++;
            }
            if(!_loc5_)
            {
               return;
            }
         }
         var _loc3_:ChatVO = new ChatVO();
         _loc3_.belong = 1;
         _loc3_.userId = param1.userId;
         _loc3_.userName = param1.userName;
         _loc3_.vipRank = param1.vipRank;
         _loc3_.msg = param1.msg;
         _loc3_.headPtId = param1.headPtId;
         var _loc2_:Date = new Date();
         _loc2_.setTime(param1.postTime * 1000);
         _loc3_.postTime = getTime(_loc2_);
         _loc3_.newTime = param1.postTime;
         _loc3_.lv = param1.lv;
         if(param1.hasOwnProperty("mineId"))
         {
            _loc3_.mineId = param1.mineId;
         }
         setChatVo(_loc3_,param1);
         if((Starling.current.root as Game).page is PVPBgUI && PVPBgMediator.isEnterRoom && PVPBgMediator.npcUserId == param1.userId)
         {
            GetPrivateDate.getRoomChatVoVec(_loc3_);
            sendNotification("show_room_chat");
         }
         if(!GetCommon.isIOSDied())
         {
            if(!facade.hasMediator("PrivateChatMedia"))
            {
               facade.registerMediator(new PrivateChatMedia(new PrivateChatUI()));
            }
            if(!facade.hasMediator("PrivateListMedia"))
            {
               facade.registerMediator(new PrivateListMedia(new PrivateListUI()));
            }
            if(!Facade.getInstance().hasMediator("RoomChatMediaotr"))
            {
               Facade.getInstance().registerMediator(new RoomChatMediaotr(new RoomChatUI()));
            }
            chatState = isChatingFun(_loc3_);
            if(chatState == 1)
            {
               sendNotification("SEND_PRIVATE_DATA",_loc3_);
            }
            ChatBtnUI.getInstance().chatNews.visible = true;
            ShowBagElfUI.getInstance().chatNews.visible = true;
         }
         if(chatState != 1 && chatState != 5 && chatState != 7)
         {
            Tips.show("玩家【" + _loc3_.userName + "】发了一条消息给你");
         }
         GetPrivateDate.getprivateChatVec(_loc3_);
         ChatMedia.getChatVec(_loc3_);
         if(chatState == 1)
         {
            sendNotification("SHOW_PRIVATE_CHAT");
         }
         else
         {
            §§dup(GetPrivateDate.privateChatVec[GetPrivateDate.getChatVec(_loc3_.userId)][0]).notReadNum++;
            if(chatState == 2)
            {
               (facade.retrieveMediator("PrivateChatMedia") as PrivateChatMedia).privateChat.btn_left.visible = true;
            }
            if(chatState == 3)
            {
               sendNotification("SHOW_CHAT_LIST");
            }
         }
         sendNotification("UPDATE_MAINCITYCHAT_NEWS");
      }
      
      public function write9005() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 9005;
         LogUtil("write9005=",JSON.stringify(_loc1_));
         client.sendBytes(_loc1_);
      }
      
      public function note9005(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc6_:* = 0;
         var _loc4_:* = null;
         var _loc7_:* = 0;
         var _loc5_:* = null;
         var _loc3_:* = null;
         LogUtil("note9005=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            _loc2_ = param1.data.Message;
            _loc6_ = 0;
            while(_loc6_ < _loc2_.length)
            {
               _loc4_ = _loc2_[_loc6_].msg;
               _loc7_ = 0;
               while(_loc7_ < _loc4_.length)
               {
                  _loc5_ = new ChatVO();
                  _loc5_.userId = _loc2_[_loc6_].playerInfo.userId;
                  _loc5_.userName = _loc2_[_loc6_].playerInfo.userName;
                  _loc5_.vipRank = _loc2_[_loc6_].playerInfo.vipRank;
                  _loc5_.msg = _loc4_[_loc7_].msg;
                  _loc5_.headPtId = _loc2_[_loc6_].playerInfo.headPtId;
                  _loc3_ = new Date();
                  _loc3_.setTime(_loc4_[_loc7_].time * 1000);
                  _loc5_.postTime = getTime(_loc3_);
                  _loc5_.newTime = _loc4_[_loc7_].time;
                  _loc5_.lv = _loc2_[_loc6_].playerInfo.lv;
                  if(_loc4_[_loc7_].hasOwnProperty("mineId"))
                  {
                     _loc5_.mineId = _loc4_[_loc7_].mineId;
                  }
                  setChatVo(_loc5_,_loc2_[_loc6_].playerInfo);
                  sendNotification("SEND_PRIVATE_DATA",_loc5_);
                  GetPrivateDate.getprivateChatVec(_loc5_);
                  sendNotification("SHOW_PRIVATE_CHAT");
                  _loc7_++;
               }
               _loc6_++;
            }
            if(_loc2_.length != 0)
            {
               sendNotification("LOOK_LEAVE_WORD",_loc2_.length);
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
            LogUtil("没有留言");
         }
      }
      
      public function write9006(param1:String, param2:String) : void
      {
         LogUtil("receiver=" + param1,"msg=" + param2);
         var _loc3_:Object = {};
         _loc3_.msgId = 9006;
         _loc3_.receiver = param1;
         _loc3_.Message = param2;
         client.sendBytes(_loc3_);
      }
      
      public function note9006(param1:Object) : void
      {
         var _loc2_:* = null;
         LogUtil("note9006=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            _loc2_ = param1.data.Message;
            Tips.show("玩家不在线，留言成功");
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write9007() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 9007;
         client.sendBytes(_loc1_);
      }
      
      public function note9007(param1:Object) : void
      {
         var _loc5_:* = null;
         var _loc6_:* = 0;
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc4_:* = null;
         var _loc7_:* = null;
         LogUtil("note9007=" + JSON.stringify(param1));
         var _loc8_:* = param1.status;
         if("success" !== _loc8_)
         {
            if("fail" !== _loc8_)
            {
               if("error" === _loc8_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            if(!param1.data.msgArr)
            {
               return;
            }
            _loc5_ = param1.data.msgArr;
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               _loc3_ = new ChatVO();
               _loc3_.belong = 2;
               if(_loc5_[_loc6_].playerInfo)
               {
                  if(_loc5_[_loc6_].postTime)
                  {
                     _loc2_ = new Date();
                     _loc2_.setTime(_loc5_[_loc6_].postTime * 1000);
                     _loc3_.postTime = getTime(_loc2_);
                     _loc3_.newTime = _loc5_[_loc6_].postTime;
                  }
                  else
                  {
                     _loc3_.postTime = "";
                  }
                  _loc3_.userId = _loc5_[_loc6_].playerInfo.userId;
                  _loc3_.userName = _loc5_[_loc6_].playerInfo.userName;
                  _loc3_.vipRank = _loc5_[_loc6_].playerInfo.vipRank;
                  _loc3_.sex = _loc5_[_loc6_].playerInfo.sex;
                  _loc3_.headPtId = _loc5_[_loc6_].playerInfo.headPtId;
                  _loc3_.lv = _loc5_[_loc6_].playerInfo.lv;
                  setChatVo(_loc3_,_loc5_[_loc6_].playerInfo);
               }
               if(_loc5_[_loc6_].spirit)
               {
                  LogUtil("object.spiritInfo=" + param1.spirit);
                  _loc4_ = _loc5_[_loc6_].spirit;
                  _loc7_ = GetElfFromSever.getElfInfo(_loc4_);
                  _loc7_.position = _loc4_.position;
                  _loc7_.master = _loc3_.userName;
                  _loc3_.msg = "展示了[" + _loc7_.name + "]";
                  _loc3_.ifShow = true;
                  _loc3_.elfVO = _loc7_;
               }
               else
               {
                  _loc3_.msg = _loc5_[_loc6_].msg;
               }
               worldChatVec.unshift(_loc3_);
               if(worldChatVec.length > 20)
               {
                  worldChatVec.splice(worldChatVec.length - 1,1);
               }
               ChatMedia.getChatVec(_loc3_);
               LogUtil(_loc3_.msg);
               _loc6_++;
            }
            sendNotification("SHOW_WORLD_LIST");
            sendNotification("UPDATE_MAINCITYCHAT_NEWS");
         }
      }
      
      public function write9011(param1:int, param2:Array) : void
      {
         var _loc3_:Object = {};
         _loc3_.msgId = 9011;
         _loc3_.mineId = param1;
         if(param2)
         {
            _loc3_.userIdArr = param2;
            _loc3_.allSend = false;
         }
         else
         {
            _loc3_.allSend = true;
         }
         client.sendBytes(_loc3_);
      }
      
      public function note9011(param1:Object) : void
      {
         LogUtil("note9011: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            Tips.show("邀请发送成功");
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      private function setChatVo(param1:ChatVO, param2:Object) : void
      {
         param1.beyondElf = param2.handBookNum;
         param1.PVPchangeNum = param2.sumFight;
         param1.pvpBestRank = param2.pvpBestRanking;
         param1.elfVec = Vector.<ElfVO>([]);
         if(param1.userId == PlayerVO.userId)
         {
            param1.elfVec = PlayerVO.bagElfVec;
         }
         if(param2.pokeInfo)
         {
            param1.otherPlayerElf = param2.pokeInfo;
         }
      }
      
      private function isChatingFun(param1:ChatVO) : int
      {
         if(!facade.hasMediator("ChatMedia"))
         {
            return 6;
         }
         var _loc4_:ChatUI = (facade.retrieveMediator("ChatMedia") as ChatMedia).chat;
         var _loc5_:PrivateChatUI = (facade.retrieveMediator("PrivateChatMedia") as PrivateChatMedia).privateChat;
         var _loc3_:PrivateListUI = (facade.retrieveMediator("PrivateListMedia") as PrivateListMedia).privateList;
         var _loc2_:RoomChatUI = (facade.retrieveMediator("RoomChatMediaotr") as RoomChatMediaotr).roomChatUI;
         if(_loc4_.parent)
         {
            if(_loc5_.parent && _loc5_.myChatVo)
            {
               if(param1.userId == _loc5_.myChatVo.userId || param1.userId == PlayerVO.userId)
               {
                  return 1;
               }
               return 2;
            }
            if(_loc3_.parent)
            {
               return 3;
            }
            if(_loc2_.parent)
            {
               return 7;
            }
            return 4;
         }
         return 5;
      }
   }
}
