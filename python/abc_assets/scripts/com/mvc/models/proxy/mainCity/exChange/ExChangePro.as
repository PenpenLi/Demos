package com.mvc.models.proxy.mainCity.exChange
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.mvc.models.vos.mainCity.exChange.ExChangeVO;
   import com.common.net.Client;
   import com.common.util.RewardHandle;
   import com.common.events.EventCenter;
   import com.common.themes.Tips;
   import com.common.util.xmlVOHandler.GetElfFactor;
   
   public class ExChangePro extends Proxy
   {
      
      public static const NAME:String = "ExChangePro";
      
      public static var exChangeVec:Vector.<ExChangeVO> = new Vector.<ExChangeVO>([]);
       
      private var client:Client;
      
      public var indexArr:Array;
      
      public function ExChangePro(param1:Object = null)
      {
         indexArr = [2,1,0];
         super("ExChangePro",param1);
         client = Client.getInstance();
         client.addCallObj("note3801",this);
         client.addCallObj("note3802",this);
      }
      
      public function write3801(param1:int, param2:Array) : void
      {
         var _loc3_:Object = {};
         _loc3_.msgId = 3801;
         _loc3_.exchangeLevel = param1;
         _loc3_.spiritIdArr = param2;
         client.sendBytes(_loc3_);
      }
      
      public function note3801(param1:Object) : void
      {
         LogUtil("note3801= " + JSON.stringify(param1));
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
            EventCenter.dispatchEvent("EXCHANGE_ELF_SUCCESS");
         }
      }
      
      public function write3802() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 3802;
         client.sendBytes(_loc1_);
      }
      
      public function note3802(param1:Object) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = 0;
         var _loc2_:* = null;
         var _loc5_:* = 0;
         LogUtil("note3802= " + JSON.stringify(param1));
         var _loc6_:* = param1.status;
         if("success" !== _loc6_)
         {
            if("fail" !== _loc6_)
            {
               if("error" === _loc6_)
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
            _loc3_ = param1.data.info;
            exChangeVec = Vector.<ExChangeVO>([]);
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc2_ = new ExChangeVO();
               _loc2_.index = indexArr[_loc4_];
               _loc2_.modeLv = _loc3_[_loc4_].level;
               _loc2_.lessNum = _loc3_[_loc4_].gradeTimes;
               _loc2_.getElfVo = GetElfFactor.getElfVO(_loc3_[_loc4_].gainSpiritSpId);
               _loc5_ = 0;
               while(_loc5_ < _loc3_[_loc4_].spiritSpIdArr.length)
               {
                  _loc2_.elfVec.push(GetElfFactor.getElfVO(_loc3_[_loc4_].spiritSpIdArr[_loc5_]));
                  _loc5_++;
               }
               exChangeVec.unshift(_loc2_);
               _loc4_++;
            }
            sendNotification("SHOW_EXCHANGE_MODE");
         }
      }
   }
}
