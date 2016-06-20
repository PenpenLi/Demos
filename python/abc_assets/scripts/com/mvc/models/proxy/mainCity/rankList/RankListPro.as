package com.mvc.models.proxy.mainCity.rankList
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.common.net.Client;
   import com.common.themes.Tips;
   
   public class RankListPro extends Proxy
   {
      
      public static const NAME:String = "RankListPro";
       
      private var client:Client;
      
      private var _rankType:int;
      
      public function RankListPro(param1:Object = null)
      {
         super("RankListPro",param1);
         client = Client.getInstance();
         client.addCallObj("note2701",this);
      }
      
      public function write2701(param1:int) : void
      {
         _rankType = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 2701;
         _loc2_.rankType = param1 + 1;
         client.sendBytes(_loc2_);
      }
      
      public function note2701(param1:Object) : void
      {
         LogUtil("2701=" + JSON.stringify(param1));
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
         else if(param1.data.rankingList)
         {
            sendNotification("SEND_RANK",{
               "rankObj":param1.data,
               "rankType":_rankType
            });
         }
      }
   }
}
