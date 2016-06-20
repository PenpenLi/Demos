package com.mvc.models.proxy.mainCity.kingKwan
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.mvc.models.vos.mainCity.kingKwan.KingVO;
   import com.common.net.Client;
   import com.mvc.views.mediator.mainCity.kingKwan.KingKwanMedia;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import com.common.util.xmlVOHandler.GetElfFromSever;
   import com.mvc.models.vos.fighting.NPCVO;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.common.util.fighting.GotoChallenge;
   import lzm.util.HttpClient;
   import flash.utils.getTimer;
   import com.common.util.RewardHandle;
   import com.mvc.views.mediator.fighting.FightingLogicFactor;
   import com.mvc.models.vos.elf.SkillVO;
   import com.mvc.models.proxy.Illustrations.IllustrationsPro;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   
   public class KingKwanPro extends Proxy
   {
      
      public static const NAME:String = "KingKwanPro";
      
      public static var kingVec:Vector.<KingVO> = new Vector.<KingVO>([]);
       
      private var client:Client;
      
      private var _chapter:int;
      
      private var _rivalStaId:int;
      
      private var _kingVo:KingVO;
      
      private var _fightResult:int;
      
      public function KingKwanPro(param1:Object = null)
      {
         super("KingKwanPro",param1);
         client = Client.getInstance();
         client.addCallObj("note2300",this);
         client.addCallObj("note2301",this);
         client.addCallObj("note2302",this);
         client.addCallObj("note2303",this);
         client.addCallObj("note2304",this);
         client.addCallObj("note2305",this);
         client.addCallObj("note2310",this);
         client.addCallObj("note2311",this);
         client.addCallObj("note2312",this);
         client.addCallObj("note2313",this);
      }
      
      public function write2300() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 2300;
         client.sendBytes(_loc1_);
      }
      
      public function note2300(param1:Object) : void
      {
         var _loc7_:* = null;
         var _loc3_:* = 0;
         var _loc2_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = 0;
         var _loc4_:* = null;
         LogUtil("2300=" + JSON.stringify(param1));
         var _loc8_:* = param1.status;
         if("success" !== _loc8_)
         {
            if("fail" !== _loc8_)
            {
               if("error" === _loc8_)
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
            KingKwanMedia.remainCount = Math.abs(param1.data.krResetFightTimes);
            if(param1.data.lastChapter)
            {
               KingKwanMedia.mopUpCount = param1.data.lastChapter;
            }
            _loc7_ = param1.data.oppPlayerList;
            KingKwanMedia.passNum = param1.data.nowChapter;
            kingVec = Vector.<KingVO>([]);
            _loc3_ = 0;
            while(_loc3_ < _loc7_.length)
            {
               _loc2_ = new KingVO();
               _loc2_.useId = _loc7_[_loc3_].playerInfo.userId;
               _loc2_.name = _loc7_[_loc3_].playerInfo.userName;
               _loc2_.headId = _loc7_[_loc3_].playerInfo.headPtId;
               _loc2_.trainPtId = _loc7_[_loc3_].playerInfo.trainPtId;
               _loc2_.imgName = "player0" + (_loc2_.trainPtId - 100000);
               _loc2_.lv = _loc7_[_loc3_].playerInfo.lv;
               _loc2_.state = _loc7_[_loc3_].state;
               _loc2_.chapter = _loc7_[_loc3_].chapter;
               _loc2_.vipRank = _loc7_[_loc3_].vipRank;
               _loc5_ = _loc7_[_loc3_].spirits;
               _loc6_ = 0;
               while(_loc6_ < _loc5_.length)
               {
                  _loc4_ = GetElfFactor.getElfVO(_loc5_[_loc6_].spId,false);
                  _loc4_.lv = _loc5_[_loc6_].lv;
                  _loc4_.id = _loc5_[_loc6_].id;
                  _loc4_.currentHp = _loc5_[_loc6_].hp;
                  _loc4_.camp = "camp_of_computer";
                  CalculatorFactor.calculatorElf(_loc4_);
                  _loc2_.elfVec.push(_loc4_);
                  _loc6_++;
               }
               kingVec.push(_loc2_);
               _loc3_++;
            }
            PlayerVO.kingIsOpen = param1.data.isStartKingWay;
            if(!PlayerVO.kingIsOpen)
            {
               sendNotification("SHOW_MOP_UP");
            }
            sendNotification("SHOW_KING_LIST");
            if(KingKwanMedia.kingPlayElf.length == 0)
            {
               (facade.retrieveProxy("KingKwanPro") as KingKwanPro).write2305();
            }
            else if(!PlayerVO.kingIsOpen)
            {
               (facade.retrieveProxy("KingKwanPro") as KingKwanPro).write2305();
            }
         }
      }
      
      public function write2301(param1:KingVO) : void
      {
         var _loc2_:* = 0;
         _kingVo = param1;
         var _loc4_:Object = {};
         _loc4_.msgId = 2301;
         _loc4_.chapter = param1.chapter;
         var _loc3_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc2_] != null)
            {
               _loc3_.push(PlayerVO.bagElfVec[_loc2_].id);
            }
            _loc2_++;
         }
         _loc4_.fightSpiritId = _loc3_;
         client.sendBytes(_loc4_);
      }
      
      public function note2301(param1:Object) : void
      {
         var _loc7_:* = null;
         var _loc3_:* = 0;
         var _loc2_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = 0;
         var _loc4_:* = null;
         LogUtil("2301=" + JSON.stringify(param1));
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
            _loc7_ = param1.data.oppSpirits;
            kingVec[_kingVo.chapter - 1].elfVec = Vector.<ElfVO>([]);
            _loc3_ = 0;
            while(_loc3_ < _loc7_.length)
            {
               kingVec[_kingVo.chapter - 1].elfVec.push(GetElfFromSever.getElfInfo(_loc7_[_loc3_]));
               _loc3_++;
            }
            _loc2_ = kingVec[_kingVo.chapter - 1];
            _loc5_ = param1.data.ownSpriits;
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               _loc4_ = GetElfFromSever.getElfInfo(_loc5_[_loc6_]);
               _loc4_.power = PlayerVO.bagElfVec[_loc6_].power;
               PlayerVO.bagElfVec[_loc6_] = null;
               PlayerVO.bagElfVec[_loc6_] = _loc4_;
               _loc6_++;
            }
            if(param1.data.oppGuild)
            {
               NPCVO.unionAttackAdd = param1.data.oppGuild.guildAttackAddition;
               NPCVO.unionDefenseAdd = param1.data.oppGuild.guildDefenseAddition;
            }
            FightingConfig.sceneName = "daoguan2";
            FightingConfig.fightingAI = 1;
            GotoChallenge.gotoChallenge(_loc2_.name,_loc2_.imgName,_loc2_.elfVec,false,_loc2_.useId,_loc2_.chapter);
            PlayerVO.kingIsOpen = param1.data.isStartKingWay;
         }
      }
      
      public function write2302() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 2302;
         client.sendBytes(_loc1_);
      }
      
      public function note2302(param1:Object) : void
      {
         var _loc7_:* = null;
         var _loc3_:* = 0;
         var _loc2_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = 0;
         var _loc4_:* = null;
         LogUtil("2302=" + JSON.stringify(param1));
         var _loc8_:* = param1.status;
         if("success" !== _loc8_)
         {
            if("fail" !== _loc8_)
            {
               if("error" !== _loc8_)
               {
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            KingKwanMedia.remainCount = Math.abs(param1.data.krResetFightTimes);
            if(param1.data.lastChapter)
            {
               KingKwanMedia.mopUpCount = param1.data.lastChapter;
            }
            _loc7_ = param1.data.oppPlayerList;
            kingVec = Vector.<KingVO>([]);
            KingKwanMedia.passNum = 1;
            PlayerVO.kingIsOpen = false;
            _loc3_ = 0;
            while(_loc3_ < _loc7_.length)
            {
               _loc2_ = new KingVO();
               _loc2_.useId = _loc7_[_loc3_].playerInfo.userId;
               _loc2_.name = _loc7_[_loc3_].playerInfo.userName;
               _loc2_.headId = _loc7_[_loc3_].playerInfo.headPtId;
               _loc2_.trainPtId = _loc7_[_loc3_].playerInfo.trainPtId;
               _loc2_.imgName = "player0" + (_loc2_.trainPtId - 100000);
               _loc2_.lv = _loc7_[_loc3_].playerInfo.lv;
               _loc2_.state = _loc7_[_loc3_].state;
               _loc2_.chapter = _loc7_[_loc3_].chapter;
               _loc5_ = _loc7_[_loc3_].spirits;
               _loc6_ = 0;
               while(_loc6_ < _loc5_.length)
               {
                  _loc4_ = GetElfFactor.getElfVO(_loc5_[_loc6_].spId,false);
                  _loc4_.camp = "camp_of_computer";
                  _loc4_.lv = _loc5_[_loc6_].lv;
                  _loc4_.currentHp = _loc5_[_loc6_].hp;
                  CalculatorFactor.calculatorElf(_loc4_);
                  _loc2_.elfVec.push(_loc4_);
                  _loc6_++;
               }
               kingVec.push(_loc2_);
               _loc3_++;
            }
            KingKwanMedia.kingPlayElf = Vector.<ElfVO>([]);
            sendNotification("REMOVE_SELEPLAYELF_MEDIA");
            sendNotification("SHOW_KING_LIST");
            sendNotification("SHOW_MOP_UP");
            write2305();
         }
      }
      
      public function write2303(param1:int, param2:Boolean = true) : void
      {
         var _loc3_:* = null;
         var _loc9_:* = 0;
         var _loc4_:* = null;
         var _loc10_:* = 0;
         var _loc14_:* = null;
         var _loc6_:* = null;
         var _loc11_:* = 0;
         var _loc5_:* = null;
         var _loc7_:* = 0;
         var _loc13_:* = null;
         LogUtil("fightResult= " + param1);
         _fightResult = param1;
         initAllElfVo();
         FightingConfig.updateKingPlayElf();
         var _loc15_:Object = {};
         _loc15_.msgId = 2303;
         _loc15_.fightResult = param1;
         _loc15_.chapter = _kingVo.chapter;
         var _loc8_:Array = [];
         _loc9_ = 0;
         while(_loc9_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc9_] != null)
            {
               _loc3_ = {};
               _loc3_.id = PlayerVO.bagElfVec[_loc9_].id;
               _loc3_.hp = PlayerVO.bagElfVec[_loc9_].currentHp;
               _loc3_.exp = Math.round(PlayerVO.bagElfVec[_loc9_].currentExp);
               _loc3_.lv = PlayerVO.bagElfVec[_loc9_].lv;
               if(PlayerVO.bagElfVec[_loc9_].carryProp)
               {
                  _loc3_.cryPidAry = [PlayerVO.bagElfVec[_loc9_].carryProp.id];
               }
               else
               {
                  _loc3_.cryPidAry = [];
               }
               _loc3_.effAry = PlayerVO.bagElfVec[_loc9_].effAry;
               _loc4_ = [];
               _loc10_ = 0;
               while(_loc10_ < PlayerVO.bagElfVec[_loc9_].currentSkillVec.length)
               {
                  _loc14_ = {};
                  _loc14_.id = PlayerVO.bagElfVec[_loc9_].currentSkillVec[_loc10_].id;
                  _loc14_.pp = PlayerVO.bagElfVec[_loc9_].currentSkillVec[_loc10_].currentPP;
                  _loc4_.push(_loc14_);
                  _loc10_++;
               }
               _loc3_.skLst = _loc4_;
               _loc8_.push(_loc3_);
               PlayerVO.bagElfVec[_loc9_].isHasFiging = false;
            }
            _loc9_++;
         }
         var _loc12_:Array = [];
         _loc11_ = 0;
         while(_loc11_ < NPCVO.bagElfVec.length)
         {
            _loc6_ = {};
            _loc6_.id = NPCVO.bagElfVec[_loc11_].id;
            _loc6_.hp = NPCVO.bagElfVec[_loc11_].currentHp;
            _loc6_.exp = Math.round(NPCVO.bagElfVec[_loc11_].currentExp);
            _loc6_.lv = NPCVO.bagElfVec[_loc11_].lv;
            if(NPCVO.bagElfVec[_loc11_].carryProp)
            {
               _loc6_.cryPidAry = [NPCVO.bagElfVec[_loc11_].carryProp.id];
            }
            else
            {
               _loc6_.cryPidAry = [];
            }
            _loc6_.effAry = NPCVO.bagElfVec[_loc11_].effAry;
            _loc5_ = [];
            _loc7_ = 0;
            while(_loc7_ < NPCVO.bagElfVec[_loc11_].currentSkillVec.length)
            {
               _loc13_ = {};
               _loc13_.id = NPCVO.bagElfVec[_loc11_].currentSkillVec[_loc7_].id;
               _loc13_.pp = NPCVO.bagElfVec[_loc11_].currentSkillVec[_loc7_].currentPP;
               _loc5_.push(_loc13_);
               _loc7_++;
            }
            _loc6_.skLst = _loc5_;
            _loc12_.push(_loc6_);
            NPCVO.bagElfVec[_loc11_].isHasFiging = false;
            _loc11_++;
         }
         _loc15_.ownPlySpiritHpArr = _loc8_;
         _loc15_.oppPlySpiritHpArr = _loc12_;
         client.sendBytes(_loc15_);
         FightingConfig.reGetBagElf();
      }
      
      public function note2303(param1:Object) : void
      {
         var _loc9_:* = 0;
         var _loc5_:* = 0;
         var _loc7_:* = 0;
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc8_:* = null;
         var _loc4_:* = 0;
         var _loc6_:* = null;
         LogUtil("2303=" + JSON.stringify(param1));
         var _loc10_:* = param1.status;
         if("success" !== _loc10_)
         {
            if("fail" !== _loc10_)
            {
               if("error" === _loc10_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show("协议处理失败");
            }
         }
         else
         {
            _loc9_ = param1.data.state;
            if(_fightResult == 1 && _loc9_ != 2)
            {
               HttpClient.send(Game.upLoadUrl,{
                  "custom":Game.system,
                  "message":"王者之路战斗结果异常=客户端发送的结果" + _fightResult + "===服务端计算的结果=" + param1.data.state,
                  "token":Game.token,
                  "userId":PlayerVO.userId,
                  "swfVersion":Pocketmon.swfVersion,
                  "starTime":((getTimer() - Pocketmon.startTime) / 60000).toFixed(2),
                  "description":Pocketmon._description
               },null,null,"post");
            }
            if(_kingVo.chapter > kingVec.length)
            {
               HttpClient.send(Game.upLoadUrl,{
                  "custom":Game.system,
                  "message":"王者之路关卡数据异常:关卡 =" + _kingVo.chapter + "===关卡数据=" + JSON.stringify(kingVec),
                  "token":Game.token,
                  "userId":PlayerVO.userId,
                  "swfVersion":Pocketmon.swfVersion,
                  "starTime":((getTimer() - Pocketmon.startTime) / 60000).toFixed(2),
                  "description":Pocketmon._description
               },null,null,"post");
            }
            if(_fightResult == 1 && _kingVo.chapter != 15)
            {
               if(!(param1.data as Object).hasOwnProperty("nextChapter"))
               {
                  HttpClient.send(Game.upLoadUrl,{
                     "custom":Game.system,
                     "message":"战斗胜利去没有数据=" + JSON.stringify(param1),
                     "token":Game.token,
                     "userId":PlayerVO.userId,
                     "swfVersion":Pocketmon.swfVersion,
                     "starTime":((getTimer() - Pocketmon.startTime) / 60000).toFixed(2),
                     "description":Pocketmon._description
                  },null,null,"post");
               }
               else if(param1.data.nextChapter == null)
               {
                  HttpClient.send(Game.upLoadUrl,{
                     "custom":Game.system,
                     "message":"战斗胜利去没有数据==" + JSON.stringify(param1),
                     "token":Game.token,
                     "userId":PlayerVO.userId,
                     "swfVersion":Pocketmon.swfVersion,
                     "starTime":((getTimer() - Pocketmon.startTime) / 60000).toFixed(2),
                     "description":Pocketmon._description
                  },null,null,"post");
               }
            }
            if(_loc9_ == 2)
            {
               if(KingKwanMedia.passNum < 15)
               {
                  §§dup(KingKwanMedia).passNum++;
               }
            }
            _loc5_ = 0;
            while(_loc5_ < NPCVO.bagElfVec.length)
            {
               if(NPCVO.bagElfVec != null)
               {
                  _loc7_ = 0;
                  while(_loc7_ < kingVec[_kingVo.chapter - 1].elfVec.length)
                  {
                     if(kingVec[_kingVo.chapter - 1].elfVec[_loc7_].id == NPCVO.bagElfVec[_loc5_].id)
                     {
                        kingVec[_kingVo.chapter - 1].elfVec[_loc7_] = NPCVO.bagElfVec[_loc5_];
                     }
                     _loc7_++;
                  }
               }
               _loc5_++;
            }
            kingVec[_kingVo.chapter - 1].state = _loc9_;
            if(_kingVo.chapter < kingVec.length)
            {
               kingVec[_kingVo.chapter].state = _loc9_ - 1;
            }
            if((param1.data as Object).hasOwnProperty("nextChapter"))
            {
               if(param1.data.nextChapter != null)
               {
                  _loc3_ = param1.data.nextChapter;
                  _loc2_ = new KingVO();
                  _loc2_.useId = _loc3_.playerInfo.userId;
                  _loc2_.name = _loc3_.playerInfo.userName;
                  _loc2_.headId = _loc3_.playerInfo.headPtId;
                  _loc2_.trainPtId = _loc3_.playerInfo.trainPtId;
                  _loc2_.imgName = "player0" + (_loc2_.trainPtId - 100000);
                  _loc2_.lv = _loc3_.playerInfo.lv;
                  _loc2_.state = _loc3_.state;
                  _loc2_.chapter = _loc3_.chapter;
                  _loc8_ = _loc3_.spirits;
                  _loc4_ = 0;
                  while(_loc4_ < _loc8_.length)
                  {
                     _loc6_ = GetElfFactor.getElfVO(_loc8_[_loc4_].spId,false);
                     _loc6_.camp = "camp_of_computer";
                     _loc6_.lv = _loc8_[_loc4_].lv;
                     _loc6_.currentHp = _loc8_[_loc4_].hp;
                     CalculatorFactor.calculatorElf(_loc6_);
                     _loc2_.elfVec.push(_loc6_);
                     _loc4_++;
                  }
                  kingVec.push(_loc2_);
               }
            }
            sendNotification("SHOW_KING_LIST");
         }
      }
      
      public function write2304(param1:int) : void
      {
         _chapter = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 2304;
         _loc2_.chapter = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note2304(param1:Object) : void
      {
         LogUtil("note2304=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            RewardHandle.Reward(param1.data.gift,3);
            kingVec[_chapter - 1].state = 3;
            sendNotification("SHOW_KING_LIST");
            sendNotification("GOTO_GET_REWARD",_chapter - 1);
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write2305() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 2305;
         client.sendBytes(_loc1_);
      }
      
      public function note2305(param1:Object) : void
      {
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = 0;
         LogUtil("2305=" + JSON.stringify(param1));
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
            _loc4_ = param1.data.spirits;
            KingKwanMedia.kingPlayElf = Vector.<ElfVO>([]);
            _loc3_ = 0;
            while(_loc3_ < _loc4_.length)
            {
               _loc2_ = GetElfFactor.getElfVO(_loc4_[_loc3_].spId);
               _loc2_.id = _loc4_[_loc3_].id;
               _loc2_.currentHp = _loc4_[_loc3_].hp;
               _loc2_.totalHp = _loc4_[_loc3_].zHp;
               _loc2_.lv = _loc4_[_loc3_].lv;
               _loc2_.power = _loc4_[_loc3_].attack;
               KingKwanMedia.kingPlayElf.push(_loc2_);
               _loc3_++;
            }
            sendNotification("SHOW_COMPLAY_ELF");
         }
      }
      
      private function initAllElfVo() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < NPCVO.bagElfVec.length)
         {
            if(NPCVO.bagElfVec[_loc2_] != null)
            {
               initElfVo(NPCVO.bagElfVec[_loc2_]);
            }
            _loc2_++;
         }
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc1_] != null)
            {
               PlayerVO.bagElfVec[_loc1_].status = [];
            }
            _loc1_++;
         }
      }
      
      private function initElfVo(param1:ElfVO) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         FightingLogicFactor.replyChange(param1);
         param1.ablilityAddLv = [0,0,0,0,0,0,0];
         if(param1.status.indexOf(13) != -1)
         {
            CalculatorFactor.calculatorElf(param1);
            param1.currentHp = param1.hpBeforeAvatars;
            param1.status.splice(param1.status.indexOf(13));
         }
         if(param1.status.indexOf(29) != -1)
         {
            param1.status.splice(param1.status.indexOf(29),1);
            if(param1.currentSkill != null && param1.currentSkill.name == "连切")
            {
               _loc2_ = GetElfFactor.getSkillById(param1.currentSkill.id);
               param1.currentSkill.power = _loc2_.power;
               _loc2_ = null;
            }
         }
         _loc3_ = 7;
         while(_loc3_ < 44)
         {
            if(param1.status.indexOf(_loc3_) != -1)
            {
               _loc4_ = param1.status.indexOf(_loc3_);
               param1.status.splice(_loc4_,1);
            }
            _loc3_++;
         }
         if(param1.copykillIndex != -1)
         {
            param1.currentSkillVec[param1.copykillIndex] = null;
            param1.currentSkillVec[param1.copykillIndex] = param1.recordSkBeforeCopy;
            param1.copykillIndex = -1;
         }
         param1.isCannotActStatus = false;
         param1.isStoreGas = false;
         if(param1.currentSkill)
         {
            param1.currentSkill.continueSkillCount = 0;
         }
         param1.currentSkill = null;
         param1.isShareExp = false;
         param1.skillBeforeStrone = null;
         param1.skillFinalUseId = 0;
         param1.tolerHurt = 0;
         param1.lastHurtOfPhysics = 0;
         param1.lastHurtOfSpecial = 0;
         param1.isReleaseAnger = false;
         param1.hasUseDefense = false;
         param1.isUsedPropOfBandage = false;
         param1.skillOfFirstSelect = null;
         param1.eyeCount = 0;
         param1.hurtNum = 0;
         param1.sleepCount = "0";
         param1.mullCount = 0;
         param1.boundCount = 0;
         param1.stoneCount = 0;
         param1.fogCount = 0;
         param1.tolerCount = 0;
         param1.lessHurtCount = 0;
         param1.protectCount = 0;
         param1.powerCount = 0;
         param1.inciteCount = 0;
         param1.prayCount = 0;
         param1.yawnCount = 0;
         param1.blightCount = 0;
         param1.blightHurt = 0;
         param1.storeNum = "0";
         CalculatorFactor.calculatorElf(param1);
      }
      
      public function write2310() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 2310;
         client.sendBytes(_loc1_);
      }
      
      public function note2310(param1:Object) : void
      {
         LogUtil("note2310: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.goods)
            {
               sendNotification("show_score_shop_goods",param1.data);
               sendNotification("update_score_shop_scoreTf",param1.data.kwDot);
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
      
      public function write2311(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 2311;
         _loc2_.goodsId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note2311(param1:Object) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         LogUtil("note2311=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            Tips.show("兑换成功。");
            sendNotification("remove_score_goods");
            sendNotification("update_score_shop_scoreTf",param1.data.kwDot);
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
      
      public function write2312() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 2312;
         client.sendBytes(_loc1_);
      }
      
      public function note2312(param1:Object) : void
      {
         LogUtil("note2312=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.goods)
            {
               sendNotification("show_score_shop_goods",param1.data);
            }
            sendNotification("update_score_shop_scoreTf",param1.data.kwDot);
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
      
      public function write2313() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 2313;
         client.sendBytes(_loc1_);
      }
      
      public function note2313(param1:Object) : void
      {
         LogUtil("note2313= " + JSON.stringify(param1));
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
            write2300();
            sendNotification("HIDE_MOP_UP");
         }
      }
   }
}
