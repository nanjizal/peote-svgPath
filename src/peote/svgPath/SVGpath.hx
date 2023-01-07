package peote.svgPath;

import peote.svgPath.Tri;
import justPath.SvgLinePath;
import justPath.ILinePathContext;
import justPath.LinePathContextTrace;

typedef QuadrilateralPos = { ax: Float, ay: Float, bx: Float, by: Float, cx: Float, cy: Float, dx: Float, dy: Float };
typedef TrianglePos = { ax: Float, ay: Float, bx: Float, by: Float, cx: Float, cy: Float };

class SVGpath implements ILinePathContext {
    public var strokeWidth: Float;
    public var strokeColor: Int;
    public var translateX: Float;
    public var translateY: Float;
    public var scaleX: Float;
    public var scaleY: Float;
    var toggleDraw = true;
    var info: QuadrilateralPos; //{ ax: Float, ay: Float, bx: Float, by: Float, cx: Float, cy: Float, dx: Float, dy: Float };
    var x0: Float = 0.;
    var y0: Float = 0.;
    var svgLinePath: SvgLinePath;
    public function new( strokeColor        = 0xff0000ff
                       , strokeWidth        = 1.
                       , translateX         = 0.
                       , translateY         = 0.
                       , scaleX             = 1.
                       , scaleY             = 1. ){
        svgLinePath = new SvgLinePath( this );
    }
    public function drawPath( pathData: String ){
        if( pathData != '' ) svgLinePath.parse( pathData );
    }
    public
    function lineSegmentTo( x2: Float, y2: Float ){
        if( toggleDraw ){
            var oldInfo = info;
            info = fillLine( x0*scaleX + translateX, y0*scaleY + translateY
                     , x2*scaleX + translateX, y2*scaleY + translateY 
                     , strokeWidth, strokeColor );
            if( info != null && oldInfo != null ){
                fillQuadrilateral( oldInfo.bx*scaleX + translateX, oldInfo.by*scaleY + translateY, info.ax*scaleX + translateX, info.ay*scaleY + translateY, info.dx*scaleX + translateX, info.dy*scaleY + translateY, oldInfo.cx*scaleX + translateX, oldInfo.cy*scaleY + translateY, strokeColor );
            }
        } else {
            
        }
        toggleDraw = !toggleDraw;
        x0 = x2;
        y0 = y2;
    }
    public
    function lineTo( x2: Float, y2: Float ){
        var oldInfo = info;
        info = fillLine( x0*scaleX + translateX, y0*scaleY + translateY
                     , x2*scaleX + translateX, y2*scaleY + translateY 
                     , strokeWidth, strokeColor );
        if( info != null && oldInfo != null ){
            fillQuadrilateral( oldInfo.bx*scaleX + translateX, oldInfo.by*scaleY + translateY, info.ax*scaleX + translateX, info.ay*scaleY + translateY, info.dx*scaleX + translateX, info.dy*scaleY + translateY, oldInfo.cx*scaleX + translateX, oldInfo.cy*scaleY + translateY, strokeColor );
        }
        x0 = x2;
        y0 = y2;
        toggleDraw = true;
    }
    public
    function moveTo( x1: Float, y1: Float ){
        x0 = x1;
        y0 = y1;
        info = null;
        toggleDraw = true;
    }
    public
    function fillLine( px: Float, py: Float, qx: Float, qy: Float
                     , thick: Float, color: Int ): QuadrilateralPos {
        var o = qy-py;
        var a = qx-px;
        var h = Math.pow( o*o + a*a, 0.5 );
        var theta = Math.atan2( o, a );
        return rotateLine( px, py, thick, h, theta, color );
    }
    function rotateLine(  px: Float, py: Float
                        , thick: Float, h: Float
                        , theta: Float, color: Int ): QuadrilateralPos {
        var sin = Math.sin( theta );
        var cos = Math.cos( theta );
        var radius = thick/2;
        var dx = 0.1;
        var dy = radius;
        var cx = h;
        var cy = radius;
        var bx = h;
        var by = -radius;
        var ax = 0.1;
        var ay = -radius;
        var temp = 0.;
        temp = px + rotX( ax, ay, sin, cos );
        ay = py + rotY( ax, ay, sin, cos );
        ax = temp;
    
        temp = px + rotX( bx, by, sin, cos );
        by = py + rotY( bx, by, sin, cos );
        bx = temp;

        temp = px + rotX( cx, cy, sin, cos );
        cy = py + rotY( cx, cy, sin, cos );
        cx = temp;

        temp = px + rotX( dx, dy, sin, cos );
        dy = py + rotY( dx, dy, sin, cos ); 
        dx = temp;
        return fillQuadrilateral( ax, ay, bx, by, cx, cy, dx, dy, color );
    }
    public
    function fillQuadrilateral( ax: Float, ay: Float
                              , bx: Float, by: Float
                              , cx: Float, cy: Float
                              , dx: Float, dy: Float 
                              , color: Int ): QuadrilateralPos {
        // tri e - a b d
        // tri f - b c d
        fillTriangle( ax, ay, bx, by, dx, dy, color );
        fillTriangle( ax, ay, cx, cy, dx, dy, color );
        return { ax: ax, ay: ay, bx: bx, by: by, cx: cx, cy: cy, dx: dx, dy: dy };
    }
    function fillTriangle( ax: Float, ay: Float
                         , bx: Float, by: Float
                         , cx: Float, cy: Float
                         , color: Int ): TrianglePos {
        var adjustWinding = ( (ax * by - bx * ay) + (bx * cy - cx * by) + (cx * ay - ax * cy) )>0;
        if( !adjustWinding ){
            var bx_ = bx;
            var by_ = by;
            bx = cx;
            by = cy;
            cx = bx_;
            cy = by_;
        }
        new Tri(			
			ax, ay, color,
			bx, by, color,
			cx, cy, color
		);
        return { ax: ax, ay: ay, bx: bx, by: by, cx: cx, cy: cy };
    }
    inline
    function rotX( x: Float, y: Float, sin: Float, cos: Float ){
        return x * cos - y * sin;
    }
    inline
    function rotY( x: Float, y: Float, sin: Float, cos: Float ){
        return y * cos + x * sin;
    }
}