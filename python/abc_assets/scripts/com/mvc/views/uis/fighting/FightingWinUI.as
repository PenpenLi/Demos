package com.mvc.views.uis.fighting
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import starling.display.DisplayObject;
   import lzm.starling.swf.display.SwfSprite;
   import starling.display.Image;
   import lzm.starling.swf.display.SwfMovieClip;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.ScrollContainer;
   import lzm.starling.swf.display.SwfImage;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.events.Event;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.friend.FriendPro;
   import flash.utils.clearTimeout;
   import com.common.managers.SoundManager;
   import com.mvc.GameFacade;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.animation.Tween;
   import extend.SoundEvent;
   import com.mvc.models.vos.fighting.FightingConfig;
   import starling.core.Starling;
   import com.mvc.views.mediator.fighting.AniFactor;
   import com.mvc.models.proxy.mainCity.elfSeries.ElfSeriesPro;
   import flash.utils.setTimeout;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.views.uis.mainCity.home.ElfBgUnitUI;
   import com.mvc.views.uis.mainCity.kingKwan.DropPropUnitUI;
   import starling.display.Quad;
   
   public class FightingWinUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var rootClass:DisplayObject;
      
      private var spr_fightWinBg:SwfSprite;
      
      private var winImage:Image;
      
      private var textSpr:SwfSprite;
      
      private var movic_light:SwfMovieClip;
      
      private var silver:TextField;
      
      private var expValue:TextField;
      
      private var btn_addFri:SwfButton;
      
      private var btn_sure:SwfButton;
      
      private var _frienfId:String;
      
      private var panel:ScrollContainer;
      
      private var seriveWinText:TextField;
      
      private var up:SwfImage;
      
      private var delay:uint;
      
      public function FightingWinUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.8;
         addChild(_loc1_);
         rootClass = (Config.starling.root as Game).page;
         init();
         addContain();
      }
      
      private function addContain() : void
      {
         panel = new ScrollContainer();
         spr_fightWinBg.addChild(panel);
         panel.width = 510;
         panel.height = 150;
         panel.y = 355;
         panel.x = 290;
         panel.scrollBarDisplayMode = "none";
         panel.verticalScrollPolicy = "none";
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("fighting");
         spr_fightWinBg = swf.createSprite("spr_winBg");
         winImage = spr_fightWinBg.getImage("winImage");
         movic_light = spr_fightWinBg.getMovie("light");
         textSpr = spr_fightWinBg.getSprite("textSpr");
         seriveWinText = spr_fightWinBg.getTextField("seriveWinText");
         up = spr_fightWinBg.getImage("up");
         showSeriesWin(false);
         silver = textSpr.getTextField("silver");
         expValue = textSpr.getTextField("expValue");
         btn_sure = spr_fightWinBg.getButton("btn_sure");
         spr_fightWinBg.y = spr_fightWinBg.y + 30;
         spr_fightWinBg.x = spr_fightWinBg.x + 50;
         addChild(spr_fightWinBg);
         this.addEventListener("triggered",onclick);
      }
      
      private function onclick(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(btn_addFri !== _loc2_)
         {
            if(btn_sure === _loc2_)
            {
               remove();
            }
         }
         else
         {
            (Facade.getInstance().retrieveProxy("FriendPro") as FriendPro).write1406(_frienfId);
         }
      }
      
      private function remove() : void
      {
         clearTimeout(delay);
         this.removeFromParent(true);
         SoundManager.getInstance().stopMusic();
         GameFacade.getInstance().sendNotification("switch_page","RETURN_LAST");
      }
      
      public function show(param1:int, param2:Boolean, param3:int, param4:int, param5:Vector.<PropVO> = null, param6:String = "", param7:Vector.<ElfVO> = null, param8:Boolean = false) : void
      {
         curOpenId = param1;
         isAddFri = param2;
         silverNum = param3;
         exp = param4;
         propVec = param5;
         friendId = param6;
         elfVec = param7;
         isSeries = param8;
         SoundEvent.dispatchEvent("play_music_and_stop_bg",{
            "musicName":FightingConfig.fightMusicAssets[1],
            "isContinuePlayBGM":false
         });
         movic_light.visible = false;
         movic_light.stop();
         btn_sure.visible = false;
         textSpr.alpha = 0;
         var t:Tween = new Tween(winImage,0.5,"easeOutBack");
         Starling.juggler.add(t);
         t.animate("scaleX",1,0);
         t.animate("scaleY",1,0);
         t.animate("alpha",1,0);
         t.onComplete = function():void
         {
            movic_light.visible = true;
            movic_light.gotoAndPlay(0);
            silver.text = "0";
            expValue.text = "0";
            AniFactor.numTfAni(silver,silverNum,1.5);
            AniFactor.numTfAni(expValue,exp,1.5);
            var _loc1_:Tween = new Tween(textSpr,0.5,"easeOut");
            Starling.juggler.add(_loc1_);
            _loc1_.animate("alpha",1);
            btn_sure.visible = true;
            addProp(propVec);
            if(elfVec)
            {
               addElf(elfVec);
            }
            if(isSeries)
            {
               showSeriesWin(true);
               seriveWinText.text = "排名上升:" + ElfSeriesPro.upRank;
            }
         };
         _frienfId = friendId;
         (rootClass as Sprite).addChild(this);
         delay = setTimeout(remove,10000);
      }
      
      private function addElf(param1:Vector.<ElfVO>) : void
      {
         var _loc4_:* = 0;
         var _loc3_:* = null;
         var _loc2_:* = null;
         panel.width = 780;
         panel.x = 140 + 65 * (6 - GetElfFactor.seriesElfNum(param1));
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            if(param1[_loc4_] != null)
            {
               _loc3_ = new ElfBgUnitUI();
               _loc3_.identify = "胜利队伍";
               _loc3_.identify2 = "王者之路";
               _loc3_.identify3 = "不可点击";
               _loc3_.myElfVo = param1[_loc4_];
               _loc3_.x = _loc4_ * 130;
               _loc3_.y = 12;
               _loc3_.alpha = 0;
               _loc2_ = new Tween(_loc3_,0.3,"easeOut");
               Starling.juggler.add(_loc2_);
               _loc2_.delay = _loc4_ / 7;
               _loc2_.animate("alpha",1);
               panel.addChild(_loc3_);
            }
            _loc4_++;
         }
      }
      
      private function addProp(param1:Vector.<PropVO>) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc2_:* = null;
         if(param1 && param1.length > 0)
         {
            panel.width = 780;
            panel.x = 140 + 65 * (6 - param1.length);
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc4_ = new DropPropUnitUI();
               _loc4_.myPropVo = param1[_loc3_];
               _loc4_.setTextColor(16777215);
               _loc4_.x = _loc3_ * 130;
               _loc4_.alpha = 0;
               _loc2_ = new Tween(_loc4_,0.5,"easeOut");
               Starling.juggler.add(_loc2_);
               _loc2_.delay = _loc3_ / 7;
               _loc2_.animate("alpha",1);
               panel.addChild(_loc4_);
               _loc3_++;
            }
         }
      }
      
      private function showSeriesWin(param1:Boolean) : void
      {
         seriveWinText.visible = param1;
         up.visible = param1;
      }
   }
}
