package com.common.sdk
{
   public interface InterfaceANE
   {
       
      function initSDK() : void;
      
      function login() : void;
      
      function logout() : void;
      
      function pay(param1:int, param2:int, param3:int, param4:int, param5:String) : void;
      
      function exit() : void;
      
      function subInfo(param1:String) : void;
      
      function get userId() : String;
      
      function get token() : String;
      
      function get platform() : String;
      
      function get channel() : String;
   }
}
