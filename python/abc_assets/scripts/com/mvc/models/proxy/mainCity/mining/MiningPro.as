package com.mvc.models.proxy.mainCity.mining
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.mvc.models.vos.mainCity.mining.MiningVO;
   import com.common.managers.LoadOtherAssetsManager;
   import com.common.net.Client;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import com.common.events.EventCenter;
   import com.mvc.views.mediator.mainCity.mining.MiningFrameMediator;
   import com.mvc.views.uis.mainCity.mining.MiningConfig;
   import com.mvc.views.uis.worldHorn.WorldTime;
   import com.mvc.views.mediator.mainCity.mining.MiningCheckFormatMediator;
   import com.mvc.views.uis.mainCity.mining.MiningCheckFormatUI;
   import com.common.net.CheckNetStatus;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.common.util.RewardHandle;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.views.mediator.mainCity.elfSeries.SelePlayElfMedia;
   import com.mvc.views.uis.mainCity.elfSeries.SelePlayElfUI;
   import com.common.util.xmlVOHandler.GetElfFromSever;
   import com.mvc.models.vos.fighting.NPCVO;
   import com.mvc.views.uis.mainCity.mining.MiningInfoPage;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.common.util.fighting.GotoChallenge;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   
   public class MiningPro extends Proxy
   {
      
      public static const NAME:String = "Miningpro";
      
      public static var pageEndTime:int;
      
      public static var miningVOVec:Vector.<MiningVO> = new Vector.<MiningVO>([]);
      
      private static var miningFightBg:String;
      
      public static var isShowMineNews:Boolean;
      
      public static var isShowDefendNews:Boolean;
       
      private var client:Client;
      
      private var npcObject:Object;
      
      private var npcUserId:String;
      
      private var isReturnToMining:Boolean;
      
      private var getPowerCallBack:Function;
      
      public function MiningPro(param1:Object = null)
      {
         super("Miningpro",param1);
         client = Client.getInstance();
         client.addCallObj("note3900",this);
         client.addCallObj("note3901",this);
         client.addCallObj("note3902",this);
         client.addCallObj("note3903",this);
         client.addCallObj("note3904",this);
         client.addCallObj("note3905",this);
         client.addCallObj("note3906",this);
         client.addCallObj("note3907",this);
         client.addCallObj("note3908",this);
         client.addCallObj("note3909",this);
         client.addCallObj("note3910",this);
         client.addCallObj("note3911",this);
         client.addCallObj("note3912",this);
         client.addCallObj("note3913",this);
      }
      
      public static function removeMiningBgAssets() : void
      {
         var _loc1_:Array = ["miningBg1","miningBg2","miningBg3","miningBg4"];
         if(_loc1_.indexOf(MiningPro.miningFightBg) != -1)
         {
            _loc1_.splice(_loc1_.indexOf(MiningPro.miningFightBg),1);
         }
         LogUtil("移除挖矿背景图bgAssetsArr： " + _loc1_);
         LoadOtherAssetsManager.getInstance().removeAsset(_loc1_,false);
         MiningPro.miningFightBg = "";
      }
      
      public function write3900() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 3900;
         client.sendBytes(_loc1_);
      }
      
      public function note3900(param1:Object) : void
      {
         LogUtil("note3900: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.spiritIdArr)
            {
               PlayerVO.miningDefendElfArr = param1.data.spiritIdArr;
            }
            if(param1.data.hint)
            {
               MiningPro.isShowMineNews = true;
               sendNotification("show_mine_draw");
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write3901(param1:Boolean = false) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 3901;
         _loc2_.isShow = param1;
         client.sendBytes(_loc2_);
      }
      
      private function loadMiningPrepare() : void
      {
         bg_loadCompleteHandler = function():void
         {
            EventCenter.removeEventListener("load_other_asset_complete",bg_loadCompleteHandler);
            sendNotification("switch_page","load_mining_page");
         };
         if(MiningPro.miningVOVec.length)
         {
            var bgName:String = "miningBg" + MiningPro.miningVOVec[0].type;
         }
         else
         {
            bgName = "miningBg4";
         }
         EventCenter.addEventListener("load_other_asset_complete",bg_loadCompleteHandler);
         LoadOtherAssetsManager.getInstance().addMiningBgAssets(bgName);
      }
      
      public function note3901(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = null;
         LogUtil("note3901: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            MiningPro.isShowMineNews = false;
            MiningPro.isShowDefendNews = false;
            if(param1.data.isShowHint)
            {
               MiningPro.isShowDefendNews = true;
            }
            MiningFrameMediator.exportPay = param1.data.needSilver;
            MiningFrameMediator.breadNum = param1.data.breadNum;
            MiningPro.miningVOVec = Vector.<MiningVO>([]);
            if(param1.data.info)
            {
               _loc2_ = param1.data.info;
               _loc4_ = 0;
               while(_loc4_ < _loc2_.length)
               {
                  _loc3_ = new MiningVO();
                  _loc3_.id = _loc2_[_loc4_].mineId;
                  _loc3_.severId = _loc2_[_loc4_].controlId;
                  _loc3_.type = _loc2_[_loc4_].mineType;
                  _loc3_.speed = _loc2_[_loc4_].perRes;
                  _loc3_.totalNum = _loc2_[_loc4_].sumRes;
                  _loc3_.startTime = _loc2_[_loc4_].createTime;
                  if(param1.data.canGainRes)
                  {
                     _loc3_.endTime = _loc2_[_loc4_].endTime - 1200;
                  }
                  else
                  {
                     _loc3_.endTime = _loc2_[_loc4_].endTime;
                  }
                  _loc3_.defenderArr = _loc2_[_loc4_].userIdArr;
                  _loc3_.lootNum = _loc2_[_loc4_].canGainRes;
                  _loc3_.nextCoin = param1.data.nextCoin;
                  _loc3_.name = MiningConfig.getName(_loc3_.endTime - _loc3_.startTime,_loc3_.type);
                  _loc3_.isComplete = _loc3_.endTime - WorldTime.getInstance().serverTime <= 0?true:false;
                  MiningPro.miningVOVec.push(_loc3_);
                  if(_loc3_.isComplete || isShowDefendNews)
                  {
                     MiningPro.isShowMineNews = true;
                  }
                  _loc4_++;
               }
               loadMiningPrepare();
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write3902(param1:int, param2:int, param3:String) : void
      {
         var _loc4_:Object = {};
         _loc4_.msgId = 3902;
         _loc4_.controlId = param1;
         _loc4_.mineId = param2;
         _loc4_.userId = param3;
         client.sendBytes(_loc4_);
      }
      
      public function note3902(param1:Object) : void
      {
         LogUtil("note3902: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(!facade.hasMediator("MiningCheckFormatMediator"))
            {
               facade.registerMediator(new MiningCheckFormatMediator(new MiningCheckFormatUI()));
            }
            sendNotification("switch_win",null,"mining_load_view_camp_win");
            sendNotification("mining_update_format_info",param1.data);
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write3903(param1:int, param2:int, param3:Array) : void
      {
         var _loc4_:Object = {};
         _loc4_.msgId = 3903;
         _loc4_.mineType = param1;
         _loc4_.times = param2;
         _loc4_.spiritIdArr = param3;
         client.sendBytes(_loc4_);
      }
      
      public function note3903(param1:Object) : void
      {
         var _loc2_:* = null;
         LogUtil("note3903: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.info)
            {
               _loc2_ = new MiningVO();
               _loc2_.id = param1.data.info.mineId;
               _loc2_.severId = param1.data.info.controlId;
               _loc2_.type = param1.data.info.mineType;
               _loc2_.speed = param1.data.info.perRes;
               _loc2_.totalNum = param1.data.info.sumRes;
               _loc2_.startTime = param1.data.info.createTime;
               if(param1.data.info.canGainRes)
               {
                  _loc2_.endTime = param1.data.info.endTime - 1200;
               }
               else
               {
                  _loc2_.endTime = param1.data.info.endTime;
               }
               _loc2_.defenderArr = param1.data.info.userIdArr;
               _loc2_.lootNum = param1.data.info.canGainRes;
               _loc2_.nextCoin = param1.data.nextCoin;
               _loc2_.name = MiningConfig.getName(_loc2_.endTime - _loc2_.startTime,_loc2_.type);
               MiningPro.miningVOVec.push(_loc2_);
               sendNotification("mining_create_info_page",_loc2_);
            }
            if(param1.data.spiritIdArr)
            {
               PlayerVO.miningDefendElfArr = param1.data.spiritIdArr;
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write3904() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 3904;
         client.sendBytes(_loc1_);
      }
      
      public function note3904(param1:Object) : void
      {
         var _loc2_:* = null;
         LogUtil("note3904: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            MiningFrameMediator.exportPay = param1.data.nextCoin;
            _loc2_ = new MiningVO();
            _loc2_.id = param1.data.mineId;
            _loc2_.severId = param1.data.controlId;
            _loc2_.type = param1.data.mineType;
            _loc2_.speed = param1.data.perRes;
            _loc2_.totalNum = param1.data.sumRes;
            _loc2_.startTime = param1.data.createTime;
            if(param1.data.canGainRes)
            {
               _loc2_.endTime = param1.data.endTime - 1200;
            }
            else
            {
               _loc2_.endTime = param1.data.endTime;
            }
            _loc2_.defenderArr = param1.data.userIdArr;
            _loc2_.lootNum = param1.data.canGainRes;
            _loc2_.nextCoin = param1.data.nextCoin;
            _loc2_.name = MiningConfig.getName(_loc2_.endTime - _loc2_.startTime,_loc2_.type);
            MiningPro.miningVOVec.push(_loc2_);
            sendNotification("mining_explort_complete",_loc2_);
            sendNotification("update_play_money_info",param1.data.silver);
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write3905() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 3905;
         client.sendBytes(_loc1_);
      }
      
      public function note3905(param1:Object) : void
      {
         LogUtil("note3905: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.defendLogs)
            {
               if((param1.data.defendLogs as Array).length == 0)
               {
                  return Tips.show("暂无记录");
               }
               sendNotification("mining_update_defendrecord_list",param1.data.defendLogs);
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write3906(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 3906;
         _loc2_.mineId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note3906(param1:Object) : void
      {
         LogUtil("note3906: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            CheckNetStatus.miningDefendInviteHandler();
            write3901(true);
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write3907(param1:int, param2:String, param3:Array) : void
      {
         var _loc4_:Object = {};
         _loc4_.msgId = 3907;
         _loc4_.mineId = param1;
         _loc4_.fromUserId = param2;
         _loc4_.spiritIdArr = param3;
         client.sendBytes(_loc4_);
      }
      
      public function note3907(param1:Object) : void
      {
         LogUtil("note3907: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            sendNotification("mining_adjust_format_complete",param1.data);
            sendNotification("mining_occupy_complete");
            if(param1.data.spiritIdArr)
            {
               PlayerVO.miningDefendElfArr = param1.data.spiritIdArr;
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write3908(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 3908;
         _loc2_.mineId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note3908(param1:Object) : void
      {
         LogUtil("note3908: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            Facade.getInstance().sendNotification("mining_update_pagevec");
            RewardHandle.Reward(param1.data.reward);
            if(param1.data.spiritIdArr)
            {
               PlayerVO.miningDefendElfArr = param1.data.spiritIdArr;
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write3909(param1:int, param2:Array) : void
      {
         var _loc3_:Object = {};
         _loc3_.msgId = 3909;
         _loc3_.mineId = param1;
         _loc3_.spiritIdArr = param2;
         client.sendBytes(_loc3_);
      }
      
      public function note3909(param1:Object) : void
      {
         LogUtil("note3909: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            sendNotification("mining_adjust_format_complete",param1.data);
            if(param1.data.spiritIdArr)
            {
               PlayerVO.miningDefendElfArr = param1.data.spiritIdArr;
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write3910(param1:String) : void
      {
         npcUserId = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 3910;
         client.sendBytes(_loc2_);
      }
      
      public function note3910(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = 0;
         var _loc4_:* = null;
         LogUtil("note3910: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.spirits)
            {
               MiningConfig.miningFightElfVec = Vector.<ElfVO>([]);
               _loc2_ = param1.data.spirits;
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  _loc4_ = GetElfFactor.getElfVO(_loc2_[_loc3_].spId,false);
                  _loc4_.id = _loc2_[_loc3_].id;
                  _loc4_.lv = _loc2_[_loc3_].lv;
                  _loc4_.currentHp = _loc2_[_loc3_].hp;
                  _loc4_.totalHp = _loc2_[_loc3_].zHp;
                  _loc4_.power = _loc2_[_loc3_].attack;
                  _loc4_.starts = _loc2_[_loc3_].star;
                  _loc4_.brokenLv = _loc2_[_loc3_].bkLv;
                  _loc4_.status = _loc2_[_loc3_].stateAry;
                  MiningConfig.miningFightElfVec.push(_loc4_);
                  _loc3_++;
               }
               if(!facade.hasMediator("SelePlayElfMedia"))
               {
                  facade.registerMediator(new SelePlayElfMedia(new SelePlayElfUI()));
               }
               sendNotification("SEND_RIVAL_DATA",null,"挖矿");
               sendNotification("switch_win",null,"LOAD_SERIES_PLAYELF");
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write3911(param1:Array) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 3911;
         _loc2_.userId = npcUserId;
         _loc2_.spiritIdArr = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note3911(param1:Object) : void
      {
         var _loc5_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = 0;
         var _loc2_:* = null;
         LogUtil("note3911: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.oppSpirits == null || (param1.data.oppSpirits as Array).length == 0)
            {
               return Tips.show("挖矿对手精灵数据异常");
            }
            _loc5_ = param1.data.oppSpirits;
            MiningConfig.collectNpcElf(_loc5_);
            _loc3_ = param1.data.ownSpriits;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc2_ = GetElfFromSever.getElfInfo(_loc3_[_loc4_]);
               PlayerVO.bagElfVec[_loc4_] = null;
               PlayerVO.bagElfVec[_loc4_] = _loc2_;
               _loc4_++;
            }
            if(param1.data.oppGuild)
            {
               NPCVO.unionAttackAdd = param1.data.oppGuild.guildAttackAddition;
               NPCVO.unionDefenseAdd = param1.data.oppGuild.guildDefenseAddition;
            }
            npcObject = param1.data.oppPlayerInfo;
            if(MiningFrameMediator.nowPage is MiningInfoPage)
            {
               miningFightBg = (MiningFrameMediator.nowPage as MiningInfoPage).bgName;
               FightingConfig.sceneName = miningFightBg;
            }
            FightingConfig.fightingAI = 1;
            GotoChallenge.gotoChallenge(npcObject.userName,"player0" + npcObject.trainPtId.substr(5),MiningConfig.miningNpcElfVec,false,npcObject.userId,200,false);
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
            FightingConfig.reGetBagElf();
         }
      }
      
      public function write3912(param1:int, param2:Boolean = true) : void
      {
         isReturnToMining = param2;
         var _loc4_:Object = {};
         _loc4_.msgId = 3912;
         _loc4_.oppUserId = npcObject.userId;
         _loc4_.isWin = param1;
         var _loc3_:Object = MiningConfig.collectElfAfterFight();
         _loc4_.ownSpiritStatus = _loc3_.elfInfoArr;
         _loc4_.oppSpiritStatus = _loc3_.enemyArr;
         client.sendBytes(_loc4_);
         LogUtil("write3912: " + JSON.stringify(_loc4_));
         FightingConfig.reGetBagElf();
      }
      
      public function note3912(param1:Object) : void
      {
         var _loc2_:* = null;
         LogUtil("note3912: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            MiningFrameMediator.breadNum = param1.data.breadNum;
            if(param1.data.reward)
            {
               MiningFrameMediator.miningReward = param1.data.reward;
            }
         }
         else if(param1.status == "fail")
         {
            _loc2_ = Alert.show(param1.data.msg,"",new ListCollection([{"label":"真遗憾"}]));
         }
         if(isReturnToMining)
         {
            write3901();
         }
      }
      
      public function write3913(param1:int, param2:Function) : void
      {
         getPowerCallBack = param2;
         var _loc3_:Object = {};
         _loc3_.msgId = 3913;
         _loc3_.index = param1;
         client.sendBytes(_loc3_);
      }
      
      public function note3913(param1:Object) : void
      {
         LogUtil("note3913: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            Tips.show("挖矿能量领取成功");
            MiningFrameMediator.breadNum = param1.data.breadNum;
            sendNotification("mining_get_power_complete");
            if(getPowerCallBack)
            {
               getPowerCallBack();
               getPowerCallBack = null;
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
   }
}
