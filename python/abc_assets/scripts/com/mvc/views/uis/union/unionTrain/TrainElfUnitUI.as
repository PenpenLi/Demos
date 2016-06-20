package com.mvc.views.uis.union.unionTrain
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import starling.display.Image;
   import lzm.starling.swf.display.SwfImage;
   import com.mvc.models.vos.mainCity.train.TrainVO;
   import com.mvc.models.vos.elf.ElfVO;
   import flash.geom.Rectangle;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.views.mediator.union.unionTrain.OtherTrainMedia;
   import com.common.themes.Tips;
   import com.common.events.EventCenter;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.union.UnionPro;
   import starling.events.Event;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   import com.mvc.views.mediator.fighting.AniFactor;
   import com.common.managers.ELFMinImageManager;
   import starling.animation.Tween;
   import starling.core.Starling;
   import extend.SoundEvent;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class TrainElfUnitUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_elfUnit:SwfSprite;
      
      private var elfName:TextField;
      
      private var elfLv:TextField;
      
      private var spr_exp:SwfSprite;
      
      private var nowExp:TextField;
      
      private var exp:SwfSprite;
      
      private var elfImage:Image;
      
      private var image:SwfImage;
      
      private var _trainVo:TrainVO;
      
      private var elfVo:ElfVO;
      
      private var upExp:int;
      
      private var rect:Rectangle;
      
      private var tempLv:int;
      
      private var lvDiff:int;
      
      private var totalExp:TextField;
      
      private var expWidth:Number;
      
      private var isUpgrade:Boolean;
      
      public function TrainElfUnitUI()
      {
         rect = new Rectangle(0,0,0,0);
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("unionTrain");
         spr_elfUnit = swf.createSprite("spr_elfUnit");
         elfName = spr_elfUnit.getTextField("elfName");
         elfLv = spr_elfUnit.getTextField("elfLv");
         spr_exp = spr_elfUnit.getSprite("spr_exp");
         nowExp = spr_exp.getTextField("nowExp");
         totalExp = spr_exp.getTextField("totalExp");
         exp = spr_exp.getSprite("exp");
         expWidth = exp.width;
         addChild(spr_elfUnit);
      }
      
      public function set myTrainVo(param1:TrainVO) : void
      {
         _trainVo = param1;
         elfVo = _trainVo.elfVo;
         showBg();
         showTxt();
         showExp();
         this.addEventListener("touch",ontouch);
      }
      
      private function ontouch(param1:TouchEvent) : void
      {
         if(OtherTrainUI.isScrolling)
         {
            return;
         }
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            if(OtherTrainMedia.isAddExp)
            {
               return Tips.show("亲，您已经帮她加过经验咯, 明天再来吧");
            }
            if(_trainVo.isFull)
            {
               return Tips.show("该精灵的经验已到达最大值");
            }
            EventCenter.addEventListener("GIVE_OTHERELF_SUCCESS",addOtherElfExp);
            (Facade.getInstance().retrieveProxy("UnionPro") as UnionPro).write3420(OtherTrainMedia.userId,_trainVo.traGrdId);
         }
      }
      
      private function addOtherElfExp(param1:Event) : void
      {
         EventCenter.removeEventListener("GIVE_OTHERELF_SUCCESS",addOtherElfExp);
         upExp = param1.data.exp;
         expUpAni();
         elfVo.currentExp = elfVo.currentExp + upExp;
         var _loc3_:Number = CalculatorFactor.calculatorLvNeedExp(elfVo,_trainVo.maxLv + 1) - 1;
         LogUtil("maxExp ================ ",upExp,_loc3_,_trainVo.maxLv);
         if(elfVo.currentExp > _loc3_)
         {
            elfVo.currentExp = _loc3_;
            _trainVo.isFull = true;
         }
         tempLv = elfVo.lv;
         CalculatorFactor.calculatorElfLv(elfVo,_trainVo.maxLv);
         lvDiff = elfVo.lv - tempLv;
         LogUtil(elfVo.lv,"升了多少级===================",lvDiff);
         var _loc4_:Number = CalculatorFactor.calculatorLvNeedExp(elfVo,elfVo.lv);
         elfVo.nextLvExp = CalculatorFactor.calculatorLvNeedExp(elfVo,elfVo.lv + 1);
         totalExp.text = "/" + Math.round(elfVo.nextLvExp - _loc4_);
         var _loc2_:Number = (elfVo.currentExp - _loc4_) / (elfVo.nextLvExp - _loc4_);
         if(lvDiff > 0)
         {
            isUpgrade = true;
            expAni(_loc2_,expWidth,rect.width);
         }
         else
         {
            expAni(_loc2_,expWidth * _loc2_,rect.width);
         }
         AniFactor.numTfAni(nowExp,elfVo.currentExp - _loc4_);
      }
      
      private function showTxt() : void
      {
         elfName.text = elfVo.nickName;
         if(_trainVo.isFull)
         {
            elfLv.text = "Lv." + elfVo.lv + "   经验已满";
         }
         else
         {
            elfLv.text = "Lv." + elfVo.lv + "   训练中…";
         }
      }
      
      private function showExp() : void
      {
         elfImage = ELFMinImageManager.getElfM(elfVo.imgName);
         elfImage.x = 20;
         elfImage.y = 30;
         addChild(elfImage);
         var _loc2_:Number = CalculatorFactor.calculatorLvNeedExp(elfVo,elfVo.lv);
         elfVo.nextLvExp = CalculatorFactor.calculatorLvNeedExp(elfVo,elfVo.lv + 1);
         nowExp.text = Math.round(elfVo.currentExp - _loc2_);
         totalExp.text = "/" + Math.round(elfVo.nextLvExp - _loc2_);
         var _loc1_:Number = (elfVo.currentExp - _loc2_) / (elfVo.nextLvExp - _loc2_);
         rect = new Rectangle(0,0,exp.width * _loc1_,exp.height);
         exp.clipRect = rect;
      }
      
      private function showBg() : void
      {
         switch(_trainVo.status)
         {
            case 0:
            case 1:
               image = swf.createImage("img_white");
               break;
            case 2:
               image = swf.createImage("img_green");
               break;
            case 3:
               image = swf.createImage("img_blue");
               break;
            case 4:
               image = swf.createImage("img_purple");
               break;
            case 5:
               image = swf.createImage("img_orange");
               break;
         }
         if(image)
         {
            addQuickChildAt(image,0);
         }
      }
      
      private function expUpAni() : void
      {
         var expText:TextField = new TextField(280,30,"经验 +" + upExp,"FZCuYuan-M03S",30,65280,true);
         expText.y = 50;
         addQuickChild(expText);
         var t:Tween = new Tween(expText,1.5);
         Starling.juggler.add(t);
         t.animate("y",expText.y - 75,expText.y);
         t.onComplete = function():void
         {
            var t2:Tween = new Tween(expText,0.5);
            Starling.juggler.add(t2);
            t2.animate("y",expText.y - 25,expText.y);
            t2.animate("alpha",0);
            t2.onComplete = function():void
            {
               expText.removeFromParent(true);
               expText = null;
            };
         };
      }
      
      private function expAni(param1:Number, param2:Number, param3:Number) : void
      {
         scale = param1;
         finalWidth = param2;
         beforeWidth = param3;
         Starling.juggler.removeTweens(rect);
         var t:Tween = new Tween(rect,(finalWidth - beforeWidth) * 0.8 / 130);
         Starling.juggler.add(t);
         t.animate("width",finalWidth,beforeWidth);
         t.onUpdate = upAni;
         t.onUpdateArgs = [t,finalWidth,beforeWidth];
         if(isUpgrade && lvDiff > 0)
         {
            lvDiff = lvDiff - 1;
            tempLv = tempLv + 1;
            elfLv.text = "Lv." + tempLv + "  训练中…";
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","upgrade");
         }
         t.onComplete = function():void
         {
            if(lvDiff > 0)
            {
               expAni(scale,expWidth,0);
            }
            if(_trainVo.isFull && lvDiff == 0 && !isUpgrade)
            {
               elfLv.text = "Lv." + elfVo.lv + "  经验已满";
               Tips.show("经验已达到玩家现等级的最大值");
            }
            if(lvDiff == 0 && isUpgrade)
            {
               isUpgrade = false;
               expAni(scale,expWidth * scale,0);
            }
         };
      }
      
      private function upAni(param1:Tween, param2:Number, param3:Number) : void
      {
         exp.clipRect = null;
         rect.width = param3 + (param2 - param3) * param1.progress;
         exp.clipRect = rect;
      }
   }
}
