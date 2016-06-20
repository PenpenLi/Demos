package com.common.themes
{
   import feathers.core.DisplayListWatcher;
   import starling.utils.AssetManager;
   import flash.geom.Rectangle;
   import starling.display.DisplayObject;
   import starling.display.Quad;
   import feathers.textures.Scale9Textures;
   import starling.textures.Texture;
   import flash.text.TextFormat;
   import starling.display.Sprite;
   import feathers.core.PopUpManager;
   import feathers.controls.Button;
   import feathers.controls.Alert;
   import feathers.controls.ButtonGroup;
   import feathers.controls.text.TextFieldTextRenderer;
   import feathers.controls.TabBar;
   import feathers.controls.List;
   import feathers.controls.renderers.DefaultListItemRenderer;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ToggleSwitch;
   import feathers.display.Scale9Image;
   import feathers.controls.Radio;
   import feathers.skins.SmartDisplayObjectStateValueSelector;
   import feathers.controls.Check;
   import feathers.controls.Callout;
   import feathers.controls.ProgressBar;
   import feathers.layout.VerticalLayout;
   import starling.display.DisplayObjectContainer;
   import starling.animation.Tween;
   import starling.core.Starling;
   import feathers.controls.Header;
   import feathers.core.FeathersControl;
   import feathers.core.ITextRenderer;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class MyFeathersTheme extends DisplayListWatcher
   {
      
      public static var assets:AssetManager;
      
      public static const DEFAULT_SCALE9_GRID:Rectangle = new Rectangle(8,8,8,8);
      
      protected static const BUTTON_SCALE9_GRID:Rectangle = new Rectangle(20,20,20,20);
      
      protected static const TAB_BUTTON_SCALE9_GRID:Rectangle = new Rectangle(25,25,25,25);
      
      protected static const MODAL_OVERLAY_COLOR:uint = 0;
      
      protected static const MODAL_OVERLAY_ALPHA:Number = 0.5;
      
      public static const MESSAGE_COLOR:Number = 9713664;
      
      protected static const TITLE_COLOR:Number = 9713664;
      
      protected static const BTN_LABEL_COLOR:Number = 16777215;
       
      private var buttonUpSkinTextures:Scale9Textures;
      
      private var buttonDownSkinTextures:Scale9Textures;
      
      private var buttonDisableSkinTextures:Scale9Textures;
      
      private var alertBgSkinTextures:Scale9Textures;
      
      private var listBgSkinTextures:Scale9Textures;
      
      private var tabBtnUpSkinTextures:Scale9Textures;
      
      private var tabBtnDownSkinTextures:Scale9Textures;
      
      protected var assetsTexture:Texture;
      
      protected var defaultTextFormat:TextFormat;
      
      protected var alertHeadSkin:Sprite;
      
      protected var ts_thumbTextures:Scale9Textures;
      
      protected var ts_onTrackTextures:Scale9Textures;
      
      protected var ts_offTrackTextures:Scale9Textures;
      
      private var checkUpSkinTextures:Scale9Textures;
      
      private var checkDownSkinTextures:Scale9Textures;
      
      public function MyFeathersTheme(param1:DisplayObjectContainer = null)
      {
         topLevelContainer = param1;
         super(topLevelContainer);
         FeathersControl.defaultTextRendererFactory = function():ITextRenderer
         {
            var _loc1_:TextFieldTextRenderer = new TextFieldTextRenderer();
            _loc1_.embedFonts = true;
            return _loc1_;
         };
         defaultTextFormat = new TextFormat("FZCuYuan-M03S",24,9713664,true,false,false,null,null,"left",0,0,0,0);
         assets = LoadOtherAssetsManager.getInstance().assets;
         initScale9Textures();
         initializeBgColor();
         setInitializer();
      }
      
      protected static function popUpOverlayFactory() : DisplayObject
      {
         var _loc1_:Quad = new Quad(100,100,0);
         _loc1_.alpha = 0.5;
         return _loc1_;
      }
      
      protected function initializeBgColor() : void
      {
         PopUpManager.overlayFactory = popUpOverlayFactory;
      }
      
      private function initScale9Textures() : void
      {
         buttonUpSkinTextures = new Scale9Textures(assets.getTexture("button_up"),BUTTON_SCALE9_GRID);
         buttonDownSkinTextures = new Scale9Textures(assets.getTexture("button_down"),BUTTON_SCALE9_GRID);
         buttonDisableSkinTextures = new Scale9Textures(assets.getTexture("button_disable"),BUTTON_SCALE9_GRID);
         alertBgSkinTextures = new Scale9Textures(assets.getTexture("alertBg"),DEFAULT_SCALE9_GRID);
         listBgSkinTextures = new Scale9Textures(assets.getTexture("listBg"),new Rectangle(15,15,15,15));
         tabBtnUpSkinTextures = new Scale9Textures(assets.getTexture("tab_btn_up"),TAB_BUTTON_SCALE9_GRID);
         tabBtnDownSkinTextures = new Scale9Textures(assets.getTexture("tab_btn_down"),TAB_BUTTON_SCALE9_GRID);
         ts_thumbTextures = new Scale9Textures(assets.getTexture("toggle_thumb"),new Rectangle(1,1,1,1));
         ts_onTrackTextures = new Scale9Textures(assets.getTexture("toggle_track"),new Rectangle(20,20,20,20));
         checkUpSkinTextures = new Scale9Textures(assets.getTexture("checkSelect"),new Rectangle(1,1,1,1));
         checkDownSkinTextures = new Scale9Textures(assets.getTexture("checkDefaut"),new Rectangle(1,1,1,1));
      }
      
      private function setInitializer() : void
      {
         this.setInitializerForClass(Button,initButton);
         this.setInitializerForClass(Alert,alertInitializer);
         this.setInitializerForClass(ButtonGroup,alertButtonGroupInitializer,"feathers-alert-button-group");
         this.setInitializerForClass(TextFieldTextRenderer,alertMessageInitializer,"feathers-alert-message");
         this.setInitializerForClass(TabBar,tabBarInitializer);
         this.setInitializerForClass(Button,tabInitializer,"feathers-tab-bar-tab");
         this.setInitializerForClass(List,listInitializer);
         this.setInitializerForClass(DefaultListItemRenderer,itemRendererInitializer);
         this.setInitializerForClass(ScrollContainer,scrollInitializer);
         this.setInitializerForClass(ToggleSwitch,toggleSwitchInitializer);
         this.setInitializerForClass(Button,toggleSwitchThumbInitializer,"feathers-toggle-switch-thumb");
         this.setInitializerForClass(Button,toggleSwitchOnTrackInitializer,"feathers-toggle-switch-on-track");
      }
      
      private function toggleSwitchOnTrackInitializer(param1:Button) : void
      {
         param1.defaultSkin = new Scale9Image(ts_onTrackTextures);
         param1.downSkin = new Scale9Image(ts_onTrackTextures);
         param1.disabledSkin = new Scale9Image(ts_onTrackTextures);
         param1.minHeight = 44;
         param1.minWidth = 87;
         param1.minTouchWidth = 87;
         param1.minTouchHeight = 44;
      }
      
      private function toggleSwitchThumbInitializer(param1:Button) : void
      {
         param1.defaultSkin = new Scale9Image(ts_thumbTextures);
         param1.downSkin = new Scale9Image(ts_thumbTextures);
         param1.disabledSkin = new Scale9Image(ts_thumbTextures);
         param1.minHeight = 36;
         param1.minWidth = 36;
         param1.minTouchWidth = 36;
         param1.minTouchHeight = 36;
      }
      
      private function toggleSwitchInitializer(param1:ToggleSwitch) : void
      {
         param1.trackLayoutMode = "single";
         param1.paddingLeft = 5;
         param1.paddingRight = 4;
      }
      
      protected function radioInitializer(param1:Radio) : void
      {
         var _loc2_:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
         param1.defaultLabelProperties.textFormat = this.defaultTextFormat;
      }
      
      private function checkInitializer(param1:Check) : void
      {
         var _loc2_:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
         _loc2_.defaultValue = this.checkDownSkinTextures;
         _loc2_.defaultSelectedValue = this.checkUpSkinTextures;
         param1.stateToSkinFunction = _loc2_.updateValue;
      }
      
      private function scrollInitializer(param1:ScrollContainer) : void
      {
         param1.scrollBarDisplayMode = "none";
      }
      
      private function calloutInitializer(param1:Callout) : void
      {
         param1.backgroundSkin = new Quad(10,20,3750478);
         param1.topArrowSkin = new Quad(10,15,3750478);
         param1.rightArrowSkin = new Quad(10,15,3750478);
         param1.leftArrowSkin = new Quad(10,15,3750478);
         param1.bottomArrowSkin = new Quad(10,15,3750478);
         var _loc2_:* = 12;
         param1.paddingBottom = _loc2_;
         param1.paddingTop = _loc2_;
         _loc2_ = 14;
         param1.paddingRight = _loc2_;
         param1.paddingLeft = _loc2_;
      }
      
      private function progressBarInitializer(param1:ProgressBar) : void
      {
         var _loc2_:Scale9Textures = new Scale9Textures(assets.getTexture("progressBg"),new Rectangle(20,20,20,20));
         param1.backgroundSkin = new Scale9Image(_loc2_);
         param1.backgroundSkin.width = 430;
         var _loc3_:Scale9Textures = new Scale9Textures(assets.getTexture("progressFillskin"),new Rectangle(40,40,20,40));
         param1.fillSkin = new Scale9Image(_loc3_);
         param1.fillSkin.width = 80;
         param1.paddingTop = -8;
         param1.paddingRight = 0;
         param1.paddingBottom = 0;
         param1.paddingLeft = 0;
      }
      
      private function listInitializer(param1:List) : void
      {
         var _loc2_:VerticalLayout = new VerticalLayout();
         _loc2_.horizontalAlign = "justify";
         _loc2_.gap = 5;
         var _loc3_:* = 0;
         _loc2_.paddingLeft = _loc3_;
         _loc3_ = _loc3_;
         _loc2_.paddingBottom = _loc3_;
         _loc3_ = _loc3_;
         _loc2_.paddingRight = _loc3_;
         _loc2_.paddingTop = _loc3_;
         param1.layout = _loc2_;
         param1.scrollBarDisplayMode = "none";
      }
      
      protected function itemRendererInitializer(param1:DefaultListItemRenderer) : void
      {
         var _loc2_:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
         _loc2_.defaultValue = listBgSkinTextures;
         _loc2_.defaultSelectedValue = tabBtnUpSkinTextures;
         param1.stateToSkinFunction = _loc2_.updateValue;
         param1.defaultLabelProperties.textFormat = defaultTextFormat;
         param1.horizontalAlign = "left";
         var _loc3_:* = 8;
         param1.paddingBottom = _loc3_;
         param1.paddingTop = _loc3_;
         param1.paddingLeft = 12;
         param1.paddingRight = 10;
         param1.gap = 20;
         param1.iconPosition = "left";
         param1.accessoryGap = Infinity;
         param1.accessoryPosition = "right";
         _loc3_ = 88;
         param1.minHeight = _loc3_;
         param1.minWidth = _loc3_;
         _loc3_ = 88;
         param1.minTouchHeight = _loc3_;
         param1.minTouchWidth = _loc3_;
         param1.defaultLabelProperties.isHTML = true;
      }
      
      private function tabBarInitializer(param1:TabBar) : void
      {
         param1.gap = 8;
      }
      
      private function tabInitializer(param1:Button) : void
      {
         param1.defaultSkin = new Scale9Image(tabBtnUpSkinTextures);
         param1.downSkin = new Scale9Image(tabBtnDownSkinTextures);
         param1.defaultSelectedSkin = new Scale9Image(tabBtnDownSkinTextures);
         param1.defaultLabelProperties.textFormat = new TextFormat("FZCuYuan-M03S",26,16777215,true);
         param1.defaultSelectedLabelProperties.textFormat = new TextFormat("FZCuYuan-M03S",26,11617792,true);
         param1.downLabelProperties.textFormat = new TextFormat("FZCuYuan-M03S",26,11617792,true);
         param1.defaultLabelProperties.isHTML = true;
         param1.defaultSelectedLabelProperties.isHTML = true;
         param1.downLabelProperties.isHTML = true;
         param1.paddingTop = 2;
         param1.paddingBottom = 8;
         var _loc2_:* = 16;
         param1.paddingRight = _loc2_;
         param1.paddingLeft = _loc2_;
         param1.gap = 12;
         _loc2_ = 67;
         param1.maxHeight = _loc2_;
         param1.minHeight = _loc2_;
         param1.minWidth = 144;
         param1.minTouchWidth = 142;
         param1.minTouchHeight = 65;
      }
      
      protected function alertInitializer(param1:Alert) : void
      {
         var _loc2_:* = null;
         param1.backgroundSkin = new Scale9Image(alertBgSkinTextures);
         param1.paddingTop = 40;
         param1.paddingRight = 30;
         param1.paddingBottom = 16;
         param1.paddingLeft = 30;
         param1.gap = 16;
         param1.maxWidth = 561;
         param1.maxHeight = 450;
         param1.minWidth = 541;
         param1.minHeight = 210;
         param1.scrollBarDisplayMode = "none";
         if(Config.isOpenAni && (Config.starling.root as DisplayObjectContainer).numChildren <= 2)
         {
            _loc2_ = new Tween(param1,0.2,"easeOutBack");
            Starling.juggler.add(_loc2_);
            _loc2_.animate("scaleX",Config.scaleX,0);
            _loc2_.animate("scaleY",Config.scaleY,0);
         }
         else
         {
            param1.scaleX = Config.scaleX;
            param1.scaleY = Config.scaleY;
         }
         param1.name = "alert";
      }
      
      protected function alertButtonGroupInitializer(param1:ButtonGroup) : void
      {
         group = param1;
         group.direction = "horizontal";
         group.horizontalAlign = "center";
         group.verticalAlign = "justify";
         group.distributeButtonSizes = false;
         group.gap = 60;
         group.paddingTop = 25;
         group.paddingRight = 20;
         group.paddingBottom = 30;
         group.paddingLeft = 20;
         group.buttonFactory = function():Button
         {
            var _loc1_:Button = new Button();
            return initButton(_loc1_);
         };
      }
      
      private function initButton(param1:Button) : Button
      {
         param1.defaultSkin = new Scale9Image(buttonUpSkinTextures);
         param1.downSkin = new Scale9Image(buttonDownSkinTextures);
         param1.disabledSkin = new Scale9Image(buttonDisableSkinTextures);
         param1.defaultLabelProperties.textFormat = new TextFormat("FZCuYuan-M03S",30,16777215,true);
         param1.paddingTop = 0;
         param1.paddingBottom = 15;
         var _loc2_:* = 16;
         param1.paddingRight = _loc2_;
         param1.paddingLeft = _loc2_;
         param1.gap = 20;
         param1.minHeight = 75;
         param1.minWidth = 110;
         param1.minTouchWidth = 110;
         param1.minTouchHeight = 75;
         return param1;
      }
      
      protected function panelHeaderInitializer(param1:Header) : void
      {
         alertHeadSkin.y = 4;
         alertHeadSkin.x = 7;
         param1.addChild(alertHeadSkin);
         param1.maxWidth = 527;
         param1.maxHeight = 96;
      }
      
      protected function alertMessageInitializer(param1:TextFieldTextRenderer) : void
      {
         param1.textFormat = new TextFormat("FZCuYuan-M03S",32,9713664,true,false,false,null,null,"center",0,0,0,0);
         param1.wordWrap = true;
         param1.isHTML = true;
      }
   }
}
