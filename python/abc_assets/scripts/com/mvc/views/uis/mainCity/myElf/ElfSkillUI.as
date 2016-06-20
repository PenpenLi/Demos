package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.events.Event;
   import lzm.starling.swf.display.SwfButton;
   import com.mvc.models.vos.elf.SkillVO;
   
   public class ElfSkillUI extends Sprite
   {
      
      private static var instance:com.mvc.views.uis.mainCity.myElf.ElfSkillUI;
       
      private var swf:Swf;
      
      private var spr_skill:SwfSprite;
      
      private var skill0:SwfSprite;
      
      private var skill1:SwfSprite;
      
      private var skill2:SwfSprite;
      
      private var skill3:SwfSprite;
      
      private var prompt:TextField;
      
      private var _elfVo:ElfVO;
      
      private var skillContain:Sprite;
      
      private var machineSkil:int;
      
      public function ElfSkillUI()
      {
         super();
         init();
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.myElf.ElfSkillUI
      {
         return instance || new com.mvc.views.uis.mainCity.myElf.ElfSkillUI();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         spr_skill = swf.createSprite("spr_skill");
         prompt = spr_skill.getTextField("prompt");
         prompt.hAlign = "left";
         addChild(spr_skill);
         skillContain = new Sprite();
         skillContain.x = 20;
         skillContain.y = 100;
         addChild(skillContain);
      }
      
      private function seleSkill(param1:Event) : void
      {
         LogUtil("skillname=",(param1.target as SwfButton).name);
         var _loc2_:int = (param1.target as SwfButton).name.substring(5);
         LogUtil(_loc2_);
         mySkillVo = _elfVo.currentSkillVec[_loc2_];
      }
      
      public function set mySkillVo(param1:SkillVO) : void
      {
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         _elfVo = param1;
         skillContain.removeChildren(0,-1,true);
         machineSkil = 0;
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            if(_loc2_ < _elfVo.currentSkillVec.length)
            {
               if(_elfVo.totalSkillID.indexOf(_elfVo.currentSkillVec[_loc2_].id) == -1)
               {
                  machineSkil = machineSkil + 1;
               }
               _loc3_ = new SkillUnit(true);
               _loc3_.haveSkill = _elfVo.currentSkillVec[_loc2_];
               _loc3_.skillIndex = _loc2_;
               _loc3_.y = 100 * _loc2_;
               skillContain.addChild(_loc3_);
            }
            else
            {
               _loc4_ = new SkillUnit(false);
               if(_loc2_ < _elfVo.totalSkillVec.length)
               {
                  _loc4_.noSkill = _elfVo.totalSkillVec[_loc2_ - machineSkil];
               }
               else
               {
                  _loc4_.noSkill = null;
               }
               _loc4_.y = 102 * _loc2_;
               if(_loc2_ == _elfVo.currentSkillVec.length)
               {
                  _loc4_.y = 100 * _loc2_;
               }
               skillContain.addChild(_loc4_);
            }
            _loc2_++;
         }
      }
   }
}
