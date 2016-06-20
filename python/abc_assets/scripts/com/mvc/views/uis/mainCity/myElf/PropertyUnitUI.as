package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.components.feathers.FeathersButton;
   import starling.display.Image;
   import com.mvc.models.vos.elf.ElfVO;
   import lzm.starling.swf.display.SwfImage;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.xmlVOHandler.GetElfFromSever;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   import com.common.themes.Tips;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.events.EventCenter;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.myElf.MyElfPro;
   import starling.events.Event;
   
   public class PropertyUnitUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_propertyBg:SwfSprite;
      
      private var propertyName:TextField;
      
      private var propertyLv:TextField;
      
      private var silver:TextField;
      
      public var btn_propertyUpgrade:FeathersButton;
      
      private var img_skillBg:Image;
      
      public var _elfVo:ElfVO;
      
      private var statusArr:Array;
      
      public var index:int;
      
      private var propertyValue:TextField;
      
      private var upValue:TextField;
      
      private var statuValueArr:Array;
      
      private var diamondIcon:SwfImage;
      
      private var silverIcon:SwfImage;
      
      public function PropertyUnitUI()
      {
         statusArr = ["HP","物攻","物防","特攻","特防","速度"];
         statuValueArr = [];
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         spr_propertyBg = swf.createSprite("spr_propertyBg");
         propertyName = spr_propertyBg.getTextField("propertyName");
         propertyLv = spr_propertyBg.getTextField("propertyLv");
         silver = spr_propertyBg.getTextField("sliver");
         btn_propertyUpgrade = spr_propertyBg.getChildByName("btn_propertyUpgrade") as FeathersButton;
         diamondIcon = spr_propertyBg.getImage("diamondIcon");
         silverIcon = spr_propertyBg.getImage("silverIcon");
         propertyValue = spr_propertyBg.getTextField("propertyValue");
         upValue = spr_propertyBg.getTextField("upValue");
         addChild(spr_propertyBg);
      }
      
      public function set statusVO(param1:ElfVO) : void
      {
         _elfVo = param1;
         getElfStatusValue(_elfVo);
         propertyName.text = statusArr[index];
         propertyLv.text = "等级" + _elfVo.individual[index] * 2;
         switchMode();
         propertyValue.text = statuValueArr[index];
         var _loc3_:ElfVO = GetElfFromSever.copyElf(_elfVo);
         _loc3_.individual[index] = _loc3_.individual[index] + 0.5;
         CalculatorFactor.calculatorElf(_loc3_);
         var _loc2_:int = statuValueArr[index];
         getElfStatusValue(_loc3_);
         upValue.text = "(" + (statuValueArr[index] - _loc2_);
         if(_elfVo.individual[index] >= 30)
         {
            showTips();
         }
         else
         {
            btn_propertyUpgrade.addEventListener("triggered",upGrade);
         }
      }
      
      private function getElfStatusValue(param1:ElfVO) : void
      {
         statuValueArr = [];
         statuValueArr.push(param1.totalHp,param1.attack,param1.defense,param1.super_attack,param1.super_defense,param1.speed);
      }
      
      private function upGrade() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         if(propertyLv.text == "等级60")
         {
            return Tips.show("等级已经达到最大值");
         }
         if(_elfVo.lv < 17)
         {
            Tips.show("精灵等级达到17级开放");
            return;
         }
         if(ElfIndividualUI.getInstance().isSilverMode)
         {
            if(ElfIndividualUI.getInstance().remainSkillPoint < 1)
            {
               if(ElfIndividualUI.getInstance().buyTimes <= 0)
               {
                  Tips.show("亲，今天购买个体值点数次数已用完了。");
                  return;
               }
               _loc1_ = "<font size=\'19\'>亲，个体值点数不足，是否花费" + ElfIndividualUI.getInstance().buyTimesCost + "钻购买10点个体值点数？</font>\n<font size=\'19\' color=\'#1c6b04\'>(剩余购买次数" + ElfIndividualUI.getInstance().buyTimes + "次, " + "提高VIP等级可以增加购买次数)</font>";
               _loc2_ = Alert.show(_loc1_,"",new ListCollection([{"label":"购买"},{"label":"太客气了"}]));
               _loc2_.addEventListener("close",buySkillDotAlert_closeHandler);
               return;
            }
            if(PlayerVO.silver < silver.text)
            {
               Tips.show("亲，金币不足哦。");
               return;
            }
         }
         else if(PlayerVO.diamond < silver.text)
         {
            return Tips.show("亲，钻石不足");
         }
         if(_elfVo.individual[index] * 2 >= _elfVo.lv)
         {
            Tips.show("亲，个体值等级不能超过精灵等级哦");
            return;
         }
         EventCenter.addEventListener("UPGRADE_INDIVIDUAL_SUCCESS",upgradeOK);
         (Facade.getInstance().retrieveProxy("MyElfPro") as MyElfPro).write2024(_elfVo.id,index,ElfIndividualUI.getInstance().isSilverMode);
      }
      
      private function upgradeOK(param1:Event) : void
      {
         EventCenter.removeEventListener("UPGRADE_INDIVIDUAL_SUCCESS",upgradeOK);
         var _loc2_:Object = param1.data as Object;
         ElfIndividualUI.getInstance().updateBuySkillInfo(_loc2_);
         ElfIndividualUI.getInstance().updateSkillPointTf(_loc2_.skillDot,_loc2_.skillDotReTime);
         var _loc3_:* = index;
         var _loc4_:* = _elfVo.individual[_loc3_] + 0.5;
         _elfVo.individual[_loc3_] = _loc4_;
         CalculatorFactor.calculatorElf(_elfVo);
         statusVO = _elfVo;
         Facade.getInstance().sendNotification("UPDATA_MYELF");
      }
      
      private function buySkillDotAlert_closeHandler(param1:Event) : void
      {
         if(param1.data.label == "购买")
         {
            if(PlayerVO.diamond >= ElfIndividualUI.getInstance().buyTimesCost)
            {
               (Facade.getInstance().retrieveProxy("MyElfPro") as MyElfPro).write2027();
            }
            else
            {
               Tips.show("亲，钻石不足哦");
            }
         }
      }
      
      private function showTips() : void
      {
         LogUtil("个体值已满");
         btn_propertyUpgrade.visible = false;
         silverIcon.visible = false;
         diamondIcon.visible = false;
         silver.visible = false;
         spr_propertyBg.getImage("upImg").visible = false;
         spr_propertyBg.getImage("numbg").visible = false;
         spr_propertyBg.getTextField("rightP").visible = false;
         upValue.visible = false;
         propertyValue.x = propertyValue.x + 35;
         propertyLv.x = propertyLv.x + 40;
         var _loc1_:TextField = new TextField(250,40,"等级达到最大值","FZCuYuan-M03S",26,10066329);
         _loc1_.hAlign = "center";
         _loc1_.touchable = false;
         _loc1_.x = 140;
         _loc1_.y = 40;
         spr_propertyBg.addChild(_loc1_);
      }
      
      public function switchMode() : void
      {
         LogUtil("切换模式");
         if(_elfVo.individual[index] < 30)
         {
            silverIcon.visible = ElfIndividualUI.getInstance().isSilverMode;
            diamondIcon.visible = !ElfIndividualUI.getInstance().isSilverMode;
         }
         if(ElfIndividualUI.getInstance().isSilverMode)
         {
            silver.text = (_elfVo.individual[index] * 2 + 1) * 1000;
         }
         else
         {
            silver.text = Math.round((_elfVo.individual[index] * 2 + 1) * 1000 / 800);
         }
         if(_elfVo.elfId > 20000)
         {
            silver.text = silver.text * 13;
         }
      }
   }
}
