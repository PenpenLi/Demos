package com.mvc.views.uis.mainCity.backPack
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.List;
   import starling.display.DisplayObject;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.common.themes.Tips;
   import com.mvc.views.uis.mainCity.exChange.ElfUnitUI;
   import feathers.data.ListCollection;
   import com.common.util.DisposeDisplay;
   import starling.display.Quad;
   
   public class CanLearnElf extends Sprite
   {
      
      private static var instance:com.mvc.views.uis.mainCity.backPack.CanLearnElf;
       
      private var swf:Swf;
      
      private var spr_learnelf:SwfSprite;
      
      private var btn_close:SwfButton;
      
      private var allElfList:List;
      
      private var displayVec:Vector.<DisplayObject>;
      
      public function CanLearnElf()
      {
         displayVec = new Vector.<DisplayObject>([]);
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         addList();
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.backPack.CanLearnElf
      {
         return instance || new com.mvc.views.uis.mainCity.backPack.CanLearnElf();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("bag");
         spr_learnelf = swf.createSprite("spr_learnelf");
         btn_close = spr_learnelf.getButton("btn_close");
         spr_learnelf.x = 1136 - spr_learnelf.width >> 1;
         spr_learnelf.y = 640 - spr_learnelf.height >> 1;
         addChild(spr_learnelf);
         btn_close.addEventListener("triggered",remove);
      }
      
      private function addList() : void
      {
         allElfList = new List();
         allElfList.x = 18;
         allElfList.y = 70;
         allElfList.width = 760;
         allElfList.height = 363;
         allElfList.isSelectable = false;
         allElfList.itemRendererProperties.stateToSkinFunction = null;
         spr_learnelf.addChild(allElfList);
      }
      
      public function show(param1:PropVO) : void
      {
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         LogUtil("计算可以学习这个学习机的所有精灵",param1.validElf);
         var _loc6_:Vector.<ElfVO> = new Vector.<ElfVO>([]);
         var _loc3_:Vector.<ElfVO> = new Vector.<ElfVO>([]);
         _loc4_ = 0;
         while(_loc4_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc4_])
            {
               if(param1.validElf.indexOf(PlayerVO.bagElfVec[_loc4_].elfId) != -1)
               {
                  _loc3_.push(PlayerVO.bagElfVec[_loc4_]);
               }
            }
            _loc4_++;
         }
         LogUtil("背包中寻找",_loc3_.length);
         GetElfFactor.elfSort(_loc3_,"lv");
         GetElfFactor.elfSort(_loc3_,"rareValue");
         var _loc2_:Vector.<ElfVO> = new Vector.<ElfVO>([]);
         _loc5_ = 0;
         while(_loc5_ < PlayerVO.comElfVec.length)
         {
            if(param1.validElf.indexOf(PlayerVO.comElfVec[_loc5_].elfId) != -1)
            {
               _loc2_.push(PlayerVO.comElfVec[_loc5_]);
            }
            _loc5_++;
         }
         LogUtil("电脑中寻找",_loc2_.length);
         GetElfFactor.elfSort(_loc2_,"lv");
         GetElfFactor.elfSort(_loc2_,"rareValue");
         _loc6_ = _loc3_.concat(_loc2_);
         LogUtil("所有精灵 ====== ",_loc6_.length);
         if(_loc6_.length > 0)
         {
            show2(_loc6_);
         }
         else
         {
            instance = null;
            Tips.show("暂时没有精灵可学习这个学习机");
         }
      }
      
      public function show2(param1:Vector.<ElfVO>) : void
      {
         var _loc10_:* = 0;
         var _loc7_:* = null;
         var _loc11_:* = 0;
         var _loc5_:* = null;
         clean();
         var _loc9_:int = param1.length;
         var _loc4_:* = 6;
         var _loc2_:Array = [];
         var _loc6_:int = Math.floor(_loc9_ / _loc4_);
         var _loc3_:* = _loc4_;
         if(_loc9_ % _loc4_ != 0)
         {
            _loc6_++;
         }
         _loc10_ = 0;
         while(_loc10_ < _loc6_)
         {
            _loc7_ = new Sprite();
            if(_loc10_ == _loc6_ - 1 && _loc9_ % _loc4_ != 0)
            {
               _loc3_ = _loc9_ % _loc4_;
            }
            _loc11_ = 0;
            while(_loc11_ < _loc3_)
            {
               _loc5_ = new ElfUnitUI();
               _loc5_.x = 126 * _loc11_;
               _loc5_.myElfVo = param1[_loc4_ * _loc10_ + _loc11_];
               _loc5_.touchable = false;
               _loc7_.addChild(_loc5_);
               _loc11_++;
            }
            _loc2_.push({
               "icon":_loc7_,
               "label":""
            });
            displayVec.push(_loc7_);
            _loc10_++;
         }
         var _loc8_:ListCollection = new ListCollection(_loc2_);
         allElfList.dataProvider = _loc8_;
         (Config.starling.root as Game).addChild(this);
      }
      
      private function clean() : void
      {
         if(allElfList.dataProvider)
         {
            allElfList.dataProvider.removeAll();
            allElfList.dataProvider = null;
            DisposeDisplay.dispose(displayVec);
            displayVec = Vector.<DisplayObject>([]);
         }
      }
      
      private function remove() : void
      {
         clean();
         removeFromParent(true);
         instance = null;
      }
   }
}
