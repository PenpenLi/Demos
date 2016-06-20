package com.mvc.models.proxy.mainCity.active
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.mvc.models.vos.mainCity.active.ActiveVO;
   import com.common.net.Client;
   import com.mvc.views.uis.worldHorn.WorldTime;
   import com.mvc.models.vos.mainCity.active.ActiveChildVO;
   import com.mvc.views.mediator.mainCity.active.ActiveMeida;
   import com.common.themes.Tips;
   import com.common.util.RewardHandle;
   import com.common.events.EventCenter;
   
   public class ActivePro extends Proxy
   {
      
      public static const NAME:String = "ActivePro";
      
      public static var activeVec:Vector.<ActiveVO> = new Vector.<ActiveVO>([]);
       
      private var client:Client;
      
      public function ActivePro(param1:Object = null)
      {
         super("ActivePro",param1);
         client = Client.getInstance();
         client.addCallObj("note1901",this);
         client.addCallObj("note1902",this);
      }
      
      public function write1901() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 1901;
         client.sendBytes(_loc1_);
      }
      
      public function note1901(param1:Object) : void
      {
         var _loc4_:* = null;
         var _loc5_:* = 0;
         var _loc3_:* = null;
         var _loc7_:* = null;
         var _loc6_:* = 0;
         var _loc2_:* = null;
         var _loc8_:* = 0;
         LogUtil("1901=" + JSON.stringify(param1));
         var _loc9_:* = param1.status;
         if("success" !== _loc9_)
         {
            if("fail" !== _loc9_)
            {
               if("error" !== _loc9_)
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
            _loc4_ = param1.data.atvAry;
            activeVec = Vector.<ActiveVO>([]);
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if(_loc4_[_loc5_])
               {
                  if(WorldTime.getInstance().serverTime <= _loc4_[_loc5_].atvEndTime)
                  {
                     _loc3_ = new ActiveVO();
                     _loc3_.weight = _loc4_[_loc5_].weight;
                     _loc3_.atvEndTime = _loc4_[_loc5_].atvEndTime;
                     _loc3_.atvStartTime = _loc4_[_loc5_].atvStartTime;
                     _loc3_.atvPicId = _loc4_[_loc5_].atvPicId;
                     _loc3_.atvDescs = _loc4_[_loc5_].atvDescs.replace(new RegExp("\\r","g"),"");
                     _loc3_.atvTitle = _loc4_[_loc5_].atvTitle;
                     _loc3_.id = _loc4_[_loc5_].id;
                     _loc3_.atvType = _loc4_[_loc5_].atvStyle;
                     if(_loc4_[_loc5_].atvChild)
                     {
                        _loc7_ = _loc4_[_loc5_].atvChild;
                        _loc6_ = 0;
                        while(_loc6_ < _loc7_.length)
                        {
                           _loc2_ = new ActiveChildVO();
                           _loc2_.rewardTip = _loc7_[_loc6_].rewardTip;
                           _loc2_.doedTime = _loc7_[_loc6_].doedTime;
                           _loc2_.status = _loc7_[_loc6_].status;
                           _loc2_.id = _loc7_[_loc6_].id;
                           if(_loc7_[_loc6_].rewardPic)
                           {
                              _loc2_.rewardPic = _loc7_[_loc6_].rewardPic;
                           }
                           _loc2_.reward = _loc7_[_loc6_].reward;
                           if(_loc7_[_loc6_].paramJNS.reqNum)
                           {
                              _loc2_.reqNum = _loc7_[_loc6_].paramJNS.reqNum;
                           }
                           if(_loc7_[_loc6_].paramJNS.reqLv)
                           {
                              _loc2_.reqNum = _loc7_[_loc6_].paramJNS.reqLv;
                           }
                           _loc3_.activeChildVec.push(_loc2_);
                           _loc6_++;
                        }
                     }
                     activeVec.push(_loc3_);
                  }
               }
               _loc5_++;
            }
            sortWeight(activeVec);
            if(activeVec.length > 0)
            {
               if(activeVec[0].atvTitle == "VIP等级礼包")
               {
                  _loc8_ = 0;
                  while(_loc8_ < activeVec[0].activeChildVec.length)
                  {
                     if(activeVec[0].activeChildVec[_loc8_].status == 1)
                     {
                        ActiveMeida.isVIPgiftNew = true;
                        sendNotification("SHOW_VIPGIFT_NEWS");
                        break;
                     }
                     _loc8_++;
                  }
               }
               if(ActiveMeida.isnewReward())
               {
                  sendNotification("SHOW_ACTIVE_REWARD");
               }
               sendNotification("SHOW_ACTIVE_MEUN");
            }
            else
            {
               Tips.show("亲，现在还没有活动哦");
            }
         }
      }
      
      public function write1902(param1:int, param2:int) : void
      {
         LogUtil("acId=",param1,"chId=",param2);
         var _loc3_:Object = {};
         _loc3_.msgId = 1902;
         _loc3_.acId = param1;
         _loc3_.chId = param2;
         client.sendBytes(_loc3_);
      }
      
      public function note1902(param1:Object) : void
      {
         LogUtil("1902=" + JSON.stringify(param1));
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
            RewardHandle.Reward(param1.data.reward,4);
            EventCenter.dispatchEvent("ACTIVE_REWARD_SUCCESS");
            sendNotification("CHECK_ACTIVE_MEUN");
         }
      }
      
      private function sortWeight(param1:Vector.<ActiveVO>) : void
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
               if(param1[_loc4_].weight < param1[_loc4_ + 1].weight)
               {
                  _loc2_ = param1[_loc4_];
                  param1[_loc4_] = param1[_loc4_ + 1];
                  param1[_loc4_ + 1] = _loc2_;
               }
               _loc4_++;
            }
            _loc3_++;
         }
      }
   }
}
