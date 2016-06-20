package com.mvc.models.proxy.mapSelect
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.mvc.models.vos.mapSelect.MapVO;
   import com.common.net.Client;
   import com.mvc.models.vos.mapSelect.MapBaseVO;
   import com.common.util.xmlVOHandler.GetMapFactor;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.common.themes.Tips;
   import com.mvc.models.vos.mapSelect.MainMapVO;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.mvc.controllers.LoadPageCmd;
   import com.mvc.views.uis.mainCity.trial.TrialUI;
   import com.mvc.views.uis.fighting.FightFailUI;
   import com.mvc.views.uis.mainCity.elfSeries.ElfSeriesUI;
   import com.mvc.views.uis.fighting.FightingWinUI;
   import com.mvc.views.uis.mainCity.kingKwan.KingKwanUI;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.views.uis.mainCity.mining.MiningFrameUI;
   import com.mvc.views.mediator.mapSelect.CityMapMeida;
   import com.mvc.views.uis.mainCity.playerInfo.ShowBadgeMc;
   import com.mvc.models.vos.mapSelect.PointVO;
   import com.mvc.views.uis.mapSelect.CityMapUI;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.views.uis.fighting.FightingUI;
   import com.massage.ane.UmengExtension;
   import extend.SoundEvent;
   import com.common.util.dialogue.NPCDialogue;
   import com.mvc.views.mediator.mapSelect.WorldMapMedia;
   import com.mvc.GameFacade;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.views.uis.mapSelect.RaidsFinishUI;
   import com.mvc.views.uis.mainCity.myElf.EvoStoneGuideUI;
   import com.common.util.RewardHandle;
   
   public class MapPro extends Proxy
   {
      
      public static const NAME:String = "MapPro";
      
      public static var _mapVo:MapVO;
      
      public static var hidePropArr:Array = [];
       
      private var client:Client;
      
      private var _mapVO:MapBaseVO;
      
      private var _isUpdate:Boolean;
      
      private var _boxId:int;
      
      private var _beforeStar:int;
      
      private var _id:int;
      
      private var sendNum:int;
      
      private var _callBack:Function;
      
      public function MapPro(param1:Object = null)
      {
         super("MapPro",param1);
         client = Client.getInstance();
         client.addCallObj("note1201",this);
         client.addCallObj("note1701",this);
         client.addCallObj("note1702",this);
         client.addCallObj("note1703",this);
         client.addCallObj("note1704",this);
         client.addCallObj("note1705",this);
         client.addCallObj("note1706",this);
         client.addCallObj("note1707",this);
         client.addCallObj("note1708",this);
         client.addCallObj("note1709",this);
         client.addCallObj("note1709",this);
         client.addCallObj("note1710",this);
      }
      
      public function write1201(param1:int) : void
      {
         _id = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 1201;
         _loc2_.nodeId = param1;
         client.sendBytes(_loc2_);
         LogUtil("1201=" + JSON.stringify(_loc2_));
         if(GetMapFactor.isLastPoint(GetMapFactor.mainIdVec,param1) || GetMapFactor.isLastPoint(GetMapFactor.ExtendVec,param1))
         {
            LogUtil("这个是最后一个节点============",param1);
            LogUtil("所有开启的节点========",GetMapFactor.getPointArr());
            if(FightingConfig.openPoint[GetMapFactor.getPointArr().indexOf(param1)].plan == 0)
            {
               LogUtil("首次通过 野外遇怪节点");
               FightingConfig.openPoint[GetMapFactor.getPointArr().indexOf(param1)].plan = 1;
               sendNotification("update_city_point_open");
            }
         }
      }
      
      public function note1201(param1:Object) : void
      {
         LogUtil("1201=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务器异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            sendNotification("exten_map_result",param1.data);
         }
      }
      
      public function write1701(param1:MainMapVO) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 1701;
         _loc2_.nodeId = param1.nodeId;
         _loc2_.isHard = param1.isHard;
         client.sendBytes(_loc2_);
      }
      
      public function note1701(param1:Object) : void
      {
         LogUtil("1701=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" === _loc2_)
            {
               Alert.show(param1.msgId + "处理失败:" + param1.data.msg,"",new ListCollection([{"label":"确定"}]));
            }
         }
         else
         {
            sendNotification("main_map_info",param1.data);
         }
      }
      
      public function write1702(param1:MapBaseVO) : void
      {
         var _loc5_:* = null;
         var _loc7_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc9_:* = null;
         var _loc2_:* = null;
         var _loc8_:* = null;
         var _loc6_:* = 0;
         LogUtil("write1702=mapVO==",param1);
         _mapVO = param1;
         if(param1 == null)
         {
            LogUtil(LoadPageCmd.lastPage);
            initElfFightStatus();
            if(LoadPageCmd.lastPage is TrialUI)
            {
               if(LoadPageCmd.fightResult() != 1)
               {
                  _loc5_ = FightFailUI.getInstance();
                  _loc5_.show();
               }
               else
               {
                  sendNotification("switch_page","RETURN_LAST");
               }
               return;
            }
            if(LoadPageCmd.lastPage is ElfSeriesUI)
            {
               if(LoadPageCmd.fightResult() == 1)
               {
                  LogUtil("联盟大赛胜利");
                  _loc7_ = new FightingWinUI();
                  _loc7_.show(1,false,0,0,null,"",null,true);
               }
               else
               {
                  LogUtil("联盟大赛失败");
                  _loc3_ = FightFailUI.getInstance();
                  _loc3_.show();
               }
               return;
            }
            if(LoadPageCmd.lastPage is KingKwanUI)
            {
               if(LoadPageCmd.fightResult() == 1)
               {
                  LogUtil("王者之路胜利");
                  _loc4_ = new FightingWinUI();
                  _loc4_.show(1,false,0,0,null,"",PlayerVO.bagElfVec);
               }
               else
               {
                  LogUtil("王者之路失败");
                  _loc9_ = FightFailUI.getInstance();
                  _loc9_.show();
               }
               return;
            }
            if(LoadPageCmd.lastPage is MiningFrameUI)
            {
               if(LoadPageCmd.fightResult() == 1)
               {
                  LogUtil("抢夺矿胜利");
                  _loc2_ = new FightingWinUI();
                  _loc2_.show(1,false,0,0,null,"",PlayerVO.bagElfVec);
               }
               else
               {
                  LogUtil("抢夺矿失败");
                  _loc8_ = FightFailUI.getInstance();
                  _loc8_.show();
               }
               return;
            }
            sendNotification("switch_page","RETURN_LAST");
            return;
         }
         _beforeStar = param1.normalStars;
         setMapStarts(param1);
         var _loc10_:Object = {};
         _loc10_.msgId = 1702;
         _loc10_.nodeId = param1.nodeId;
         _loc10_.plan = param1.curOpenId;
         _loc10_.curPlan = param1.id;
         _loc10_.batRes = FightingConfig.isWin;
         if(FightingConfig.isWin)
         {
            CityMapMeida.playDia = true;
         }
         _loc10_.fightPockList = [];
         _loc10_.isHard = param1.isHard;
         _loc10_.verify = FightingConfig.fightToken;
         if(FightingConfig.isWin)
         {
            if(param1.isHard)
            {
               _loc10_.curStar = param1.hardStars;
            }
            else
            {
               _loc10_.curStar = param1.normalStars;
            }
         }
         else
         {
            _loc10_.curStar = 0;
         }
         _loc6_ = 0;
         while(_loc6_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc6_] != null && PlayerVO.bagElfVec[_loc6_].isHasFiging)
            {
               _loc10_.fightPockList.push(PlayerVO.bagElfVec[_loc6_].id);
            }
            _loc6_++;
         }
         if(FightingConfig.computerElfVO)
         {
            _loc10_.pockMet = {
               "spId":FightingConfig.computerElfVO.elfId,
               "lv":FightingConfig.computerElfVO.lv
            };
         }
         client.sendBytes(_loc10_);
         return;
         §§push(LogUtil("发送1702=" + JSON.stringify(_loc10_)));
      }
      
      public function note1702(param1:Object) : void
      {
         var _loc19_:* = 0;
         var _loc6_:* = 0;
         var _loc15_:* = null;
         var _loc18_:* = 0;
         var _loc10_:* = 0;
         var _loc7_:* = false;
         var _loc3_:* = NaN;
         var _loc5_:* = NaN;
         var _loc9_:* = NaN;
         var _loc12_:* = NaN;
         var _loc13_:* = NaN;
         var _loc11_:* = NaN;
         var _loc21_:* = NaN;
         var _loc22_:* = NaN;
         var _loc16_:* = null;
         var _loc2_:* = undefined;
         var _loc4_:* = 0;
         var _loc8_:* = 0;
         var _loc17_:* = null;
         var _loc20_:* = null;
         var _loc14_:* = null;
         LogUtil("1702=" + JSON.stringify(param1));
         var _loc23_:* = param1.status;
         if("success" !== _loc23_)
         {
            if("fail" !== _loc23_)
            {
               if("error" === _loc23_)
               {
                  Tips.show("服务器异常");
               }
            }
            else
            {
               Alert.show(param1.msgId + "处理失败:" + param1.data.msg,"",new ListCollection([{"label":"确定"}]));
            }
         }
         else
         {
            initElfFightStatus();
            if(_mapVO.nodeId < 10000)
            {
               if(GetMapFactor.isLastPoint(GetMapFactor.mainIdVec,_mapVO.nodeId) || GetMapFactor.isLastPoint(GetMapFactor.ExtendVec,_mapVO.nodeId))
               {
                  LogUtil("这是最后一个节点","_beforeStar=",_beforeStar,"    _mapVO.normalStars= ",_mapVO.normalStars);
                  if(GetMapFactor.normalMapVec[GetMapFactor.normalMapVec.length - 1].id == _mapVO.id && _mapVO.normalStars > 0 && _beforeStar == 0)
                  {
                     LogUtil("这是首次通过最后一个list的节点，设置开启节点状态",_mapVO.id);
                     FightingConfig.openPoint[GetMapFactor.getPointArr().indexOf(_mapVO.nodeId)].plan = _mapVO.id;
                     LogUtil("最新=",JSON.stringify(FightingConfig.openPoint));
                     sendNotification("update_city_point_open");
                  }
               }
            }
            if(param1.data.star)
            {
               FightingConfig.openPoint[GetMapFactor.getPointArr().indexOf(_mapVO.nodeId)].currStars = param1.data.star;
               sendNotification("update_city_point_open");
            }
            if(param1.data.badgeNum)
            {
               ShowBadgeMc.badgeFlag = param1.data.badgeNum;
            }
            if(FightingConfig.selectMap)
            {
               _loc19_ = PlayerVO.actionForce;
               sendNotification("update_play_power_info",PlayerVO.actionForce - FightingConfig.selectMap.needPower);
               if(PlayerVO.actionCDTime == 0 && PlayerVO.actionForce < PlayerVO.maxActionForce)
               {
                  PlayerVO.actionCDTime = 360;
               }
            }
            LogUtil(param1.data.sNodeLst + "开启的节点列表");
            LogUtil(param1.data.cityId + "开启的世界城市id");
            if(param1.data.sNodeLst && param1.data.sNodeLst.length > 0)
            {
               _loc6_ = 0;
               while(_loc6_ < param1.data.sNodeLst.length)
               {
                  _loc15_ = new PointVO();
                  _loc15_.rcdId = param1.data.sNodeLst[_loc4_];
                  _loc15_.plan = 0;
                  FightingConfig.openPoint.push(_loc15_);
                  _loc6_++;
               }
               sendNotification("update_city_point_open");
               CityMapMeida.recordMainAdvance = null;
               FightingConfig.isHasNewPoint = true;
            }
            if((Config.starling.root as Game).page is CityMapUI)
            {
               sendNotification("tell_new_point_open");
            }
            _loc18_ = param1.data.money;
            if(_loc18_ > 0)
            {
               sendNotification("update_play_money_info",PlayerVO.silver + _loc18_);
            }
            _loc10_ = param1.data.exp;
            _loc7_ = param1.data.isLvUp;
            _loc3_ = param1.data.lv1;
            _loc5_ = param1.data.lv2;
            _loc9_ = param1.data.ac1;
            _loc12_ = param1.data.ac2;
            _loc13_ = param1.data.mac1;
            _loc11_ = param1.data.mac2;
            _loc21_ = param1.data.pokeSpace1;
            _loc22_ = param1.data.pokeSpace2;
            if(_loc10_ > 0)
            {
               sendNotification("update_play_expbar_info",PlayerVO.exper + _loc10_);
            }
            _loc16_ = param1.data.itemAry;
            _loc2_ = new Vector.<PropVO>();
            if(_loc16_ && _loc16_.length > 0)
            {
               _loc4_ = 0;
               for(; _loc4_ < _loc16_.length; _loc4_++)
               {
                  if(_loc16_[_loc4_].pId)
                  {
                     if(_loc16_[_loc4_].pId != -2)
                     {
                        _loc8_ = _loc16_[_loc4_].pId;
                        if(_loc16_[_loc4_].pId == -1)
                        {
                           switch(PlayerVO.firstElfId - 1)
                           {
                              case 0:
                                 _loc8_ = 134;
                                 break;
                              case 3:
                                 _loc8_ = 131;
                              case 6:
                                 _loc8_ = 132;
                                 break;
                              default:
                                 _loc8_ = 131;
                           }
                        }
                        _loc17_ = GetPropFactor.getPropVO(_loc8_);
                        _loc17_.rewardCount = _loc16_[_loc4_].num;
                        GetPropFactor.addOrLessProp(_loc17_,true,_loc16_[_loc4_].num);
                        _loc2_.push(_loc17_);
                        if(FightingConfig.selectMap && FightingConfig.selectMap.type == 5)
                        {
                           FightingConfig.getArr.push("获得了一个【" + _loc17_.name + "】");
                        }
                     }
                     continue;
                  }
                  if(_loc16_[_loc4_].diamond)
                  {
                     FightingConfig.getArr.push("获得了" + _loc16_[_loc4_].diamond.num + "颗【钻石】");
                     sendNotification("update_play_diamond_info",PlayerVO.diamond + _loc16_[_loc4_].diamond.num);
                     continue;
                  }
               }
            }
            if((Config.starling.root as Game).page is FightingUI && !FightingConfig.isGoOut)
            {
               if(FightingConfig.isWin)
               {
                  _loc20_ = new FightingWinUI();
                  _loc20_.show(_mapVO.curOpenId,false,_loc18_ + FightingConfig.moneyFromFighting,_loc10_,_loc2_);
                  UmengExtension.getInstance().UMAnalysic("finishLevel|" + _mapVO.id);
               }
               else if(FightingConfig.isWin == false)
               {
                  _loc14_ = FightFailUI.getInstance();
                  _loc14_.show();
                  UmengExtension.getInstance().UMAnalysic("failLevel|" + _mapVO.id);
               }
            }
            else if(!(Config.starling.root as Game).page is FightingUI)
            {
               if(_loc2_.length > 0)
               {
                  SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","getProp");
               }
               NPCDialogue.playDialogue(FightingConfig.getArr,"您",null);
               sendNotification("adventure_result",0,"adventure_pass");
            }
            FightingConfig.selectMap = null;
            if(param1.data.cityId)
            {
               CityMapMeida.recordMainAdvance = null;
               FightingConfig.openCity = param1.data.cityId;
               FightingConfig.isHasNewCity = true;
               write1703(WorldMapMedia.mapVO,true);
            }
            write1710(GetMapFactor.countCityId(_mapVO.nodeId));
         }
         if(FightingConfig.isGoOut)
         {
            GameFacade.getInstance().sendNotification("switch_page","RETURN_LAST");
            FightingConfig.isGoOut = false;
            CityMapMeida.playDia = false;
         }
      }
      
      private function setMapStarts(param1:MapBaseVO) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc2_] != null && PlayerVO.bagElfVec[_loc2_].currentHp == 0)
            {
               _loc3_++;
            }
            _loc2_++;
         }
         if(_loc3_ == 0)
         {
            if(param1.isHard)
            {
               param1.hardStars = 3;
            }
            else
            {
               param1.normalStars = 3;
            }
         }
         else if(_loc3_ == 1)
         {
            if(param1.isHard)
            {
               if(param1.hardStars < 2)
               {
                  param1.hardStars = 2;
               }
            }
            else if(param1.normalStars < 2)
            {
               param1.normalStars = 2;
            }
         }
         else if(param1.isHard)
         {
            if(param1.hardStars < 1)
            {
               param1.hardStars = 1;
            }
         }
         else if(param1.normalStars < 1)
         {
            param1.normalStars = 1;
         }
      }
      
      private function initElfFightStatus() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc1_] != null && PlayerVO.bagElfVec[_loc1_].isHasFiging)
            {
               PlayerVO.bagElfVec[_loc1_].isHasFiging = false;
            }
            _loc1_++;
         }
      }
      
      public function write1703(param1:MapVO, param2:Boolean = false) : void
      {
         _mapVo = param1;
         _isUpdate = param2;
         var _loc3_:Object = {};
         _loc3_.msgId = 1703;
         _loc3_.cityId = param1.id;
         client.sendBytes(_loc3_);
      }
      
      public function note1703(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = null;
         LogUtil("1703=" + JSON.stringify(param1));
         var _loc5_:* = param1.status;
         if("success" !== _loc5_)
         {
            if("fail" === _loc5_)
            {
               Alert.show(param1.msgId + "处理失败:" + param1.data.msg,"",new ListCollection([{"label":"确定"}]));
            }
         }
         else
         {
            LogUtil(JSON.stringify(param1.data.lst) + "开启的节点列表");
            if(param1.data.specProp)
            {
               hidePropArr = param1.data.specProp;
            }
            FightingConfig.openPoint = Vector.<PointVO>([]);
            _loc2_ = param1.data.lst;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = new PointVO();
               _loc3_.rcdId = _loc2_[_loc4_].rcdId;
               _loc3_.plan = _loc2_[_loc4_].plan;
               _loc3_.currStars = _loc2_[_loc4_].star;
               FightingConfig.openPoint.push(_loc3_);
               _loc4_++;
            }
            if(param1.data.cityId)
            {
               FightingConfig.cityIdArr = param1.data.cityId;
            }
            if(_isUpdate)
            {
               sendNotification("update_city_map_show",WorldMapMedia.mapVO);
            }
            else
            {
               sendNotification("switch_page","load_city_map_page");
            }
         }
      }
      
      public function write1704(param1:MainMapVO, param2:int, param3:Boolean) : void
      {
         var _loc4_:Object = {};
         _loc4_.msgId = 1704;
         _loc4_.rcdId = param1.id;
         _loc4_.sweepNum = param2;
         _loc4_.isDiaSweep = param3;
         _loc4_.isHard = param1.isHard;
         client.sendBytes(_loc4_);
         GetElfFactor.getBeforeFightElf();
      }
      
      public function note1704(param1:Object) : void
      {
         var _loc16_:* = 0;
         var _loc15_:* = 0;
         var _loc9_:* = 0;
         var _loc7_:* = false;
         var _loc4_:* = NaN;
         var _loc5_:* = NaN;
         var _loc8_:* = NaN;
         var _loc11_:* = NaN;
         var _loc12_:* = NaN;
         var _loc10_:* = NaN;
         var _loc17_:* = NaN;
         var _loc18_:* = NaN;
         var _loc13_:* = null;
         var _loc3_:* = undefined;
         var _loc6_:* = 0;
         var _loc14_:* = null;
         var _loc2_:* = null;
         LogUtil("1704=" + JSON.stringify(param1));
         var _loc19_:* = param1.status;
         if("success" !== _loc19_)
         {
            if("fail" === _loc19_)
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            sendNotification("update_raids_num");
            if(FightingConfig.selectMap)
            {
               _loc16_ = PlayerVO.actionForce;
               sendNotification("update_play_power_info",PlayerVO.actionForce - FightingConfig.selectMap.needPower * FightingConfig.raidsNum);
               if(PlayerVO.actionCDTime == 0 && PlayerVO.actionForce < PlayerVO.maxActionForce)
               {
                  PlayerVO.actionCDTime = 360;
               }
            }
            _loc15_ = param1.data.money;
            if(_loc15_ > 0)
            {
               sendNotification("update_play_money_info",PlayerVO.silver + _loc15_);
            }
            _loc9_ = param1.data.exp;
            _loc7_ = param1.data.isLvUp;
            _loc4_ = param1.data.lv1;
            _loc5_ = param1.data.lv2;
            _loc8_ = param1.data.ac1;
            _loc11_ = param1.data.ac2;
            LogUtil("升级后体力" + _loc11_);
            _loc12_ = param1.data.mac1;
            _loc10_ = param1.data.mac2;
            _loc17_ = param1.data.pokeSpace1;
            _loc18_ = param1.data.pokeSpace2;
            if(_loc9_ > 0)
            {
               sendNotification("update_play_expbar_info",PlayerVO.exper + _loc9_);
            }
            _loc13_ = param1.data.itemAry;
            if(_loc13_)
            {
               _loc3_ = new Vector.<PropVO>();
               _loc6_ = 0;
               while(_loc6_ < _loc13_.length)
               {
                  _loc14_ = GetPropFactor.getPropVO(_loc13_[_loc6_].pId);
                  _loc14_.rewardCount = _loc13_[_loc6_].num;
                  GetPropFactor.addOrLessProp(_loc14_,true,_loc14_.rewardCount);
                  _loc3_.push(_loc14_);
                  _loc6_++;
               }
            }
            FightingConfig.getPropFromRaids = _loc3_;
            FightingConfig.selectMap = null;
            _loc2_ = new RaidsFinishUI();
            _loc2_.show(_loc15_,_loc9_,_loc3_);
         }
      }
      
      public function write1705() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 1705;
         client.sendBytes(_loc1_);
      }
      
      public function note1705(param1:Object) : void
      {
         LogUtil("1705=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" === _loc2_)
            {
               Alert.show(param1.msgId + "处理失败:" + param1.data.msg,"",new ListCollection([{"label":"确定"}]));
            }
         }
         else
         {
            LogUtil(param1.data.cityPlan + "开启的城市进度" + EvoStoneGuideUI.cityID);
            FightingConfig.openCity = param1.data.cityPlan;
            WorldMapMedia.mapVO = GetMapFactor.getMapVoById(FightingConfig.openCity);
            Config.cityScene = WorldMapMedia.mapVO.bgImg;
            if(EvoStoneGuideUI.cityID != -1)
            {
               sendNotification("switch_page","load_world_map_page");
            }
            else
            {
               write1703(WorldMapMedia.mapVO);
            }
         }
      }
      
      public function write1706(param1:MapBaseVO) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 1706;
         _loc2_.nodeId = param1.nodeId;
         client.sendBytes(_loc2_);
      }
      
      public function note1706(param1:Object) : void
      {
         LogUtil("1706=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" === _loc2_)
            {
               Alert.show(param1.msgId + "处理失败:" + param1.data.msg,"",new ListCollection([{"label":"确定"}]));
            }
         }
         else
         {
            sendNotification("return_is_open_point",param1.data);
         }
      }
      
      public function write1707(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 1707;
         _loc2_.rcdId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note1707(param1:Object) : void
      {
         LogUtil("1707=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" === _loc2_)
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            sendNotification("RESTART_UPDATE");
            UmengExtension.getInstance().UMAnalysic("buy|04|1|" + (PlayerVO.diamond - param1.data.diamond));
            sendNotification("update_play_diamond_info",param1.data.diamond);
         }
      }
      
      public function write1708(param1:MapBaseVO, param2:Function) : void
      {
         _callBack = param2;
         var _loc3_:Object = {};
         _loc3_.msgId = 1708;
         _loc3_.rcdId = param1.id;
         _loc3_.isHard = param1.isHard;
         client.sendBytes(_loc3_);
         LogUtil("发送1708=" + JSON.stringify(_loc3_));
         UmengExtension.getInstance().UMAnalysic("startLevel|" + param1.id);
      }
      
      public function note1708(param1:Object) : void
      {
         LogUtil("1708=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" === _loc2_)
            {
               Alert.show(param1.data.msg,"",new ListCollection([{"label":"确定"}]));
            }
         }
         else
         {
            _callBack();
         }
      }
      
      public function write1709(param1:int, param2:int) : void
      {
         var _loc3_:Object = {};
         _boxId = param2;
         _loc3_.msgId = 1709;
         _loc3_.cityId = param1;
         _loc3_.box = param2;
         client.sendBytes(_loc3_);
      }
      
      public function note1709(param1:Object) : void
      {
         LogUtil("1709=" + JSON.stringify(param1));
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
            RewardHandle.Reward(param1.data.reward,2);
            sendNotification("UPDATE_CHESTS",_boxId);
         }
      }
      
      public function write1710(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 1710;
         _loc2_.cityId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note1710(param1:Object) : void
      {
         LogUtil("1710=" + JSON.stringify(param1));
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
            sendNotification("SHOW_CHESTS",param1.data);
         }
      }
   }
}
