package cn.macro.slg.view {
	import flash.utils.Dictionary;
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author yyi
	 */
	public class GridView extends Sprite {
		public var w : uint;
		public var h : uint;

		private var dict : Dictionary = new Dictionary();

		public function GridView() {
		}

		public override function addChild(child : DisplayObject) : DisplayObject {
			var gridNode : GridNode = child as GridNode;
			var key : String = gridNode.xIndex + "x" + gridNode.yIndex;
			dict[key] = gridNode;
			super.addChild(gridNode);
			return gridNode;
		}

		public function getChild(x : uint, y : uint) : GridNode {
			var key : String = x + "x" + y;
			return dict[key];
		}
	}
}
