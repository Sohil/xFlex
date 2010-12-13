package com.xebia.components.xcombobox
{
	import mx.controls.List;

	public class DefaultValueList extends List
	{
		public function DefaultValueList()
		{
			super();
		}
		
		
		public override function itemToLabel(data:Object):String{
			
			if(labelFunction!=null && data is DefaultValueObject){
				return data[labelField];	
			}
			
			return super.itemToLabel(data);
		}
		
	}
}