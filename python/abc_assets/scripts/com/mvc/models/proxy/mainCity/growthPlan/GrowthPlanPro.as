package com.mvc.models.proxy.mainCity.growthPlan
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.common.net.Client;
   import com.massage.ane.UmengExtension;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import com.mvc.views.mediator.mainCity.growthPlan.GrowthPlanMediator;
   import com.common.util.RewardHandle;
   
   public class GrowthPlanPro extends Proxy
   {
      
      public static const NAME:String = "GrowthPlanPro";
       
      private var client:Client;
      
      private var selectIndex:int;
      
      public function GrowthPlanPro(param1:Object = null)
      {
         super("GrowthPlanPro",param1);
         client = Client.getInstance();
         client.addCallObj("note1903",this);
         client.addCallObj("note1904",this);
         client.addCallObj("note1905",this);
      }
      
      public function write1903() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 1903;
         client.sendBytes(_loc1_);
      }
      
      public function note1903(param1:Object) : void
      {
         LogUtil("note1903: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            sendNotification("growthplan_update_list",param1.data);
            if(param1.data.diamond)
            {
               UmengExtension.getInstance().UMAnalysic("buy|05|1|" + (PlayerVO.diamond - param1.data.diamond));
               sendNotification("update_play_diamond_info",param1.data.diamond);
            }
            else
            {
               PlayerVO.diamond = PlayerVO.diamond - 1000;
               UmengExtension.getInstance().UMAnalysic("buy|05|1|1000");
               sendNotification("update_play_diamond_info",PlayerVO.diamond);
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
      
      public function write1904() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 1904;
         client.sendBytes(_loc1_);
      }
      
      public function note1904(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = false;
         var _loc4_:* = 0;
         LogUtil("note1904: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            _loc2_ = param1.data.growFoundation;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               if(_loc2_[_loc4_] == 1)
               {
                  _loc3_ = true;
                  GrowthPlanMediator.isGet = true;
                  sendNotification("SHOW_GROWTHPLAN");
                  break;
               }
               _loc4_++;
            }
            if(!param1.data.isBuy && PlayerVO.vipRank >= 2)
            {
               GrowthPlanMediator.isGet = true;
               sendNotification("SHOW_GROWTHPLAN");
            }
            sendNotification("growthplan_update_list",param1.data);
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
      
      public function write1905(param1:int) : void
      {
         selectIndex = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 1905;
         _loc2_.growKey = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note1905(param1:Object) : void
      {
         LogUtil("note1905: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            sendNotification("growthplan_get_foundation_success",selectIndex);
            RewardHandle.Reward(param1.data,8);
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
