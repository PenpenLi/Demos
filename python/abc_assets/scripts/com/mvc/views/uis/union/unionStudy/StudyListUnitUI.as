package com.mvc.views.uis.union.unionStudy
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfImage;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.Label;
   import com.mvc.models.vos.union.MarkUpVO;
   import com.common.util.GetCommon;
   import com.common.events.EventCenter;
   import com.common.util.xmlVOHandler.GetUnionInfo;
   import flash.geom.Rectangle;
   import starling.events.Event;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class StudyListUnitUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_list:SwfSprite;
      
      private var iconBg:SwfImage;
      
      private var titleName:TextField;
      
      private var lv:TextField;
      
      private var expTxt:TextField;
      
      private var spr_exp:SwfSprite;
      
      private var btn_donate:SwfButton;
      
      private var nowLabel:Label;
      
      private var nextLabel:Label;
      
      private var _markUpVo:MarkUpVO;
      
      private var expWidth:Number;
      
      public function StudyListUnitUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("unionStudy");
         spr_list = swf.createSprite("spr_list");
         iconBg = spr_list.getImage("iconBg");
         titleName = spr_list.getTextField("titleName");
         lv = spr_list.getTextField("lv");
         expTxt = spr_list.getTextField("expTxt");
         spr_exp = spr_list.getSprite("spr_exp");
         expWidth = spr_exp.width;
         btn_donate = spr_list.getButton("btn_donate");
         addChild(spr_list);
         addLabel();
      }
      
      private function addLabel() : void
      {
         nowLabel = GetCommon.getLabel(this,17,160);
         nextLabel = GetCommon.getLabel(this,17,256);
      }
      
      public function set myMarkUpVo(param1:MarkUpVO) : void
      {
         _markUpVo = param1;
         var _loc2_:SwfImage = swf.createImage(param1.imgName);
         _loc2_.pivotX = _loc2_.width / 2;
         _loc2_.pivotY = _loc2_.height / 2;
         _loc2_.x = iconBg.x + iconBg.width / 2;
         _loc2_.y = iconBg.y + iconBg.height / 2;
         addChild(_loc2_);
         titleName.text = param1.title;
         writeLv(param1);
         writeExp(param1);
         btn_donate.addEventListener("triggered",onClick);
      }
      
      private function onClick() : void
      {
         EventCenter.addEventListener("UNION_DONATE_OK",donateOK);
         MarkUpUI.getInstance().myMarkUpVo = _markUpVo;
         MarkUpUI.getInstance().show();
      }
      
      private function writeLv(param1:MarkUpVO) : void
      {
         lv.text = "Lv." + param1.lv;
         var _loc3_:String = "";
         var _loc2_:String = "";
         if(param1.type == 20 || param1.type == 21)
         {
            _loc3_ = param1.lv * 5 + "%";
            _loc2_ = (param1.lv + 1) * 5 + "%";
         }
         else if(param1.type == 10)
         {
            _loc3_ = (param1.lv - 1) * 5 == 0?"1":(param1.lv - 1) * 5;
            _loc2_ = param1.lv * 5;
         }
         else if(param1.type == 30 || param1.type == 31)
         {
            _loc3_ = param1.lv + "%";
            _loc2_ = param1.lv + 1 + "%";
         }
         nowLabel.text = "<font size=\'20\'>" + param1.dec + " </font><font color=\'#33abfb\' size=\'20\'>" + _loc3_ + "</font>";
         nextLabel.text = "<font size=\'20\'>" + param1.dec + " </font><font color=\'#33abfb\' size=\'20\'>" + _loc2_ + "</font>";
      }
      
      private function writeExp(param1:MarkUpVO) : void
      {
         var _loc2_:int = GetUnionInfo.GetMarkUpExp(param1.lv - 1,param1.type);
         var _loc4_:int = param1.exp - _loc2_;
         var _loc3_:int = GetUnionInfo.GetMarkUpExp(param1.lv,param1.type) - _loc2_;
         expTxt.text = _loc4_ + "/" + _loc3_;
         spr_exp.clipRect = new Rectangle(0,0,expWidth * _loc4_ / _loc3_,spr_exp.height);
      }
      
      private function donateOK(param1:Event) : void
      {
         EventCenter.removeEventListener("UNION_DONATE_OK",donateOK);
         var _loc2_:MarkUpVO = param1.data.markVO;
         writeLv(_loc2_);
         writeExp(_loc2_);
      }
   }
}
