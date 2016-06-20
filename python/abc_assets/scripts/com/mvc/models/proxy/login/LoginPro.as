package com.mvc.models.proxy.login
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.common.net.Client;
   import com.common.util.loading.NETLoading;
   import flash.events.Event;
   import com.common.util.loading.GameLoading;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.events.EventCenter;
   import com.common.managers.LoadOtherAssetsManager;
   import com.common.util.dialogue.NPCDialogue;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import feathers.controls.Alert;
   import com.mvc.views.uis.worldHorn.WorldTime;
   import com.mvc.models.vos.login.PlayerVO;
   import lzm.util.LSOManager;
   import com.mvc.views.mediator.mainCity.elfSeries.ElfSeriesMedia;
   import com.mvc.models.proxy.mainCity.specialAct.SpecialActPro;
   import com.mvc.models.vos.mainCity.elfSeries.SeriesVO;
   import com.mvc.models.proxy.mainCity.kingKwan.KingKwanPro;
   import com.common.util.xmlVOHandler.GetLvExp;
   import com.common.util.xmlVOHandler.GetVIP;
   import com.mvc.views.uis.login.startChat.StartChatUI;
   import feathers.data.ListCollection;
   import com.common.themes.Tips;
   import com.common.net.CheckNetStatus;
   import com.common.managers.SoundManager;
   import com.mvc.models.vos.elf.ElfVO;
   import com.massage.ane.UmengExtension;
   import com.common.util.xmlVOHandler.GetMapFactor;
   import com.mvc.models.proxy.union.UnionPro;
   import com.mvc.models.proxy.mainCity.backPack.BackPackPro;
   import com.mvc.models.proxy.mainCity.task.TaskPro;
   import com.mvc.models.proxy.mainCity.playerInfo.PlayInfoPro;
   import com.mvc.models.proxy.mainCity.friend.FriendPro;
   import com.mvc.models.proxy.mainCity.elfSeries.ElfSeriesPro;
   import com.mvc.models.proxy.mainCity.information.InformationPro;
   import com.mvc.models.proxy.Illustrations.IllustrationsPro;
   import com.mvc.models.proxy.mainCity.amuse.AmusePro;
   import com.mvc.models.proxy.mainCity.chat.ChatPro;
   import com.mvc.models.proxy.mainCity.active.ActivePro;
   import com.mvc.models.proxy.mainCity.sign.SignPro;
   import com.mvc.models.proxy.mainCity.train.TrainPro;
   import com.mvc.models.proxy.mainCity.growthPlan.GrowthPlanPro;
   import com.mvc.models.proxy.mainCity.hunting.HuntingPro;
   import com.mvc.models.proxy.mainCity.home.HomePro;
   import com.mvc.models.proxy.mainCity.mining.MiningPro;
   import com.common.util.xmlVOHandler.GetElfFromSever;
   import com.common.util.GetCommon;
   import com.mvc.views.mediator.mainCity.active.ActiveMeida;
   import com.mvc.views.mediator.mainCity.information.MailMedia;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.uis.mainCity.information.MailUI;
   import flash.utils.clearTimeout;
   import com.mvc.views.uis.mainCity.pvp.PVPBgUI;
   import com.mvc.views.mediator.mainCity.pvp.PVPBgMediator;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import com.mvc.views.mediator.mainCity.pvp.PVPPracticeMediator;
   import com.mvc.views.uis.fighting.FightingUI;
   import com.mvc.views.mediator.fighting.FightingMedia;
   import com.mvc.controllers.LoadPageCmd;
   import com.mvc.views.uis.mainCity.kingKwan.KingKwanUI;
   import com.mvc.views.uis.mainCity.elfSeries.ElfSeriesUI;
   import com.mvc.views.uis.mainCity.trial.TrialUI;
   import com.mvc.views.uis.mainCity.mining.MiningFrameUI;
   import com.mvc.models.proxy.fighting.FightingPro;
   import com.mvc.models.proxy.mapSelect.MapPro;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.mvc.views.mediator.fighting.FightingLogicFactor;
   import com.common.util.dialogue.Dialogue;
   import com.mvc.GameFacade;
   import com.common.consts.ConfigConst;
   import flash.desktop.NativeApplication;
   import com.mvc.models.vos.fighting.NPCVO;
   
   public class LoginPro extends Proxy
   {
      
      public static const NAME:String = "LoginPro";
      
      private static var client:Client;
      
      public static var logining:Boolean;
      
      public static var isConnect:Boolean;
      
      public static var isLoginSuccess:Boolean;
      
      public static var isMaintenance:Boolean;
       
      public function LoginPro(param1:Object = null)
      {
         super("LoginPro",param1);
      }
      
      override public function onRegister() : void
      {
         client = Client.getInstance();
         client.connect(data.ip,data.port);
         NETLoading.addLoading();
         client._port = data.port;
         client._host = data.ip;
         client.addCallObj("note1000",this);
         client.addCallObj("note1002",this);
         client.addCallObj("note1004",this);
         client.addCallObj("note1005",this);
         client.addCallObj("note1010",this);
         client.addCallObj("note1011",this);
         client.addCallObj("note1161",this);
         client.addCallObj("note1107",this);
         client.addCallObj("note1009",this);
         client.addEventListener("CONNECT_COMPLETE",onComplete);
      }
      
      protected function onComplete(param1:flash.events.Event) : void
      {
         NETLoading.removeLoading();
         GameLoading.getIntance().showLoading(loadGameAssets);
      }
      
      private function loadGameAssets() : void
      {
         if(LoadSwfAssetsManager.getInstance().assets.getSwf("common") == null)
         {
            EventCenter.addEventListener("load_swf_asset_complete",gotoMainCity);
            LoadOtherAssetsManager.getInstance().addGotoGameAssets();
         }
         else
         {
            write1002();
         }
         client.removeEventListener("CONNECT_COMPLETE",onComplete);
      }
      
      private function gotoMainCity() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",gotoMainCity);
         NPCDialogue.init();
         GetElfFactor.getAllSpeciality();
         GetElfFactor.getAllElfVO();
         GetPropFactor.getAllPropVO();
         GetElfFactor.getAllSkillVO();
         GetPropFactor.initShopList();
         write1002();
      }
      
      public function write1002() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 1002;
         if(Pocketmon._channel != 0)
         {
            _loc1_.token = Pocketmon.sdkTool.token;
            _loc1_.platform = Pocketmon.sdkTool.platform;
         }
         else
         {
            _loc1_.token = data.key;
            _loc1_.platform = "mc";
         }
         _loc1_.deviceTokens = Game.token;
         client.sendBytes(_loc1_,false);
         LogUtil("1002发送数据=" + JSON.stringify(_loc1_));
         isLoginSuccess = false;
      }
      
      public function note1002(param1:Object) : void
      {
         object = param1;
         LogUtil("object1002=" + JSON.stringify(object));
         if(object.status == "success")
         {
            logining = true;
            if(object.data.playerStatus == 0)
            {
               LogUtil("掉线，重新登陆");
            }
            if(object.data.playerStatus == 1)
            {
               LogUtil("登陆成功");
               if(object.data.nodeIdArr)
               {
                  GetPropFactor.evoStonePlaceArr = object.data.nodeIdArr;
               }
               WorldTime.getInstance().serverTime = object.data.sevDate;
               LogUtil("服务器的时间= ",object.data.sevDate);
               PlayerVO.userId = object.data.playerInfo.userId;
               PlayerVO.nickName = object.data.playerInfo.userName;
               PlayerVO.isFirstChangeName = object.data.playerInfo.isFirstChangeName;
               PlayerVO.sex = object.data.playerInfo.sex;
               PlayerVO.headPtId = object.data.playerInfo.headPtId;
               PlayerVO.trainPtId = object.data.playerInfo.trainPtId;
               xiaomaoElfId(object.data.playerInfo.firstPokeStaId);
               PlayerVO.lv = object.data.playerInfo.lv;
               PlayerVO.silver = object.data.playerInfo.silver;
               PlayerVO.diamond = object.data.playerInfo.diamond;
               PlayerVO.actionForce = object.data.playerInfo.actionForce;
               PlayerVO.vipRank = object.data.playerInfo.vipRank;
               PlayerVO.isBuyMonCard = object.data.playerInfo.buyMonCard;
               PlayerVO.monCardNum = object.data.playerInfo.monCardNum;
               PlayerVO.guideProgress = object.data.playerInfo.guideProgress;
               PlayerVO.recruitTimes = object.data.playerInfo.recruitTimes;
               PlayerVO.getRechargeIdArr(object.data.playerInfo.payLog);
               Config.isCompleteBeginner = object.data.playerInfo.isCompleteBeginner;
               if(Config.isCompleteBeginner)
               {
                  LSOManager.put("isCompleteChange",true);
                  Config.isCompleteCatchElf = true;
               }
               else
               {
                  Config.isCompleteCatchElf = false;
               }
               Config.isCompleteRestrain = object.data.playerInfo.isCompleteRestrain;
               ElfSeriesMedia.isNew = object.data.playerInfo.isSeries;
               PlayerVO.payCount = object.data.playerInfo.payNum;
               if(object.data.atvStatus)
               {
                  SpecialActPro.isDiaOpen = object.data.atvStatus.atvDia;
                  SpecialActPro.isLightOpen = object.data.atvStatus.atvFla;
                  SpecialActPro.isDayHappyOpen = object.data.atvStatus.atvDay;
                  SpecialActPro.isLimitSpecialElfOpen = object.data.atvStatus.atvLimit;
                  SpecialActPro.isPreferOpen = object.data.atvStatus.atvGift;
                  SpecialActPro.isLottery = object.data.atvStatus.atvLot;
               }
               PlayerVO.vipExper = object.data.playerInfo.vipExper;
               PlayerVO.maxFriendNum = object.data.playerInfo.maxFriendNum;
               PlayerVO.maxActionForce = object.data.playerInfo.maxActionForce;
               PlayerVO.exper = object.data.playerInfo.exper;
               PlayerVO.badgeNum = object.data.playerInfo.badge;
               PlayerVO.pokeSpace = object.data.playerInfo.pokeSpace;
               PlayerVO.cpSpace = object.data.playerInfo.cpSpace;
               SeriesVO.remainCount = object.data.playerInfo.rankBuyTime;
               LogUtil("背包的空间大小=" + PlayerVO.pokeSpace,PlayerVO.cpSpace);
               PlayerVO.trainSpace = object.data.playerInfo.trainSpace;
               PlayerVO.kingIsOpen = object.data.playerInfo.isStartKingWay;
               if(PlayerVO.kingIsOpen)
               {
                  (facade.retrieveProxy("KingKwanPro") as KingKwanPro).write2305();
               }
               if(GetLvExp.elfGradeExp.length == 0)
               {
                  PlayerVO.playerLvVoVec = GetLvExp.getPlayerLvVoVec();
               }
               PlayerVO.vipInfoVO = GetVIP.getVIP(object.data.playerInfo.vipRank);
               PlayerVO.vipInfoVO.remainAlliance = object.data.vip._alliance;
               PlayerVO.vipInfoVO.remainBuyAcFr = object.data.vip._buyAcFr;
               PlayerVO.vipInfoVO.remainGoldFinger = object.data.vip._goldFinger;
               PlayerVO.vipInfoVO.remainKingRoad = object.data.vip._kingRoad;
               PlayerVO.vipInfoVO.remainPmCenter = object.data.vip._pmCenter;
               PlayerVO.vipInfoVO.remainSweep = object.data.vip._sweep;
               if(!Config.isCompleteBeginner && !((Config.starling.root as Game).page is StartChatUI))
               {
                  var loadVoiceComplete:Function = function():void
                  {
                     EventCenter.removeEventListener("load_other_asset_complete",loadVoiceComplete);
                     sendNotification("switch_page","load_maincity_page");
                     EventCenter.addEventListener("CREATE_CITY_COMPLETE",message);
                  };
                  EventCenter.addEventListener("load_other_asset_complete",loadVoiceComplete);
                  LoadOtherAssetsManager.getInstance().addAssets(["music/beginGuideVoice"]);
               }
               else
               {
                  sendNotification("switch_page","load_maincity_page");
                  EventCenter.addEventListener("CREATE_CITY_COMPLETE",message);
               }
            }
            if(object.data.playerStatus == 2)
            {
               tipNew();
            }
            if(object.data.playerStatus == 4)
            {
               Alert.show("服务器维护中","");
            }
            if(object.data.playerStatus == 5)
            {
               var loginAlert:Alert = Alert.show("尊敬的训练师，本区已异常火爆！请您选择最新区，那里将是您的乐园","温馨提示",new ListCollection([{"label":"确定"}]));
               loginAlert.addEventListener("close",loginAlertHander);
            }
         }
         else if(object.status == "fail")
         {
            Tips.show(object.data.msg);
            client.close();
            CheckNetStatus.otherLogin(object.data.msg);
         }
      }
      
      private function loginAlertHander(param1:starling.events.Event, param2:Object) : void
      {
         if(param1.data.label == "确定")
         {
            GameLoading.getIntance().removeLoading();
         }
      }
      
      private function setDefaultSetting() : void
      {
         if(LSOManager.has("BGMusic"))
         {
            LSOManager.put("BGMusic",true);
            SoundManager.BGSwitch = LSOManager.get("BGMusic");
         }
         if(LSOManager.has("SEMusic"))
         {
            LSOManager.put("SEMusic",true);
            SoundManager.SESwitch = LSOManager.get("SEMusic");
         }
         if(LSOManager.has("isOpenCartoon"))
         {
            LSOManager.put("isOpenCartoon",true);
            Config.isOpenAni = LSOManager.get("isOpenCartoon");
         }
         if(LSOManager.has("isGetPower"))
         {
            LSOManager.put("isGetPower",true);
            Config.getPowerSwitch = LSOManager.get("isGetPower");
         }
         if(LSOManager.has("isPrivateChat"))
         {
            LSOManager.put("isPrivateChat",true);
            Config.privateChaSwitch = LSOManager.get("isPrivateChat");
         }
         if(LSOManager.has("isSeriesAttack"))
         {
            LSOManager.put("isSeriesAttack",true);
            Config.seriesAttackSwitch = LSOManager.get("isSeriesAttack");
         }
         if(LSOManager.has("isAutoFightSave"))
         {
            LSOManager.put("isAutoFightSave",false);
            Config.isAutoFighting = LSOManager.get("isAutoFightSave");
         }
         if(LSOManager.has("isAutoFightUsePropSave"))
         {
            LSOManager.put("isAutoFightUsePropSave",false);
            Config.isAutoFightingUseProp = LSOManager.get("isAutoFightUsePropSave");
         }
         if(LSOManager.has("isPvpInviteSureSave"))
         {
            LSOManager.put("isPvpInviteSureSave",true);
            Config.isPvpInviteSure = LSOManager.get("isPvpInviteSureSave");
         }
         if(LSOManager.has("isOpenFightingAniSave"))
         {
            LSOManager.put("isOpenFightingAniSave",true);
            Config.isOpenFightingAni = LSOManager.get("isOpenFightingAniSave");
         }
      }
      
      private function tipNew() : void
      {
         WorldTime.getInstance().serverTime = new Date().getTime();
         PlayerVO.nickName = "新手" + Math.random() * 10000;
         PlayerVO.headPtId = 100001;
         PlayerVO.trainPtId = 100001;
         PlayerVO.sex = 1;
         var _loc1_:ElfVO = GetElfFactor.getElfVO("1");
         PlayerVO.bagElfVec[0] = _loc1_;
         PlayerVO.bagElfVec[0].nickName = "跳新手的精灵";
         write1010();
         write1011();
         write1161(true,true,true);
         write1002();
      }
      
      private function message() : void
      {
         LogUtil("主城加载后发送");
         UmengExtension.getInstance().UMAnalysic("userId|" + PlayerVO.userId);
         EventCenter.removeEventListener("CREATE_CITY_COMPLETE",message);
         logining = false;
         write1000();
      }
      
      public function write1000() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 1000;
         client.sendBytes(_loc1_);
      }
      
      public function note1000(param1:Object) : void
      {
         var _loc2_:* = null;
         LogUtil("1000=" + JSON.stringify(param1));
         var _loc53_:* = param1.status;
         if("success" !== _loc53_)
         {
            if("fail" !== _loc53_)
            {
               if("error" === _loc53_)
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
            if(!GetMapFactor.allPropBirthPllace)
            {
               GetMapFactor.getPropBirthplace();
            }
            _loc2_ = param1.data.allRepack;
            if(_loc2_.hasOwnProperty("3413"))
            {
               try
               {
                  (facade.retrieveProxy("UnionPro") as UnionPro).note3413(_loc2_["3413"]);
               }
               catch(error:Error)
               {
                  LogUtil("公会信息获取失败");
               }
            }
            if(_loc2_.hasOwnProperty("2305"))
            {
               try
               {
                  (facade.retrieveProxy("KingKwanPro") as KingKwanPro).note2305(_loc2_["2305"]);
               }
               catch(error:Error)
               {
                  LogUtil("王者之路精灵获取失败");
               }
            }
            if(_loc2_.hasOwnProperty("3000"))
            {
               try
               {
                  (facade.retrieveProxy("BackPackPro") as BackPackPro).note3000(_loc2_["3000"]);
               }
               catch(error:Error)
               {
                  LogUtil("道具获取失败");
               }
            }
            if(_loc2_.hasOwnProperty("1801"))
            {
               try
               {
                  (facade.retrieveProxy("TaskPro") as TaskPro).note1801(_loc2_["1801"]);
               }
               catch(error:Error)
               {
                  LogUtil("任务获取失败");
               }
            }
            if(_loc2_.hasOwnProperty("1106"))
            {
               try
               {
                  (facade.retrieveProxy("PlayInfoPro") as PlayInfoPro).note1106(_loc2_["1106"]);
               }
               catch(error:Error)
               {
                  LogUtil("体力倒计时获取失败");
               }
            }
            if(_loc2_.hasOwnProperty("1401"))
            {
               try
               {
                  (facade.retrieveProxy("FriendPro") as FriendPro).note1401(_loc2_["1401"]);
               }
               catch(error:Error)
               {
                  LogUtil("好友获取失败");
               }
            }
            if(_loc2_.hasOwnProperty("5009"))
            {
               try
               {
                  (facade.retrieveProxy("ElfSeriesPro") as ElfSeriesPro).note5009(_loc2_["5009"]);
               }
               catch(error:Error)
               {
                  LogUtil("联盟大赛防守阵容获取失败");
               }
            }
            if(_loc2_.hasOwnProperty("4203"))
            {
               try
               {
                  (facade.retrieveProxy("InformationPro") as InformationPro).note4203(_loc2_["4203"]);
               }
               catch(error:Error)
               {
                  LogUtil("官方活动获取失败");
               }
            }
            if(_loc2_.hasOwnProperty("4204"))
            {
               try
               {
                  (facade.retrieveProxy("InformationPro") as InformationPro).note4204(_loc2_["4204"]);
               }
               catch(error:Error)
               {
                  LogUtil("官方公告获取失败");
               }
            }
            if(_loc2_.hasOwnProperty("1301"))
            {
               try
               {
                  (facade.retrieveProxy("IllustrationsPro") as IllustrationsPro).note1301(_loc2_["1301"]);
               }
               catch(error:Error)
               {
                  LogUtil("图鉴获取失败");
               }
            }
            if(_loc2_.hasOwnProperty("2500"))
            {
               try
               {
                  (facade.retrieveProxy("AmusePro") as AmusePro).note2500(_loc2_["2500"]);
               }
               catch(error:Error)
               {
                  LogUtil("扭蛋机获取失败");
               }
            }
            if(_loc2_.hasOwnProperty("4200"))
            {
               try
               {
                  (facade.retrieveProxy("InformationPro") as InformationPro).note4200(_loc2_["4200"]);
               }
               catch(error:Error)
               {
                  LogUtil("邮件获取失败");
               }
            }
            if(_loc2_.hasOwnProperty("9005"))
            {
               try
               {
                  (facade.retrieveProxy("ChatPro") as ChatPro).note9005(_loc2_["9005"]);
               }
               catch(error:Error)
               {
                  LogUtil("聊天获取失败");
               }
            }
            if(_loc2_.hasOwnProperty("1901"))
            {
               try
               {
                  (facade.retrieveProxy("ActivePro") as ActivePro).note1901(_loc2_["1901"]);
               }
               catch(error:Error)
               {
                  LogUtil("活动获取失败");
               }
            }
            if(_loc2_.hasOwnProperty("2100"))
            {
               try
               {
                  (facade.retrieveProxy("SignPro") as SignPro).note2100(_loc2_["2100"]);
               }
               catch(error:Error)
               {
                  LogUtil("签到获取失败");
               }
            }
            if(_loc2_.hasOwnProperty("3506"))
            {
               try
               {
                  (facade.retrieveProxy("TrainPro") as TrainPro).note3506(_loc2_["3506"]);
               }
               catch(error:Error)
               {
                  LogUtil("训练位数据获取失败");
               }
            }
            if(_loc2_.hasOwnProperty("1904"))
            {
               try
               {
                  (facade.retrieveProxy("GrowthPlanPro") as GrowthPlanPro).note1904(_loc2_["1904"]);
               }
               catch(error:Error)
               {
                  LogUtil("成长计划获取失败");
               }
            }
            if(_loc2_.hasOwnProperty("1906"))
            {
               try
               {
                  (facade.retrieveProxy("SpecialActivePro") as SpecialActPro).note1906(_loc2_["1906"]);
               }
               catch(error:Error)
               {
                  LogUtil("钻石增值获取失败");
               }
            }
            if(_loc2_.hasOwnProperty("3700"))
            {
               try
               {
                  (facade.retrieveProxy("SpecialActivePro") as SpecialActPro).note3700(_loc2_["3700"]);
               }
               catch(error:Error)
               {
                  LogUtil("在线领取奖励获取失败");
               }
            }
            if(_loc2_.hasOwnProperty("2101"))
            {
               try
               {
                  (facade.retrieveProxy("SignPro") as SignPro).note2101(_loc2_["2101"]);
               }
               catch(error:Error)
               {
                  LogUtil("签到获取失败");
               }
            }
            if(_loc2_.hasOwnProperty("2900"))
            {
               try
               {
                  (facade.retrieveProxy("HuntingPro") as HuntingPro).note2900(_loc2_["2900"]);
               }
               catch(error:Error)
               {
                  LogUtil("精灵狩猎场获取失败");
               }
            }
            if(_loc2_.hasOwnProperty("2000"))
            {
               try
               {
                  (facade.retrieveProxy("HomePro") as HomePro).note2000(_loc2_["2000"]);
               }
               catch(error:Error)
               {
                  LogUtil("玩家的家背包精灵获取失败");
               }
            }
            if(_loc2_.hasOwnProperty("2001"))
            {
               try
               {
                  (facade.retrieveProxy("HomePro") as HomePro).note2001(_loc2_["2001"]);
               }
               catch(error:Error)
               {
                  LogUtil("玩家的家电脑精灵获取失败");
               }
            }
            if(_loc2_.hasOwnProperty("3900"))
            {
               try
               {
                  (facade.retrieveProxy("Miningpro") as MiningPro).note3900(_loc2_["3900"]);
               }
               catch(error:Error)
               {
                  LogUtil("挖矿防守精灵获取失败");
               }
            }
            if(_loc2_.hasOwnProperty("4206"))
            {
               try
               {
                  (facade.retrieveProxy("SpecialActivePro") as SpecialActPro).note4206(_loc2_["4206"]);
               }
               catch(error:Error)
               {
                  LogUtil("活动预览信息获取失败");
               }
            }
            if(Config.isCompleteBeginner && SpecialActPro.showActPreview)
            {
               sendNotification("switch_win",null,"load_actpreview_win");
            }
            if(Config.isCompleteBeginner)
            {
               Pocketmon.sdkTool.subInfo("0");
            }
            else
            {
               Pocketmon.sdkTool.subInfo("1");
               Pocketmon.sdkTool.subInfo("0");
               UmengExtension.getInstance().UMAnalysic("setPlayerLevel|1");
            }
            isLoginSuccess = true;
         }
      }
      
      public function write1010() : void
      {
         LoginPro.logining = false;
         var _loc1_:Object = {};
         _loc1_.msgId = 1010;
         _loc1_.userName = PlayerVO.nickName;
         _loc1_.headPtId = PlayerVO.headPtId;
         _loc1_.trainPtId = PlayerVO.trainPtId;
         _loc1_.sex = PlayerVO.sex;
         _loc1_.spriteId = PlayerVO.bagElfVec[0].elfId;
         _loc1_.spritName = PlayerVO.bagElfVec[0].nickName;
         client.sendBytes(_loc1_);
      }
      
      public function note1010(param1:Object) : void
      {
         LogUtil("1010=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" !== _loc2_)
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
            LoginPro.logining = true;
            PlayerVO.bagElfVec[0] = GetElfFromSever.getElfInfo(param1.data.spirit);
         }
      }
      
      public function write1011() : void
      {
         LoginPro.logining = false;
         var _loc1_:Object = {};
         _loc1_.msgId = 1011;
         _loc1_.userName = PlayerVO.nickName;
         client.sendBytes(_loc1_);
      }
      
      public function note1011(param1:Object) : void
      {
         LogUtil("1011=" + JSON.stringify(param1));
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
            Tips.show("昵称设置成功");
            LoginPro.logining = true;
            sendNotification("CLOSE_SETNAME_ELF");
         }
      }
      
      public function write1161(param1:Boolean, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:Object = {};
         _loc4_.msgId = 1161;
         _loc4_.isCompleteBeginner = param1;
         _loc4_.isCompleteRestrain = param2;
         _loc4_.isCompleteCatchElf = param3;
         client.sendBytes(_loc4_,false);
      }
      
      public function note1161(param1:Object) : void
      {
         LogUtil("1161=" + JSON.stringify(param1));
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
      
      public function note1005(param1:Object) : void
      {
         if(GetCommon.isIOSDied())
         {
            return;
         }
         LogUtil("note1005=" + JSON.stringify(param1));
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
               Alert.show(param1.data.msg,"",new ListCollection([{"label":"确定"}]));
            }
         }
         else
         {
            Alert.show(param1.data.msg,"",new ListCollection([{"label":"确定"}]));
         }
      }
      
      public function write1107() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 1107;
         client.sendBytes(_loc1_);
      }
      
      public function note1107(param1:Object) : void
      {
         var _loc2_:* = null;
         LogUtil("1107=" + JSON.stringify(param1));
         var _loc3_:* = param1.status;
         if("success" !== _loc3_)
         {
            if("fail" !== _loc3_)
            {
               if("error" === _loc3_)
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
            _loc3_ = param1.data.page;
            if("series" !== _loc3_)
            {
               if("activity" !== _loc3_)
               {
                  if("mail" !== _loc3_)
                  {
                     if("vipAtv" !== _loc3_)
                     {
                        if("guildId" === _loc3_)
                        {
                           (facade.retrieveProxy("UnionPro") as UnionPro).write3413(false);
                        }
                     }
                     else
                     {
                        ActiveMeida.isVIPgiftNew = true;
                        sendNotification("SHOW_VIPGIFT_NEWS");
                     }
                  }
                  else
                  {
                     Tips.show("刚刚有一封【系统邮件】飞到您的信箱哦");
                     MailMedia.isNew = true;
                     if(facade.hasMediator("MainCityMedia") && !GetCommon.isIOSDied())
                     {
                        sendNotification("SHOW_INFOMATION_NEWS");
                     }
                     if(facade.hasMediator("MailMedia"))
                     {
                        _loc2_ = (Facade.getInstance().retrieveMediator("MailMedia") as MailMedia).UI as MailUI;
                        if(_loc2_.parent)
                        {
                           LogUtil("就在邮件页面");
                           (facade.retrieveProxy("InformationPro") as InformationPro).write4200();
                        }
                     }
                  }
               }
               else
               {
                  Tips.show("一不小心完成了活动，快去领奖吧");
                  ActiveMeida.isNew = true;
                  if(facade.hasMediator("MainCityMedia") && !GetCommon.isIOSDied())
                  {
                     sendNotification("SHOW_ACTIVE_REWARD");
                  }
               }
            }
            else
            {
               Tips.show("刚刚有个二货在联盟大赛偷袭了您，快去看看吧");
               ElfSeriesMedia.isNew = true;
               if(facade.hasMediator("MainCityMedia"))
               {
                  if((param1.data as Object).hasOwnProperty("rank") != null)
                  {
                     PlayerVO.seriesRank = param1.data.rank;
                  }
                  if(!GetCommon.isIOSDied())
                  {
                     sendNotification("SHOW_SERIES_NEWS");
                  }
               }
               if(facade.hasMediator("ElfSeriesMedia"))
               {
                  (facade.retrieveProxy("ElfSeriesPro") as ElfSeriesPro).write5000();
               }
            }
         }
      }
      
      public function write1009() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 1009;
         _loc1_.userId = PlayerVO.userId;
         client.sendBytes(_loc1_);
      }
      
      public function note1009(param1:Object) : void
      {
         object = param1;
         LogUtil("1009=" + JSON.stringify(object));
         if(object.result)
         {
            if(object.ac)
            {
               sendNotification("update_play_power_info",object.ac);
            }
            Tips.show("欢迎回来");
            clearTimeout(CheckNetStatus.reCheck);
            isConnect = true;
            CheckNetStatus.isHaveConnect = false;
            LogUtil("(Config.starling.root as Game).page==",(Config.starling.root as Game).page);
            if((Config.starling.root as Game).page is PVPBgUI)
            {
               PVPBgMediator.pvpFrom = 1;
               PVPBgMediator.npcUserId = "";
               PVPPro.nowInviteUserId = "";
               PVPPracticeMediator.myStatus = 0;
               PVPPracticeMediator.npcStatus = 0;
               PVPBgMediator.recoverElfData();
               sendNotification("switch_page","load_maincity_page");
            }
            if((Config.starling.root as Game).page is FightingUI)
            {
               var callBack:Function = function():void
               {
                  var _loc2_:* = 0;
                  var _loc1_:* = null;
                  if(FightingMedia.isFighting == false)
                  {
                     _loc2_ = 0;
                     while(_loc2_ < PlayerVO.bagElfVec.length)
                     {
                        if(PlayerVO.bagElfVec[_loc2_] != null && PlayerVO.bagElfVec[_loc2_].isHasFiging)
                        {
                           if(!(LoadPageCmd.lastPage is KingKwanUI) && !(LoadPageCmd.lastPage is ElfSeriesUI) && !(LoadPageCmd.lastPage is PVPBgUI) && !(LoadPageCmd.lastPage is TrialUI) && !(LoadPageCmd.lastPage is MiningFrameUI))
                           {
                              (facade.retrieveProxy("FightingPro") as FightingPro).write1601();
                           }
                           (facade.retrieveProxy("MapPro") as MapPro).write1702(FightingConfig.selectMap);
                           return;
                        }
                        _loc2_++;
                     }
                  }
                  if(FightingLogicFactor.isPVP)
                  {
                     FightingConfig.isWin = false;
                     Dialogue.initAll();
                     GameFacade.getInstance().sendNotification(ConfigConst.INIT_ALL_ELF);
                     PVPPracticeMediator.myStatus = 0;
                     GameFacade.getInstance().sendNotification("switch_page","RETURN_LAST");
                  }
                  if(FightingPro.isRequest1501Com == false)
                  {
                     _loc1_ = {};
                     _loc1_.res = 2;
                     GameFacade.getInstance().sendNotification("catch_elf_result",_loc1_);
                  }
               };
               (facade.retrieveProxy("FightingPro") as FightingPro).write3100(callBack);
            }
         }
         else
         {
            Tips.show("噢，链接不上");
            isConnect = false;
            CheckNetStatus.reConnect();
         }
      }
      
      public function note1004(param1:Object) : void
      {
         var _loc2_:* = null;
         LogUtil("note1004= " + JSON.stringify(param1));
         var _loc3_:* = param1.status;
         if("success" !== _loc3_)
         {
            if("fail" !== _loc3_)
            {
               if("error" === _loc3_)
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
            isMaintenance = true;
            if(GetCommon.isIOSDied())
            {
               return;
            }
            _loc2_ = Alert.show("服务器已断开","",new ListCollection([{"label":"确定"}]));
            _loc2_.addEventListener("close",loginHandler);
         }
      }
      
      private function loginHandler() : void
      {
         NativeApplication.nativeApplication.exit();
         UmengExtension.getInstance().UMAnalysic("exit");
      }
      
      private function xiaomaoElfId(param1:int) : void
      {
         switch(param1 - 1)
         {
            case 0:
               NPCVO.elfOfXiaoMao = "4";
               break;
            case 3:
               NPCVO.elfOfXiaoMao = "7";
            case 6:
               NPCVO.elfOfXiaoMao = "1";
               break;
            default:
               NPCVO.elfOfXiaoMao = "7";
         }
      }
   }
}
