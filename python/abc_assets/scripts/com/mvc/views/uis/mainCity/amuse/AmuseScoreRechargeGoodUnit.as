package com.mvc.views.uis.mainCity.amuse
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import starling.display.Image;
   import com.common.managers.ELFMinImageManager;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.common.util.xmlVOHandler.GetpropImage;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.views.uis.mapSelect.ExtendElfUnitTips;
   import com.mvc.views.uis.mainCity.firstRecharge.FirstRchRewardTips;
   
   public class AmuseScoreRechargeGoodUnit extends Sprite
   {
       
      private var swf:Swf;
      
      public var _elfVO:ElfVO;
      
      public var _propVO:PropVO;
      
      private var elfImg:Image;
      
      private var propSpr:Sprite;
      
      public function AmuseScoreRechargeGoodUnit()
      {
         super();
      }
      
      public function addElfImg(param1:ElfVO) : void
      {
         _elfVO = param1;
         elfImg = ELFMinImageManager.getElfM(param1.imgName);
         elfImg.addEventListener("touch",touchHandler);
         addChild(elfImg);
      }
      
      public function addPropSpr(param1:PropVO) : void
      {
         _propVO = GetPropFactor.getProp(param1.id);
         if(!_propVO)
         {
            _propVO = param1;
         }
         propSpr = GetpropImage.getPropSpr(param1);
         propSpr.addEventListener("touch",touchHandler);
         addChild(propSpr);
      }
      
      private function touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_)
         {
            if(_loc2_.phase == "began")
            {
               if(_elfVO && !_propVO)
               {
                  ExtendElfUnitTips.getInstance().showElfTips(_elfVO,this);
               }
               if(!_elfVO && _propVO)
               {
                  FirstRchRewardTips.getInstance().showPropTips(_propVO,this);
               }
            }
            if(_loc2_.phase == "ended")
            {
               if(_elfVO && !_propVO)
               {
                  ExtendElfUnitTips.getInstance().removeElfTips();
               }
               if(!_elfVO && _propVO)
               {
                  FirstRchRewardTips.getInstance().removePropTips();
               }
            }
         }
      }
   }
}
