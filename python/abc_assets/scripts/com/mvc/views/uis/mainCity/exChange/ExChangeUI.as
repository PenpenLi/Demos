package com.mvc.views.uis.mainCity.exChange
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class ExChangeUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_exChange:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var btn_help:SwfButton;
      
      public var elfContain:Sprite;
      
      public function ExChangeUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("exChange");
         spr_exChange = swf.createSprite("spr_exChange");
         btn_close = spr_exChange.getButton("btn_close");
         btn_help = spr_exChange.getButton("btn_help");
         addChild(spr_exChange);
         elfContain = new Sprite();
         elfContain.x = 100;
         elfContain.y = 120;
         spr_exChange.addChild(elfContain);
      }
   }
}
