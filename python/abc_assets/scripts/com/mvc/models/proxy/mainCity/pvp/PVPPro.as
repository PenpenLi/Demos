package com.mvc.models.proxy.mainCity.pvp
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.mvc.models.vos.mainCity.elfSeries.RivalVO;
   import com.common.net.Client;
   import feathers.controls.Alert;
   import flash.utils.Timer;
   import com.common.themes.Tips;
   import feathers.data.ListCollection;
   import starling.events.Event;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.uis.mainCity.pvp.PVPRankPlayerInfoUI;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.views.uis.mainCity.pvp.PVPBgUI;
   import com.mvc.views.uis.mainCity.pvp.PVPMatchimgUI;
   import com.mvc.views.mediator.mainCity.pvp.PVPChallengeMediator;
   import com.mvc.views.mediator.mainCity.pvp.PVPBgMediator;
   import com.mvc.models.vos.fighting.NPCVO;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.common.util.fighting.GotoChallenge;
   import com.mvc.views.mediator.mainCity.pvp.PVPPracticeMediator;
   import com.common.util.RewardHandle;
   import com.mvc.models.vos.mainCity.chat.ChatVO;
   import starling.core.Starling;
   import com.common.net.CheckNetStatus;
   import com.mvc.views.uis.mainCity.chat.ChatBtnUI;
   import com.mvc.views.mediator.mainCity.chat.RoomChatMediaotr;
   import com.mvc.views.uis.mainCity.chat.RoomChatUI;
   import com.common.util.xmlVOHandler.GetPrivateDate;
   import com.common.util.xmlVOHandler.GetElfFromSever;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.proxy.Illustrations.IllustrationsPro;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.views.uis.fighting.FightingUI;
   import com.common.util.loading.NETLoading;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   import flash.events.TimerEvent;
   import lzm.util.TimeUtil;
   
   public class PVPPro extends Proxy
   {
      
      public static const NAME:String = "PVPPro";
      
      public static var rankVec:Vector.<RivalVO> = new Vector.<RivalVO>([]);
      
      public static var pageIndexNow:int = 1;
      
      public static var nowInviteUserId:String;
      
      public static var pvpInviteRoomId:String;
      
      public static var isAcceptPvpInvite:Boolean;
      
      public static var addRoomObject:Object;
       
      private var client:Client;
      
      private var npcObject:Object;
      
      private var pvpChallengeResult:Boolean;
      
      private var pvpChallengeType:int;
      
      private var pvpFrom:int;
      
      private var object:Object;
      
      private var isRemoveNpc:Boolean;
      
      private var isPvpAlert:Alert;
      
      private var pvpAlert:int;
      
      private var pvpAlertTimer:Timer;
      
      private var isPvpAlertMessage:String;
      
      private var isNotSuitableAlertExist:Boolean;
      
      public function PVPPro(param1:Object = null)
      {
         super("PVPPro",param1);
         client = Client.getInstance();
         client.addCallObj("note6004",this);
         client.addCallObj("note6005",this);
         client.addCallObj("note6010",this);
         client.addCallObj("note6011",this);
         client.addCallObj("note6012",this);
         client.addCallObj("note6013",this);
         client.addCallObj("note6020",this);
         client.addCallObj("note6021",this);
         client.addCallObj("note6022",this);
         client.addCallObj("note6023",this);
         client.addCallObj("note6101",this);
         client.addCallObj("note6102",this);
         client.addCallObj("note6103",this);
         client.addCallObj("note6104",this);
         client.addCallObj("note6105",this);
         client.addCallObj("note6106",this);
         client.addCallObj("note6201",this);
         client.addCallObj("note6202",this);
         client.addCallObj("note6203",this);
         client.addCallObj("note6204",this);
         client.addCallObj("note6205",this);
         client.addCallObj("note6206",this);
         client.addCallObj("note6207",this);
         client.addCallObj("note6208",this);
         client.addCallObj("note6209",this);
         client.addCallObj("note6250",this);
         client.addCallObj("note6251",this);
         client.addCallObj("note6252",this);
      }
      
      public function write6011(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 6011;
         _loc2_.roomNum = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note6011(param1:Object) : void
      {
         object = param1;
         LogUtil("6011=" + JSON.stringify(object));
         if(object.status == "success")
         {
            if(!object.data.roomInfo)
            {
               Tips.show("亲，房间不存在哦");
               return;
            }
            var addRoomSure:Alert = Alert.show("是否加入" + object.data.roomInfo.roomNum + "号房?","",new ListCollection([{"label":"加入"},{"label":"取消"}]));
            addRoomSure.addEventListener("close",function():*
            {
               var /*UnknownSlot*/:* = §§dup(function(param1:Event, param2:Object):void
               {
                  if(param2.label == "加入")
                  {
                     if(object.data.roomInfo.isPsw)
                     {
                        sendNotification("switch_win",null,"load_pvp_check_psw");
                        sendNotification("pvp_send_room_data",object.data.roomInfo);
                     }
                     else
                     {
                        (Facade.getInstance().retrieveProxy("PVPPro") as PVPPro).write6204(object.data.roomInfo.roomId);
                     }
                  }
               });
               return function(param1:Event, param2:Object):void
               {
                  if(param2.label == "加入")
                  {
                     if(object.data.roomInfo.isPsw)
                     {
                        sendNotification("switch_win",null,"load_pvp_check_psw");
                        sendNotification("pvp_send_room_data",object.data.roomInfo);
                     }
                     else
                     {
                        (Facade.getInstance().retrieveProxy("PVPPro") as PVPPro).write6204(object.data.roomInfo.roomId);
                     }
                  }
               };
            }());
         }
         else if(object.status == "fail")
         {
            Tips.show(object.data.msg);
         }
         else if(object.status == "error")
         {
            Tips.show(object.data.msg);
         }
      }
      
      public function write6012() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 6012;
         client.sendBytes(_loc1_);
      }
      
      public function note6012(param1:Object) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = null;
         LogUtil("note6012: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.userInfoArr)
            {
               rankVec = Vector.<RivalVO>([]);
               _loc2_ = 0;
               while(_loc2_ < param1.data.userInfoArr.length)
               {
                  _loc3_ = new RivalVO();
                  _loc3_.rank = _loc2_ + 1;
                  _loc3_.userId = param1.data.userInfoArr[_loc2_].userId;
                  _loc3_.userName = param1.data.userInfoArr[_loc2_].userName;
                  _loc3_.headPtId = param1.data.userInfoArr[_loc2_].headPtId;
                  _loc3_.lv = param1.data.userInfoArr[_loc2_].lv;
                  rankVec.push(_loc3_);
                  _loc2_++;
               }
               sendNotification("show_pvp_rank");
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write6013(param1:RivalVO) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 6013;
         _loc2_.userId = param1.userId;
         client.sendBytes(_loc2_);
      }
      
      public function note6013(param1:Object) : void
      {
         LogUtil("6013=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.playerInfo)
            {
               PVPRankPlayerInfoUI.getInstance().showPlayerInfo(param1.data.playerInfo);
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write6101() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 6101;
         client.sendBytes(_loc1_);
      }
      
      public function note6101(param1:Object) : void
      {
         LogUtil("note6101: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data)
            {
               sendNotification("update_pvpChallenge_info",param1.data);
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write6102() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 6102;
         _loc1_.pokeId = collectBagElfId();
         _loc1_.attack = GetElfFactor.powerCalculate(PlayerVO.bagElfVec);
         client.sendBytes(_loc1_);
      }
      
      public function note6102(param1:Object) : void
      {
         LogUtil("note6102: " + JSON.stringify(param1));
         if(!((Config.starling.root as Game).page is PVPBgUI))
         {
            return;
         }
         if(param1.status == "success")
         {
            if(param1.data.oppPlayerInfo)
            {
               npcObject = param1.data;
               PVPMatchimgUI.getInstance().removeMatchimg();
               sendNotification("update_pvpChallenge_npcinfo",npcObject);
               sendNotification("update_pvpChallenge_state",true);
            }
            else
            {
               PVPMatchimgUI.getInstance().showMatchimg();
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write6103() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 6103;
         client.sendBytes(_loc1_);
      }
      
      public function note6103(param1:Object) : void
      {
         LogUtil("note6103: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            Tips.show("取消匹配成功");
            PVPMatchimgUI.getInstance().removeMatchimg();
            PVPChallengeMediator.isMatchComplete = false;
         }
         else if(param1.status == "fail")
         {
            PVPMatchimgUI.getInstance().removeMatchimg();
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            PVPMatchimgUI.getInstance().removeMatchimg();
            Tips.show(param1.data.msg);
         }
      }
      
      public function write6104() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 6104;
         _loc1_.oppUserId = PVPBgMediator.npcUserId;
         client.sendBytes(_loc1_);
      }
      
      public function note6104(param1:Object) : void
      {
         LogUtil("note6104: " + JSON.stringify(param1));
         if(!PVPChallengeMediator.isMatchComplete)
         {
            return;
         }
         if(param1.status == "success")
         {
            PVPChallengeMediator.isBeginPlay = true;
            var _loc2_:* = param1.data.fightStatus;
            if(1 !== _loc2_)
            {
               if(2 !== _loc2_)
               {
                  if(3 === _loc2_)
                  {
                     Tips.show("对方逃跑，您获得胜利");
                     PVPMatchimgUI.getInstance().removeMatchimg();
                     sendNotification("update_pvpChallenge_state",false);
                  }
               }
               else
               {
                  PVPMatchimgUI.getInstance().showMatchimg(false);
               }
            }
            else
            {
               sendNotification("stop_pvp_countdown");
               PVPMatchimgUI.getInstance().removeMatchimg();
               NPCVO.unionAttackAdd = npcObject.oppPlayerInfo.guildAttackAddition;
               NPCVO.unionDefenseAdd = npcObject.oppPlayerInfo.guildDefenseAddition;
               FightingConfig.sceneName = "daoguan3";
               GotoChallenge.gotoChallenge(npcObject.oppPlayerInfo.userName,"player0" + npcObject.oppPlayerInfo.trainPtId.substr(5),PVPBgMediator.npcElfVOVec,false,PVPBgMediator.npcUserId,100,true);
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write6105() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 6105;
         client.sendBytes(_loc1_);
      }
      
      public function note6105(param1:Object) : void
      {
         LogUtil("note6105: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            Tips.show("取消开始成功");
            PVPMatchimgUI.getInstance().removeMatchimg();
            PVPChallengeMediator.isBeginPlay = false;
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write6106(param1:Boolean, param2:int, param3:int = 1) : void
      {
         var _loc4_:* = null;
         var _loc6_:* = 0;
         var _loc7_:* = null;
         pvpChallengeResult = param1;
         pvpChallengeType = param2;
         pvpFrom = param3;
         object = {};
         object.msgId = 6106;
         object.results = param1;
         object.type = param2;
         object.fightFrom = param3;
         object.verify = FightingConfig.fightToken;
         if(param3 == 2)
         {
            object.roomId = PVPPracticeMediator.pvpRoomId;
         }
         var _loc5_:Array = [];
         _loc6_ = 0;
         while(_loc6_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc6_] != null)
            {
               _loc4_ = {};
               _loc4_.id = PlayerVO.bagElfVec[_loc6_].id;
               _loc7_ = [];
               if(PlayerVO.bagElfVec[_loc6_].carryProp)
               {
                  _loc7_.push(PlayerVO.bagElfVec[_loc6_].carryProp.id);
               }
               if(PlayerVO.bagElfVec[_loc6_].hagberryProp)
               {
                  _loc7_.push(PlayerVO.bagElfVec[_loc6_].hagberryProp.id);
               }
               _loc4_.cryPidAry = _loc7_;
               _loc5_.push(_loc4_);
            }
            _loc6_++;
         }
         object.updtPokeLst = _loc5_;
         client.sendBytes(object);
      }
      
      public function note6106(param1:Object) : void
      {
         LogUtil("note6106: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            LogUtil("pvpFrom=====",pvpChallengeType,pvpFrom,pvpChallengeResult);
            if(pvpFrom == 1)
            {
               if(pvpChallengeType == 1 && pvpChallengeResult)
               {
                  write6101();
                  Tips.show("对方逃跑，您获得胜利");
                  if(param1.data.gift)
                  {
                     RewardHandle.Reward(param1.data.gift);
                  }
               }
               if(pvpChallengeType == 1 && !pvpChallengeResult)
               {
                  write6101();
                  Tips.show("您逃跑了，挑战失败");
               }
               if(pvpChallengeType == 2 && pvpChallengeResult)
               {
                  Tips.show("挑战胜利");
                  PVPBgMediator.pvpReward = param1.data.gift;
               }
               if(pvpChallengeType == 2 && !pvpChallengeResult)
               {
                  Tips.show("挑战失败");
                  PVPBgMediator.pvpReward = param1.data.gift;
               }
               PVPBgMediator.npcUserId = "";
            }
         }
         else if(param1.status == "fail")
         {
            Alert.show(param1.data.msg,"",new ListCollection([{"label":"我知道啦"}]));
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
         if(pvpChallengeType == 2)
         {
            PVPBgMediator.recoverElfData();
            sendNotification("switch_page","load_pvp_page");
         }
      }
      
      public function write6201(param1:int) : void
      {
         pageIndexNow = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 6201;
         _loc2_.pageNow = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note6201(param1:Object) : void
      {
         LogUtil("note6201: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            sendNotification("update_pvpprapre_roomlist",param1.data);
         }
         else if(param1.status == "fail")
         {
            if(param1.data.pageCount == 0)
            {
               sendNotification("update_pvpprapre_roomlist",param1.data);
            }
            else if(param1.data.pageCount > 0)
            {
               write6201(param1.data.pageCount);
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write6202(param1:String, param2:Boolean, param3:String) : void
      {
         var _loc4_:Object = {};
         _loc4_.msgId = 6202;
         _loc4_.roomName = param1;
         _loc4_.isPsw = param2;
         _loc4_.psw = param3;
         client.sendBytes(_loc4_);
      }
      
      public function note6202(param1:Object) : void
      {
         LogUtil("note6202: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            sendNotification("remove_pvp_croom",param1.data.roomMaster);
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write6203() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 6203;
         client.sendBytes(_loc1_);
      }
      
      public function note6203(param1:Object) : void
      {
         LogUtil("note6203: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.roomId)
            {
               write6204(param1.data.roomId);
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write6204(param1:String) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 6204;
         _loc2_.roomId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note6204(param1:Object) : void
      {
         var _loc2_:* = null;
         LogUtil("note6204: " + JSON.stringify(param1));
         pvpInviteRoomId = "";
         if(param1.status == "success")
         {
            addRoomObject = param1;
            _loc2_ = new ChatVO();
            if(param1.data.roomGuest && param1.data.roomMaster)
            {
               if(isAcceptPvpInvite && !((Starling.current.root as Game).page is PVPBgUI))
               {
                  CheckNetStatus.pvpInviteHandler();
                  PVPBgMediator.pvpFrom = 2;
                  sendNotification("switch_page","load_pvp_page");
               }
               else if(isAcceptPvpInvite && (Starling.current.root as Game).page is PVPBgUI)
               {
                  CheckNetStatus.pvpInviteHandler();
                  ChatBtnUI.getInstance().show();
                  PVPBgMediator.pvpFrom = 2;
                  sendNotification("jump_pvp_game",false);
               }
               else
               {
                  inviteAddRoom(param1);
               }
               npcObject = param1.data.roomMaster;
               _loc2_.userId = param1.data.roomMaster.userId;
               _loc2_.userName = param1.data.roomMaster.userName;
               _loc2_.headPtId = param1.data.roomMaster.trainPtId;
            }
            else if(param1.data.roomGuest && !param1.data.roomMaster)
            {
               Tips.show(param1.data.roomGuest.userName + "加入了房间");
               sendNotification("update_pvp_npcInfo",param1.data.roomGuest);
               npcObject = param1.data.roomGuest;
               _loc2_.userId = param1.data.roomGuest.userId;
               _loc2_.userName = param1.data.roomGuest.userName;
               _loc2_.headPtId = param1.data.roomGuest.trainPtId;
            }
            if(!facade.hasMediator("RoomChatMediaotr"))
            {
               facade.registerMediator(new RoomChatMediaotr(new RoomChatUI()));
            }
            sendNotification("SEND_PRIVATE_DATA",_loc2_);
            GetPrivateDate.addChatList(_loc2_);
            sendNotification("send_roomchat_data",_loc2_);
         }
         else if(param1.status == "fail")
         {
            isAcceptPvpInvite = false;
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            isAcceptPvpInvite = false;
            Tips.show(param1.data.msg);
         }
      }
      
      public function inviteAddRoom(param1:Object) : void
      {
         Tips.show("加入房间成功");
         sendNotification("add_pvp_practice");
         sendNotification("update_pvp_myInfo",param1.data.roomGuest);
         sendNotification("update_pvp_npcInfo",param1.data.roomMaster);
         var param1:Object = null;
         addRoomObject = null;
      }
      
      public function write6205() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 6205;
         var _loc2_:* = collectBagElfId();
         _loc1_.pokeId = _loc2_;
         _loc1_.pokeId = _loc2_;
         client.sendBytes(_loc1_);
      }
      
      public function note6205(param1:Object) : void
      {
         LogUtil("note6205: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.hasOwnProperty("roomGuest") && param1.data.roomGuest.status)
            {
               if(!PVPPracticeMediator.npcStatus)
               {
                  return;
               }
               Tips.show("对方已准备好");
               PVPPracticeMediator.npcStatus = param1.data.roomGuest.status;
               sendNotification("update_pvp_my_npc_status","npcStatus");
            }
            else
            {
               if(PVPPracticeMediator.myStatus == 1)
               {
                  return;
               }
               Tips.show("准备成功");
               PVPPracticeMediator.myStatus = 3;
               sendNotification("update_pvp_my_npc_status","myStatus");
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write6206() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 6206;
         client.sendBytes(_loc1_);
      }
      
      public function note6206(param1:Object) : void
      {
         LogUtil("note6206: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.status)
            {
               if(!PVPPracticeMediator.npcStatus)
               {
                  return;
               }
               Tips.show("对方取消准备");
               PVPPracticeMediator.npcStatus = param1.data.status;
               sendNotification("update_pvp_my_npc_status","npcStatus");
            }
            else
            {
               if(PVPPracticeMediator.myStatus == 1)
               {
                  return;
               }
               Tips.show("取消准备成功");
               PVPPracticeMediator.myStatus = 2;
               sendNotification("update_pvp_my_npc_status","myStatus");
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write6207(param1:int) : void
      {
         if(param1 == 2)
         {
            isRemoveNpc = true;
         }
         else
         {
            isRemoveNpc = false;
         }
         var _loc2_:Object = {};
         _loc2_.msgId = 6207;
         _loc2_.type = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note6207(param1:Object) : void
      {
         LogUtil("note6207: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.status)
            {
               var _loc2_:* = param1.data.status;
               if(1 !== _loc2_)
               {
                  if(2 !== _loc2_)
                  {
                     if(3 === _loc2_)
                     {
                        Tips.show("你已被房主踢出");
                        sendNotification("add_pvp_practicepre_from_room");
                        PVPPracticeMediator.myStatus = 0;
                        PVPBgMediator.isEnterRoom = false;
                        sendNotification("remove_pvp_npc");
                     }
                  }
                  else
                  {
                     Tips.show("你成为房主");
                     PVPPracticeMediator.myStatus = 1;
                     sendNotification("remove_pvp_npc","updateMyStatus");
                  }
               }
               else
               {
                  Tips.show("访客已退出");
                  sendNotification("remove_pvp_npc");
               }
            }
            else
            {
               sendNotification("remove_pvp_npc");
               if(!isRemoveNpc)
               {
                  sendNotification("add_pvp_practicepre_from_room");
                  PVPPracticeMediator.myStatus = 0;
                  PVPBgMediator.isEnterRoom = false;
               }
            }
            removeRoomChatData();
            nowInviteUserId = "";
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write6208() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 6208;
         _loc1_.pokeId = collectBagElfId();
         if(PVPPracticeMediator.myStatus == 1)
         {
            _loc1_.roomMasterUserId = PlayerVO.userId;
            _loc1_.roomGuestUserId = PVPBgMediator.npcUserId;
         }
         else
         {
            _loc1_.roomMasterUserId = PVPBgMediator.npcUserId;
            _loc1_.roomGuestUserId = PlayerVO.userId;
         }
         client.sendBytes(_loc1_);
      }
      
      public function note6208(param1:Object) : void
      {
         LogUtil("note6208: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            Tips.show("开始对战");
            if(param1.data.hasOwnProperty("roomMaster"))
            {
               PVPBgMediator.collectNpcElf(param1.data.roomMaster.poke);
            }
            else if(param1.data.hasOwnProperty("roomGuest"))
            {
               PVPBgMediator.collectNpcElf(param1.data.roomGuest.poke);
            }
            NPCVO.unionAttackAdd = npcObject.guildAttackAddition;
            NPCVO.unionDefenseAdd = npcObject.guildDefenseAddition;
            FightingConfig.sceneName = "daoguan3";
            GotoChallenge.gotoChallenge(npcObject.userName,"player0" + npcObject.trainPtId.substr(5),PVPBgMediator.npcElfVOVec,false,PVPBgMediator.npcUserId,100,true);
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write6209() : void
      {
         if(PVPPracticeMediator.myStatus == 0)
         {
            PVPBgMediator.npcUserId = "";
            write6201(PVPPro.pageIndexNow);
            return;
         }
         var _loc1_:Object = {};
         _loc1_.msgId = 6209;
         if(PVPPracticeMediator.myStatus == 1)
         {
            _loc1_.roomMasterUserId = PlayerVO.userId;
            _loc1_.roomGuestUserId = PVPBgMediator.npcUserId;
         }
         else
         {
            _loc1_.roomMasterUserId = PVPBgMediator.npcUserId;
            _loc1_.roomGuestUserId = PlayerVO.userId;
         }
         client.sendBytes(_loc1_);
         return;
         §§push(LogUtil("write6209: " + JSON.stringify(_loc1_)));
      }
      
      public function note6209(param1:Object) : void
      {
         var _loc2_:* = null;
         LogUtil("note6209: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            _loc2_ = new ChatVO();
            sendNotification("add_pvp_practice");
            if(param1.data.roomMaster && param1.data.roomGuest)
            {
               if(PVPPracticeMediator.myStatus == 1)
               {
                  sendNotification("update_pvp_myInfo",param1.data.roomMaster);
                  sendNotification("update_pvp_npcInfo",param1.data.roomGuest);
                  _loc2_.userId = param1.data.roomGuest.userId;
               }
               else
               {
                  sendNotification("update_pvp_myInfo",param1.data.roomGuest);
                  sendNotification("update_pvp_npcInfo",param1.data.roomMaster);
                  _loc2_.userId = param1.data.roomMaster.userId;
               }
               if(!facade.hasMediator("RoomChatMediaotr"))
               {
                  facade.registerMediator(new RoomChatMediaotr(new RoomChatUI()));
               }
               sendNotification("send_roomchat_data",_loc2_);
            }
            else if(param1.data.roomMaster && !param1.data.roomGuest)
            {
               sendNotification("update_pvp_myInfo",param1.data.roomMaster);
               removeRoomChatData();
               PVPBgMediator.npcUserId = "";
               nowInviteUserId = "";
            }
            else if(!param1.data.roomMaster && param1.data.roomGuest)
            {
               sendNotification("update_pvp_myInfo",param1.data.roomGuest);
               removeRoomChatData();
               PVPBgMediator.npcUserId = "";
               nowInviteUserId = "";
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write6250() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 6250;
         client.sendBytes(_loc1_);
      }
      
      public function note6250(param1:Object) : void
      {
         LogUtil("note6250: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.goods)
            {
               sendNotification("show_score_shop_goods",param1.data);
               sendNotification("update_score_shop_scoreTf",param1.data.pvDot);
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write6251(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 6251;
         _loc2_.goodsId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note6251(param1:Object) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         LogUtil("note6251=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            Tips.show("兑换成功");
            sendNotification("remove_score_goods");
            sendNotification("update_score_shop_scoreTf",param1.data.pvDot);
            sendNotification("update_score_shop");
            if(param1.data.goods)
            {
               if(param1.data.goods.spirites)
               {
                  _loc4_ = param1.data.goods.spirites;
                  _loc3_ = GetElfFromSever.getElfInfo(_loc4_);
                  GetElfFactor.bagOrCom(_loc3_);
                  IllustrationsPro.saveElfInfo(_loc3_);
               }
               if(param1.data.goods.props)
               {
                  _loc2_ = GetPropFactor.getPropVO(param1.data.goods.props.pId);
                  _loc2_.rewardCount = param1.data.goods.props.num;
                  GetPropFactor.addOrLessProp(_loc2_,true,_loc2_.rewardCount);
               }
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write6252() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 6252;
         client.sendBytes(_loc1_);
      }
      
      public function note6252(param1:Object) : void
      {
         LogUtil("note6252=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.goods)
            {
               sendNotification("show_score_shop_goods",param1.data);
            }
            sendNotification("update_score_shop_scoreTf",param1.data.pvDot);
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write6010() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 6010;
         client.sendBytes(_loc1_);
      }
      
      public function note6010(param1:Object) : void
      {
         LogUtil("note6010=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show(param1.data.msg);
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            sendNotification("check_pvp_rank_reward",param1);
         }
      }
      
      public function write6020(param1:String) : void
      {
         nowInviteUserId = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 6020;
         _loc2_.userId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note6020(param1:Object) : void
      {
         LogUtil("note6020=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show(param1.data.msg);
                  nowInviteUserId = "";
               }
            }
            else
            {
               Tips.show(param1.data.msg);
               nowInviteUserId = "";
            }
         }
         else
         {
            Tips.show("亲，邀请发送成功，请耐心等待");
         }
      }
      
      public function note6021(param1:Object) : void
      {
         object = param1;
         LogUtil("note6021=" + JSON.stringify(object));
         var _loc3_:* = object.status;
         if("success" !== _loc3_)
         {
            if("fail" !== _loc3_)
            {
               if("error" === _loc3_)
               {
                  Tips.show(object.data.msg);
               }
            }
            else
            {
               Tips.show(object.data.msg);
            }
         }
         else
         {
            pvpInviteRoomId = object.data.roomId;
            LogUtil("接受邀请推送，PlayerVO.isAcceptPvp: " + PlayerVO.isAcceptPvp);
            if(!checkFriend(object.data.userId) && !Config.isPvpInviteSure)
            {
               write6022(pvpInviteRoomId);
               return;
            }
            if((Starling.current.root as Game).page is FightingUI || PVPBgMediator.isEnterRoom || PVPChallengeMediator.isMatchComplete || NETLoading.isNetLoading || Config.isOpenBeginner || FightingConfig.isLvUp || CalculatorFactor.isLearnSkill || !PlayerVO.isAcceptPvp)
            {
               isNotSuitableAlertExist = true;
               var notSuitableAlert:Alert = Alert.show("训练师<font color = \'#07a0f2\'>" + object.data.userName + "</font>" + "邀您到房间PK，检测到您当前正忙，系统已婉拒","",new ListCollection([{"label":"我知道了"}]));
               notSuitableAlert.addEventListener("close",notSuitableAlert_closeHandler);
               Starling.juggler.delayCall(function():void
               {
                  if(!isNotSuitableAlertExist)
                  {
                     return;
                  }
                  if(Config.stage.getChildByName("alert") != null)
                  {
                     Config.stage.getChildByName("alert").removeFromParent(true);
                  }
                  write6022(pvpInviteRoomId);
                  isNotSuitableAlertExist = false;
               },2);
            }
            else
            {
               pvpAlertTimer = new Timer(1000);
               isPvpAlert = Alert.show("训练师<font color = \'#07a0f2\'>" + object.data.userName + "</font>" + "邀您到房间PK，是否立刻前往？\n","",new ListCollection([{"label":"好的"},{"label":"不虐菜"}]));
               isPvpAlert.addEventListener("close",isPvpAlert_closeHandler);
               isPvpAlertMessage = isPvpAlert.message;
               pvpAlert = 15;
               pvpAlertTimer.addEventListener("timer",pvpAlertTimer_timerHandler);
               pvpAlertTimer.start();
            }
         }
      }
      
      private function checkFriend(param1:String) : Boolean
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < PlayerVO.friendVec.length)
         {
            if(param1 == PlayerVO.friendVec[_loc2_].userId)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function notSuitableAlert_closeHandler(param1:Event) : void
      {
         if(param1.data.label == "我知道了")
         {
            isNotSuitableAlertExist = false;
            write6022(pvpInviteRoomId);
         }
      }
      
      protected function pvpAlertTimer_timerHandler(param1:TimerEvent) : void
      {
         if(!pvpAlertTimer)
         {
            return;
         }
         pvpAlert = pvpAlert - 1;
         isPvpAlert.message = isPvpAlertMessage + TimeUtil.convertStringToDate(pvpAlert);
         if(pvpAlert <= 0)
         {
            pvpAlertTimer.stop();
            pvpAlertTimer.removeEventListener("timer",pvpAlertTimer_timerHandler);
            pvpAlertTimer = null;
            if(Config.stage.getChildByName("alert") != null)
            {
               Config.stage.getChildByName("alert").removeFromParent(true);
            }
            write6022(pvpInviteRoomId);
         }
      }
      
      private function isPvpAlert_closeHandler(param1:Event) : void
      {
         event = param1;
         if((Starling.current.root as Game).page is FightingUI || PVPBgMediator.isEnterRoom || PVPChallengeMediator.isMatchComplete || NETLoading.isNetLoading || Config.isOpenBeginner || FightingConfig.isLvUp || CalculatorFactor.isLearnSkill || !PlayerVO.isAcceptPvp)
         {
            isAcceptPvpInvite = false;
            Tips.show("亲，当前状态不能接受邀请哦");
            Starling.juggler.delayCall(function():void
            {
               write6022(pvpInviteRoomId);
            },1);
            pvpAlertTimer.stop();
            pvpAlertTimer.removeEventListener("timer",pvpAlertTimer_timerHandler);
            pvpAlertTimer = null;
            return;
         }
         if(event.data.label == "好的")
         {
            isAcceptPvpInvite = true;
            write6204(pvpInviteRoomId);
            pvpAlertTimer.stop();
            pvpAlertTimer.removeEventListener("timer",pvpAlertTimer_timerHandler);
            pvpAlertTimer = null;
         }
         else
         {
            isAcceptPvpInvite = false;
            write6022(pvpInviteRoomId);
            pvpAlertTimer.stop();
            pvpAlertTimer.removeEventListener("timer",pvpAlertTimer_timerHandler);
            pvpAlertTimer = null;
         }
      }
      
      public function write6022(param1:String, param2:Boolean = false) : void
      {
         pvpInviteRoomId = "";
         if(Config.isPvpInviteSure)
         {
            Tips.show("您拒绝了PvP对战邀请");
         }
         var _loc3_:Object = {};
         _loc3_.msgId = 6022;
         _loc3_.roomId = param1;
         _loc3_.invite = param2;
         client.sendBytes(_loc3_,false);
      }
      
      public function note6022(param1:Object) : void
      {
         LogUtil("note6022=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" !== _loc2_)
               {
               }
            }
         }
      }
      
      public function note6023(param1:Object) : void
      {
         LogUtil("note6023=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show(param1.data.msg);
               }
            }
            else
            {
               Tips.show(param1.data.msg);
               nowInviteUserId = "";
            }
         }
         else
         {
            Tips.show("对方玩家不便应战");
            nowInviteUserId = "";
         }
      }
      
      public function write6004() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 6004;
         client.sendBytes(_loc1_,false);
      }
      
      public function note6004(param1:Object) : void
      {
         LogUtil("note6004=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show(param1.data.msg);
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
      }
      
      public function write6005() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 6005;
         client.sendBytes(_loc1_,false);
      }
      
      public function note6005(param1:Object) : void
      {
         LogUtil("note6005=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show(param1.data.msg);
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
      }
      
      private function collectBagElfId() : Array
      {
         var _loc2_:* = 0;
         var _loc1_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc2_] != null)
            {
               _loc1_.push(PlayerVO.bagElfVec[_loc2_].id);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function removeRoomChatData() : void
      {
         if(!facade.hasMediator("RoomChatMediaotr"))
         {
            facade.registerMediator(new RoomChatMediaotr(new RoomChatUI()));
         }
         sendNotification("send_roomchat_data",null);
         GetPrivateDate.roomChatVoVec = new Vector.<ChatVO>([]);
         sendNotification("show_room_chat");
      }
   }
}
