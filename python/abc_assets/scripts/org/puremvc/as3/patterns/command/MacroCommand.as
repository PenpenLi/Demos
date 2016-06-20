package org.puremvc.as3.patterns.command
{
   import org.puremvc.as3.patterns.observer.Notifier;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotifier;
   import org.puremvc.as3.interfaces.INotification;
   
   public class MacroCommand extends Notifier implements ICommand, INotifier
   {
       
      private var subCommands:Array;
      
      public function MacroCommand()
      {
         super();
         subCommands = [];
         initializeMacroCommand();
      }
      
      protected function initializeMacroCommand() : void
      {
      }
      
      protected function addSubCommand(param1:Class) : void
      {
         subCommands.push(param1);
      }
      
      public final function execute(param1:INotification) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = null;
         while(subCommands.length > 0)
         {
            _loc3_ = subCommands.shift();
            _loc2_ = new _loc3_();
            _loc2_.execute(param1);
         }
      }
   }
}
