package com.mvc.views.uis.mainCity.perfer
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import feathers.controls.List;
   import feathers.controls.Label;
   import com.common.util.GetCommon;
   import com.mvc.models.proxy.mainCity.specialAct.SpecialActPro;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.display.Image;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class PreferUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_prefer:SwfSprite;
      
      public var btn_close:SwfButton;
      
      private var activityTxt:TextField;
      
      public var preferList:List;
      
      private var activityTime:Label;
      
      private var prompt:Label;
      
      public function PreferUI()
      {
         super();
         var _loc1_:Image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("common"));
         var _loc2_:* = 1.515;
         _loc1_.scaleY = _loc2_;
         _loc1_.scaleX = _loc2_;
         _loc1_.y = -328;
         addChild(_loc1_);
         init();
         addlist();
      }
      
      public function addLabel() : void
      {
         activityTime = GetCommon.getLabel(spr_prefer,activityTxt.x + activityTxt.width,activityTxt.y - 3,25);
         activityTime.text = SpecialActPro.preferStartTime.getMonth() + 1 + "月" + SpecialActPro.preferStartTime.getDate() + "日 - " + (SpecialActPro.preferEndTime.getMonth() + 1) + "月" + SpecialActPro.preferEndTime.getDate() + "日";
         prompt = GetCommon.getLabel(spr_prefer,activityTxt.x,activityTxt.y + 30,20);
         prompt.text = "<font color=\'#573526\'>活动时间内使用指定数量钻石或物品即可购买特惠大礼包，所消耗的节日道具可在冒险关卡掉落中获得</font>";
      }
      
      private function addlist() : void
      {
         preferList = new List();
         preferList.width = 900;
         preferList.height = 410;
         preferList.y = 120;
         preferList.x = 30;
         preferList.isSelectable = false;
         spr_prefer.addChild(preferList);
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("preferential");
         spr_prefer = swf.createSprite("spr_perfer");
         btn_close = spr_prefer.getButton("btn_close_b");
         activityTxt = spr_prefer.getTextField("activityTxt");
         spr_prefer.x = 1136 - spr_prefer.width >> 1;
         spr_prefer.y = 640 - spr_prefer.height >> 1;
         addChild(spr_prefer);
      }
   }
}
