package com.mvc.views.uis.mapSelect
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfSprite;
   import feathers.display.Scale9Image;
   import starling.text.TextField;
   import lzm.starling.swf.Swf;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.DisplayObject;
   import com.mvc.models.proxy.Illustrations.IllustrationsPro;
   import flash.geom.Point;
   import starling.core.Starling;
   import starling.animation.Tween;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class ExtendElfUnitTips extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mapSelect.ExtendElfUnitTips;
       
      public var spr_extendElfTips:SwfSprite;
      
      public var tipsBg:Scale9Image;
      
      private var elfNameTf:TextField;
      
      private var markTf:TextField;
      
      private var natureTf:TextField;
      
      private var rareTf:TextField;
      
      private var elfDescTf:TextField;
      
      private var swf:Swf;
      
      public function ExtendElfUnitTips()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         spr_extendElfTips = swf.createSprite("spr_extendElfTips");
         addChild(spr_extendElfTips);
         tipsBg = spr_extendElfTips.getChildByName("tipsBg") as Scale9Image;
         elfNameTf = spr_extendElfTips.getChildByName("elfNameTf") as TextField;
         markTf = spr_extendElfTips.getChildByName("markTf") as TextField;
         natureTf = spr_extendElfTips.getChildByName("natureTf") as TextField;
         rareTf = spr_extendElfTips.getChildByName("rareTf") as TextField;
         elfDescTf = spr_extendElfTips.getChildByName("elfDescTf") as TextField;
         elfDescTf.autoScale = true;
         markTf.text = "尚未遇见";
      }
      
      public static function getInstance() : com.mvc.views.uis.mapSelect.ExtendElfUnitTips
      {
         return instance || new com.mvc.views.uis.mapSelect.ExtendElfUnitTips();
      }
      
      public function showElfTips(param1:ElfVO, param2:DisplayObject) : void
      {
         elfNameTf.text = param1.name;
         elfDescTf.text = param1.descr;
         rareTf.text = param1.rare;
         if(param1.nature.length > 1)
         {
            natureTf.text = param1.nature[0] + " | " + param1.nature[1];
         }
         else
         {
            natureTf.text = param1.nature[0];
         }
         var _loc3_:int = param1.elfId - 1;
         if(IllustrationsPro.markStr[_loc3_] == 0)
         {
            markTf.text = "尚未遇见";
         }
         if(IllustrationsPro.markStr[_loc3_] == 1)
         {
            markTf.text = "遇见过";
         }
         if(IllustrationsPro.markStr[_loc3_] == 2)
         {
            markTf.text = "拥有或拥有过";
         }
         if(param1.elfId > 10000)
         {
            markTf.text = "";
         }
         if(rareTf.text == "常见")
         {
            elfNameTf.color = 9790750;
         }
         if(rareTf.text == "较稀有")
         {
            elfNameTf.color = 2985257;
         }
         if(rareTf.text == "稀有")
         {
            elfNameTf.color = 2393740;
         }
         if(rareTf.text == "史诗")
         {
            elfNameTf.color = 6900641;
         }
         if(rareTf.text == "传说")
         {
            elfNameTf.color = 11483904;
         }
         this.x = param2.localToGlobal(new Point(0,0)).x / Config.scaleX + (param2.width - this.width >> 1);
         this.y = param2.localToGlobal(new Point(0,0)).y / Config.scaleY - this.height;
         if(this.x + tipsBg.width > 1136)
         {
            this.x = this.x - (this.x + tipsBg.width - 1136);
         }
         if(this.x < 0)
         {
            this.x = 0;
         }
         if(this.y < 0)
         {
            this.y = 0;
         }
         (Starling.current.root as Game).addChild(this);
         this.alpha = 0;
         Starling.juggler.removeTweens(this);
         var _loc4_:Tween = new Tween(this,0.2);
         Starling.juggler.add(_loc4_);
         _loc4_.fadeTo(1);
      }
      
      public function removeElfTips() : void
      {
         var _loc1_:* = null;
         if(getInstance().parent)
         {
            _loc1_ = new Tween(this,0.2);
            Starling.juggler.add(_loc1_);
            _loc1_.fadeTo(0);
            _loc1_.onComplete = onPropTipsCompleteFun;
         }
      }
      
      private function onPropTipsCompleteFun() : void
      {
         this.removeFromParent(true);
         instance = null;
      }
   }
}
