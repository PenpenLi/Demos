package com.mvc.views.uis.mainCity.active
{
   import starling.display.Sprite;
   import starling.text.TextField;
   import com.mvc.models.vos.mainCity.active.ActiveVO;
   
   public class TypeOneUI extends Sprite
   {
       
      private var textDec:TextField;
      
      public function TypeOneUI()
      {
         super();
         addText();
      }
      
      private function addText() : void
      {
         textDec = new TextField(730,100,"","FZCuYuan-M03S",20,5715237);
         textDec.autoSize = "vertical";
         textDec.hAlign = "left";
         textDec.x = 5;
         addChild(textDec);
      }
      
      public function set myActive(param1:ActiveVO) : void
      {
         textDec.text = param1.atvDescs;
      }
   }
}
