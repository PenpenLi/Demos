package com.mvc.views.mediator.huntingParty
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.huntingParty.HuntAdventureUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.mvc.models.proxy.huntingParty.HuntingPartyPro;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.DisposeDisplay;
   import starling.display.Sprite;
   import feathers.data.ListCollection;
   
   public class HuntAdventureMedia extends Mediator
   {
      
      public static const NAME:String = "HuntAdventureMedia";
       
      public var huntAdventure:HuntAdventureUI;
      
      public var displayVec:Vector.<DisplayObject>;
      
      public function HuntAdventureMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("HuntAdventureMedia",param1);
         huntAdventure = param1 as HuntAdventureUI;
         huntAdventure.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(huntAdventure.btn_cancel !== _loc2_)
         {
            if(huntAdventure.btn_adventure === _loc2_)
            {
               dispose();
               (facade.retrieveProxy("HuntingPartyPro") as HuntingPartyPro).write4102(HuntingPartyMedia.nodeVO);
            }
         }
         else
         {
            dispose();
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_HUNTADVENTURE_UI"];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SHOW_HUNTADVENTURE_UI" === _loc2_)
         {
            huntAdventure.setInfo(HuntingPartyMedia.nodeVO);
            showList();
         }
      }
      
      private function showList() : void
      {
         var _loc5_:* = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc1_:Array = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         _loc5_ = 0;
         while(_loc5_ < HuntingPartyMedia.nodeVO.elfPropertyArr.length)
         {
            _loc2_ = HuntingPartyMedia.nodeVO.elfPropertyArr[_loc5_];
            _loc3_ = huntAdventure.seticon(_loc2_);
            _loc1_.push({
               "icon":_loc3_,
               "label":"             " + _loc2_ + "系精灵"
            });
            displayVec.push(_loc3_);
            _loc5_++;
         }
         var _loc4_:ListCollection = new ListCollection(_loc1_);
         huntAdventure.list.dataProvider = _loc4_;
      }
      
      private function removeHandle() : void
      {
         if(huntAdventure.list.dataProvider)
         {
            DisposeDisplay.dispose(displayVec);
            displayVec = Vector.<DisplayObject>([]);
            huntAdventure.list.dataProvider.removeAll();
            huntAdventure.list.dataProvider = null;
         }
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("HuntAdventureMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
