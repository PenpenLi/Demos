package lzm.starling.swf.components.feathers
{
   import feathers.controls.Button;
   import lzm.starling.swf.components.ISwfComponent;
   import lzm.starling.swf.display.SwfSprite;
   import starling.display.DisplayObject;
   import starling.text.TextField;
   import flash.text.TextFormat;
   
   public class FeathersButton extends Button implements ISwfComponent
   {
       
      public function FeathersButton()
      {
         super();
      }
      
      public function initialization(param1:SwfSprite) : void
      {
         var _loc2_:* = null;
         var _loc7_:DisplayObject = param1.getChildByName("_upSkin");
         var _loc6_:DisplayObject = param1.getChildByName("_selectUpSkin");
         var _loc8_:DisplayObject = param1.getChildByName("_downSkin");
         var _loc5_:DisplayObject = param1.getChildByName("_disabledSkin");
         var _loc4_:DisplayObject = param1.getChildByName("_selectDisabledSkin");
         var _loc3_:TextField = param1.getTextField("_labelTextField");
         if(_loc7_)
         {
            this.defaultSkin = _loc7_;
            _loc7_.removeFromParent();
         }
         if(_loc6_)
         {
            this.defaultSelectedSkin = _loc6_;
            _loc6_.removeFromParent();
         }
         if(_loc8_)
         {
            this.downSkin = _loc8_;
            _loc8_.removeFromParent();
         }
         if(_loc5_)
         {
            this.disabledSkin = _loc5_;
            _loc5_.removeFromParent();
         }
         if(_loc4_)
         {
            this.selectedDisabledSkin = _loc4_;
            _loc5_.removeFromParent();
         }
         if(_loc3_)
         {
            _loc2_ = new TextFormat();
            _loc2_.font = _loc3_.fontName;
            _loc2_.size = _loc3_.fontSize;
            _loc2_.color = _loc3_.color;
            _loc2_.bold = _loc3_.bold;
            _loc2_.italic = _loc3_.italic;
            this.defaultLabelProperties.textFormat = _loc2_;
            this.label = _loc3_.text;
         }
         param1.removeFromParent(true);
      }
      
      public function get editableProperties() : Object
      {
         return {
            "label":label,
            "isEnabled":isEnabled
         };
      }
      
      public function set editableProperties(param1:Object) : void
      {
         var _loc4_:* = 0;
         var _loc3_:* = param1;
         for(var _loc2_ in param1)
         {
            this[_loc2_] = param1[_loc2_];
         }
      }
   }
}
