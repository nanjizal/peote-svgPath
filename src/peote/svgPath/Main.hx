package peote.svgPath;

import haxe.CallStack;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;

import lime.app.Application;
import lime.ui.Window;

import peote.view.PeoteView;
import peote.view.Buffer;
import peote.view.Display;
import peote.view.Program;
import peote.view.Color;
import peote.svgPath.Tri;
import peote.svgPath.SVGpath;

class Main extends Application
{
	override function onWindowCreate():Void
	{
		switch (window.context.type)
		{
			case WEBGL, OPENGL, OPENGLES:
				try startSample(window)
				catch (_) trace(CallStack.toString(CallStack.exceptionStack()), _);
			default: throw("Sorry, only works with OpenGL.");
		}
	}
	
	public function startSample(window:Window)
	{
		var peoteView = new PeoteView(window);
		var display = new Display(0, 0, window.width, window.height);
		peoteView.addDisplay(display);
		Tri.init(display);
		var lineThick = 4;
		var drawing = new SVGpath( Color.RED, lineThick );
		//drawing.fillTriangle( 100,100,200,150,130,220, Color.RED );
		//drawing.fillLine( 100, 100, 500, 500, Color.RED, 20 );
		//drawing.fillQuadrilateral(100,300,300,120,130,220,500,500, Color.RED );
		drawing.fillQuadrilateral( 20, 20, 200, 20, 200+50, 200, 20+50, 200, Color.RED );
		//drawing.fillQuadrilateral(20, 20,200, 20,200,200,20,200, Color.RED );
		
		//var pathData =  'M200,300 Q400,50 600,300 T1000,300,L50,50 L20,20 L100,200 C100,100 250,100 250,200S400,300 400,200';

		//drawing.drawPath( pathData );
		
		//basicTriangle();
		//basicTriangle2();

	}
	public function basicTriangle()
	{
		var aX=100; 
		var aY=100; 
        var bX=200;
		var bY=150; 
        var cX=130; 
		var cY=220; 
		var tri = new Tri(			
			aX, aY, Color.RED,
			bX, bY, Color.RED,
			cX, cY, Color.RED
		);
	}
	public function basicTriangle2()
	{
		var aX=50; 
		var aY=10; 
		var bX=100;
		var bY=10; 
		var cX=130; 
		var cY=120; 
		var tri = new Tri(			
			aX, aY, Color.RED,
			bX, bY, Color.RED,
			cX, cY, Color.RED
		);
	}
}
