package com.mvc.views.mediator.union.unionTrain
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.union.unionTrain.OtherTrainUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.common.consts.ConfigConst;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.DisposeDisplay;
   import com.mvc.models.proxy.union.UnionPro;
   import com.common.themes.Tips;
   import starling.display.Sprite;
   import com.mvc.views.uis.union.unionTrain.TrainElfUnitUI;
   import feathers.data.ListCollection;
   
   public class OtherTrainMedia extends Mediator
   {
      
      public static const NAME:String = "OtherTrainMedia";
      
      public static var userId:String;
      
      public static var isAddExp:Boolean;
       
      public var otherTain:OtherTrainUI;
      
      public var displayVec:Vector.<DisplayObject>;
      
      public function OtherTrainMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("OtherTrainMedia",param1);
         otherTain = param1 as OtherTrainUI;
         otherTain.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(otherTain.btn_close === _loc2_)
         {
            if(otherTain.otherTrainList.dataProvider)
            {
               otherTain.otherTrainList.dataProvider.removeAll();
            }
            dispose();
            sendNotification(ConfigConst.SHOW_UNION_TRAIN);
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if(ConfigConst.SHOW_OTHERTRAIN_LIST === _loc2_)
         {
            show();
         }
      }
      
      private function show() : void
      {
         var _loc9_:* = 0;
         var _loc6_:* = null;
         var _loc10_:* = 0;
         var _loc2_:* = null;
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         if(otherTain.otherTrainList.dataProvider)
         {
            otherTain.otherTrainList.dataProvider.removeAll();
         }
         if(UnionPro.otherTrainVec.length == 0)
         {
            return Tips.show("该会员训练位没有精灵");
         }
         var _loc1_:Array = [];
         var _loc8_:int = UnionPro.otherTrainVec.length;
         var _loc4_:* = 2;
         var _loc5_:int = Math.floor(_loc8_ / _loc4_);
         var _loc3_:* = _loc4_;
         if(_loc8_ % _loc4_ != 0)
         {
            _loc5_++;
         }
         _loc9_ = 0;
         while(_loc9_ < _loc5_)
         {
            if(_loc9_ == _loc5_ - 1 && _loc8_ % _loc4_ != 0)
            {
               _loc3_ = _loc8_ % _loc4_;
            }
            _loc6_ = new Sprite();
            _loc10_ = 0;
            while(_loc10_ < _loc3_)
            {
               _loc2_ = new TrainElfUnitUI();
               _loc2_.x = 400 * _loc10_;
               _loc2_.myTrainVo = UnionPro.otherTrainVec[_loc4_ * _loc9_ + _loc10_];
               _loc6_.addChild(_loc2_);
               _loc10_++;
            }
            _loc1_.push({
               "icon":_loc6_,
               "label":""
            });
            displayVec.push(_loc6_);
            _loc9_++;
         }
         var _loc7_:ListCollection = new ListCollection(_loc1_);
         otherTain.otherTrainList.dataProvider = _loc7_;
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ConfigConst.SHOW_OTHERTRAIN_LIST];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         isAddExp = false;
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         facade.removeMediator("OtherTrainMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
