package com.mvc.views.mediator.union.unionTrain
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.union.unionTrain.UnionTrainUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.consts.ConfigConst;
   import com.mvc.models.proxy.union.UnionPro;
   import com.common.util.DisposeDisplay;
   import com.mvc.views.uis.union.unionTrain.ListUnitUI;
   import feathers.data.ListCollection;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class UnionTrainMedia extends Mediator
   {
      
      public static const NAME:String = "UnionTrainMedia";
       
      public var unionTrain:UnionTrainUI;
      
      public var displayVec:Vector.<DisplayObject>;
      
      public function UnionTrainMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("UnionTrainMedia",param1);
         unionTrain = param1 as UnionTrainUI;
         unionTrain.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(unionTrain.btn_close === _loc2_)
         {
            if(unionTrain.trainList.dataProvider)
            {
               unionTrain.trainList.dataProvider.removeAll();
            }
            WinTweens.closeWin(unionTrain.spr_unionTrain,remove);
         }
      }
      
      private function remove() : void
      {
         WinTweens.showCity();
         dispose();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if(ConfigConst.SHOW_UNIONTRAIN_LIST !== _loc2_)
         {
            if(ConfigConst.SHOW_UNION_TRAIN !== _loc2_)
            {
               if(ConfigConst.HIDE_UNION_TRAIN === _loc2_)
               {
                  unionTrain.visible = false;
                  LogUtil("=======================",unionTrain.visible);
               }
            }
            else
            {
               unionTrain.visible = true;
            }
         }
         else
         {
            show();
            showLabel();
         }
      }
      
      private function showLabel() : void
      {
         unionTrain.speedUpCount.text = "<font color=\'#dd632e\' size=\'20\'>今日剩余加速次数: " + UnionPro.speedUpTimes + "\n" + "今日剩余被加速次数: " + UnionPro.beSpeedUpTimes + "</font>";
         unionTrain.speedUpState.text = UnionPro.beSpeedUpLog;
      }
      
      private function show() : void
      {
         var _loc4_:* = 0;
         var _loc2_:* = null;
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         if(unionTrain.trainList.dataProvider)
         {
            unionTrain.trainList.dataProvider.removeAll();
         }
         var _loc1_:Array = [];
         _loc4_ = 0;
         while(_loc4_ < UnionPro.trainMemberVec.length)
         {
            _loc2_ = new ListUnitUI();
            _loc2_.myMemberVo = UnionPro.trainMemberVec[_loc4_];
            _loc1_.push({
               "icon":_loc2_,
               "label":""
            });
            displayVec.push(_loc2_);
            _loc4_++;
         }
         var _loc3_:ListCollection = new ListCollection(_loc1_);
         unionTrain.trainList.dataProvider = _loc3_;
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ConfigConst.SHOW_UNION_TRAIN,ConfigConst.HIDE_UNION_TRAIN,ConfigConst.SHOW_UNIONTRAIN_LIST];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         if(Facade.getInstance().hasMediator("OtherTrainMedia"))
         {
            (Facade.getInstance().retrieveMediator("OtherTrainMedia") as OtherTrainMedia).dispose();
         }
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         facade.removeMediator("UnionTrainMedia");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.unionTrainAssets);
      }
   }
}
