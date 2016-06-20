package com.mvc.views.uis.mainCity.backPack
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfScale9Image;
   import starling.text.TextField;
   import feathers.controls.Label;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.util.xmlVOHandler.GetpropImage;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.vos.elf.SkillVO;
   import lzm.starling.swf.display.SwfMovieClip;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.GetCommon;
   
   public class PlayElfUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var mySpr:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var spr_elf:Sprite;
      
      private var swf2:Swf;
      
      public var s9_bg:SwfScale9Image;
      
      public var spr_skillDec:SwfSprite;
      
      private var propName:TextField;
      
      private var status:TextField;
      
      private var type:TextField;
      
      private var power:TextField;
      
      private var rate:TextField;
      
      private var skillDec:TextField;
      
      private var propImg:Sprite;
      
      private var PPLabel:Label;
      
      public function PlayElfUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("bag");
         swf2 = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         mySpr = swf.createSprite("spr_palyElfBg");
         btn_close = mySpr.getButton("btn_palyClose");
         s9_bg = mySpr.getScale9Image("s9_bg");
         spr_skillDec = swf.createSprite("spr_skillDec");
         propName = spr_skillDec.getTextField("propName");
         status = spr_skillDec.getTextField("status");
         type = spr_skillDec.getTextField("type");
         power = spr_skillDec.getTextField("power");
         rate = spr_skillDec.getTextField("rate");
         skillDec = spr_skillDec.getTextField("skillDec");
         skillDec.vAlign = "top";
         skillDec.hAlign = "left";
         spr_skillDec.x = 35;
         spr_skillDec.y = 405;
         mySpr.x = 1136 - mySpr.width >> 1;
         mySpr.y = 100;
         spr_elf = new Sprite();
         spr_elf.x = 70;
         spr_elf.y = 90;
         addChild(mySpr);
         mySpr.addChild(spr_elf);
         PPLabel = GetCommon.getLabel(spr_skillDec,rate.x + rate.width,rate.y,20);
      }
      
      public function setPostion() : void
      {
         LogUtil("mySpr.y=",mySpr.y,mySpr.pivotY);
         s9_bg.height = 470;
         spr_elf.y = 105;
         spr_skillDec.visible = false;
         LogUtil("spr_skillDec.visible==",spr_skillDec.visible);
         mySpr.y = 100;
      }
      
      public function set myPropVo(param1:PropVO) : void
      {
         var _loc2_:* = null;
         LogUtil("更新代码",param1.skillId);
         if(param1.skillId != 0)
         {
            mySpr.y = 55;
            mySpr.addChild(spr_skillDec);
            s9_bg.height = 550;
            spr_elf.y = 90;
            spr_skillDec.visible = true;
            LogUtil("spr_skillDec.visible=",spr_skillDec.visible);
            cleanImg();
            propImg = GetpropImage.getPropSpr(param1,false);
            propImg.x = 15;
            propImg.y = 4;
            spr_skillDec.addChild(propImg);
            _loc2_ = GetElfFactor.getSkillById(param1.skillId);
            propName.text = param1.name;
            status.text = _loc2_.property;
            type.text = _loc2_.sort;
            power.text = _loc2_.power;
            PPLabel.text = "<font color=\'#573525\'>PP: </font><font color=\'#F08300\'>" + _loc2_.totalPP + "</font>";
            if(_loc2_.hitRate > 100)
            {
               rate.text = "--";
            }
            else
            {
               rate.text = _loc2_.hitRate;
            }
            skillDec.text = _loc2_.descs;
         }
         else
         {
            setPostion();
            cleanImg();
            spr_skillDec.removeFromParent();
         }
      }
      
      private function cleanImg() : void
      {
         if(propImg)
         {
            propImg.removeFromParent(true);
            propImg = null;
         }
      }
      
      public function getNull() : SwfSprite
      {
         return swf2.createSprite("spr_Notunlock");
      }
      
      public function addRestrain(param1:Sprite, param2:String) : void
      {
         LogUtil("添加克制动画");
         var _loc3_:SwfMovieClip = swf.createMovieClip(param2);
         _loc3_.x = 130;
         _loc3_.y = 5;
         param1.addChild(_loc3_);
         _loc3_.gotoAndPlay(0);
      }
   }
}
