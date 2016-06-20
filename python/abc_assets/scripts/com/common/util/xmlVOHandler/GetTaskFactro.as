package com.common.util.xmlVOHandler
{
   import com.mvc.models.vos.mainCity.task.TaskVO;
   import com.common.managers.LoadOtherAssetsManager;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.proxy.mainCity.task.TaskPro;
   
   public class GetTaskFactro
   {
       
      public function GetTaskFactro()
      {
         super();
      }
      
      public static function getTaskVO(param1:int) : TaskVO
      {
         var _loc2_:* = null;
         var _loc7_:* = false;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc8_:* = null;
         var _loc9_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_task");
         var _loc11_:* = 0;
         var _loc10_:* = _loc9_.sta_task;
         for each(var _loc6_ in _loc9_.sta_task)
         {
            if(_loc6_.@id == param1)
            {
               _loc7_ = true;
               _loc2_ = new TaskVO();
               _loc2_.id = param1;
               _loc2_.title = _loc6_.@title;
               _loc2_.descs = _loc6_.@descs;
               if(_loc6_.@rewardJNS != "")
               {
                  _loc3_ = _loc6_.@rewardJNS;
                  _loc4_ = _loc3_.replace(new RegExp("\\\'|&apos;","g"),"\"");
                  _loc5_ = JSON.parse(_loc4_);
                  _loc2_.reward = rewardHandle(_loc5_,_loc2_.title);
               }
               if(_loc6_.@paramJNS != "")
               {
                  _loc8_ = _loc6_.@paramJNS;
                  _loc2_.requireValue = timeHandle(_loc8_);
               }
               if(_loc2_.id == 10007)
               {
                  _loc2_.reward = "道具 扫荡券 *" + PlayerVO.vipInfoVO.sweep;
               }
               _loc2_.pic = "img_" + _loc6_.@pic;
               _loc2_.nextId = _loc6_.@nextId;
               _loc2_.nodeId = _loc6_.@mapId;
               _loc2_.begin = _loc6_.@begin;
               break;
            }
         }
         return _loc2_;
      }
      
      public static function rewardHandle(param1:Object, param2:String) : String
      {
         var _loc4_:* = 0;
         var _loc3_:String = "";
         if(param1.silver)
         {
            _loc3_ = _loc3_ + ("金币 " + param1.silver.num + "   ");
         }
         if(param1.exper)
         {
            _loc3_ = _loc3_ + ("经验 " + param1.exper.num + "   ");
         }
         if(param1.diamond)
         {
            _loc3_ = _loc3_ + ("钻石 " + param1.diamond.num + "   ");
         }
         if(param1.prop)
         {
            _loc3_ = _loc3_ + "道具 ";
            _loc4_ = 0;
            while(_loc4_ < param1.prop.length)
            {
               _loc3_ = _loc3_ + (GetPropFactor.getPropVO(param1.prop[_loc4_].pId).name + "*" + param1.prop[_loc4_].num + "   ");
               _loc4_++;
            }
         }
         return _loc3_;
      }
      
      public static function timeHandle(param1:String) : int
      {
         var _loc3_:String = param1.replace(new RegExp("\\\'|&apos;","g"),"\"");
         var _loc2_:Object = JSON.parse(_loc3_);
         if(_loc2_.reqNum)
         {
            return _loc2_.reqNum;
         }
         return 1;
      }
      
      public static function isGetTask() : Boolean
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < TaskPro.mainTaskVec.length)
         {
            if(TaskPro.mainTaskVec[_loc1_].status == 1)
            {
               return true;
            }
            _loc1_++;
         }
         _loc2_ = 0;
         while(_loc2_ < TaskPro.dateTaskVec.length)
         {
            if(TaskPro.dateTaskVec[_loc2_].status == 1)
            {
               return true;
            }
            _loc2_++;
         }
         LogUtil("没有奖励可以领取的任务奖励");
         return false;
      }
      
      public static function mainIsGet() : Boolean
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < TaskPro.mainTaskVec.length)
         {
            if(TaskPro.mainTaskVec[_loc1_].status == 1)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public static function dataIsGet() : Boolean
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < TaskPro.dateTaskVec.length)
         {
            if(TaskPro.dateTaskVec[_loc1_].status == 1)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
   }
}
