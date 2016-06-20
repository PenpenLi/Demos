package com.mvc.views.uis.mapSelect
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.display.Button;
   import starling.display.Image;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfMovieClip;
   import flash.geom.Point;
   import lzm.starling.swf.display.SwfImage;
   import lzm.starling.swf.display.SwfButton;
   import com.mvc.models.vos.mapSelect.MapVO;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.managers.LoadOtherAssetsManager;
   import lzm.starling.swf.display.SwfScale9Image;
   import com.common.managers.ElfFrontImageManager;
   import com.mvc.views.mediator.mainCity.task.TaskMedia;
   import starling.core.Starling;
   import com.common.util.Finger;
   import starling.text.TextField;
   import com.common.util.xmlVOHandler.GetMapFactor;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.mvc.views.mediator.fighting.AniFactor;
   
   public class CityMapUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var closeBtn:Button;
      
      public var bg:Image;
      
      private var frame:SwfSprite;
      
      private var extenMapMark:SwfMovieClip;
      
      public var location:Point;
      
      public var markVec:Vector.<SwfMovieClip>;
      
      public var starVec:Vector.<SwfSprite>;
      
      public var doubleVec:Vector.<SwfImage>;
      
      private var icon:Image;
      
      private var iconVec:Vector.<Image>;
      
      public var bombBtn:SwfButton;
      
      public var promptImg:Image;
      
      private var _mapVo:MapVO;
      
      public function CityMapUI()
      {
         location = new Point();
         markVec = new Vector.<SwfMovieClip>([]);
         starVec = new Vector.<SwfSprite>([]);
         doubleVec = new Vector.<SwfImage>([]);
         iconVec = new Vector.<Image>([]);
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("cityMap");
         closeBtn = swf.createButton("btn_worldBtn_b");
         var _loc1_:* = 0.8;
         closeBtn.scaleY = _loc1_;
         closeBtn.scaleX = _loc1_;
         closeBtn.x = 80;
         closeBtn.y = 565;
         bombBtn = swf.createButton("btn_bombBtn_b");
         _loc1_ = 0.8;
         bombBtn.scaleY = _loc1_;
         bombBtn.scaleX = _loc1_;
         bombBtn.x = 10;
         bombBtn.y = 565;
         promptImg = LoadSwfAssetsManager.getInstance().assets.getSwf("common").createImage("img_new");
         promptImg.x = bombBtn.x;
         promptImg.y = bombBtn.y;
         _loc1_ = 0.8;
         promptImg.scaleY = _loc1_;
         promptImg.scaleX = _loc1_;
      }
      
      public function updateShow(param1:MapVO) : void
      {
         _mapVo = param1;
         if(frame)
         {
            frame.removeChildren(0,-1,true);
            frame.dispose();
            bg.texture.dispose();
            bg.dispose();
         }
         LogUtil("===================",param1.frameImg,Config.cityScene);
         frame = swf.createSprite(param1.frameImg);
         if(frame.getSprite("path") == null)
         {
            addChild(closeBtn);
            return;
         }
         bg = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(Config.cityScene));
         addChild(bg);
         var _loc2_:SwfScale9Image = LoadSwfAssetsManager.getInstance().assets.getSwf("loading").createS9Image("s9_BG");
         _loc2_.touchable = false;
         _loc2_.width = 154;
         _loc2_.height = 83;
         _loc2_.y = 561;
         addChild(_loc2_);
         frame.getSprite("path").flatten();
         addChild(frame);
         cleanMark();
         setFrameOpen();
         addChild(closeBtn);
         addChild(bombBtn);
      }
      
      public function cleanMark() : void
      {
         var _loc1_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc2_:* = 0;
         LogUtil("清除上一次的记录动画");
         _loc1_ = 0;
         while(_loc1_ < markVec.length)
         {
            markVec[_loc1_].stop(true);
            markVec[_loc1_].removeFromParent(true);
            _loc1_++;
         }
         markVec = Vector.<SwfMovieClip>([]);
         _loc3_ = 0;
         while(_loc3_ < iconVec.length)
         {
            ElfFrontImageManager.getInstance().disposeImg(iconVec[_loc3_]);
            _loc3_++;
         }
         iconVec = Vector.<Image>([]);
         _loc4_ = 0;
         while(_loc4_ < starVec.length)
         {
            starVec[_loc4_].removeFromParent(true);
            _loc4_++;
         }
         starVec = Vector.<SwfSprite>([]);
         _loc2_ = 0;
         while(_loc2_ < doubleVec.length)
         {
            doubleVec[_loc2_].removeFromParent(true);
            _loc2_++;
         }
         doubleVec = Vector.<SwfImage>([]);
      }
      
      public function setFrameOpen() : void
      {
         var _loc2_:* = 0;
         var _loc4_:* = null;
         var _loc1_:* = null;
         var _loc3_:* = 0;
         LogUtil("设置节点开启情况");
         _loc2_ = 1;
         while(_loc2_ < frame.numChildren)
         {
            _loc4_ = frame.getChildAt(_loc2_) as SwfButton;
            _loc1_ = _loc4_.skin as Sprite;
            if(_loc4_.name.indexOf("main") != -1)
            {
               _loc3_ = _loc4_.name.substr(4);
               LogUtil("id == TaskMedia.nodeId===========",_loc3_,TaskMedia.nodeId);
               if(_loc3_ == TaskMedia.nodeId)
               {
                  LogUtil("有没有跳转到任务目的节点" + _loc4_.name);
                  TaskMedia.nodeId = 0;
                  (Starling.current.root as Game).addChild(Finger.getInstance());
                  Finger.getInstance().setFinger(_loc4_);
               }
               if(_loc3_ == 37)
               {
                  if(_loc1_.getChildByName("nameTF2") != null)
                  {
                     (_loc1_.getChildByName("nameTF2") as TextField).name = "nameTF";
                  }
               }
               (_loc1_.getChildByName("nameTF") as TextField).text = GetMapFactor.getMainMapNameVoByID(_loc3_);
               if(isOpen(_loc3_))
               {
                  (_loc1_.getChildByName("nameTF") as TextField).color = 16777215;
                  _loc1_.touchable = true;
                  addMainMapMark(_loc4_,_loc3_,_loc1_);
                  LogUtil("id===================",_loc3_);
                  if(_loc3_ == 37)
                  {
                     (_loc1_.getChildByName("nameTF") as TextField).name = "nameTF2";
                  }
               }
               else
               {
                  addIcon(_loc1_,0,_loc3_);
                  (_loc1_.getChildByName("nameTF") as TextField).color = 11184552;
               }
            }
            else if(_loc4_.name.indexOf("exten") != -1)
            {
               _loc3_ = _loc4_.name.substr(5);
               if(_loc3_ == TaskMedia.nodeId)
               {
                  TaskMedia.nodeId = 0;
                  (Starling.current.root as Game).addChild(Finger.getInstance());
                  Finger.getInstance().setFinger(_loc4_);
               }
               (_loc1_.getChildByName("nameTF") as TextField).text = GetMapFactor.getExtenMapNameByID(_loc3_);
               if(isOpen(_loc3_))
               {
                  (_loc1_.getChildByName("nameTF") as TextField).color = 16777215;
                  _loc1_.touchable = true;
                  addMainMapMark(_loc4_,_loc3_,_loc1_);
               }
               else
               {
                  addIcon(_loc1_,0,_loc3_);
                  (_loc1_.getChildByName("nameTF") as TextField).color = 11184552;
               }
            }
            else
            {
               _loc1_.touchable = false;
            }
            _loc2_++;
         }
      }
      
      private function addExtenMapMark(param1:Button) : void
      {
         addChild(extenMapMark);
         extenMapMark.play(true);
         extenMapMark.x = param1.x;
         extenMapMark.y = param1.y;
      }
      
      private function addMainMapMark(param1:Button, param2:int, param3:Sprite) : void
      {
         var _loc4_:* = 0;
         var _loc5_:Array = GetMapFactor.bestNewMapId();
         LogUtil("最新的两个点");
         _loc4_ = 0;
         while(_loc4_ < _loc5_.length)
         {
            if(param2 == _loc5_[_loc4_])
            {
               if(param2 > 10000)
               {
                  if(FightingConfig.openPoint[GetMapFactor.getPointArr().indexOf(param2)].plan == 0)
                  {
                     addCartoon(param1,param3,param2);
                     return;
                  }
               }
               else if(FightingConfig.openPoint[GetMapFactor.getPointArr().indexOf(param2)].plan != GetMapFactor.getRecIdArr(param2)[GetMapFactor.getRecIdArr(param2).length - 1].id)
               {
                  LogUtil("主线====");
                  addCartoon(param1,param3,param2);
                  return;
               }
            }
            _loc4_++;
         }
         addIcon(param3,1,param2);
      }
      
      private function addCartoon(param1:Button, param2:Sprite, param3:int) : void
      {
         LogUtil("添加最新动画");
         var _loc4_:SwfMovieClip = swf.createMovieClip("mc_mark");
         _loc4_.touchable = false;
         _loc4_.x = param1.x + 45;
         _loc4_.y = param1.y - 97;
         addChild(_loc4_);
         _loc4_.play(true);
         markVec.push(_loc4_);
         addIcon(param2,2,param3);
      }
      
      private function isOpen(param1:int) : Boolean
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < FightingConfig.openPoint.length)
         {
            if(FightingConfig.openPoint[_loc2_].rcdId == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function addIcon(param1:Sprite, param2:int, param3:int) : void
      {
         contain = param1;
         state = param2;
         id = param3;
         switch(state)
         {
            case 0:
               icon = swf.createImage("img_notOpen");
               break;
            case 1:
               icon = swf.createImage("img_open");
               if(id < 10000)
               {
                  var spr_starPro:SwfSprite = swf.createSprite("spr_starPro_s");
                  var starTxt:TextField = spr_starPro.getTextField("starTxt");
                  starTxt.text = FightingConfig.openPoint[GetMapFactor.getPointArr().indexOf(id)].currStars + "/" + GetMapFactor.getNodeIdChilds(id) * 6;
                  spr_starPro.x = (contain.width - spr_starPro.width >> 1) - 7;
                  spr_starPro.y = -65;
                  contain.addChild(spr_starPro);
                  starVec.push(spr_starPro);
               }
               break;
            case 2:
               icon = swf.createImage("img_now");
               break;
         }
         if(FightingConfig.cityIdArr.indexOf(_mapVo.id) != -1 && id < 10000)
         {
            var doubleIcon:Image = swf.createImage("img_double");
            doubleIcon.x = -20;
            doubleIcon.y = -50;
            contain.addChild(doubleIcon);
            doubleVec.push(doubleIcon);
         }
         icon.x = (contain.width - icon.width) / 2 - 7;
         icon.y = -25;
         if(id > 10000)
         {
            var imgName:String = GetMapFactor.getExtenMapIcon(id);
            if(imgName)
            {
               var elfIcon:Image = icon;
               var showElf:Function = function():void
               {
                  ElfFrontImageManager.tempNoRemoveTexture = ["img_" + imgName];
                  elfIcon.texture = LoadOtherAssetsManager.getInstance().assets.getTexture("img_" + imgName);
                  var _loc1_:* = 1.5;
                  elfIcon.scaleY = _loc1_;
                  elfIcon.scaleX = _loc1_;
                  elfIcon.x = (contain.width - elfIcon.width) / 2;
                  elfIcon.y = -80;
                  AniFactor.ifOpen = true;
                  AniFactor.elfAni(elfIcon);
                  if(state == 0)
                  {
                  }
               };
               ElfFrontImageManager.getInstance().getImg(["img_" + imgName],showElf);
            }
         }
         contain.addChildAt(icon,0);
         iconVec.push(icon);
      }
   }
}
