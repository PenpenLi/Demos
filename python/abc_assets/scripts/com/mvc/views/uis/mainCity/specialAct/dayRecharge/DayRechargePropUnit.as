package com.mvc.views.uis.mainCity.specialAct.dayRecharge
{
   import starling.display.Sprite;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.models.vos.elf.ElfVO;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import starling.display.Image;
   import com.common.managers.LoadSwfAssetsManager;
   import lzm.starling.swf.Swf;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.views.uis.mapSelect.ExtendElfUnitTips;
   import com.mvc.views.uis.mainCity.firstRecharge.FirstRchRewardTips;
   import com.common.managers.ELFMinImageManager;
   import com.common.util.xmlVOHandler.GetpropImage;
   
   public class DayRechargePropUnit extends Sprite
   {
       
      private var _propVO:PropVO;
      
      private var _elfVO:ElfVO;
      
      public var spr_propUnit:SwfSprite;
      
      public var tf_num:TextField;
      
      private var img_dot:Image;
      
      public function DayRechargePropUnit()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc1_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("dayRecharge");
         spr_propUnit = _loc1_.createSprite("spr_propUnit");
         addChild(spr_propUnit);
         img_dot = spr_propUnit.getImage("img_dot");
         img_dot.touchable = false;
         tf_num = spr_propUnit.getTextField("tf_num");
         tf_num.touchable = false;
         this.addEventListener("touch",touchHandler);
      }
      
      private function touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(spr_propUnit);
         if(_loc2_ && _loc2_.phase == "began")
         {
            if(elfVO && !propVO)
            {
               ExtendElfUnitTips.getInstance().showElfTips(elfVO,this);
            }
            else
            {
               FirstRchRewardTips.getInstance().showPropTips(propVO,this);
            }
         }
         if(_loc2_ && _loc2_.phase == "ended")
         {
            if(elfVO && !propVO)
            {
               ExtendElfUnitTips.getInstance().removeElfTips();
            }
            else
            {
               FirstRchRewardTips.getInstance().removePropTips();
            }
         }
      }
      
      public function get elfVO() : ElfVO
      {
         return _elfVO;
      }
      
      public function set elfVO(param1:ElfVO) : void
      {
         _elfVO = param1;
         addElfImg();
      }
      
      private function addElfImg() : void
      {
         var _loc1_:Image = ELFMinImageManager.getElfM(elfVO.imgName,0.8);
         _loc1_.x = spr_propUnit.width - _loc1_.width >> 1;
         _loc1_.y = spr_propUnit.height - _loc1_.height >> 1;
         spr_propUnit.addChildAt(_loc1_,1);
         setNumTf(1);
      }
      
      public function get propVO() : PropVO
      {
         return _propVO;
      }
      
      public function set propVO(param1:PropVO) : void
      {
         _propVO = param1;
         addPropImg();
         setNumTf(param1.rewardCount);
      }
      
      private function addPropImg() : void
      {
         var _loc1_:Sprite = GetpropImage.getPropSpr(propVO,false,0.8);
         _loc1_.x = spr_propUnit.width - _loc1_.width >> 1;
         _loc1_.y = spr_propUnit.height - _loc1_.height >> 1;
         spr_propUnit.addChildAt(_loc1_,1);
      }
      
      public function setOtherAward(param1:String, param2:int) : void
      {
         var _loc4_:* = null;
         if(!param1)
         {
            return;
         }
         var _loc5_:* = param1;
         if("经验" !== _loc5_)
         {
            if("金币" !== _loc5_)
            {
               if("钻石" !== _loc5_)
               {
                  if("体力" !== _loc5_)
                  {
                     if("王者积分" !== _loc5_)
                     {
                        if("对战积分" !== _loc5_)
                        {
                           if("联盟积分" !== _loc5_)
                           {
                              if("神秘积分" === _loc5_)
                              {
                                 _loc4_ = "img_fsDot";
                              }
                           }
                           else
                           {
                              _loc4_ = "img_rkDot";
                           }
                        }
                        else
                        {
                           _loc4_ = "img_pvDot";
                        }
                     }
                     else
                     {
                        _loc4_ = "img_kwDot";
                     }
                  }
                  else
                  {
                     _loc4_ = "img_cake";
                  }
               }
               else
               {
                  _loc4_ = "img_dia980";
               }
            }
            else
            {
               _loc4_ = "img_coin";
            }
         }
         else
         {
            _loc4_ = "img_expicon";
         }
         var _loc3_:Sprite = GetpropImage.getOtherSpr(_loc4_);
         _loc3_.x = spr_propUnit.width - _loc3_.width >> 1;
         _loc3_.y = spr_propUnit.height - _loc3_.height >> 1;
         spr_propUnit.addChildAt(_loc3_,1);
         setNumTf(param2);
      }
      
      public function setNumTf(param1:int) : void
      {
         if(param1 == 1)
         {
            img_dot.visible = false;
            tf_num.visible = false;
            return;
         }
         tf_num.text = param1;
      }
   }
}
