package cn.macro.slg.view
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author yyi
	 */
	public class Role extends Sprite
	{
		public var mobility : int;
		public var place : GridNode;
		public var speed : int = 13;

		private var pathArr : Array;
		private var targetPlace : GridNode;

		public function Role(type : int, mobility : int = 50)
		{

			this.mobility = mobility;

			var color : uint;
			if (type == 0)
				color = 0x000000;
			else if (type == 1)
				color = 0x0000ff;

			doDrawGrid(color);
			this.mouseEnabled = false;
		}

		public function move(getPath : Array) : void
		{
			place = null;
			targetPlace = getPath[getPath.length - 1];
			pathArr = getPath;
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function getDistance(x1 : int, y1 : int, x2 : int, y2 : int) : Number
		{
			return Math.sqrt(Math.pow((x2 - x1), 2) + Math.pow((y2 - y1), 2));
		}

		private function getPoint(x1 : int, y1 : int, x2 : int, y2 : int, r : int) : Point
		{
			var p : Point = new Point();
			if (x1 == x2)
			{
				p.x = x1;
				p.y = y1 + ((y1 > y2) ? -r : r); 
			}else if(y1 == y2) 
			{
				p.y = y1;
				p.x = x1 + ((x1 > x2) ? -r : r);
			}
			else
			{
				p.x = Math.sqrt(Math.pow(r, 2) / (1 + Math.pow(y2 - y1, 2) / Math.pow(x2 - x1, 2))) + x1;
				p.y = (p.x - x1) * (y2 - y1) / (x2 - x1) + y1;
			}
			return p;
		}

		private function onEnterFrame(e : Event) : void
		{
			if (pathArr.length > 0)
			{
				var grid : GridNode = pathArr[0];

				var targetX : int = grid.x + grid.width * 0.5;
				var targetY : int = grid.y + grid.height * 0.5;
				
				var sourceX : int = this.x;
				var sourceY : int = this.y;
				var d : int = getDistance(this.x, this.y, targetX, targetY);
				var p : Point = new Point(targetX, targetY);; 
				if (d < speed)
				{
					pathArr.shift();
					if (pathArr.length > 0)
					{
						grid = pathArr[0];
						sourceX = targetX;
						sourceY = targetY;
						targetX = grid.x + grid.width * 0.5;
						targetY = grid.y + grid.height * 0.5;
						
						p = getPoint(sourceX, sourceY, targetX, targetY, speed - d);
					}
				}else if(d == speed) 
				{
					pathArr.shift();
				}
				else
				{
					p = getPoint(sourceX, sourceY, targetX, targetY, speed);
				}
				(this.parent as MapView).drawPoint(p);
				this.x = p.x;
				this.y = p.y;
			}
			else
			{
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				place = targetPlace;
				targetPlace = null;
			}
		}

		private function doDrawGrid(color : uint) : void
		{
			graphics.beginFill(color);
			graphics.lineStyle(0, color);
			graphics.drawRect(-10, -5, 20, 30);
			graphics.drawCircle(0, -15, 10);
			graphics.endFill();
		}
	}
}
