package swallow.utils
{
   import flash.utils.Timer;
   import flash.events.Event;
   import starling.core.Starling;
   
   public class TimerLists
   {
      
      private static var _target:swallow.utils.TimerLists;
      
      private static var timerLists:Vector.<swallow.utils.Timer2D>;
       
      private var tiemr:Timer;
      
      private var index:int;
      
      public function TimerLists()
      {
         super();
         timerLists = new Vector.<swallow.utils.Timer2D>();
         Starling.current.nativeStage.addEventListener("enterFrame",run);
      }
      
      public static function get target() : swallow.utils.TimerLists
      {
         if(_target == null)
         {
            _target = new swallow.utils.TimerLists();
         }
         return _target;
      }
      
      public static function run() : void
      {
         var _loc2_:* = 0;
         var _loc1_:int = timerLists.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            timerLists[_loc2_].run();
            _loc2_++;
         }
      }
      
      private function run(param1:Event) : void
      {
         index = index + 1;
         if(index > 100000)
         {
            tiemr.reset();
            tiemr.start();
         }
         swallow.utils.TimerLists.run();
      }
      
      public function suspend(param1:int) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < timerLists.length)
         {
            timerLists[_loc2_].suspend(param1);
            _loc2_++;
         }
      }
      
      public function addTimer(param1:swallow.utils.Timer2D) : void
      {
         timerLists.push(param1);
      }
      
      public function removeTimer(param1:swallow.utils.Timer2D) : void
      {
         timerLists.splice(timerLists.indexOf(param1),1);
      }
   }
}
