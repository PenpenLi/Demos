package com.mvc.views.uis.mainCity.mining
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import starling.events.Event;
   import starling.core.Starling;
   
   public class MiningRule extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.mining.MiningRule;
       
      public var btn_close:SwfButton;
      
      public function MiningRule()
      {
         super();
         init();
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.mining.MiningRule
      {
         return instance || new com.mvc.views.uis.mainCity.mining.MiningRule();
      }
      
      private function init() : void
      {
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.5;
         addChild(_loc1_);
         var _loc2_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("mining");
         var _loc4_:SwfSprite = _loc2_.createSprite("spr_rule");
         _loc4_ = _loc2_.createSprite("spr_rule");
         _loc4_.x = 1136 - _loc4_.width >> 1;
         _loc4_.y = 640 - _loc4_.height >> 1;
         addChild(_loc4_);
         btn_close = _loc4_.getButton("btn_close");
         var _loc3_:TextField = _loc4_.getTextField("tf_rule");
         addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         if(param1.target == btn_close)
         {
            this.removeFromParent();
         }
      }
      
      public function showRule() : void
      {
         (Starling.current.root as Game).addChild(this);
      }
      
      public function removeSelf() : void
      {
         if(instance)
         {
            this.removeFromParent(true);
            instance = null;
         }
      }
   }
}
