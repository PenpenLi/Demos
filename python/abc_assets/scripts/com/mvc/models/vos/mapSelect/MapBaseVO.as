package com.mvc.models.vos.mapSelect
{
   public class MapBaseVO
   {
       
      public var nodeId:int = 0;
      
      public var id:int = 1;
      
      public var needSkillId:int = 0;
      
      public var needOpenLv:int;
      
      public var needBadge:int = 0;
      
      public var curOpenId:int = 0;
      
      public var needPower:int;
      
      public var sceneName:String;
      
      public var type:int = 0;
      
      public var pokeList:Array;
      
      public var isClub:int = 0;
      
      public var isHard:Boolean;
      
      public var normalStars:int = 0;
      
      public var hardStars:int = 0;
      
      public function MapBaseVO()
      {
         super();
      }
   }
}
