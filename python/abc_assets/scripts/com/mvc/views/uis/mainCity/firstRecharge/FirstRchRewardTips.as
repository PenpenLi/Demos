package com.mvc.views.uis.mainCity.firstRecharge
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfSprite;
   import feathers.display.Scale9Image;
   import starling.text.TextField;
   import lzm.starling.swf.Swf;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import starling.display.DisplayObject;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.vos.elf.SkillVO;
   import com.common.util.xmlVOHandler.GetpropImage;
   import flash.geom.Point;
   import starling.core.Starling;
   import starling.animation.Tween;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class FirstRchRewardTips extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.firstRecharge.FirstRchRewardTips;
       
      public var spr_rewardTips:SwfSprite;
      
      public var tipsBg:Scale9Image;
      
      private var tipsTf:TextField;
      
      private var propNameTf:TextField;
      
      private var propNumTf:TextField;
      
      private var propDescTf:TextField;
      
      private var propImgSpr:SwfSprite;
      
      private var image:Sprite;
      
      private var swf:Swf;
      
      public function FirstRchRewardTips()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         spr_rewardTips = swf.createSprite("spr_rewardTips");
         addChild(spr_rewardTips);
         tipsBg = spr_rewardTips.getChildByName("tipsBg") as Scale9Image;
         propNameTf = spr_rewardTips.getChildByName("propNameTf") as TextField;
         propNameTf.autoScale = true;
         propNumTf = spr_rewardTips.getChildByName("propNumTf") as TextField;
         propDescTf = spr_rewardTips.getChildByName("propDescTf") as TextField;
         propDescTf.autoScale = true;
         propImgSpr = spr_rewardTips.getChildByName("propImgSpr") as SwfSprite;
         propImgSpr.removeFromParent();
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.firstRecharge.FirstRchRewardTips
      {
         return instance || new com.mvc.views.uis.mainCity.firstRecharge.FirstRchRewardTips();
      }
      
      public function showPropTips(param1:PropVO, param2:DisplayObject) : void
      {
         var _loc3_:* = null;
         var _loc5_:* = null;
         _loc3_ = GetPropFactor.getProp(param1.id);
         if(!_loc3_)
         {
            _loc3_ = param1;
         }
         LogUtil(_loc3_.name + "==展示详细提示");
         var _loc4_:String = "可出售";
         if(_loc3_.isSale == 3 || _loc3_.isSale == 4)
         {
            _loc4_ = "不可出售";
         }
         if(param1.rewardCount > 1)
         {
            propNameTf.text = _loc3_.name + "×" + param1.rewardCount;
         }
         else
         {
            propNameTf.text = _loc3_.name;
         }
         propNumTf.text = "（已拥有" + _loc3_.count + "）\n" + _loc4_;
         propDescTf.text = _loc3_.describe;
         if(_loc3_.skillId != 0)
         {
            _loc5_ = GetElfFactor.getSkillById(_loc3_.skillId);
            if(_loc5_.power == "1")
            {
               _loc5_.power = "0";
            }
            propDescTf.text = "属性:" + _loc5_.property + " PP:" + _loc5_.totalPP + " 威力:" + _loc5_.power + " 分类:" + _loc5_.sort + " 命中:";
            if(_loc5_.hitRate > 100)
            {
               propDescTf.text = propDescTf.text + "--";
            }
            else
            {
               propDescTf.text = propDescTf.text + _loc5_.hitRate;
            }
            propDescTf.text = propDescTf.text + ("\n技能描述: " + _loc5_.descs);
         }
         image = GetpropImage.getPropSpr(_loc3_,true,0.625);
         image.x = 13;
         image.y = 10;
         addChild(image);
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
         _loc3_ = null;
         (Starling.current.root as Game).addChild(this);
         this.alpha = 0;
         Starling.juggler.removeTweens(this);
         var _loc6_:Tween = new Tween(this,0.2);
         Starling.juggler.add(_loc6_);
         _loc6_.fadeTo(1);
      }
      
      public function showTips(param1:String, param2:DisplayObject) : void
      {
         if(tipsTf)
         {
            return;
            §§push(LogUtil(tipsTf + "按下看看有没有为null"));
         }
         else
         {
            tipsTf = new TextField(50,50,"");
            addChild(tipsTf);
            tipsTf.text = param1;
            setTipTf();
            var _loc4_:* = (tipsTf.text.length + 1) * tipsTf.fontSize;
            tipsTf.width = _loc4_;
            tipsBg.width = _loc4_;
            _loc4_ = tipsTf.fontSize + 20;
            tipsTf.height = _loc4_;
            tipsBg.height = _loc4_;
            this.x = param2.localToGlobal(new Point(0,0)).x;
            this.y = param2.localToGlobal(new Point(0,0)).y - this.height;
            if(this.x + tipsBg.width > 1136)
            {
               this.x = this.x - (this.x + tipsBg.width - 1136);
            }
            (Starling.current.root as Game).addChild(this);
            this.alpha = 0;
            var _loc3_:Tween = new Tween(this,0.2);
            Starling.juggler.add(_loc3_);
            _loc3_.fadeTo(1);
            return;
         }
      }
      
      public function setTipTf(param1:int = 24, param2:uint = 9713664, param3:String = "FZCuYuan-M03S") : void
      {
         tipsTf.fontSize = param1;
         tipsTf.color = param2;
         tipsTf.fontName = param3;
      }
      
      public function removePropTips() : void
      {
         var _loc1_:* = null;
         if(getInstance().parent)
         {
            if(image)
            {
               image.removeFromParent(true);
               image = null;
            }
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
      
      public function removeTips() : void
      {
         var _loc1_:Tween = new Tween(this,0.2);
         Starling.juggler.add(_loc1_);
         _loc1_.fadeTo(0);
         _loc1_.onComplete = onCompleteFun;
      }
      
      private function onCompleteFun() : void
      {
         if(!tipsTf)
         {
            return;
            §§push(LogUtil(tipsTf + "松开看看有没有为null"));
         }
         else
         {
            tipsTf.removeFromParent();
            tipsTf = null;
            this.removeFromParent();
            return;
         }
      }
   }
}
