package com.common.util
{
   import mx.utils.StringUtil;
   
   public class SomeFontHandler
   {
       
      public function SomeFontHandler()
      {
         super();
      }
      
      public static function setLvText(param1:int) : String
      {
         var _loc2_:String = "<font color=\'#f08300\' size=\'25\'>Lv.</font>";
         var _loc3_:String = "<font color=\'#943800\' size=\'25\'>" + param1 + "</font>";
         return _loc2_ + _loc3_;
      }
      
      public static function setColoeSize(param1:String, param2:int = 25, param3:int = 10, param4:Boolean = true) : String
      {
         var _loc5_:String = "<font color=\'#f08300\' size=\'" + param2 + "\'>" + setLength(StringUtil.trim(param1),param3,param4) + "</font>";
         return _loc5_;
      }
      
      public static function setLength(param1:String, param2:int = 10, param3:Boolean = true) : String
      {
         var _loc5_:* = 0;
         if(!param3)
         {
            return param1;
         }
         var _loc4_:String = "";
         if(param1.length > param2)
         {
            return param1 + _loc4_;
         }
         _loc5_ = 0;
         while(_loc5_ < param2 - param1.length)
         {
            _loc4_ = _loc4_ + "    ";
            _loc5_++;
         }
         return param1 + _loc4_;
      }
   }
}
