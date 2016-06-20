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
   import lzm.starling.swf.display.SwfImage;
   
   public class MiningDefendRecordUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_fightRecord:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var list:List;
      
      public var listData:ListCollection;
      
      public function MiningDefendRecordUI()
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
         spr_fightRecord = swf.createSprite("spr_fightRecord");
         spr_fightRecord.x = 1136 - spr_fightRecord.width >> 1;
         spr_fightRecord.y = 640 - spr_fightRecord.height >> 1;
         addChild(spr_fightRecord);
         btn_close = spr_fightRecord.getButton("btn_close");
         creatreList();
      }
      
      private function creatreList() : void
      {
         listData = new ListCollection();
         list = new List();
         list.x = 25;
         list.y = 105;
         list.width = 700;
         list.height = 360;
         list.isSelectable = false;
         list.dataProvider = listData;
         list.scrollBarDisplayMode = "none";
      }
      
      public function getImg(param1:String) : SwfImage
      {
         return swf.createImage(param1);
      }
      
      public function getBtn(param1:String) : SwfButton
      {
         return swf.createButton(param1);
      }
   }
}
