package com.mvc.views.uis.mainCity.laboratory
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.Image;
   import com.mvc.models.vos.elf.SkillVO;
   import feathers.controls.ScrollContainer;
   import starling.text.TextField;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.common.managers.ElfFrontImageManager;
   import com.mvc.views.mediator.fighting.AniFactor;
   import com.common.managers.LoadOtherAssetsManager;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.views.uis.mainCity.backPack.SelectElfUI;
   
   public class RecallSkillUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_recallSkill:SwfSprite;
      
      private var spr_putElf:SwfSprite;
      
      public var btn_seleElf:SwfButton;
      
      public var btn_return:SwfButton;
      
      public var btn_skillChangeBtn:SwfButton;
      
      private var _elfVO:ElfVO;
      
      public var image:Image;
      
      public var skillVec:Vector.<SkillVO>;
      
      public var ownSkillUnitSprVec:Vector.<SwfSprite>;
      
      public var repSkillUnitSprVec:Vector.<SwfSprite>;
      
      public var replaceContainer:ScrollContainer;
      
      public var ownSelectedIndex:int = -1;
      
      public var repSelectedIndex:int = -1;
      
      public var tf_propNum:TextField;
      
      public var propVO:PropVO;
      
      public function RecallSkillUI()
      {
         skillVec = new Vector.<SkillVO>([]);
         ownSkillUnitSprVec = new Vector.<SwfSprite>([]);
         repSkillUnitSprVec = new Vector.<SwfSprite>([]);
         super();
         init();
         addReplaceContainer();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("laboratory");
         spr_recallSkill = swf.createSprite("spr_recallSkill");
         spr_putElf = spr_recallSkill.getSprite("spr_putElf");
         btn_seleElf = spr_recallSkill.getButton("btn_seleElf");
         btn_skillChangeBtn = spr_recallSkill.getButton("btn_skillChangeBtn");
         btn_return = spr_recallSkill.getButton("btn_return");
         btn_return.visible = false;
         spr_recallSkill.x = 370;
         spr_recallSkill.y = 120;
         tf_propNum = spr_recallSkill.getTextField("tf_propNum");
         propVO = GetPropFactor.getProp(764);
         updatePropNum();
         switchView(false);
         addChild(spr_recallSkill);
      }
      
      private function addReplaceContainer() : void
      {
         replaceContainer = new ScrollContainer();
         replaceContainer.x = 448;
         replaceContainer.y = 78;
         replaceContainer.width = 200;
         replaceContainer.height = 330;
         replaceContainer.horizontalScrollPolicy = "off";
         spr_recallSkill.addChild(replaceContainer);
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         _elfVO = param1;
         switchView(true);
         if(image != null)
         {
            ElfFrontImageManager.getInstance().disposeImg(image);
            image = null;
         }
         AniFactor.ifOpen = true;
         ElfFrontImageManager.getInstance().getImg([param1.imgName],showElf);
         calculatorSkill(param1);
         addOwnSkill(param1);
      }
      
      private function showElf() : void
      {
         image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(_elfVO.imgName));
         ElfFrontImageManager.getInstance().autoZoom(image,190,true,20);
         spr_putElf.addChild(image);
         AniFactor.elfAni(image);
         image.addEventListener("touch",reSeleElf);
      }
      
      private function reSeleElf(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(image);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            seleElf();
         }
      }
      
      public function seleElf() : void
      {
         SelectElfUI.getIntance().createSeleElf();
         SelectElfUI.getIntance().title.text = "选择需要回忆技能的精灵";
         this;
         addChild(SelectElfUI.getIntance());
      }
      
      public function addOwnSkill(param1:ElfVO) : void
      {
         var _loc2_:* = 0;
         var _loc5_:* = 0;
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc6_:* = null;
         removeOwnSkill();
         _loc5_ = 0;
         while(_loc5_ < param1.currentSkillVec.length)
         {
            _loc4_ = getSkillUnitSpr();
            _loc3_ = _loc4_.getTextField("tf_skillName");
            _loc6_ = _loc4_.getTextField("tf_skillPP");
            _loc3_.text = "[" + param1.currentSkillVec[_loc5_].property + "]" + param1.currentSkillVec[_loc5_].name;
            _loc3_.touchable = false;
            _loc6_.text = "PP " + param1.currentSkillVec[_loc5_].currentPP + "/" + param1.currentSkillVec[_loc5_].totalPP;
            _loc6_.touchable = false;
            _loc4_.getImage("img_selectTips").visible = false;
            _loc4_.getImage("img_selectTips").touchable = false;
            _loc4_.getChildAt(0).name = "own" + _loc5_;
            spr_recallSkill.addChild(_loc4_);
            ownSkillUnitSprVec.push(_loc4_);
            if(_loc5_ % 2 == 0 && _loc5_ != 0)
            {
               _loc2_++;
            }
            _loc4_.x = _loc5_ % 2 * 200 + 30;
            _loc4_.y = _loc2_ * 75 + 270;
            _loc5_++;
         }
      }
      
      public function updateOwnSkillState() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < ownSkillUnitSprVec.length)
         {
            if(_loc1_ == ownSelectedIndex)
            {
               ownSkillUnitSprVec[_loc1_].getImage("img_selectTips").visible = true;
            }
            else
            {
               ownSkillUnitSprVec[_loc1_].getImage("img_selectTips").visible = false;
            }
            _loc1_++;
         }
      }
      
      private function removeOwnSkill() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < ownSkillUnitSprVec.length)
         {
            ownSkillUnitSprVec[_loc1_].removeFromParent(true);
            ownSkillUnitSprVec.splice(_loc1_,1);
            _loc1_--;
            _loc1_++;
         }
      }
      
      private function calculatorSkill(param1:ElfVO) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = false;
         var _loc4_:* = 0;
         skillVec = Vector.<SkillVO>([]);
         _loc3_ = 0;
         while(_loc3_ < param1.totalSkillVec.length)
         {
            if(param1.totalSkillVec[_loc3_].lvNeed <= param1.lv)
            {
               _loc2_ = true;
               _loc4_ = 0;
               while(_loc4_ < param1.currentSkillVec.length)
               {
                  if(param1.currentSkillVec[_loc4_].id == param1.totalSkillVec[_loc3_].id)
                  {
                     _loc2_ = false;
                     break;
                  }
                  _loc4_++;
               }
               if(_loc2_)
               {
                  skillVec.push(param1.totalSkillVec[_loc3_]);
               }
            }
            _loc3_++;
         }
         addRepSkill();
      }
      
      public function addRepSkill() : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         var _loc1_:* = null;
         var _loc4_:* = null;
         removeRepSkill();
         _loc3_ = 0;
         while(_loc3_ < skillVec.length)
         {
            _loc2_ = getSkillUnitSpr();
            _loc1_ = _loc2_.getTextField("tf_skillName");
            _loc4_ = _loc2_.getTextField("tf_skillPP");
            _loc1_.text = "[" + skillVec[_loc3_].property + "]" + skillVec[_loc3_].name;
            _loc1_.touchable = false;
            _loc4_.text = "PP " + skillVec[_loc3_].totalPP + "/" + skillVec[_loc3_].totalPP;
            _loc4_.touchable = false;
            _loc2_.getImage("img_selectTips").visible = false;
            _loc2_.getImage("img_selectTips").touchable = false;
            _loc2_.getChildAt(0).name = "rep" + _loc3_;
            _loc2_.y = _loc3_ * 75;
            repSkillUnitSprVec.push(_loc2_);
            replaceContainer.addChild(_loc2_);
            _loc3_++;
         }
      }
      
      public function updateRepSkillState() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < repSkillUnitSprVec.length)
         {
            if(_loc1_ == repSelectedIndex)
            {
               repSkillUnitSprVec[_loc1_].getImage("img_selectTips").visible = true;
            }
            else
            {
               repSkillUnitSprVec[_loc1_].getImage("img_selectTips").visible = false;
            }
            _loc1_++;
         }
      }
      
      private function removeRepSkill() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < repSkillUnitSprVec.length)
         {
            repSkillUnitSprVec[_loc1_].removeFromParent(true);
            repSkillUnitSprVec.splice(_loc1_,1);
            _loc1_--;
            _loc1_++;
         }
      }
      
      public function getBtn(param1:String) : SwfButton
      {
         return swf.createButton(param1);
      }
      
      public function switchView(param1:Boolean) : void
      {
         spr_putElf.visible = param1;
         btn_seleElf.visible = !param1;
      }
      
      public function getSkillUnitSpr() : SwfSprite
      {
         var _loc1_:SwfSprite = swf.createSprite("spr_skillUnit");
         return _loc1_;
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
   }
}
