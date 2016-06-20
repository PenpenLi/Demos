package com.mvc.views.uis.mapSelect
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.ScrollContainer;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.mvc.views.uis.mainCity.playerInfo.PlayerUpdateUI;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.views.uis.mainCity.kingKwan.DropPropUnitUI;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.mediator.mapSelect.MainAdventureWinMedia;
   import starling.display.Quad;
   
   public class RaidsFinishUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var rootClass:Game;
      
      private var spr_mopUpBg:SwfSprite;
      
      private var silver:TextField;
      
      private var exp:TextField;
      
      private var btn_mopUp:SwfButton;
      
      private var panel:ScrollContainer;
      
      public function RaidsFinishUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         rootClass = Config.starling.root as Game;
         init();
         addContain();
      }
      
      private function addContain() : void
      {
         panel = new ScrollContainer();
         spr_mopUpBg.addChild(panel);
         panel.width = 500;
         panel.height = 150;
         panel.y = 215;
         panel.x = 40;
         panel.scrollBarDisplayMode = "none";
         panel.verticalScrollPolicy = "none";
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("cityMap");
         spr_mopUpBg = swf.createSprite("spr_mopUpBg");
         silver = spr_mopUpBg.getTextField("silver");
         exp = spr_mopUpBg.getTextField("exp");
         btn_mopUp = spr_mopUpBg.getButton("btn_mopUp");
         spr_mopUpBg.x = (1136 - spr_mopUpBg.width) / 2;
         spr_mopUpBg.y = (640 - spr_mopUpBg.height) / 2;
         addChild(spr_mopUpBg);
         btn_mopUp.addEventListener("triggered",onclick);
      }
      
      private function onclick() : void
      {
         this.removeFromParent(true);
         if(FightingConfig.isLvUp)
         {
            PlayerUpdateUI.getInstance().show();
         }
      }
      
      public function show(param1:int, param2:int, param3:Vector.<PropVO>) : void
      {
         var _loc4_:* = 0;
         var _loc5_:* = null;
         silver.text = param1.toString();
         exp.text = param2.toString();
         if(param3 && param3.length > 0)
         {
            spr_mopUpBg.getTextField("getPropTF").visible = true;
            _loc4_ = 0;
            while(_loc4_ < param3.length)
            {
               _loc5_ = new DropPropUnitUI();
               _loc5_.x = _loc4_ * 138;
               _loc5_.myPropVo = param3[_loc4_];
               panel.addChild(_loc5_);
               _loc4_++;
            }
         }
         else
         {
            spr_mopUpBg.getTextField("getPropTF").visible = false;
         }
         ((Facade.getInstance().retrieveMediator("MainMapWinMedia") as MainAdventureWinMedia).UI as MainAdventureWinUI).addChild(this);
      }
   }
}
