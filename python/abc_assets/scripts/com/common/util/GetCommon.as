package com.common.util
{
   import lzm.starling.swf.Swf;
   import starling.display.Image;
   import lzm.starling.display.Button;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import feathers.controls.Label;
   import flash.text.TextFormat;
   import lzm.starling.swf.display.SwfScale9Image;
   import starling.display.DisplayObjectContainer;
   import starling.utils.SystemUtil;
   import lzm.util.OSUtil;
   
   public class GetCommon
   {
      
      private static var swf:Swf;
       
      public function GetCommon()
      {
         super();
      }
      
      public static function getNews(param1:Button, param2:Number, param3:int = 0, param4:int = 10, param5:int = 0) : Image
      {
         var _loc7_:* = null;
         var _loc6_:* = null;
         if(param5 == 0)
         {
            swf = LoadSwfAssetsManager.getInstance().assets.getSwf("mainCity");
            _loc7_ = swf.createImage("img_new");
         }
         else
         {
            _loc6_ = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
            _loc7_ = _loc6_.createImage("img_new");
         }
         _loc7_.x = param3;
         _loc7_.y = param4;
         _loc7_.visible = false;
         _loc7_.touchable = false;
         _loc7_.name = "news";
         var _loc8_:* = param2;
         _loc7_.scaleY = _loc8_;
         _loc7_.scaleX = _loc8_;
         (param1.skin as Sprite).addChild(_loc7_);
         return _loc7_;
      }
      
      public static function getVipIcon(param1:int, param2:Number = 1) : SwfSprite
      {
         var _loc3_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("bag");
         var _loc4_:SwfSprite = _loc3_.createSprite("spr_vip");
         var _loc5_:TextField = _loc4_.getTextField("tf_vipRank");
         _loc5_.x = §§dup(_loc5_).x - 1;
         _loc5_.y = _loc5_.y + 2;
         _loc5_.text = param1;
         _loc5_.fontName = "img_vipIcon";
         _loc4_.touchable = false;
         var _loc6_:* = param2;
         _loc4_.scaleY = _loc6_;
         _loc4_.scaleX = _loc6_;
         return _loc4_;
      }
      
      public static function isNullObject(param1:Object) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         var _loc4_:* = 0;
         var _loc3_:* = param1;
         for(var _loc2_ in param1)
         {
            return true;
         }
         return false;
      }
      
      public static function getLabel(param1:Sprite, param2:int, param3:int, param4:int = 30, param5:String = "", param6:uint = 9713664) : Label
      {
         var _loc7_:Label = new Label();
         _loc7_.x = param2;
         _loc7_.y = param3;
         _loc7_.text = param5;
         _loc7_.textRendererProperties.wordWrap = false;
         _loc7_.textRendererProperties.isHTML = true;
         _loc7_.textRendererProperties.textFormat = new TextFormat("FZCuYuan-M03S",param4,param6,true);
         param1.addChild(_loc7_);
         return _loc7_;
      }
      
      public static function getImage(param1:int, param2:int, param3:String, param4:Swf, param5:Sprite) : Image
      {
         var _loc6_:Image = param4.createImage(param3);
         _loc6_.x = param1;
         _loc6_.y = param2;
         param5.addChild(_loc6_);
         return _loc6_;
      }
      
      public static function getS9Image(param1:int, param2:int, param3:int, param4:int, param5:String, param6:Swf, param7:Sprite) : SwfScale9Image
      {
         var _loc8_:SwfScale9Image = param6.createS9Image(param5);
         _loc8_.x = param1;
         _loc8_.y = param2;
         _loc8_.width = param3;
         _loc8_.height = param4;
         param7.addChild(_loc8_);
         return _loc8_;
      }
      
      public static function getText(param1:int, param2:int, param3:int, param4:int, param5:String, param6:String, param7:int, param8:uint, param9:DisplayObjectContainer, param10:Boolean = false, param11:Boolean = false, param12:Boolean = false, param13:Boolean = false, param14:Boolean = false, param15:Boolean = false, param16:Boolean = false) : TextField
      {
         var _loc17_:TextField = new TextField(param3,param4,param5,param6,param7,param8,param15);
         if(param11)
         {
            _loc17_.hAlign = "center";
         }
         if(param10)
         {
            _loc17_.autoSize = "horizontal";
         }
         if(param16)
         {
            _loc17_.autoSize = "vertical";
         }
         if(param12)
         {
            _loc17_.autoScale = param12;
         }
         if(param13)
         {
            _loc17_.hAlign = "left";
         }
         if(param14)
         {
            _loc17_.hAlign = "right";
         }
         _loc17_.x = param1;
         _loc17_.y = param2;
         _loc17_.touchable = false;
         param9.addChild(_loc17_);
         return _loc17_;
      }
      
      public static function isIOSDied() : Boolean
      {
         if(!SystemUtil.isApplicationActive && OSUtil.isIPhone())
         {
            return true;
         }
         return false;
      }
   }
}
