package org.puremvc.as3.core
{
   import org.puremvc.as3.interfaces.IController;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.patterns.observer.Observer;
   import org.puremvc.as3.interfaces.IView;
   
   public class Controller implements IController
   {
      
      protected static var instance:IController;
       
      protected var view:IView;
      
      protected var commandMap:Array;
      
      protected const SINGLETON_MSG:String = "Controller Singleton already constructed!";
      
      public function Controller()
      {
         super();
         if(instance != null)
         {
            throw Error("Controller Singleton already constructed!");
         }
         instance = this;
         commandMap = [];
         initializeController();
      }
      
      public static function getInstance() : IController
      {
         if(instance == null)
         {
            instance = new Controller();
         }
         return instance;
      }
      
      protected function initializeController() : void
      {
         view = View.getInstance();
      }
      
      public function executeCommand(param1:INotification) : void
      {
         var _loc3_:Class = commandMap[param1.getName()];
         if(_loc3_ == null)
         {
            return;
         }
         var _loc2_:ICommand = new _loc3_();
         _loc2_.execute(param1);
      }
      
      public function registerCommand(param1:String, param2:Class) : void
      {
         if(commandMap[param1] == null)
         {
            view.registerObserver(param1,new Observer(executeCommand,this));
         }
         commandMap[param1] = param2;
      }
      
      public function hasCommand(param1:String) : Boolean
      {
         return commandMap[param1] != null;
      }
      
      public function removeCommand(param1:String) : void
      {
         if(hasCommand(param1))
         {
            view.removeObserver(param1,this);
            commandMap[param1] = null;
         }
      }
   }
}
