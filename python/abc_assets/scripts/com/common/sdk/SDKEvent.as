package com.common.sdk
{
   import starling.events.EventDispatcher;
   
   public class SDKEvent
   {
      
      private static var instance:EventDispatcher = new EventDispatcher();
       
      public function SDKEvent()
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
      
      public static function hasEvent(param1:String) : Boolean
      {
         return instance.hasEventListener(param1);
      }
   }
}
