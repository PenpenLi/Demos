package com.mvc.models.proxy.mainCity.specialAct
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.mvc.models.vos.mainCity.specialAct.PreferVO;
   import com.common.net.Client;
   import com.mvc.models.vos.mainCity.specialAct.DiaMarkUpVO;
   import com.common.themes.Tips;
   import com.common.consts.ConfigConst;
   import com.common.util.RewardHandle;
   import com.mvc.views.mediator.mainCity.specialAct.flashElfAct.FlashBaoLiLongMediator;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.vos.elf.ElfVO;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.views.mediator.mainCity.specialAct.ActPreviewMediator;
   import lzm.util.LSOManager;
   import com.mvc.views.uis.worldHorn.WorldTime;
   
   public class SpecialActPro extends Proxy
   {
      
      public static const NAME:String = "SpecialActivePro";
      
      public static var isDiaOpen:Boolean;
      
      public static var isDayHappyOpen:Boolean;
      
      public static var isLightOpen:Boolean;
      
      public static var isLimitSpecialElfOpen:Boolean;
      
      public static var isPreferOpen:Boolean;
      
      public static var isRichGift:Boolean;
      
      public static var isLottery:Boolean;
      
      public static var isOnlineOpen:Boolean;
      
      public static var preferVec:Vector.<PreferVO> = new Vector.<PreferVO>([]);
      
      public static var preferStartTime:Date = new Date();
      
      public static var preferEndTime:Date = new Date();
      
      public static var onlinePhases:int;
      
      public static var onlineCountdown:int;
      
      public static var showActPreview:Boolean;
       
      private var client:Client;
      
      private var str:String = " { \"rankList\": [{ \"userName\": \"砍砍价sd\", \"score\": 222 }, { \"userName\": \"豆腐价方法商\", \"score\": 22222 }, { \"userName\": \"水\", \"score\": 22222 }],  \"rewardList\": [ { \"id\": \"1\", \"prop\": [{ \"pId\": 1, \"num\": 5 }, { \"pId\": 1, \"num\": 5 }], \"poke\": [{ \"pokeId\": 1, \"num\": 5 }] }, { \"id\": \"2\", \"prop\": [{ \"pId\": 1, \"num\": 5 }, { \"pId\": 1, \"num\": 5 }], \"poke\": [{ \"pokeId\": 1, \"num\": 5 }] }, { \"id\": \"3\", \"prop\": [{ \"pId\": 1, \"num\": 5 }], \"poke\": [{ \"pokeId\": 1, \"num\": 5 }] } ]  } ";
      
      private var index:int;
      
      private var sonActIdArr:Array;
      
      private var atvId:int;
      
      private var _index:int;
      
      private var _preferVo:PreferVO;
      
      public function SpecialActPro(param1:Object = null)
      {
         super("SpecialActivePro",param1);
         client = Client.getInstance();
         client.addCallObj("note1906",this);
         client.addCallObj("note1907",this);
         client.addCallObj("note1908",this);
         client.addCallObj("note1909",this);
         client.addCallObj("note1910",this);
         client.addCallObj("note1911",this);
         client.addCallObj("note2505",this);
         client.addCallObj("note1912",this);
         client.addCallObj("note1913",this);
         client.addCallObj("note3700",this);
         client.addCallObj("note3701",this);
         client.addCallObj("note4206",this);
      }
      
      public function write1906() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 1906;
         client.sendBytes(_loc1_);
      }
      
      public function note1906(param1:Object) : void
      {
         LogUtil("note1906: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            DiaMarkUpVO.lessTime = param1.data.leftTime;
            DiaMarkUpVO.addUpDia = param1.data.allDiamond;
            DiaMarkUpVO.lessNum = param1.data.fortuneTimes;
            DiaMarkUpVO.nextNeedDia = param1.data.nextNeedDiamond;
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
      
      public function write1907() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 1907;
         client.sendBytes(_loc1_);
      }
      
      public function note1907(param1:Object) : void
      {
         LogUtil("note1907: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            DiaMarkUpVO.addUpDia = param1.data.allDiamond;
            DiaMarkUpVO.lessNum = param1.data.fortuneTimes;
            DiaMarkUpVO.nextNeedDia = param1.data.nextNeedDiamond;
            DiaMarkUpVO.theGetDia = param1.data.diamond;
            sendNotification("update_diamondup_info_after_buy");
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
      
      public function write1908() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 1908;
         client.sendBytes(_loc1_);
      }
      
      public function note1908(param1:Object) : void
      {
         var _loc6_:* = null;
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc7_:* = 0;
         var _loc2_:* = null;
         var _loc5_:* = null;
         LogUtil("note1908: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            _loc6_ = {};
            _loc4_ = [];
            _loc3_ = [];
            sonActIdArr = [];
            atvId = param1.data.atvId;
            if(param1.data.rewardArr)
            {
               _loc8_ = 0;
               while(_loc8_ < param1.data.rewardArr.length)
               {
                  _loc4_.push([]);
                  if(param1.data.rewardArr[_loc8_].hasOwnProperty("poke"))
                  {
                     _loc9_ = 0;
                     while(_loc9_ < param1.data.rewardArr[_loc8_].poke.length)
                     {
                        _loc4_[_loc8_].push(param1.data.rewardArr[_loc8_].poke[_loc9_]);
                        _loc9_++;
                     }
                  }
                  if(param1.data.rewardArr[_loc8_].hasOwnProperty("prop"))
                  {
                     _loc7_ = 0;
                     while(_loc7_ < param1.data.rewardArr[_loc8_].prop.length)
                     {
                        _loc4_[_loc8_].push(param1.data.rewardArr[_loc8_].prop[_loc7_]);
                        _loc7_++;
                     }
                  }
                  if(param1.data.rewardArr[_loc8_].hasOwnProperty("silver"))
                  {
                     _loc2_ = {"silver":param1.data.rewardArr[_loc8_].silver.num};
                     _loc4_[_loc8_].push(_loc2_);
                  }
                  if(param1.data.rewardArr[_loc8_].hasOwnProperty("diamond"))
                  {
                     _loc5_ = {"diamond":param1.data.rewardArr[_loc8_].diamond.num};
                     _loc4_[_loc8_].push(_loc5_);
                  }
                  _loc3_.push(param1.data.rewardArr[_loc8_].status);
                  sonActIdArr.push(param1.data.rewardArr[_loc8_].id);
                  _loc8_++;
               }
            }
            LogUtil("rewardArr: " + _loc4_[0]);
            LogUtil("stateArr: " + _loc3_);
            _loc6_.rewardArr = _loc4_;
            _loc6_.stateArr = _loc3_;
            _loc6_.atvId = param1.data.atvId;
            _loc6_.reqNum = param1.data.reqNum;
            _loc6_.doTimes = param1.data.doTimes;
            _loc6_.actTime = transDate(param1.data.date.start) + "—" + transDate(param1.data.date.end);
            sendNotification(ConfigConst.UPDATE_DAYRECHARGE_INFO,_loc6_);
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
      
      public function transDate(param1:Number) : String
      {
         var _loc2_:Date = new Date(param1 * 1000);
         return _loc2_.month + 1 + "月" + _loc2_.date + "日";
      }
      
      public function write1909(param1:int) : void
      {
         index = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 1909;
         _loc2_.atvId = atvId;
         _loc2_.rewardId = sonActIdArr[param1];
         client.sendBytes(_loc2_);
      }
      
      public function note1909(param1:Object) : void
      {
         LogUtil("note1909: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            sendNotification(ConfigConst.UPDATE_DAYRECHARGE_STATE_INFO,index);
            RewardHandle.Reward(param1.data.reward);
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
      
      public function write1910() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 1910;
         client.sendBytes(_loc1_);
      }
      
      public function note1910(param1:Object) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc4_:* = 0;
         LogUtil("note1910: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            _loc3_ = {};
            _loc2_ = [];
            if(param1.data.rewardArr)
            {
               _loc4_ = 0;
               while(_loc4_ < param1.data.rewardArr.length)
               {
                  _loc2_.push(param1.data.rewardArr[_loc4_].status);
                  _loc4_++;
               }
            }
            _loc3_.stateArr = _loc2_;
            _loc3_.actTime = param1.data.leftTime;
            FlashBaoLiLongMediator.lightElfInfoObj = _loc3_;
            if(param1.data.imgShow)
            {
               FlashBaoLiLongMediator.bgFlag = param1.data.imgShow;
            }
            sendNotification("switch_win",null,"load_flash_baolilong");
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
      
      public function write1911() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 1911;
         client.sendBytes(_loc1_);
      }
      
      public function note1911(param1:Object) : void
      {
         LogUtil("note1911: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            sendNotification(ConfigConst.UPDATE_FLASHELF_STATE_INFO);
            RewardHandle.Reward(param1.data.reward);
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
      
      public function write2505() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 2505;
         client.sendBytes(_loc1_);
      }
      
      public function note2505(param1:Object) : void
      {
         LogUtil("note2505: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            sendNotification(ConfigConst.UPDATE_LIMITSPECIALELF_INFO,param1.data);
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
      
      public function write1912() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 1912;
         client.sendBytes(_loc1_);
      }
      
      public function note1912(param1:Object) : void
      {
         var _loc4_:* = null;
         var _loc5_:* = 0;
         var _loc6_:* = null;
         var _loc8_:* = 0;
         var _loc3_:* = null;
         var _loc9_:* = 0;
         var _loc7_:* = null;
         var _loc10_:* = 0;
         var _loc2_:* = null;
         LogUtil("note1912: " + JSON.stringify(param1));
         var _loc11_:* = param1.status;
         if("success" !== _loc11_)
         {
            if("fail" !== _loc11_)
            {
               if("error" === _loc11_)
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
            preferStartTime.setTime(param1.data.beginTime * 1000);
            preferEndTime.setTime(param1.data.endTime * 1000);
            if(param1.data.convert)
            {
               _loc4_ = param1.data.convert;
               preferVec = Vector.<PreferVO>([]);
               _loc5_ = 0;
               while(_loc5_ < _loc4_.length)
               {
                  _loc6_ = new PreferVO();
                  if(_loc4_[_loc5_].gain.prop)
                  {
                     _loc8_ = 0;
                     while(_loc8_ < _loc4_[_loc5_].gain.prop.length)
                     {
                        _loc3_ = GetPropFactor.getPropVO(_loc4_[_loc5_].gain.prop[_loc8_].pId);
                        _loc3_.rewardCount = _loc4_[_loc5_].gain.prop[_loc8_].num;
                        _loc6_.rewardArr.push(_loc3_);
                        _loc8_++;
                     }
                  }
                  if(_loc4_[_loc5_].gain.poke)
                  {
                     _loc9_ = 0;
                     while(_loc9_ < _loc4_[_loc5_].gain.poke.length)
                     {
                        _loc7_ = GetElfFactor.getElfVO(_loc4_[_loc5_].gain.poke[_loc9_].spId);
                        _loc7_.lv = _loc4_[_loc5_].gain.poke[_loc9_].lv;
                        _loc6_.rewardArr.push(_loc7_);
                        _loc9_++;
                     }
                  }
                  if(_loc4_[_loc5_].gain.silver)
                  {
                     _loc6_.rewardArr.push("奖励金币×" + _loc4_[_loc5_].gain.silver);
                  }
                  if(_loc4_[_loc5_].gain.diamond)
                  {
                     _loc6_.rewardArr.push("奖励钻石×" + _loc4_[_loc5_].gain.diamond);
                  }
                  if(_loc4_[_loc5_].gain.action)
                  {
                     _loc6_.rewardArr.push("奖励体力×" + _loc4_[_loc5_].gain.action);
                  }
                  if(_loc4_[_loc5_].gain.exper)
                  {
                     _loc6_.rewardArr.push("奖励经验×" + _loc4_[_loc5_].gain.exper);
                  }
                  if(_loc4_[_loc5_].consume.prop)
                  {
                     _loc10_ = 0;
                     while(_loc10_ < _loc4_[_loc5_].consume.prop.length)
                     {
                        _loc2_ = GetPropFactor.getPropVO(_loc4_[_loc5_].consume.prop[_loc10_].pId);
                        _loc2_.rewardCount = _loc4_[_loc5_].consume.prop[_loc10_].num;
                        _loc6_.costArr.push(_loc2_);
                        _loc10_++;
                     }
                  }
                  if(_loc4_[_loc5_].consume.diamond)
                  {
                     _loc6_.costArr.push("奖励钻石×" + _loc4_[_loc5_].consume.diamond);
                     _loc6_.state = 2;
                  }
                  _loc6_.remainCount = _loc4_[_loc5_].times;
                  _loc6_.id = _loc4_[_loc5_].convertId;
                  preferVec.push(_loc6_);
                  _loc5_++;
               }
               sendNotification("SHOW_PREFER_GIFT",0,"初始化");
            }
         }
      }
      
      public function write1913(param1:PreferVO, param2:int) : void
      {
         _preferVo = param1;
         _index = param2;
         var _loc3_:Object = {};
         _loc3_.msgId = 1913;
         _loc3_.convertId = param1.id;
         client.sendBytes(_loc3_);
      }
      
      public function note1913(param1:Object) : void
      {
         var _loc2_:* = 0;
         LogUtil("note1913= " + JSON.stringify(param1));
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
            RewardHandle.Reward(param1.data.gain);
            §§dup(_preferVo).remainCount--;
            if(param1.data.consume)
            {
               if(param1.data.consume.prop)
               {
                  _loc2_ = 0;
                  while(_loc2_ < param1.data.consume.prop.length)
                  {
                     GetPropFactor.addOrLessProp(GetPropFactor.getPropVO(param1.data.consume.prop[_loc2_].pId),false,param1.data.consume.prop[_loc2_].num);
                     _loc2_++;
                  }
               }
               if(param1.data.consume.diamond != null)
               {
                  Facade.getInstance().sendNotification("update_play_diamond_info",PlayerVO.diamond - param1.data.consume.diamond);
               }
               if(param1.data.consume.silver != null)
               {
                  Facade.getInstance().sendNotification("update_play_money_info",PlayerVO.silver - param1.data.consume.silver);
               }
            }
            Facade.getInstance().sendNotification("SHOW_PREFER_GIFT",_index);
         }
      }
      
      public function write3700() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 3700;
         client.sendBytes(_loc1_);
      }
      
      public function note3700(param1:Object) : void
      {
         LogUtil("note3700: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            SpecialActPro.onlinePhases = param1.data.nextRewardNum;
            SpecialActPro.onlineCountdown = param1.data.nextRewardTime;
            if(SpecialActPro.onlinePhases > 0)
            {
               SpecialActPro.isOnlineOpen = true;
               sendNotification("UPDATE_SELETE_BTN");
               if(param1.data.nextRewardTime > 0)
               {
                  sendNotification("hide_online_news");
               }
               else
               {
                  sendNotification("show_online_news");
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
      
      public function write3701(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 3701;
         _loc2_.currentReward = SpecialActPro.onlinePhases;
         client.sendBytes(_loc2_);
      }
      
      public function note3701(param1:Object) : void
      {
         LogUtil("note3701: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            SpecialActPro.onlinePhases = param1.data.nextRewardNum;
            SpecialActPro.onlineCountdown = param1.data.nextRewardTime;
            if(SpecialActPro.onlinePhases > 0)
            {
               sendNotification("hide_online_news");
            }
            else
            {
               SpecialActPro.isOnlineOpen = false;
               sendNotification("UPDATE_SELETE_BTN");
               Tips.show("今天在线奖励已全部领取，明天记得来哦。");
            }
            if(param1.data.reward)
            {
               RewardHandle.Reward(param1.data.reward);
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
      
      public function note4206(param1:Object) : void
      {
         var _loc2_:* = false;
         var _loc3_:* = false;
         LogUtil("note4206: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(!param1.data.path)
            {
               return;
            }
            ActPreviewMediator.url = param1.data.path;
            ActPreviewMediator.gotoId = param1.data.goTo;
            if(LSOManager.has("ACT_PREVIEW_NOTTIP"))
            {
               _loc2_ = LSOManager.get("ACT_PREVIEW_NOTTIP");
            }
            if(LSOManager.has("ACT_PREVIEW_DAY") && WorldTime.getInstance().day == LSOManager.get("ACT_PREVIEW_DAY"))
            {
               _loc3_ = true;
            }
            if(!_loc3_)
            {
               SpecialActPro.showActPreview = true;
            }
            else if(_loc3_ && !_loc2_)
            {
               SpecialActPro.showActPreview = true;
            }
            else
            {
               SpecialActPro.showActPreview = false;
            }
            LSOManager.put("ACT_PREVIEW_DAY",WorldTime.getInstance().day);
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
