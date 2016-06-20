package feathers.controls.renderers
{
   import feathers.core.IToggle;
   import feathers.controls.List;
   
   public interface IListItemRenderer extends IToggle
   {
       
      function get data() : Object;
      
      function set data(param1:Object) : void;
      
      function get index() : int;
      
      function set index(param1:int) : void;
      
      function get owner() : List;
      
      function set owner(param1:List) : void;
   }
}
