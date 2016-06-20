package com.mvc.views.uis.mainCity.trial
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.views.uis.mainCity.home.ElfBgUnitUI;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.views.uis.mainCity.kingKwan.DropPropUnitUI;
   
   public class TrialBossInfoUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_bossInfo:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var btn_challenge:SwfButton;
      
      public var tf_bossName:TextField;
      
      public var tf_difficultyLv:TextField;
      
      public var tf_bossDesc:TextField;
      
      public var tf_nowPower:TextField;
      
      public var elfContainer:Sprite;
      
      public var propContainer:Sprite;
      
      public function TrialBossInfoUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("trial");
         spr_bossInfo = swf.createSprite("spr_bossInfo");
         spr_bossInfo.x = 1136 - spr_bossInfo.width >> 1;
         spr_bossInfo.y = (640 - spr_bossInfo.height >> 1) + 20;
         addChild(spr_bossInfo);
         btn_close = spr_bossInfo.getButton("btn_close");
         btn_challenge = spr_bossInfo.getButton("btn_challenge");
         tf_bossName = spr_bossInfo.getTextField("tf_bossName");
         tf_difficultyLv = spr_bossInfo.getTextField("tf_difficultyLv");
         tf_bossDesc = spr_bossInfo.getTextField("tf_bossDesc");
         tf_nowPower = spr_bossInfo.getTextField("tf_nowPower");
         tf_nowPower.visible = false;
      }
      
      public function updateElfCamp(param1:Vector.<ElfVO>) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         if(elfContainer)
         {
            elfContainer.removeChildren(0,-1,true);
            elfContainer = null;
         }
         elfContainer = new Sprite();
         elfContainer.x = 28;
         elfContainer.y = 260;
         spr_bossInfo.addChild(elfContainer);
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = new ElfBgUnitUI(true);
            var _loc4_:* = 0.8;
            _loc2_.scaleY = _loc4_;
            _loc2_.scaleX = _loc4_;
            _loc2_.identify = "试炼";
            _loc2_.myElfVo = param1[_loc3_];
            _loc2_.switchContain(true);
            elfContainer.addChild(_loc2_);
            _loc2_.x = 100 * _loc3_;
            _loc3_++;
         }
      }
      
      public function updateDropRrward(param1:Array) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         var _loc4_:* = null;
         if(propContainer)
         {
            propContainer.removeChildren(0,-1,true);
            propContainer = null;
         }
         propContainer = new Sprite();
         propContainer.x = 28;
         propContainer.y = 410;
         spr_bossInfo.addChild(propContainer);
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            LogUtil("caonim");
            _loc2_ = GetPropFactor.getPropVO(param1[_loc3_]);
            _loc4_ = new DropPropUnitUI();
            _loc4_.myPropVo = _loc2_;
            _loc4_.rewardNameTf.visible = false;
            var _loc5_:* = 0.8;
            _loc4_.scaleY = _loc5_;
            _loc4_.scaleX = _loc5_;
            _loc4_.x = 100 * _loc3_;
            propContainer.addChild(_loc4_);
            _loc3_++;
         }
      }
   }
}
