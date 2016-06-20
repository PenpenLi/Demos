package com.mvc.models.vos.login
{
   public class ServerVO
   {
       
      public var serverId:int;
      
      public var serverIp:String;
      
      public var serverProt:int;
      
      public var serverName:String;
      
      public var serverState:String;
      
      public var forbid:Boolean;
      
      public var isFix:Boolean;
      
      public var clientnum:int;
      
      public var isBusy:Boolean;
      
      public var playerName:String;
      
      public var playerLv:String;
      
      public var rankVip:int;
      
      public var headId:int;
      
      public var userId:String;
      
      public function ServerVO()
      {
         super();
      }
   }
}
