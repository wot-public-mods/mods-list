package com.poliroid.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getQualifiedClassName;
	
	public class Utils
	{
		public static function recursiveFindDOC(parentDOC:DisplayObjectContainer, className:String) : DisplayObjectContainer 
		{
			var child:DisplayObject = null;
			var childDOC:DisplayObjectContainer = null;
			var i:int = 0;
			var result:DisplayObjectContainer = null;
			while (i < parentDOC.numChildren) 
			{
				child = parentDOC.getChildAt(i);
				if (child is DisplayObject && getQualifiedClassName(child) == className) 
					result = child as DisplayObjectContainer;
				if (result != null) 
					return result;
				childDOC = child as DisplayObjectContainer;
				if (childDOC && childDOC.numChildren > 0) 
					result = Utils.recursiveFindDOC(childDOC, className);
				i++;
			}
			return result;
		}
	}
}
