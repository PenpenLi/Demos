package com.mvc.views.mediator.fighting
{
   import starling.display.DisplayObject;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.text.TextField;
   import com.mvc.GameFacade;
   import com.common.util.dialogue.Dialogue;
   import starling.display.Image;
   
   public class AniFactor
   {
      
      public static var ifOpen:Boolean;
      
      public static var _scale:Number;
      
      public static var _time:Number;
       
      public function AniFactor()
      {
         super();
      }
      
      public static function useSkillForOtherAni(param1:DisplayObject, param2:int) : void
      {
         target = param1;
         rang = param2;
         var targetX:int = target.x;
         var targetY:int = target.y;
         var t:Tween = new Tween(target,0.1,"easeOut");
         Starling.juggler.add(t);
         t.animate("x",targetX + rang);
         t.animate("y",targetY - rang);
         var t2:Tween = new Tween(target,0.1,"easeOut");
         t2.animate("x",targetX);
         t2.animate("y",targetY);
         t.nextTween = t2;
         t2.onComplete = function():void
         {
            target.dispatchEventWith("end_attack_ani");
         };
      }
      
      public static function useSkillForSelfAni(param1:DisplayObject, param2:Boolean = false) : void
      {
         target = param1;
         isKillSelf = param2;
         var rang:int = 30;
         if(!isKillSelf)
         {
            var targetY:int = target.y;
            var t:Tween = new Tween(target,0.5,"easeOut");
            Starling.juggler.add(t);
            t.animate("y",targetY - rang);
            var t2:Tween = new Tween(target,0.5,"easeOut");
            t2.animate("y",targetY);
            t.nextTween = t2;
         }
         else
         {
            var targetX:int = target.x;
            t = new Tween(target,0.1,"easeOut");
            Starling.juggler.add(t);
            t.animate("x",targetX - rang);
            t2 = new Tween(target,0.1,"easeOut");
            t2.animate("x",targetX);
            t.nextTween = t2;
         }
         t2.onComplete = function():void
         {
            target.dispatchEventWith("end_help_skill_ani");
         };
      }
      
      public static function scaleMinAni(param1:DisplayObject) : void
      {
         target = param1;
         var t:Tween = new Tween(target,0.7,"easeOutBounce");
         Starling.juggler.add(t);
         t.animate("scaleX",0.4);
         t.animate("scaleY",0.4);
         var t2:Tween = new Tween(target,0.3,"easeOut");
         t2.animate("scaleX",1);
         t2.animate("scaleY",1);
         t.nextTween = t2;
         t2.onComplete = function():void
         {
            target.dispatchEventWith("end_help_skill_ani");
         };
      }
      
      public static function ScaleMaxAni(param1:DisplayObject, param2:Number = 0.2) : void
      {
         var _loc3_:Tween = new Tween(param1,param2,"easeInBack");
         Starling.juggler.add(_loc3_);
         _loc3_.animate("scaleX",1,1.2);
         _loc3_.animate("scaleY",1,1.2);
      }
      
      public static function elfAni(param1:DisplayObject, param2:Number = 0.95, param3:* = 1.8) : void
      {
         target = param1;
         scale = param2;
         time = param3;
         _scale = scale;
         _time = time;
         var t:Tween = new Tween(target,_time);
         Starling.juggler.add(t);
         t.animate("scaleX",target.scaleX * _scale,target.scaleX);
         t.animate("scaleY",target.scaleY * _scale,target.scaleY);
         t.onComplete = function():void
         {
            var t2:Tween = new Tween(target,_time);
            Starling.juggler.add(t2);
            t2.animate("scaleX",target.scaleX / _scale,target.scaleX);
            t2.animate("scaleY",target.scaleY / _scale,target.scaleY);
            t2.onComplete = function():void
            {
               if(ifOpen)
               {
                  elfAni(target,_scale,_time);
               }
            };
         };
      }
      
      public static function textPlayAni(param1:TextField) : void
      {
         Starling.juggler.removeTweens(param1);
         var _loc2_:Tween = new Tween(param1,param1.text.length / 15);
         Starling.juggler.add(_loc2_);
         _loc2_.onUpdate = playTextAni;
         _loc2_.onUpdateArgs = [param1.text,_loc2_,param1];
      }
      
      private static function playTextAni(param1:String, param2:Tween, param3:TextField) : void
      {
         var _loc4_:int = param1.length * param2.progress;
         param3.text = param1.substr(0,_loc4_);
      }
      
      public static function beAttackAni(param1:DisplayObject, param2:int = 3) : void
      {
         param2--;
         var _loc3_:Tween = new Tween(param1,0.1,"easeOut");
         Starling.juggler.add(_loc3_);
         _loc3_.animate("alpha",0);
         var _loc4_:Tween = new Tween(param1,0.1,"easeOut");
         _loc4_.animate("alpha",1);
         _loc3_.nextTween = _loc4_;
         if(param2 == 0)
         {
            param1.dispatchEventWith("end_hurt_ani");
            return;
         }
         _loc4_.onComplete = beAttackAni;
         _loc4_.onCompleteArgs = [param1,param2];
      }
      
      public static function beAttacking2(param1:DisplayObject, param2:int, param3:Number = 0.7, param4:Number = 0.2) : void
      {
         var _loc5_:Tween = new Tween(param1,0.2,"linear");
         Starling.juggler.add(_loc5_);
         _loc5_.animate("scaleY",1,param3);
         _loc5_.repeatCount = param2;
         _loc5_.delay = param4;
      }
      
      public static function beAttacking3(param1:DisplayObject, param2:int, param3:Number = 1.15) : void
      {
         var _loc4_:Tween = new Tween(param1,0.3,"linear");
         Starling.juggler.add(_loc4_);
         _loc4_.animate("scaleX",1,param3);
         _loc4_.repeatCount = param2;
         _loc4_.delay = 0.3;
      }
      
      public static function beAttacking4(param1:DisplayObject, param2:int, param3:int = 30) : void
      {
         target = param1;
         num = param2;
         moveD = param3;
         if(num == 0)
         {
            return;
         }
         num = num - 1;
         var _x:int = target.x;
         var _y:int = target.y;
         var t:Tween = new Tween(target,0.1,"linear");
         Starling.juggler.add(t);
         t.animate("x",_x - moveD,_x);
         t.animate("y",_y + moveD / 3,_y);
         var t2:Tween = new Tween(target,0.1,"linear");
         t2.animate("x",_x - moveD * 2,_x - moveD);
         t2.animate("y",_y,_y + moveD / 3);
         t.nextTween = t2;
         t2.onComplete = function():void
         {
            beAttacking4(target,num,-moveD);
         };
      }
      
      public static function beAttacking1(param1:DisplayObject, param2:int, param3:Number) : void
      {
         target = param1;
         num = param2;
         delay = param3;
         var _x:int = target.x;
         var _y:int = target.y;
         var t:Tween = new Tween(target,0.1,"linear");
         Starling.juggler.add(t);
         t.animate("x",_x - 3,_x + 3);
         t.animate("y",_y - 3,_y + 3);
         t.repeatCount = num;
         t.delay = delay;
         t.onComplete = function():void
         {
            target.x = _x;
            target.y = _y;
         };
      }
      
      public static function shareScreen(param1:Function) : void
      {
         callBack = param1;
         Config.starling.root.pivotX = 1136 >> 1;
         Config.starling.root.pivotY = 640 >> 1;
         Config.starling.root.x = 1136 >> 1;
         Config.starling.root.y = 640 >> 1;
         var t3:Tween = new Tween(Config.starling.root,0.15,"easeIn");
         Starling.juggler.add(t3);
         t3.animate("scaleX",0.98,1.02);
         t3.animate("scaleY",0.98,1.02);
         t3.onComplete = function():void
         {
            if(callBack != null)
            {
               callBack();
            }
            Config.starling.root.x = 0;
            Config.starling.root.y = 0;
            Config.starling.root.pivotX = 0;
            Config.starling.root.pivotY = 0;
            Config.starling.root.scaleX = 1;
            Config.starling.root.scaleY = 1;
         };
      }
      
      public static function shareScreen2(param1:int) : void
      {
         num = param1;
         var t3:Tween = new Tween(Config.starling.root,0.2,"linear");
         Starling.juggler.add(t3);
         t3.animate("x",-2,2);
         t3.animate("y",-2,2);
         t3.repeatCount = num;
         t3.onComplete = function():void
         {
            Config.starling.root.x = 0;
            Config.starling.root.y = 0;
         };
      }
      
      public static function shareScreen1(param1:int) : void
      {
         num = param1;
         var t3:Tween = new Tween(Config.starling.root,0.1,"linear");
         Starling.juggler.add(t3);
         t3.animate("y",-3,3);
         t3.repeatCount = num;
         LogUtil("摇屏次数" + num);
         t3.onComplete = function():void
         {
            Config.starling.root.y = 0;
         };
      }
      
      public static function barScaleXAni(param1:DisplayObject, param2:Number, param3:Boolean, param4:String, param5:Number = 0.5) : void
      {
         target = param1;
         scaleX = param2;
         isTellEvent = param3;
         camp = param4;
         time = param5;
         var t:Tween = new Tween(target,time,"easeOut");
         Starling.juggler.add(t);
         t.animate("scaleX",scaleX);
         if(isTellEvent && scaleX != 0)
         {
            t.onComplete = function():void
            {
               GameFacade.getInstance().sendNotification("end_hpbar_ani",0,camp);
            };
         }
         if(scaleX == 0)
         {
            t.onComplete = function():void
            {
               GameFacade.getInstance().sendNotification("no_hp",0,camp);
            };
         }
      }
      
      public static function endEleFightAni(param1:DisplayObject, param2:DisplayObject) : void
      {
         target1 = param1;
         target2 = param2;
         Dialogue.updateDialogue("......");
         var t:Tween = new Tween(target1,0.3,"easeOut");
         Starling.juggler.add(t);
         t.animate("y",target1.y + 70);
         t.animate("alpha",0);
         var t2:Tween = new Tween(target2,0.2,"easeOut");
         Starling.juggler.add(t2);
         t2.animate("alpha",0);
         t.onComplete = function():void
         {
            target1.alpha = 1;
            target1.y = target1.y - 70;
            target1.visible = false;
            target2.alpha = 1;
            target2.visible = false;
            LogUtil("广播啊尼玛");
            target1.dispatchEventWith("ELF_WILL_DIE");
         };
      }
      
      public static function numTfAni(param1:TextField, param2:int, param3:Number = 1) : void
      {
         var _loc4_:Tween = new Tween(param1,param3);
         Starling.juggler.add(_loc4_);
         var _loc5_:Number = param1.text;
         if(_loc5_ == param2)
         {
            return;
         }
         _loc4_.animate("text",param2,_loc5_);
         _loc4_.onUpdate = setTextFiedLength;
         _loc4_.onUpdateArgs = [param1];
      }
      
      public static function fadeOutOrIn(param1:DisplayObject, param2:int, param3:int, param4:Number) : void
      {
         target = param1;
         end = param2;
         start = param3;
         time = param4;
         Starling.juggler.removeTweens(target);
         if(end == 1)
         {
            target.alpha = 0;
         }
         var t:Tween = new Tween(target,time,"easeOut");
         Starling.juggler.add(t);
         t.animate("alpha",end,start);
         t.onComplete = function():void
         {
            if(end == 0)
            {
               target.removeFromParent();
            }
         };
      }
      
      public static function hurtSelfAni(param1:Image, param2:Number = 0) : void
      {
         target = param1;
         delay = param2;
         var _x:int = target.x;
         var _y:int = target.y;
         target.color = 16711680;
         var t:Tween = new Tween(target,0.2,"linear");
         Starling.juggler.add(t);
         t.animate("alpha",1,0);
         t.delay = delay;
         t.repeatCount = 2;
         t.onComplete = function():void
         {
            target.color = 16777215;
            target.x = _x;
            target.y = _y;
         };
      }
      
      private static function setTextFiedLength(param1:TextField) : void
      {
         param1.text = param1.text;
      }
   }
}
