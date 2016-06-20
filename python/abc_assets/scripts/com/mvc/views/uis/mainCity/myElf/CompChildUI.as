package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import starling.display.Quad;
   import lzm.starling.swf.display.SwfButton;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import lzm.starling.swf.display.SwfImage;
   import feathers.controls.List;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.login.PlayerVO;
   import starling.events.Event;
   import com.common.managers.LoadOtherAssetsManager;
   import starling.utils.AssetManager;
   import feathers.skins.SmartDisplayObjectStateValueSelector;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import com.common.util.xmlVOHandler.GetMapFactor;
   import com.common.themes.Tips;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.myElf.MyElfPro;
   import com.mvc.models.vos.mapSelect.MainMapVO;
   import feathers.data.ListCollection;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import com.mvc.views.mediator.mainCity.task.TaskMedia;
   import starling.core.Starling;
   import com.mvc.views.mediator.mapSelect.WorldMapMedia;
   import com.mvc.models.proxy.mapSelect.MapPro;
   import com.mvc.views.mediator.mainCity.myElf.MyElfMedia;
   import com.common.util.WinTweens;
   import starling.animation.Tween;
   import com.common.events.EventCenter;
   import com.mvc.models.proxy.mainCity.backPack.BackPackPro;
   import extend.SoundEvent;
   import com.common.util.xmlVOHandler.GetpropImage;
   
   public class CompChildUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.myElf.CompChildUI;
       
      private var swf:Swf;
      
      private var spr_compChild1:SwfSprite;
      
      private var propName:TextField;
      
      private var propCount:TextField;
      
      private var propDec:TextField;
      
      private var spr_compChild2:SwfSprite;
      
      private var bg:Quad;
      
      private var propImg:com.mvc.views.uis.mainCity.myElf.SimplePropUI;
      
      private var btn_collect:SwfButton;
      
      private var styleContain:Sprite;
      
      private var propName2:TextField;
      
      private var _propVo:PropVO;
      
      private var compCost:TextField;
      
      private var compIcon:SwfImage;
      
      private var btn_return:SwfButton;
      
      private var btn_comp:SwfButton;
      
      private var stoneGuideList:List;
      
      private var propBirthArr:Array;
      
      private var isCloseSecond:Boolean;
      
      private var nodeRcdIndex:int;
      
      private var isAllMeet:Boolean;
      
      private var comPropVo:PropVO;
      
      private var comNeedPropVec:Vector.<com.mvc.views.uis.mainCity.myElf.SimplePropUI>;
      
      private var btn_close1:SwfButton;
      
      private var btn_close2:SwfButton;
      
      private var posX:Number;
      
      private var posY:Number;
      
      public function CompChildUI()
      {
         comNeedPropVec = new Vector.<com.mvc.views.uis.mainCity.myElf.SimplePropUI>([]);
         super();
         bg = new Quad(1136,640,0);
         bg.alpha = 0.7;
         addChild(bg);
         bg.addEventListener("touch",close);
         init();
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.myElf.CompChildUI
      {
         return instance || new com.mvc.views.uis.mainCity.myElf.CompChildUI();
      }
      
      private function close(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(bg);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            remove();
         }
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         spr_compChild1 = swf.createSprite("spr_compChild1");
         propName = spr_compChild1.getTextField("propName");
         propCount = spr_compChild1.getTextField("propCount");
         propDec = spr_compChild1.getTextField("propDec");
         btn_collect = spr_compChild1.getButton("btn_collect");
         btn_close1 = spr_compChild1.getButton("btn_close1");
         spr_compChild2 = swf.createSprite("spr_compChild2");
         propName2 = spr_compChild2.getTextField("propName2");
         compCost = spr_compChild2.getTextField("compCost");
         compIcon = spr_compChild2.getImage("compIcon");
         btn_return = spr_compChild2.getButton("btn_return");
         btn_comp = spr_compChild2.getButton("btn_comp");
         btn_close2 = spr_compChild2.getButton("btn_close2");
         propDec.vAlign = "top";
         propDec.hAlign = "left";
         spr_compChild1.x = 1136 - spr_compChild1.width >> 1;
         spr_compChild1.y = 640 - spr_compChild1.height >> 1;
         addChild(spr_compChild1);
         spr_compChild2.y = 640 - spr_compChild2.height >> 1;
         styleContain = new Sprite();
         spr_compChild2.addChild(styleContain);
         this.addEventListener("triggered",click);
      }
      
      private function showbottom(param1:Boolean) : void
      {
         btn_comp.visible = param1;
         btn_return.visible = !param1;
         compIcon.visible = param1;
         compCost.visible = param1;
      }
      
      public function addStyleOne(param1:PropVO) : void
      {
         var _loc9_:* = null;
         var _loc12_:* = null;
         var _loc8_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc10_:* = 0;
         var _loc7_:* = null;
         var _loc4_:* = null;
         styleContain.removeChildren(0,-1,true);
         isAllMeet = true;
         var _loc2_:com.mvc.views.uis.mainCity.myElf.SimplePropUI = new com.mvc.views.uis.mainCity.myElf.SimplePropUI(0.6,0,true);
         _loc2_.myPropVo = param1;
         _loc2_.identity = "one";
         _loc2_.x = 20;
         _loc2_.y = 53;
         styleContain.addChild(_loc2_);
         var _loc11_:SwfImage = swf.createImage("img_beacon");
         _loc11_.x = (_loc2_.width - _loc11_.width >> 1) + _loc2_.x;
         _loc11_.y = _loc2_.y + _loc2_.height;
         styleContain.addChild(_loc11_);
         propName2.text = param1.name;
         showbottom(true);
         var _loc3_:com.mvc.views.uis.mainCity.myElf.SimplePropUI = new com.mvc.views.uis.mainCity.myElf.SimplePropUI(0.7);
         _loc3_.myPropVo = param1;
         comPropVo = param1;
         _loc3_.x = spr_compChild2.width - _loc3_.width >> 1;
         _loc3_.y = propName2.y + propName2.height + 5;
         styleContain.addChild(_loc3_);
         posX = _loc3_.x;
         posY = _loc3_.y;
         if(param1.type == 18 || param1.type == 24)
         {
            _loc12_ = GetPropFactor.getBrokenPropByComposeID(param1.id);
            if(!_loc12_)
            {
               isCloseSecond = true;
               _loc3_.removeFromParent(true);
               showbottom(false);
               addList(param1);
               return;
            }
            compCost.text = "合成花费: " + _loc12_.composeMoney;
            if(_loc12_.composeMoney < PlayerVO.silver)
            {
               compCost.color = 3407616;
            }
            else
            {
               compCost.color = 16711680;
               isAllMeet = false;
            }
            comNeedPropVec = new Vector.<com.mvc.views.uis.mainCity.myElf.SimplePropUI>([]);
            _loc9_ = swf.createImage("img_comp1");
            _loc9_.x = spr_compChild2.width - _loc9_.width >> 1;
            _loc9_.y = _loc3_.y + _loc3_.height - 2;
            _loc8_ = GetPropFactor.getProp(_loc12_.id);
            if(!_loc8_)
            {
               _loc8_ = _loc12_;
            }
            _loc5_ = new com.mvc.views.uis.mainCity.myElf.SimplePropUI(0.6,_loc8_.composeNum,true);
            _loc5_.lastPropVo = param1;
            _loc5_.myPropVo = _loc8_;
            _loc5_.identity = "合成23";
            _loc5_.x = _loc9_.x - 30;
            _loc5_.y = _loc9_.y + _loc9_.height;
            styleContain.addChild(_loc5_);
            comNeedPropVec.push(_loc5_);
            if(!_loc5_.isMeet)
            {
               isAllMeet = false;
            }
         }
         if(param1.type == 19)
         {
            compCost.text = "合成花费: " + param1.composeMoney;
            if(param1.composeMoney < PlayerVO.silver)
            {
               compCost.color = 3407616;
            }
            else
            {
               compCost.color = 16711680;
               isAllMeet = false;
            }
            _loc6_ = param1.compNeedPropId;
            _loc9_ = swf.createImage("img_comp" + _loc6_.length);
            _loc9_.x = spr_compChild2.width - _loc9_.width >> 1;
            _loc9_.y = _loc3_.y + _loc3_.height - 2;
            comNeedPropVec = new Vector.<com.mvc.views.uis.mainCity.myElf.SimplePropUI>([]);
            _loc10_ = 0;
            while(_loc10_ < _loc6_.length)
            {
               _loc7_ = GetPropFactor.getProp(_loc6_[_loc10_]);
               if(!_loc7_)
               {
                  _loc7_ = GetPropFactor.getPropVO(_loc6_[_loc10_]);
               }
               _loc4_ = new com.mvc.views.uis.mainCity.myElf.SimplePropUI(0.6,1,true);
               _loc4_.lastPropVo = param1;
               _loc4_.myPropVo = _loc7_;
               _loc4_.x = _loc9_.x - 35 + _loc10_ * 85;
               _loc4_.y = _loc9_.y + _loc9_.height;
               _loc4_.identity = "合成2";
               styleContain.addChild(_loc4_);
               comNeedPropVec.push(_loc4_);
               if(!_loc4_.isMeet)
               {
                  isAllMeet = false;
               }
               _loc10_++;
            }
         }
         styleContain.addChild(_loc9_);
      }
      
      public function addStyleTwo(param1:PropVO, param2:PropVO) : void
      {
         var _loc8_:* = null;
         var _loc14_:* = null;
         var _loc11_:* = 0;
         var _loc9_:* = null;
         var _loc6_:* = null;
         var _loc10_:* = null;
         var _loc7_:* = null;
         var _loc5_:* = null;
         isAllMeet = true;
         styleContain.removeChildren(0,-1,true);
         var _loc3_:com.mvc.views.uis.mainCity.myElf.SimplePropUI = new com.mvc.views.uis.mainCity.myElf.SimplePropUI(0.6,0,true);
         _loc3_.myPropVo = param1;
         _loc3_.identity = "one";
         _loc3_.x = 20;
         _loc3_.y = 53;
         styleContain.addChild(_loc3_);
         var _loc12_:SwfImage = swf.createImage("img_beacon");
         _loc12_.pivotX = _loc12_.width / 2;
         _loc12_.x = _loc3_.width + _loc3_.x + 3;
         _loc12_.y = (_loc3_.height - _loc12_.height >> 1) + _loc3_.y + 5;
         _loc12_.rotation = 80;
         styleContain.addChild(_loc12_);
         var _loc4_:com.mvc.views.uis.mainCity.myElf.SimplePropUI = new com.mvc.views.uis.mainCity.myElf.SimplePropUI(0.6,0,true);
         _loc4_.myPropVo = param2;
         _loc4_.lastPropVo = param1;
         _loc4_.identity = "two";
         _loc4_.x = _loc12_.x + _loc12_.width;
         _loc4_.y = 53;
         styleContain.addChild(_loc4_);
         var _loc13_:SwfImage = swf.createImage("img_beacon");
         _loc13_.x = (_loc4_.width - _loc13_.width >> 1) + _loc4_.x;
         _loc13_.y = _loc4_.y + _loc4_.height;
         styleContain.addChild(_loc13_);
         var _loc15_:PropVO = GetPropFactor.getBrokenPropByComposeID(param2.id);
         propName2.text = param2.name;
         if(!_loc15_ && param2.type != 19)
         {
            showbottom(false);
            addList(param2);
         }
         else
         {
            showbottom(true);
            _loc8_ = new com.mvc.views.uis.mainCity.myElf.SimplePropUI(0.7);
            _loc8_.myPropVo = param2;
            comPropVo = param2;
            _loc8_.x = spr_compChild2.width - _loc8_.width >> 1;
            _loc8_.y = propName2.y + propName2.height + 5;
            styleContain.addChild(_loc8_);
            posX = _loc8_.x;
            posY = _loc8_.y;
            if(param2.type == 19)
            {
               compCost.text = "合成花费: " + param2.composeMoney;
               if(param2.composeMoney < PlayerVO.silver)
               {
                  compCost.color = 3407616;
               }
               else
               {
                  compCost.color = 16711680;
                  isAllMeet = false;
               }
               _loc14_ = param2.compNeedPropId;
               _loc10_ = swf.createImage("img_comp" + _loc14_.length);
               _loc10_.x = spr_compChild2.width - _loc10_.width >> 1;
               _loc10_.y = _loc8_.y + _loc8_.height - 2;
               comNeedPropVec = new Vector.<com.mvc.views.uis.mainCity.myElf.SimplePropUI>([]);
               _loc11_ = 0;
               while(_loc11_ < _loc14_.length)
               {
                  _loc9_ = GetPropFactor.getProp(_loc14_[_loc11_]);
                  if(!_loc9_)
                  {
                     _loc9_ = GetPropFactor.getPropVO(_loc14_[_loc11_]);
                  }
                  _loc6_ = new com.mvc.views.uis.mainCity.myElf.SimplePropUI(0.6,1,true);
                  _loc6_.lastBestPropVo = param1;
                  _loc6_.lastPropVo = param2;
                  _loc6_.myPropVo = _loc9_;
                  _loc6_.x = _loc10_.x - 35 + _loc11_ * 85;
                  _loc6_.y = _loc10_.y + _loc10_.height;
                  _loc6_.identity = "合成3";
                  styleContain.addChild(_loc6_);
                  comNeedPropVec.push(_loc6_);
                  if(!_loc6_.isMeet)
                  {
                     isAllMeet = false;
                  }
                  _loc11_++;
               }
            }
            else
            {
               if(_loc15_.composeMoney < PlayerVO.silver)
               {
                  compCost.text = "合成花费: " + _loc15_.composeMoney;
                  compCost.color = 3407616;
               }
               else
               {
                  compCost.color = 16711680;
                  isAllMeet = false;
               }
               _loc10_ = swf.createImage("img_comp1");
               _loc10_.x = spr_compChild2.width - _loc10_.width >> 1;
               _loc10_.y = _loc8_.y + _loc8_.height - 2;
               comNeedPropVec = new Vector.<com.mvc.views.uis.mainCity.myElf.SimplePropUI>([]);
               _loc7_ = GetPropFactor.getProp(_loc15_.id);
               if(!_loc7_)
               {
                  _loc7_ = _loc15_;
               }
               _loc5_ = new com.mvc.views.uis.mainCity.myElf.SimplePropUI(0.6,_loc7_.composeNum,true);
               _loc5_.lastBestPropVo = param1;
               _loc5_.lastPropVo = param2;
               _loc5_.myPropVo = _loc7_;
               _loc5_.y = _loc10_.y + _loc10_.height;
               _loc5_.x = _loc10_.x - (_loc5_.width - _loc10_.width) / 2;
               _loc5_.identity = "合成3";
               styleContain.addChild(_loc5_);
               comNeedPropVec.push(_loc5_);
               if(!_loc5_.isMeet)
               {
                  isAllMeet = false;
               }
            }
            styleContain.addChild(_loc10_);
         }
      }
      
      public function addStyleThree(param1:PropVO, param2:PropVO, param3:PropVO = null) : void
      {
         var _loc7_:* = null;
         var _loc5_:* = null;
         var _loc9_:* = null;
         var _loc13_:* = null;
         var _loc15_:* = null;
         var _loc10_:* = null;
         var _loc11_:* = null;
         var _loc8_:* = null;
         var _loc6_:* = null;
         styleContain.removeChildren(0,-1,true);
         showbottom(false);
         if(param3)
         {
            propName2.text = param3.name;
         }
         else
         {
            propName2.text = param2.name;
         }
         var _loc4_:com.mvc.views.uis.mainCity.myElf.SimplePropUI = new com.mvc.views.uis.mainCity.myElf.SimplePropUI(0.6,0,true);
         _loc4_.myPropVo = param1;
         _loc4_.identity = "one";
         _loc4_.x = 20;
         _loc4_.y = 53;
         styleContain.addChild(_loc4_);
         var _loc12_:SwfImage = swf.createImage("img_beacon");
         _loc12_.pivotX = _loc12_.width / 2;
         _loc12_.x = _loc4_.width + _loc4_.x + 3;
         _loc12_.y = (_loc4_.height - _loc12_.height >> 1) + _loc4_.y + 5;
         _loc12_.rotation = 80;
         styleContain.addChild(_loc12_);
         var _loc14_:SwfImage = swf.createImage("img_beacon");
         if(param2.type == 22)
         {
            _loc7_ = new com.mvc.views.uis.mainCity.myElf.SimplePropUI(0.6,0,false);
            _loc7_.myPropVo = param2;
            _loc7_.lastPropVo = param1;
            _loc7_.x = _loc12_.x + _loc12_.width;
            _loc7_.y = 53;
            styleContain.addChild(_loc7_);
            _loc14_.x = (_loc7_.width - _loc14_.x >> 1) + _loc7_.x;
            _loc14_.y = _loc7_.height + _loc7_.y;
            styleContain.addChild(_loc14_);
            addList(param2);
         }
         else
         {
            _loc5_ = new com.mvc.views.uis.mainCity.myElf.SimplePropUI(0.6,0,true);
            _loc5_.myPropVo = param2;
            _loc5_.lastPropVo = param1;
            _loc5_.identity = "two";
            _loc5_.x = _loc12_.x + _loc12_.width;
            _loc5_.y = 53;
            styleContain.addChild(_loc5_);
            _loc14_.pivotX = _loc14_.width / 2;
            _loc14_.x = _loc5_.width + _loc5_.x + 3;
            _loc14_.y = (_loc5_.height - _loc14_.height >> 1) + _loc5_.y + 5;
            _loc14_.rotation = 80;
            styleContain.addChild(_loc14_);
         }
         if(param3)
         {
            isAllMeet = true;
            _loc9_ = new com.mvc.views.uis.mainCity.myElf.SimplePropUI(0.6,0,false);
            _loc9_.myPropVo = param3;
            _loc9_.x = _loc14_.x + _loc14_.width;
            _loc9_.y = 53;
            styleContain.addChild(_loc9_);
            _loc13_ = swf.createImage("img_beacon");
            _loc13_.x = (_loc9_.width - _loc13_.width >> 1) + _loc9_.x;
            _loc13_.y = _loc9_.y + _loc9_.height;
            styleContain.addChild(_loc13_);
            if(param3.type == 18)
            {
               _loc15_ = GetPropFactor.getBrokenPropByComposeID(param3.id);
               propName2.text = param3.name;
               if(!_loc15_)
               {
                  showbottom(false);
                  addList(param3);
               }
               else
               {
                  showbottom(true);
                  if(_loc15_.composeMoney < PlayerVO.silver)
                  {
                     compCost.text = "合成花费: " + _loc15_.composeMoney;
                     compCost.color = 3407616;
                  }
                  else
                  {
                     compCost.color = 16711680;
                     isAllMeet = false;
                  }
                  _loc10_ = new com.mvc.views.uis.mainCity.myElf.SimplePropUI(0.7);
                  _loc10_.myPropVo = param3;
                  comPropVo = param3;
                  _loc10_.x = spr_compChild2.width - _loc10_.width >> 1;
                  _loc10_.y = propName2.y + propName2.height + 5;
                  styleContain.addChild(_loc10_);
                  posX = _loc10_.x;
                  posY = _loc10_.y;
                  _loc11_ = swf.createImage("img_comp1");
                  _loc11_.x = spr_compChild2.width - _loc11_.width >> 1;
                  _loc11_.y = _loc10_.y + _loc10_.height - 2;
                  styleContain.addChild(_loc11_);
                  comNeedPropVec = new Vector.<com.mvc.views.uis.mainCity.myElf.SimplePropUI>([]);
                  _loc8_ = GetPropFactor.getProp(_loc15_.id);
                  if(!_loc8_)
                  {
                     _loc8_ = _loc15_;
                  }
                  _loc6_ = new com.mvc.views.uis.mainCity.myElf.SimplePropUI(0.6,_loc8_.composeNum,true);
                  _loc6_.lastBestBestPropVo = param1;
                  _loc6_.lastBestPropVo = param2;
                  _loc6_.lastPropVo = param3;
                  _loc6_.myPropVo = _loc8_;
                  _loc6_.y = _loc11_.y + _loc11_.height;
                  _loc6_.x = _loc11_.x - (_loc6_.width - _loc11_.width) / 2;
                  _loc6_.identity = "合成4";
                  styleContain.addChild(_loc6_);
                  comNeedPropVec.push(_loc6_);
                  if(!_loc6_.isMeet)
                  {
                     isAllMeet = false;
                  }
               }
            }
            else
            {
               addList(param3);
            }
         }
      }
      
      public function addStylefour(param1:PropVO, param2:PropVO, param3:PropVO, param4:PropVO) : void
      {
         styleContain.removeChildren(0,-1,true);
         showbottom(false);
         propName2.text = param4.name;
         var _loc5_:com.mvc.views.uis.mainCity.myElf.SimplePropUI = new com.mvc.views.uis.mainCity.myElf.SimplePropUI(0.6,0,true);
         _loc5_.myPropVo = param1;
         _loc5_.identity = "one";
         _loc5_.x = 20;
         _loc5_.y = 53;
         styleContain.addChild(_loc5_);
         var _loc10_:SwfImage = swf.createImage("img_beacon");
         _loc10_.pivotX = _loc10_.width / 2;
         _loc10_.x = _loc5_.width + _loc5_.x + 3;
         _loc10_.y = (_loc5_.height - _loc10_.height >> 1) + _loc5_.y + 5;
         _loc10_.rotation = 80;
         styleContain.addChild(_loc10_);
         var _loc6_:com.mvc.views.uis.mainCity.myElf.SimplePropUI = new com.mvc.views.uis.mainCity.myElf.SimplePropUI(0.6,0,true);
         _loc6_.myPropVo = param2;
         _loc6_.lastPropVo = param1;
         _loc6_.identity = "two";
         _loc6_.x = _loc10_.x + _loc10_.width;
         _loc6_.y = 53;
         styleContain.addChild(_loc6_);
         var _loc12_:SwfImage = swf.createImage("img_beacon");
         _loc12_.pivotX = _loc12_.width / 2;
         _loc12_.x = _loc6_.width + _loc6_.x + 3;
         _loc12_.y = (_loc6_.height - _loc12_.height >> 1) + _loc6_.y + 5;
         _loc12_.rotation = 80;
         styleContain.addChild(_loc12_);
         var _loc8_:com.mvc.views.uis.mainCity.myElf.SimplePropUI = new com.mvc.views.uis.mainCity.myElf.SimplePropUI(0.6,0,true);
         _loc8_.lastBestPropVo = param1;
         _loc8_.lastPropVo = param2;
         _loc8_.myPropVo = param3;
         _loc8_.identity = "three";
         _loc8_.x = _loc12_.x + _loc12_.width;
         _loc8_.y = 53;
         styleContain.addChild(_loc8_);
         var _loc11_:SwfImage = swf.createImage("img_beacon");
         _loc11_.x = _loc8_.width + _loc8_.x + 3;
         _loc11_.y = (_loc8_.height - _loc11_.height >> 1) + _loc8_.y + 5;
         styleContain.addChild(_loc11_);
         var _loc9_:com.mvc.views.uis.mainCity.myElf.SimplePropUI = new com.mvc.views.uis.mainCity.myElf.SimplePropUI(0.6,0,false);
         _loc9_.myPropVo = param4;
         _loc9_.x = _loc11_.x + _loc11_.width;
         _loc9_.y = 53;
         styleContain.addChild(_loc9_);
         var _loc7_:SwfImage = swf.createImage("img_beacon");
         _loc7_.x = (_loc9_.width - _loc7_.width >> 1) + _loc9_.x;
         _loc7_.y = _loc9_.y + _loc9_.height;
         styleContain.addChild(_loc7_);
         addList(param4);
      }
      
      private function addList(param1:PropVO) : void
      {
         stoneGuideList = new List();
         stoneGuideList.x = 20;
         stoneGuideList.y = 170;
         stoneGuideList.width = 340;
         stoneGuideList.height = 220;
         stoneGuideList.name = "breakDropList";
         styleContain.addChild(stoneGuideList);
         stoneGuideList.addEventListener("creationComplete",stoneGuideLis_createHandler);
         addWriteInfo(param1);
      }
      
      private function stoneGuideLis_createHandler(param1:Event) : void
      {
         var _loc2_:AssetManager = LoadOtherAssetsManager.getInstance().assets;
         var _loc3_:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
         _loc3_.defaultValue = new Scale9Textures(_loc2_.getTexture("listBg"),new Rectangle(15,15,15,15));
         _loc3_.defaultSelectedValue = new Scale9Textures(_loc2_.getTexture("listBg"),new Rectangle(15,15,15,15));
         stoneGuideList.itemRendererProperties.stateToSkinFunction = _loc3_.updateValue;
      }
      
      private function addWriteInfo(param1:PropVO) : void
      {
         if(!GetMapFactor.allPropBirthPllace.hasOwnProperty(param1.id))
         {
            Tips.show("没有这个道具的消息");
            return;
         }
         propBirthArr = GetMapFactor.allPropBirthPllace[param1.id];
         (Facade.getInstance().retrieveProxy("MyElfPro") as MyElfPro).write3010(propBirthArr);
      }
      
      public function showDropList(param1:Array) : void
      {
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc4_:* = 0;
         var _loc14_:* = 0;
         var _loc11_:* = false;
         var _loc10_:* = false;
         var _loc15_:* = undefined;
         var _loc8_:* = 0;
         var _loc12_:* = null;
         var _loc9_:* = null;
         var _loc13_:* = null;
         var _loc3_:* = null;
         LogUtil("openArr========",param1);
         var _loc2_:Array = [];
         _loc6_ = 0;
         while(_loc6_ < propBirthArr.length)
         {
            _loc7_ = GetMapFactor.countCityId(propBirthArr[_loc6_].nodeId);
            _loc4_ = propBirthArr[_loc6_].rcdId;
            _loc14_ = propBirthArr[_loc6_].nodeId;
            _loc11_ = propBirthArr[_loc6_].isHard;
            _loc10_ = param1[_loc6_];
            _loc15_ = GetMapFactor.getRecIdArr(_loc14_);
            _loc8_ = 0;
            while(_loc8_ < _loc15_.length)
            {
               if(_loc15_[_loc8_].id == _loc4_)
               {
                  nodeRcdIndex = _loc8_;
                  break;
               }
               _loc8_++;
            }
            if(_loc11_)
            {
               _loc9_ = "<font color=\'#33cc00\' size=\'22\'>[精英]</font>";
            }
            else
            {
               _loc9_ = "<font color=\'#ff9900\' size=\'22\'>[普通]</font>";
            }
            if(_loc10_)
            {
               _loc13_ = "<font color=\'#48271b\' size=\'22\'>已开启</font>";
               _loc3_ = "\'#48271b\'";
            }
            else
            {
               _loc13_ = "<font color=\'#9b8f9e\' size=\'22\'>未开启</font>";
               _loc3_ = "\'#9b8f9e\'";
            }
            _loc12_ = "<font color=" + _loc3_ + " size=\'22\'>" + GetMapFactor.getCityNameById(_loc7_) + " - " + _loc15_[nodeRcdIndex].name + "    " + _loc9_ + "\n" + _loc15_[nodeRcdIndex].descs + "</font>";
            LogUtil("cityID=",_loc7_," nodeID=",_loc14_," nodeRcdID=",_loc4_," nodeRcdIndex=",nodeRcdIndex," isOpen=",_loc10_," isHard=",_loc11_);
            if(_loc10_)
            {
               _loc2_.unshift({
                  "label":_loc12_,
                  "cityID":_loc7_,
                  "nodeID":_loc14_,
                  "nodeRcdID":_loc4_,
                  "nodeRcdIndex":nodeRcdIndex,
                  "isOpen":_loc10_,
                  "isHard":_loc11_
               });
            }
            else
            {
               _loc2_.push({
                  "label":_loc12_,
                  "cityID":_loc7_,
                  "nodeID":_loc14_,
                  "nodeRcdID":_loc4_,
                  "nodeRcdIndex":nodeRcdIndex,
                  "isOpen":_loc10_,
                  "isHard":_loc11_
               });
            }
            _loc6_++;
         }
         var _loc5_:ListCollection = new ListCollection(_loc2_);
         stoneGuideList.dataProvider = _loc5_;
         stoneGuideList.addEventListener("change",seleStoneGuideList);
         stoneGuideList.dataViewPort.addEventListener("CREAT_LIST_COMPLETE",creatListComplete);
      }
      
      private function creatListComplete() : void
      {
         LogUtil("list名字" + stoneGuideList.name);
         BeginnerGuide.playBeginnerGuide();
         stoneGuideList.dataViewPort.removeEventListener("CREAT_LIST_COMPLETE",creatListComplete);
      }
      
      private function seleStoneGuideList(param1:Event) : void
      {
         var _loc6_:List = List(param1.currentTarget);
         var _loc4_:int = _loc6_.selectedIndex;
         if(_loc4_ < 0)
         {
            return;
         }
         var _loc3_:Object = stoneGuideList.dataProvider.getItemAt(_loc4_);
         var _loc5_:int = _loc3_.cityID;
         var _loc2_:Boolean = _loc3_.isOpen;
         EvoStoneGuideUI.nodeID = _loc3_.nodeID;
         if(!_loc2_)
         {
            TaskMedia.nodeId = _loc3_.nodeID;
            if(EvoStoneGuideUI.cityID == _loc5_ && (Starling.current.root as Game).page.name == "MapMeida")
            {
               Facade.getInstance().sendNotification("update_city_point_open");
            }
            else
            {
               EvoStoneGuideUI.cityID = _loc5_;
               WorldMapMedia.mapVO = GetMapFactor.getMapVoById(EvoStoneGuideUI.cityID);
               Config.cityScene = WorldMapMedia.mapVO.bgImg;
               (Facade.getInstance().retrieveProxy("MapPro") as MapPro).write1703(WorldMapMedia.mapVO);
            }
         }
         else
         {
            LogUtil("城市id===",_loc5_);
            EvoStoneGuideUI.isEvoStoneGuide = true;
            EvoStoneGuideUI.nodeRcdID = _loc3_.nodeRcdID;
            EvoStoneGuideUI.nodeRcdIndex = _loc3_.nodeRcdIndex;
            EvoStoneGuideUI.isHard = _loc3_.isHard;
            if(EvoStoneGuideUI.cityID == _loc5_ && (Starling.current.root as Game).page.name == "MapMeida")
            {
               Facade.getInstance().sendNotification("open_main_advance_list_by_evoStone",EvoStoneGuideUI.isHard);
            }
            else
            {
               EvoStoneGuideUI.cityID = _loc5_;
               WorldMapMedia.mapVO = GetMapFactor.getMapVoById(EvoStoneGuideUI.cityID);
               Config.cityScene = WorldMapMedia.mapVO.bgImg;
               (Facade.getInstance().retrieveProxy("MapPro") as MapPro).write1703(WorldMapMedia.mapVO);
            }
         }
         stoneGuideList.selectedIndex = -1;
         MyElfMedia.isJumpPage = true;
         (Facade.getInstance().retrieveMediator("MyElfMedia") as MyElfMedia).myElf.removeFromParent();
         WinTweens.showCity();
      }
      
      private function click(param1:Event) : void
      {
         e = param1;
         var _loc3_:* = e.target;
         if(btn_collect !== _loc3_)
         {
            if(btn_comp !== _loc3_)
            {
               if(btn_return !== _loc3_)
               {
                  if(btn_close1 !== _loc3_)
                  {
                     if(btn_close2 !== _loc3_)
                     {
                     }
                  }
                  remove();
               }
               else
               {
                  if(isCloseSecond)
                  {
                     isCloseSecond = false;
                     btn_close1.visible = true;
                     spr_compChild2.removeFromParent();
                     var t2:Tween = new Tween(spr_compChild1,0.15,"linear");
                     Starling.juggler.add(t2);
                     t2.animate("x",1136 - spr_compChild1.width >> 1,spr_compChild1.x);
                     t2.onComplete = function():void
                     {
                        btn_collect.enabled = true;
                     };
                     return;
                  }
                  EventCenter.dispatchEvent("BREAK_RETURN");
               }
            }
            else
            {
               if(!isAllMeet)
               {
                  Tips.show("合成条件不满足");
                  return;
               }
               if(comPropVo.type == 18)
               {
                  EventCenter.addEventListener("BOKEN_COMPOSE_SUCCES",comBrokenSucces);
                  (Facade.getInstance().retrieveProxy("BackPackPro") as BackPackPro).write3008(GetPropFactor.getBrokenPropByComposeID(comPropVo.id).id);
               }
               else if(comPropVo.type == 19)
               {
                  EventCenter.addEventListener("BOKEN_COMPOSE_SUCCES",comRobotSucces);
                  (Facade.getInstance().retrieveProxy("MyElfPro") as MyElfPro).write3009(comPropVo.id);
               }
            }
         }
         else
         {
            btn_collect.enabled = false;
            btn_close1.visible = false;
            var t:Tween = new Tween(spr_compChild1,0.15,"linear");
            Starling.juggler.add(t);
            t.animate("x",185,spr_compChild1.x);
            t.onComplete = function():void
            {
               spr_compChild2.x = spr_compChild1.x + spr_compChild1.width;
               addChild(spr_compChild2);
               addStyleOne(_propVo);
            };
         }
      }
      
      private function comRobotSucces() : void
      {
         var _loc1_:* = 0;
         LogUtil("合成机器人道具成功");
         playRobotAni();
         EventCenter.removeEventListener("BOKEN_COMPOSE_SUCCES",comRobotSucces);
         GetPropFactor.addOrLessProp(comPropVo);
         Facade.getInstance().sendNotification("update_play_money_info",PlayerVO.silver - comPropVo.composeMoney);
         _loc1_ = 0;
         while(_loc1_ < comNeedPropVec.length)
         {
            GetPropFactor.addOrLessProp(comNeedPropVec[_loc1_]._propVo,false);
            comNeedPropVec[_loc1_].myPropVo = comNeedPropVec[_loc1_]._propVo;
            if(!comNeedPropVec[_loc1_].isMeet)
            {
               isAllMeet = false;
            }
            _loc1_++;
         }
         compCost.text = "合成花费: " + comPropVo.composeMoney;
         if(comPropVo.composeMoney < PlayerVO.silver)
         {
            compCost.color = 3407616;
         }
         else
         {
            compCost.color = 16711680;
            isAllMeet = false;
         }
         myPropVo = GetPropFactor.getProp(comPropVo.id);
      }
      
      private function playRobotAni() : void
      {
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","propCom");
         var imgVec:Vector.<Sprite> = new Vector.<Sprite>([]);
         var i:int = 0;
         while(i < comNeedPropVec.length)
         {
            var img:Sprite = GetpropImage.getPropSpr(comNeedPropVec[i]._propVo,true,0.6);
            img.x = comNeedPropVec[i].x;
            img.y = comNeedPropVec[i].y;
            styleContain.addChild(img);
            imgVec.push(img);
            var t:Tween = new Tween(img,0.3);
            Starling.juggler.add(t);
            t.animate("x",posX + 5,img.x);
            t.animate("y",posY - 5,img.y);
            t.animate("alpha",0.5,1);
            t.onComplete = function():void
            {
               var _loc1_:* = 0;
               _loc1_ = 0;
               while(_loc1_ < imgVec.length)
               {
                  imgVec[_loc1_].removeFromParent(true);
                  _loc1_++;
               }
            };
            i = i + 1;
         }
      }
      
      private function comBrokenSucces() : void
      {
         var _loc2_:* = 0;
         LogUtil("合成玩偶道具成功");
         playRobotAni();
         EventCenter.removeEventListener("BOKEN_COMPOSE_SUCCES",comBrokenSucces);
         var _loc1_:PropVO = GetPropFactor.getBrokenPropByComposeID(comPropVo.id);
         GetPropFactor.addOrLessProp(comPropVo);
         Facade.getInstance().sendNotification("update_play_money_info",PlayerVO.silver - comPropVo.composeMoney);
         _loc2_ = 0;
         while(_loc2_ < comNeedPropVec.length)
         {
            GetPropFactor.addOrLessProp(comNeedPropVec[_loc2_]._propVo,false,comNeedPropVec[_loc2_]._propVo.composeNum);
            comNeedPropVec[_loc2_].myPropVo = comNeedPropVec[_loc2_]._propVo;
            if(!comNeedPropVec[_loc2_].isMeet)
            {
               isAllMeet = false;
            }
            _loc2_++;
         }
         if(comNeedPropVec.length > 0)
         {
            compCost.text = "合成花费: " + comNeedPropVec[0]._propVo.composeMoney;
            if(comNeedPropVec[0]._propVo.composeMoney < PlayerVO.silver)
            {
               compCost.color = 3407616;
            }
            else
            {
               compCost.color = 16711680;
               isAllMeet = false;
            }
         }
         if(_propVo.type == 18)
         {
            myPropVo = GetPropFactor.getProp(comPropVo.id);
         }
      }
      
      public function set myPropVo(param1:PropVO) : void
      {
         _propVo = param1;
         propName.text = param1.name;
         propCount.text = "数量: " + param1.count;
         propDec.text = param1.describe;
         if(propImg)
         {
            propImg.removeFromParent(true);
         }
         propImg = new com.mvc.views.uis.mainCity.myElf.SimplePropUI();
         propImg.myPropVo = param1;
         propImg.x = 22;
         propImg.y = 57;
         spr_compChild1.addChild(propImg);
      }
      
      public function upDdateChild1() : void
      {
         var _loc1_:PropVO = GetPropFactor.getProp(_propVo.id);
         if(!_loc1_)
         {
            _loc1_ = GetPropFactor.getPropVO(_propVo.id);
            LogUtil("没有这个道具===",_loc1_.name);
         }
         LogUtil("更新子界面1===========",_loc1_.count);
         myPropVo = _loc1_;
      }
      
      public function remove() : void
      {
         if(getInstance().parent)
         {
            btn_collect.enabled = true;
            btn_close1.visible = true;
            if(spr_compChild1.parent)
            {
               spr_compChild1.removeFromParent();
            }
            if(spr_compChild2.parent)
            {
               spr_compChild2.removeFromParent();
            }
            spr_compChild1.x = 1136 - spr_compChild1.width >> 1;
            spr_compChild1.y = 640 - spr_compChild1.height >> 1;
            addChild(spr_compChild1);
            getInstance().removeFromParent();
            EventCenter.dispatchEvent("COMPROP_SUCCESS");
         }
      }
   }
}
