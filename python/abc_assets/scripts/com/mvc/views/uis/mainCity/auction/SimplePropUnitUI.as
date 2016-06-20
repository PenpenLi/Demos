package com.mvc.views.uis.mainCity.auction
{
   import starling.display.Sprite;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import starling.text.TextField;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfImage;
   import com.common.util.xmlVOHandler.GetpropImage;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.views.uis.mainCity.firstRecharge.FirstRchRewardTips;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class SimplePropUnitUI extends Sprite
   {
       
      private var _propVo:PropVO;
      
      private var image:Sprite;
      
      private var _scale:Number;
      
      private var _txt:String;
      
      private var decText:TextField;
      
      private var swf:Swf;
      
      private var numBg:SwfImage;
      
      private var numTxt:TextField;
      
      public function SimplePropUnitUI(param1:String = "", param2:Number = 1)
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("auction");
         _scale = param2;
         _txt = param1;
         numBg = swf.createImage("img_numBg");
         numBg.x = 72;
         numBg.y = 73;
         addChild(numBg);
         numTxt = new TextField(50,20,_txt,"FZCuYuan-M03S",20,16777215,true);
         numTxt.x = 63;
         numTxt.y = 80;
         addChild(numTxt);
      }
      
      public function set myPropVo(param1:PropVO) : void
      {
         _propVo = param1;
         numTxt.text = param1.auctionNum;
         if(image)
         {
            GetpropImage.clean(image);
         }
         image = GetpropImage.getPropSpr(param1,true,_scale);
         addChildAt(image,0);
         decText = new TextField(image.width,25,_txt,"FZCuYuan-M03S",25 * _scale,5584695,true);
         decText.y = image.height - 2;
         decText.autoScale = true;
         addChild(decText);
         this.addEventListener("touch",onclick);
      }
      
      private function onclick(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_ && _loc2_.phase == "began")
         {
            if(_propVo)
            {
               FirstRchRewardTips.getInstance().showPropTips(_propVo,this);
            }
         }
         if(_loc2_ && _loc2_.phase == "ended")
         {
            if(_propVo)
            {
               FirstRchRewardTips.getInstance().removePropTips();
            }
         }
      }
   }
}
