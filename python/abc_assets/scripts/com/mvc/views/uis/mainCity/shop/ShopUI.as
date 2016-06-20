package com.mvc.views.uis.mainCity.shop
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import feathers.controls.TabBar;
   import feathers.controls.List;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.components.feathers.FeathersButton;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfMovieClip;
   import com.common.managers.LoadSwfAssetsManager;
   import feathers.data.ListCollection;
   import lzm.starling.swf.display.SwfImage;
   import starling.animation.Tween;
   import starling.core.Starling;
   
   public class ShopUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var tabs:TabBar;
      
      public var buyGoodsList:List;
      
      public var sellGoodsList:List;
      
      public var spr_shopBg:SwfSprite;
      
      public var spr_goodBg:SwfSprite;
      
      public var btn_shopBuy:FeathersButton;
      
      public var btn_mainClose:SwfButton;
      
      public var btn_shopSell:FeathersButton;
      
      public var prompt:TextField;
      
      public var mc_clerk:SwfMovieClip;
      
      private var swfLoading:Swf;
      
      private var mc_bottomArrow:SwfMovieClip;
      
      public function ShopUI()
      {
         super();
         init();
         initBuyGoodsList();
         initSellGoodsList();
         spr_shopBg.addChild(mc_bottomArrow);
         swtich(true);
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("shop");
         swfLoading = LoadSwfAssetsManager.getInstance().assets.getSwf("loading");
         spr_shopBg = swf.createSprite("spr_shopBg_s");
         spr_goodBg = spr_shopBg.getSprite("spr_goodBg");
         btn_shopBuy = spr_shopBg.getChildByName("btn_shopBuy") as FeathersButton;
         btn_shopSell = spr_shopBg.getChildByName("btn_shopSell") as FeathersButton;
         btn_mainClose = spr_shopBg.getButton("btn_mainClose");
         prompt = spr_shopBg.getTextField("prompt");
         mc_clerk = swfLoading.createMovieClip("mc_shopZui");
         mc_clerk.x = 101;
         mc_clerk.y = 331;
         mc_clerk.stop();
         spr_shopBg.addChild(mc_clerk);
         prompt.hAlign = "left";
         mc_bottomArrow = swf.createMovieClip("mc_bottomArrow");
         mc_bottomArrow.x = 710;
         mc_bottomArrow.y = 590;
         addChild(spr_shopBg);
      }
      
      private function initBuyGoodsList() : void
      {
         tabs = new TabBar();
         tabs.dataProvider = new ListCollection([{"label":"药品"},{"label":"精灵球"},{"label":"其他物品"},{"label":"钻石购买"}]);
         tabs.x = 30;
         tabs.y = 70;
         spr_goodBg.addChild(tabs);
         buyGoodsList = new List();
         buyGoodsList.width = 720;
         buyGoodsList.height = 370;
         buyGoodsList.x = 30;
         buyGoodsList.y = 140;
         buyGoodsList.isSelectable = false;
         spr_goodBg.addChild(buyGoodsList);
      }
      
      private function initSellGoodsList() : void
      {
         sellGoodsList = new List();
         sellGoodsList.width = 720;
         sellGoodsList.height = 420;
         sellGoodsList.x = 30;
         sellGoodsList.y = 70;
         sellGoodsList.isSelectable = false;
         spr_goodBg.addChild(sellGoodsList);
      }
      
      public function swtich(param1:Boolean) : void
      {
         tabs.visible = param1;
         buyGoodsList.visible = param1;
         sellGoodsList.visible = !param1;
         if(param1)
         {
            prompt.text = "你好，需要买些什么不？";
         }
         else
         {
            prompt.text = "你好，想要卖些什么呢？";
         }
         textPlayAni();
      }
      
      public function getBtn(param1:String) : SwfButton
      {
         return swf.createButton(param1);
      }
      
      public function getImg(param1:String) : SwfImage
      {
         return swf.createImage(param1);
      }
      
      private function textPlayAni() : void
      {
         Starling.juggler.removeTweens(prompt);
         var t:Tween = new Tween(prompt,prompt.text.length / 15);
         Starling.juggler.add(t);
         mc_clerk.gotoAndPlay(0);
         t.onUpdate = playTextAni;
         t.onUpdateArgs = [prompt.text,t,prompt];
         t.onComplete = function():void
         {
            mc_clerk.gotoAndStop(0);
         };
      }
      
      private function playTextAni(param1:String, param2:Tween, param3:TextField) : void
      {
         var _loc4_:int = param1.length * param2.progress;
         param3.text = param1.substr(0,_loc4_);
      }
   }
}
