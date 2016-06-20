package com.mvc.models.proxy.mainCity.elfSeries
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.mvc.models.vos.mainCity.elfSeries.RivalVO;
   import com.common.net.Client;
   import com.mvc.models.vos.mainCity.elfSeries.SeriesVO;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import com.common.util.xmlVOHandler.GetElfFromSever;
   import com.mvc.models.vos.elf.ElfVO;
   import lzm.util.HttpClient;
   import flash.utils.getTimer;
   import com.mvc.models.vos.fighting.NPCVO;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.common.util.fighting.GotoChallenge;
   import lzm.util.TimeUtil;
   import com.massage.ane.UmengExtension;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.proxy.Illustrations.IllustrationsPro;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   
   public class ElfSeriesPro extends Proxy
   {
      
      public static const NAME:String = "ElfSeriesPro";
      
      public static var rankVec:Vector.<RivalVO> = new Vector.<RivalVO>([]);
      
      public static var pvpVec:Vector.<RivalVO> = new Vector.<RivalVO>([]);
      
      public static var upRank:int;
       
      private var client:Client;
      
      private var _rivalVo:RivalVO;
      
      private var _fightResult:int;
      
      private var rankRivalVo:RivalVO;
      
      public function ElfSeriesPro(param1:Object = null)
      {
         super("ElfSeriesPro",param1);
         client = Client.getInstance();
         client.addCallObj("note5000",this);
         client.addCallObj("note5001",this);
         client.addCallObj("note5002",this);
         client.addCallObj("note5004",this);
         client.addCallObj("note5005",this);
         client.addCallObj("note5006",this);
         client.addCallObj("note5007",this);
         client.addCallObj("note5008",this);
         client.addCallObj("note5009",this);
         client.addCallObj("note5010",this);
         client.addCallObj("note5011",this);
         client.addCallObj("note5012",this);
         client.addCallObj("note5020",this);
         client.addCallObj("note5021",this);
         client.addCallObj("note5022",this);
         client.addCallObj("note5013",this);
         PlayerVO.initFormationElfVec();
         PlayerVO.initPlayElfVec();
      }
      
      public static function rankSort(param1:Vector.<RivalVO>) : Vector.<RivalVO>
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc2_:* = null;
         _loc3_ = 1;
         while(_loc3_ < param1.length)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length - _loc3_)
            {
               if(param1[_loc4_].rank > param1[_loc4_ + 1].rank)
               {
                  _loc2_ = param1[_loc4_];
                  param1[_loc4_] = param1[_loc4_ + 1];
                  param1[_loc4_ + 1] = _loc2_;
               }
               _loc4_++;
            }
            _loc3_++;
         }
         return param1;
      }
      
      public function write5000() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 5000;
         client.sendBytes(_loc1_);
      }
      
      public function note5000(param1:Object) : void
      {
         var _loc2_:* = 0;
         LogUtil("5000=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            SeriesVO.rank = param1.data.rank;
            PlayerVO.seriesRank = param1.data.rank;
            SeriesVO.fightTime = param1.data.fightTime;
            SeriesVO.surplusTime = param1.data.surplusTime;
            if(param1.data.defendArr)
            {
               _loc2_ = 0;
               while(_loc2_ < PlayerVO.bagElfVec.length)
               {
                  if(PlayerVO.bagElfVec[_loc2_] != null)
                  {
                     PlayerVO.FormationElfVec[_loc2_] = PlayerVO.bagElfVec[_loc2_];
                  }
                  _loc2_++;
               }
               sendNotification("SEND_FORMATION_MAIN");
            }
            sendNotification("SHOW_ELFSERIES");
            write5010();
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
      
      public function write5010() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 5010;
         client.sendBytes(_loc1_);
      }
      
      public function note5010(param1:Object) : void
      {
         var _loc7_:* = null;
         var _loc3_:* = 0;
         var _loc6_:* = null;
         var _loc2_:* = null;
         var _loc5_:* = 0;
         var _loc4_:* = null;
         LogUtil("5010=" + JSON.stringify(param1));
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
            _loc7_ = param1.data.playerArr;
            LogUtil("可以挑战的人数=" + _loc7_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc7_.length)
            {
               _loc6_ = new RivalVO();
               _loc6_.userId = _loc7_[_loc3_].playerInfo.userId;
               _loc6_.userName = _loc7_[_loc3_].playerInfo.userName;
               _loc6_.rank = _loc7_[_loc3_].rank;
               _loc6_.badge = _loc7_[_loc3_].playerInfo.badge;
               _loc6_.sex = _loc7_[_loc3_].playerInfo.sex;
               _loc6_.vipRank = _loc7_[_loc3_].playerInfo.vipRank;
               _loc6_.lv = _loc7_[_loc3_].playerInfo.lv;
               _loc6_.headPtId = _loc7_[_loc3_].playerInfo.headPtId;
               _loc6_.unionAttackAdd = _loc7_[_loc3_].guildAttackAddition;
               _loc6_.unionDefenseAdd = _loc7_[_loc3_].guildDefenseAddition;
               _loc2_ = _loc7_[_loc3_].spirits;
               _loc5_ = 0;
               while(_loc5_ < _loc2_.length)
               {
                  if(_loc2_[_loc5_])
                  {
                     _loc4_ = GetElfFromSever.getElfInfo(_loc2_[_loc5_]);
                     _loc6_.elfVec.push(_loc4_);
                  }
                  else
                  {
                     HttpClient.send(Game.upLoadUrl,{
                        "custom":Game.system,
                        "message":"联盟大赛挑战对象精灵为null=" + JSON.stringify(param1),
                        "token":Game.token,
                        "userId":PlayerVO.userId,
                        "swfVersion":Pocketmon.swfVersion,
                        "starTime":((getTimer() - Pocketmon.startTime) / 60000).toFixed(2),
                        "description":Pocketmon._description
                     },null,null,"post");
                  }
                  _loc5_++;
               }
               SeriesVO.rivalVec[_loc3_] = _loc6_;
               _loc3_++;
            }
            sendNotification("SHOW_RIVAL");
         }
      }
      
      public function write5001(param1:RivalVO) : void
      {
         _rivalVo = param1;
         upRank = PlayerVO.seriesRank - param1.rank;
         var _loc2_:Object = {};
         _loc2_.msgId = 5001;
         _loc2_.elemyUserId = param1.userId;
         client.sendBytes(_loc2_);
      }
      
      public function note5001(param1:Object) : void
      {
         LogUtil("5001=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            NPCVO.unionAttackAdd = _rivalVo.unionAttackAdd;
            NPCVO.unionDefenseAdd = _rivalVo.unionDefenseAdd;
            FightingConfig.sceneName = "daoguan3";
            FightingConfig.fightingAI = 1;
            GotoChallenge.gotoChallenge(_rivalVo.userName,_rivalVo.imgName,_rivalVo.elfVec,false,_rivalVo.userId,0,true);
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
            FightingConfig.reGetBagElf();
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write5002(param1:String, param2:int, param3:Boolean = true) : void
      {
         LogUtil("elemyUserId=" + param1,"fightResult=" + param2);
         var _loc4_:Object = {};
         _loc4_.msgId = 5002;
         _loc4_.elemyUserId = param1;
         _loc4_.fightResult = param2;
         client.sendBytes(_loc4_);
         LogUtil("write5002=" + JSON.stringify(_loc4_));
         FightingConfig.reGetBagElf();
      }
      
      public function note5002(param1:Object) : void
      {
         LogUtil("5002=" + JSON.stringify(param1));
         if(param1.status != "success")
         {
            if(param1.status == "fail")
            {
               Tips.show(param1.data.msg);
            }
            else if(param1.status == "error")
            {
               Tips.show(param1.data.msg);
            }
         }
      }
      
      public function write5005() : void
      {
         LogUtil(" 发送5005协议,请求排行榜");
         var _loc1_:Object = {};
         _loc1_.msgId = 5005;
         client.sendBytes(_loc1_);
      }
      
      public function note5005(param1:Object) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = null;
         LogUtil("5005=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            rankVec = Vector.<RivalVO>([]);
            _loc2_ = 0;
            while(_loc2_ < param1.data.userInfoArr.length)
            {
               _loc3_ = new RivalVO();
               _loc3_.userId = param1.data.userInfoArr[_loc2_].userId;
               _loc3_.userName = param1.data.userInfoArr[_loc2_].userName;
               _loc3_.headPtId = param1.data.userInfoArr[_loc2_].headPtId;
               _loc3_.rank = _loc2_ + 1;
               _loc3_.lv = param1.data.userInfoArr[_loc2_].lv;
               _loc3_.vipRank = param1.data.userInfoArr[_loc2_].vipRank;
               rankVec.push(_loc3_);
               _loc2_++;
            }
            sendNotification("SEND_RANK_DATA");
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
      
      public function write5006() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 5006;
         client.sendBytes(_loc1_);
      }
      
      public function note5006(param1:Object) : void
      {
         var _loc3_:* = NaN;
         var _loc2_:* = 0;
         var _loc4_:* = null;
         LogUtil("5006=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            pvpVec = Vector.<RivalVO>([]);
            _loc3_ = param1.data.time;
            _loc2_ = 0;
            while(_loc2_ < param1.data.recordArr.length)
            {
               _loc4_ = new RivalVO();
               _loc4_.rivalTime = TimeUtil.getTime(_loc3_ - param1.data.recordArr[_loc2_].time);
               _loc4_.ranking = param1.data.recordArr[_loc2_].up;
               _loc4_.userName = param1.data.recordArr[_loc2_].userName;
               _loc4_.userId = param1.data.recordArr[_loc2_].userId;
               _loc4_.headPtId = param1.data.recordArr[_loc2_].headPtId;
               _loc4_.lv = param1.data.recordArr[_loc2_].lv;
               _loc4_.isWin = param1.data.recordArr[_loc2_].isWin;
               _loc4_.vipRank = param1.data.recordArr[_loc2_].vipRank;
               pvpVec.unshift(_loc4_);
               _loc2_++;
            }
            if(pvpVec.length != 0)
            {
               sendNotification("switch_win",null,"LOAD_SERIES_PVP");
            }
            else
            {
               Tips.show("暂无对战记录");
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
      
      public function write5004() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 5004;
         client.sendBytes(_loc1_);
      }
      
      public function note5004(param1:Object) : void
      {
         LogUtil("5004=" + JSON.stringify(param1));
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
            Tips.show("重置成功");
            UmengExtension.getInstance().UMAnalysic("buy|022|1|" + (PlayerVO.diamond - param1.data.diamond));
            sendNotification("update_play_diamond_info",param1.data.diamond);
            sendNotification("SEND_RESTAR");
         }
      }
      
      public function write5007() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 5007;
         client.sendBytes(_loc1_);
      }
      
      public function note5007(param1:Object) : void
      {
         LogUtil("5007=" + JSON.stringify(param1));
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
            PlayerVO.seriesSilver = param1.data.reward.rewardJNS.silver.num;
            PlayerVO.seriesDiamon = param1.data.reward.rewardJNS.diamond.num;
            PlayerVO.seriesRkDot = param1.data.reward.rewardJNS.rkDot.num;
            PlayerVO.seriesMaxRank = param1.data.bestRank;
            sendNotification("CHECK_REWARD");
         }
      }
      
      public function write5008(param1:int) : void
      {
         var _loc4_:* = 0;
         var _loc2_:* = null;
         var _loc5_:* = 0;
         var _loc3_:* = null;
         var _loc7_:Object = {};
         _loc7_.msgId = 5008;
         _loc7_.type = param1;
         var _loc6_:Array = [];
         if(param1 == 0)
         {
            _loc4_ = 0;
            while(_loc4_ < PlayerVO.FormationElfVec.length)
            {
               if(PlayerVO.FormationElfVec[_loc4_] != null)
               {
                  _loc2_ = {};
                  _loc2_["id"] = PlayerVO.FormationElfVec[_loc4_].id;
                  _loc2_["position"] = _loc4_;
                  _loc6_.push(_loc2_);
               }
               _loc4_++;
            }
         }
         else if(param1 == 1)
         {
            _loc5_ = 0;
            while(_loc5_ < PlayerVO.playElfVec.length)
            {
               if(PlayerVO.playElfVec[_loc5_] != null)
               {
                  _loc3_ = {};
                  _loc3_["id"] = PlayerVO.playElfVec[_loc5_].id;
                  _loc3_["position"] = _loc5_;
                  LogUtil(JSON.stringify(_loc3_));
                  _loc6_.push(_loc3_);
               }
               _loc5_++;
            }
         }
         _loc7_.rankList = _loc6_;
         client.sendBytes(_loc7_);
      }
      
      public function note5008(param1:Object) : void
      {
         LogUtil("5008=" + JSON.stringify(param1));
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
      }
      
      public function write5009(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 5009;
         _loc2_.type = param1;
         client.sendBytes(_loc2_,false);
      }
      
      public function note5009(param1:Object) : void
      {
         var _loc7_:* = null;
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc6_:* = 0;
         var _loc5_:* = 0;
         var _loc2_:* = null;
         LogUtil("5009=" + JSON.stringify(param1));
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
            _loc7_ = param1.data.rankFormation;
            if(param1.data.type == 0)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc7_.length)
               {
                  _loc4_ = GetElfFromSever.getElfInfo(_loc7_[_loc3_].spirit);
                  CalculatorFactor.calculatorElf(_loc4_);
                  PlayerVO.FormationElfVec[_loc7_[_loc3_].position] = _loc4_;
                  _loc6_ = 0;
                  while(_loc6_ < PlayerVO.comElfVec.length)
                  {
                     if(PlayerVO.comElfVec[_loc6_].id == PlayerVO.FormationElfVec[_loc3_].id)
                     {
                        PlayerVO.comElfVec[_loc6_] = PlayerVO.FormationElfVec[_loc3_];
                     }
                     _loc6_++;
                  }
                  _loc3_++;
               }
            }
            else if(param1.data.type == 1)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc7_.length)
               {
                  _loc2_ = GetElfFromSever.getElfInfo(_loc7_[_loc5_].spirit);
                  CalculatorFactor.calculatorElf(_loc2_);
                  PlayerVO.playElfVec[_loc7_[_loc5_].position] = _loc2_;
                  _loc5_++;
               }
            }
         }
      }
      
      public function write5011(param1:RivalVO, param2:Boolean = false) : void
      {
         rankRivalVo = param1;
         var _loc3_:Object = {};
         _loc3_.msgId = 5011;
         _loc3_.userId = param1.userId;
         _loc3_.isPackage = param2;
         client.sendBytes(_loc3_);
      }
      
      public function note5011(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = null;
         LogUtil("5011=" + JSON.stringify(param1));
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
            _loc2_ = param1.data.defendArr;
            rankRivalVo.elfVec.length = 0;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = GetElfFromSever.getElfInfo(_loc2_[_loc4_]);
               rankRivalVo.elfVec.push(_loc3_);
               _loc4_++;
            }
            sendNotification("SHOW_RANKPLAYER_DATA",rankRivalVo);
         }
      }
      
      public function write5012() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 5012;
         client.sendBytes(_loc1_);
      }
      
      public function note5012(param1:Object) : void
      {
         LogUtil("5012=" + JSON.stringify(param1));
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
            Tips.show("购买成功");
            SeriesVO.fightTime = SeriesVO.fightTime + 5;
            §§dup(SeriesVO).remainCount--;
            SeriesVO.surplusTime = param1.data.cdTime;
            sendNotification("SHOW_ELFSERIES");
            UmengExtension.getInstance().UMAnalysic("buy|023|1|50");
            sendNotification("update_play_diamond_info",PlayerVO.diamond - 50);
         }
      }
      
      public function write5013(param1:RivalVO) : void
      {
         _rivalVo = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 5013;
         _loc2_.elemyUserId = param1.userId;
         _loc2_.elemyRank = param1.rank;
         client.sendBytes(_loc2_);
      }
      
      public function note5013(param1:Object) : void
      {
         LogUtil("5013=" + JSON.stringify(param1));
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
               write5010();
            }
         }
         else
         {
            sendNotification("CLICK_CHANLLENGE",_rivalVo);
         }
      }
      
      public function write5020() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 5020;
         client.sendBytes(_loc1_);
      }
      
      public function note5020(param1:Object) : void
      {
         LogUtil("note5020: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.goods)
            {
               sendNotification("show_score_shop_goods",param1.data);
               sendNotification("update_score_shop_scoreTf",param1.data.rkDot);
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
      
      public function write5021(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 5021;
         _loc2_.goodsId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note5021(param1:Object) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         LogUtil("note5021=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            Tips.show("兑换成功。");
            sendNotification("remove_score_goods");
            sendNotification("update_score_shop_scoreTf",param1.data.rkDot);
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
      
      public function write5022() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 5022;
         client.sendBytes(_loc1_);
      }
      
      public function note5022(param1:Object) : void
      {
         LogUtil("note5022=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.goods)
            {
               sendNotification("show_score_shop_goods",param1.data);
            }
            sendNotification("update_score_shop_scoreTf",param1.data.rkDot);
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
   }
}
