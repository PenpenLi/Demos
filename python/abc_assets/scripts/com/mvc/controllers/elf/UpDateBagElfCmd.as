package com.mvc.controllers.elf
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.proxy.mainCity.home.HomePro;
   
   public class UpDateBagElfCmd extends SimpleCommand
   {
       
      public function UpDateBagElfCmd()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         (facade.retrieveProxy("HomePro") as HomePro).write2000();
      }
   }
}
