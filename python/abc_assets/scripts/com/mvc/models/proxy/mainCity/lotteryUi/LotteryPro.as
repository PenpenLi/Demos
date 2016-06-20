package com.mvc.models.proxy.mainCity.lotteryUi
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import starling.display.DisplayObject;
   import com.common.net.Client;
   import com.mvc.models.vos.mainCity.lottery.LotteryVO;
   import com.mvc.models.vos.mainCity.lottery.LotteryRewardVO;
   import com.common.themes.Tips;
   import com.mvc.models.vos.login.PlayerVO;
   
   public class LotteryPro extends Proxy
   {
      
      public static const NAME:String = "LotteryPro";
      
      public static var lotteryVec:Vector.<DisplayObject>;
      
      public static var reward:Object;
      
      public static var LotteryLessTime:int;
       
      private var client:Client;
      
      public function LotteryPro(param1:Object = null)
      {
         super("LotteryPro",param1);
         client = Client.getInstance();
         client.addCallObj("note4001",this);
         client.addCallObj("note4002",this);
      }
      
      public function write4001() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 4001;
         client.sendBytes(_loc1_);
      }
      
      public function note4001(param1:Object) : void
      {
         var _loc4_:* = 0;
         var _loc2_:* = 0;
         var _loc6_:* = null;
         var _loc5_:* = null;
         LogUtil("4001=" + JSON.stringify(param1));
         var _loc3_:Object = param1.data;
         if(param1.status == "success")
         {
            LotteryVO.costDiamond = _loc3_.costDiamond;
            LotteryVO.currentTimes = _loc3_.currentTimes;
            LotteryVO.endTime = _loc3_.endTime;
            LotteryVO.startTime = _loc3_.nowTime;
            LotteryVO.upTotalRes = _loc3_.upTotalRes;
            LotteryLessTime = _loc3_.endTime - _loc3_.nowTime;
            LotteryVO.payList = [];
            if(_loc3_.payList)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_.payList.length)
               {
                  LotteryVO.payList.push(_loc3_.payList[_loc4_]);
                  _loc4_++;
               }
            }
            if(_loc3_.rewardList)
            {
               LotteryVO.rewardList = Vector.<LotteryRewardVO>([]);
               _loc2_ = 0;
               while(_loc2_ < _loc3_.rewardList.length)
               {
                  _loc6_ = _loc3_.rewardList[_loc2_];
                  _loc5_ = new LotteryRewardVO();
                  _loc5_.diamond = _loc6_.reward.diamond;
                  _loc5_.id = _loc6_.id;
                  _loc5_.exper = _loc6_.reward.exper;
                  _loc5_.silver = _loc6_.reward.silver;
                  if(_loc6_.reward.diamond)
                  {
                     _loc5_.diamond = {"num":_loc6_.reward.diamond.num};
                  }
                  if(_loc6_.reward.poke)
                  {
                     _loc5_.poke = {
                        "lv":_loc6_.reward.poke[0].lv,
                        "num":_loc6_.reward.poke[0].num,
                        "pokeid":_loc6_.reward.poke[0].pokeId
                     };
                  }
                  if(_loc6_.reward.prop)
                  {
                     _loc5_.prop = {
                        "num":_loc6_.reward.prop[0].num,
                        "pId":_loc6_.reward.prop[0].pId
                     };
                  }
                  LotteryVO.rewardList.push(_loc5_);
                  _loc2_++;
               }
               sendNotification("show_lottery_viewlist");
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write4002() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 4002;
         client.sendBytes(_loc1_);
      }
      
      public function note4002(param1:Object) : void
      {
         LogUtil("4002=" + JSON.stringify(param1));
         var _loc2_:Object = param1.data;
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
               sendNotification("show_lottery_close");
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            reward = _loc2_;
            if(PlayerVO.diamond < LotteryVO.costDiamond)
            {
               Tips.show("钻石不足，请充值");
               sendNotification("show_lottery_close");
            }
            else
            {
               sendNotification("update_play_diamond_info",PlayerVO.diamond - LotteryVO.costDiamond);
               sendNotification("show_lottery_effect");
            }
         }
      }
   }
}
