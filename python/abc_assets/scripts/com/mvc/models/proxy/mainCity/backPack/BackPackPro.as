package com.mvc.models.proxy.mainCity.backPack
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.net.Client;
   import com.mvc.models.vos.elf.ElfVO;
   import flash.utils.getTimer;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.common.themes.Tips;
   import com.mvc.views.mediator.fighting.FightingMedia;
   import com.mvc.views.uis.mainCity.myElf.ElfInfoUI;
   import com.common.events.EventCenter;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.common.util.RewardHandle;
   
   public class BackPackPro extends Proxy
   {
      
      public static const NAME:String = "BackPackPro";
      
      public static var salePropVec:Vector.<PropVO> = new Vector.<PropVO>([]);
      
      public static var bagPropVecArr:Array = [];
      
      public static var littleMistNum:int;
      
      public static var middleMistNum:int;
      
      public static var heightMistNum:int;
       
      private var client:Client;
      
      private var _type:int;
      
      private var _elfVo:ElfVO;
      
      private var _propVo:PropVO;
      
      private var _callBack:Function;
      
      private var _skillId:int;
      
      private var skillPropVO:PropVO;
      
      private var _openPropVo:PropVO;
      
      private var _count:int;
      
      private var _sugerPropVo:PropVO;
      
      private var propVO:PropVO;
      
      public function BackPackPro(param1:Object = null)
      {
         super("BackPackPro",param1);
         client = Client.getInstance();
         client.addCallObj("note3000",this);
         client.addCallObj("note3001",this);
         client.addCallObj("note3002",this);
         client.addCallObj("note3003",this);
         client.addCallObj("note3004",this);
         client.addCallObj("note3005",this);
         client.addCallObj("note3006",this);
         client.addCallObj("note3007",this);
         client.addCallObj("note3008",this);
         client.addCallObj("note3011",this);
         client.addCallObj("note3012",this);
         client.addCallObj("note3013",this);
      }
      
      public function note3000(param1:Object) : void
      {
         var _loc5_:* = null;
         var _loc2_:* = null;
         var _loc6_:* = null;
         var _loc4_:* = 0;
         LogUtil("note3000=" + JSON.stringify(param1));
         var _loc3_:Number = getTimer();
         PlayerVO.elfBallVec = Vector.<PropVO>([]);
         PlayerVO.medicineVec = Vector.<PropVO>([]);
         PlayerVO.otherPropVec = Vector.<PropVO>([]);
         PlayerVO.propBroken = Vector.<PropVO>([]);
         PlayerVO.sandBagVec = Vector.<PropVO>([]);
         PlayerVO.evolveStoneVec = Vector.<PropVO>([]);
         PlayerVO.dollVec = Vector.<PropVO>([]);
         PlayerVO.learnMachineVec = Vector.<PropVO>([]);
         salePropVec = Vector.<PropVO>([]);
         if(param1.status == "success")
         {
            _loc5_ = deleNot(param1.data.propList);
            _loc4_ = 0;
            while(_loc4_ < _loc5_.length)
            {
               _loc2_ = GetPropFactor.getPropVO(_loc5_[_loc4_].pId);
               _loc2_.count = _loc5_[_loc4_].num;
               if(_loc2_.count != 0)
               {
                  if(_loc2_.name == "扫荡券")
                  {
                     PlayerVO.raidsProp = _loc2_;
                  }
                  if(_loc2_.isSale == 1 || _loc2_.isSale == 2)
                  {
                     salePropVec.push(_loc2_);
                  }
                  if(_loc2_.type == 14)
                  {
                     PlayerVO.trashyPropVec.push(_loc2_);
                  }
                  if(_loc2_.type == 25)
                  {
                     PlayerVO.huntingPropVec.push(_loc2_);
                  }
                  if(_loc2_.type == 26)
                  {
                     PlayerVO.bugleChipVec.push(_loc2_);
                  }
                  if(_loc2_.type == 2 || _loc2_.type == 3 || _loc2_.type == 16 || _loc2_.type == 17)
                  {
                     PlayerVO.medicineVec.push(_loc2_);
                  }
                  else if(_loc2_.type == 5 || _loc2_.type == 20 || _loc2_.type == 30)
                  {
                     if(_loc2_.type == 20)
                     {
                        _loc6_ = _loc2_;
                     }
                     else
                     {
                        PlayerVO.elfBallVec.push(_loc2_);
                     }
                  }
                  else if(_loc2_.type == 10 || _loc2_.type == 11 || _loc2_.type == 12 || _loc2_.type == 13 || _loc2_.type == 22)
                  {
                     PlayerVO.propBroken.push(_loc2_);
                  }
                  else if(_loc2_.type == 24)
                  {
                     PlayerVO.sandBagVec.push(_loc2_);
                  }
                  else if(_loc2_.type == 4)
                  {
                     PlayerVO.evolveStoneVec.push(_loc2_);
                  }
                  else if(_loc2_.type == 18 || _loc2_.type == 19)
                  {
                     PlayerVO.dollVec.push(_loc2_);
                  }
                  else if(_loc2_.type == 6)
                  {
                     PlayerVO.learnMachineVec.push(_loc2_);
                  }
                  else
                  {
                     PlayerVO.otherPropVec.push(_loc2_);
                  }
               }
               _loc4_++;
            }
            if(_loc6_)
            {
               PlayerVO.elfBallVec.push(_loc6_);
            }
            LogUtil("背包道具列表=========",getTimer() - _loc3_);
            GetPropFactor.idSort(PlayerVO.medicineVec);
            GetPropFactor.idSort(PlayerVO.otherPropVec);
            bagPropVecArr.push(PlayerVO.medicineVec,PlayerVO.elfBallVec,PlayerVO.learnMachineVec,PlayerVO.propBroken,PlayerVO.sandBagVec,PlayerVO.evolveStoneVec,PlayerVO.dollVec,PlayerVO.otherPropVec);
            LogUtil("出售物品=" + salePropVec);
            LogUtil("药品=" + PlayerVO.medicineVec);
            LogUtil("精灵球=" + PlayerVO.elfBallVec);
            LogUtil("其他物品=" + PlayerVO.otherPropVec);
            LogUtil("碎片=" + PlayerVO.propBroken);
            LogUtil("沙袋=" + PlayerVO.sandBagVec);
            LogUtil("进化是=" + PlayerVO.evolveStoneVec);
            LogUtil("玩偶=" + PlayerVO.dollVec);
            LogUtil("学习机=" + PlayerVO.learnMachineVec);
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write3000(param1:int) : void
      {
         _type = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 3000;
         client.sendBytes(_loc2_);
      }
      
      public function note3002(param1:Object) : void
      {
         LogUtil("result3002=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            updateBag(propVO,false);
            if(FightingMedia.isFighting)
            {
               if(propVO.id == 149)
               {
                  littleMistNum = littleMistNum + 1;
               }
               if(propVO.id == 150)
               {
                  middleMistNum = middleMistNum + 1;
               }
               if(propVO.id == 151)
               {
                  heightMistNum = heightMistNum + 1;
               }
               sendNotification("show_prop_info",propVO);
            }
            if(facade.hasMediator("ReCallSkillMedia"))
            {
               sendNotification("recallskill_use_prop_success");
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
      
      private function updateBag(param1:PropVO, param2:Boolean = false) : void
      {
         var _loc3_:int = GetPropFactor.getPropIndex(param1);
         GetPropFactor.addOrLessProp(param1,false);
         if(!GetPropFactor.getPropIndex(param1))
         {
            _loc3_ = _loc3_ > 0?_loc3_ - 1:0.0;
         }
         if(param2)
         {
            sendNotification("SHOW_BACKPACK");
         }
         sendNotification("UPDATA_USE_PROP",_loc3_);
      }
      
      public function write3002(param1:PropVO) : void
      {
         propVO = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 3002;
         LogUtil("道具主键id=" + param1.id);
         _loc2_.pId = param1.id;
         client.sendBytes(_loc2_);
      }
      
      public function note3003(param1:Object) : void
      {
         LogUtil("note3003 =" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            sendNotification("carry_prop_success");
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
      
      public function write3003(param1:int, param2:int) : void
      {
         var _loc3_:Object = {};
         _loc3_.msgId = 3003;
         LogUtil("write3003 静态id=" + param1,"精灵主键id=" + param2);
         _loc3_.propStaId = param1;
         _loc3_.spId = param2;
         client.sendBytes(_loc3_);
      }
      
      public function note3004(param1:Object) : void
      {
         LogUtil("result3004=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(_propVo.type == 16 || _propVo.type == 17)
            {
               _elfVo.hagberryProp = null;
               GetPropFactor.addOrLessProp(_propVo);
               Tips.show(_elfVo.nickName + "卸下了【" + _propVo.name + "】");
               sendNotification("UNLOAD_PROP",_propVo);
               ElfInfoUI.getInstance().myElfVo = _elfVo;
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
      
      public function write3004(param1:ElfVO, param2:PropVO) : void
      {
         _propVo = param2;
         _elfVo = param1;
         var _loc3_:Object = {};
         _loc3_.msgId = 3004;
         _loc3_.spId = param1.id;
         _loc3_.pId = param2.id;
         client.sendBytes(_loc3_);
      }
      
      public function write3005(param1:int, param2:int, param3:int = -1, param4:int = -1) : void
      {
         LogUtil("write3005=" + param1,param2,param3,param4);
         var _loc5_:Object = {};
         _loc5_.msgId = 3005;
         _loc5_.pId = param1;
         _loc5_.spId = param2;
         if(param4 > 0)
         {
            _loc5_.skillIndex = param4;
         }
         if(param3 != -1)
         {
            if(param3 == 100)
            {
               _loc5_.targetId = "all";
            }
            else
            {
               _loc5_.targetId = param3;
            }
         }
         LogUtil("write3005=",JSON.stringify(_loc5_));
         client.sendBytes(_loc5_);
      }
      
      public function note3005(param1:Object) : void
      {
         LogUtil("3005=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            sendNotification("use_prop_success");
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
      
      public function write3006(param1:int, param2:int) : void
      {
         LogUtil("write3006=" + param1,param2);
         var _loc3_:Object = {};
         _loc3_.msgId = 3006;
         _loc3_.spId = param1;
         _loc3_.skillId = param2;
         client.sendBytes(_loc3_);
      }
      
      public function note3006(param1:Object) : void
      {
         var _loc2_:* = null;
         LogUtil("3006=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            EventCenter.dispatchEvent("GIVE_UP_SKILL_SUCCESS");
            if(param1.data.silver)
            {
               sendNotification("update_play_money_info",param1.data.silver);
            }
            if(param1.data.retSilver)
            {
               _loc2_ = Alert.show("你替换技能获得了" + param1.data.retSilver + "金币","",new ListCollection([{"label":"我知道了"}]));
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
      
      public function write3007(param1:int, param2:int, param3:int, param4:Function) : void
      {
         LogUtil("write3007=" + param1,param2,param3);
         var _loc5_:Object = {};
         _loc5_.msgId = 3007;
         _loc5_.spId = param1;
         _loc5_.skillId = param2;
         _loc5_.skillIndex = param3;
         _callBack = param4;
         _skillId = param2;
         client.sendBytes(_loc5_);
      }
      
      public function note3007(param1:Object) : void
      {
         LogUtil("3007=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(_callBack)
            {
               _callBack();
            }
         }
         else if(param1.status == "fail")
         {
            Alert.show(param1.msgId + "处理失败:" + param1.data.msg,"",new ListCollection([{"label":"确定"}]));
         }
      }
      
      public function write3008(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:Object = {};
         _loc3_.msgId = 3008;
         if(param2)
         {
            _loc3_.hornId = param1;
         }
         else
         {
            _loc3_.pieceId = param1;
         }
         client.sendBytes(_loc3_);
      }
      
      public function note3008(param1:Object) : void
      {
         LogUtil("3008=" + JSON.stringify(param1));
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
            Tips.show("合成成功");
            EventCenter.dispatchEvent("BOKEN_COMPOSE_SUCCES",{"mainId":param1.data.pId});
         }
      }
      
      public function write3011(param1:PropVO, param2:int, param3:int) : void
      {
         _openPropVo = param1;
         _count = param3;
         var _loc4_:Object = {};
         _loc4_.msgId = 3011;
         _loc4_.pId = param1.id;
         _loc4_.propType = param2;
         _loc4_.num = param3;
         client.sendBytes(_loc4_);
      }
      
      public function note3011(param1:Object) : void
      {
         LogUtil("3011=" + JSON.stringify(param1));
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
            GetPropFactor.addOrLessProp(_openPropVo,false,_count);
            if(_openPropVo.type == 29)
            {
               GetPropFactor.addOrLessProp(GetPropFactor.getProp(_openPropVo.actRole),false,_count);
            }
            sendNotification("SHOW_BACKPACK");
            sendNotification("UPDATA_USE_PROP",GetPropFactor.getPropIndex(_openPropVo));
         }
      }
      
      public function write3012(param1:PropVO) : void
      {
         _sugerPropVo = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 3012;
         client.sendBytes(_loc2_);
      }
      
      public function note3012(param1:Object) : void
      {
         LogUtil("3012=" + JSON.stringify(param1));
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
            Tips.show("您的当前体力为 " + param1.data.actionForce);
            sendNotification("update_play_power_info",param1.data.actionForce);
            GetPropFactor.addOrLessProp(_sugerPropVo,false);
            sendNotification("SHOW_BACKPACK");
            sendNotification("UPDATA_USE_PROP",GetPropFactor.getPropIndex(_sugerPropVo));
         }
      }
      
      public function write3013(param1:int, param2:int, param3:int, param4:PropVO, param5:int, param6:Function) : void
      {
         _callBack = param6;
         _skillId = param2;
         skillPropVO = param4;
         var _loc7_:Object = {};
         _loc7_.msgId = 3013;
         _loc7_.spId = param1;
         _loc7_.skillIndex = param3;
         if(param4)
         {
            _loc7_.prop = {
               "id":param4.id,
               "num":param5
            };
         }
         if(!param4 || param4 && param4.type != 6)
         {
            _loc7_.newSkId = param2;
         }
         client.sendBytes(_loc7_);
      }
      
      public function note3013(param1:Object) : void
      {
         LogUtil("note3013=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(skillPropVO)
            {
               updateBag(skillPropVO,true);
            }
            if(_callBack)
            {
               _callBack();
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function deleNot(param1:Array) : Array
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_].pId == 20 || param1[_loc2_].pId == 135 || param1[_loc2_].pId == 136 || param1[_loc2_].pId >= 127 && param1[_loc2_].pId <= 130 || param1[_loc2_].pId >= 452 && param1[_loc2_].pId <= 702)
            {
               param1.splice(_loc2_,1);
               _loc2_--;
            }
            _loc2_++;
         }
         return param1;
      }
   }
}
