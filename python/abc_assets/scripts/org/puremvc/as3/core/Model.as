package org.puremvc.as3.core
{
   import org.puremvc.as3.interfaces.IModel;
   import org.puremvc.as3.interfaces.IProxy;
   
   public class Model implements IModel
   {
      
      protected static var instance:IModel;
       
      protected var proxyMap:Array;
      
      protected const SINGLETON_MSG:String = "Model Singleton already constructed!";
      
      public function Model()
      {
         super();
         if(instance != null)
         {
            throw Error("Model Singleton already constructed!");
         }
         instance = this;
         proxyMap = [];
         initializeModel();
      }
      
      public static function getInstance() : IModel
      {
         if(instance == null)
         {
            instance = new Model();
         }
         return instance;
      }
      
      protected function initializeModel() : void
      {
      }
      
      public function registerProxy(param1:IProxy) : void
      {
         proxyMap[param1.getProxyName()] = param1;
         param1.onRegister();
      }
      
      public function retrieveProxy(param1:String) : IProxy
      {
         return proxyMap[param1];
      }
      
      public function hasProxy(param1:String) : Boolean
      {
         return proxyMap[param1] != null;
      }
      
      public function removeProxy(param1:String) : IProxy
      {
         var _loc2_:IProxy = proxyMap[param1] as IProxy;
         if(_loc2_)
         {
            proxyMap[param1] = null;
            _loc2_.onRemove();
         }
         return _loc2_;
      }
   }
}
