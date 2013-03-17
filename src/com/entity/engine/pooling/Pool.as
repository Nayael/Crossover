package com.entity.engine.pooling
{
	import flash.utils.Dictionary;
	
	public class Pool
	{
		private static var _instance:Pool;
		private var _pool:Dictionary = new Dictionary;
		
		public function Pool( lock:SingletonLock ) { }
		
        public static function get instance():Pool {
            if (_instance == null){
                _instance = new Pool( new SingletonLock() );
            };
			
            return (_instance);
        }
		
		// cree une nouvelle pool
		public function pool( poolName:String ):Array 
		{
			if (_pool[poolName] == null) {
				_pool[poolName] = [];
			}
			return _pool[poolName];
		}		
		
		// efface la reference vers la pool
		public function del( poolName:String ):void
		{
			delete _pool[poolName];
		}	
		
	}
}

internal class SingletonLock { }