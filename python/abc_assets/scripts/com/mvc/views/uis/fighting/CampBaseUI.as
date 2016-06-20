package com.mvc.views.uis.fighting
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import starling.display.Image;
   import lzm.starling.swf.display.SwfSprite;
   import feathers.controls.Label;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfScale9Image;
   import com.mvc.models.vos.elf.ElfVO;
   import lzm.starling.swf.display.SwfImage;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.views.mediator.fighting.StatusFactor;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class CampBaseUI extends Sprite
   {
       
      protected var swf:Swf;
      
      public var elf:Image;
      
      public var statusBar:SwfSprite;
      
      public var elfNameTF:Label;
      
      public var lvTF:TextField;
      
      public var sexIcon:Image;
      
      public var hpBar:SwfScale9Image;
      
      public var GhpBar:SwfScale9Image;
      
      public var YhpBar:SwfScale9Image;
      
      public var RhpBar:SwfScale9Image;
      
      protected var _elfVO:ElfVO;
      
      public var moveRange:int;
      
      public var showElfNum:Sprite;
      
      protected var sexImage:Image;
      
      protected var statusSpr:SwfSprite;
      
      public var shadow:SwfImage;
      
      public var elfBall:SwfImage;
      
      public var landStar:int = 0;
      
      public var statusX:int;
      
      public var currentHpTf:TextField;
      
      protected var totalHpTf:TextField;
      
      protected var brokenColor:Array;
      
      protected var brokenStr:Array;
      
      public function CampBaseUI()
      {
         brokenColor = ["#ffffff","#42e549","#42e549","#42e549","#56bcf7","#56bcf7","#56bcf7","#d792ff","#d792ff","#d792ff","#fb9a44","#fb9a44","#fb9a44","#fb9a44","#fb9a44"];
         brokenStr = ["","","+1","+2","","+1","+2","","+1","+2","","+1","+2","+3"," Max"];
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("fighting");
         showElfNum = swf.createSprite("spr_showNumBg_s");
         statusSpr = swf.createSprite("spr_statusInfo_s");
         statusSpr.addEventListener("touch",introduceHandler);
      }
      
      private function introduceHandler(param1:TouchEvent) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = 0;
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.phase == "began")
         {
            _loc4_ = statusSpr.getTextField("stateTf").text;
            _loc3_ = StatusFactor.status.indexOf(_loc4_);
            Alert.show(_loc4_ + "状态\n<font size=\'22\' color=\'#1c6b04\'>" + StatusFactor.statusIntroduce[_loc3_] + "</font>","",new ListCollection([{"label":"我知道啦"}]));
         }
      }
      
      public function get myVO() : ElfVO
      {
         return _elfVO;
      }
      
      public function disposeMc() : void
      {
      }
   }
}
