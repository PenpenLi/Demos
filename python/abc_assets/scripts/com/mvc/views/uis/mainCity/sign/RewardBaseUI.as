package com.mvc.views.uis.mainCity.sign
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfImage;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import starling.display.Image;
   import starling.text.TextField;
   import com.mvc.models.vos.elf.ElfVO;
   import lzm.starling.swf.display.SwfSprite;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.models.vos.mainCity.sign.SignVO;
   import com.mvc.views.mediator.mainCity.amuse.AmuseMedia;
   import com.common.events.EventCenter;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.sign.SignPro;
   import com.mvc.views.uis.mapSelect.ExtendElfUnitTips;
   import com.mvc.views.uis.mainCity.firstRecharge.FirstRchRewardTips;
   import com.common.util.xmlVOHandler.GetpropImage;
   import com.common.managers.ELFMinImageManager;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class RewardBaseUI extends Sprite
   {
       
      public var swf:Swf;
      
      public var numBg:SwfImage;
      
      public var _propVo:PropVO;
      
      public var img:Image;
      
      public var numText:TextField;
      
      public var _elfVo:ElfVO;
      
      public var day:int = 100;
      
      private var tick:SwfImage;
      
      private var seleteBg:SwfImage;
      
      private var spr_vip:SwfSprite;
      
      private var double:int = 1;
      
      private var contain:Sprite;
      
      private var propImg:Sprite;
      
      private var otherImg:Sprite;
      
      public function RewardBaseUI()
      {
         super();
         contain = new Sprite();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("sign");
         numBg = swf.createImage("img_numBg");
         numBg.x = 78;
         numBg.y = 78;
         numText = new TextField(50,20,"1","FZCuYuan-M03S",16,16777215,true);
         numText.x = 69;
         numText.y = 85;
         tick = swf.createImage("img_tick");
         tick.x = 60;
         tick.y = 70;
         tick.touchable = false;
         addChild(contain);
         initEvent();
      }
      
      public function initEvent() : void
      {
         addEventListener("touch",ontouch);
      }
      
      private function ontouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_)
         {
            if(_loc2_.phase == "began")
            {
               LogUtil(SignVO.monthTimes,day,SignVO.isTodaySigned);
               if(SignVO.monthTimes == day && !SignVO.isTodaySigned)
               {
                  if(_elfVo && !AmuseMedia.once())
                  {
                     return;
                  }
                  LogUtil("签到===");
                  EventCenter.addEventListener("SIGN_SUCCESS",signSuccess);
                  (Facade.getInstance().retrieveProxy("SignPro") as SignPro).write2102();
                  return;
               }
               if(_elfVo)
               {
                  ExtendElfUnitTips.getInstance().showElfTips(_elfVo,this);
               }
               if(_propVo)
               {
                  FirstRchRewardTips.getInstance().showPropTips(_propVo,this);
               }
            }
            if(_loc2_.phase == "ended")
            {
               if(_propVo)
               {
                  FirstRchRewardTips.getInstance().removePropTips();
               }
               if(_elfVo)
               {
                  ExtendElfUnitTips.getInstance().removeElfTips();
               }
            }
         }
      }
      
      private function signSuccess() : void
      {
         EventCenter.removeEventListener("SIGN_SUCCESS",signSuccess);
         addSignState();
      }
      
      public function rewardHandle(param1:Object) : void
      {
         if(param1 is String)
         {
            other = param1 as String;
         }
         if(param1 is PropVO)
         {
            myProp = param1 as PropVO;
         }
         if(param1 is ElfVO)
         {
            myElfVo = param1 as ElfVO;
         }
         this.addQuickChild(numBg);
         this.addQuickChild(numText);
         if(spr_vip)
         {
            this.addQuickChild(spr_vip);
         }
         if(day < SignVO.monthTimes)
         {
            addSignState();
         }
      }
      
      public function set myProp(param1:PropVO) : void
      {
         _propVo = param1;
         propImg = GetpropImage.getPropSpr(param1);
         this.addQuickChild(propImg);
         numText.text = param1.rewardCount;
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         _elfVo = param1;
         img = ELFMinImageManager.getElfM(param1.imgName);
         this.addQuickChild(img);
         numText.visible = false;
         numBg.visible = false;
      }
      
      public function set other(param1:String) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.substr(0,4);
         if("奖励经验" !== _loc3_)
         {
            if("奖励积分" !== _loc3_)
            {
               if("奖励金币" !== _loc3_)
               {
                  if("奖励钻石" !== _loc3_)
                  {
                     if("奖励体力" === _loc3_)
                     {
                        _loc2_ = "img_cake";
                     }
                  }
                  else
                  {
                     _loc2_ = "img_dia980";
                  }
               }
               else
               {
                  _loc2_ = "img_coin";
               }
            }
            addr46:
            otherImg = GetpropImage.getOtherSpr(_loc2_);
            this.addQuickChild(otherImg);
            numText.text = param1.slice(5);
            return;
         }
         _loc2_ = "img_expicon";
         §§goto(addr46);
      }
      
      public function addSignState() : void
      {
         addMask();
         addQuickChild(tick);
      }
      
      public function addVIPDouble(param1:int) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc5_:* = null;
         double = 2;
         spr_vip = swf.createSprite("spr_vip");
         spr_vip.touchable = false;
         var _loc2_:SwfImage = spr_vip.getImage("vip");
         if(param1 > 9)
         {
            _loc2_.x = -10;
            _loc2_.y = 45;
            _loc4_ = swf.createImage("img_vip" + param1 / 10);
            _loc3_ = swf.createImage("img_vip" + param1 % 10);
            _loc4_.x = 2;
            _loc4_.y = 36;
            _loc3_.x = 9;
            _loc3_.y = 29;
            spr_vip.addQuickChild(_loc4_);
            spr_vip.addQuickChild(_loc3_);
         }
         else
         {
            _loc2_.x = -4;
            _loc2_.y = 38;
            _loc5_ = swf.createImage("img_vip" + param1);
            _loc5_.x = 8;
            _loc5_.y = 30;
            spr_vip.addQuickChild(_loc5_);
         }
      }
      
      public function addMask() : void
      {
         if(!seleteBg)
         {
            seleteBg = swf.createImage("img_bg2");
            addQuickChild(seleteBg);
            seleteBg.touchable = false;
         }
      }
      
      public function removeMask() : void
      {
         if(seleteBg)
         {
            seleteBg.texture.dispose();
            seleteBg.removeFromParent(true);
            seleteBg = null;
         }
      }
   }
}
