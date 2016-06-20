package com.mvc.controllers.backpack
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.proxy.mainCity.backPack.BackPackPro;
   
   public class UpdateBackpackCmd extends SimpleCommand
   {
       
      public function UpdateBackpackCmd()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         LogUtil(param1.getBody() + "==更新背包数据");
         if(param1.getBody() as int == 1)
         {
            (facade.retrieveProxy("BackPackPro") as BackPackPro).write3000(1);
         }
         else
         {
            (facade.retrieveProxy("BackPackPro") as BackPackPro).write3000(0);
         }
      }
   }
}
