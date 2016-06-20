package com.mvc.views.mediator.mainCity.active
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.models.proxy.mainCity.active.ActivePro;
   import com.mvc.views.uis.mainCity.active.ActiveUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.DisposeDisplay;
   import com.mvc.views.uis.mainCity.active.TarUnit;
   import feathers.data.ListCollection;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.views.uis.mainCity.active.TypeOneUI;
   import com.mvc.views.uis.mainCity.active.TypeTwoUI;
   import com.mvc.views.uis.mainCity.active.TypeThreeUI;
   import com.mvc.models.vos.mainCity.active.ActiveVO;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class ActiveMeida extends Mediator
   {
      
      public static const NAME:String = "ActiveMeida";
      
      public static var isNew:Boolean;
      
      public static var isVIPgiftNew:Boolean;
       
      public var active:ActiveUI;
      
      private var tarUnitVec:Vector.<DisplayObject>;
      
      private var currMenuIndx:int;
      
      public function ActiveMeida(param1:Object = null)
      {
         tarUnitVec = new Vector.<DisplayObject>([]);
         super("ActiveMeida",param1);
         active = param1 as ActiveUI;
         active.addEventListener("triggered",clickHandler);
      }
      
      public static function isnewReward() : Boolean
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < ActivePro.activeVec.length)
         {
            if(ActivePro.activeVec[_loc1_])
            {
               _loc2_ = 0;
               while(_loc2_ < ActivePro.activeVec[_loc1_].activeChildVec.length)
               {
                  if(ActivePro.activeVec[_loc1_].activeChildVec[_loc2_])
                  {
                     if(ActivePro.activeVec[_loc1_].activeChildVec[_loc2_].status == 1)
                     {
                        isNew = true;
                        return true;
                     }
                  }
                  _loc2_++;
               }
            }
            _loc1_++;
         }
         return false;
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(active.btn_close === _loc2_)
         {
            if(active.menuList.dataViewPort)
            {
               active.menuList.dataViewPort.touchable = true;
            }
            if(active.menuList.dataProvider)
            {
               active.menuList.dataProvider.removeAll();
            }
            active.ActiveView.removeFromParent(true);
            WinTweens.closeWin(active.spr_bg,remove);
         }
      }
      
      private function remove() : void
      {
         active.isScrolling = false;
         if(ActivePro.activeVec != null)
         {
            if(ActivePro.activeVec.length > 0)
            {
               if(!isnewReward())
               {
                  isNew = false;
                  sendNotification("HIDE_ACTIVE_REWARD");
               }
            }
         }
         dispose();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = param1.getName();
         if("SHOW_ACTIVE_MEUN" !== _loc3_)
         {
            if("CHECK_ACTIVE_MEUN" === _loc3_)
            {
               LogUtil("检测展示活动菜单是否还有奖励",currMenuIndx);
               _loc2_ = 0;
               while(_loc2_ < tarUnitVec[currMenuIndx].myActiveVo.activeChildVec.length)
               {
                  if(tarUnitVec[currMenuIndx].myActiveVo.activeChildVec[_loc2_].status == 1)
                  {
                     return;
                  }
                  _loc2_++;
               }
               LogUtil("去除提醒");
               tarUnitVec[currMenuIndx].news.removeFromParent(true);
               LogUtil("还存在？=",tarUnitVec[currMenuIndx].news);
               if(tarUnitVec[currMenuIndx].myActiveVo.atvTitle == "VIP等级礼包")
               {
                  isVIPgiftNew = false;
                  sendNotification("HIDE_VIPGIFT_NEWS");
               }
            }
         }
         else
         {
            showMenu();
         }
      }
      
      private function showMenu() : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = null;
         if(active.menuList.dataProvider)
         {
            active.menuList.dataProvider.removeAll();
            DisposeDisplay.dispose(tarUnitVec);
            tarUnitVec = Vector.<DisplayObject>([]);
            tarUnitVec = null;
         }
         var _loc1_:Array = [];
         if(ActivePro.activeVec.length <= 3)
         {
            active.mc_upDown.visible = false;
         }
         _loc3_ = 0;
         while(_loc3_ < ActivePro.activeVec.length)
         {
            _loc4_ = new TarUnit();
            _loc4_.index = _loc3_;
            _loc4_.myActiveVo = ActivePro.activeVec[_loc3_];
            _loc1_.push({
               "icon":_loc4_,
               "label":""
            });
            tarUnitVec.push(_loc4_);
            _loc4_.addEventListener("touch",ontouch);
            _loc3_++;
         }
         var _loc2_:ListCollection = new ListCollection(_loc1_);
         active.menuList.dataProvider = _loc2_;
         switchPage(tarUnitVec[0] as TarUnit);
      }
      
      private function ontouch(param1:TouchEvent) : void
      {
         var _loc3_:TarUnit = param1.currentTarget as TarUnit;
         var _loc2_:Touch = param1.getTouch(_loc3_);
         if(_loc2_)
         {
            if(_loc2_.phase == "ended")
            {
               if(active.isScrolling)
               {
                  return;
               }
               switchPage(_loc3_);
            }
         }
      }
      
      private function switchPage(param1:TarUnit) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = null;
         LogUtil("第几个 ？ = ",param1.index,param1.myActiveVo.atvTitle,"=zihuandong = ",param1.myActiveVo.activeChildVec.length);
         LogUtil("活动类型=",param1.myActiveVo.atvType);
         currMenuIndx = param1.index;
         showSelete(param1);
         active.ActiveView.removeChildren(0,-1,true);
         switch(param1.myActiveVo.atvType - 1)
         {
            case 0:
               _loc3_ = new TypeOneUI();
               _loc3_.myActive = param1.myActiveVo;
               active.ActiveView.addChild(_loc3_);
               break;
            case 1:
               _loc2_ = new TypeTwoUI();
               _loc2_.myActive = param1.myActiveVo;
               active.ActiveView.addChild(_loc2_);
               break;
            case 2:
            case 3:
               TypeThreeUI.getInstance().clean();
               TypeThreeUI.getInstance().showThree = param1.myActiveVo;
               active.ActiveView.addChild(TypeThreeUI.getInstance());
               break;
            case 4:
               TypeThreeUI.getInstance().clean();
               TypeThreeUI.getInstance().showFour = param1.myActiveVo;
               active.ActiveView.addChild(TypeThreeUI.getInstance());
               break;
         }
      }
      
      private function showSelete(param1:TarUnit) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < tarUnitVec.length)
         {
            if(tarUnitVec.indexOf(param1) == _loc2_)
            {
               tarUnitVec[_loc2_].light.visible = true;
            }
            else
            {
               tarUnitVec[_loc2_].light.visible = false;
            }
            _loc2_++;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_ACTIVE_MEUN","CHECK_ACTIVE_MEUN"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         active.removeEventListener("triggered",clickHandler);
         WinTweens.showCity();
         DisposeDisplay.dispose(tarUnitVec);
         tarUnitVec = Vector.<DisplayObject>([]);
         tarUnitVec = null;
         ActivePro.activeVec = Vector.<ActiveVO>([]);
         ActivePro.activeVec = null;
         facade.removeMediator("ActiveMeida");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.activityAssets);
      }
   }
}
