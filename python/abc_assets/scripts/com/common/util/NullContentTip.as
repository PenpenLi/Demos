package com.common.util
{
   import starling.display.Sprite;
   import starling.display.Image;
   import starling.text.TextField;
   import starling.display.DisplayObjectContainer;
   import com.common.managers.ElfFrontImageManager;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class NullContentTip extends Sprite
   {
      
      public static var instance:com.common.util.NullContentTip;
       
      private var elfTipImg:Image;
      
      private var nullMailTf:TextField;
      
      private var origin:DisplayObjectContainer;
      
      private var offestX:int;
      
      private var offestY:int;
      
      private var str:String;
      
      public function NullContentTip()
      {
         super();
      }
      
      public static function getInstance() : com.common.util.NullContentTip
      {
         return instance || new com.common.util.NullContentTip();
      }
      
      public function showNullMailTip(param1:String, param2:DisplayObjectContainer, param3:Number = 0, param4:Number = 0) : void
      {
         if(!elfTipImg)
         {
            str = param1;
            origin = param2;
            offestX = param3;
            offestY = param4;
            ElfFrontImageManager.getInstance().getImg(["img_ke3da2ya1"],showElfTipImg);
         }
      }
      
      private function showElfTipImg() : void
      {
         elfTipImg = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("img_ke3da2ya1"));
         elfTipImg.x = (origin.width - elfTipImg.width >> 1) + offestX;
         elfTipImg.y = (origin.height - elfTipImg.height >> 1) + offestY;
         if(!nullMailTf)
         {
            nullMailTf = new TextField(250,40,str,"FZCuYuan-M03S",30,5516307);
         }
         nullMailTf.x = elfTipImg.x + elfTipImg.width + 20;
         nullMailTf.y = elfTipImg.y + (elfTipImg.height - nullMailTf.height >> 1);
         origin.addChild(elfTipImg);
         origin.addChild(nullMailTf);
      }
      
      public function disposeNullMailTip() : void
      {
         if(elfTipImg)
         {
            ElfFrontImageManager.getInstance().disposeImg(elfTipImg);
         }
         if(nullMailTf)
         {
            nullMailTf.removeFromParent(true);
         }
         this.removeFromParent(true);
         instance = null;
      }
   }
}
