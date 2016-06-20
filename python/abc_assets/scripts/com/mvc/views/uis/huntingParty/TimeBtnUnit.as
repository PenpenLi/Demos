package com.mvc.views.uis.huntingParty
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import starling.display.Image;
   import lzm.starling.swf.display.SwfScale9Image;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfImage;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import org.puremvc.as3.patterns.facade.Facade;
   import lzm.util.TimeUtil;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.managers.ELFMinImageManager;
   import com.common.util.GetCommon;
   
   public class TimeBtnUnit extends Sprite
   {
       
      private var swf:Swf;
      
      private var icon:Image;
      
      private var event:String;
      
      private var cdBg:SwfScale9Image;
      
      private var cdTxt:TextField;
      
      private var promptImg:SwfImage;
      
      public function TimeBtnUnit(param1:int, param2:int, param3:String, param4:Sprite, param5:String, param6:int, param7:Number = 1)
      {
         super();
         event = param5;
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("huntingParty");
         if(event == "elf")
         {
            icon = ELFMinImageManager.getElfM(param3);
         }
         else
         {
            icon = swf.createImage(param3);
         }
         var _loc8_:* = param7;
         icon.scaleY = _loc8_;
         icon.scaleX = _loc8_;
         addChild(icon);
         if(param6 > 0 || event == "elf")
         {
            cdBg = GetCommon.getS9Image(5,icon.height,icon.width - 10,20,"s9_icon_sj",swf,this);
            cdTxt = GetCommon.getText(5,icon.height,cdBg.width,20,TimeUtil.convertStringToDate(param6),"FZCuYuan-M03S",15,16777215,this,false,true);
         }
         promptImg = swf.createImage("img_icon_dot");
         promptImg.visible = false;
         addChild(promptImg);
         this.x = param1;
         this.y = param2;
         param4.addChild(this);
         this.addEventListener("touch",touch);
      }
      
      private function touch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_ && _loc2_.phase == "began")
         {
            var _loc3_:* = event;
            if("elf" !== _loc3_)
            {
               if("buff" === _loc3_)
               {
                  Facade.getInstance().sendNotification("switch_win",null,"LOAD_HUNTINGBUFF_WIN");
               }
            }
            else
            {
               Facade.getInstance().sendNotification("switch_win",null,"LOAD_HUNTINGTASK_WIN");
            }
         }
      }
      
      public function updateTime(param1:int) : void
      {
         cdTxt.text = TimeUtil.convertStringToDate(param1);
      }
      
      public function isPrompt(param1:Boolean) : void
      {
         promptImg.visible = param1;
      }
   }
}
