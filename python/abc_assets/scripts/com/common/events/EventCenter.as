package com.common.events
{
   import starling.events.EventDispatcher;
   
   public class EventCenter
   {
      
      private static var instance:EventDispatcher = new EventDispatcher();
       
      public function EventCenter()
      {
         super();
      }
      
      public static function addEventListener(param1:String, param2:Function) : void
      {
         instance.addEventListener(param1,param2);
      }
      
      public static function dispatchEvent(param1:String, param2:Object = null) : void
      {
         instance.dispatchEventWith(param1,false,param2);
      }
      
      public static function removeEventListener(param1:String, param2:Function) : void
      {
         instance.removeEventListener(param1,param2);
      }
      
      public static function removeEventListeners(param1:String) : void
      {
         instance.removeEventListeners(param1);
      }
      
      public static function hasEvent(param1:String) : Boolean
      {
         return instance.hasEventListener(param1);
      }
   }
}
