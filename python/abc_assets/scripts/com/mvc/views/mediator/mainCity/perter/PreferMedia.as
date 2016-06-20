package com.mvc.views.mediator.mainCity.perter
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.perfer.PreferUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.views.uis.mainCity.perfer.PreferList;
   import com.mvc.models.proxy.mainCity.specialAct.SpecialActPro;
   import feathers.data.ListCollection;
   import com.common.util.DisposeDisplay;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class PreferMedia extends Mediator
   {
      
      public static const NAME:String = "PreferMedia";
      
      public static const assets:Array = ["preferential"];
       
      public var prefer:PreferUI;
      
      private var displayVec:Vector.<DisplayObject>;
      
      public function PreferMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("PreferMedia",param1);
         prefer = param1 as PreferUI;
         prefer.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(prefer.btn_close === _loc2_)
         {
            clean();
            WinTweens.closeWin(prefer.spr_prefer,remove);
         }
      }
      
      private function remove() : void
      {
         dispose();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = param1.getName();
         if("SHOW_PREFER_GIFT" === _loc3_)
         {
            _loc2_ = param1.getBody() as int;
            show(_loc2_);
            if(param1.getType())
            {
               prefer.addLabel();
            }
         }
      }
      
      private function show(param1:int) : void
      {
         var _loc5_:* = 0;
         var _loc3_:* = null;
         clean();
         var _loc2_:Array = [];
         _loc5_ = 0;
         while(_loc5_ < SpecialActPro.preferVec.length)
         {
            _loc3_ = new PreferList();
            _loc3_.index = _loc5_;
            _loc3_.myPreferVo = SpecialActPro.preferVec[_loc5_];
            _loc2_.push({
               "icon":_loc3_,
               "label":""
            });
            displayVec.push(_loc3_);
            _loc5_++;
         }
         var _loc4_:ListCollection = new ListCollection(_loc2_);
         prefer.preferList.dataProvider = _loc4_;
         if(prefer.preferList.dataProvider)
         {
            prefer.preferList.scrollToDisplayIndex(param1);
         }
      }
      
      private function clean() : void
      {
         if(prefer.preferList.dataProvider)
         {
            prefer.preferList.dataProvider.removeAll();
            prefer.preferList.dataProvider = null;
            DisposeDisplay.dispose(displayVec);
            displayVec = Vector.<DisplayObject>([]);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_PREFER_GIFT"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         WinTweens.showCity();
         facade.removeMediator("PreferMedia");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(assets);
      }
   }
}
