package com.mvc.views.uis.mainCity.scoreShop
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import feathers.controls.Label;
   import lzm.starling.swf.display.SwfScale9Image;
   import starling.display.Image;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import flash.text.TextFormat;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.common.util.xmlVOHandler.GetpropImage;
   
   public class ScoreGoodInfoUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_goodsInfo:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var btn_exChangeBtn:SwfButton;
      
      public var tf_goodsName:TextField;
      
      public var tf_ownNum:TextField;
      
      public var tf_goodsAttribute:Label;
      
      public var tf_goodsDesc:TextField;
      
      public var tf_exchangeNum:TextField;
      
      public var tf_needFightDot:TextField;
      
      public var propContain:SwfSprite;
      
      public var brokenPropContain:SwfSprite;
      
      public var attributeBg:SwfScale9Image;
      
      private var img_pvpScore:Image;
      
      private var img_seriesScore:Image;
      
      private var img_kingScore:Image;
      
      private var img_freeScore:Image;
      
      private var img_diamond:Image;
      
      public var image:Sprite;
      
      private var _propVO:PropVO;
      
      public function ScoreGoodInfoUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.5;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("scoreShop");
         spr_goodsInfo = swf.createSprite("spr_propInfo");
         spr_goodsInfo.x = 1136 - spr_goodsInfo.width >> 1;
         spr_goodsInfo.y = 640 - spr_goodsInfo.height >> 1;
         addChild(spr_goodsInfo);
         tf_goodsName = spr_goodsInfo.getChildByName("tf_propName") as TextField;
         tf_goodsName.autoScale = true;
         tf_ownNum = spr_goodsInfo.getChildByName("tf_ownNum") as TextField;
         tf_exchangeNum = spr_goodsInfo.getChildByName("tf_exchangeNum") as TextField;
         tf_needFightDot = spr_goodsInfo.getChildByName("tf_needFightDot") as TextField;
         tf_needFightDot.fontName = "img_pvpShop";
         tf_goodsDesc = new TextField(366,50,"","FZCuYuan-M03S",24,10064778);
         tf_goodsDesc.x = 25;
         tf_goodsDesc.autoScale = true;
         tf_goodsDesc.vAlign = "top";
         tf_goodsDesc.hAlign = "left";
         spr_goodsInfo.addChild(tf_goodsDesc);
         tf_goodsAttribute = new Label();
         spr_goodsInfo.addChild(tf_goodsAttribute);
         tf_goodsAttribute.width = 366;
         tf_goodsAttribute.x = 25;
         tf_goodsAttribute.y = 220;
         var _loc2_:TextFormat = new TextFormat("FZCuYuan-M03S",24,5911825);
         tf_goodsAttribute.textRendererProperties.textFormat = _loc2_;
         tf_goodsAttribute.textRendererProperties.isHTML = true;
         tf_goodsAttribute.textRendererProperties.wordWrap = true;
         btn_exChangeBtn = spr_goodsInfo.getChildByName("btn_exChangeBtn") as SwfButton;
         btn_close = spr_goodsInfo.getChildByName("btn_close") as SwfButton;
         propContain = spr_goodsInfo.getChildByName("propContain") as SwfSprite;
         brokenPropContain = spr_goodsInfo.getChildByName("brokenPropContain") as SwfSprite;
         attributeBg = spr_goodsInfo.getChildByName("attributeBg") as SwfScale9Image;
         img_pvpScore = spr_goodsInfo.getChildByName("img_pvpScore") as Image;
         img_seriesScore = spr_goodsInfo.getChildByName("img_seriesScore") as Image;
         img_kingScore = spr_goodsInfo.getChildByName("img_kingScore") as Image;
         img_freeScore = spr_goodsInfo.getChildByName("img_freeScore") as Image;
         img_diamond = spr_goodsInfo.getChildByName("img_diamond") as Image;
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
         tf_goodsDesc.text = "";
         tf_ownNum.text = "已拥有" + _propVO.count + "件";
         tf_goodsAttribute.text = _propVO.describe;
         tf_goodsAttribute.validate();
         attributeBg.height = 200;
         tf_goodsDesc.y = attributeBg.y + attributeBg.height + 10;
         tf_goodsDesc.height = tf_exchangeNum.y - tf_goodsDesc.y - 10;
         if(image)
         {
            GetpropImage.clean(image);
         }
         image = GetpropImage.getPropSpr(_propVO);
         image.x = 19;
         image.y = 88;
         spr_goodsInfo.addChild(image);
         propContain.removeFromParent(true);
         brokenPropContain.removeFromParent(true);
      }
      
      public function setNumAndDot(param1:int, param2:int) : void
      {
         if(!propVO)
         {
            return;
         }
         tf_exchangeNum.text = param1;
         tf_needFightDot.text = param1 * param2;
      }
      
      public function showScoreImg(param1:String) : void
      {
         var _loc2_:* = param1;
         if("PVPBgMediator" !== _loc2_)
         {
            if("KingKwanMedia" !== _loc2_)
            {
               if("ElfSeriesMedia" !== _loc2_)
               {
                  if("MainCityMedia" !== _loc2_)
                  {
                     if("ShopMedia" === _loc2_)
                     {
                        img_diamond.visible = true;
                        img_freeScore.visible = false;
                        img_pvpScore.visible = false;
                        img_seriesScore.visible = false;
                        img_kingScore.visible = false;
                     }
                  }
                  else
                  {
                     img_freeScore.visible = true;
                     img_pvpScore.visible = false;
                     img_seriesScore.visible = false;
                     img_kingScore.visible = false;
                     img_diamond.visible = false;
                  }
               }
               else
               {
                  img_seriesScore.visible = true;
                  img_freeScore.visible = false;
                  img_pvpScore.visible = false;
                  img_kingScore.visible = false;
                  img_diamond.visible = false;
               }
            }
            else
            {
               img_kingScore.visible = true;
               img_freeScore.visible = false;
               img_pvpScore.visible = false;
               img_seriesScore.visible = false;
               img_diamond.visible = false;
            }
         }
         else
         {
            img_pvpScore.visible = true;
            img_freeScore.visible = false;
            img_seriesScore.visible = false;
            img_kingScore.visible = false;
            img_diamond.visible = false;
         }
      }
   }
}
