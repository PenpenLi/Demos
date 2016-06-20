package com.mvc.views.mediator.mainCity.train
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.train.SeleTrainElfUI;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.views.uis.mainCity.train.ElfContainUI;
   import starling.events.Event;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import com.common.util.DisposeDisplay;
   import starling.display.Sprite;
   import feathers.data.ListCollection;
   import feathers.layout.VerticalLayout;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.proxy.mainCity.train.TrainPro;
   import starling.display.DisplayObject;
   
   public class SeleTrainElfMedia extends Mediator
   {
      
      public static const NAME:String = "SeleTrainElfMedia";
      
      public static var traGrdId:int;
       
      public var seleTrainElf:SeleTrainElfUI;
      
      private var allElfVec:Vector.<ElfVO>;
      
      private var allElfContainVec:Vector.<ElfContainUI>;
      
      public function SeleTrainElfMedia(param1:Object = null)
      {
         allElfVec = new Vector.<ElfVO>([]);
         allElfContainVec = new Vector.<ElfContainUI>([]);
         super("SeleTrainElfMedia",param1);
         seleTrainElf = param1 as SeleTrainElfUI;
         seleTrainElf.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(seleTrainElf.btn_close === _loc2_)
         {
            dispose();
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SHOW_SELETRAINELF" !== _loc2_)
         {
            if("CLOSE_SELETRAINELF" === _loc2_)
            {
               dispose();
               BeginnerGuide.playBeginnerGuide();
            }
         }
         else
         {
            show();
         }
      }
      
      private function show() : void
      {
         var _loc9_:* = 0;
         var _loc6_:* = null;
         var _loc10_:* = 0;
         var _loc4_:* = null;
         DisposeDisplay.dispose(allElfContainVec);
         allElfContainVec = new Vector.<ElfContainUI>([]);
         getAllElf();
         var _loc8_:int = allElfVec.length;
         var _loc3_:* = 2;
         var _loc1_:Array = [];
         var _loc5_:int = Math.floor(_loc8_ / _loc3_);
         var _loc2_:* = _loc3_;
         if(_loc8_ % _loc3_ != 0)
         {
            _loc5_++;
         }
         _loc9_ = 0;
         while(_loc9_ < _loc5_)
         {
            _loc6_ = new Sprite();
            if(_loc9_ == _loc5_ - 1 && _loc8_ % _loc3_ != 0)
            {
               _loc2_ = _loc8_ % _loc3_;
            }
            _loc10_ = 0;
            while(_loc10_ < _loc2_)
            {
               _loc4_ = new ElfContainUI();
               _loc4_.x = 375 * _loc10_;
               _loc4_.name = "seleElfTrain" + (_loc3_ * _loc9_ + _loc10_);
               _loc4_.myElfVo = allElfVec[_loc3_ * _loc9_ + _loc10_];
               allElfContainVec.push(_loc4_);
               _loc6_.addChild(_loc4_);
               _loc10_++;
            }
            _loc1_.push({
               "icon":_loc6_,
               "label":""
            });
            _loc9_++;
         }
         var _loc7_:ListCollection = new ListCollection(_loc1_);
         seleTrainElf.elfContainList.dataProvider = _loc7_;
         seleTrainElf.elfContainList.dataViewPort.addEventListener("CREAT_LIST_COMPLETE",creatComplete);
      }
      
      private function creatComplete() : void
      {
         (seleTrainElf.elfContainList.layout as VerticalLayout).gap = 0;
         seleTrainElf.elfContainList.dataViewPort.removeEventListener("CREAT_LIST_COMPLETE",creatComplete);
         BeginnerGuide.playBeginnerGuide();
      }
      
      public function getAllElf() : void
      {
         var _loc1_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc2_:* = 0;
         allElfVec = new Vector.<ElfVO>([]);
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc1_] != null)
            {
               allElfVec.push(PlayerVO.bagElfVec[_loc1_]);
            }
            _loc1_++;
         }
         _loc3_ = 0;
         while(_loc3_ < PlayerVO.comElfVec.length)
         {
            allElfVec.push(PlayerVO.comElfVec[_loc3_]);
            _loc3_++;
         }
         _loc4_ = 0;
         while(_loc4_ < TrainPro.trainVec.length)
         {
            if(TrainPro.trainVec[_loc4_].elfVo)
            {
               _loc2_ = 0;
               while(_loc2_ < allElfVec.length)
               {
                  if(TrainPro.trainVec[_loc4_].elfVo.id == allElfVec[_loc2_].id)
                  {
                     allElfVec.splice(_loc2_,1);
                     break;
                  }
                  _loc2_++;
               }
            }
            _loc4_++;
         }
         if(TrainPro.trainVec[traGrdId - 1].elfVo)
         {
            allElfVec.unshift(TrainPro.trainVec[traGrdId - 1].elfVo);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_SELETRAINELF","CLOSE_SELETRAINELF"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      private function cleanTrain() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < allElfContainVec.length)
         {
            allElfContainVec[_loc1_].clean(true);
            _loc1_++;
         }
      }
      
      public function dispose() : void
      {
         cleanTrain();
         DisposeDisplay.dispose(allElfContainVec);
         allElfContainVec = Vector.<ElfContainUI>([]);
         SeleTrainElfUI.isScrolling = false;
         facade.removeMediator("SeleTrainElfMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
