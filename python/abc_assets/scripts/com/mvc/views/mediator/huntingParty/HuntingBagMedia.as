package com.mvc.views.mediator.huntingParty
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.huntingParty.HuntingBagUI;
   import starling.display.DisplayObject;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.huntingParty.HuntPartyVO;
   import com.common.util.DisposeDisplay;
   import lzm.starling.swf.display.SwfButton;
   import com.common.util.xmlVOHandler.GetpropImage;
   import starling.display.Sprite;
   import com.common.util.SomeFontHandler;
   import feathers.data.ListCollection;
   import com.mvc.views.mediator.fighting.FightingMedia;
   import com.common.themes.Tips;
   import feathers.controls.Alert;
   import com.mvc.models.proxy.huntingParty.HuntingPartyPro;
   
   public class HuntingBagMedia extends Mediator
   {
      
      public static const NAME:String = "HuntingBagMedia";
       
      public var bag:HuntingBagUI;
      
      public var displayVec:Vector.<DisplayObject>;
      
      private var propVo:PropVO;
      
      public function HuntingBagMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("HuntingBagMedia",param1);
         bag = param1 as HuntingBagUI;
         bag.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(bag.btn_close === _loc2_)
         {
            removeHandle();
            WinTweens.closeWin(bag.spr_bag,dispose);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_HUNTBAG_UI"];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SHOW_HUNTBAG_UI" === _loc2_)
         {
            LogUtil("展示背包界面=",HuntPartyVO.bagVec.length);
            showList();
         }
      }
      
      private function showList() : void
      {
         var _loc5_:* = 0;
         var _loc6_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc1_:Array = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         _loc5_ = 0;
         while(_loc5_ < HuntPartyVO.bagVec.length)
         {
            _loc6_ = bag.getBtn("btn_btn_shi");
            _loc6_.name = _loc5_.toString();
            _loc3_ = GetpropImage.getPropSpr(HuntPartyVO.bagVec[_loc5_],false);
            _loc2_ = SomeFontHandler.setColoeSize(HuntPartyVO.bagVec[_loc5_].name,35,13);
            _loc6_.addEventListener("triggered",useProp);
            _loc1_.push({
               "icon":_loc3_,
               "label":_loc2_ + "数量:" + HuntPartyVO.bagVec[_loc5_].count + " \n" + HuntPartyVO.bagVec[_loc5_].describe,
               "accessory":_loc6_
            });
            displayVec.push(_loc3_,_loc6_);
            _loc5_++;
         }
         var _loc4_:ListCollection = new ListCollection(_loc1_);
         bag.bagList.dataProvider = _loc4_;
      }
      
      private function useProp(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = (param1.target as SwfButton).name;
         propVo = HuntPartyVO.bagVec[_loc3_];
         if(propVo.type == 23)
         {
            if(FightingMedia.isFighting)
            {
               return Tips.show("战斗过程中不能使用积分卡");
            }
            _loc2_ = Alert.show("您确定要使用【" + propVo.name + "】么？","温馨提示",new ListCollection([{"label":"确定"},{"label":"取消"}]));
            _loc2_.addEventListener("close",alertHander);
         }
         else if(propVo.type == 5)
         {
            Tips.show("老爸说过,每一样东西都有合适使用的时候");
         }
      }
      
      private function alertHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            (facade.retrieveProxy("HuntingPartyPro") as HuntingPartyPro).write4108(propVo);
         }
      }
      
      private function removeHandle() : void
      {
         if(bag.bagList.dataProvider)
         {
            DisposeDisplay.dispose(displayVec);
            displayVec = Vector.<DisplayObject>([]);
            bag.bagList.dataProvider.removeAll();
            bag.bagList.dataProvider = null;
         }
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         WinTweens.showCity();
         facade.removeMediator("HuntingBagMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
