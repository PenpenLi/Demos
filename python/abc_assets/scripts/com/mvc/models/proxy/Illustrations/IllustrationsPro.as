package com.mvc.models.proxy.Illustrations
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.net.Client;
   import com.mvc.views.mediator.fighting.FightingLogicFactor;
   
   public class IllustrationsPro extends Proxy
   {
      
      public static const NAME:String = "IllustrationsPro";
      
      public static var markStr:Array;
       
      private var client:Client;
      
      public function IllustrationsPro(param1:Object = null)
      {
         super("IllustrationsPro",param1);
         client = Client.getInstance();
         client.addCallObj("note1301",this);
         client.addCallObj("note1302",this);
      }
      
      public static function saveElfInfo(param1:ElfVO) : void
      {
         IllustrationsPro.markStr[param1.elfId - 1] = 2;
      }
      
      public function write1301() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 1301;
         client.sendBytes(_loc1_);
      }
      
      public function note1301(param1:Object) : void
      {
         LogUtil("1301=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            markStr = param1.data.markStr;
         }
         sendNotification("SHOW_ILLUSTRATIONS_ELF",markStr);
      }
      
      public function write1302(param1:int) : void
      {
         if(FightingLogicFactor.isPVP)
         {
            return;
         }
         var _loc2_:Object = {};
         _loc2_.msgId = 1302;
         _loc2_.spStaId = param1;
         client.sendBytes(_loc2_,false);
         return;
         §§push(LogUtil("1302=" + JSON.stringify(_loc2_)));
      }
      
      public function note1302(param1:Object) : void
      {
         LogUtil("1302=" + JSON.stringify(param1));
         if(param1.result)
         {
            markStr = param1.markStr;
         }
         sendNotification("SHOW_ILLUSTRATIONS_ELF",markStr);
      }
   }
}
