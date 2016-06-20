package com.mvc.views.uis.mainCity.amuse
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.Image;
   import com.common.managers.ElfFrontImageManager;
   import extend.SoundEvent;
   import com.common.managers.LoadOtherAssetsManager;
   import starling.animation.Tween;
   import starling.core.Starling;
   import com.mvc.models.vos.elf.SkillVO;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class AmuseElfInfoUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_oneBg:SwfSprite;
      
      public var btn_oneClose:SwfButton;
      
      private var pk_name:TextField;
      
      private var elfDecs:TextField;
      
      private var lv:TextField;
      
      private var pk_rare:TextField;
      
      private var pk_nature:TextField;
      
      private var tall:TextField;
      
      private var heavy:TextField;
      
      private var pk_hp:TextField;
      
      private var pk_speed:TextField;
      
      private var attack:TextField;
      
      private var super_attack:TextField;
      
      private var defense:TextField;
      
      private var spuer_defense:TextField;
      
      private var nextExp:TextField;
      
      private var exp:TextField;
      
      private var skill0:TextField;
      
      private var skill1:TextField;
      
      private var skill2:TextField;
      
      private var skill3:TextField;
      
      private var _elfVO:ElfVO;
      
      public var btn_sePetName:SwfButton;
      
      private var image:Image;
      
      private var totalhp:TextField;
      
      public var skillBgVec:Vector.<Image>;
      
      public var skillTfVec:Vector.<TextField>;
      
      public function AmuseElfInfoUI()
      {
         skillBgVec = new Vector.<Image>([]);
         skillTfVec = new Vector.<TextField>([]);
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("amuse");
         var _loc1_:Image = swf.createImage("img_amuseBg");
         spr_oneBg = swf.createSprite("spr_oneBg");
         spr_oneBg.addChildAt(_loc1_,0);
         btn_oneClose = spr_oneBg.getButton("btn_oneClose");
         btn_sePetName = spr_oneBg.getButton("btn_sePetName");
         btn_sePetName.name = "btn_sePetName";
         elfDecs = spr_oneBg.getTextField("elfDecs");
         pk_name = spr_oneBg.getTextField("pk_name");
         lv = spr_oneBg.getTextField("lv");
         pk_rare = spr_oneBg.getTextField("pk_rare");
         pk_nature = spr_oneBg.getTextField("pk_nature");
         tall = spr_oneBg.getTextField("tall");
         heavy = spr_oneBg.getTextField("heavy");
         pk_hp = spr_oneBg.getTextField("pk_hp");
         totalhp = spr_oneBg.getTextField("totalhp");
         pk_speed = spr_oneBg.getTextField("pk_speed");
         attack = spr_oneBg.getTextField("attack");
         super_attack = spr_oneBg.getTextField("super_attack");
         defense = spr_oneBg.getTextField("defense");
         spuer_defense = spr_oneBg.getTextField("spuer_defense");
         exp = spr_oneBg.getTextField("exp");
         nextExp = spr_oneBg.getTextField("nextExp");
         spr_oneBg.x = 1136 - spr_oneBg.width >> 1;
         spr_oneBg.y = 640 - spr_oneBg.height >> 1;
         addChild(spr_oneBg);
      }
      
      public function set myElfVO(param1:ElfVO) : void
      {
         _elfVO = param1;
         if(image != null)
         {
            ElfFrontImageManager.getInstance().disposeImg(image);
         }
         ElfFrontImageManager.getInstance().getImg([param1.imgName],showEfImage);
      }
      
      private function showEfImage() : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc5_:* = null;
         LogUtil("扭蛋机显示精灵详细信息，精灵名字：" + _elfVO.name);
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","elf" + _elfVO.sound);
         image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(_elfVO.imgName));
         image.alignPivot();
         image.x = 580;
         image.y = 220;
         spr_oneBg.addChild(image);
         var _loc1_:Tween = new Tween(image,0.4,"easeInOut");
         Starling.juggler.add(_loc1_);
         _loc1_.animate("alpha",1,0);
         _loc1_.animate("scaleX",1,3);
         _loc1_.animate("scaleY",1,3);
         elfDecs.text = _elfVO.descr;
         elfDecs.vAlign = "top";
         pk_name.text = _elfVO.name;
         lv.text = _elfVO.lv;
         pk_rare.text = _elfVO.rare;
         pk_nature.text = _elfVO.nature[0];
         tall.text = _elfVO.tall;
         heavy.text = _elfVO.heavy;
         pk_hp.text = _elfVO.currentHp;
         totalhp.text = _elfVO.totalHp;
         pk_speed.text = _elfVO.speed;
         attack.text = _elfVO.attack;
         super_attack.text = _elfVO.super_attack;
         defense.text = _elfVO.defense;
         spuer_defense.text = _elfVO.super_defense;
         exp.text = Math.round(_elfVO.currentExp);
         nextExp.text = Math.round(_elfVO.nextLvExp - _elfVO.currentExp);
         _loc3_ = 0;
         while(_loc3_ < _elfVO.currentSkillVec.length)
         {
            _loc2_ = _elfVO.currentSkillVec[_loc3_];
            _loc4_ = swf.createImage("img_skillBg");
            _loc4_.x = 880;
            _loc4_.y = 110 + _loc3_ * 80;
            spr_oneBg.addChild(_loc4_);
            _loc5_ = new TextField(188,67,"","FZCuYuan-M03S",18,10084);
            _loc5_.hAlign = "center";
            _loc5_.x = 880;
            _loc5_.y = 110 + _loc3_ * 80;
            _loc5_.text = "【" + _loc2_.property + "】" + _loc2_.name + " \n            PP   " + _loc2_.currentPP + "/" + _loc2_.totalPP;
            spr_oneBg.addChild(_loc5_);
            skillBgVec.push(_loc4_);
            skillTfVec.push(_loc5_);
            _loc4_ = null;
            _loc5_ = null;
            _loc3_++;
         }
      }
      
      public function get myElfVO() : ElfVO
      {
         return _elfVO;
      }
      
      public function cleanImg() : void
      {
         if(!image)
         {
            return;
         }
         ElfFrontImageManager.getInstance().disposeImg(image);
      }
      
      public function removeSkill() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < skillBgVec.length)
         {
            skillBgVec[_loc1_].removeFromParent(true);
            skillTfVec[_loc1_].removeFromParent(true);
            _loc1_++;
         }
         skillBgVec = Vector.<Image>([]);
         skillTfVec = Vector.<TextField>([]);
      }
   }
}
