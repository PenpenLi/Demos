package com.mvc.views.mediator.mainCity.train
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.train.ElfContainUI;
   import com.mvc.views.uis.mainCity.train.PropUnitUI;
   import com.mvc.views.uis.mainCity.train.TrainUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.mvc.views.mediator.mainCity.myElf.MyElfMedia;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.util.DisposeDisplay;
   import starling.display.Sprite;
   import com.mvc.models.proxy.mainCity.train.TrainPro;
   import feathers.data.ListCollection;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import starling.display.DisplayObject;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class TrainMedia extends Mediator
   {
      
      public static const NAME:String = "TrainMedia";
      
      public static var trainUIVec:Vector.<ElfContainUI> = new Vector.<ElfContainUI>([]);
      
      public static var propVec:Vector.<PropUnitUI> = new Vector.<PropUnitUI>([]);
      
      public static var isUseProp:Boolean;
      
      public static var isNewOpen:Boolean;
       
      public var train:TrainUI;
      
      public function TrainMedia(param1:Object = null)
      {
         super("TrainMedia",param1);
         train = param1 as TrainUI;
         train.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(train.btn_close === _loc2_)
         {
            cleanTrain();
            cleanProp();
            WinTweens.closeWin(train.spr_train,remove);
         }
      }
      
      private function remove() : void
      {
         sendNotification("switch_win",null);
         dispose();
         if(MyElfMedia.isJumpTrain && !TrainMedia.isNewOpen)
         {
            MyElfMedia.isJumpTrain = false;
            sendNotification("UPDATA_MYELF_DATA");
         }
         else
         {
            TrainMedia.isNewOpen = false;
            WinTweens.showCity();
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SEND_TRAIN" !== _loc2_)
         {
            if("CLICK_LIGHT" === _loc2_)
            {
               clickLight(param1.getBody() as PropUnitUI);
            }
         }
         else
         {
            show();
            showProp();
         }
      }
      
      private function clickLight(param1:PropUnitUI) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = 0;
         _loc3_ = 0;
         while(_loc3_ < propVec.length)
         {
            if(param1.id == _loc3_)
            {
               propVec[_loc3_].addLight();
            }
            else
            {
               propVec[_loc3_].removeLight();
            }
            _loc3_++;
         }
         _loc2_ = 0;
         while(_loc2_ < trainUIVec.length)
         {
            if(trainUIVec[_loc2_].elfVo)
            {
               trainUIVec[_loc2_].addLight(param1);
            }
            _loc2_++;
         }
         if(isUseProp)
         {
            train.propmpt.text = "点击或者长按精灵使用糖果";
         }
         else
         {
            train.propmpt.text = "训练中的精灵每隔一段时间会获得一定的经验值";
         }
      }
      
      private function showProp() : void
      {
         var _loc3_:* = 0;
         var _loc1_:* = null;
         var _loc2_:* = null;
         propVec = new Vector.<PropUnitUI>([]);
         _loc3_ = 245;
         while(_loc3_ < 249)
         {
            _loc1_ = new PropUnitUI();
            _loc2_ = GetPropFactor.getProp(_loc3_);
            if(!_loc2_)
            {
               _loc2_ = GetPropFactor.getPropVO(_loc3_);
            }
            LogUtil("糖果的主键id===========",_loc2_.id,_loc2_.name);
            _loc1_.myPropVo = _loc2_;
            var _loc4_:* = 0.85;
            _loc1_.scaleY = _loc4_;
            _loc1_.scaleX = _loc4_;
            _loc1_.y = 99 * (248 - _loc3_) + 50;
            _loc1_.x = 15;
            _loc1_.id = _loc3_ - 245;
            train.spr_propContain.addChild(_loc1_);
            propVec.push(_loc1_);
            _loc3_++;
         }
      }
      
      private function show() : void
      {
         var _loc5_:* = 0;
         var _loc3_:* = null;
         var _loc7_:* = 0;
         var _loc2_:* = null;
         var _loc6_:* = 0;
         DisposeDisplay.dispose(trainUIVec);
         var _loc1_:Array = [];
         trainUIVec = new Vector.<ElfContainUI>([]);
         _loc5_ = 0;
         while(_loc5_ < 6)
         {
            _loc3_ = new Sprite();
            _loc7_ = 0;
            while(_loc7_ < 2)
            {
               _loc2_ = new ElfContainUI();
               _loc6_ = _loc5_ * 2 + _loc7_;
               _loc2_.myTrainVO = TrainPro.trainVec[_loc6_];
               _loc2_.x = 373 * _loc7_;
               trainUIVec.push(_loc2_);
               _loc3_.addChild(_loc2_);
               _loc7_++;
            }
            _loc1_.push({
               "icon":_loc3_,
               "label":""
            });
            _loc5_++;
         }
         var _loc4_:ListCollection = new ListCollection(_loc1_);
         train.elfContainList.dataProvider = _loc4_;
         train.elfContainList.dataViewPort.addEventListener("CREAT_LIST_COMPLETE",creatListComplete);
      }
      
      private function creatListComplete() : void
      {
         BeginnerGuide.playBeginnerGuide();
         train.elfContainList.dataViewPort.removeEventListener("CREAT_LIST_COMPLETE",creatListComplete);
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SEND_TRAIN","CLICK_LIGHT"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         if(PVPPro.isAcceptPvpInvite)
         {
            if(MyElfMedia.isJumpTrain && !TrainMedia.isNewOpen)
            {
               MyElfMedia.isJumpTrain = false;
               sendNotification("UPDATA_MYELF_DATA");
            }
            else
            {
               TrainMedia.isNewOpen = false;
               WinTweens.showCity();
            }
         }
         if(Facade.getInstance().hasMediator("SeleTrainElfMedia"))
         {
            (Facade.getInstance().retrieveMediator("SeleTrainElfMedia") as SeleTrainElfMedia).dispose();
         }
         TrainUI.isScrolling = false;
         DisposeDisplay.dispose(trainUIVec);
         trainUIVec = Vector.<ElfContainUI>([]);
         facade.removeMediator("TrainMedia");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.trainAssets);
      }
      
      private function cleanTrain() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < trainUIVec.length)
         {
            trainUIVec[_loc1_].clean(true);
            _loc1_++;
         }
      }
      
      private function cleanProp() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < propVec.length)
         {
            propVec[_loc1_].clean();
            _loc1_++;
         }
      }
   }
}
