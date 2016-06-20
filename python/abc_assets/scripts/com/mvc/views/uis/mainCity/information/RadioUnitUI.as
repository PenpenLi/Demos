package com.mvc.views.uis.mainCity.information
{
   import feathers.controls.Radio;
   import lzm.starling.swf.Swf;
   import com.common.managers.LoadSwfAssetsManager;
   import flash.text.TextFormat;
   
   public class RadioUnitUI extends Radio
   {
       
      private var swf:Swf;
      
      public function RadioUnitUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("information");
         if(!swf)
         {
            swf = LoadSwfAssetsManager.getInstance().assets.getSwf("laboratory");
         }
         this.defaultIcon = swf.createS9Image("s9_defaultSkin");
         this.defaultSelectedIcon = swf.createImage("img_defaultSelectedSkin");
         this.downIcon = swf.createImage("img_downSelectedSkin");
         this.disabledIcon = swf.createImage("img_disabledSelectedSkin");
         this.defaultLabelProperties.textFormat = new TextFormat("FZCuYuan-M03S",20,5715237);
      }
   }
}
