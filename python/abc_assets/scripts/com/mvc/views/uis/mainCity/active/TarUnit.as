package com.mvc.views.uis.mainCity.active
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfImage;
   import starling.text.TextField;
   import com.mvc.models.vos.mainCity.active.ActiveVO;
   import starling.display.Image;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class TarUnit extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_tar:SwfSprite;
      
      public var light:SwfImage;
      
      private var actName:TextField;
      
      private var image:SwfImage;
      
      private var _activeVo:ActiveVO;
      
      public var news:Image;
      
      public var index:int;
      
      public function TarUnit()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("activity");
         spr_tar = swf.createSprite("spr_tar");
         actName = spr_tar.getTextField("actName");
         actName.autoScale = true;
         light = spr_tar.getImage("light");
         light.visible = false;
         addChild(spr_tar);
      }
      
      public function set myActiveVo(param1:ActiveVO) : void
      {
         var _loc2_:* = 0;
         _activeVo = param1;
         actName.text = param1.atvTitle;
         LogUtil("actName =",actName.text);
         if(image)
         {
            image.removeFromParent(true);
            image = null;
         }
         image = swf.createImage("img_" + param1.atvPicId);
         var _loc3_:* = 15;
         image.y = _loc3_;
         image.x = _loc3_;
         spr_tar.addChildAt(image,1);
         if(news)
         {
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < param1.activeChildVec.length)
         {
            if(param1.activeChildVec[_loc2_].status == 1)
            {
               news = LoadSwfAssetsManager.getInstance().assets.getSwf("common").createImage("img_new");
               _loc3_ = 10;
               news.y = _loc3_;
               news.x = _loc3_;
               addChild(news);
               break;
            }
            _loc2_++;
         }
      }
      
      public function get myActiveVo() : ActiveVO
      {
         return _activeVo;
      }
   }
}
