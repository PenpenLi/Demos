package com.mvc.views.mediator.mainCity.pvp
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.pvp.PVPPropUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import feathers.controls.TabBar;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.common.themes.Tips;
   import com.common.util.DisposeDisplay;
   import lzm.starling.swf.display.SwfButton;
   import com.common.util.xmlVOHandler.GetpropImage;
   import starling.display.Sprite;
   import com.common.util.SomeFontHandler;
   import com.common.util.strHandler.StrHandle;
   import feathers.data.ListCollection;
   import com.common.util.WinTweens;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import org.puremvc.as3.patterns.facade.Facade;
   import org.puremvc.as3.interfaces.INotification;
   
   public class PVPPropMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "PVPPropMediator";
       
      public var pvpPropUI:PVPPropUI;
      
      private var displayVec:Vector.<DisplayObject>;
      
      private var currentTab:int = 0;
      
      private var index:int;
      
      public function PVPPropMediator(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("PVPPropMediator",param1);
         pvpPropUI = param1 as PVPPropUI;
         pvpPropUI.addEventListener("triggered",triggeredHandler);
         pvpPropUI.tabs.addEventListener("change",tabs_changeHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(pvpPropUI.closeBtn === _loc2_)
         {
            close();
         }
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(pvpPropUI.closeBtn === _loc2_)
         {
            close();
         }
      }
      
      private function tabs_changeHandler(param1:Event) : void
      {
         var _loc2_:TabBar = TabBar(param1.currentTarget);
         if(GetPropFactor.pvpPropVecArr.length != 0)
         {
            if(GetPropFactor.pvpPropVecArr[_loc2_.selectedIndex].length == 0)
            {
               Tips.show("该物品栏下没有道具");
               pvpPropUI.tabs.selectedIndex = currentTab;
               return;
            }
         }
         switchBackPackGoods(_loc2_.selectedIndex);
         currentTab = _loc2_.selectedIndex;
      }
      
      private function switchBackPackGoods(param1:int) : void
      {
         var _loc8_:* = 0;
         var _loc10_:* = null;
         var _loc6_:* = null;
         var _loc3_:* = null;
         var _loc9_:* = 0;
         var _loc5_:* = null;
         var _loc11_:* = null;
         var _loc4_:* = null;
         var _loc2_:Array = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         switch(param1)
         {
            case 0:
               _loc8_ = 0;
               while(_loc8_ < GetPropFactor.carryVec.length)
               {
                  _loc10_ = pvpPropUI.getBtn("btn_carry_b");
                  _loc10_.name = _loc8_.toString();
                  _loc6_ = GetpropImage.getPropSpr(GetPropFactor.carryVec[_loc8_],false);
                  _loc3_ = SomeFontHandler.setColoeSize(GetPropFactor.carryVec[_loc8_].name,35,17);
                  _loc10_.addEventListener("triggered",medicineHandle);
                  _loc2_.push({
                     "icon":_loc6_,
                     "label":_loc3_ + "数量:" + GetPropFactor.carryVec[_loc8_].count + " \n" + StrHandle.lineFeed(GetPropFactor.carryVec[_loc8_].describe,31,"\n",24),
                     "accessory":_loc10_
                  });
                  displayVec.push(_loc6_);
                  displayVec.push(_loc10_);
                  _loc8_++;
               }
               break;
            case 1:
               _loc9_ = 0;
               while(_loc9_ < GetPropFactor.hagberryVec.length)
               {
                  _loc5_ = pvpPropUI.getBtn("btn_carry_b");
                  _loc5_.name = _loc9_.toString();
                  _loc11_ = GetpropImage.getPropSpr(GetPropFactor.hagberryVec[_loc9_],false);
                  _loc4_ = SomeFontHandler.setColoeSize(GetPropFactor.hagberryVec[_loc9_].name,35,17);
                  _loc5_.addEventListener("triggered",medicineHandle);
                  _loc2_.push({
                     "icon":_loc11_,
                     "label":_loc4_ + "数量:" + GetPropFactor.hagberryVec[_loc9_].count + " \n" + StrHandle.lineFeed(GetPropFactor.hagberryVec[_loc9_].describe,31,"\n",24),
                     "accessory":_loc5_
                  });
                  displayVec.push(_loc11_);
                  displayVec.push(_loc5_);
                  _loc9_++;
               }
               break;
         }
         var _loc7_:ListCollection = new ListCollection(_loc2_);
         pvpPropUI.pvpPropList.dataProvider = _loc7_;
         pvpPropUI.pvpPropList.stopScrolling();
         pvpPropUI.tabs.selectedIndex = param1;
         if(pvpPropUI.pvpPropList.dataProvider)
         {
            pvpPropUI.pvpPropList.scrollToDisplayIndex(0);
         }
      }
      
      public function close() : void
      {
         if(pvpPropUI.pvpPropList.dataProvider)
         {
            pvpPropUI.pvpPropList.dataProvider.removeAll();
         }
         WinTweens.closeWin(pvpPropUI.mySpr,remove);
      }
      
      public function remove() : void
      {
         sendNotification("switch_win",null);
         pvpPropUI.removeFromParent();
      }
      
      private function medicineHandle(param1:Event) : void
      {
         sendNotification("switch_win",null,"LOAD_PLAYELF_WIN");
         var _loc3_:int = (param1.target as SwfButton).name;
         var _loc2_:PropVO = GetPropFactor.pvpPropVecArr[pvpPropUI.tabs.selectedIndex][_loc3_];
         _loc2_.isUsed = false;
         LogUtil("propVO==" + _loc2_.name);
         Facade.getInstance().sendNotification("SEND_USE_PROP",_loc2_);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = param1.getName();
         if("update_pvp_prop" === _loc3_)
         {
            GetPropFactor.getPVPPropVecArr();
            if(currentTab == 0)
            {
               _loc2_ = 0;
               while(_loc2_ < GetPropFactor.pvpPropVecArr.length)
               {
                  if(GetPropFactor.pvpPropVecArr[_loc2_].length != 0)
                  {
                     currentTab = _loc2_;
                     break;
                  }
                  _loc2_++;
               }
            }
            pvpPropUI.tabs.selectedIndex = currentTab;
            switchBackPackGoods(currentTab);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["update_pvp_prop"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("PVPPropMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
