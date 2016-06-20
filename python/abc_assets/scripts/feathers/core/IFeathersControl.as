package feathers.core
{
   import flash.geom.Rectangle;
   
   public interface IFeathersControl extends IValidating
   {
       
      function get minWidth() : Number;
      
      function set minWidth(param1:Number) : void;
      
      function get minHeight() : Number;
      
      function set minHeight(param1:Number) : void;
      
      function get maxWidth() : Number;
      
      function set maxWidth(param1:Number) : void;
      
      function get maxHeight() : Number;
      
      function set maxHeight(param1:Number) : void;
      
      function get clipRect() : Rectangle;
      
      function set clipRect(param1:Rectangle) : void;
      
      function get isEnabled() : Boolean;
      
      function set isEnabled(param1:Boolean) : void;
      
      function get isInitialized() : Boolean;
      
      function get isCreated() : Boolean;
      
      function get nameList() : TokenList;
      
      function setSize(param1:Number, param2:Number) : void;
   }
}
