package com.mvc.views.uis.mainCity.backPack
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import com.mvc.models.vos.elf.ElfVO;
   import feathers.controls.Label;
   import com.common.managers.LoadSwfAssetsManager;
   import flash.text.TextFormat;
   import com.mvc.models.vos.elf.SkillVO;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import org.puremvc.as3.patterns.facade.Facade;
   import starling.display.Quad;
   
   public class SkillPanelUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_skillBg:SwfSprite;
      
      public var btn_close:SwfButton;
      
      private var skill0:TextField;
      
      private var skill1:TextField;
      
      private var skill2:TextField;
      
      private var skill3:TextField;
      
      private var _elfVO:ElfVO;
      
      public var prompt:Label;
      
      public var tips:TextField;
      
      public function SkillPanelUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("bag");
         spr_skillBg = swf.createSprite("spr_skillBg");
         btn_close = spr_skillBg.getButton("btn_close");
         skill0 = spr_skillBg.getTextField("skill0");
         skill1 = spr_skillBg.getTextField("skill1");
         skill2 = spr_skillBg.getTextField("skill2");
         skill3 = spr_skillBg.getTextField("skill3");
         tips = spr_skillBg.getTextField("tipsTf");
         spr_skillBg.x = 1136 - spr_skillBg.width >> 1;
         spr_skillBg.y = 640 - spr_skillBg.height >> 1;
         addChild(spr_skillBg);
         prompt = getLabel();
      }
      
      public function propmt() : void
      {
         prompt.y = 80;
         prompt.text = "<font color=\'#B94600\' size=\'25\'>            要恢复哪项技能？ </font>";
      }
      
      private function getLabel() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.x = 70;
         _loc1_.textRendererProperties.wordWrap = false;
         _loc1_.textRendererProperties.isHTML = true;
         _loc1_.textRendererProperties.textFormat = new TextFormat("FZCuYuan-M03S",30,9713664,true);
         spr_skillBg.addChild(_loc1_);
         return _loc1_;
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         _elfVO = param1;
         _loc3_ = 0;
         while(_loc3_ < 4)
         {
            if(_loc3_ < param1.currentSkillVec.length)
            {
               _loc2_ = param1.currentSkillVec[_loc3_];
               (this["skill" + _loc3_] as TextField).name = _loc3_.toString();
               (this["skill" + _loc3_] as TextField).text = "【" + _loc2_.property + "】" + _loc2_.name + "  \n                PP   " + _loc2_.currentPP + "/" + _loc2_.totalPP;
               (this["skill" + _loc3_] as TextField).addEventListener("touch",ontouch);
            }
            else
            {
               (this["skill" + _loc3_] as TextField).text = "";
               (this["skill" + _loc3_] as TextField).removeEventListener("touch",ontouch);
            }
            _loc3_++;
         }
      }
      
      public function get myElfVo() : ElfVO
      {
         return _elfVO;
      }
      
      private function ontouch(param1:TouchEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:Touch = param1.getTouch(param1.target as TextField);
         if(_loc3_)
         {
            if(_loc3_.phase == "began")
            {
               _loc2_ = _elfVO.currentSkillVec[(param1.target as TextField).name];
               Facade.getInstance().sendNotification("skill_pp_up",_loc2_);
               remove();
            }
         }
      }
      
      private function remove() : void
      {
         Facade.getInstance().sendNotification("switch_win",null);
         removeFromParent();
      }
   }
}
