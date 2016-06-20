package com.mvc.views.uis.mainCity.train
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import starling.text.TextField;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import starling.display.Image;
   import lzm.starling.swf.display.SwfImage;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.mediator.mainCity.train.TrainMedia;
   import com.common.util.xmlVOHandler.GetpropImage;
   import starling.display.DisplayObject;
   import com.common.themes.Tips;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.xmlVOHandler.GetPropFactor;
   
   public class PropUnitUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var image:Sprite;
      
      private var numText:TextField;
      
      private var _propVo:PropVO;
      
      private var lightBg:Image;
      
      public var id:int;
      
      private var gray:SwfImage;
      
      public function PropUnitUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("train");
         numText = new TextField(50,20,"","FZCuYuan-M03S",20,5592405,true);
         numText.hAlign = "right";
         numText.x = 57;
         numText.y = 83;
         addQuickChild(numText);
         this.addEventListener("touch",useHandle);
      }
      
      private function useHandle(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(image);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            Facade.getInstance().sendNotification("CLICK_LIGHT",this);
         }
      }
      
      public function addLight() : void
      {
         if(lightBg && lightBg.parent)
         {
            removeNoNull(lightBg);
            TrainMedia.isUseProp = false;
         }
         else
         {
            lightBg = swf.createImage("img_lightProp");
            lightBg.x = -46;
            lightBg.y = -45;
            lightBg.touchable = false;
            addQuickChildAt(lightBg,0);
            TrainMedia.isUseProp = true;
         }
      }
      
      public function removeLight() : void
      {
         if(lightBg && lightBg.parent)
         {
            removeNoNull(lightBg);
         }
      }
      
      public function set myPropVo(param1:PropVO) : void
      {
         _propVo = param1;
         image = GetpropImage.getPropSpr(param1);
         addQuickChildAt(image,0);
         if(param1.count > 0)
         {
            count = param1.count;
         }
         else
         {
            addMask();
         }
      }
      
      private function addMask() : void
      {
         gray = swf.createImage("img_gray");
         addQuickChild(gray);
      }
      
      public function clean() : void
      {
         removeNoNull(image);
         removeNoNull(gray);
         removeNoNull(lightBg);
         removeNoNull(numText);
      }
      
      private function removeNoNull(param1:DisplayObject) : void
      {
         if(param1 && param1.parent)
         {
            if(param1 is Image)
            {
               (param1 as Image).texture.dispose();
            }
            if(param1 is TextField)
            {
               (param1 as TextField).text = "";
            }
            param1.removeFromParent(true);
            var param1:DisplayObject = null;
         }
      }
      
      public function set count(param1:int) : void
      {
         numText.text = param1;
         if(param1 == 0)
         {
            Tips.show("该糖果已经没有咯");
            PlayerVO.otherPropVec.splice(GetPropFactor.getPropIndex(_propVo),1);
            numText.text = "";
            addMask();
            Facade.getInstance().sendNotification("CLICK_LIGHT",this);
         }
      }
      
      public function get propVO() : PropVO
      {
         return _propVo;
      }
   }
}
