module Solar.Types exposing (..)

import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Color exposing (Color)
import WebGL exposing (Mesh)


type alias Vertex =
    { color : Vec3
    , position : Vec3
    }


type alias SpaceObject =
    { name : String
    , renderFunction : Maybe (Color -> Mesh Vertex)
    , texture : String
    , worldMatrix : Mat4
    , localMatrix : Mat4
    , color : Color
    , children : Children
    , selected : Bool
    , selectable : Bool
    }


type alias StarSystem =
    { stars : List SpaceObject
    }


type Children
    = Children (List SpaceObject)


unwrapChildren : Children -> List SpaceObject
unwrapChildren (Children children) =
    children
