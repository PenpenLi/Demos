package com.mvc.views.uis.mainCity.shop
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.views.mediator.mainCity.shop.BuySureMedia;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.display.Quad;
   
   public class BuySureUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_sureBg:SwfSprite;
      
      public var btn_min:SwfButton;
      
      public var btn_sub:SwfButton;
      
      public var btn_add:SwfButton;
      
      public var btn_max:SwfButton;
      
      public var btn_ok:SwfButton;
      
      public var btn_sureClose:SwfButton;
      
      public var prompt:TextField;
      
      public var moneyPrompt:TextField;
      
      public var sum:TextField;
      
      private var _propVO:PropVO;
      
      public function BuySureUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
      }
      
      public function set myPropVo(param1:PropVO) : void
      {
         _propVO = param1;
         sum.text = "1";
         switch(BuySureMedia.type - 1)
         {
            case 0:
               prompt.text = "购买【" + param1.name + "】的数量：";
               moneyPrompt.text = "花费金币：" + param1.price;
               break;
            case 1:
               prompt.text = "兑换【" + param1.name + "】的数量：";
               moneyPrompt.text = "花费钻石：" + param1.diamond;
               break;
            case 2:
               prompt.text = "出售【" + param1.name + "】的数量：";
               moneyPrompt.text = "获取金币：" + param1.price * 0.5;
               break;
         }
      }
      
      public function get myPropVo() : PropVO
      {
         return _propVO;
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("shop");
         spr_sureBg = swf.createSprite("spr_sureBg_s");
         btn_min = spr_sureBg.getButton("btn_min");
         btn_sub = spr_sureBg.getButton("btn_sub");
         btn_add = spr_sureBg.getButton("btn_add");
         btn_max = spr_sureBg.getButton("btn_max");
         btn_ok = spr_sureBg.getButton("btn_ok");
         btn_sureClose = spr_sureBg.getButton("btn_sureClose");
         prompt = spr_sureBg.getTextField("prompt");
         moneyPrompt = spr_sureBg.getTextField("moneyPrompt");
         sum = spr_sureBg.getTextField("sum");
         spr_sureBg.x = 1136 - spr_sureBg.width >> 1;
         spr_sureBg.y = 640 - spr_sureBg.height >> 1;
         addChild(spr_sureBg);
      }
   }
}
