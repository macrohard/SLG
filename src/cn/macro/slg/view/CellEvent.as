package cn.macro.slg.view {
	import flash.events.Event;

	/**
	 * @author yyi
	 */
	public class CellEvent extends Event {

		public static const CELL_CLICK : String = "CellClick";

		public function CellEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
