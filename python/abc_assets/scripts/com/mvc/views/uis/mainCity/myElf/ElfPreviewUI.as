package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import feathers.controls.List;
   import starling.display.DisplayObject;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.util.DisposeDisplay;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.common.util.xmlVOHandler.GetElfQuality;
   import feathers.data.ListCollection;
   import feathers.layout.VerticalLayout;
   
   public class ElfPreviewUI extends Sprite
   {
      
      private static var instance:com.mvc.views.uis.mainCity.myElf.ElfPreviewUI;
       
      private var swf:Swf;
      
      private var spr_breakPreview:SwfSprite;
      
      private var previewList:List;
      
      private var displayVec:Vector.<DisplayObject>;
      
      public function ElfPreviewUI()
      {
         displayVec = new Vector.<DisplayObject>([]);
         super();
         init();
         addList();
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.myElf.ElfPreviewUI
      {
         return instance || new com.mvc.views.uis.mainCity.myElf.ElfPreviewUI();
      }
      
      private function addList() : void
      {
         previewList = new List();
         previewList.width = 750;
         previewList.height = 485;
         previewList.x = 10;
         previewList.y = 83;
         previewList.isSelectable = false;
         previewList.itemRendererProperties.stateToSkinFunction = null;
         spr_breakPreview.addChild(previewList);
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         spr_breakPreview = swf.createSprite("spr_breakPreview");
         addChild(spr_breakPreview);
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         var _loc6_:* = null;
         var _loc5_:* = 0;
         var _loc3_:* = null;
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         if(param1.elfId > 10000 && param1.elfId < 20000)
         {
            _loc6_ = GetElfFactor.getElfVO(param1.elfId - 10000,false);
         }
         else
         {
            _loc6_ = param1;
         }
         var _loc7_:Array = GetElfQuality.allBreakData(_loc6_);
         var _loc2_:Array = [];
         _loc5_ = 0;
         while(_loc5_ < _loc7_.length)
         {
            _loc3_ = new BreakpreviewUnit();
            _loc3_.breakLv = _loc5_;
            _loc3_.breakVo = _loc7_[_loc5_];
            LogUtil("int(elfVo.brokenLv) == i  ",param1.brokenLv,_loc5_);
            if(param1.brokenLv == _loc5_)
            {
               _loc3_.nowPropmt.visible = true;
               _loc3_.elfLv.visible = false;
               _loc3_.addTick(true);
            }
            if(param1.brokenLv > _loc5_)
            {
               _loc3_.addTick(false);
            }
            _loc2_.push({
               "icon":_loc3_,
               "label":""
            });
            displayVec.push(_loc3_);
            _loc5_++;
         }
         var _loc4_:ListCollection = new ListCollection(_loc2_);
         previewList.dataProvider = _loc4_;
         if(!previewList.hasEventListener("creationComplete"))
         {
            previewList.addEventListener("creationComplete",creatComplete);
         }
      }
      
      private function creatComplete() : void
      {
         (previewList.layout as VerticalLayout).gap = -5;
      }
   }
}
