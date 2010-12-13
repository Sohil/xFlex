package com.xebia.components.xcombobox
{
	import mx.collections.IList;
	import mx.controls.ComboBox;
	import mx.core.ClassFactory;
	import mx.core.IFactory;

	/**
	 *  A smarter ComboBox that uses some kind of programmer defined identity to match value with items in the ComboBox.
	 *  Objects used with this control should have a property name "id".
	 *  If no property named "id" is found, an equality comparison is done directly between the selected object
	 *  and items in the ComboBox.
	 *  It also supports a property "mandatory". If mandatory is set to false, an "empty" item is shown as the first item in
	 *  the ComboBox to support nullable values.
	 *  Initially based on http://www.forta.com/blog/index.cfm/2006/11/22/Flex-ComboBox-With-selectedValue-Support,
	 */
	/**
	 * 
	 * @author admin
	 */
	public class XComboBox extends ComboBox
	{

		private var dataProviderSet:Boolean = false;

		private var itemToSelect:Object = null;


		public function XComboBox()
		{
			super();
		}

		/**
		 * Override commit, this may be called repeatedly
		 */
		override protected function commitProperties():void
		{
			// invoke ComboBox version
			super.commitProperties();

			if (dataProviderSet)
			{
				if (dataProvider is DefaultValueListCollectionView)
				{
					var list:DefaultValueListCollectionView = dataProvider as DefaultValueListCollectionView;
					list.setDefaultValue(labelField, prompt);
				}

				if (itemToSelect == null)
				{
					// use current selected item to choose selectedItem in the new data provider
					itemToSelect = selectedItem;
				}
				setSelectedItemFromDataProvider(itemToSelect);
				itemToSelect = null;
			}
		}


		override public function set dataProvider(o:Object):void
		{
			if (o != null && o.length)
			{
				// we need to store this flag locally because Flex is doing something weird .. perhaps setting the _dataProvider internally
				// without going through the setter. Sometimes between dataProvider being null, and being set to the real
				// "data provider", it gets set to a an ArrayList with one element which is null
				dataProviderSet = true;
			}

			super.dataProvider = wrapOrUnwrapDataProviderIfNeeded(o);
			
		}

		private function setSelectedItemFromDataProvider(value:Object):void
		{
			super.selectedIndex = findValueIndexInDataProvider(value);
		}

		[Bindable("valueCommit")]
		[Bindable("collectionChange")]
		[Bindable("change")]
		public override function set selectedItem(value:Object):void
		{
			itemToSelect = value;
			invalidateProperties();
		}

		// whenever the selected Index is 0, reset it to -1
		override public function set selectedIndex(value:int):void
		{
			if (value == 0 && showChoose)
			{
				value = -1;
			}
			super.selectedIndex = value;
		}

		private var _showChoose:Boolean = true;

		public override function set prompt(value:String):void
		{
			super.prompt = value;
			invalidateProperties();
		}

		public function get showChoose():Boolean
		{
			return _showChoose;
		}

		public function set showChoose(value:Boolean):void
		{
			_showChoose = value;
			dataProvider = wrapOrUnwrapDataProviderIfNeeded(dataProvider);

			if (showChoose && prompt == null)
			{
				prompt = "-- Choose --";
			}

			invalidateProperties();
		}
		
		public override function itemToLabel(item:Object , ...rest):String{
			if(labelFunction != null && (item is DefaultValueObject)){
				return item[labelField];
			}	
			return super.itemToLabel(item , rest);
		}
		
		
		public override function set labelField(value:String):void
		{
			super.labelField = value;
			invalidateProperties();
		}

		private function wrapOrUnwrapDataProviderIfNeeded(dp:Object):Object
		{
			if (showChoose && dataProviderSet && !(dp is DefaultValueListCollectionView))
			{
				dp = new DefaultValueListCollectionView(dp as IList);
				(dp as DefaultValueListCollectionView).setDefaultValue(labelField, prompt);

			}
			else if (!showChoose && (dp is DefaultValueListCollectionView))
			{
				dp = (dp as DefaultValueListCollectionView).list;
			}

			return dp;
		}

		private function findValueIndexInDataProvider(value:Object):int
		{

			var index:int = -1;
			for (var i:int = 0; i < dataProvider.length; i++)
			{
				var item:Object = dataProvider[i];
				if (isEqual(item, value))
				{
					index = i;
					break;
				}
			}
			return index;
		}

		private function isEqual(item:Object, value:Object):Boolean
		{
			if (value != null && value.hasOwnProperty("id") && item.hasOwnProperty("id"))
			{
				return value.id == item.id;
			}
			return value == item;

		}
		
		
		private var _customDropdownFactory:ClassFactory = new ClassFactory(DefaultValueList);

		public override function get dropdownFactory():IFactory
		{
			return _customDropdownFactory;
		}



	}
}