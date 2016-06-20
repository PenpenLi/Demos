package com.common.util.xmlVOHandler
{
   import com.common.managers.LoadOtherAssetsManager;
   import com.mvc.models.vos.login.PlayerVO;
   
   public class GetHomeSpace
   {
       
      public function GetHomeSpace()
      {
         super();
      }
      
      public static function getComLv() : int
      {
         var _loc2_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_home");
         var _loc4_:* = 0;
         var _loc3_:* = _loc2_.sta_home;
         for each(var _loc1_ in _loc2_.sta_home)
         {
            if(PlayerVO.cpSpace == _loc1_.@capacity)
            {
               LogUtil("获取电脑空间等级==",_loc1_.@id);
               return _loc1_.@id;
            }
         }
         return null;
      }
      
      public static function getComSpace(param1:int) : int
      {
         var _loc3_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_home");
         var _loc5_:* = 0;
         var _loc4_:* = _loc3_.sta_home;
         for each(var _loc2_ in _loc3_.sta_home)
         {
            if(param1 == _loc2_.@id)
            {
               LogUtil("获取等级对应的电脑空间==",_loc2_.@capacity);
               return _loc2_.@capacity;
            }
         }
         return null;
      }
      
      public static function getComNeed(param1:int) : Object
      {
         var _loc2_:* = null;
         var _loc4_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_home");
         var _loc6_:* = 0;
         var _loc5_:* = _loc4_.sta_home;
         for each(var _loc3_ in _loc4_.sta_home)
         {
            if(param1 == _loc3_.@id)
            {
               _loc2_ = {};
               _loc2_.playerLv = _loc3_.@playerLv;
               _loc2_.money = _loc3_.@money;
               _loc2_.diamond = _loc3_.@diamond;
               _loc2_.capacity = _loc3_.@capacity;
               LogUtil("获取解锁空间条件===",JSON.stringify(_loc2_));
               return _loc2_;
            }
         }
         return null;
      }
   }
}
