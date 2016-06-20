package com.mvc.views.mediator.mainCity.amuse
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.amuse.AmuseScoreRechargeUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import feathers.controls.TabBar;
   import com.mvc.models.proxy.mainCity.amuse.AmusePro;
   import com.common.util.WinTweens;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.DisposeDisplay;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.views.uis.mainCity.amuse.AmuseScoreRechargeGoodUnit;
   import lzm.starling.swf.display.SwfButton;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.themes.Tips;
   
   public class AmuseScoreRechargeMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "AmuseScoreRechargeMediator";
      
      public static var itemArr:Array = [];
      
      public static var tabsIndex:int;
       
      public var amuseScoreRechargeUI:AmuseScoreRechargeUI;
      
      private var displayVec:Vector.<DisplayObject>;
      
      private var nowItemId:int;
      
      private var verticalScrollPosition:Number;
      
      public function AmuseScoreRechargeMediator(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("AmuseScoreRechargeMediator",param1);
         amuseScoreRechargeUI = param1 as AmuseScoreRechargeUI;
         amuseScoreRechargeUI.addEventListener("triggered",triggeredHandler);
         amuseScoreRechargeUI.tabs.addEventListener("change",tabs_changeHandler);
      }
      
      private function tabs_changeHandler(param1:Event) : void
      {
         var _loc2_:TabBar = TabBar(param1.currentTarget);
         if(_loc2_.selectedIndex == -1)
         {
            return;
         }
         tabsIndex = _loc2_.selectedIndex;
         nowItemId = _loc2_.dataProvider.getItemAt(_loc2_.selectedIndex).itemId;
         LogUtil("nowItemId: " + nowItemId + " tabsIndex: " + _loc2_.selectedIndex);
         (facade.retrieveProxy("AmusePro") as AmusePro).write2503(nowItemId);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(amuseScoreRechargeUI.btn_close === _loc2_)
         {
            amuseScoreRechargeUI.propList.removeFromParent();
            WinTweens.closeWin(amuseScoreRechargeUI.spr_scoreRecharge,remove);
         }
      }
      
      private function remove() : void
      {
         WinTweens.showCity();
         amuseScoreRechargeUI.removeFromParent();
         sendNotification("switch_win",null);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.getName();
         if("amuse_update_score_list" !== _loc3_)
         {
            if("amuse_load_complete_switch_index" !== _loc3_)
            {
               if("amuse_update_score_point" === _loc3_)
               {
                  amuseScoreRechargeUI.tf_scoreNum.text = param1.getBody();
               }
            }
            else
            {
               amuseScoreRechargeUI.addChild(amuseScoreRechargeUI.propList);
               if(amuseScoreRechargeUI.tabs.dataProvider.length == 0)
               {
                  return;
               }
               if(tabsIndex > amuseScoreRechargeUI.tabs.dataProvider.length - 1 || tabsIndex < 0)
               {
                  tabsIndex = 0;
               }
               if(amuseScoreRechargeUI.tabs.selectedIndex != tabsIndex)
               {
                  amuseScoreRechargeUI.tabs.selectedIndex = tabsIndex;
               }
               else
               {
                  (facade.retrieveProxy("AmusePro") as AmusePro).write2503(nowItemId);
               }
            }
         }
         else
         {
            _loc2_ = param1.getBody() as Array;
            switchItem(_loc2_);
         }
      }
      
      private function switchItem(param1:Array) : void
      {
         var _loc8_:* = 0;
         var _loc5_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc4_:* = null;
         var _loc9_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc10_:* = null;
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         if(amuseScoreRechargeUI.propList.dataProvider)
         {
            amuseScoreRechargeUI.propList.dataProvider.removeAll();
         }
         _loc8_ = 0;
         while(_loc8_ < param1.length)
         {
            if(param1[_loc8_].hasOwnProperty("prop"))
            {
               _loc5_ = GetPropFactor.getPropVO(param1[_loc8_].prop.pId);
               _loc3_ = new AmuseScoreRechargeGoodUnit();
               _loc3_.addPropSpr(_loc5_);
               _loc2_ = "<font size = \'30\' color = \'#8b4216\'>" + _loc5_.name + "</font>" + "\n" + "<font size = \'22\' color = \'#8b4216\'>积分：</font>" + "<font size = \'22\' color = \'#489bde\'>" + param1[_loc8_].prop.price + "</font>" + "      \t" + "<font size = \'22\' color = \'#8b4216\'>今日可兑换：</font>" + "<font size = \'22\' color = \'#489bde\'>" + param1[_loc8_].prop.times + "</font>";
               _loc4_ = amuseScoreRechargeUI.getRechargeBtn();
               _loc4_.name = "道具" + _loc8_;
               _loc4_.addEventListener("triggered",rechargeBtn_triggeredHandler);
               displayVec.push(_loc3_,_loc4_);
               amuseScoreRechargeUI.propList.dataProvider.push({
                  "label":_loc2_,
                  "icon":_loc3_,
                  "accessory":_loc4_,
                  "goodId":_loc5_.id,
                  "price":param1[_loc8_].prop.price,
                  "times":param1[_loc8_].prop.times
               });
            }
            if(param1[_loc8_].hasOwnProperty("spirit"))
            {
               _loc9_ = GetElfFactor.getElfVO(param1[_loc8_].spirit.spId);
               _loc6_ = new AmuseScoreRechargeGoodUnit();
               _loc6_.addElfImg(_loc9_);
               _loc7_ = "<font size = \'30\' color = \'#8b4216\'>" + _loc9_.name + "</font>" + "\n" + "<font size = \'22\' color = \'#8b4216\'>积分：</font>" + "<font size = \'22\' color = \'#489bde\'>" + param1[_loc8_].spirit.price + "</font>" + "      \t" + "<font size = \'22\' color = \'#8b4216\'>今日可兑换：</font>" + "<font size = \'22\' color = \'#489bde\'>" + param1[_loc8_].spirit.times + "</font>";
               _loc10_ = amuseScoreRechargeUI.getRechargeBtn();
               _loc10_.name = "精灵" + _loc8_;
               _loc10_.addEventListener("triggered",rechargeBtn_triggeredHandler);
               displayVec.push(_loc6_,_loc10_);
               amuseScoreRechargeUI.propList.dataProvider.push({
                  "label":_loc7_,
                  "icon":_loc6_,
                  "accessory":_loc10_,
                  "goodId":_loc9_.elfId,
                  "price":param1[_loc8_].spirit.price,
                  "times":param1[_loc8_].spirit.times
               });
            }
            _loc8_++;
         }
         if(amuseScoreRechargeUI.propList.dataProvider)
         {
            amuseScoreRechargeUI.propList.scrollToPosition(0,verticalScrollPosition);
            verticalScrollPosition = 0;
         }
      }
      
      private function rechargeBtn_triggeredHandler(param1:Event) : void
      {
         var _loc3_:int = (param1.target as DisplayObject).name.substr(2);
         var _loc2_:int = amuseScoreRechargeUI.propList.dataProvider.getItemAt(_loc3_).goodId;
         LogUtil("扭蛋积分兑换按钮点击，name......id........." + (param1.target as DisplayObject).name,_loc2_);
         if(amuseScoreRechargeUI.propList.dataProvider.getItemAt(_loc3_).times <= 0)
         {
            Tips.show("亲，兑换次数不足哦。");
            return;
         }
         if(amuseScoreRechargeUI.tf_scoreNum.text < amuseScoreRechargeUI.propList.dataProvider.getItemAt(_loc3_).price)
         {
            Tips.show("亲，积分不足哦。");
            return;
         }
         verticalScrollPosition = amuseScoreRechargeUI.propList.verticalScrollPosition;
         (facade.retrieveProxy("AmusePro") as AmusePro).write2504(nowItemId,_loc2_,(param1.target as DisplayObject).name.substr(0,2) == "道具"?1:2.0);
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["amuse_update_score_list","amuse_load_complete_switch_index","amuse_update_score_point"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         WinTweens.showCity();
         facade.removeMediator("AmuseScoreRechargeMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
