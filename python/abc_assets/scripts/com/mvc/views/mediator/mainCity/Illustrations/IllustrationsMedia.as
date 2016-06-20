package com.mvc.views.mediator.mainCity.Illustrations
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.Illustrations.IllustrationsUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.mvc.views.uis.mainCity.Illustrations.HabitatUI;
   import extend.SoundEvent;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.DisposeDisplay;
   import starling.display.Image;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.managers.ELFMinImageManager;
   import lzm.starling.swf.display.SwfButton;
   import feathers.data.ListCollection;
   import feathers.controls.List;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.managers.ElfFrontImageManager;
   
   public class IllustrationsMedia extends Mediator
   {
      
      public static const NAME:String = "IllustrationsMedia";
      
      public static var ifNew:Boolean;
       
      public var illustrations:IllustrationsUI;
      
      private var elfArr:Array;
      
      public var displayVec:Vector.<DisplayObject>;
      
      public function IllustrationsMedia(param1:Object = null)
      {
         super("IllustrationsMedia",param1);
         illustrations = param1 as IllustrationsUI;
         displayVec = new Vector.<DisplayObject>([]);
         illustrations.addEventListener("triggered",clickHandler);
      }
      
      public static function numberTxt(param1:String) : String
      {
         switch(param1.length - 1)
         {
            case 0:
               var param1:String = "00" + param1;
               break;
            case 1:
               param1 = "0" + param1;
            default:
               param1 = "0" + param1;
         }
         return param1;
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.target;
         if(illustrations.btn_close !== _loc3_)
         {
            if(illustrations.btn_check !== _loc3_)
            {
               if(illustrations.btn_elfSound === _loc3_)
               {
                  SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","elf" + illustrations.myElfVo.sound);
               }
            }
            else
            {
               if(!facade.hasMediator("HabitatMedia"))
               {
                  facade.registerMediator(new HabitatMedia(new HabitatUI()));
               }
               _loc2_ = (facade.retrieveMediator("HabitatMedia") as HabitatMedia).UI as HabitatUI;
               illustrations.addChild(_loc2_);
               WinTweens.openWin(_loc2_.spr_mapBg);
               _loc2_.myElfVo = illustrations.myElfVo;
            }
         }
         else
         {
            if(illustrations.list.dataProvider)
            {
               illustrations.list.dataProvider.removeAll();
            }
            WinTweens.closeWin(illustrations.spr_background,remove);
         }
      }
      
      private function remove() : void
      {
         sendNotification("switch_win",null);
         dispose();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = null;
         var _loc9_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:* = null;
         var _loc10_:* = null;
         var _loc8_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc11_:* = param1.getName();
         if("SHOW_ILLUSTRATIONS_ELF" === _loc11_)
         {
            _loc2_ = param1.getBody() as Array;
            elfArr = [];
            DisposeDisplay.dispose(displayVec);
            displayVec = Vector.<DisplayObject>([]);
            _loc9_ = -1;
            _loc6_ = 0;
            while(_loc6_ < _loc2_.length)
            {
               _loc8_ = _loc6_ + 1;
               _loc11_ = _loc2_[_loc6_];
               if(0 !== _loc11_)
               {
                  if(1 !== _loc11_)
                  {
                     if(2 === _loc11_)
                     {
                        if(_loc9_ == -1)
                        {
                           _loc9_ = _loc6_;
                        }
                        _loc7_ = GetElfFactor.getElfVO(_loc8_,false);
                        _loc10_ = ELFMinImageManager.getElfM(_loc7_.imgName,0.7);
                        _loc4_ = illustrations.getElfBall();
                        elfArr.push({
                           "icon":_loc10_,
                           "label":numberTxt(_loc8_) + "   " + _loc7_.name,
                           "accessory":_loc4_
                        });
                        displayVec.push(_loc4_);
                        displayVec.push(_loc10_);
                     }
                  }
                  else
                  {
                     if(_loc9_ == -1)
                     {
                        _loc9_ = _loc6_;
                     }
                     _loc7_ = GetElfFactor.getElfVO(_loc8_,false);
                     _loc10_ = ELFMinImageManager.getElfM(_loc7_.imgName,0.7);
                     elfArr.push({
                        "icon":_loc10_,
                        "label":numberTxt(_loc8_) + "   " + _loc7_.name
                     });
                     displayVec.push(_loc10_);
                  }
               }
               else
               {
                  _loc3_ = illustrations.getImg();
                  elfArr.push({
                     "icon":_loc3_,
                     "label":numberTxt(_loc8_) + "   ???"
                  });
                  displayVec.push(_loc3_);
               }
               _loc7_ = null;
               _loc6_++;
            }
            _loc5_ = new ListCollection(elfArr);
            illustrations.list.dataProvider = _loc5_;
            illustrations.list.addEventListener("change",list_changeHandler);
            if(_loc9_ == -1)
            {
               _loc9_ = 0;
            }
            illustrations.list.selectedIndex = _loc9_;
            if(illustrations.list.dataProvider)
            {
               illustrations.list.scrollToDisplayIndex(_loc9_);
            }
         }
      }
      
      private function list_changeHandler(param1:Event) : void
      {
         var _loc4_:List = List(param1.currentTarget);
         if(_loc4_.selectedIndex < 0)
         {
            return;
         }
         var _loc2_:int = _loc4_.selectedIndex;
         var _loc3_:String = _loc2_ + 1;
         var _loc5_:ElfVO = GetElfFactor.getElfVO(_loc3_,false);
         if(elfArr[_loc2_].label == numberTxt(_loc3_) + "   ???")
         {
            _loc5_.relation = 0;
            illustrations.myElfVo = _loc5_;
            return;
         }
         if(elfArr[_loc2_].accessory)
         {
            _loc5_.relation = 2;
         }
         else
         {
            _loc5_.relation = 1;
         }
         illustrations.myElfVo = _loc5_;
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_ILLUSTRATIONS_ELF"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         WinTweens.showCity();
         if(facade.hasMediator("HabitatMedia"))
         {
            (facade.retrieveMediator("HabitatMedia") as HabitatMedia).dispose();
         }
         illustrations.cleanImg();
         illustrations.removeFromParent();
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         facade.removeMediator("IllustrationsMedia");
         UI.dispose();
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.IllustrationsAssets);
         ElfFrontImageManager.getInstance().dispose();
      }
   }
}
