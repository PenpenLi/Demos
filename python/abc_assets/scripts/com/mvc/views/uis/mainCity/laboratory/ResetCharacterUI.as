package com.mvc.views.uis.mainCity.laboratory
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import starling.display.Image;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.managers.LoadSwfAssetsManager;
   import lzm.starling.swf.Swf;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.common.managers.ELFMinImageManager;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.views.uis.mainCity.backPack.SelectElfUI;
   
   public class ResetCharacterUI extends Sprite
   {
       
      public var spr_character:SwfSprite;
      
      public var spr_addElf:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var btn_previewCharacter:SwfButton;
      
      public var btn_changeCharacter:SwfButton;
      
      public var btn_addElfBtn:SwfButton;
      
      private var tf_nickName:TextField;
      
      private var tf_lv:TextField;
      
      private var tf_propNum:TextField;
      
      private var tf_preCharacter:TextField;
      
      private var tf_preHp:TextField;
      
      private var tf_preAtk:TextField;
      
      private var tf_preDef:TextField;
      
      private var tf_preSpA:TextField;
      
      private var tf_preSpD:TextField;
      
      private var tf_preSpE:TextField;
      
      private var tf_newCharacter:TextField;
      
      private var tf_newHp:TextField;
      
      private var tf_newAtk:TextField;
      
      private var tf_newDef:TextField;
      
      private var tf_newSpA:TextField;
      
      private var tf_newSpD:TextField;
      
      private var tf_newSpE:TextField;
      
      private var tf_hpChange:TextField;
      
      private var tf_atkChange:TextField;
      
      private var tf_defChange:TextField;
      
      private var tf_spAChange:TextField;
      
      private var tf_spDChange:TextField;
      
      private var tf_spEChange:TextField;
      
      private var elfImage:Image;
      
      public var propVO:PropVO;
      
      private var _elfVO:ElfVO;
      
      public function ResetCharacterUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc1_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("laboratory");
         spr_character = _loc1_.createSprite("spr_character");
         spr_character.x = 340;
         spr_character.y = 120;
         addChild(spr_character);
         spr_addElf = spr_character.getSprite("spr_addElf");
         btn_close = spr_character.getButton("btn_close");
         btn_close.visible = false;
         btn_previewCharacter = spr_character.getButton("btn_previewCharacter");
         btn_changeCharacter = spr_character.getButton("btn_changeCharacter");
         btn_addElfBtn = spr_addElf.getButton("btn_addElfBtn");
         tf_nickName = spr_character.getTextField("tf_nickName");
         tf_lv = spr_character.getTextField("tf_lv");
         tf_propNum = spr_character.getTextField("tf_propNum");
         propVO = GetPropFactor.getProp(765);
         updatePropNum();
         tf_preCharacter = spr_character.getTextField("tf_preCharacter");
         tf_preCharacter.text = "";
         tf_preHp = spr_character.getTextField("tf_preHp");
         tf_preAtk = spr_character.getTextField("tf_preAtk");
         tf_preDef = spr_character.getTextField("tf_preDef");
         tf_preSpA = spr_character.getTextField("tf_preSpA");
         tf_preSpD = spr_character.getTextField("tf_preSpD");
         tf_preSpE = spr_character.getTextField("tf_preSpE");
         tf_newCharacter = spr_character.getTextField("tf_newCharacter");
         tf_newCharacter.text = "?";
         tf_newHp = spr_character.getTextField("tf_newHp");
         tf_newAtk = spr_character.getTextField("tf_newAtk");
         tf_newDef = spr_character.getTextField("tf_newDef");
         tf_newSpA = spr_character.getTextField("tf_newSpA");
         tf_newSpD = spr_character.getTextField("tf_newSpD");
         tf_newSpE = spr_character.getTextField("tf_newSpE");
         tf_hpChange = spr_character.getTextField("tf_hpChange");
         tf_atkChange = spr_character.getTextField("tf_atkChange");
         tf_defChange = spr_character.getTextField("tf_defChange");
         tf_spAChange = spr_character.getTextField("tf_spAChange");
         tf_spDChange = spr_character.getTextField("tf_spDChange");
         tf_spEChange = spr_character.getTextField("tf_spEChange");
      }
      
      public function myElfVO(param1:ElfVO) : void
      {
         _elfVO = param1;
         if(elfImage)
         {
            elfImage.removeFromParent(true);
            elfImage = null;
         }
         elfImage = ELFMinImageManager.getElfM(param1.imgName);
         elfImage.addEventListener("touch",elfImage_touchHandler);
         spr_addElf.addChild(elfImage);
         tf_nickName.text = "昵称：" + param1.nickName;
         tf_lv.text = "等级：" + param1.lv;
         tf_preCharacter.text = param1.character;
         tf_preHp.text = param1.totalHp;
         tf_preAtk.text = param1.attack;
         tf_preDef.text = param1.defense;
         tf_preSpA.text = param1.super_attack;
         tf_preSpD.text = param1.super_defense;
         tf_preSpE.text = param1.speed;
         tf_newCharacter.text = "?";
         tf_newHp.text = "?";
         tf_newAtk.text = "?";
         tf_newDef.text = "?";
         tf_newSpA.text = "?";
         tf_newSpD.text = "?";
         tf_newSpE.text = "?";
         tf_hpChange.text = "(--)";
         tf_hpChange.color = 3355443;
         tf_atkChange.text = "(--)";
         tf_atkChange.color = 3355443;
         tf_defChange.text = "(--)";
         tf_defChange.color = 3355443;
         tf_spAChange.text = "(--)";
         tf_spAChange.color = 3355443;
         tf_spDChange.text = "(--)";
         tf_spDChange.color = 3355443;
         tf_spEChange.text = "(--)";
         tf_spEChange.color = 3355443;
      }
      
      private function elfImage_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(elfImage);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            seleElf();
            elfImage.removeEventListener("touch",elfImage_touchHandler);
         }
      }
      
      public function seleElf() : void
      {
         SelectElfUI.getIntance().createSeleElf();
         SelectElfUI.getIntance().title.text = "选择需要洗炼性格的精灵";
         this;
         addChild(SelectElfUI.getIntance());
      }
      
      public function updatePropNum() : void
      {
         if(propVO)
         {
            tf_propNum.text = propVO.count;
         }
         else
         {
            tf_propNum.text = "0";
         }
      }
      
      public function updateAttributeTf(param1:ElfVO) : void
      {
         tf_preCharacter.text = _elfVO.character;
         tf_preHp.text = _elfVO.totalHp;
         tf_preAtk.text = _elfVO.attack;
         tf_preDef.text = _elfVO.defense;
         tf_preSpA.text = _elfVO.super_attack;
         tf_preSpD.text = _elfVO.super_defense;
         tf_preSpE.text = _elfVO.speed;
         tf_newCharacter.text = param1.character;
         tf_newHp.text = param1.totalHp;
         tf_newAtk.text = param1.attack;
         tf_newDef.text = param1.defense;
         tf_newSpA.text = param1.super_attack;
         tf_newSpD.text = param1.super_defense;
         tf_newSpE.text = param1.speed;
         tf_hpChange.text = tf_newHp.text - tf_preHp.text != 0?tf_newHp.text - tf_preHp.text:"(--)";
         tf_atkChange.text = tf_newAtk.text - tf_preAtk.text != 0?tf_newAtk.text - tf_preAtk.text:"(--)";
         tf_defChange.text = tf_newDef.text - tf_preDef.text != 0?tf_newDef.text - tf_preDef.text:"(--)";
         tf_spAChange.text = tf_newSpA.text - tf_preSpA.text != 0?tf_newSpA.text - tf_preSpA.text:"(--)";
         tf_spDChange.text = tf_newSpD.text - tf_preSpD.text != 0?tf_newSpD.text - tf_preSpD.text:"(--)";
         tf_spEChange.text = tf_newSpE.text - tf_preSpE.text != 0?tf_newSpE.text - tf_preSpE.text:"(--)";
         setTfColor(tf_hpChange);
         setTfColor(tf_atkChange);
         setTfColor(tf_defChange);
         setTfColor(tf_spAChange);
         setTfColor(tf_spDChange);
         setTfColor(tf_spEChange);
         _elfVO = param1;
      }
      
      private function setTfColor(param1:TextField) : void
      {
         if(param1.text < 0)
         {
            param1.color = 11534336;
         }
         else if(param1.text > 0)
         {
            param1.color = 32085;
         }
         else
         {
            param1.color = 3355443;
         }
      }
   }
}
