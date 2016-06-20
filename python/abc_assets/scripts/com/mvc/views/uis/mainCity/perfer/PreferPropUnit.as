package com.mvc.views.uis.mainCity.perfer
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.Image;
   import com.common.util.xmlVOHandler.GetpropImage;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.common.managers.ELFMinImageManager;
   import com.mvc.models.vos.login.PlayerVO;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.views.uis.mapSelect.ExtendElfUnitTips;
   import com.mvc.views.uis.mainCity.firstRecharge.FirstRchRewardTips;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class PreferPropUnit extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_diaNumBg:SwfSprite;
      
      private var diaTxt:TextField;
      
      private var spr_propNumBg:SwfSprite;
      
      private var otherSpr:Sprite;
      
      private var propSpr:Sprite;
      
      public var _propVo:PropVO;
      
      public var _elfVo:ElfVO;
      
      private var elfSpr:Image;
      
      public var isPropPass:Boolean = true;
      
      public var isDiaPass:Boolean = true;
      
      private var _isReward:Boolean;
      
      private var propText:TextField;
      
      public var _other:String;
      
      public function PreferPropUnit(param1:Boolean, param2:Number = 1)
      {
         super();
         _isReward = param1;
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("npcMin");
         this.scaleX = param2;
         this.scaleY = param2;
         addEventListener("touch",ontouch);
      }
      
      public function handle(param1:Object) : void
      {
         if(param1 is String)
         {
            other = param1 as String;
         }
         if(param1 is PropVO)
         {
            myProp = param1 as PropVO;
         }
         if(param1 is ElfVO)
         {
            myElfVo = param1 as ElfVO;
         }
      }
      
      public function set myProp(param1:PropVO) : void
      {
         _propVo = param1;
         if(propSpr)
         {
            GetpropImage.clean(propSpr);
         }
         propSpr = GetpropImage.getPropSpr(param1);
         if(_isReward)
         {
            if(!spr_propNumBg)
            {
               spr_propNumBg = swf.createSprite("spr_propNumBg");
            }
            if(!propText)
            {
               propText = spr_propNumBg.getTextField("numTxt");
            }
            propText.autoScale = true;
            propText.text = param1.rewardCount;
            spr_propNumBg.x = 78;
            spr_propNumBg.y = 78;
         }
         else
         {
            if(!spr_propNumBg)
            {
               spr_propNumBg = swf.createSprite("spr_diaNumBg");
            }
            if(!propText)
            {
               propText = spr_propNumBg.getTextField("numTxt");
            }
            propText.autoScale = true;
            spr_propNumBg.x = 37;
            spr_propNumBg.y = 84;
            if(GetPropFactor.getProp(param1.id))
            {
               propText.text = GetPropFactor.getProp(param1.id).count + "/" + param1.rewardCount;
               if(param1.rewardCount > GetPropFactor.getProp(param1.id).count)
               {
                  isPropPass = false;
                  propText.color = 16711680;
               }
            }
            else
            {
               isPropPass = false;
               propText.text = "0/" + param1.rewardCount;
               propText.color = 16711680;
            }
         }
         propSpr.addChild(spr_propNumBg);
         addChild(propSpr);
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         _elfVo = param1;
         if(elfSpr)
         {
            GetpropImage.clean(elfSpr);
         }
         elfSpr = ELFMinImageManager.getElfM(param1.imgName);
         spr_diaNumBg = swf.createSprite("spr_diaNumBg");
         if(!diaTxt)
         {
            diaTxt = spr_diaNumBg.getTextField("numTxt");
         }
         diaTxt.autoScale = true;
         diaTxt.text = "Lv." + param1.lv;
         spr_diaNumBg.x = 37;
         spr_diaNumBg.y = 84;
         addChild(elfSpr);
         addChild(spr_diaNumBg);
      }
      
      public function set other(param1:String) : void
      {
         var _loc2_:* = null;
         _other = param1;
         var _loc3_:* = param1.substr(0,4);
         if("奖励经验" !== _loc3_)
         {
            if("奖励金币" !== _loc3_)
            {
               if("奖励钻石" !== _loc3_)
               {
                  if("奖励体力" === _loc3_)
                  {
                     _loc2_ = "img_cake";
                  }
               }
               else
               {
                  _loc2_ = "img_dia980";
               }
            }
            else
            {
               _loc2_ = "img_coin";
            }
         }
         else
         {
            _loc2_ = "img_expicon";
         }
         otherSpr = GetpropImage.getOtherSpr(_loc2_);
         if(!spr_diaNumBg)
         {
            spr_diaNumBg = swf.createSprite("spr_diaNumBg");
         }
         if(!diaTxt)
         {
            diaTxt = spr_diaNumBg.getTextField("numTxt");
         }
         diaTxt.autoScale = true;
         if(_isReward)
         {
            diaTxt.text = param1.slice(5);
         }
         else
         {
            diaTxt.text = PlayerVO.diamond + "/" + param1.slice(5);
            if(param1.slice(5) > PlayerVO.diamond)
            {
               isDiaPass = false;
               diaTxt.color = 16711680;
            }
         }
         spr_diaNumBg.x = 37;
         spr_diaNumBg.y = 84;
         otherSpr.addChild(spr_diaNumBg);
         addQuickChild(otherSpr);
      }
      
      private function ontouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_)
         {
            if(_loc2_.phase == "began")
            {
               if(_elfVo)
               {
                  ExtendElfUnitTips.getInstance().showElfTips(_elfVo,this);
               }
               if(_propVo)
               {
                  FirstRchRewardTips.getInstance().showPropTips(_propVo,this);
               }
            }
            if(_loc2_.phase == "ended")
            {
               if(_propVo)
               {
                  FirstRchRewardTips.getInstance().removePropTips();
               }
               if(_elfVo)
               {
                  ExtendElfUnitTips.getInstance().removeElfTips();
               }
            }
         }
      }
   }
}
