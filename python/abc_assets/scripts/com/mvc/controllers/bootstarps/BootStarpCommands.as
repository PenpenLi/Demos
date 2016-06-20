package com.mvc.controllers.bootstarps
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.controllers.LoadPageCmd;
   import com.mvc.controllers.LoadWindowsCmd;
   import com.mvc.controllers.elf.UpDateBagElfCmd;
   import com.mvc.controllers.elf.UpDataComElfCmd;
   import com.mvc.controllers.backpack.UpdateBackpackCmd;
   
   public class BootStarpCommands extends SimpleCommand
   {
       
      public function BootStarpCommands()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         facade.registerCommand("switch_page",LoadPageCmd);
         facade.registerCommand("switch_win",LoadWindowsCmd);
         facade.registerCommand("UPDATE_BAG_ELF",UpDateBagElfCmd);
         facade.registerCommand("UPDATE_COM_ELF",UpDataComElfCmd);
         facade.registerCommand("UPDATE_BACKPACK",UpdateBackpackCmd);
      }
   }
}
