package com.mvc.views.uis.mainCity.exChange
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.List;
   import starling.display.DisplayObject;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.elf.ElfVO;
   import feathers.data.ListCollection;
   import com.common.util.DisposeDisplay;
   import starling.events.Event;
   import com.common.events.EventCenter;
   import starling.display.Quad;
   
   public class ExSeleElfUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.exChange.ExSeleElfUI;
       
      private var swf:Swf;
      
      private var spr_seleElf:SwfSprite;
      
      private var btn_close:SwfButton;
      
      private var allElfList:List;
      
      private var displayVec:Vector.<DisplayObject>;
      
      public function ExSeleElfUI()
      {
         displayVec = new Vector.<DisplayObject>([]);
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         addList();
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.exChange.ExSeleElfUI
      {
         return instance || new com.mvc.views.uis.mainCity.exChange.ExSeleElfUI();
      }
      
      private function addList() : void
      {
         allElfList = new List();
         allElfList.x = 10;
         allElfList.y = 85;
         allElfList.width = 760;
         allElfList.height = 400;
         allElfList.isSelectable = false;
         allElfList.itemRendererProperties.stateToSkinFunction = null;
         spr_seleElf.addChild(allElfList);
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("exChange");
         spr_seleElf = swf.createSprite("spr_seleElf");
         btn_close = spr_seleElf.getButton("btn_close");
         btn_close.addEventListener("triggered",onclick);
         spr_seleElf.x = 1136 - spr_seleElf.width >> 1;
         spr_seleElf.y = 640 - spr_seleElf.height >> 1;
         addChild(spr_seleElf);
      }
      
      public function show(param1:Vector.<ElfVO>) : void
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
      
      private function onclick(param1:Event) : void
      {
         remove();
         EventCenter.dispatchEvent("SELE_EXCHANGE_ELF");
      }
      
      public function remove() : void
      {
         clean();
         removeFromParent(true);
         instance = null;
      }
   }
}
