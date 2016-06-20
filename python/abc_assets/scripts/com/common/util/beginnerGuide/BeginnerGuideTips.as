package com.common.util.beginnerGuide
{
   import feathers.display.Scale9Image;
   import starling.text.TextField;
   import starling.display.Sprite;
   import com.common.managers.LoadSwfAssetsManager;
   import flash.geom.Rectangle;
   import starling.display.DisplayObject;
   import starling.utils.deg2rad;
   import starling.core.Starling;
   import starling.animation.Tween;
   
   public class BeginnerGuideTips
   {
      
      private static var bg:Scale9Image;
      
      private static var TF:TextField;
      
      private static var container:Sprite;
      
      private static var root:Sprite;
      
      private static var h_gap:int = 35;
      
      private static var v_gap:int = 15;
      
      private static const minWidth:int = 280;
       
      public function BeginnerGuideTips()
      {
         super();
      }
      
      public static function init() : void
      {
         root = Config.starling.root as Game;
         container = new Sprite();
         bg = LoadSwfAssetsManager.getInstance().assets.getSwf("loading").createS9Image("s9_BG");
         container.addChild(bg);
         TF = new TextField(0,0,"","FZCuYuan-M03S",25,16777215,true);
         TF.x = h_gap;
         TF.y = v_gap;
         TF.autoSize = "bothDirections";
         container.addChild(TF);
         container.touchable = false;
      }
      
      private static function setXy() : void
      {
         var _loc1_:Rectangle = bg.getBounds(container);
         container.x = (1136 - _loc1_.width) / 2;
         container.y = (640 - _loc1_.height) / 2.4;
         root.addChild(container);
      }
      
      public static function showBeginnersGuide(param1:String, param2:DisplayObject, param3:Sprite, param4:int, param5:int, param6:Number) : void
      {
         if(root == null)
         {
            init();
         }
         if(param1 == "")
         {
            container.removeFromParent();
            return;
         }
         TF.x = h_gap;
         TF.text = param1;
         var _loc7_:int = TF.bounds.width + h_gap * 2;
         bg.width = _loc7_;
         bg.height = TF.bounds.height + v_gap * 2 + 5;
         if(_loc7_ < 280 - 30)
         {
            TF.x = TF.x + (280 - 30 - _loc7_) / 2;
            bg.width = 280 - 30;
         }
         if(param2.scaleX == -1)
         {
            container.x = param4 + 50;
            container.y = param5 - 35;
         }
         else if(param6 == deg2rad(-90))
         {
            container.x = param4 - 50 - container.width;
            container.y = param5 - 35;
         }
         else if(param4 >= 1136 >> 1)
         {
            container.x = param4 - 50 - container.width;
            container.y = param5 - 35;
         }
         else
         {
            container.x = param4 + 50;
            container.y = param5 - 35;
         }
         LogUtil(param4 + "sss" + (1136 >> 1));
         param3.addChild(container);
         Starling.juggler.removeTweens(container);
         container.alpha = 0;
         var _loc8_:Tween = new Tween(container,0.3,"easeOut");
         Starling.juggler.add(_loc8_);
         _loc8_.animate("alpha",1,0);
      }
      
      public static function dispose() : void
      {
         if(root == null)
         {
            return;
         }
         container.removeFromParent(true);
         root = null;
      }
   }
}
