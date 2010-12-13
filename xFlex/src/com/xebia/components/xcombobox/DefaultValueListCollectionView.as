package com.xebia.components.xcombobox
{
    import com.xebia.components.xcombobox.DefaultValueObject;
    
    import mx.collections.IList;
    import mx.collections.ListCollectionView;

    /**
     *  A ListCollectionView subclass that acts as a wrapper around another collection,
     * and provides an empty "default" value at index 0
     */
    public class DefaultValueListCollectionView extends ListCollectionView
    {

        private var defaultValue:DefaultValueObject = null;

        /**
         * @param target the collection to wrap
         */
        public function DefaultValueListCollectionView(target:IList)
        {
			        	
            super(target);
        }

		public function setDefaultValue(labelField:String , prompt:String):void{
			defaultValue = new DefaultValueObject();
			defaultValue[labelField] = prompt;
		}
		
        [Bindable("collectionChange")]
        override public function getItemAt(index:int, prefetch:int = 0):Object
        {
            if(index == 0)
            {
                return defaultValue;
            }
            return super.getItemAt(index - 1, prefetch);
        }

        override public function getItemIndex(item:Object):int
        {
            if(item == defaultValue)
            {
                return 0;
            }
            return super.getItemIndex(item) + 1;
        }

        override public function addItemAt(item:Object, index:int):void 
        {
            if(index == 0)
            {
                throw new ArgumentError('The default item at index 0 cannot be changed')
            }
            super.addItemAt(item, index - 1);
        }

        override public function setItemAt(item:Object, index:int):Object
        {
            if(index == 0)
            {
                throw new ArgumentError('The default item at index 0 cannot be changed')
            }
            return super.setItemAt(item, index - 1);
        }


        override public function removeItemAt(index:int):Object
        {
            if(index == 0)
            {
                throw new ArgumentError('The default item at index 0 cannot be changed')
            }
            return super.removeItemAt(index - 1);
        }

        [Bindable("collectionChange")]
        override public function get length():int
        {
            return super.length + 1;
        }

    }
}