package com.mvc.models.proxy.mainCity.miracle
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.common.net.Client;
   import com.common.util.xmlVOHandler.GetElfFromSever;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.proxy.Illustrations.IllustrationsPro;
   import com.common.themes.Tips;
   
   public class MiraclePro extends Proxy
   {
      
      public static var NAME:String = "MiraclePro";
       
      private var client:Client;
      
      public function MiraclePro(param1:Object = null)
      {
         super(NAME,param1);
         client = Client.getInstance();
         client.addCallObj("note2601",this);
      }
      
      public function write2601(param1:Array) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 2601;
         _loc2_.spiritIdArr = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note2601(param1:Object) : void
      {
         var _loc2_:* = null;
         LogUtil("note2601: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.spirit)
            {
               _loc2_ = GetElfFromSever.getElfInfo(param1.data.spirit);
               IllustrationsPro.saveElfInfo(_loc2_);
               sendNotification("miracle_update_elfvec",_loc2_);
               sendNotification("miracle_exchange_complete");
            }
            if(param1.data.silver != null)
            {
               sendNotification("update_play_money_info",param1.data.silver);
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
   }
}
