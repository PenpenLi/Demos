package com.mvc.models.proxy.mainCity.task
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.mvc.models.vos.mainCity.task.TaskVO;
   import com.common.net.Client;
   import com.mvc.views.uis.worldHorn.WorldTime;
   import com.common.util.xmlVOHandler.GetTaskFactro;
   import com.mvc.views.mediator.mainCity.task.TaskMedia;
   import com.mvc.views.uis.ShowBagElfUI;
   import com.common.themes.Tips;
   import com.common.util.RewardHandle;
   
   public class TaskPro extends Proxy
   {
      
      public static const NAME:String = "TaskPro";
      
      public static var mainTaskVec:Vector.<TaskVO> = new Vector.<TaskVO>([]);
      
      public static var dateTaskVec:Vector.<TaskVO> = new Vector.<TaskVO>([]);
      
      public static var lunchTaskVo:TaskVO = new TaskVO();
      
      public static var dinnerTaskVo:TaskVO = new TaskVO();
       
      private var client:Client;
      
      private var _type:int;
      
      private var isPush:Boolean = true;
      
      private var newTaskIdArr:Array;
      
      public function TaskPro(param1:Object = null)
      {
         super("TaskPro",param1);
         client = Client.getInstance();
         client.addCallObj("note1801",this);
         client.addCallObj("note1802",this);
         client.addCallObj("note1803",this);
      }
      
      public function write1801(param1:int = 0) : void
      {
         LogUtil("发送1801");
         _type = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 1801;
         client.sendBytes(_loc2_);
      }
      
      public function note1801(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = null;
         LogUtil("1801=" + JSON.stringify(param1));
         WorldTime.getInstance().initState();
         var _loc5_:* = param1.status;
         if("success" !== _loc5_)
         {
            if("fail" !== _loc5_)
            {
               if("error" === _loc5_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show("协议处理失败");
            }
         }
         else
         {
            _loc2_ = param1.data.taskMap;
            mainTaskVec = Vector.<TaskVO>([]);
            dateTaskVec = Vector.<TaskVO>([]);
            newTaskIdArr = [];
            lunchTaskVo = null;
            dinnerTaskVo = null;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = GetTaskFactro.getTaskVO(_loc2_[_loc4_].id);
               if(_loc3_ == null)
               {
                  newTaskIdArr.push(_loc2_[_loc4_].id);
               }
               else
               {
                  _loc3_.userId = _loc2_[_loc4_].userId;
                  _loc3_.reachValue = _loc2_[_loc4_].doedTime;
                  _loc3_.type = _loc2_[_loc4_].type;
                  _loc3_.status = _loc2_[_loc4_].status;
                  if(_loc3_.status != 2)
                  {
                     if(_loc3_.id == 10008)
                     {
                        _loc3_.status = 0;
                        lunchTaskVo = _loc3_;
                     }
                     else if(_loc3_.id == 10009)
                     {
                        _loc3_.status = 0;
                        dinnerTaskVo = _loc3_;
                     }
                     else
                     {
                        if(_loc3_.status == 1)
                        {
                           sendNotification("SHOW_TASK_NEWS");
                        }
                        if(_loc2_[_loc4_].id > 10000)
                        {
                           if(_loc3_.status == 1)
                           {
                              dateTaskVec.unshift(_loc3_);
                           }
                           else
                           {
                              dateTaskVec.push(_loc3_);
                           }
                        }
                        else if(_loc3_.status == 1)
                        {
                           mainTaskVec.unshift(_loc3_);
                        }
                        else
                        {
                           mainTaskVec.push(_loc3_);
                        }
                     }
                  }
               }
               _loc4_++;
            }
            if(newTaskIdArr.length > 0)
            {
               write1803(newTaskIdArr);
            }
            sendNotification("SHOW_REWARD_PROMPT");
            sendNotification("SHOW_TASK",_type);
            if(GetTaskFactro.isGetTask())
            {
               TaskMedia.isNew = true;
               ShowBagElfUI.getInstance().taskNews.visible = true;
            }
         }
      }
      
      public function write1802(param1:int, param2:int) : void
      {
         LogUtil("pgId=" + param1);
         _type = param2;
         var _loc3_:Object = {};
         _loc3_.msgId = 1802;
         _loc3_.pgId = param1;
         client.sendBytes(_loc3_);
      }
      
      public function note1802(param1:Object) : void
      {
         LogUtil("1802=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            RewardHandle.Reward(param1.data.reward,5,_type);
         }
      }
      
      public function write1803(param1:Array) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 1803;
         _loc2_.id = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note1803(param1:Object) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = 0;
         var _loc2_:* = null;
         LogUtil("1803=" + JSON.stringify(param1));
         var _loc5_:* = param1.status;
         if("success" !== _loc5_)
         {
            if("fail" !== _loc5_)
            {
               if("error" !== _loc5_)
               {
               }
            }
         }
         else
         {
            _loc4_ = param1.data.task;
            _loc3_ = 0;
            while(_loc3_ < _loc4_.length)
            {
               _loc2_ = new TaskVO();
               _loc2_.title = _loc4_[_loc3_].title;
               _loc2_.nodeId = _loc4_[_loc3_].mapId;
               _loc2_.id = _loc4_[_loc3_].id;
               _loc2_.descs = _loc4_[_loc3_].descs;
               _loc2_.pic = "img_" + _loc4_[_loc3_].pic;
               _loc2_.nextId = _loc4_[_loc3_].nextId;
               _loc2_.begin = _loc4_[_loc3_].begin;
               _loc2_.status = _loc4_[_loc3_].status;
               _loc2_.reward = GetTaskFactro.rewardHandle(_loc4_[_loc3_].rewardJNS,_loc2_.title);
               if(_loc2_.status == 2)
               {
                  return;
               }
               _loc2_.reachValue = _loc4_[_loc3_].doedTime;
               if(_loc4_[_loc3_].id > 10000)
               {
                  dateTaskVec.push(_loc2_);
               }
               else
               {
                  mainTaskVec.push(_loc2_);
               }
               _loc3_++;
            }
         }
      }
   }
}
