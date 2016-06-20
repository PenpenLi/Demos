package com.common.util.strHandler
{
   import mx.utils.StringUtil;
   import flash.utils.ByteArray;
   import com.mvc.models.vos.mainCity.chat.ChatVO;
   
   public class StrHandle
   {
       
      public function StrHandle()
      {
         super();
      }
      
      public static function lineFeed(param1:String, param2:int, param3:String, param4:int = 20, param5:Boolean = true) : String
      {
         var _loc6_:String = StringUtil.trim(param1);
         var _loc8_:int = _loc6_.length % param2;
         var _loc7_:String = "";
         _loc7_ = _loc6_.substr(0,param2) + param3 + _loc6_.substring(param2);
         if(param5)
         {
            _loc7_ = "<font size=\'" + param4 + "\'>" + _loc7_ + "</font>";
         }
         return _loc7_;
      }
      
      public static function simLineFeed(param1:String, param2:int) : String
      {
         if(param1.length <= param2)
         {
            return param1;
         }
         return param1.slice(0,param2) + "\n" + param1.slice(param2);
      }
      
      public static function getByteLen(param1:String) : int
      {
         var _loc3_:* = null;
         var _loc2_:* = -1;
         if(param1 != null)
         {
            _loc3_ = new ByteArray();
            _loc3_.writeUTF(param1);
            _loc2_ = _loc3_.length;
         }
         return _loc2_;
      }
      
      public static function ifEnough(param1:String, param2:int, param3:int) : String
      {
         var _loc4_:String = param1.substr(param2 * param3,param2);
         do
         {
            param2++;
            _loc4_ = param1.substr(param2 * param3,param2);
         }
         while(getByteLen(_loc4_) == param2 * 2);
         
         return _loc4_;
      }
      
      public static function isAllSpace(param1:String) : Boolean
      {
         var param1:String = param1.replace(new RegExp(" ","g"),"");
         if(param1 == "")
         {
            return true;
         }
         return false;
      }
      
      public static function getTime(param1:int) : String
      {
         var _loc2_:Date = new Date();
         _loc2_.setTime(param1 * 1000);
         return _loc2_.getFullYear() + "-" + (_loc2_.getMonth() + 1 > 9?_loc2_.getMonth() + 1:"0" + (_loc2_.getMonth() + 1)) + "-" + (_loc2_.getDate() > 9?_loc2_.getDate():"0" + _loc2_.getDate());
      }
      
      public static function chatOvertop(param1:ChatVO) : String
      {
         if(param1.userName.length + param1.msg.length > 13)
         {
            if(param1.belong != 1)
            {
               return "<font color=\'#ffffff\'>[" + param1.userName + "]:" + param1.msg.substr(0,13 - param1.userName.length) + "..." + "</font>";
            }
            return "<font color=\'#4bc91f\'>[" + param1.userName + "]:" + param1.msg.substr(0,13 - param1.userName.length) + "..." + "</font>";
         }
         if(param1.belong != 1)
         {
            return "<font color=\'#ffffff\'>[" + param1.userName + "]:" + param1.msg + "</font>";
         }
         return "<font color=\'#4bc91f\'>[" + param1.userName + "]:" + param1.msg + "</font>";
      }
      
      public static function getLen(param1:String, param2:int, param3:Boolean = false, param4:int = 25, param5:String = "#943800") : String
      {
         var _loc6_:String = "";
         if(param1.length <= param2)
         {
            _loc6_ = param1;
         }
         else
         {
            _loc6_ = param1.substr(0,param2) + "…";
         }
         if(param3)
         {
            _loc6_ = "<font color=\'" + param5 + "\' size=\'" + param4 + "\'>" + _loc6_ + "</font>";
         }
         LogUtil(_loc6_);
         return _loc6_;
      }
   }
}
