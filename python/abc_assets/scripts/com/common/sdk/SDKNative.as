package com.common.sdk
{
   import org.puremvc.as3.patterns.facade.Facade;
   import com.common.events.EventCenter;
   
   public class SDKNative implements InterfaceANE
   {
       
      private var _userId:String;
      
      private var _token:String;
      
      public function SDKNative()
      {
         super();
      }
      
      public function initSDK() : void
      {
      }
      
      public function login() : void
      {
         Facade.getInstance().sendNotification("switch_win",null,"LOAD_LOGINWINDOW_WIN");
         _token = "mc";
      }
      
      public function logout() : void
      {
      }
      
      public function pay(param1:int, param2:int, param3:int, param4:int, param5:String) : void
      {
      }
      
      public function exit() : void
      {
         EventCenter.dispatchEvent("GET_EXIT");
      }
      
      public function subInfo(param1:String) : void
      {
      }
      
      public function get userId() : String
      {
         return _userId;
      }
      
      public function get token() : String
      {
         return _token;
      }
      
      public function get platform() : String
      {
         return "mc";
      }
      
      public function get channel() : String
      {
         return "mc";
      }
   }
}
