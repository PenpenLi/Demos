package com.common.sdk
{
   public class SDKManager
   {
      
      private static var instance:com.common.sdk.SDKManager;
       
      public function SDKManager()
      {
         super();
      }
      
      public static function getInstance() : com.common.sdk.SDKManager
      {
         return instance || new com.common.sdk.SDKManager();
      }
      
      public function setANEtype(param1:int) : *
      {
         switch(param1)
         {
            case 0:
               return new SDKNative();
            case 1:
               LogUtil("==================棱境=================");
            case 2:
               LogUtil("==================UC==================");
            case 3:
               LogUtil("==================A阿==================");
               return new SDKAG();
            case 4:
               LogUtil("=================易接==================");
            default:
               return;
         }
      }
   }
}
