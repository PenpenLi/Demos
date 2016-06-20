package com.mvc.views.uis.mainCity.scoreShop
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfSprite;
   import starling.display.Image;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import lzm.starling.swf.Swf;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.common.util.xmlVOHandler.GetpropImage;
   import com.mvc.views.mediator.mainCity.scoreShop.ScoreShopMediator;
   
   public class FreeShopGoodsBtn extends Sprite
   {
       
      public var btn_freePropUnit:SwfButton;
      
      public var tf_goodsName:TextField;
      
      public var tf_needFightDot:TextField;
      
      public var tf_goodsNum:TextField;
      
      public var propContain:SwfSprite;
      
      public var brokenPropContain:SwfSprite;
      
      private var img_point:Image;
      
      public var image:Sprite;
      
      private var _propVO:PropVO;
      
      private var swf:Swf;
      
      public function FreeShopGoodsBtn()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("scoreShop");
         btn_freePropUnit = swf.createButton("btn_freePropUnit");
         addChild(btn_freePropUnit);
         tf_goodsName = (btn_freePropUnit.skin as Sprite).getChildByName("tf_propName") as TextField;
         tf_goodsName.autoScale = true;
         tf_needFightDot = (btn_freePropUnit.skin as Sprite).getChildByName("tf_needFightDot") as TextField;
         tf_needFightDot.fontName = "img_pvpShop";
         tf_goodsNum = (btn_freePropUnit.skin as Sprite).getChildByName("tf_propNum") as TextField;
         tf_goodsNum.fontName = "img_pvpShop";
         propContain = (btn_freePropUnit.skin as Sprite).getChildByName("propContain") as SwfSprite;
         brokenPropContain = (btn_freePropUnit.skin as Sprite).getChildByName("brokenPropContain") as SwfSprite;
         img_point = (btn_freePropUnit.skin as Sprite).getChildByName("img_point") as Image;
      }
      
      public function get propVO() : PropVO
      {
         return _propVO;
      }
      
      public function set propVO(param1:PropVO) : void
      {
         _propVO = GetPropFactor.getProp(param1.id);
         if(!_propVO)
         {
            _propVO = param1;
         }
         tf_goodsName.text = _propVO.name;
         image = GetpropImage.getPropSpr(_propVO);
         image.x = propContain.width - image.width >> 1;
         image.y = propContain.height - image.height >> 1;
         if(_propVO.composeMoney)
         {
            brokenPropContain.addChildAt(image,1);
            propContain.removeFromParent(true);
         }
         else
         {
            propContain.addChild(image);
            brokenPropContain.removeFromParent(true);
         }
      }
      
      public function setNumAndDot(param1:int, param2:int, param3:int) : void
      {
         if(!propVO)
         {
            return;
         }
         if(param1 == 1)
         {
            tf_goodsNum.text = "";
            img_point.visible = false;
         }
         else
         {
            tf_goodsNum.text = param1;
            img_point.visible = true;
         }
         if(ScoreShopMediator.disCountActTime > 0)
         {
            tf_needFightDot.text = param1 * param3 + "(" + param1 * param2 + ")";
         }
         else
         {
            tf_needFightDot.text = param1 * param2;
         }
      }
      
      public function addMask() : void
      {
         var _loc1_:SwfSprite = swf.createSprite("spr_freeEvenBuy");
         this.addChild(_loc1_);
      }
   }
}
