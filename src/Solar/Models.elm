module Solar.Models exposing (Model, init)

import Solar.Types exposing (..)
import Dict exposing (Dict)
import WebGL.Texture exposing (Texture, loadWith, nonPowerOfTwoOptions)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
import Time exposing (Time)
import Solar.SceneGraph exposing (starsystem, updateMatrix)
import Solar.Messages exposing (Msg(TextureLoaded))
import Task


type alias Model =
    { zoom : Float
    , rotate : Float
    , translateX : Float
    , translateY : Float
    , starsystem : StarSystem
    , textures : Dict String Texture
    , mouse : Vec3
    , theta : Time
    }


init : Model
init =
    let
        initialisedSystem =
            List.map (updateMatrix 0 Nothing) starsystem.stars
    in
        Model 3 0 0 0 (StarSystem initialisedSystem) Dict.empty (vec3 0 0 0) 0


initCommand : Cmd Msg
initCommand =
    Cmd.batch
        [ Task.attempt (TextureLoaded "font.png") (loadWith nonPowerOfTwoOptions "texture/font.png") ]
