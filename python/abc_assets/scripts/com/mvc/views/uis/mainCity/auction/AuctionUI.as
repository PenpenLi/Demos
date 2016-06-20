package com.mvc.views.uis.mainCity.auction
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.components.feathers.FeathersTextInput;
   import feathers.controls.List;
   import lzm.starling.swf.display.SwfMovieClip;
   import lzm.starling.swf.display.SwfImage;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.models.proxy.mainCity.auction.AuctionPro;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.vos.elf.SkillVO;
   import com.common.util.xmlVOHandler.GetpropImage;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class AuctionUI extends Sprite
   {
      
      public static var isScrolling:Boolean;
       
      private var swf:Swf;
      
      private var spr_bid:SwfSprite;
      
      private var propName:TextField;
      
      private var propDec:TextField;
      
      public var auctionLessTime:TextField;
      
      private var bidTitle:TextField;
      
      private var currentPrice:TextField;
      
      private var playerName:TextField;
      
      public var bidLessTime:TextField;
      
      private var prompt:TextField;
      
      public var btn_close:SwfButton;
      
      public var btn_pid:SwfButton;
      
      public var priceInput:FeathersTextInput;
      
      private var spr_bidProp:SwfSprite;
      
      public var propList:List;
      
      private var image:Sprite;
      
      private var light:SwfMovieClip;
      
      private var dimmon:SwfImage;
      
      private var silver:SwfImage;
      
      private var maxPriceTxt:TextField;
      
      private var playerNameTxt:TextField;
      
      public var _propVo:PropVO;
      
      public function AuctionUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("auction");
         spr_bid = swf.createSprite("spr_bid");
         propName = spr_bid.getTextField("propName");
         propDec = spr_bid.getTextField("propDec");
         auctionLessTime = spr_bid.getTextField("bidLessTime");
         bidTitle = spr_bid.getTextField("bidTitle");
         currentPrice = spr_bid.getTextField("currentPrice");
         playerName = spr_bid.getTextField("playerName");
         playerName.fontName = "1";
         bidLessTime = spr_bid.getTextField("priceLessTime");
         prompt = spr_bid.getTextField("prompt");
         maxPriceTxt = spr_bid.getTextField("maxPriceTxt");
         playerNameTxt = spr_bid.getTextField("playerNameTxt");
         playerNameTxt.fontName = "img_auction0";
         maxPriceTxt.fontName = "img_auction0";
         bidTitle.fontName = "img_auction1";
         bidTitle.text = "";
         prompt.text = "物品竞标时间5分钟，每30秒出价一次，价高者得;";
         btn_close = spr_bid.getButton("btn_close");
         btn_pid = spr_bid.getButton("btn_pid");
         dimmon = spr_bid.getImage("dimmon");
         silver = spr_bid.getImage("silver");
         priceInput = spr_bid.getChildByName("priceInput") as FeathersTextInput;
         spr_bidProp = spr_bid.getSprite("spr_bidProp");
         priceInput.paddingLeft = 50;
         priceInput.paddingTop = 8;
         priceInput.prompt = "点击输入金额";
         priceInput.restrict = "0-9";
         propName.autoScale = true;
         propDec.autoScale = true;
         currentPrice.autoSize = "horizontal";
         addChild(spr_bid);
         addMenu();
      }
      
      private function addMenu() : void
      {
         propList = new List();
         spr_bidProp.addChild(propList);
         propList.width = 160;
         propList.height = 410;
         propList.y = 60;
         propList.x = 18;
         propList.isSelectable = false;
         propList.itemRendererProperties.stateToSkinFunction = null;
         propList.itemRendererProperties.paddingTop = 0;
         propList.itemRendererProperties.paddingBottom = -5;
      }
      
      public function showInfo(param1:Boolean) : void
      {
         if(param1)
         {
            if(AuctionPro.session > 0)
            {
               bidTitle.text = "第" + AuctionPro.session + "轮拍卖";
            }
            if(AuctionPro.maxPrice > 0)
            {
               currentPrice.text = AuctionPro.maxPrice;
            }
            playerName.text = AuctionPro.playerName;
            myPropVo = AuctionPro.auctionPropVec[0];
         }
         else
         {
            clean();
         }
      }
      
      private function set myPropVo(param1:PropVO) : void
      {
         var _loc2_:* = null;
         _propVo = param1;
         propDec.text = param1.describe;
         if(param1.skillId != 0)
         {
            _loc2_ = GetElfFactor.getSkillById(param1.skillId);
            propDec.text = "属性:" + _loc2_.property + "  PP:" + _loc2_.totalPP + "  威力:" + _loc2_.power + "  分类:" + _loc2_.sort + "  命中:";
            if(_loc2_.hitRate > 100)
            {
               propDec.text = propDec.text + "--";
            }
            else
            {
               propDec.text = propDec.text + _loc2_.hitRate;
            }
            propDec.text = propDec.text + ("\n技能描述:" + _loc2_.descs);
         }
         propName.text = param1.name + "×" + param1.auctionNum;
         if(!light)
         {
            LogUtil("添加发光动画");
            light = swf.createMovieClip("mc_light");
            light.x = 295;
            light.y = 260;
            spr_bid.addChildAt(light,spr_bid.numChildren - 3);
         }
         if(image)
         {
            GetpropImage.clean(image);
         }
         image = GetpropImage.getPropSpr(param1);
         image.x = light.x - 50;
         image.y = light.y - 50;
         spr_bid.addChild(image);
         silver.visible = false;
         dimmon.visible = false;
         if(param1.auctionType == 1)
         {
            dimmon.visible = true;
            dimmon.x = currentPrice.x + currentPrice.width + 5;
         }
         if(param1.auctionType == 2)
         {
            silver.visible = true;
            silver.x = currentPrice.x + currentPrice.width + 5;
         }
      }
      
      private function clean() : void
      {
         if(image)
         {
            GetpropImage.clean(image);
         }
         silver.visible = false;
         dimmon.visible = false;
         propDec.text = "";
         propName.text = "";
         if(light)
         {
            light.removeFromParent(true);
         }
         bidTitle.text = "";
         currentPrice.text = "";
         playerName.text = "";
      }
   }
}
