port module Canvas.Ports exposing (..)

type alias CanvasId = String


port createTile : CanvasId -> Cmd msg

port initCanvas : CanvasId -> Cmd msg

-- fill(ctx){
--   ctx.fill();
-- }
--
port stroke : () -> Cmd msg
--
-- beginPath(ctx){
--   ctx.beginPath()
-- }
--
port moveTo : (Int,  Int) -> Cmd msg

-- closePath(){}
--
port lineTo : (Int,  Int) -> Cmd msg
