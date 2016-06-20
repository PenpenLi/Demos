package com.mvc.controllers.bootstarps
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   
   public class BootstrapMediators extends SimpleCommand
   {
       
      public function BootstrapMediators()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
      }
   }
}
