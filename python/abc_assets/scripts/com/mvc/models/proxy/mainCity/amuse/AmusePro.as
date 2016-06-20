package com.mvc.models.proxy.mainCity.amuse
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.net.Client;
   import com.mvc.views.mediator.mainCity.amuse.AmuseScoreRechargeMediator;
   import com.common.themes.Tips;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.login.LoginPro;
   import com.common.util.xmlVOHandler.GetElfFromSever;
   import com.mvc.models.proxy.Illustrations.IllustrationsPro;
   import com.mvc.models.vos.login.PlayerVO;
   import com.massage.ane.UmengExtension;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import starling.events.Event;
   
   public class AmusePro extends Proxy
   {
      
      public static const NAME:String = "AmusePro";
      
      public static var onceTimeVec:Array = [];
      
      public static var _recrId:int;
      
      public static var writeType:String;
      
      public static var ifPutBag:Boolean;
      
      public static var recruitFreeTimes:int;
      
      public static var priceArr:Array = [5000,45000,350,3080,500,4500];
      
      public static var discountLessTime:int;
      
      public static var tenDrawLessTime:int;
      
      public static var amusePreviewArr:Array;
       
      private var client:Client;
      
      private var _elfVo:ElfVO;
      
      private var _isReturn:Boolean;
      
      private var str:String = "{ \"list\": { \"spirit\": [ { \"spId\": 10, \"lv\": 20, \"price\": 50, \"times\": 1 }, { \"spId\": 20, \"lv\": 20, \"price\": 6, \"times\": 1 } ], \"prop\": [ { \"pId\": 10, \"price\": 100, \"times\": 5 }, { \"pId\": 30, \"price\": 200, \"times\": 5 } ] } }";
      
      private var itemId:int;
      
      private var _isLimited:Boolean;
      
      public function AmusePro(param1:Object = null)
      {
         super("AmusePro",param1);
         client = Client.getInstance();
         client.addCallObj("note2500",this);
         client.addCallObj("note2501",this);
         client.addCallObj("note2014",this);
         client.addCallObj("note2502",this);
         client.addCallObj("note2503",this);
         client.addCallObj("note2504",this);
      }
      
      public static function getAmusePreviewElfVo() : void
      {
         AmusePro.amusePreviewArr = [[],[],[]];
         var _loc4_:* = 0;
         var _loc3_:* = GetElfFactor.allElfStaticObj;
         for each(var _loc1_ in GetElfFactor.allElfStaticObj)
         {
            if(_loc1_.previewLimit == 1)
            {
               (AmusePro.amusePreviewArr[0] as Array).push(_loc1_);
            }
            if(_loc1_.previewLimit == 2)
            {
               (AmusePro.amusePreviewArr[1] as Array).push(_loc1_);
            }
            if(_loc1_.previewLimit == 3)
            {
               (AmusePro.amusePreviewArr[2] as Array).push(_loc1_);
            }
         }
         var _loc6_:* = 0;
         var _loc5_:* = GetPropFactor.allPropStaticVec;
         for each(var _loc2_ in GetPropFactor.allPropStaticVec)
         {
            if(_loc2_.previewLimit == 1)
            {
               (AmusePro.amusePreviewArr[0] as Array).push(_loc2_);
            }
            if(_loc2_.previewLimit == 2)
            {
               (AmusePro.amusePreviewArr[1] as Array).push(_loc2_);
            }
            if(_loc2_.previewLimit == 3)
            {
               (AmusePro.amusePreviewArr[2] as Array).push(_loc2_);
            }
         }
         randomReward(AmusePro.amusePreviewArr);
      }
      
      private static function randomReward(param1:Array) : void
      {
         var _loc3_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = undefined;
         var _loc4_:* = 0;
         var _loc2_:* = undefined;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc5_ = 0;
            while(_loc5_ < param1[_loc3_].length)
            {
               _loc6_ = param1[_loc3_][_loc5_];
               _loc4_ = Math.floor(Math.random() * param1[_loc3_].length);
               _loc2_ = param1[_loc3_][_loc4_];
               param1[_loc3_][_loc5_] = _loc2_;
               param1[_loc3_][_loc4_] = _loc6_;
               _loc5_++;
            }
            _loc3_++;
         }
      }
      
      public function write2500() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 2500;
         Config.starling.root.touchable = false;
         client.sendBytes(_loc1_);
      }
      
      public function note2500(param1:Object) : void
      {
         var _loc2_:* = 0;
         LogUtil("2500=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            Config.starling.root.touchable = true;
            onceTimeVec = [];
            _loc2_ = 0;
            while(_loc2_ < param1.data.recInfo.length)
            {
               onceTimeVec.push(param1.data.recInfo[_loc2_]);
               _loc2_++;
            }
            recruitFreeTimes = param1.data.recruitFreeTimes;
            sendNotification("update_count_down");
            if(param1.data.priceArr)
            {
               priceArr = param1.data.priceArr;
               sendNotification("amuse_update_cost");
            }
            if(param1.data.hornData)
            {
               sendNotification("amuse_show_tendraw_act_reward",param1.data.hornData);
            }
            if(param1.data.atvDate > 0)
            {
               discountLessTime = param1.data.atvDate;
            }
            if(param1.data.hornDate > 0)
            {
               tenDrawLessTime = param1.data.hornDate;
            }
            if(param1.data.spriteIdArr)
            {
               sendNotification("amuse_send_spriteIdArr",param1.data.spriteIdArr);
            }
            if(param1.data.titleInfo)
            {
               AmuseScoreRechargeMediator.itemArr = param1.data.titleInfo;
               AmuseScoreRechargeMediator.itemArr.sortOn("weight",16 | 2);
            }
         }
         else
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write2501(param1:int, param2:Boolean = false) : void
      {
         writeType = "2501";
         _recrId = param1;
         var _loc3_:Object = {};
         _loc3_.msgId = 2501;
         _loc3_.recrId = param1;
         _loc3_.isLimited = param2;
         if(!Config.isCompleteBeginner)
         {
            (Facade.getInstance().retrieveProxy("LoginPro") as LoginPro).write1161(true,Config.isCompleteRestrain,Config.isCompleteCatchElf);
         }
         client.sendBytes(_loc3_);
      }
      
      public function note2501(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc5_:* = null;
         var _loc4_:* = null;
         var _loc6_:* = null;
         var _loc3_:* = null;
         LogUtil("2501=" + JSON.stringify(param1));
         var _loc7_:* = param1.status;
         if("success" !== _loc7_)
         {
            if("fail" !== _loc7_)
            {
               if("error " === _loc7_)
               {
                  Tips.show(param1.data.msg);
               }
            }
            else if((param1.data.msg as String).indexOf("钻石") != -1)
            {
               showDiamondAlert();
            }
            else if((param1.data.msg as String).indexOf("金币") != -1)
            {
               showMoneyAlert();
            }
         }
         else
         {
            sendNotification("remove_amuse_last_resource");
            _loc2_ = [];
            if(param1.data.spirit)
            {
               LogUtil("精灵啦啦啦");
               _loc5_ = param1.data.spirit;
               _loc4_ = GetElfFromSever.getElfInfo(_loc5_);
               GetElfFactor.bagOrCom(_loc4_);
               IllustrationsPro.saveElfInfo(_loc4_);
               if(_recrId == 1)
               {
                  recruitFreeTimes = param1.data.recFreeTimes;
                  onceTimeVec[0] = param1.data.cdt;
               }
               if(_recrId == 3)
               {
                  onceTimeVec[1] = param1.data.cdt;
               }
               if(_recrId == 7)
               {
                  onceTimeVec[2] = param1.data.cdt;
               }
               sendNotification("update_count_down");
               _loc2_.push(_loc4_);
            }
            if(param1.data.proptool)
            {
               LogUtil("道具啦啦啦");
               _loc6_ = param1.data.proptool;
               _loc3_ = GetPropFactor.getPropVO(_loc6_.pId);
               if(param1.data.proptool.num != null)
               {
                  _loc3_.rewardCount = param1.data.proptool.num;
               }
               _loc2_.push(_loc3_);
               GetPropFactor.addOrLessProp(_loc3_,true,_loc3_.rewardCount);
            }
            if(param1.data.diamond != null && param1.data.diamond != PlayerVO.diamond)
            {
               UmengExtension.getInstance().UMAnalysic("buy|013|1|" + (PlayerVO.diamond - param1.data.diamond));
               sendNotification("update_play_diamond_info",param1.data.diamond);
            }
            if(param1.data.money != null && param1.data.money != PlayerVO.silver)
            {
               sendNotification("update_play_money_info",param1.data.money);
            }
            sendNotification("load_amuse_mc",_loc2_);
            _loc2_ = null;
         }
      }
      
      public function write2014(param1:ElfVO, param2:String, param3:Boolean, param4:Boolean = false) : void
      {
         LogUtil("spId=" + param1.id,"nickName=" + param2);
         if(param1.id == 0)
         {
            return;
         }
         if(param2 == param1.name && !param4)
         {
            return;
         }
         _elfVo = param1;
         _isReturn = param3;
         _elfVo.nickName = param2;
         var _loc5_:Object = {};
         _loc5_.msgId = 2014;
         _loc5_.spId = param1.id;
         _loc5_.nickName = param2;
         _loc5_.isCost = param4;
         client.sendBytes(_loc5_);
      }
      
      public function note2014(param1:Object) : void
      {
         LogUtil("2014=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            Tips.show("昵称设置成功");
            if(param1.data.silver)
            {
               sendNotification("update_play_money_info",param1.data.silver);
               sendNotification("UPDATE_NAME_ELF");
            }
            if(_isReturn)
            {
               LogUtil("返回精灵VOnicheng=" + _elfVo.nickName);
               sendNotification("SEND_ELF_DETAIL",_elfVo);
            }
         }
         else if(param1.status != "fail")
         {
            if(param1.status == "error")
            {
               Tips.show(param1.data.msg);
            }
         }
      }
      
      public function write2502(param1:int, param2:Boolean = false) : void
      {
         writeType = "2502";
         _recrId = param1;
         _isLimited = param2;
         LogUtil("_recrId=" + param1);
         var _loc3_:Object = {};
         _loc3_.msgId = 2502;
         _loc3_.recrId = param1;
         _loc3_.isLimited = param2;
         client.sendBytes(_loc3_);
      }
      
      public function note2502(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc8_:* = null;
         var _loc4_:* = 0;
         var _loc5_:* = null;
         var _loc7_:* = null;
         var _loc6_:* = 0;
         var _loc3_:* = null;
         LogUtil("2502=" + JSON.stringify(param1));
         var _loc9_:* = param1.status;
         if("success" !== _loc9_)
         {
            if("fail" !== _loc9_)
            {
               if("error " === _loc9_)
               {
                  Tips.show(param1.data.msg);
               }
            }
            else if((param1.data.msg as String).indexOf("钻石") != -1)
            {
               showDiamondAlert();
            }
            else if((param1.data.msg as String).indexOf("金币") != -1)
            {
               showMoneyAlert();
            }
         }
         else
         {
            if(!_isLimited && _recrId == 6 && PlayerVO.recruitTimes[4] == 0)
            {
               _loc9_ = PlayerVO.recruitTimes;
               var _loc10_:* = 4;
               var _loc11_:* = _loc9_[_loc10_] + 1;
               _loc9_[_loc10_] = _loc11_;
               sendNotification("amuse_update_ten_tips");
            }
            sendNotification("remove_amuse_last_resource");
            _loc2_ = [];
            if(param1.data.diamond != null && param1.data.diamond != PlayerVO.diamond)
            {
               UmengExtension.getInstance().UMAnalysic("buy|014|1|" + (PlayerVO.diamond - param1.data.diamond));
               sendNotification("update_play_diamond_info",param1.data.diamond);
            }
            if(param1.data.money != null && param1.data.money != PlayerVO.silver)
            {
               sendNotification("update_play_money_info",param1.data.money);
            }
            if(param1.data.spiritArr)
            {
               _loc8_ = param1.data.spiritArr;
               _loc4_ = 0;
               while(_loc4_ < _loc8_.length)
               {
                  _loc5_ = GetElfFromSever.getElfInfo(_loc8_[_loc4_]);
                  GetElfFactor.bagOrCom(_loc5_);
                  IllustrationsPro.saveElfInfo(_loc5_);
                  _loc2_.push(_loc5_);
                  _loc4_++;
               }
            }
            if(param1.data.proptoolArr)
            {
               LogUtil(param1.data.proptoolArr + " proptoolArr");
               _loc7_ = param1.data.proptoolArr;
               _loc6_ = 0;
               while(_loc6_ < _loc7_.length)
               {
                  _loc3_ = GetPropFactor.getPropVO(_loc7_[_loc6_].pId);
                  if(_loc7_[_loc6_].num != null)
                  {
                     _loc3_.rewardCount = _loc7_[_loc6_].num;
                  }
                  _loc2_.push(_loc3_);
                  GetPropFactor.addOrLessProp(_loc3_,true,_loc3_.rewardCount);
                  _loc6_++;
               }
            }
            sendNotification("load_amuse_mc",_loc2_);
            _loc2_ = null;
         }
      }
      
      public function write2503(param1:int) : void
      {
         itemId = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 2503;
         _loc2_.id = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note2503(param1:Object) : void
      {
         LogUtil("note2503: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.list)
            {
               sendNotification("amuse_update_score_list",param1.data.list);
            }
            sendNotification("amuse_update_score_point",param1.data.recruitScore);
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
      
      public function write2504(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:Object = {};
         _loc4_.msgId = 2504;
         _loc4_.id = param1;
         if(param3 == 1)
         {
            _loc4_.goodsId = {"pId":param2};
         }
         else
         {
            _loc4_.goodsId = {"spId":param2};
         }
         client.sendBytes(_loc4_);
      }
      
      public function note2504(param1:Object) : void
      {
         var _loc5_:* = 0;
         var _loc3_:* = null;
         var _loc4_:* = 0;
         var _loc2_:* = null;
         LogUtil("note2504: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.reward.poke)
            {
               _loc5_ = 0;
               while(_loc5_ < param1.data.reward.poke.length)
               {
                  _loc3_ = GetElfFromSever.getElfInfo(param1.data.reward.poke[_loc5_]);
                  GetElfFactor.bagOrCom(_loc3_,false);
                  IllustrationsPro.saveElfInfo(_loc3_);
                  _loc5_++;
               }
            }
            if(param1.data.reward.prop)
            {
               _loc4_ = 0;
               while(_loc4_ < param1.data.reward.prop.length)
               {
                  _loc2_ = GetPropFactor.getPropVO(param1.data.reward.prop[_loc4_].pId);
                  _loc2_.rewardCount = param1.data.reward.prop[_loc4_].num;
                  GetPropFactor.addOrLessProp(_loc2_,true,_loc2_.rewardCount);
                  _loc4_++;
               }
            }
            Tips.show("兑换成功。");
            write2503(itemId);
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
      
      private function showDiamondAlert() : void
      {
         var _loc1_:Alert = Alert.show("亲钻石不足，是否充值？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
         _loc1_.addEventListener("close",diamondAlert_closeHandle);
      }
      
      private function diamondAlert_closeHandle(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            sendNotification("switch_win",null,"load_diamond_panel");
         }
      }
      
      private function showMoneyAlert() : void
      {
         var _loc1_:Alert = Alert.show("亲，金币不足，是否使用金手指？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
         _loc1_.addEventListener("close",moneyAlert_closeHandle);
      }
      
      private function moneyAlert_closeHandle(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            sendNotification("switch_win",null,"load_money_panel");
         }
      }
   }
}
