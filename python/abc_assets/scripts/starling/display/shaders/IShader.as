package starling.display.shaders
{
   import flash.utils.ByteArray;
   import flash.display3D.Context3D;
   
   public interface IShader
   {
       
      function get opCode() : ByteArray;
      
      function setConstants(param1:Context3D, param2:int) : void;
   }
}
