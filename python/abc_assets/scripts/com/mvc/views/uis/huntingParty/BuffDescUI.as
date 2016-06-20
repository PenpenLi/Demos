package com.mvc.views.uis.huntingParty
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.display.DisplayObject;
   import flash.geom.Point;
   import starling.core.Starling;
   
   public class BuffDescUI extends Sprite
   {
      
      private static var instance:com.mvc.views.uis.huntingParty.BuffDescUI;
       
      private var swf:Swf;
      
      private var spr_desc:SwfSprite;
      
      private var prompt:TextField;
      
      public function BuffDescUI()
      {
         super();
         init();
      }
      
      public static function getInstance() : com.mvc.views.uis.huntingParty.BuffDescUI
      {
         return instance || new com.mvc.views.uis.huntingParty.BuffDescUI();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("huntingParty");
         spr_desc = swf.createSprite("spr_desc");
         prompt = spr_desc.getTextField("prompt");
         addChild(spr_desc);
      }
      
      public function showInfo(param1:String, param2:DisplayObject) : void
      {
         var _loc3_:Point = param2.parent.localToGlobal(new Point(param2.x,param2.y));
         prompt.text = param1;
         this.pivotX = this.width;
         this.pivotY = this.height;
         this.x = _loc3_.x;
         this.y = _loc3_.y;
         (Starling.current.root as Game).addChild(this);
      }
      
      public function remove() : void
      {
         removeFromParent(true);
         instance = null;
      }
   }
}
