package lzm.util
{
   import starling.utils.formatString;
   
   public class TimeUtil
   {
       
      public function TimeUtil()
      {
         super();
      }
      
      public static function convertStringToDate(param1:int, param2:Boolean = false, param3:int = 0) : String
      {
         var _loc8_:int = param1 / 3600;
         var _loc6_:String = _loc8_ + param3 + "";
         _loc6_ = _loc6_.length > 1?_loc6_:"0" + _loc6_;
         var param1:int = param1 - _loc8_ * 3600;
         var _loc7_:int = param1 / 60;
         var _loc4_:String = _loc7_ + "";
         _loc4_ = _loc4_.length > 1?_loc4_:"0" + _loc4_;
         param1 = param1 - _loc7_ * 60;
         var _loc5_:String = param1 + "";
         _loc5_ = _loc5_.length > 1?_loc5_:"0" + _loc5_;
         if(param2)
         {
            return _loc6_ + " : " + _loc4_ + " : " + _loc5_;
         }
         return _loc6_ + ":" + _loc4_ + ":" + _loc5_;
      }
      
      public static function getTime(param1:int) : String
      {
         if(param1 < 60)
         {
            return param1 + "秒";
         }
         if(param1 >= 60 && param1 < 3600)
         {
            return Math.round(param1 / 60) + "分钟";
         }
         if(param1 >= 3600 && param1 < 86400)
         {
            return Math.round(param1 / 3600) + "小时";
         }
         if(param1 >= 86400 && param1 < 2592000)
         {
            return Math.round(param1 / 86400) + "天";
         }
         if(param1 >= 2592000 && param1 < 31104000)
         {
            return Math.round(param1 / 2592000) + "个月";
         }
         if(param1 >= 31104000)
         {
            return Math.round(param1 / 31104000) + "年";
         }
         return null;
      }
      
      public static function convertStringToDate2(param1:int) : String
      {
         if(param1 <= 0)
         {
            return "00天 00小时 00分 00秒";
         }
         var _loc2_:int = param1 / 86400;
         var param1:int = param1 - _loc2_ * 24 * 3600;
         var _loc7_:int = param1 / 3600;
         var _loc5_:String = _loc7_ + "";
         _loc5_ = _loc5_.length > 1?_loc5_:"0" + _loc5_;
         param1 = param1 - _loc7_ * 3600;
         var _loc6_:int = param1 / 60;
         var _loc3_:String = _loc6_ + "";
         _loc3_ = _loc3_.length > 1?_loc3_:"0" + _loc3_;
         param1 = param1 - _loc6_ * 60;
         var _loc4_:String = param1 + "";
         _loc4_ = _loc4_.length > 1?_loc4_:"0" + _loc4_;
         if(_loc2_ > 0)
         {
            return formatString("{0}天 {1}小时 {2}分",_loc2_,_loc5_,_loc3_);
         }
         if(_loc7_ > 0)
         {
            if(_loc6_ == 0)
            {
               return formatString("{0}小时",_loc5_);
            }
            return formatString("{0}小时 {1}分",_loc5_,_loc3_);
         }
         if(_loc6_ > 0)
         {
            if(param1 == 0)
            {
               return formatString("{0}分钟",_loc3_);
            }
            return formatString("{0}分 {1}秒",_loc3_,_loc4_);
         }
         return formatString("{0}秒",_loc4_);
      }
      
      public static function convertStringToDate3(param1:int, param2:String = "#ffffff") : String
      {
         if(param1 <= 0)
         {
            return "00天 00小时 00分 00秒";
         }
         var _loc3_:int = param1 / 86400;
         var param1:int = param1 - _loc3_ * 24 * 3600;
         var _loc8_:int = param1 / 3600;
         var _loc6_:String = _loc8_ + "";
         _loc6_ = _loc6_.length > 1?_loc6_:"0" + _loc6_;
         param1 = param1 - _loc8_ * 3600;
         var _loc7_:int = param1 / 60;
         var _loc4_:String = _loc7_ + "";
         _loc4_ = _loc4_.length > 1?_loc4_:"0" + _loc4_;
         param1 = param1 - _loc7_ * 60;
         var _loc5_:String = param1 + "";
         _loc5_ = _loc5_.length > 1?_loc5_:"0" + _loc5_;
         if(_loc3_ > 0)
         {
            return addColor("{0}天 {1}小时 {2}分 {3}秒",_loc3_,_loc6_,_loc4_,_loc5_,param2);
         }
         if(_loc8_ > 0)
         {
            return addColor("{0}小时 {1}分 {2}秒",_loc6_,_loc4_,_loc5_,param2);
         }
         if(_loc7_ > 0)
         {
            return addColor("{0}分 {1}秒",_loc4_,_loc5_,param2);
         }
         return addColor("{0}秒",_loc5_,param2);
      }
      
      public static function parseString(param1:String) : Date
      {
         var _loc2_:Array = param1.split(" ");
         var _loc4_:Array = _loc2_[0].split("-");
         var _loc3_:Array = _loc2_[1].split(":");
         return new Date(_loc4_[0],_loc4_[1],_loc4_[2],_loc3_[0],_loc3_[1],_loc3_[2]);
      }
      
      public static function addColor(param1:String, ... rest) : String
      {
         var _loc3_:* = 0;
         _loc3_ = 0;
         while(_loc3_ < rest.length)
         {
            var param1:String = param1.replace(new RegExp("\\{" + _loc3_ + "\\}","g"),"<font color=\'" + rest[rest.length - 1] + "\'>" + rest[_loc3_] + "</font>");
            _loc3_++;
         }
         return param1;
      }
   }
}
