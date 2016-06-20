package com.mvc.controllers
{
   import org.puremvc.as3.patterns.command.MacroCommand;
   import com.mvc.controllers.bootstarps.BootStarpCommands;
   import com.mvc.controllers.bootstarps.BootStarpModels;
   import com.mvc.controllers.bootstarps.BootstrapMediators;
   
   public class StartUpCommand extends MacroCommand
   {
       
      public function StartUpCommand()
      {
         super();
      }
      
      override protected function initializeMacroCommand() : void
      {
         addSubCommand(BootStarpCommands);
         addSubCommand(BootStarpModels);
         addSubCommand(BootstrapMediators);
      }
   }
}
