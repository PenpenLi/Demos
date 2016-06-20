package feathers.controls
{
   import flash.errors.IllegalOperationError;
   
   public class Check extends Button
   {
       
      public function Check()
      {
         super();
         .super.isToggle = true;
      }
      
      override public function set isToggle(param1:Boolean) : void
      {
         throw IllegalOperationError("CheckBox isToggle must always be true.");
      }
   }
}
