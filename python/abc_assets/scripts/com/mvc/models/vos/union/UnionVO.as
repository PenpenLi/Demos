package com.mvc.models.vos.union
{
   public class UnionVO
   {
       
      public var unionId:Number;
      
      public var unionName:String;
      
      public var unionRCD:String;
      
      public var unionRCDId:String;
      
      public var unionRCDLv:int;
      
      public var unionViceRCDIdArr:Array;
      
      public var maxMemberNum:int;
      
      public var nowMemberNum:int;
      
      public var notice:String;
      
      public var unionRank:int;
      
      public var needLv:int;
      
      public var unionLv:int;
      
      public var applyStatus:int;
      
      public var serverId:int;
      
      public var isApply:Boolean;
      
      public var isAutoEnter:Boolean;
      
      public var unionExp:int;
      
      public function UnionVO()
      {
         super();
      }
   }
}
