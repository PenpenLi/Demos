package com.mvc.views.uis.mainCity.Illustrations
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.util.xmlVOHandler.GetMapFactor;
   import com.common.themes.Tips;
   import starling.display.Image;
   import com.common.managers.LoadOtherAssetsManager;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class HabitatUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_habit:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var spr_mapBg:SwfSprite;
      
      private var cityArr:Array;
      
      private var decText:TextField;
      
      private var habitatObj:Object;
      
      public function HabitatUI()
      {
         super();
         var _loc1_:Image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("common"));
         var _loc2_:* = 1.515;
         _loc1_.scaleY = _loc2_;
         _loc1_.scaleX = _loc2_;
         _loc1_.y = -328;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("Illustrations");
         spr_mapBg = swf.createSprite("spr_mapBg");
         decText = spr_mapBg.getTextField("decText");
         spr_habit = spr_mapBg.getSprite("spr_habit");
         btn_close = spr_mapBg.getButton("btn_mapClose");
         spr_mapBg.x = 1136 - spr_mapBg.width >> 1;
         spr_mapBg.y = 640 - spr_mapBg.height >> 1;
         addChild(spr_mapBg);
         decText.hAlign = "center";
         decText.vAlign = "center";
      }
      
      private function init() : void
      {
         var _loc1_:* = 0;
         decText.text = "";
         _loc1_ = 1;
         while(_loc1_ < 17)
         {
            spr_habit.getMovie("bigMap" + _loc1_).stop();
            spr_habit.getMovie("bigMap" + _loc1_).visible = false;
            _loc1_++;
         }
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         var _loc2_:* = 0;
         var _loc4_:* = 0;
         var _loc3_:* = 0;
         init();
         LogUtil("ttttttttttttttttt");
         if(!GetMapFactor.allElfBirthPllace.hasOwnProperty(param1.elfId))
         {
            decText.text = "未知";
            Tips.show("无法探知该精灵");
            return;
         }
         habitatObj = GetMapFactor.allElfBirthPllace[param1.elfId];
         cityArr = [];
         _loc2_ = 0;
         while(_loc2_ < habitatObj.elfBirthNodeIdArr.length)
         {
            if(habitatObj.elfBirthNodeIdArr[_loc2_] != 10034)
            {
               cityArr.push(GetMapFactor.countCityId(habitatObj.elfBirthNodeIdArr[_loc2_]));
            }
            _loc2_++;
         }
         LogUtil("cityArr==",cityArr);
         _loc4_ = 0;
         while(_loc4_ < habitatObj.elfBirthArr.length)
         {
            if(habitatObj.elfBirthArr[_loc4_] != "华蓝洞")
            {
               decText.text = decText.text + (habitatObj.elfBirthArr[_loc4_] + " ");
            }
            _loc4_++;
         }
         _loc3_ = 0;
         while(_loc3_ < cityArr.length)
         {
            spr_habit.getMovie("bigMap" + cityArr[_loc3_]).play();
            spr_habit.getMovie("bigMap" + cityArr[_loc3_]).visible = true;
            _loc3_++;
         }
         if(decText.text == "")
         {
            decText.text = "未知";
            Tips.show("无法探知该精灵");
         }
      }
   }
}
