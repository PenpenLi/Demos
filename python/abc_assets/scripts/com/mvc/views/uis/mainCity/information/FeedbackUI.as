package com.mvc.views.uis.mainCity.information
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.components.feathers.FeathersButton;
   import starling.text.TextField;
   import lzm.starling.swf.components.feathers.FeathersTextInput;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.Radio;
   import feathers.core.ToggleGroup;
   import starling.events.Event;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.information.InformationPro;
   import com.common.themes.Tips;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class FeedbackUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var ageArray:Array;
      
      private var input_down:FeathersButton;
      
      private var input_up:FeathersButton;
      
      private var listSpr:Sprite;
      
      private var ageText:TextField;
      
      private var contentInput:FeathersTextInput;
      
      public var inputTxt:TextField;
      
      private var btn_sure:SwfButton;
      
      private var sexRadio:Radio;
      
      private var typeRadio:Radio;
      
      private var typeGroup:ToggleGroup;
      
      private var sexGroup:ToggleGroup;
      
      public function FeedbackUI()
      {
         ageArray = ["0 ~ 5 岁","5 ~ 10 岁","10 ~ 15 岁","15 ~ 20 岁","20 ~ 25 岁","25 ~ 30 岁","30 ~ 35 岁","35 ~ 100 岁"];
         listSpr = new Sprite();
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("information");
         btn_sure = swf.createButton("btn_determine");
         sexSelect();
         typeSelect();
         writeContent();
         ageSelect();
      }
      
      private function writeContent() : void
      {
         var _loc1_:TextField = new TextField(50,50,"问题描述：","FZCuYuan-M03S",25,5715238);
         _loc1_.bold = true;
         _loc1_.autoSize = "horizontal";
         _loc1_.x = 20;
         _loc1_.y = 150;
         addChild(_loc1_);
         contentInput = swf.createComponent("comp_feathers_input_feedback");
         contentInput.width = 767;
         contentInput.height = 167;
         contentInput.maxChars = 500;
         contentInput.paddingLeft = 10;
         contentInput.paddingTop = 10;
         contentInput.y = 200;
         contentInput.x = 10;
         contentInput.maxChars = 150;
         addChild(contentInput);
         inputTxt = new TextField(757,157,"","FZCuYuan-M03S",25,5715237);
         inputTxt.x = contentInput.x + 10;
         inputTxt.y = contentInput.y + 10;
         inputTxt.touchable = false;
         inputTxt.autoSize = "vertical";
         inputTxt.vAlign = "top";
         inputTxt.hAlign = "left";
         addChild(inputTxt);
         btn_sure.y = 394;
         btn_sure.x = 350;
         addChild(btn_sure);
         addEventListener("triggered",onclick);
         contentInput.addEventListener("change",passOn);
      }
      
      private function passOn() : void
      {
         inputTxt.text = contentInput.text;
      }
      
      private function onclick(param1:Event) : void
      {
         if(contentInput.text != "" && input_down.label != "请选择年龄")
         {
            (Facade.getInstance().retrieveProxy("InformationPro") as InformationPro).write4205((sexGroup.selectedItem as Radio).label,input_down.label,typeGroup.selectedIndex,contentInput.text);
            contentInput.text = "";
         }
         else
         {
            Tips.show("请完善内容");
         }
      }
      
      private function addPop() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         _loc1_ = 1;
         while(_loc1_ < 749)
         {
            (Facade.getInstance().retrieveProxy("InformationPro") as InformationPro).write4205("女","0~5岁",3,"add//道具//100//" + _loc1_);
            _loc1_++;
         }
         _loc2_ = 10000;
         while(_loc2_ < 10072)
         {
            (Facade.getInstance().retrieveProxy("InformationPro") as InformationPro).write4205("女","0~5岁",3,"add//道具//100//" + _loc2_);
            _loc2_++;
         }
         _loc3_ = 100000;
         while(_loc3_ < 100075)
         {
            (Facade.getInstance().retrieveProxy("InformationPro") as InformationPro).write4205("女","0~5岁",3,"add//道具//100//" + _loc3_);
            _loc3_++;
         }
         _loc4_ = 101;
         while(_loc4_ < 118)
         {
            (Facade.getInstance().retrieveProxy("InformationPro") as InformationPro).write4205("女","0~5岁",3,"add//道具//100//" + _loc4_ + "000");
            _loc4_++;
         }
      }
      
      private function test() : void
      {
         var _loc1_:* = 0;
         (Facade.getInstance().retrieveProxy("InformationPro") as InformationPro).write4205("女","0~5岁",3,"add//等级//70");
         _loc1_ = 200;
         while(_loc1_ < 252)
         {
            (Facade.getInstance().retrieveProxy("InformationPro") as InformationPro).write4205("女","0~5岁",3,"add//精灵//1//" + _loc1_ + "//70");
            _loc1_++;
         }
      }
      
      private function ageSelect() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = null;
         ageText = new TextField(50,50,"年龄：","FZCuYuan-M03S",25,5715238);
         ageText.bold = true;
         ageText.autoSize = "horizontal";
         ageText.x = 310;
         addChild(ageText);
         input_down = swf.createComponent("comp_feathers_button_3");
         input_down.label = "请选择年龄";
         input_up = swf.createComponent("comp_feathers_button_2");
         input_up.visible = false;
         input_down.name = "down";
         input_up.name = "up";
         var _loc3_:* = 400;
         listSpr.x = _loc3_;
         _loc3_ = _loc3_;
         input_up.x = _loc3_;
         input_down.x = _loc3_;
         _loc3_ = 5;
         listSpr.y = _loc3_;
         _loc3_ = _loc3_;
         input_up.y = _loc3_;
         input_down.y = _loc3_;
         addChild(input_up);
         addChild(input_down);
         addChild(listSpr);
         _loc2_ = 0;
         while(_loc2_ < ageArray.length)
         {
            _loc1_ = swf.createComponent("comp_feathers_button_1");
            _loc1_.label = ageArray[_loc2_];
            _loc1_.name = ageArray[_loc2_].toString();
            _loc1_.y = 44 * _loc2_ + 44;
            listSpr.addChild(_loc1_);
            _loc2_++;
         }
         listSpr.visible = false;
         _loc3_ = "0~5岁";
         input_down.label = _loc3_;
         input_up.label = _loc3_;
         input_up.visible = false;
         input_down.visible = true;
         listSpr.visible = false;
         this.addEventListener("touch",click);
      }
      
      private function click(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(param1.target as FeathersButton);
         if(_loc2_)
         {
            if(_loc2_.phase == "began")
            {
               var _loc3_:* = (param1.target as FeathersButton).name;
               if("down" !== _loc3_)
               {
                  if("up" !== _loc3_)
                  {
                     _loc3_ = (param1.target as FeathersButton).name;
                     input_down.label = _loc3_;
                     input_up.label = _loc3_;
                     input_up.visible = false;
                     input_down.visible = true;
                     listSpr.visible = false;
                  }
                  else
                  {
                     input_up.visible = false;
                     input_down.visible = true;
                     listSpr.visible = false;
                  }
               }
               else
               {
                  input_up.visible = true;
                  input_down.visible = false;
                  listSpr.visible = true;
               }
            }
         }
      }
      
      private function typeSelect() : void
      {
         var _loc1_:* = 0;
         var _loc3_:* = null;
         var _loc2_:TextField = new TextField(50,50,"请选择反馈类型：","FZCuYuan-M03S",25,5715238);
         _loc2_.bold = true;
         _loc2_.autoSize = "horizontal";
         _loc2_.x = 20;
         _loc2_.y = 60;
         addChild(_loc2_);
         typeGroup = new ToggleGroup();
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc3_ = new RadioUnitUI();
            _loc3_.y = 110;
            _loc3_.x = 150 * _loc1_ + 20;
            switch(_loc1_)
            {
               case 0:
                  _loc3_.label = "游戏BUG";
                  break;
               case 1:
                  _loc3_.label = "游戏建议";
                  break;
               case 2:
                  _loc3_.label = "游戏网络";
                  break;
               case 3:
                  _loc3_.label = "其他";
                  break;
            }
            _loc3_.toggleGroup = typeGroup;
            this.addChild(_loc3_);
            _loc1_++;
         }
         typeGroup.selectedIndex = 3;
      }
      
      private function sexSelect() : void
      {
         var _loc1_:* = 0;
         var _loc3_:* = null;
         var _loc2_:TextField = new TextField(50,50,"性别：","FZCuYuan-M03S",25,5715238);
         _loc2_.autoSize = "horizontal";
         _loc2_.bold = true;
         _loc2_.x = 20;
         addChild(_loc2_);
         sexGroup = new ToggleGroup();
         _loc1_ = 0;
         while(_loc1_ < 2)
         {
            _loc3_ = new RadioUnitUI();
            _loc3_.x = 70 * _loc1_ + 100;
            _loc3_.y = 10;
            switch(_loc1_)
            {
               case 0:
                  _loc3_.label = "男";
                  break;
               case 1:
                  _loc3_.label = "女";
                  break;
            }
            _loc3_.toggleGroup = sexGroup;
            this.addChild(_loc3_);
            _loc1_++;
         }
         sexGroup.selectedIndex = 0;
      }
   }
}
