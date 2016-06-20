package com.mvc.views.uis.mainCity.mining
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class MiningSelectMemberUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_selectMember:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var btn_selectAll:SwfButton;
      
      public var btn_clearAll:SwfButton;
      
      public var btn_sure:SwfButton;
      
      public var list:List;
      
      public var listData:ListCollection;
      
      public function MiningSelectMemberUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.5;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("mining");
         spr_selectMember = swf.createSprite("spr_selectMember");
         spr_selectMember.x = 1136 - spr_selectMember.width >> 1;
         spr_selectMember.y = 640 - spr_selectMember.height >> 1;
         addChild(spr_selectMember);
         btn_close = spr_selectMember.getButton("btn_close");
         btn_selectAll = spr_selectMember.getButton("btn_selectAll");
         btn_clearAll = spr_selectMember.getButton("btn_clearAll");
         btn_sure = spr_selectMember.getButton("btn_sure");
         creatreList();
      }
      
      private function creatreList() : void
      {
         listData = new ListCollection();
         list = new List();
         list.x = 40;
         list.y = 130;
         list.width = 670;
         list.height = 310;
         list.isSelectable = false;
         list.dataProvider = listData;
         list.scrollBarDisplayMode = "none";
      }
      
      public function getSpr(param1:String) : SwfSprite
      {
         return swf.createSprite(param1);
      }
   }
}
