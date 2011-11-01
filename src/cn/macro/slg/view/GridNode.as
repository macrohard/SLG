package cn.macro.slg.view {
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.display.Sprite;

	/**
	 * @author yyi
	 */
	public class GridNode extends Sprite {

		public var xIndex : uint;
		public var yIndex : uint;

		// styled grid
		private var bgColor : uint = 0x00CCFF;
		private var bgAlpha : Number = 0.5;

		private var borderColor : uint = 0x666666;
		private var borderSize : uint = 1;

		private var borderColorOver : uint = 0xFFFFFF;
		private var borderSizeOver : uint = 3;

		private var size : uint = 20;
		private var cornerRadius : uint = 10;
		private var padding : uint = 4;
		private var selectedShape : Shape;
		private var overShape : Shape;

		private var tf : TextField = new TextField();

		public function GridNode(size : uint) {
			this.size = size;
			doDrawGrid();
			initChild();
			configListener();
			this.addEventListener(Event.REMOVED, destroyListener);
		}

		public function get selected() : Boolean {
			return contains(selectedShape);
		}

		public function set selected(value : Boolean) : void {
			if (value) {
				if (!contains(selectedShape))
					addChild(selectedShape);
			} else {
				if (contains(selectedShape))
					removeChild(selectedShape);
			}
		}

		public function get friction() : int {
			return int(tf.text);
		}
		
		public function set friction(value : int) : void {
			var color : uint;
			if (value < 20) {
				color = 0xbbffbb;
			}else if(value <30) {
				color = 0x88aaff;
			}else if (value < 50) {
				color = 0xdea00a;
			}else if (value < 90) {
				color = 0xff9090;
			}else{
				color = 0xff0000;
			}
			doDrawGrid(color, value.toString());
		}

		private function doDrawGrid(color : uint = 0xFFFFFF, str : String = "10") : void {
			graphics.clear();
			graphics.beginFill(color, 1);
			graphics.lineStyle(borderSize, borderColor);
			graphics.drawRect(0, 0, size, size);
			graphics.endFill();
			
			tf.text = str;
		}

		private function initChild() : void {
			var tempXY : Number;
			var tempSize : Number;
			
			tempSize = size - padding * 2 + 1;
			selectedShape = new Shape();
			selectedShape.graphics.beginFill(bgColor, bgAlpha);
			selectedShape.graphics.lineStyle(1, bgColor, bgAlpha);
			selectedShape.graphics.drawRoundRect(padding, padding, tempSize, tempSize, cornerRadius);
			selectedShape.graphics.endFill();
			
			tempXY = borderSizeOver / 2 + 1;
			tempSize = size - borderSizeOver - 1;
			overShape = new Shape();
			overShape.graphics.lineStyle(borderSizeOver, borderColorOver);
			overShape.graphics.drawRect(tempXY, tempXY, tempSize, tempSize);
			
			tf.selectable = false;
			tf.mouseEnabled = false;
			tf.width = 30;
			tf.height = 30;
			addChild(tf);
		}

		private function configListener() : void {
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function destroyListener(e : Event) : void {
			if (e.target != this) 
				return;
				
			this.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.removeEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(e : MouseEvent) : void {
			dispatchEvent(new CellEvent(CellEvent.CELL_CLICK, true));
		}

		private function onMouseOver(e : MouseEvent) : void {
			addChild(overShape);
		}

		private function onMouseOut(e : MouseEvent) : void {
			removeChild(overShape);
		}
	}
}
