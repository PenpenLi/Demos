package com.mvc.views.uis.mainCity.home
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.display.Button;
   import starling.text.TextField;
   import starling.display.Image;
   import lzm.starling.swf.display.SwfButton;
   import com.mvc.models.vos.elf.ElfVO;
   import lzm.starling.swf.display.SwfScale9Image;
   import lzm.starling.swf.display.SwfImage;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.managers.ElfFrontImageManager;
   import com.mvc.models.vos.elf.SkillVO;
   import com.common.managers.LoadOtherAssetsManager;
   import com.mvc.views.mediator.fighting.AniFactor;
   import extend.SoundEvent;
   import starling.display.Quad;
   
   public class ElfDetailInfoUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_infopanel:SwfSprite;
      
      public var spr_shead:SwfSprite;
      
      public var info_close:Button;
      
      public var petName:TextField;
      
      public var pk_name:TextField;
      
      public var master:TextField;
      
      public var lv:TextField;
      
      public var pk_state:TextField;
      
      public var pk_nature:TextField;
      
      public var currentHp:TextField;
      
      public var pk_speed:TextField;
      
      public var attack:TextField;
      
      public var super_attack:TextField;
      
      public var defense:TextField;
      
      public var spuer_defense:TextField;
      
      public var exp:TextField;
      
      public var skill0:TextField;
      
      public var skill1:TextField;
      
      public var skill2:TextField;
      
      public var skill3:TextField;
      
      private var bigImage:Image;
      
      private var smallImage:Image;
      
      public var btn_makeFree:SwfButton;
      
      private var _elfVO:ElfVO;
      
      private var totalHp:TextField;
      
      private var spr_hp:SwfSprite;
      
      private var nextLvExp:TextField;
      
      private var hp:SwfScale9Image;
      
      private var woman:SwfImage;
      
      private var man:SwfImage;
      
      private var yellow:SwfScale9Image;
      
      private var red:SwfScale9Image;
      
      private var pk_rare:TextField;
      
      public var btn_setNiceName:SwfButton;
      
      private var loadingSwf:Swf;
      
      public function ElfDetailInfoUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         loadingSwf = LoadSwfAssetsManager.getInstance().assets.getSwf("loading");
         spr_infopanel = swf.createSprite("spr_infopanel_s");
         woman = loadingSwf.createImage("img_woman");
         man = loadingSwf.createImage("img_man");
         spr_shead = spr_infopanel.getSprite("spr_shead");
         info_close = spr_infopanel.getButton("info_close");
         petName = spr_infopanel.getTextField("petName");
         pk_name = spr_infopanel.getTextField("pk_name");
         master = spr_infopanel.getTextField("master");
         lv = spr_infopanel.getTextField("lv");
         pk_state = spr_infopanel.getTextField("pk_state");
         pk_nature = spr_infopanel.getTextField("pk_nature");
         pk_rare = spr_infopanel.getTextField("pk_rare");
         currentHp = spr_infopanel.getTextField("currentHp");
         totalHp = spr_infopanel.getTextField("totalHp");
         pk_speed = spr_infopanel.getTextField("pk_speed");
         attack = spr_infopanel.getTextField("attack");
         super_attack = spr_infopanel.getTextField("super_attack");
         defense = spr_infopanel.getTextField("defense");
         spuer_defense = spr_infopanel.getTextField("spuer_defense");
         exp = spr_infopanel.getTextField("exp");
         nextLvExp = spr_infopanel.getTextField("nextLvExp");
         skill0 = spr_infopanel.getTextField("skill_one");
         skill1 = spr_infopanel.getTextField("skill_two");
         skill2 = spr_infopanel.getTextField("skill_three");
         skill3 = spr_infopanel.getTextField("skill_four");
         btn_makeFree = spr_infopanel.getButton("btn_free");
         btn_setNiceName = spr_infopanel.getButton("btn_setNiceName");
         spr_hp = spr_infopanel.getSprite("hpSpr");
         hp = spr_hp.getScale9Image("hp");
         yellow = spr_hp.getScale9Image("yellow");
         red = spr_hp.getScale9Image("red");
         spr_infopanel.x = 1136 - spr_infopanel.width >> 1;
         spr_infopanel.y = 640 - spr_infopanel.height >> 1;
         addChild(spr_infopanel);
         var _loc1_:* = 63;
         man.x = _loc1_;
         woman.x = _loc1_;
         _loc1_ = 259;
         man.y = _loc1_;
         woman.y = _loc1_;
         spr_infopanel.addChild(woman);
         spr_infopanel.addChild(man);
         _loc1_ = false;
         woman.visible = _loc1_;
         man.visible = _loc1_;
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         _elfVO = param1;
         if(smallImage != null)
         {
            if(!(Config.starling.root as Game).page is HomeUI)
            {
               ElfFrontImageManager.getInstance().disposeImg(smallImage);
            }
            else
            {
               smallImage.removeFromParent(true);
            }
         }
         ElfFrontImageManager.getInstance().getImg([param1.imgName],showElf);
         petName.text = param1.nickName;
         pk_name.text = param1.name;
         master.text = param1.master;
         pk_rare.text = param1.rare;
         lv.text = param1.lv;
         if(param1.carryProp == null)
         {
            pk_state.text = "无";
         }
         else
         {
            pk_state.text = param1.carryProp.name;
         }
         if(param1.nature.length > 1)
         {
            pk_nature.text = param1.nature[0] + " | " + param1.nature[1];
         }
         else
         {
            pk_nature.text = param1.nature[0];
         }
         currentHp.text = param1.currentHp > 10000?param1.currentHp / 10000 + "万":param1.currentHp;
         totalHp.text = param1.totalHp > 10000?param1.totalHp / 10000 + "万":param1.totalHp;
         showHpState(param1.currentHp / param1.totalHp);
         pk_speed.text = param1.speed;
         attack.text = param1.attack;
         super_attack.text = param1.super_attack;
         defense.text = param1.defense;
         spuer_defense.text = param1.super_defense;
         exp.text = Math.round(param1.currentExp);
         nextLvExp.text = Math.round(param1.nextLvExp - param1.currentExp);
         if(param1.sex == 0)
         {
            switchSex(false);
         }
         else if(param1.sex == 1)
         {
            switchSex(true);
         }
         else
         {
            var _loc4_:* = false;
            woman.visible = _loc4_;
            man.visible = _loc4_;
         }
         _loc3_ = 0;
         while(_loc3_ < 4)
         {
            if(_loc3_ < param1.currentSkillVec.length)
            {
               _loc2_ = param1.currentSkillVec[_loc3_];
               (this["skill" + _loc3_] as TextField).text = "【" + _loc2_.property + "】" + _loc2_.name + " \n           PP   " + _loc2_.currentPP + "/" + _loc2_.totalPP;
            }
            else
            {
               (this["skill" + _loc3_] as TextField).text = "";
            }
            _loc3_++;
         }
      }
      
      private function showElf() : void
      {
         smallImage = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(_elfVO.imgName));
         ElfFrontImageManager.getInstance().autoZoom(smallImage,190,true,10);
         spr_shead.addChild(smallImage);
         AniFactor.ifOpen = true;
         AniFactor.elfAni(smallImage);
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","elf" + _elfVO.sound);
      }
      
      public function get myElfVo() : ElfVO
      {
         return _elfVO;
      }
      
      private function showHpState(param1:Number) : void
      {
         if(param1 >= 0.5)
         {
            hp.visible = true;
            var _loc2_:* = false;
            red.visible = _loc2_;
            yellow.visible = _loc2_;
            hp.scaleX = param1;
         }
         else if(param1 < 0.5 && param1 > 0.15)
         {
            yellow.visible = true;
            _loc2_ = false;
            red.visible = _loc2_;
            hp.visible = _loc2_;
            yellow.scaleX = param1;
         }
         else
         {
            red.visible = true;
            _loc2_ = false;
            yellow.visible = _loc2_;
            hp.visible = _loc2_;
            red.scaleX = param1;
         }
      }
      
      private function switchSex(param1:Boolean) : void
      {
         man.visible = param1;
         woman.visible = !param1;
      }
      
      public function cleanImg() : void
      {
         ElfFrontImageManager.getInstance().disposeImg(smallImage);
      }
   }
}
