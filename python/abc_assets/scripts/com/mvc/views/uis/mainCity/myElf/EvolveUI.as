package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import com.mvc.models.vos.elf.ElfVO;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.components.feathers.FeathersButton;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import feathers.controls.ScrollContainer;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import com.mvc.views.mediator.mainCity.myElf.MyElfMedia;
   import org.puremvc.as3.patterns.facade.Facade;
   import starling.events.Event;
   import com.mvc.models.proxy.mainCity.myElf.MyElfPro;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import starling.display.Quad;
   
   public class EvolveUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.myElf.EvolveUI;
       
      private var swf:Swf;
      
      private var _myElfVo:ElfVO;
      
      public var spr_evolveBg:SwfSprite;
      
      public var btn_evolve:FeathersButton;
      
      public var btn_cancel:SwfButton;
      
      public var evolveLv:TextField;
      
      public var tipsTf:TextField;
      
      public var propContain:ScrollContainer;
      
      public var ifAllPass:Boolean = true;
      
      private var btn_trainBtn:FeathersButton;
      
      public function EvolveUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         addContain();
         addEventListener("triggered",clickHandler);
         btn_evolve.addEventListener("triggered",click);
         btn_trainBtn.addEventListener("triggered",gotoTrain);
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.myElf.EvolveUI
      {
         return instance || new com.mvc.views.uis.mainCity.myElf.EvolveUI();
      }
      
      private function gotoTrain() : void
      {
         if(PlayerVO.lv < 8)
         {
            return Tips.show("玩家等级达到8级开启训练");
         }
         MyElfMedia.isJumpTrain = true;
         Facade.getInstance().sendNotification("switch_win",null,"LOAD_TRAINELF");
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(btn_cancel === _loc2_)
         {
            removeFromParent();
         }
      }
      
      public function remove() : void
      {
         if(getInstance().parent)
         {
            getInstance().removeFromParent();
         }
      }
      
      private function click(param1:Event) : void
      {
         if(ifAllPass)
         {
            (Facade.getInstance().retrieveProxy("MyElfPro") as MyElfPro).write2011(myElfVo.evolveId,myElfVo);
            BeginnerGuide.playBeginnerGuide();
         }
         else
         {
            Tips.show("进化条件未达成");
         }
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         spr_evolveBg = swf.createSprite("spr_evolveBg");
         btn_evolve = swf.createComponent("comp_feathers_button");
         btn_evolve.name = "btn_evolve2";
         btn_cancel = spr_evolveBg.getButton("btn_cancel");
         evolveLv = spr_evolveBg.getTextField("evolveLv");
         tipsTf = spr_evolveBg.getTextField("tipsTf");
         btn_trainBtn = spr_evolveBg.getChildByName("btn_trainBtn") as FeathersButton;
         spr_evolveBg.x = 1136 - spr_evolveBg.width >> 1;
         spr_evolveBg.y = 640 - spr_evolveBg.height >> 1;
         addChild(spr_evolveBg);
         btn_evolve.x = 125;
         btn_evolve.y = 370;
         btn_evolve.width = 109;
         btn_evolve.height = 75;
         spr_evolveBg.addChild(btn_evolve);
      }
      
      private function addContain() : void
      {
         propContain = new ScrollContainer();
         spr_evolveBg.addChild(propContain);
         propContain.width = 480;
         propContain.height = 160;
         propContain.y = 200;
         propContain.x = 30;
         propContain.scrollBarDisplayMode = "none";
         propContain.verticalScrollPolicy = "none";
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         var _loc4_:* = 0;
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc5_:* = 0;
         if(param1.evoStoneArr.length > 0)
         {
            tipsTf.text = "（点击图片可打开碎片合成窗口）";
         }
         else
         {
            tipsTf.text = "";
         }
         ifAllPass = true;
         if(param1.evolveId == "0")
         {
            ifAllPass = false;
            return;
         }
         propContain.removeChildren(0,-1,true);
         this._myElfVo = param1;
         evolveLv.text = "Lv." + param1.evoLv;
         LogUtil("ceshi=======",param1.evoLv);
         _loc4_ = 0;
         while(_loc4_ < param1.evoStoneArr.length)
         {
            _loc3_ = GetPropFactor.getProp(param1.evoStoneArr[_loc4_][0]);
            if(!_loc3_)
            {
               _loc3_ = GetPropFactor.getPropVO(param1.evoStoneArr[_loc4_][0]);
               LogUtil("没有这个进化用的道具====",_loc3_.name);
            }
            _loc3_.evolveNum = param1.evoStoneArr[_loc4_][1];
            _loc2_ = new PropUnitUI();
            _loc2_.myElfVo = param1;
            _loc2_.myPropVo = _loc3_;
            _loc2_.x = 120 * _loc4_;
            propContain.addChild(_loc2_);
            if(!_loc2_.ifPass)
            {
               ifAllPass = false;
            }
            _loc4_++;
         }
         if(param1.lv >= param1.evoLv)
         {
            btn_trainBtn.isEnabled = false;
         }
         else
         {
            btn_trainBtn.isEnabled = true;
            ifAllPass = false;
         }
         if(param1.currentHp <= 0)
         {
            ifAllPass = false;
         }
         if(param1.evolveId > 20000)
         {
            if(param1.brokenLv < 13)
            {
               ifAllPass = false;
            }
            if(param1.starts < param1.maxStar)
            {
               ifAllPass = false;
            }
            _loc5_ = 0;
            while(_loc5_ < param1.individual.length)
            {
               if(param1.individual[_loc5_] < 30)
               {
                  ifAllPass = false;
                  break;
               }
               _loc5_++;
            }
         }
         btn_evolve.isEnabled = ifAllPass;
      }
      
      public function get myElfVo() : ElfVO
      {
         return _myElfVo;
      }
   }
}
