package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import com.mvc.models.vos.elf.ElfVO;
   import flash.utils.Timer;
   import feathers.controls.List;
   import lzm.starling.swf.display.SwfButton;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.DisposeDisplay;
   import feathers.data.ListCollection;
   import flash.events.TimerEvent;
   import lzm.util.TimeUtil;
   
   public class ElfIndividualUI extends Sprite
   {
      
      private static var instance:com.mvc.views.uis.mainCity.myElf.ElfIndividualUI;
       
      private var swf:Swf;
      
      private var spr_individual:SwfSprite;
      
      private var tf_skillPoint:TextField;
      
      private var tf_countDown:TextField;
      
      private var machineSkil:int;
      
      public var _elfVO:ElfVO;
      
      public var remainSkillPoint:int;
      
      public var countDown:int;
      
      private var countDownTimer:Timer;
      
      public var isSkillUpSure:Boolean;
      
      public var buyTimesCost:int;
      
      public var buyTimes:int;
      
      private var skillList:List;
      
      public var isSilverMode:Boolean = true;
      
      private var spr_silverBug:SwfSprite;
      
      private var btn_diaBug:SwfButton;
      
      private var spr_diaBug:SwfSprite;
      
      private var btn_silverBug:SwfButton;
      
      private var displayVec:Vector.<DisplayObject>;
      
      public function ElfIndividualUI()
      {
         displayVec = new Vector.<DisplayObject>([]);
         super();
         init();
         addList();
         switchMode();
         this.addEventListener("triggered",modeSwitch);
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.myElf.ElfIndividualUI
      {
         return instance || new com.mvc.views.uis.mainCity.myElf.ElfIndividualUI();
      }
      
      private function modeSwitch(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(btn_diaBug !== _loc2_)
         {
            if(btn_silverBug === _loc2_)
            {
               isSilverMode = true;
               switchMode();
               updateMode();
            }
         }
         else
         {
            isSilverMode = false;
            switchMode();
            updateMode();
         }
      }
      
      private function updateMode() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < displayVec.length)
         {
            displayVec[_loc1_].switchMode();
            _loc1_++;
         }
      }
      
      private function addList() : void
      {
         skillList = new List();
         skillList.x = 9;
         skillList.y = 145;
         skillList.width = 500;
         skillList.height = 447;
         skillList.isSelectable = false;
         skillList.itemRendererProperties.stateToSkinFunction = null;
         skillList.itemRendererProperties.paddingTop = 3;
         skillList.itemRendererProperties.paddingBottom = 3;
         spr_individual.addChild(skillList);
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         spr_individual = swf.createSprite("spr_individual");
         spr_silverBug = spr_individual.getSprite("spr_silverBug");
         tf_skillPoint = spr_silverBug.getTextField("skillPoint");
         tf_countDown = spr_silverBug.getTextField("tf_countDown");
         btn_diaBug = spr_silverBug.getButton("btn_diaBug");
         spr_diaBug = spr_individual.getSprite("spr_diaBug");
         btn_silverBug = spr_diaBug.getButton("btn_silverBug");
         tf_countDown.visible = false;
         addChild(spr_individual);
         countDownTimer = new Timer(1000);
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         var _loc4_:* = 0;
         var _loc5_:* = null;
         isSkillUpSure = false;
         _elfVO = param1;
         var _loc2_:Array = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         _loc4_ = 0;
         while(_loc4_ < _elfVO.individual.length)
         {
            _loc5_ = new PropertyUnitUI();
            _loc5_.index = _loc4_;
            _loc5_.statusVO = _elfVO;
            _loc2_.push({
               "icon":_loc5_,
               "label":""
            });
            displayVec.push(_loc5_);
            _loc4_++;
         }
         var _loc3_:ListCollection = new ListCollection(_loc2_);
         skillList.dataProvider = _loc3_;
      }
      
      public function updateSkillPointTf(param1:int, param2:int) : void
      {
         remainSkillPoint = param1;
         countDown = param2;
         tf_skillPoint.text = "个体值点数量:" + param1 + "/10";
         if(param1 < 10 && param2 > 0)
         {
            tf_countDown.visible = true;
            countDownTimer.addEventListener("timer",timerHandler);
            countDownTimer.start();
         }
         else
         {
            stopTimer();
         }
      }
      
      protected function timerHandler(param1:TimerEvent) : void
      {
         countDown = countDown - 1;
         if(countDown >= 0)
         {
            tf_countDown.text = TimeUtil.convertStringToDate(countDown);
         }
         else
         {
            remainSkillPoint = §§dup(remainSkillPoint + 1);
            if(remainSkillPoint + 1 < 10)
            {
               countDown = 300;
               tf_skillPoint.text = "个体值点数量:" + remainSkillPoint + "/10";
            }
            else
            {
               tf_skillPoint.text = "个体值点数量:" + remainSkillPoint + "/10";
               stopTimer();
            }
         }
      }
      
      public function stopTimer() : void
      {
         tf_countDown.visible = false;
         countDownTimer.stop();
         countDownTimer.removeEventListener("timer",timerHandler);
      }
      
      public function updateBuySkillInfo(param1:Object) : void
      {
         if(param1.buyTimes)
         {
            buyTimes = param1.buyTimes;
         }
         if(param1.buyTimesCost)
         {
            buyTimesCost = param1.buyTimesCost;
         }
      }
      
      public function switchMode() : void
      {
         spr_silverBug.visible = isSilverMode;
         spr_diaBug.visible = !isSilverMode;
      }
   }
}
