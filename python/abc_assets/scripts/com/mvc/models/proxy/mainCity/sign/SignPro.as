package com.mvc.models.proxy.mainCity.sign
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.mvc.models.vos.mainCity.sign.AddUpVO;
   import com.common.net.Client;
   import com.mvc.models.vos.mainCity.sign.SignVO;
   import com.common.themes.Tips;
   import com.common.events.EventCenter;
   import com.common.util.RewardHandle;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.vos.elf.ElfVO;
   
   public class SignPro extends Proxy
   {
      
      public static const NAME:String = "SignPro";
      
      public static var monRewardArr:Array;
      
      public static var addUpVec:Vector.<AddUpVO> = new Vector.<AddUpVO>([]);
       
      private var client:Client;
      
      public function SignPro(param1:Object = null)
      {
         super("SignPro",param1);
         client = Client.getInstance();
         client.addCallObj("note2100",this);
         client.addCallObj("note2101",this);
         client.addCallObj("note2102",this);
         client.addCallObj("note2103",this);
      }
      
      public static function rankSort(param1:Vector.<AddUpVO>) : Vector.<AddUpVO>
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
               if(param1[_loc4_].id > param1[_loc4_ + 1].id)
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
      
      public function write2100() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 2100;
         client.sendBytes(_loc1_);
      }
      
      public function note2100(param1:Object) : void
      {
         var _loc3_:* = null;
         var _loc7_:* = null;
         var _loc6_:* = null;
         var _loc5_:* = 0;
         var _loc2_:* = null;
         LogUtil("2100=" + JSON.stringify(param1));
         var _loc9_:* = param1.status;
         if("success" !== _loc9_)
         {
            if("fail" !== _loc9_)
            {
               if("error" === _loc9_)
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
            monRewardArr = [];
            addUpVec = Vector.<AddUpVO>([]);
            if(!param1.data.staSignReward)
            {
               return;
            }
            _loc3_ = param1.data.staSignReward;
            _loc9_ = 0;
            var _loc8_:* = _loc3_;
            for each(var _loc4_ in _loc3_)
            {
               _loc7_ = new AddUpVO();
               _loc7_.rewardArr = getRewardObj(_loc4_.rewardJNS,true) as Array;
               _loc7_.id = _loc4_.id;
               _loc7_.times = _loc4_.times;
               addUpVec.push(_loc7_);
            }
            rankSort(addUpVec);
            if(!param1.data.staSignin)
            {
               return;
            }
            _loc6_ = param1.data.staSignin;
            SignVO.month = _loc6_.id;
            _loc5_ = 1;
            while(_loc5_ < 32)
            {
               _loc2_ = "_" + _loc5_ + "JNS";
               if(_loc6_.hasOwnProperty(_loc2_))
               {
                  if(_loc6_[_loc2_])
                  {
                     monRewardArr.push(getRewardObj(_loc6_[_loc2_]));
                  }
                  else
                  {
                     break;
                  }
               }
               _loc5_++;
            }
            write2101();
            LogUtil("addUpVec = ",addUpVec.length);
            LogUtil("monRewardArr = ",monRewardArr.length);
         }
      }
      
      public function write2101() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 2101;
         client.sendBytes(_loc1_);
      }
      
      public function note2101(param1:Object) : void
      {
         LogUtil("2101=" + JSON.stringify(param1));
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
            SignVO.isTodaySigned = param1.data.isTodaySigned;
            SignVO.lastRewardId = param1.data.lastRewardId;
            SignVO.monthTimes = param1.data.monthTimes;
            SignVO.totalTimes = param1.data.totalTimes;
            if(!SignVO.isTodaySigned)
            {
               sendNotification("SHOW_SIGN_NEWS");
               Tips.show("亲，你今天还没有签到哦");
            }
            else
            {
               sendNotification("HIDE_SIGN_NEWS");
            }
         }
      }
      
      public function write2102() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 2102;
         client.sendBytes(_loc1_);
      }
      
      public function note2102(param1:Object) : void
      {
         LogUtil("2102=" + JSON.stringify(param1));
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
            EventCenter.dispatchEvent("SIGN_SUCCESS");
            SignVO.isTodaySigned = true;
            §§dup(SignVO).monthTimes++;
            §§dup(SignVO).totalTimes++;
            RewardHandle.Reward(param1.data.reward,6);
            sendNotification("UPDATE_SIGN_INFO");
            sendNotification("HIDE_SIGN_NEWS");
         }
      }
      
      public function write2103() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 2103;
         client.sendBytes(_loc1_);
      }
      
      public function note2103(param1:Object) : void
      {
         LogUtil("2103=" + JSON.stringify(param1));
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
            §§dup(SignVO).lastRewardId++;
            if(SignVO.lastRewardId >= 5)
            {
               SignVO.lastRewardId = 0;
               SignVO.totalTimes = 0;
            }
            RewardHandle.Reward(param1.data.reward,6);
            sendNotification("UPDATE_UPADDSIGN_INFO");
         }
      }
      
      private function getRewardObj(param1:Object, param2:Boolean = false) : Object
      {
         var _loc5_:* = 0;
         var _loc4_:* = null;
         var _loc7_:* = 0;
         var _loc6_:* = null;
         var _loc3_:Array = [];
         if(param1.silver)
         {
            if(param2)
            {
               _loc3_.push("奖励金币×" + param1.silver.num);
            }
            else
            {
               return "奖励金币×" + param1.silver.num;
            }
         }
         if(param1.diamond)
         {
            if(param2)
            {
               _loc3_.push("奖励钻石×" + param1.diamond.num);
            }
            else
            {
               return "奖励钻石×" + param1.diamond.num;
            }
         }
         if(param1.prop)
         {
            _loc5_ = 0;
            while(_loc5_ < param1.prop.length)
            {
               _loc4_ = GetPropFactor.getPropVO(param1.prop[_loc5_].pId);
               _loc4_.rewardCount = param1.prop[_loc5_].num;
               if(param2)
               {
                  _loc3_.push(_loc4_);
                  _loc5_++;
                  continue;
               }
               return _loc4_;
            }
         }
         if(param1.poke)
         {
            _loc7_ = 0;
            while(_loc7_ < param1.poke.length)
            {
               _loc6_ = GetElfFactor.getElfVO(param1.poke[_loc7_].pokeId);
               _loc6_.lv = param1.poke[_loc7_].lv;
               if(param2)
               {
                  _loc3_.push(_loc6_);
                  _loc7_++;
                  continue;
               }
               return _loc6_;
            }
         }
         if(param2)
         {
            return _loc3_;
         }
         return null;
      }
   }
}
