package com.mvc.views.uis.worldHorn
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import com.common.managers.LoadSwfAssetsManager;
   import flash.geom.Rectangle;
   import com.mvc.views.mediator.fighting.AniFactor;
   import com.mvc.models.proxy.mainCity.chat.ChatPro;
   import com.mvc.models.vos.mainCity.chat.ChatVO;
   import feathers.controls.Label;
   import starling.animation.Tween;
   import starling.core.Starling;
   import com.mvc.views.uis.fighting.FightingUI;
   import flash.text.TextFormat;
   
   public class WorldHorn extends Sprite
   {
      
      private static var intance:com.mvc.views.uis.worldHorn.WorldHorn;
       
      private var swf:Swf;
      
      private var rootClass:Game;
      
      private var spr_broadcast:SwfSprite;
      
      private var viewContain:Sprite;
      
      private var isPlay:Boolean;
      
      public var isNotShow:Boolean;
      
      private var isUrgent:Boolean;
      
      private var sprWith:int;
      
      public function WorldHorn()
      {
         super();
         rootClass = Config.starling.root as Game;
         init();
      }
      
      public static function getIntance() : com.mvc.views.uis.worldHorn.WorldHorn
      {
         if(intance == null)
         {
            intance = new com.mvc.views.uis.worldHorn.WorldHorn();
            intance.width = intance.width * Config.scaleX;
            intance.height = intance.height * Config.scaleY;
         }
         return intance;
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         spr_broadcast = swf.createSprite("spr_broadcast");
         spr_broadcast.x = 180;
         spr_broadcast.y = 60;
         viewContain = new Sprite();
         viewContain.x = 87;
         viewContain.y = 25;
         spr_broadcast.addChild(viewContain);
         viewContain.clipRect = new Rectangle(0,0,720,50);
         addChild(spr_broadcast);
         this.touchable = false;
         sprWith = spr_broadcast.width;
      }
      
      public function playText(param1:Boolean) : void
      {
         isUrgent = param1;
         if(!isPlay)
         {
            rootClass.parent.addChild(com.mvc.views.uis.worldHorn.WorldHorn.getIntance());
            AniFactor.fadeOutOrIn(com.mvc.views.uis.worldHorn.WorldHorn.getIntance(),1,0,0.5);
            if(ChatPro.worldHornVec.length > 0)
            {
               playFirstHorn(ChatPro.worldHornVec[0]);
               ChatPro.worldHornVec.splice(0,1);
            }
         }
      }
      
      public function playFirstHorn(param1:ChatVO) : void
      {
         chatVo = param1;
         LogUtil("播放第一条广播");
         isPlay = true;
         var color:uint = 9713664;
         if(chatVo.userName == "系统公告")
         {
            color = 1211399;
         }
         var label:Label = getLabel(color);
         var msg:String = chatVo.msg.replace(new RegExp("\\n|\\r","g"),"");
         label.text = "<font color=\'#ff0000\'>【" + chatVo.userName + "】</font>" + msg;
         label.validate();
         var labelWidth:Number = label.width;
         LogUtil("label.width==",labelWidth);
         if(label.x < 0)
         {
            var time:Number = (labelWidth + label.x - 350) / 100;
         }
         else
         {
            time = labelWidth / 90 > 8?labelWidth / 90:8.0;
         }
         LogUtil("time=",time);
         LogUtil("什么鬼========",label.text);
         var t:Tween = Starling.juggler.tween(label,time,{}) as Tween;
         t.animate("x",-labelWidth);
         t.onUpdate = function():void
         {
            if(labelWidth + label.x <= 450 && !isStarNext)
            {
               if(ChatPro.worldHornVec.length > 0)
               {
                  isStarNext = true;
                  playFirstHorn(ChatPro.worldHornVec[0]);
                  ChatPro.worldHornVec.splice(0,1);
               }
            }
            if(rootClass.page is FightingUI)
            {
               if(isUrgent)
               {
                  WorldHorn.getIntance().alpha = 1;
               }
               else
               {
                  WorldHorn.getIntance().alpha = 0;
               }
            }
            else if(isNotShow)
            {
               WorldHorn.getIntance().alpha = 0;
            }
            else
            {
               WorldHorn.getIntance().alpha = 1;
            }
         };
         t.onComplete = function():void
         {
            if(ChatPro.worldHornVec.length <= 0 && !isStarNext)
            {
               isPlay = false;
               isUrgent = false;
               AniFactor.fadeOutOrIn(WorldHorn.getIntance(),0,1,0.5);
            }
            label.text = "";
            label.removeFromParent(true);
         };
      }
      
      private function getLabel(param1:uint) : Label
      {
         var _loc2_:Label = new Label();
         _loc2_.y = 8;
         _loc2_.x = spr_broadcast.width;
         _loc2_.textRendererProperties.wordWrap = false;
         _loc2_.textRendererProperties.isHTML = true;
         _loc2_.textRendererProperties.textFormat = new TextFormat("FZCuYuan-M03S",25,param1);
         viewContain.addChild(_loc2_);
         return _loc2_;
      }
   }
}
