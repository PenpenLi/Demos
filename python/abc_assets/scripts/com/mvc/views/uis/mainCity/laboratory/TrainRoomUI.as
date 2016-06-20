package com.mvc.views.uis.mainCity.laboratory
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import feathers.core.ToggleGroup;
   import feathers.controls.Radio;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.Image;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.views.uis.mainCity.information.RadioUnitUI;
   import starling.events.Event;
   import com.common.managers.ElfFrontImageManager;
   import com.mvc.views.mediator.fighting.AniFactor;
   import com.common.managers.LoadOtherAssetsManager;
   import starling.display.Quad;
   
   public class TrainRoomUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_train:SwfSprite;
      
      private var spr_putElf:SwfSprite;
      
      public var btn_seleElf:SwfButton;
      
      private var elfName:TextField;
      
      private var petName:TextField;
      
      private var lv:TextField;
      
      private var spr_ability:SwfSprite;
      
      private var Attack:TextField;
      
      private var totalHp:TextField;
      
      private var Defense:TextField;
      
      private var spuer_defense:TextField;
      
      private var super_attack:TextField;
      
      private var speed:TextField;
      
      public var btn_return:SwfButton;
      
      public var btn_help:SwfButton;
      
      public var btn_train:SwfButton;
      
      public var typeGroup:ToggleGroup;
      
      public var typeRadio:Radio;
      
      private var totalHpV:TextField;
      
      private var AttackV:TextField;
      
      private var DefenseV:TextField;
      
      private var super_attackV:TextField;
      
      private var spuer_defenseV:TextField;
      
      private var speedV:TextField;
      
      private var _elfVO:ElfVO;
      
      public var image:Image;
      
      public function TrainRoomUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0;
         addChild(_loc1_);
         init();
         addRadio();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("laboratory");
         spr_train = swf.createSprite("spr_train");
         spr_putElf = spr_train.getSprite("spr_putElf");
         btn_seleElf = spr_train.getButton("btn_seleElf");
         btn_train = spr_train.getButton("btn_train");
         btn_return = spr_train.getButton("btn_return");
         btn_help = spr_train.getButton("btn_help");
         elfName = spr_train.getTextField("elfName");
         petName = spr_train.getTextField("petName");
         lv = spr_train.getTextField("lv");
         spr_ability = swf.createSprite("spr_ability_s");
         totalHp = spr_ability.getTextField("totalHp");
         Attack = spr_ability.getTextField("Attack");
         Defense = spr_ability.getTextField("Defense");
         super_attack = spr_ability.getTextField("super_attack");
         spuer_defense = spr_ability.getTextField("spuer_defense");
         speed = spr_ability.getTextField("speed");
         totalHpV = spr_ability.getTextField("totalHpV");
         AttackV = spr_ability.getTextField("AttackV");
         DefenseV = spr_ability.getTextField("DefenseV");
         super_attackV = spr_ability.getTextField("super_attackV");
         spuer_defenseV = spr_ability.getTextField("spuer_defenseV");
         speedV = spr_ability.getTextField("speedV");
         spuer_defenseV.color = 10461344;
         speedV.color = 9421599;
         spr_ability.x = 351;
         spr_ability.y = 68;
         spr_train.addChild(spr_ability);
         spr_train.x = 370;
         spr_train.y = 120;
         switchView(false);
         addChild(spr_train);
      }
      
      private function addRadio() : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = null;
         var _loc1_:ToggleGroup = new ToggleGroup();
         _loc1_.isSelectionRequired = false;
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            _loc3_ = new RadioUnitUI();
            _loc3_.y = 358;
            _loc3_.x = 126 * _loc2_ + 90;
            switch(_loc2_)
            {
               case 0:
                  _loc3_.label = "普通训练\n金币100";
                  break;
               case 1:
                  _loc3_.label = "加强训练\n钻石10";
                  break;
               case 2:
                  _loc3_.label = "白金训练\n钻石50";
                  break;
               case 3:
                  _loc3_.label = "至尊训练\n钻石100";
                  break;
            }
            _loc3_.toggleGroup = _loc1_;
            spr_train.addChild(_loc3_);
            _loc2_++;
         }
         _loc1_.addEventListener("change",typeGroup_changeHandler);
      }
      
      private function typeGroup_changeHandler(param1:Event) : void
      {
         typeGroup = ToggleGroup(param1.currentTarget);
         typeRadio = Radio(typeGroup.selectedItem);
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         _elfVO = param1;
         switchView(true);
         if(image != null)
         {
            ElfFrontImageManager.getInstance().disposeImg(image);
         }
         AniFactor.ifOpen = true;
         ElfFrontImageManager.getInstance().getImg([param1.imgName],showElf);
         elfName.text = param1.name;
         petName.text = param1.nickName;
         lv.text = param1.lv;
         totalHp.text = param1.totalHp;
         Attack.text = param1.attack;
         Defense.text = param1.defense;
         super_attack.text = param1.super_attack;
         spuer_defense.text = param1.super_defense;
         speed.text = param1.speed;
      }
      
      private function showElf() : void
      {
         image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(_elfVO.imgName));
         ElfFrontImageManager.getInstance().autoZoom(image,190,true,20);
         spr_putElf.addChild(image);
         AniFactor.elfAni(image);
      }
      
      public function switchView(param1:Boolean) : void
      {
         spr_putElf.visible = param1;
         btn_seleElf.visible = !param1;
      }
   }
}
