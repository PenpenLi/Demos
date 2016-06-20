package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import starling.display.Image;
   import starling.text.TextField;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class UnlockUnitUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_unlock:Image;
      
      private var numText:TextField;
      
      public function UnlockUnitUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         spr_unlock = swf.createImage("img_unlock");
         addChild(spr_unlock);
         numText = new TextField(80,60,"","FZCuYuan-M03S",50,16777215,true);
         numText.x = spr_unlock.width - numText.width >> 1;
         numText.y = 8;
         addChild(numText);
      }
      
      public function set number(param1:int) : void
      {
         numText.text = param1.toString();
      }
   }
}
