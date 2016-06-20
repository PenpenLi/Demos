package com.mvc.views.mediator.mainCity.hunting
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import starling.display.DisplayObject;
   import com.mvc.views.uis.mainCity.hunting.HuntingSelectTickUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.DisposeDisplay;
   import com.mvc.models.vos.login.PlayerVO;
   import lzm.starling.swf.display.SwfButton;
   import com.common.util.xmlVOHandler.GetpropImage;
   import starling.display.Sprite;
   import com.common.util.SomeFontHandler;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.models.proxy.mainCity.hunting.HuntingPro;
   
   public class HuntingSelectTickMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "HuntingSelectTickMediator";
       
      private var displayVec:Vector.<DisplayObject>;
      
      public var huntingSelectTickUI:HuntingSelectTickUI;
      
      public function HuntingSelectTickMediator(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("HuntingSelectTickMediator",param1);
         huntingSelectTickUI = param1 as HuntingSelectTickUI;
         huntingSelectTickUI.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(huntingSelectTickUI.btn_close === _loc2_)
         {
            close();
         }
      }
      
      public function close() : void
      {
         huntingSelectTickUI.huntingTickListData.removeAll();
         WinTweens.closeWin(huntingSelectTickUI.mySpr,remove);
      }
      
      public function remove() : void
      {
         WinTweens.showCity();
         sendNotification("switch_win",null);
         huntingSelectTickUI.removeFromParent();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("update_hunting_select_prop" === _loc2_)
         {
            updateList();
         }
      }
      
      private function updateList() : void
      {
         var _loc4_:* = 0;
         var _loc5_:* = null;
         var _loc3_:* = null;
         var _loc1_:* = null;
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         huntingSelectTickUI.huntingTickListData.removeAll();
         var _loc2_:int = PlayerVO.huntingPropVec.length;
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            if(PlayerVO.huntingPropVec[_loc4_].name != "初级狩猎券" && PlayerVO.huntingPropVec[_loc4_].name != "中级狩猎券")
            {
               _loc5_ = huntingSelectTickUI.getBtn("btn_use");
               _loc5_.name = _loc4_.toString();
               _loc3_ = GetpropImage.getPropSpr(PlayerVO.huntingPropVec[_loc4_]);
               _loc1_ = SomeFontHandler.setColoeSize(PlayerVO.huntingPropVec[_loc4_].name,35,15);
               _loc5_.addEventListener("triggered",btn_useHandle);
               huntingSelectTickUI.huntingTickListData.push({
                  "icon":_loc3_,
                  "label":_loc1_ + "数量:" + PlayerVO.huntingPropVec[_loc4_].count + " \n" + PlayerVO.huntingPropVec[_loc4_].describe,
                  "accessory":_loc5_
               });
               displayVec.push(_loc3_);
               displayVec.push(_loc5_);
            }
            _loc4_++;
         }
      }
      
      private function btn_useHandle(param1:Event) : void
      {
         var _loc3_:int = (param1.target as SwfButton).name;
         trace("使用道具" + _loc3_);
         var _loc2_:PropVO = PlayerVO.huntingPropVec[_loc3_];
         if(_loc2_.name == "高级狩猎券")
         {
            (facade.retrieveProxy("HuntingPro") as HuntingPro).write2901(3);
         }
         else
         {
            (facade.retrieveProxy("HuntingPro") as HuntingPro).write2901(3,_loc2_.id);
         }
         close();
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["update_hunting_select_prop"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         facade.removeMediator("HuntingSelectTickMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
