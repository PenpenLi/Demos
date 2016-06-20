package com.mvc.views.uis.mainCity.scoreShop
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfSprite;
   import feathers.display.Scale9Image;
   import starling.text.TextField;
   import lzm.starling.swf.Swf;
   import starling.display.DisplayObject;
   import flash.geom.Point;
   import starling.core.Starling;
   import starling.animation.Tween;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class ScoreShopNpcTips extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.scoreShop.ScoreShopNpcTips;
       
      public var spr_npcTips:SwfSprite;
      
      public var tipsBg:Scale9Image;
      
      private var tipsTf:TextField;
      
      private var swf:Swf;
      
      private var propNameTf:TextField;
      
      public function ScoreShopNpcTips()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("scoreShop");
         spr_npcTips = swf.createSprite("spr_npcTips");
         addChild(spr_npcTips);
         tipsBg = spr_npcTips.getChildByName("s9_npcTips") as Scale9Image;
         tipsTf = spr_npcTips.getChildByName("tf_npcTips") as TextField;
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.scoreShop.ScoreShopNpcTips
      {
         return instance || new com.mvc.views.uis.mainCity.scoreShop.ScoreShopNpcTips();
      }
      
      public function showNpcTips(param1:String, param2:DisplayObject) : void
      {
         tipsTf.text = param1;
         LogUtil("tipsTf" + tipsTf.text);
         var _loc5_:* = (tipsTf.text.length + 1) * tipsTf.fontSize;
         tipsTf.width = _loc5_;
         tipsBg.width = _loc5_;
         this.x = param2.localToGlobal(new Point(0,0)).x + param2.width;
         this.y = param2.localToGlobal(new Point(0,0)).y + this.height;
         if(this.x + tipsBg.width > 1136)
         {
            this.x = this.x - (this.x + tipsBg.width - 1136);
         }
         (Starling.current.root as Game).addChild(this);
         Starling.juggler.removeTweens(this);
         this.alpha = 0;
         var _loc3_:Tween = new Tween(this,0.5,"easeOut");
         Starling.juggler.add(_loc3_);
         _loc3_.fadeTo(1);
         var _loc4_:Tween = new Tween(this,0.5,"easeOut");
         Starling.juggler.add(_loc4_);
         _loc3_.nextTween = _loc4_;
         _loc4_.delay = 1.5;
         _loc4_.fadeTo(0);
         _loc4_.onComplete = onCompleteFun;
      }
      
      private function onCompleteFun() : void
      {
         this.removeFromParent();
      }
      
      public function destructSelf() : void
      {
         if(getInstance().parent)
         {
            Starling.juggler.removeTweens(this);
            this.removeFromParent(true);
         }
         instance = null;
      }
   }
}
