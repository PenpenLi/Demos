package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.models.vos.elf.ElfVO;
   
   public class ElfSpeciesTipsUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.myElf.ElfSpeciesTipsUI;
       
      private var swf:Swf;
      
      private var spr_species:SwfSprite;
      
      private var tf_totalNum:TextField;
      
      private var tf_hpNum:TextField;
      
      private var tf_sdNum:TextField;
      
      private var tf_wgNum:TextField;
      
      private var tf_wfNum:TextField;
      
      private var tf_tgNum:TextField;
      
      private var tf_tfNum:TextField;
      
      private var bg:Quad;
      
      public function ElfSpeciesTipsUI()
      {
         super();
         init();
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.myElf.ElfSpeciesTipsUI
      {
         return instance || new com.mvc.views.uis.mainCity.myElf.ElfSpeciesTipsUI();
      }
      
      private function init() : void
      {
         bg = new Quad(1136,640,0);
         bg.alpha = 0.7;
         addChild(bg);
         bg.addEventListener("touch",bg_touchHandler);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         spr_species = swf.createSprite("spr_species");
         spr_species.x = 1136 - spr_species.width >> 1;
         spr_species.y = 640 - spr_species.height >> 1;
         addChild(spr_species);
         tf_totalNum = spr_species.getTextField("tf_totalNum");
         tf_hpNum = spr_species.getTextField("tf_hpNum");
         tf_sdNum = spr_species.getTextField("tf_sdNum");
         tf_wgNum = spr_species.getTextField("tf_wgNum");
         tf_wfNum = spr_species.getTextField("tf_wfNum");
         tf_tgNum = spr_species.getTextField("tf_tgNum");
         tf_tfNum = spr_species.getTextField("tf_tfNum");
      }
      
      private function bg_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            this.removeFromParent();
         }
      }
      
      public function showSpecies(param1:ElfVO) : void
      {
         (Config.starling.root as Game).addChild(this);
         tf_totalNum.text = param1.zzTotal;
         tf_hpNum.text = param1.speciesHp;
         tf_sdNum.text = param1.speciesSpeed;
         tf_wgNum.text = param1.speciesAttack;
         tf_wfNum.text = param1.speciesDefense;
         tf_tgNum.text = param1.speciesSuper_attack;
         tf_tfNum.text = param1.speciesSpuer_defense;
      }
      
      public function removeSelf() : void
      {
         if(instance)
         {
            this.removeFromParent(true);
            instance = null;
         }
      }
   }
}
