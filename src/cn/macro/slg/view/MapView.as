package cn.macro.slg.view
{
	import flash.geom.Point;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author yyi
	 */
	public class MapView extends Sprite
	{

		private var gridSize : uint = 60;
		private var gridView : GridView;

		private var roleList : Array = new Array();
		private var roleSelected : Role;

		private var cacheGrid : Array;
		
		private var temp:Sprite;

		public function MapView(mapData : Array)
		{

			gridView = new GridView();
			gridView.w = mapData[0].length;
			gridView.h = mapData.length;

			for (var i : uint = 0;i < mapData.length; i++)
			{
				var tempArr : Array = new Array();
				var mapArr : Array = mapData[i];
				for (var j : uint = 0;j < mapArr.length; j++)
				{
					var grid : GridNode = new GridNode(gridSize);
					grid.x = j * gridSize;
					grid.y = i * gridSize;
					grid.xIndex = j;
					grid.yIndex = i;
					grid.friction = mapArr[j];
					gridView.addChild(grid);
					tempArr.push(grid);
				}
			}
			addChild(gridView);

			this.addEventListener(CellEvent.CELL_CLICK, onSelect);

			var role1 : Role = new Role(0);
			setRolePos(role1, 5, 4);
			roleList.push(role1);			
			addChild(role1);
			
			var role2 : Role = new Role(1, 30);
			setRolePos(role2, 8, 5);
			roleList.push(role2);			
			addChild(role2);
			
			temp = new Sprite();
			addChild(temp);
		}
		
		public function drawPoint(p:Point) : void
		{
			var g:Graphics = temp.graphics;
			g.beginFill(0xFFFFFF);
			g.lineStyle(1, 0x000000);
			g.drawCircle(p.x - 1, p.y - 1, 3);
			g.endFill();
		}

		private function setRolePos(role : Role, x : int, y : int) : void
		{
			var t : GridNode = gridView.getChild(x, y);
			role.x = t.x + gridSize * 0.5;
			role.y = t.y + gridSize * 0.5;
			role.place = t;
		}

		private function onSelect(e : Event) : void
		{
			var clickGridNode : GridNode = e.target as GridNode;
			
			var role : Role = checkRole(clickGridNode);

			if (role != null)
			{
				if (role == roleSelected && clickGridNode.selected)
				{
					clearSelect();
					roleSelected = null;
				}
				else
				{
					clearSelect();
					cacheGrid = MArrayUtil.createMArray(gridView.w, gridView.h);
					selectRange(clickGridNode, role.mobility);
					roleSelected = role;
				}
			}
			else
			{
				if (clickGridNode.selected)
				{
					roleSelected.move(getPath(clickGridNode));
				}
				clearSelect();
			}
		}

		private function getPath(gridNode : GridNode) : Array
		{
			var pathArr : Array = new Array();
			while(gridNode != roleSelected.place)
			{
				pathArr.push(gridNode);
				var top : int = (gridNode.yIndex > 0) ? cacheGrid[gridNode.xIndex][gridNode.yIndex - 1] : 0;				
				var bottom : int = (gridNode.yIndex + 1 < gridView.h) ? cacheGrid[gridNode.xIndex][gridNode.yIndex + 1] : 0;				
				var left : int = (gridNode.xIndex > 0) ? cacheGrid[gridNode.xIndex - 1][gridNode.yIndex] : 0;				
				var right : int = (gridNode.xIndex + 1 < gridView.w) ? cacheGrid[gridNode.xIndex + 1][gridNode.yIndex] : 0;				
				
				var max : int = Math.max(top, bottom, left, right);
				switch (max) {
					case top:
						gridNode = gridView.getChild(gridNode.xIndex, gridNode.yIndex - 1);
						break;
					case right:
						gridNode = gridView.getChild(gridNode.xIndex + 1, gridNode.yIndex);
						break;
					case bottom:
						gridNode = gridView.getChild(gridNode.xIndex, gridNode.yIndex + 1);
						break;
					case left:
						gridNode = gridView.getChild(gridNode.xIndex - 1, gridNode.yIndex);
						break;
				}
			}
			return pathArr.reverse();
		}

		protected function checkRole(grid : GridNode) : Role
		{
			for (var i : int = 0;i < roleList.length; i++)
			{
				var role : Role = roleList[i];
				if (role.place == grid)
					return role;
			}
			return null;
		}

		private function selectRange(gridNode : GridNode, mobility : int) : void
		{
			if (cacheGrid[gridNode.xIndex][gridNode.yIndex] != null && cacheGrid[gridNode.xIndex][gridNode.yIndex] >= mobility)
				return;

			cacheGrid[gridNode.xIndex][gridNode.yIndex] = mobility;
			if (mobility < 0)
				return;

			gridNode.selected = true;

			var topGrid : GridNode = gridView.getChild(gridNode.xIndex, gridNode.yIndex - 1);
			if (topGrid != null)
				selectRange(topGrid, mobility - topGrid.friction);

			var bottomGrid : GridNode = gridView.getChild(gridNode.xIndex, gridNode.yIndex + 1);
			if (bottomGrid != null)
				selectRange(bottomGrid, mobility - bottomGrid.friction);

			var leftGrid : GridNode = gridView.getChild(gridNode.xIndex - 1, gridNode.yIndex);
			if (leftGrid != null)
				selectRange(leftGrid, mobility - leftGrid.friction);

			var rightGrid : GridNode = gridView.getChild(gridNode.xIndex + 1, gridNode.yIndex);
			if (rightGrid != null)
				selectRange(rightGrid, mobility - rightGrid.friction);
		}

		protected function clearSelect() : void
		{
			cacheGrid = null;
			for (var i : uint = 0;i < gridView.h; i++)
			{
				for (var j : uint = 0;j < gridView.w; j++)
				{
					gridView.getChild(j, i).selected = false;
				}
			}
		}
	}
}
