package cn.macro.slg.view {

	/**
	 * @author yyi
	 */
	public class MArrayUtil {
		public static function createMArray(... args : Array) : Array {
			if (args.length == 0)
				return null;

			var arr : Array = new Array(args.shift());
			fillArray(arr, args);
			return arr;
		}

		private static function fillArray(arr : Array, args : Array) : void {
			if (args.length == 0)
				return;
			
			var len : uint = args.shift();			
			for (var i : uint = 0;i < arr.length; i++)
			{
				var t : Array = new Array(len);
				if (args.length > 0)
					fillArray(t, args.concat());
				arr[i] = t;
			}
		}
	}
}
