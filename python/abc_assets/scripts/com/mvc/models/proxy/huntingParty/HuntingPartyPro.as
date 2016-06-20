package com.mvc.models.proxy.huntingParty
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.common.net.Client;
   import com.mvc.models.vos.huntingParty.HuntNodeVO;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.util.GetCommon;
   import com.mvc.models.vos.huntingParty.HuntPartyVO;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.common.util.xmlVOHandler.GetHuntingParty;
   import com.common.themes.Tips;
   import com.common.util.RewardHandle;
   import com.common.managers.ElfFrontImageManager;
   import com.mvc.models.vos.huntingParty.HuntRankVO;
   import com.mvc.models.vos.huntingParty.RankRewardVO;
   import com.mvc.models.vos.huntingParty.RankVO;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.views.mediator.mainCity.kingKwan.GetPropMedia;
   
   public class HuntingPartyPro extends Proxy
   {
      
      public static const NAME:String = "HuntingPartyPro";
      
      public static var bossName:Array = [];
      
      public static var reward:Object;
       
      private var client:Client;
      
      private var _rewardId:int;
      
      private var _nodeVo:HuntNodeVO;
      
      private var _propVo:PropVO;
      
      public function HuntingPartyPro(param1:Object = null)
      {
         super("HuntingPartyPro",param1);
         client = Client.getInstance();
         client.addCallObj("note4101",this);
         client.addCallObj("note4102",this);
         client.addCallObj("note4103",this);
         client.addCallObj("note4104",this);
         client.addCallObj("note4105",this);
         client.addCallObj("note4106",this);
         client.addCallObj("note4107",this);
         client.addCallObj("note4108",this);
         client.addCallObj("note4109",this);
         client.addCallObj("note4111",this);
         client.addCallObj("note4120",this);
      }
      
      public function write4101() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 4101;
         client.sendBytes(_loc1_);
      }
      
      public function note4101(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = 0;
         LogUtil("4101=" + JSON.stringify(param1));
         var _loc4_:* = param1.status;
         if("success" !== _loc4_)
         {
            if("fail" !== _loc4_)
            {
               if("error" === _loc4_)
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
            LogUtil("object.data==",param1.data,param1.data == null,GetCommon.isNullObject(param1.data));
            if(GetCommon.isNullObject(param1.data))
            {
               HuntPartyVO.isOpen = true;
               HuntPartyVO.catchCount = param1.data.catchTime;
               HuntPartyVO.lastNodeId = param1.data.lastNodeId;
               HuntPartyVO.refreshTime = param1.data.refreshTime;
               HuntPartyVO.buyCountDia = param1.data.nextCostDiamond;
               HuntPartyVO.lessCountTime = param1.data.refreshTime;
            }
            else
            {
               HuntPartyVO.isOpen = false;
            }
            if(param1.data.catchMission)
            {
               HuntPartyVO.catchElfObj.lessTime = param1.data.catchMission.endTime - param1.data.catchMission.startTime;
               HuntPartyVO.catchElfObj.goalElfVo = GetElfFactor.getElfVO(param1.data.catchMission.pokeId,false);
               HuntPartyVO.catchElfObj.state = param1.data.catchMission.state;
               HuntPartyVO.catchElfObj.nodeId = param1.data.catchMission.nodeId;
               HuntPartyVO.catchElfObj.rewardObj = param1.data.catchMission.reward;
            }
            else
            {
               HuntPartyVO.catchElfObj = null;
            }
            if(param1.data.catchProp)
            {
               HuntPartyVO.scorePropVo = GetPropFactor.getPropVO(param1.data.catchProp.propId);
               HuntPartyVO.scoreLessTime = param1.data.catchProp.lessTime;
            }
            else
            {
               HuntPartyVO.scorePropVo = null;
            }
            if(param1.data.buff)
            {
               HuntPartyVO.buffObj = GetHuntingParty.buffVec[param1.data.buff.buffId - 1];
               HuntPartyVO.buffObj.id = param1.data.buff.buffId;
               HuntPartyVO.buffObj.time = param1.data.buff.lessTime;
            }
            else
            {
               HuntPartyVO.buffObj = null;
            }
            if(param1.data.boosIds)
            {
               _loc2_ = param1.data.boosIds;
            }
            else
            {
               _loc2_ = [20094,20130,20150,30257,10200,20248];
            }
            bossName = [];
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               bossName.push(GetElfFactor.getElfVO(_loc2_[_loc3_],false).imgName);
               _loc3_++;
            }
            sendNotification("SHOW_HUNTINGPARTY");
            sendNotification("UPDATE_HUNTSCORE",param1.data.catchScore);
         }
      }
      
      public function write4102(param1:HuntNodeVO) : void
      {
         _nodeVo = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 4102;
         _loc2_.nodeId = param1.id;
         client.sendBytes(_loc2_);
      }
      
      public function note4102(param1:Object) : void
      {
         LogUtil("note4102=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
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
            HuntPartyVO.lastNodeId = param1.data.lastNodeId;
            sendNotification("UPDATE_HUNTCOUNT",HuntPartyVO.catchCount - 1);
            sendNotification("SEND_MEETREULT",param1.data.pokeObj);
            sendNotification("UPDATE_HUNTNODE");
         }
      }
      
      public function write4103() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 4103;
         client.sendBytes(_loc1_);
      }
      
      public function note4103(param1:Object) : void
      {
         LogUtil("note4103=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
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
            RewardHandle.Reward(param1.data.reward);
            HuntPartyVO.catchElfObj.state = 2;
            sendNotification("SHOW_GOALELF_UI");
         }
      }
      
      public function write4104() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 4104;
         client.sendBytes(_loc1_);
      }
      
      public function note4104(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         LogUtil("note4104=" + JSON.stringify(param1));
         var _loc5_:* = param1.status;
         if("success" !== _loc5_)
         {
            if("fail" !== _loc5_)
            {
               if("error" === _loc5_)
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
            if(param1.data.scoreMissionState)
            {
               _loc2_ = param1.data.scoreMissionState;
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  _loc4_ = 0;
                  while(_loc4_ < GetHuntingParty.rewardVec.length)
                  {
                     if(GetHuntingParty.rewardVec[_loc4_].rewardId == _loc2_[_loc3_].id)
                     {
                        GetHuntingParty.rewardVec[_loc4_].state = _loc2_[_loc3_].state;
                        break;
                     }
                     _loc4_++;
                  }
                  _loc3_++;
               }
            }
            sendNotification("SHOW_SCOREREWARD_UI",0);
         }
      }
      
      public function write4105(param1:int) : void
      {
         _rewardId = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 4105;
         _loc2_.missionId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note4105(param1:Object) : void
      {
         LogUtil("note4105=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
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
            RewardHandle.Reward(param1.data.reward);
            GetHuntingParty.rewardVec[_rewardId - 1].state = 2;
            sendNotification("SHOW_SCOREREWARD_UI",_rewardId - 1);
         }
      }
      
      public function write4106() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 4106;
         client.sendBytes(_loc1_);
      }
      
      public function note4106(param1:Object) : void
      {
         LogUtil("note4106=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
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
            if(param1.data.catchMission)
            {
               HuntPartyVO.catchElfObj.lessTime = param1.data.catchMission.endTime - param1.data.catchMission.startTime;
               HuntPartyVO.catchElfObj.goalElfVo = GetElfFactor.getElfVO(param1.data.catchMission.pokeId,false);
               HuntPartyVO.catchElfObj.state = param1.data.catchMission.state;
               HuntPartyVO.catchElfObj.nodeId = param1.data.catchMission.nodeId;
               HuntPartyVO.catchElfObj.rewardObj = param1.data.catchMission.reward;
            }
            sendNotification("SHOW_GOALELF_UI");
            sendNotification("update_play_diamond_info",param1.data.diamond);
            Tips.show("当前捕捉目标改为【" + HuntPartyVO.catchElfObj.goalElfVo.name + "】");
         }
      }
      
      public function write4107() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 4107;
         client.sendBytes(_loc1_);
      }
      
      public function note4107(param1:Object) : void
      {
         LogUtil("note4107=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
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
            if(param1.data.buff)
            {
               HuntPartyVO.buffObj = GetHuntingParty.buffVec[param1.data.buff.buffId - 1];
               HuntPartyVO.buffObj.time = param1.data.buff.lessTime;
               sendNotification("UPDATE_HUNTBUFF");
               sendNotification("update_play_diamond_info",param1.data.diamond);
               ElfFrontImageManager.getInstance().getImg(["img_wen2xiang1wa1"],ss);
            }
            Tips.show(HuntPartyVO.buffObj.desc);
         }
      }
      
      private function ss() : void
      {
      }
      
      public function write4108(param1:PropVO) : void
      {
         _propVo = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 4108;
         _loc2_.propId = param1.id;
         client.sendBytes(_loc2_);
      }
      
      public function note4108(param1:Object) : void
      {
         LogUtil("note4108=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
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
            Tips.show("【" + _propVo.name + "】已生效");
            GetPropFactor.addOrLessProp(_propVo,false);
            GetPropFactor.getHuntPartProp();
            if(param1.data.catchProp)
            {
               HuntPartyVO.scorePropVo = GetPropFactor.getPropVO(param1.data.catchProp.propId);
               HuntPartyVO.scoreLessTime = param1.data.catchProp.lessTime;
            }
            sendNotification("SHOW_HUNTBAG_UI");
            sendNotification("USE_SCOREPROP");
         }
      }
      
      public function write4109() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 4109;
         client.sendBytes(_loc1_);
      }
      
      public function note4109(param1:Object) : void
      {
         var _loc4_:* = null;
         var _loc5_:* = 0;
         var _loc2_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = 0;
         var _loc3_:* = null;
         LogUtil("note4109=" + JSON.stringify(param1));
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
            HuntRankVO.myScore = param1.data.catchScore;
            HuntRankVO.myRank = param1.data.catchRanking;
            HuntRankVO.lessTime = param1.data.lessTime;
            if(param1.data.rankingReward)
            {
               _loc4_ = param1.data.rankingReward;
               HuntRankVO.rewardVec = Vector.<RankRewardVO>([]);
               _loc5_ = 0;
               while(_loc5_ < _loc4_.length)
               {
                  _loc2_ = new RankRewardVO();
                  _loc2_.order = _loc5_;
                  if(_loc4_[_loc5_].startRanking == _loc4_[_loc5_].endRanking)
                  {
                     _loc2_.title = "第" + _loc4_[_loc5_].startRanking + "名";
                  }
                  else
                  {
                     _loc2_.title = "第" + _loc4_[_loc5_].startRanking + "名 ~ 第" + _loc4_[_loc5_].endRanking + "名";
                  }
                  _loc2_.rewardObj = _loc4_[_loc5_].reward;
                  HuntRankVO.rewardVec.push(_loc2_);
                  _loc5_++;
               }
            }
            if(param1.data.rankingList)
            {
               _loc6_ = param1.data.rankingList;
               HuntRankVO.allRankVec = Vector.<RankVO>([]);
               _loc7_ = 0;
               while(_loc7_ < _loc6_.length)
               {
                  _loc3_ = new RankVO();
                  _loc3_.niceName = _loc6_[_loc7_].userName;
                  _loc3_.rank = _loc7_ + 1;
                  _loc3_.score = _loc6_[_loc7_].catchScore;
                  _loc3_.serverId = _loc6_[_loc7_].controlId;
                  _loc3_.vip = _loc6_[_loc7_].vipRank;
                  HuntRankVO.allRankVec.push(_loc3_);
                  _loc7_++;
               }
            }
            sendNotification("SHOW_SCORERANK_UI");
         }
      }
      
      public function write4111(param1:Boolean) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 4111;
         _loc2_.free = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note4111(param1:Object) : void
      {
         LogUtil("note4111=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
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
            HuntPartyVO.buyCountDia = param1.data.nextCostDiamond;
            if(param1.data.refreshTime)
            {
               HuntPartyVO.lessCountTime = param1.data.refreshTime;
            }
            sendNotification("UPDATE_HUNTCOUNT",param1.data.catchTimes);
            sendNotification("SHOW_HUNTBUYCOUNT_UI",param1.datanextCostDiamond);
            sendNotification("update_play_diamond_info",param1.data.diamond);
            Tips.show("购买成功，行动次数上升至" + HuntPartyVO.catchCount + "点");
         }
      }
      
      public function write4120(param1:ElfVO, param2:PropVO) : void
      {
         var _loc3_:Object = {};
         _loc3_.msgId = 4120;
         _loc3_.pId = param2.id;
         _loc3_.stateAry = param1.status;
         _loc3_.maxHp = param1.totalHp;
         _loc3_.curHp = param1.currentHp;
         _loc3_.pokeId = param1.elfId;
         client.sendBytes(_loc3_);
      }
      
      public function note4120(param1:Object) : void
      {
         LogUtil("note4120=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
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
            if(param1.data.reward)
            {
               GetPropMedia.type = 1;
               reward = param1.data.reward;
               if(param1.data.isFinish)
               {
                  HuntPartyVO.catchElfObj.state = 1;
               }
            }
            sendNotification("catch_elf_result",param1.data);
         }
      }
   }
}
