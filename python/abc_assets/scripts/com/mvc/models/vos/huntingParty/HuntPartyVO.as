package com.mvc.models.vos.huntingParty
{
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   
   public class HuntPartyVO
   {
      
      public static var catchCount:int;
      
      public static var maxCatchCount:int = 30;
      
      public static var lastNodeId:int;
      
      public static var refreshTime:int;
      
      public static var score:int;
      
      public static var catchElfObj:com.mvc.models.vos.huntingParty.GoalElfVO = new com.mvc.models.vos.huntingParty.GoalElfVO();
      
      public static var buffObj:com.mvc.models.vos.huntingParty.BuffVO;
      
      public static var scoreLessTime:int;
      
      public static var scorePropVo:PropVO;
      
      public static var buyCountDia:int;
      
      public static var lessCountTime:int;
      
      public static var bagVec:Vector.<PropVO> = new Vector.<PropVO>([]);
      
      public static var isOpen:Boolean;
       
      public function HuntPartyVO()
      {
         super();
      }
   }
}
