package com.mvc.views.mediator.mainCity.task
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.task.TaskUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.common.util.xmlVOHandler.GetTaskFactro;
   import com.mvc.views.uis.ShowBagElfUI;
   import com.common.util.WinTweens;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.GetCommon;
   import com.mvc.models.proxy.mainCity.task.TaskPro;
   import com.common.util.DisposeDisplay;
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import starling.display.Image;
   import com.common.util.SomeFontHandler;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import feathers.data.ListCollection;
   import com.common.util.xmlVOHandler.GetMapFactor;
   import com.mvc.views.mediator.mapSelect.WorldMapMedia;
   import com.mvc.models.proxy.mapSelect.MapPro;
   import feathers.controls.TabBar;
   import com.massage.ane.UmengExtension;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import com.mvc.models.vos.mainCity.task.TaskVO;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class TaskMedia extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "TaskMedia";
      
      public static var isNew:Boolean;
      
      public static var cityId:int;
      
      public static var nodeId:int;
       
      public var task:TaskUI;
      
      private var displayVec:Vector.<DisplayObject>;
      
      private var taskIndex:int;
      
      private var currtenTar:int;
      
      public function TaskMedia(param1:Object = null)
      {
         super("TaskMedia",param1);
         task = param1 as TaskUI;
         displayVec = new Vector.<DisplayObject>([]);
         task.addEventListener("triggered",clickHandler);
         task.tabs.addEventListener("change",tabs_changeHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(task.btn_close === _loc2_)
         {
            removeTask();
         }
      }
      
      public function removeTask() : void
      {
         LogUtil("关闭任务");
         if(task.taskList.dataProvider)
         {
            task.taskList.dataProvider.removeAll();
            task.taskList.dataProvider = null;
         }
         if(!GetTaskFactro.isGetTask())
         {
            isNew = false;
            sendNotification("HIDE_TASK_NEWS");
            ShowBagElfUI.getInstance().taskNews.visible = false;
         }
         WinTweens.closeWin(task.spr_taskBg,remove);
      }
      
      private function remove() : void
      {
         sendNotification("switch_win",null);
         dispose();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = param1.getName();
         if("SHOW_TASK" !== _loc3_)
         {
            if("UPDATE_MEALS" !== _loc3_)
            {
               if("SHOW_REWARD_PROMPT" === _loc3_)
               {
                  if(GetCommon.isIOSDied())
                  {
                     return;
                  }
                  task.mainTaskNew.visible = GetTaskFactro.mainIsGet();
                  task.dateTaskNew.visible = GetTaskFactro.dataIsGet();
               }
            }
            else
            {
               LogUtil("更新午餐晚餐状态",TaskPro.dateTaskVec.length,currtenTar);
               if(currtenTar == 1)
               {
                  switchTask(currtenTar);
               }
            }
         }
         else
         {
            if(GetCommon.isIOSDied())
            {
               return;
            }
            LogUtil("展示任务",param1.getBody() as int);
            _loc2_ = param1.getBody() as int;
            currtenTar = _loc2_;
            switchTask(_loc2_);
         }
      }
      
      private function switchTask(param1:int, param2:Boolean = false) : void
      {
         var _loc9_:* = 0;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc14_:* = null;
         var _loc10_:* = null;
         var _loc7_:* = null;
         var _loc16_:* = null;
         var _loc11_:* = 0;
         var _loc12_:* = null;
         var _loc18_:* = null;
         var _loc15_:* = null;
         var _loc17_:* = null;
         var _loc13_:* = null;
         var _loc4_:* = null;
         var _loc3_:Array = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         switch(param1)
         {
            case 0:
               _loc9_ = 0;
               while(_loc9_ < TaskPro.mainTaskVec.length)
               {
                  _loc5_ = new Sprite();
                  switch(TaskPro.mainTaskVec[_loc9_].status)
                  {
                     case 0:
                        if(TaskPro.mainTaskVec[_loc9_].nodeId != 0)
                        {
                           _loc6_ = task.getBtn("btn_goto");
                           _loc6_.y = 35;
                           _loc5_.addChild(_loc6_);
                           _loc6_.name = "主线" + _loc9_;
                           _loc6_.addEventListener("triggered",taskHandle);
                        }
                        _loc14_ = new TextField(50,30,TaskPro.mainTaskVec[_loc9_].reachValue + "/" + TaskPro.mainTaskVec[_loc9_].requireValue,"FZCuYuan-M03S",25,11617792);
                        _loc14_.autoSize = "horizontal";
                        _loc14_.bold = true;
                        _loc5_.addChild(_loc14_);
                        break;
                     case 1:
                        _loc10_ = task.getBtn("btn_getReward");
                        _loc10_.name = "主线" + _loc9_.toString();
                        _loc5_.addChild(_loc10_);
                        _loc10_.addEventListener("triggered",onGetReward);
                        break;
                  }
                  _loc7_ = task.getImage(TaskPro.mainTaskVec[_loc9_].pic);
                  _loc16_ = SomeFontHandler.setColoeSize(TaskPro.mainTaskVec[_loc9_].title,35,8,false);
                  _loc3_.push({
                     "icon":_loc7_,
                     "label":_loc16_ + "\n" + TaskPro.mainTaskVec[_loc9_].descs + "\n" + TaskPro.mainTaskVec[_loc9_].reward,
                     "accessory":_loc5_
                  });
                  displayVec.push(_loc7_);
                  displayVec.push(_loc5_);
                  _loc9_++;
               }
               break;
            case 1:
               _loc11_ = 0;
               while(_loc11_ < TaskPro.dateTaskVec.length)
               {
                  _loc12_ = new Sprite();
                  switch(TaskPro.dateTaskVec[_loc11_].status)
                  {
                     case 0:
                        if(TaskPro.dateTaskVec[_loc11_].id == 10001 || TaskPro.dateTaskVec[_loc11_].id == 10002 || TaskPro.dateTaskVec[_loc11_].id == 10004 || TaskPro.dateTaskVec[_loc11_].id == 10005 || TaskPro.dateTaskVec[_loc11_].id == 10006 || TaskPro.dateTaskVec[_loc11_].id == 10010 || TaskPro.dateTaskVec[_loc11_].id == 10011 || TaskPro.dateTaskVec[_loc11_].id == 10013 || TaskPro.dateTaskVec[_loc11_].id == 10014)
                        {
                           _loc18_ = task.getBtn("btn_goto");
                           _loc18_.y = 35;
                           _loc12_.addChild(_loc18_);
                           _loc18_.name = "每日" + _loc11_;
                           _loc18_.addEventListener("triggered",taskHandle);
                        }
                        _loc15_ = new TextField(50,30,TaskPro.dateTaskVec[_loc11_].reachValue + "/" + TaskPro.dateTaskVec[_loc11_].requireValue,"FZCuYuan-M03S",25,11617792);
                        if(TaskPro.dateTaskVec[_loc11_].id == 10008 || TaskPro.dateTaskVec[_loc11_].id == 10009)
                        {
                           _loc15_.text = "时间未到";
                        }
                        _loc15_.autoSize = "horizontal";
                        _loc15_.bold = true;
                        _loc12_.addChild(_loc15_);
                        break;
                     case 1:
                        _loc17_ = task.getBtn("btn_getReward");
                        _loc17_.name = "每日" + _loc11_.toString();
                        _loc12_.addChild(_loc17_);
                        _loc17_.addEventListener("triggered",onGetReward);
                        break;
                  }
                  _loc13_ = task.getImage(TaskPro.dateTaskVec[_loc11_].pic);
                  _loc4_ = SomeFontHandler.setColoeSize(TaskPro.dateTaskVec[_loc11_].title,35,8,false);
                  if(PlayerVO.lv < 11)
                  {
                     if(TaskPro.dateTaskVec[_loc11_].id == 10008 || TaskPro.dateTaskVec[_loc11_].id == 10009 || TaskPro.dateTaskVec[_loc11_].id == 10007)
                     {
                        LogUtil("TaskPro.dateTaskVec[j].id ===",TaskPro.dateTaskVec[_loc11_].id);
                        _loc3_.push({
                           "icon":_loc13_,
                           "label":_loc4_ + "\n" + TaskPro.dateTaskVec[_loc11_].descs + "\n" + TaskPro.dateTaskVec[_loc11_].reward,
                           "accessory":_loc12_
                        });
                        displayVec.push(_loc13_);
                        displayVec.push(_loc12_);
                     }
                  }
                  else
                  {
                     _loc3_.push({
                        "icon":_loc13_,
                        "label":_loc4_ + "\n" + TaskPro.dateTaskVec[_loc11_].descs + "\n" + TaskPro.dateTaskVec[_loc11_].reward,
                        "accessory":_loc12_
                     });
                     displayVec.push(_loc13_);
                     displayVec.push(_loc12_);
                  }
                  _loc11_++;
               }
               if(displayVec.length == 0 && param2)
               {
                  LogUtil("displayVec==",displayVec.length);
                  Tips.show("玩家等级达到11级后开启【每日任务】");
               }
               LogUtil("displayVec==============",displayVec.length);
               break;
         }
         var _loc8_:ListCollection = new ListCollection(_loc3_);
         task.taskList.dataProvider = _loc8_;
         if(task.taskList.dataProvider)
         {
            task.taskList.scrollToDisplayIndex(0);
         }
      }
      
      private function onGetReward(param1:Event) : void
      {
         taskIndex = (param1.target as SwfButton).name.substring(2);
         var _loc2_:* = (param1.target as SwfButton).name.substr(0,2);
         if("主线" !== _loc2_)
         {
            if("每日" === _loc2_)
            {
               (facade.retrieveProxy("TaskPro") as TaskPro).write1802(TaskPro.dateTaskVec[taskIndex].id,1);
            }
         }
         else
         {
            (facade.retrieveProxy("TaskPro") as TaskPro).write1802(TaskPro.mainTaskVec[taskIndex].id,0);
         }
      }
      
      private function taskHandle(param1:Event) : void
      {
         var _loc4_:* = 0;
         sendNotification("switch_win",null);
         var _loc2_:String = (param1.target as SwfButton).name;
         var _loc3_:int = _loc2_.substring(2);
         var _loc5_:* = _loc2_.substr(0,2);
         if("主线" !== _loc5_)
         {
            if("每日" === _loc5_)
            {
               _loc4_ = TaskPro.dateTaskVec[_loc3_].id;
               dataTaskGoHand(_loc4_);
            }
         }
         else
         {
            nodeId = TaskPro.mainTaskVec[_loc3_].nodeId;
            dispose();
            mainTaskGoHand();
         }
      }
      
      private function mainTaskGoHand() : void
      {
         cityId = GetMapFactor.countCityId(nodeId);
         WorldMapMedia.mapVO = GetMapFactor.getMapVoById(cityId);
         LogUtil(cityId + "看看任务城市id");
         Config.cityScene = WorldMapMedia.mapVO.bgImg;
         (facade.retrieveProxy("MapPro") as MapPro).write1703(WorldMapMedia.mapVO);
      }
      
      private function dataTaskGoHand(param1:int) : void
      {
         switch(param1 - 10001)
         {
            case 0:
               if(PlayerVO.lv < 15)
               {
                  Tips.show("玩家等级15级开启。");
                  return;
               }
               dispose();
               sendNotification("switch_page","LOAD_ELFSERIES_PAGE");
               break;
            case 1:
               if(PlayerVO.lv < 22)
               {
                  Tips.show("玩家等级22级开启。");
                  return;
               }
               dispose();
               sendNotification("switch_page","LOAD_KING_PAGE");
               break;
            case 3:
               dispose();
               sendNotification("switch_win",null,"load_money_panel");
               break;
            case 4:
               dispose();
               sendNotification("switch_page","LOAD_AMUSE_PAGE");
               break;
            case 5:
               dispose();
               sendNotification("switch_page","LOAD_ELFCENTER_PAGE");
               break;
            case 9:
               dispose();
               sendNotification("switch_win",null,"LOAD_ELF_WIN");
               break;
            case 10:
               if(PlayerVO.lv < 19)
               {
                  Tips.show("玩家等级19级开启。");
                  return;
               }
               dispose();
               sendNotification("switch_page","load_trial_page");
               break;
            case 12:
               if(PlayerVO.lv < 8)
               {
                  Tips.show("玩家等级8级开启。");
                  return;
               }
               dispose();
               sendNotification("switch_win",null,"LOAD_TRAINELF");
               break;
            case 13:
               if(PlayerVO.lv < 24)
               {
                  Tips.show("玩家等级24级开启。");
                  return;
               }
               dispose();
               sendNotification("switch_page","load_trial_page");
               break;
            default:
               if(PlayerVO.lv < 19)
               {
                  Tips.show("玩家等级19级开启。");
                  return;
               }
               dispose();
               sendNotification("switch_page","load_trial_page");
               break;
         }
      }
      
      private function tabs_changeHandler(param1:Event) : void
      {
         var _loc2_:TabBar = TabBar(param1.currentTarget);
         if(TaskPro.dateTaskVec.length == 0 && _loc2_.selectedIndex == 1)
         {
            Tips.show("每日活动已经没有了");
            _loc2_.selectedIndex = currtenTar;
            return;
         }
         if(_loc2_.selectedIndex != currtenTar)
         {
            switchTask(_loc2_.selectedIndex,true);
         }
         currtenTar = _loc2_.selectedIndex;
         if(_loc2_.selectedIndex == 0)
         {
            UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|任务-成就");
         }
         else
         {
            UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|任务-每日任务");
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_TASK","UPDATE_MEALS","SHOW_REWARD_PROMPT"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as TaskUI;
      }
      
      public function dispose() : void
      {
         WinTweens.showCity();
         if(PVPPro.isAcceptPvpInvite)
         {
         }
         if(!GetTaskFactro.isGetTask())
         {
            isNew = false;
            sendNotification("HIDE_TASK_NEWS");
            ShowBagElfUI.getInstance().taskNews.visible = false;
         }
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         TaskPro.mainTaskVec = Vector.<TaskVO>([]);
         TaskPro.dateTaskVec = Vector.<TaskVO>([]);
         facade.removeMediator("TaskMedia");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.taskAssets);
      }
   }
}
