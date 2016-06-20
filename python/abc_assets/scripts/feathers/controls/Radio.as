package feathers.controls
{
   import feathers.core.IGroupedToggle;
   import feathers.core.ToggleGroup;
   import flash.errors.IllegalOperationError;
   import starling.events.Event;
   
   public class Radio extends Button implements IGroupedToggle
   {
      
      public static const defaultRadioGroup:ToggleGroup = new ToggleGroup();
       
      protected var _toggleGroup:ToggleGroup;
      
      public function Radio()
      {
         super();
         .super.isToggle = true;
         this.addEventListener("addedToStage",radio_addedToStageHandler);
         this.addEventListener("removedFromStage",radio_removedFromStageHandler);
      }
      
      override public function set isToggle(param1:Boolean) : void
      {
         throw IllegalOperationError("Radio isToggle must always be true.");
      }
      
      public function get toggleGroup() : ToggleGroup
      {
         return this._toggleGroup;
      }
      
      public function set toggleGroup(param1:ToggleGroup) : void
      {
         if(this._toggleGroup == param1)
         {
            return;
         }
         if(!param1 && this._toggleGroup != defaultRadioGroup && this.stage)
         {
            var param1:ToggleGroup = defaultRadioGroup;
         }
         if(this._toggleGroup && this._toggleGroup.hasItem(this))
         {
            this._toggleGroup.removeItem(this);
         }
         this._toggleGroup = param1;
         if(this._toggleGroup && !this._toggleGroup.hasItem(this))
         {
            this._toggleGroup.addItem(this);
         }
      }
      
      protected function radio_addedToStageHandler(param1:Event) : void
      {
         if(!this._toggleGroup)
         {
            this.toggleGroup = defaultRadioGroup;
         }
      }
      
      protected function radio_removedFromStageHandler(param1:Event) : void
      {
         if(this._toggleGroup == defaultRadioGroup)
         {
            this._toggleGroup.removeItem(this);
         }
      }
   }
}
