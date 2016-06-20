package com.mvc
{
   import org.puremvc.as3.patterns.facade.Facade;
   import org.puremvc.as3.interfaces.IFacade;
   import com.mvc.controllers.StartUpCommand;
   
   public class GameFacade extends Facade implements IFacade
   {
      
      private static const STARTUP:String = "start_up";
       
      public function GameFacade()
      {
         super();
      }
      
      public static function getInstance() : GameFacade
      {
         if(instance == null)
         {
            instance = new GameFacade();
         }
         return instance as GameFacade;
      }
      
      override protected function initializeController() : void
      {
         super.initializeController();
         registerCommand("start_up",StartUpCommand);
      }
      
      public function startup() : void
      {
         sendNotification("start_up");
      }
   }
}
