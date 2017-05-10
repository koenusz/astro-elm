module Solar.Meshes exposing (..)

import Solar.Types exposing (Vertex)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
import WebGL exposing (Mesh)
import Color exposing (Color)


circleMesh : Color -> Mesh Vertex
circleMesh color =
    let
        clr =
            colorToVec color

        center =
            Vertex clr (vec3 0 0 0)

        attributes =
            center :: []

        pointList =
            circleCircumference color 1 50
    in
        pointList
            |> List.append attributes
            |> WebGL.triangleFan


loop : Color -> Mesh Vertex
loop color =
    let
        clr =
            colorToVec color

        center =
            Vertex clr (vec3 0 0 0)

        attributes =
            []

        pointList =
            circleCircumference color 1 50
    in
        pointList
            |> List.append attributes
            |> WebGL.lineLoop


circleCircumference : Color -> Float -> Int -> List Vertex
circleCircumference color radius vertexAmount =
    let
        clr =
            colorToVec color

        verticise : Int -> Vertex
        verticise point =
            Vertex
                (Vec3.scale (0.01 * (100 - toFloat point)) clr)
                (vec3 (x point) (y point) 0)

        pointList =
            List.range 0 vertexAmount

        angle : Int -> Float
        angle point =
            toFloat point
                |> (*) (2 / toFloat vertexAmount)
                |> (*) pi

        x : Int -> Float
        x point =
            angle point
                |> cos
                |> (*) radius

        y : Int -> Float
        y point =
            angle point
                |> sin
                |> (*) radius
    in
        List.map verticise pointList


colorToVec : Color -> Vec3
colorToVec rawColor =
    let
        c =
            Color.toRgb rawColor
    in
        vec3
            (toFloat c.red / 255)
            (toFloat c.green / 255)
            (toFloat c.blue / 255)


cubeMesh : Mesh Vertex
cubeMesh =
    let
        rft =
            vec3 1 1 1

        lft =
            vec3 -1 1 1

        lbt =
            vec3 -1 -1 1

        rbt =
            vec3 1 -1 1

        rbb =
            vec3 1 -1 -1

        rfb =
            vec3 1 1 -1

        lfb =
            vec3 -1 1 -1

        lbb =
            vec3 -1 -1 -1
    in
        [ face Color.green rft rfb rbb rbt
        , face Color.blue rft rfb lfb lft
        , face Color.yellow rft lft lbt rbt
        , face Color.red rfb lfb lbb rbb
        , face Color.purple lft lfb lbb lbt
        , face Color.orange rbt rbb lbb lbt
        ]
            |> List.concat
            |> WebGL.triangles


faceMesh : Color -> Mesh Vertex
faceMesh color =
    let
        rft =
            vec3 1 1 0

        lft =
            vec3 0 1 0

        rfb =
            vec3 1 0 0

        lfb =
            vec3 0 0 0
    in
        [ face color rft rfb lfb lft ]
            |> List.concat
            |> WebGL.triangles


face : Color -> Vec3 -> Vec3 -> Vec3 -> Vec3 -> List ( Vertex, Vertex, Vertex )
face rawColor a b c d =
    let
        color =
            let
                c =
                    Color.toRgb rawColor
            in
                vec3
                    (toFloat c.red / 255)
                    (toFloat c.green / 255)
                    (toFloat c.blue / 255)

        vertex position =
            Vertex color position
    in
        [ ( vertex a, vertex b, vertex c )
        , ( vertex c, vertex d, vertex a )
        ]
