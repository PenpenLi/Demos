package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfImage;
   import lzm.starling.swf.display.SwfScale9Image;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.xmlVOHandler.GetElfQuality;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import starling.display.Image;
   
   public class BreakpreviewUnit extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_breakUnit:SwfSprite;
      
      private var elfName:TextField;
      
      public var elfLv:TextField;
      
      public var nowPropmt:SwfImage;
      
      public var breakLv:int;
      
      public var tickArr:Array;
      
      private var breakPropBg:SwfScale9Image;
      
      private var propSprVec:Vector.<com.mvc.views.uis.mainCity.myElf.SimplePropUI>;
      
      public function BreakpreviewUnit()
      {
         tickArr = [1,1,1,1,1,1];
         propSprVec = new Vector.<com.mvc.views.uis.mainCity.myElf.SimplePropUI>([]);
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         spr_breakUnit = swf.createSprite("spr_breakUnit");
         elfName = spr_breakUnit.getTextField("elfName");
         elfLv = spr_breakUnit.getTextField("elfLv");
         nowPropmt = spr_breakUnit.getImage("nowPropmt");
         breakPropBg = spr_breakUnit.getScale9Image("breakPropBg");
         breakPropBg.height = 250;
         nowPropmt.visible = false;
         addChild(spr_breakUnit);
      }
      
      public function set breakVo(param1:Object) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = 0;
         var _loc2_:* = null;
         elfName.text = param1.elfName + ElfBreakUI.getInstance().brokenStr[breakLv];
         elfName.color = ElfBreakUI.getInstance().brokenColor[breakLv];
         elfLv.text = "Lv." + GetElfQuality.getElfLv(breakLv + 1);
         propSprVec = new Vector.<com.mvc.views.uis.mainCity.myElf.SimplePropUI>([]);
         var _loc5_:* = 0;
         _loc4_ = 0;
         while(_loc4_ < param1.propArr.length)
         {
            if(_loc4_ % 3 == 0 && _loc4_ != 0)
            {
               _loc5_++;
            }
            _loc3_ = GetPropFactor.getProp(param1.propArr[_loc4_][0]);
            if(!_loc3_)
            {
               _loc3_ = GetPropFactor.getPropVO(param1.propArr[_loc4_][0]);
               LogUtil("预览-没有这个道具==",_loc3_.name);
               tickArr[_loc4_] = 0;
            }
            LogUtil("道具数量是否满足==",_loc3_.count,param1.propArr[_loc4_][1]);
            if(_loc3_.count < param1.propArr[_loc4_][1])
            {
               tickArr[_loc4_] = 0;
            }
            _loc2_ = new com.mvc.views.uis.mainCity.myElf.SimplePropUI(0.75,0,true,true);
            _loc2_.myPropVo = _loc3_;
            _loc2_.x = 110 * (_loc4_ % 3) + 35;
            _loc2_.y = 60 + _loc5_ * 95;
            propSprVec.push(_loc2_);
            spr_breakUnit.addChildAt(_loc2_,1);
            _loc4_++;
         }
         _loc3_ = null;
      }
      
      public function addTick(param1:Boolean) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = null;
         _loc2_ = 0;
         while(_loc2_ < tickArr.length)
         {
            if(!(param1 && tickArr[_loc2_] == 0))
            {
               if(_loc2_ < propSprVec.length)
               {
                  _loc3_ = swf.createImage("img_tick");
                  _loc3_.x = 40;
                  _loc3_.y = 45;
                  propSprVec[_loc2_].addChild(_loc3_);
               }
            }
            _loc2_++;
         }
      }
   }
}
