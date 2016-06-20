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
   
   public class ScoreShopGoodsBtnUI extends Sprite
   {
       
      public var btn_propUnit:SwfButton;
      
      public var tf_goodsName:TextField;
      
      public var tf_needFightDot:TextField;
      
      public var tf_goodsNum:TextField;
      
      public var propContain:SwfSprite;
      
      public var brokenPropContain:SwfSprite;
      
      private var img_point:Image;
      
      private var img_pvpScore:Image;
      
      private var img_seriesScore:Image;
      
      private var img_kingScore:Image;
      
      private var img_diamond:Image;
      
      public var image:Sprite;
      
      private var shopType:String;
      
      private var _propVO:PropVO;
      
      private var swf:Swf;
      
      public function ScoreShopGoodsBtnUI(param1:String)
      {
         super();
         this.shopType = param1;
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("scoreShop");
         btn_propUnit = swf.createButton("btn_propUnit");
         addChild(btn_propUnit);
         tf_goodsName = (btn_propUnit.skin as Sprite).getChildByName("tf_propName") as TextField;
         tf_goodsName.autoScale = true;
         tf_needFightDot = (btn_propUnit.skin as Sprite).getChildByName("tf_needFightDot") as TextField;
         tf_needFightDot.fontName = "img_pvpShop";
         tf_goodsNum = (btn_propUnit.skin as Sprite).getChildByName("tf_propNum") as TextField;
         tf_goodsNum.fontName = "img_pvpShop";
         propContain = (btn_propUnit.skin as Sprite).getChildByName("propContain") as SwfSprite;
         brokenPropContain = (btn_propUnit.skin as Sprite).getChildByName("brokenPropContain") as SwfSprite;
         img_point = (btn_propUnit.skin as Sprite).getChildByName("img_point") as Image;
         img_pvpScore = (btn_propUnit.skin as Sprite).getChildByName("img_pvpScore") as Image;
         img_seriesScore = (btn_propUnit.skin as Sprite).getChildByName("img_seriesScore") as Image;
         img_kingScore = (btn_propUnit.skin as Sprite).getChildByName("img_kingScore") as Image;
         img_diamond = (btn_propUnit.skin as Sprite).getChildByName("img_diamond") as Image;
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
         image.x = 87;
         image.y = 34;
         (btn_propUnit.skin as Sprite).addChild(image);
         brokenPropContain.removeFromParent(true);
         propContain.removeFromParent(true);
         showScoreImg();
      }
      
      private function showScoreImg() : void
      {
         var _loc1_:* = shopType;
         if("PVPBgMediator" !== _loc1_)
         {
            if("KingKwanMedia" !== _loc1_)
            {
               if("ElfSeriesMedia" !== _loc1_)
               {
                  if("ShopMedia" === _loc1_)
                  {
                     img_diamond.visible = true;
                     img_pvpScore.visible = false;
                     img_seriesScore.visible = false;
                     img_kingScore.visible = false;
                  }
               }
               else
               {
                  img_seriesScore.visible = true;
                  img_pvpScore.visible = false;
                  img_kingScore.visible = false;
                  img_diamond.visible = false;
               }
            }
            else
            {
               img_kingScore.visible = true;
               img_seriesScore.visible = false;
               img_pvpScore.visible = false;
               img_diamond.visible = false;
            }
         }
         else
         {
            img_pvpScore.visible = true;
            img_seriesScore.visible = false;
            img_kingScore.visible = false;
            img_diamond.visible = false;
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
         var _loc1_:SwfSprite = swf.createSprite("spr_evenBuy");
         this.addChild(_loc1_);
      }
   }
}
