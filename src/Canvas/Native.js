

function createTile(tile){
  console.log('creating tile');
        ctx.beginPath();

        const center =  { x: 50
                        , y: 50
                        }

       const point = hex_corner(center, 20, i);
       ctx.moveTo( point.x, point.y);

       var i;
        for (i = 0; i < 6; i++) {
            const point = hex_corner(center, 20, i);
            ctx.lineTo( point.x, point.y);
          }
        ctx.closePath();
        ctx.fill();
}

function hex_corner(center, size, i) {
    var angle_deg = 60 * i   + 30
    var angle_rad = Math.PI / 180 * angle_deg
    return  { x: center.x + size * Math.cos(angle_rad)
            , y: center.y + size * Math.sin(angle_rad)
            }
}

//Paths

// fill(ctx){
//   ctx.fill();
// }
//
function stroke(ctx){
  ctx.stroke();
}
//
// beginPath(ctx){
//   ctx.beginPath()
// }
//
 function moveTo(x, y){
   ctx.moveTo(x,y);
 }
//
// closePath(){}
//
function lineTo(x, y){
  ctx.lineTo(x,y);
}
//
// clip(){}
//
// quadraticCurveTo(){}
//
// bezierCurveTo(){}
//
// arc(){}
//
// arcTo(){}
//
// isPointInPath(){}

//Styling

//init
var ctx;

function initCanvas(canvasName){
      var c = document.getElementById(canvasName);
      ctx = c.getContext("2d");
      ctx.moveTo(0,0);
      ctx.lineTo(200,100);
      ctx.stroke();
}
