module Solar.SceneGraph exposing (..)

import Solar.Types exposing (..)
import Solar.Meshes exposing (loop, circleMesh, faceMesh)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Color


-- import Time exposing (Time)


walk : (SpaceObject -> a) -> SpaceObject -> List a
walk function spaceObject =
    let
        children =
            List.concatMap (walk function) (unwrapChildren spaceObject.children)

        result =
            function spaceObject
    in
        result :: children


update : (SpaceObject -> SpaceObject) -> SpaceObject -> SpaceObject
update function spaceObject =
    let
        result =
            function spaceObject

        updated =
            List.map (update function) (unwrapChildren spaceObject.children)
    in
        { result | children = Children updated }


starsystem : StarSystem
starsystem =
    { stars = [ star ] }


updateMatrix : Float -> Maybe Mat4 -> SpaceObject -> SpaceObject
updateMatrix time parentMatrix spaceObject =
    let
        parentMatrix_ =
            case parentMatrix of
                Nothing ->
                    Mat4.identity

                Just parentMatrix ->
                    parentMatrix

        transform =
            Mat4.mul parentMatrix_ spaceObject.localMatrix
                |> Mat4.rotate (time * pi) (vec3 0 0 1)

        transformedChildren =
            spaceObject.children
                |> unwrapChildren
                |> List.map (updateMatrix time (Just transform))
                |> Children

        result =
            { spaceObject | worldMatrix = parentMatrix_, children = transformedChildren }
    in
        result


transformMatrix : Float -> Float -> Vec3 -> Mat4
transformMatrix scale rotation translation =
    Mat4.identity
        |> Mat4.translate translation
        |> Mat4.rotate (rotation * pi) (vec3 0 0 1)
        |> Mat4.scale (vec3 scale scale scale)


text : SpaceObject
text =
    { name = "text"
    , renderFunction = Just faceMesh
    , texture = "font.png"
    , worldMatrix = Mat4.identity
    , localMatrix = transformMatrix 5 0 (vec3 0 2 0)
    , color = Color.red
    , children = Children []
    , selected = False
    , selectable = False
    }


star : SpaceObject
star =
    { name = "star"
    , renderFunction = Just circleMesh
    , texture = ""
    , worldMatrix = Mat4.identity
    , localMatrix = transformMatrix 1 0 (vec3 0 0 0)
    , color = Color.yellow
    , children = Children [ planetOrbit, text ]
    , selected = True
    , selectable = True
    }


planetOrbit : SpaceObject
planetOrbit =
    { name = "planetOrbit"
    , renderFunction = Nothing
    , texture = ""
    , worldMatrix = Mat4.identity
    , localMatrix = transformMatrix 1 0 (vec3 0 0 0)
    , color = Color.blue
    , children = Children [ planet, planetOrbitMesh ]
    , selected = False
    , selectable = False
    }



--make sure the scale of the orbit mesh is equal to the radious of the orbiting spaceobject


planetOrbitMesh : SpaceObject
planetOrbitMesh =
    { name = "planetOrbitMesh"
    , renderFunction = Just loop
    , texture = ""
    , worldMatrix = Mat4.identity
    , localMatrix = transformMatrix 5 0 (vec3 0 0 0)
    , color = Color.blue
    , children = Children []
    , selected = False
    , selectable = False
    }


planet : SpaceObject
planet =
    { name = "planet"
    , renderFunction = Just circleMesh
    , texture = ""
    , worldMatrix = Mat4.identity
    , localMatrix = transformMatrix 0.8 0.7 (vec3 5 0 0)
    , color = Color.blue
    , children = Children [ moonOrbit ]
    , selected = False
    , selectable = True
    }


moonOrbit : SpaceObject
moonOrbit =
    { name = "moonOrbit"
    , renderFunction = Nothing
    , texture = ""
    , worldMatrix = Mat4.identity
    , localMatrix = transformMatrix 1 0.4 (vec3 0 0 0)
    , color = Color.green
    , children = Children [ moon, moonOrbitMesh ]
    , selected = False
    , selectable = False
    }


moonOrbitMesh : SpaceObject
moonOrbitMesh =
    { name = "moonOrbitMesh"
    , renderFunction = Just loop
    , texture = ""
    , worldMatrix = Mat4.identity
    , localMatrix = transformMatrix 3 0 (vec3 0 0 0)
    , color = Color.green
    , children = Children []
    , selected = False
    , selectable = False
    }


moon : SpaceObject
moon =
    { name = "moon"
    , renderFunction = Just circleMesh
    , texture = ""
    , worldMatrix = Mat4.identity
    , localMatrix = transformMatrix 0.5 1.3 (vec3 0 3 0)
    , color = Color.green
    , children = Children []
    , selected = False
    , selectable = True
    }
