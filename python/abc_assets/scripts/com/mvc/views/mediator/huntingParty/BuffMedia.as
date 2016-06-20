package com.mvc.views.mediator.huntingParty
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import starling.display.DisplayObject;
   import com.mvc.views.uis.huntingParty.BuffUI;
   import starling.events.Event;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.mvc.models.proxy.huntingParty.HuntingPartyPro;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.huntingParty.HuntPartyVO;
   import com.common.util.DisposeDisplay;
   import com.mvc.views.uis.huntingParty.BuffUnit;
   import com.common.util.xmlVOHandler.GetHuntingParty;
   import com.common.util.WinTweens;
   
   public class BuffMedia extends Mediator
   {
      
      public static const NAME:String = "BuffMedia";
       
      public var displayVec:Vector.<DisplayObject>;
      
      public var buff:BuffUI;
      
      public function BuffMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("BuffMedia",param1);
         buff = param1 as BuffUI;
         buff.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc4_:* = param1.target;
         if(buff.btn_close !== _loc4_)
         {
            if(buff.btn_f5 !== _loc4_)
            {
               if(buff.btn_invoke === _loc4_)
               {
                  _loc2_ = Alert.show("激活buff将会消耗200钻石，确认刷新？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                  _loc2_.addEventListener("close",alertHander);
               }
            }
            else
            {
               _loc3_ = Alert.show("刷新buff将会消耗200钻石，确认刷新？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
               _loc3_.addEventListener("close",alertHander);
            }
         }
         else
         {
            removeHandle();
            dispose();
         }
      }
      
      private function alertHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            (facade.retrieveProxy("HuntingPartyPro") as HuntingPartyPro).write4107();
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_HUNTBUFF_UI","UPDATE_HUNTBUFF","UPDATE_HUNTBUFFTIME"];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SHOW_HUNTBUFF_UI" !== _loc2_)
         {
            if("UPDATE_HUNTBUFF" !== _loc2_)
            {
               if("UPDATE_HUNTBUFFTIME" === _loc2_)
               {
                  if(HuntPartyVO.buffObj)
                  {
                     buff.updateTime();
                  }
               }
            }
            else
            {
               buff.setInfo();
            }
         }
         else
         {
            buff.setInfo();
            showList();
         }
      }
      
      private function showList() : void
      {
         var _loc4_:* = 0;
         var _loc2_:* = null;
         var _loc1_:Array = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         _loc4_ = 0;
         while(_loc4_ < GetHuntingParty.buffVec.length)
         {
            _loc2_ = new BuffUnit(GetHuntingParty.buffVec[_loc4_]);
            var _loc5_:* = 0.8;
            _loc2_.scaleY = _loc5_;
            _loc2_.scaleX = _loc5_;
            _loc1_.push({
               "icon":_loc2_,
               "label":""
            });
            _loc4_++;
         }
         var _loc3_:ListCollection = new ListCollection(_loc1_);
         buff.buffList.dataProvider = _loc3_;
      }
      
      private function removeHandle() : void
      {
         if(buff.buffList.dataProvider)
         {
            DisposeDisplay.dispose(displayVec);
            displayVec = Vector.<DisplayObject>([]);
            buff.buffList.dataProvider.removeAll();
            buff.buffList.dataProvider = null;
         }
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         WinTweens.showCity();
         facade.removeMediator("BuffMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
