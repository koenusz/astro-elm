
function logThis(string){
  console.log(string);
}


function initCanvas(canvasName){
      var c = document.getElementById(canvasName);
      var ctx = c.getContext("2d");
      ctx.moveTo(0,0);
      ctx.lineTo(200,100);
      ctx.stroke();
}
