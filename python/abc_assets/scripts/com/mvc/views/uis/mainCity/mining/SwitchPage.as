package com.mvc.views.uis.mainCity.mining
{
   import starling.display.Sprite;
   import starling.display.Image;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.common.events.EventCenter;
   import com.common.managers.LoadOtherAssetsManager;
   import starling.animation.Tween;
   import starling.core.Starling;
   
   public class SwitchPage extends Sprite
   {
       
      protected var preX:Number;
      
      protected var lastX:Number;
      
      protected var _isMoving:Boolean;
      
      protected var _bgName:String;
      
      protected var _gestureStatus:String = "normal";
      
      protected var miningBg:Image;
      
      public function SwitchPage()
      {
         super();
         addEventListener("touch",touchHandler);
      }
      
      public function get gestureStatus() : String
      {
         return _gestureStatus;
      }
      
      public function set gestureStatus(param1:String) : void
      {
         _gestureStatus = param1;
      }
      
      protected function touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this);
         if(!_loc2_ || isMoving)
         {
            return;
         }
         if(_loc2_.phase == "began")
         {
            preX = _loc2_.globalX;
         }
         if(_loc2_.phase == "ended")
         {
            lastX = _loc2_.globalX;
            LogUtil("lastX - preX: " + (lastX - preX));
            if(lastX - preX > 100)
            {
               LogUtil("手指右滑");
               gestureStatus = "right";
               EventCenter.dispatchEvent("mining_finger_right");
            }
            else if(lastX - preX < -100)
            {
               LogUtil("手指左滑");
               gestureStatus = "left";
               EventCenter.dispatchEvent("mining_finger_left");
            }
         }
      }
      
      protected function addBg(param1:String) : void
      {
         this.bgName = param1;
         if(!LoadOtherAssetsManager.getInstance().assets.getTexture(param1))
         {
            EventCenter.addEventListener("load_other_asset_complete",load_miningBg_completeHandler);
            LoadOtherAssetsManager.getInstance().addMiningBgAssets(param1);
         }
         else
         {
            miningBg = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(param1));
            addChildAt(miningBg,0);
         }
      }
      
      private function load_miningBg_completeHandler() : void
      {
         EventCenter.removeEventListener("load_other_asset_complete",load_miningBg_completeHandler);
         var _loc1_:Image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(bgName));
         addChildAt(_loc1_,0);
      }
      
      public function get bgName() : String
      {
         return _bgName;
      }
      
      public function set bgName(param1:String) : void
      {
         _bgName = param1;
      }
      
      public function get isMoving() : Boolean
      {
         return _isMoving;
      }
      
      public function setMoving(param1:Boolean, param2:Function = null) : void
      {
         value = param1;
         callBack = param2;
         if(value)
         {
            var tween:Tween = new Tween(this,0.5,"easeOut");
            Starling.current.juggler.add(tween);
            if(gestureStatus == "right")
            {
               tween.animate("x",this.x + 1136,this.x);
            }
            if(gestureStatus == "left")
            {
               tween.animate("x",this.x - 1136,this.x);
            }
            tween.onComplete = function():void
            {
               if(callBack)
               {
                  callBack();
               }
               Starling.current.juggler.removeTweens(this);
               _isMoving = false;
            };
         }
         _isMoving = value;
      }
   }
}
