package com.common.themes
{
   import feathers.display.Scale9Image;
   import starling.text.TextField;
   import starling.display.Sprite;
   import com.common.managers.LoadSwfAssetsManager;
   import flash.geom.Rectangle;
   import starling.animation.Tween;
   import starling.core.Starling;
   
   public class Tips
   {
      
      private static var bg:Scale9Image;
      
      private static var TF:TextField;
      
      private static var container:Sprite;
      
      private static var root:Sprite;
      
      private static var h_gap:int = 35;
      
      private static var v_gap:int = 15;
      
      private static const minWidth:int = 280;
       
      public function Tips()
      {
         super();
      }
      
      public static function init(param1:Sprite) : void
      {
         root = param1;
         container = new Sprite();
         bg = LoadSwfAssetsManager.getInstance().assets.getSwf("loading").createS9Image("s9_BG");
         container.addChild(bg);
         TF = new TextField(0,0,"","FZCuYuan-M03S",25,16777215,true);
         TF.x = h_gap;
         TF.y = v_gap;
         TF.autoSize = "bothDirections";
         container.addChild(TF);
         container.touchable = false;
         container.name = "tips";
      }
      
      public static function show(param1:String) : void
      {
         var _loc2_:* = 0;
         try
         {
            TF.x = h_gap;
            TF.text = param1;
            _loc2_ = TF.bounds.width + h_gap * 2;
            bg.width = _loc2_;
            bg.height = TF.bounds.height + v_gap * 2 + 5;
            if(_loc2_ < 280)
            {
               TF.x = TF.x + (280 - _loc2_) / 2;
               bg.width = 280;
            }
            setXy();
            playAni();
            return;
         }
         catch(error:Error)
         {
            LogUtil("Tips丢失纹理");
            return;
         }
      }
      
      private static function setXy() : void
      {
         var _loc1_:Rectangle = bg.getBounds(container);
         container.x = (1136 - _loc1_.width) / 2;
         container.y = (640 - _loc1_.height) / 2.4;
         root.addChild(container);
         container.visible = true;
      }
      
      private static function playAni() : void
      {
         Starling.juggler.removeTweens(container);
         container.alpha = 0;
         var t:Tween = new Tween(container,0.5,"easeOut");
         Starling.juggler.add(t);
         t.fadeTo(1);
         var t2:Tween = new Tween(container,0.5,"easeOut");
         t2.delay = 1.5;
         t.nextTween = t2;
         t2.fadeTo(0);
         t2.onComplete = function():*
         {
            var /*UnknownSlot*/:* = §§dup(function():void
            {
               container.removeFromParent();
            });
            return function():void
            {
               container.removeFromParent();
            };
         }();
      }
   }
}
