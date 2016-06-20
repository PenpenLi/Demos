package org.puremvc.as3.core
{
   import org.puremvc.as3.interfaces.IView;
   import org.puremvc.as3.interfaces.IObserver;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.observer.Observer;
   import org.puremvc.as3.interfaces.IMediator;
   
   public class View implements IView
   {
      
      protected static var instance:IView;
       
      protected var mediatorMap:Array;
      
      protected var observerMap:Array;
      
      protected const SINGLETON_MSG:String = "View Singleton already constructed!";
      
      public function View()
      {
         super();
         if(instance != null)
         {
            throw Error("View Singleton already constructed!");
         }
         instance = this;
         mediatorMap = [];
         observerMap = [];
         initializeView();
      }
      
      public static function getInstance() : IView
      {
         if(instance == null)
         {
            instance = new View();
         }
         return instance;
      }
      
      protected function initializeView() : void
      {
      }
      
      public function registerObserver(param1:String, param2:IObserver) : void
      {
         var _loc3_:Array = observerMap[param1];
         if(_loc3_)
         {
            _loc3_.push(param2);
         }
         else
         {
            observerMap[param1] = [param2];
         }
      }
      
      public function notifyObservers(param1:INotification) : void
      {
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = NaN;
         if(observerMap[param1.getName()] != null)
         {
            _loc4_ = observerMap[param1.getName()] as Array;
            _loc5_ = [];
            _loc3_ = 0.0;
            while(_loc3_ < _loc4_.length)
            {
               _loc2_ = _loc4_[_loc3_] as IObserver;
               _loc5_.push(_loc2_);
               _loc3_++;
            }
            _loc3_ = 0.0;
            while(_loc3_ < _loc5_.length)
            {
               _loc2_ = _loc5_[_loc3_] as IObserver;
               _loc2_.notifyObserver(param1);
               _loc3_++;
            }
         }
      }
      
      public function removeObserver(param1:String, param2:Object) : void
      {
         var _loc3_:* = 0;
         var _loc4_:Array = observerMap[param1] as Array;
         _loc3_ = 0;
         while(_loc3_ < _loc4_.length)
         {
            if(Observer(_loc4_[_loc3_]).compareNotifyContext(param2) == true)
            {
               _loc4_.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
         if(_loc4_.length == 0)
         {
            delete observerMap[param1];
         }
      }
      
      public function registerMediator(param1:IMediator) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = NaN;
         if(mediatorMap[param1.getMediatorName()] != null)
         {
            return;
         }
         mediatorMap[param1.getMediatorName()] = param1;
         var _loc4_:Array = param1.listNotificationInterests();
         if(_loc4_.length > 0)
         {
            _loc2_ = new Observer(param1.handleNotification,param1);
            _loc3_ = 0.0;
            while(_loc3_ < _loc4_.length)
            {
               registerObserver(_loc4_[_loc3_],_loc2_);
               _loc3_++;
            }
         }
         param1.onRegister();
      }
      
      public function retrieveMediator(param1:String) : IMediator
      {
         return mediatorMap[param1];
      }
      
      public function removeMediator(param1:String) : IMediator
      {
         var _loc4_:* = null;
         var _loc2_:* = NaN;
         var _loc3_:IMediator = mediatorMap[param1] as IMediator;
         if(_loc3_)
         {
            _loc4_ = _loc3_.listNotificationInterests();
            _loc2_ = 0.0;
            while(_loc2_ < _loc4_.length)
            {
               removeObserver(_loc4_[_loc2_],_loc3_);
               _loc2_++;
            }
            delete mediatorMap[param1];
            _loc3_.onRemove();
         }
         return _loc3_;
      }
      
      public function hasMediator(param1:String) : Boolean
      {
         return mediatorMap[param1] != null;
      }
   }
}
