package com.common.util
{
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   
   public class IsAllElfDie
   {
       
      public function IsAllElfDie()
      {
         super();
      }
      
      public static function isAllElfDie() : Boolean
      {
         var _loc1_:* = 0;
         var _loc2_:* = true;
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc1_] != null && PlayerVO.bagElfVec[_loc1_].currentHp > 0)
            {
               _loc2_ = false;
            }
            _loc1_++;
         }
         if(_loc2_)
         {
            Tips.show("你所持有的精灵都处于濒死状态，请到小精灵中心进行恢复");
            return true;
         }
         return false;
      }
      
      public static function playElfIsDie(param1:String) : Boolean
      {
         var _loc2_:* = 0;
         if(param1 == "联盟大赛" || param1 == "PVP" || param1 == "试炼")
         {
            return false;
         }
         _loc2_ = 0;
         while(_loc2_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc2_] != null)
            {
               if(PlayerVO.bagElfVec[_loc2_].currentHp <= 0)
               {
                  Tips.show("不能带濒死状态的精灵参战");
                  return true;
               }
            }
            _loc2_++;
         }
         return false;
      }
   }
}
