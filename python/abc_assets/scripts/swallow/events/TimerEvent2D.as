package swallow.events
{
   import swallow.utils.Timer2D;
   
   public class TimerEvent2D
   {
      
      public static var TIMER:String = "EVENT2D_TIMER";
      
      public static var TIMER_END:String = "EVENT2D_END";
      
      public static var TIMER_RESET:String = "EVENT2D_TIMER_RESET";
      
      public static var TIMER_SRATR:String = "EVENT2D_TIMER_SRATR";
      
      public static var TIMER_STOP:String = "EVENT2D_TIMER_STOP";
       
      public var targetRepeatCount:int;
      
      public var repeatCount:int;
      
      public var target:Timer2D;
      
      public function TimerEvent2D()
      {
         super();
      }
   }
}
