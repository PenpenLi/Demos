package com.common.util.xmlVOHandler
{
   import com.mvc.models.vos.mainCity.train.TrainVO;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class GetTrainInfo
   {
       
      public function GetTrainInfo()
      {
         super();
      }
      
      public static function getTrainVo(param1:int) : TrainVO
      {
         var _loc2_:* = null;
         var _loc4_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_trainInfo");
         var _loc6_:* = 0;
         var _loc5_:* = _loc4_.sta_trainInfo;
         for each(var _loc3_ in _loc4_.sta_trainInfo)
         {
            if(_loc3_.@id == param1)
            {
               _loc2_ = new TrainVO();
               _loc2_.traGrdId = param1;
               _loc2_.vipNeed = _loc3_.@vipNeed;
               _loc2_.openCost = _loc3_.@openCost;
               _loc2_.green = _loc3_.@green;
               _loc2_.blue = _loc3_.@blue;
               _loc2_.purple = _loc3_.@purple;
               _loc2_.orange = _loc3_.@orange;
               break;
            }
         }
         return _loc2_;
      }
   }
}
