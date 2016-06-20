package lzm.util
{
   import flash.system.Capabilities;
   
   public class OSUtil
   {
       
      public function OSUtil()
      {
         super();
      }
      
      public static function isMac() : Boolean
      {
         return Capabilities.os.toLocaleUpperCase().indexOf("MAC") != -1;
      }
      
      public static function isWindows() : Boolean
      {
         return Capabilities.os.toLocaleUpperCase().indexOf("WIN") != -1;
      }
      
      public static function isAndriod() : Boolean
      {
         if(Capabilities.os.toLocaleUpperCase().indexOf("ANDROID") != -1)
         {
            return true;
         }
         if(Capabilities.os.toLocaleUpperCase().indexOf("LINUX") != -1)
         {
            return true;
         }
         return false;
      }
      
      public static function isIPhone() : Boolean
      {
         return Capabilities.os.toLocaleUpperCase().indexOf("IPHONE") != -1;
      }
   }
}
