package com.mvc.views.uis.mainCity.backPack
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.views.uis.mainCity.myElf.EvoStoneGuideUI;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.mediator.mainCity.myElf.MyElfMedia;
   import com.mvc.views.mediator.mainCity.backPack.BackPackMedia;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.common.util.xmlVOHandler.GetpropImage;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.common.util.xmlVOHandler.GetMapFactor;
   import com.common.themes.Tips;
   import com.mvc.models.proxy.mainCity.myElf.MyElfPro;
   import com.mvc.views.uis.mainCity.firstRecharge.FirstRchRewardTips;
   import starling.events.Event;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.events.EventCenter;
   import com.mvc.models.proxy.mainCity.backPack.BackPackPro;
   import starling.animation.Tween;
   import extend.SoundEvent;
   import starling.core.Starling;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class ComposeUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.backPack.ComposeUI;
       
      private var swf:Swf;
      
      private var spr_composeBg:SwfSprite;
      
      private var btn_compose:SwfButton;
      
      private var btn_cancle:SwfButton;
      
      private var btn_close:SwfButton;
      
      private var titleTf:TextField;
      
      private var brokenTf:TextField;
      
      private var propNameTf:TextField;
      
      private var moneyTf:TextField;
      
      private var bokenImg:Sprite;
      
      private var comPropImg:Sprite;
      
      private var _propVO:PropVO;
      
      private var composePropVO:PropVO;
      
      public function ComposeUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("bag");
         spr_composeBg = swf.createSprite("spr_compose_s");
         btn_compose = spr_composeBg.getButton("btn_compose");
         btn_cancle = spr_composeBg.getButton("btn_cancle");
         btn_close = spr_composeBg.getButton("btn_close");
         titleTf = spr_composeBg.getTextField("title");
         titleTf.autoScale = true;
         brokenTf = spr_composeBg.getTextField("broken");
         propNameTf = spr_composeBg.getTextField("propName");
         propNameTf.autoScale = true;
         moneyTf = spr_composeBg.getTextField("money");
         spr_composeBg.x = 1136 - spr_composeBg.width >> 1;
         spr_composeBg.y = 640 - spr_composeBg.height >> 1;
         addChild(spr_composeBg);
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.backPack.ComposeUI
      {
         return instance || new com.mvc.views.uis.mainCity.backPack.ComposeUI();
      }
      
      public function show(param1:PropVO, param2:String) : void
      {
         var _loc3_:* = null;
         EvoStoneGuideUI.parentPage = param2;
         if(param2 == "MyElfMedia")
         {
            _loc3_ = (Facade.getInstance().retrieveMediator("MyElfMedia") as MyElfMedia).myElf;
         }
         if(param2 == "BackPackMedia")
         {
            _loc3_ = (Facade.getInstance().retrieveMediator("BackPackMedia") as BackPackMedia).backPack;
         }
         _propVO = GetPropFactor.getProp(param1.id);
         if(!_propVO)
         {
            _propVO = GetPropFactor.getPropVO(param1.id);
         }
         if(bokenImg)
         {
            GetpropImage.clean(bokenImg);
         }
         bokenImg = GetpropImage.getPropSpr(_propVO);
         bokenImg.x = 60;
         bokenImg.y = 143;
         bokenImg.addEventListener("touch",bokenImg_touchHandler);
         spr_composeBg.addChild(bokenImg);
         composePropVO = GetPropFactor.getPropVO(_propVO.composeId);
         if(comPropImg)
         {
            GetpropImage.clean(comPropImg);
         }
         comPropImg = GetpropImage.getPropSpr(composePropVO);
         comPropImg.x = 250;
         comPropImg.y = 143;
         comPropImg.addEventListener("touch",comPropImg_touchHandler);
         spr_composeBg.addChild(comPropImg);
         titleTf.text = "合成" + composePropVO.name;
         brokenTf.text = _propVO.count + "/" + _propVO.composeNum;
         propNameTf.text = composePropVO.name;
         moneyTf.text = _propVO.composeMoney;
         _loc3_.addChild(this);
         this.addEventListener("triggered",click);
      }
      
      private function bokenImg_touchHandler(param1:TouchEvent) : void
      {
         var _loc3_:* = null;
         var _loc2_:Touch = param1.getTouch(bokenImg);
         if(_loc2_)
         {
            if(_loc2_.phase == "began")
            {
               if(!GetMapFactor.allPropBirthPllace.hasOwnProperty(_propVO.id))
               {
                  Tips.show("没有这个道具的消息");
                  return;
               }
               _loc3_ = GetMapFactor.allPropBirthPllace[_propVO.id];
               (Facade.getInstance().retrieveProxy("MyElfPro") as MyElfPro).write3010(_loc3_);
            }
         }
      }
      
      public function showDropList(param1:Array) : void
      {
         EvoStoneGuideUI.getInstance().show(_propVO,param1);
         removeFromParent();
      }
      
      private function comPropImg_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(comPropImg);
         if(_loc2_)
         {
            if(_loc2_.phase == "began")
            {
               FirstRchRewardTips.getInstance().showPropTips(composePropVO,comPropImg);
            }
            if(_loc2_.phase == "ended")
            {
               FirstRchRewardTips.getInstance().removePropTips();
            }
         }
      }
      
      private function click(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(btn_cancle !== _loc2_)
         {
            if(btn_close !== _loc2_)
            {
               if(btn_compose === _loc2_)
               {
                  if(_propVO.count < _propVO.composeNum)
                  {
                     Tips.show(_propVO.name + "数量不足");
                     return;
                  }
                  if(PlayerVO.silver < _propVO.composeMoney)
                  {
                     Tips.show("金币不足");
                     return;
                  }
                  EventCenter.addEventListener("BOKEN_COMPOSE_SUCCES",composeSucces);
                  (Facade.getInstance().retrieveProxy("BackPackPro") as BackPackPro).write3008(_propVO.id);
               }
            }
            addr61:
            return;
         }
         close();
         §§goto(addr61);
      }
      
      private function composeSucces(param1:Event) : void
      {
         LogUtil("e.data.mainId ====== ",param1.data.mainId);
         EventCenter.removeEventListener("BOKEN_COMPOSE_SUCCES",composeSucces);
         playAni(_propVO);
         GetPropFactor.addOrLessProp(_propVO,false,_propVO.composeNum);
         GetPropFactor.addOrLessProp(composePropVO);
         Facade.getInstance().sendNotification("update_play_money_info",PlayerVO.silver - _propVO.composeMoney);
         brokenTf.text = _propVO.count + "/" + _propVO.composeNum;
         Facade.getInstance().sendNotification("SHOW_BACKPACK");
      }
      
      private function playAni(param1:PropVO) : void
      {
         _propVO = param1;
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","propCom");
         var img:Sprite = GetpropImage.getPropSpr(_propVO);
         img.x = bokenImg.x;
         img.y = bokenImg.y;
         spr_composeBg.addChild(img);
         var t:Tween = new Tween(img,0.3);
         Starling.juggler.add(t);
         t.animate("x",comPropImg.x,img.x);
         t.animate("alpha",0.5,1);
         t.onComplete = function():void
         {
            img.removeFromParent(true);
         };
      }
      
      public function close() : void
      {
         if(getInstance().parent)
         {
            EvoStoneGuideUI.parentPage = "";
            bokenImg.removeEventListener("touch",bokenImg_touchHandler);
            comPropImg.removeEventListener("touch",comPropImg_touchHandler);
            bokenImg.removeFromParent(true);
            comPropImg.removeFromParent(true);
            removeFromParent();
            this.removeEventListener("triggered",click);
            Facade.getInstance().sendNotification("UPDATA_USE_PROP",GetPropFactor.getPropIndex(_propVO));
            EventCenter.dispatchEvent("BOKEN_COMPOSE_OVER");
         }
      }
   }
}
