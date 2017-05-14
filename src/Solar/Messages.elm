module Solar.Messages exposing (..)

import Time exposing (Time)
import WebGL.Texture exposing (Texture, Error)


type Msg
    = ShowSolar
    | SetZoom String
    | SetRotate String
    | SetTranslateX String
    | SetTranslateY String
    | TextureLoaded String (Result Error Texture)
    | MouseClick ( Int, Int )
    | Tick Time
