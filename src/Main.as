package {
	import cn.macro.slg.view.MapView;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author yyi
	 */
	public class Main extends Sprite {

		public static const stageWidth : uint = 900;
		public static const stageHeight : uint = 600;

		private var sensor : uint = 80;
		private var mapView : MapView;

		private var moveX : uint = 0;
		private var moveY : uint = 0;
		private var scrollSpeed : uint = 8;		
		private var scrollW : Number;
		private var scrollH : Number;
		
		private var mapData : Array = [
		[10,10,10,10,10,10,10,10,10,50,50,50,90,90,90,90,50,10,10,10,10,10,10,10,10],
		[10,10,10,10,10,10,10,10,10,10,50,50,50,50,50,50,10,10,10,10,10,10,10,10,10],
		[10,10,10,10,10,10,10,10,10,10,10,50,50,50,50,50,10,10,10,10,10,10,10,10,10],
		[10,10,10,10,10,10,10,10,10,10,10,10,10,50,50,10,10,10,10,10,10,10,10,10,10],
		[10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10],
		[10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10],
		[10,10,10,50,50,50,10,20,20,20,20,10,10,10,10,10,10,10,10,10,10,10,10,10,10],
		[10,10,10,50,90,50,10,10,10,10,20,10,10,10,10,10,10,10,10,10,10,10,10,10,10],
		[10,10,10,50,50,50,10,10,10,10,20,20,20,20,20,20,10,10,10,10,10,10,10,10,10],
		[10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,20,10,10,10,10,10,10,10,10,10],
		[10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10],
		[10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10],
		[10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10],
		[10,10,10,10,10,10,10,20,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10],
		[10,10,10,10,10,10,10,20,10,10,10,10,30,30,10,10,10,10,10,10,10,10,10,10,10],
		[10,10,10,10,10,10,10,20,10,10,10,10,30,30,10,10,10,10,10,10,10,10,10,10,10],
		[10,10,10,10,10,10,10,20,20,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10],
		[10,10,10,10,10,10,10,20,20,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10],
		[10,10,10,10,10,10,10,10,20,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10],
		[10,10,10,10,10,10,10,10,20,20,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10],
		[10,10,10,10,10,10,10,10,10,20,20,10,10,10,10,10,10,10,10,10,10,10,10,10,10],
		[10,10,10,10,10,10,10,10,10,10,20,10,10,10,10,10,10,10,10,10,10,10,10,10,10],
		[10,10,10,10,10,10,10,10,10,10,20,10,10,10,10,10,10,10,10,10,10,10,10,10,10],
		[10,10,10,10,10,10,10,10,10,10,20,10,10,10,10,10,10,10,10,10,10,10,10,10,10],
		[10,10,10,10,10,10,10,10,10,10,20,10,10,10,10,10,10,10,10,10,10,10,10,10,10]];

		public function Main() {
			mapView = new MapView(mapData);
			addChild(mapView);
			configListener();
			scrollW = stageWidth - mapView.width;
			scrollH = stageHeight - mapView.height;
		}

		private function configListener() : void {
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}

		private function onEnterFrame(e : Event) : void {
			var tempX : Number = mapView.x;
			if (moveX == 1) {
				tempX += scrollSpeed;
				if (tempX >= 0) {
					moveX = 0;
					tempX = 0;
				}
			}else if (moveX == 2) {
				tempX -= scrollSpeed;
				if (tempX <= scrollW) {
					moveX = 0;
					tempX = scrollW;
				}
			}
			mapView.x = tempX;
			
			var tempY : Number = mapView.y;
			if (moveY == 1) {
				tempY += scrollSpeed;
				if (tempY >= 0) {
					moveY = 0;
					tempY = 0;
				}
			}else if (moveY == 2) {
				tempY -= scrollSpeed;
				if (tempY <= scrollH) {
					moveY = 0;
					tempY = scrollH;
				}
			}
			mapView.y = tempY;
		}

		private function onMouseMove(e : MouseEvent) : void {
			if (e.stageX < sensor) {
				moveX = 1;
			}else if (e.stageX > stage.stageWidth - sensor) {
				moveX = 2;
			} else {
				moveX = 0;
			}
			
			if (e.stageY < sensor) {
				moveY = 1;
			}else if (e.stageY > stage.stageHeight - sensor) {
				moveY = 2;
			} else {
				moveY = 0;
			}
			
			if (moveX != 0 || moveY != 0) {
				if (!this.hasEventListener(Event.ENTER_FRAME))
					this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			} else {
				if (this.hasEventListener(Event.ENTER_FRAME))
					this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
	}
}
