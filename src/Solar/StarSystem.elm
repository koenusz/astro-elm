module Solar.Starsystem exposing (..)

import Html exposing (Html, div, button, text, input, hr)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
import Math.Vector2 as Vec2 exposing (vec2, Vec2)
import WebGL exposing (Mesh, Shader)
import WebGL.Texture exposing (Texture, Error)
import Solar.Types exposing (Vertex, StarSystem, SpaceObject)
import Solar.SceneGraph as SceneGraph
import Dict exposing (Dict)
import Json.Decode exposing (int, map2, field, Decoder)
import Solar.Models exposing (Model)
import Solar.Messages exposing (Msg(..))


width_ : Int
width_ =
    800


height_ : Int
height_ =
    800



-- import AnimationFrame


perspective : Mat4
perspective =
    Mat4.makePerspective 60 1 0.1 100


camera : Float -> Mat4
camera zoom =
    Mat4.makeLookAt (vec3 0 0 (10 * zoom)) (vec3 0 0 0) (vec3 0 1 0)



-- main : Program Never Model StarsystemMsg
-- main =
--     Html.program
--         { init = ( model, initCommand )
--         , view = view
--         , subscriptions =
--             (\_ -> Sub.none)
--             --(\_ -> AnimationFrame.diffs Tick)
--         , update = update
--         }


viewToClipspace : Vec3 -> Vec3
viewToClipspace view =
    let
        x =
            (Vec3.getX view) * 2 / (toFloat width_) - 1

        y =
            (Vec3.getY view) * -2 / (toFloat height_) + 1
    in
        vec3 x y 0



{- Select an object in the view based on the clicklocation (raycasting) -}


select : Model -> Model
select model =
    { model | starsystem = StarSystem (List.map (SceneGraph.update (checkSelectionforSpaceObject model)) model.starsystem.stars) }


checkSelectionforSpaceObject : Model -> SpaceObject -> SpaceObject
checkSelectionforSpaceObject model spaceObject =
    let
        selectSpaceObject : Bool -> SpaceObject
        selectSpaceObject selected =
            { spaceObject | selected = selected }

        clipspaceClick =
            viewToClipspace model.mouse

        center =
            multiplyByViewAndLocation model spaceObject (vec3 0 0 0)

        pointOnCircle =
            multiplyByViewAndLocation model spaceObject (vec3 0 1 0)
    in
        clipspaceClick
            |> clickInsideCircle center pointOnCircle
            |> Debug.log spaceObject.name
            |> selectSpaceObject


multiplyByViewAndLocation : Model -> SpaceObject -> Vec3 -> Vec3
multiplyByViewAndLocation model spaceObject input =
    let
        transform =
            Mat4.mul spaceObject.worldMatrix spaceObject.localMatrix
    in
        Mat4.transform
            (Mat4.mul (Mat4.mul perspective (camera model.zoom)) transform)
            input


clickInsideCircle : Vec3 -> Vec3 -> Vec3 -> Bool
clickInsideCircle center pointOnCircle mouse =
    let
        mouseX =
            Vec3.getX mouse

        mouseY =
            Vec3.getY mouse

        centerX =
            Vec3.getX center

        centerY =
            Vec3.getY center

        pointX =
            Vec3.getX pointOnCircle

        pointY =
            Vec3.getY pointOnCircle

        r2 =
            (centerX - pointX) ^ 2 + (centerY - pointY) ^ 2
    in
        (centerX - mouseX) ^ 2 + (centerY - mouseY) ^ 2 <= r2


spaceObjectLocation : Model -> SpaceObject -> Html Msg
spaceObjectLocation model spaceObject =
    div []
        [ div [] [ text spaceObject.name ]
        , div []
            [ case spaceObject.renderFunction of
                Nothing ->
                    div [] []

                Just renderFunction ->
                    div []
                        [ [ vec3 0 0 0, vec3 0 1 0 ]
                            |> List.map (multiplyByViewAndLocation model spaceObject)
                            |> toString
                            |> text
                        ]
            ]
        ]


offsetPosition : Decoder ( Int, Int )
offsetPosition =
    map2 (,) (field "offsetX" int) (field "offsetY" int)


prepareScene : Model -> List WebGL.Entity
prepareScene model =
    -- List.concatMap (prepareSpaceObject model Nothing) model.starsystem.stars
    List.filterMap (\x -> x) (List.concatMap (SceneGraph.walk (prepareSpaceObject2 model)) model.starsystem.stars)


prepareSpaceObject2 : Model -> SpaceObject -> Maybe WebGL.Entity
prepareSpaceObject2 model spaceObject =
    let
        transform =
            Mat4.mul spaceObject.worldMatrix spaceObject.localMatrix

        result =
            case spaceObject.renderFunction of
                Nothing ->
                    Nothing

                Just renderFunction ->
                    if String.isEmpty spaceObject.texture then
                        Just
                            (WebGL.entity
                                vertexShader
                                fragmentShader
                                (renderFunction spaceObject.color)
                                (uniforms model spaceObject.selected transform)
                            )
                    else
                        case Dict.get spaceObject.texture model.textures of
                            Nothing ->
                                (spaceObject.texture
                                    |> (++) "no texture: "
                                    |> Debug.log
                                )
                                    Nothing

                            Just texture ->
                                Just
                                    (WebGL.entity
                                        textureVertexShader
                                        textureFragmentShader
                                        (renderFunction spaceObject.color)
                                        (textureUniforms (uniforms model spaceObject.selected transform) texture)
                                    )
    in
        result


spaceObjectToEntity : Model -> Mat4 -> SpaceObject -> Maybe WebGL.Entity
spaceObjectToEntity model worldMatrix spaceOnject =
    let
        transform =
            Mat4.mul worldMatrix spaceOnject.localMatrix

        result =
            case spaceOnject.renderFunction of
                Nothing ->
                    Nothing

                Just renderFunction ->
                    if String.isEmpty spaceOnject.texture then
                        Just
                            (WebGL.entity
                                vertexShader
                                fragmentShader
                                (renderFunction spaceOnject.color)
                                (uniforms model spaceOnject.selected transform)
                            )
                    else
                        case Dict.get spaceOnject.texture model.textures of
                            Nothing ->
                                (spaceOnject.texture
                                    |> (++) "no texture: "
                                    |> Debug.log
                                )
                                    Nothing

                            Just texture ->
                                Just
                                    (WebGL.entity
                                        textureVertexShader
                                        textureFragmentShader
                                        (renderFunction spaceOnject.color)
                                        (textureUniforms (uniforms model spaceOnject.selected transform) texture)
                                    )
    in
        result


type alias Uniforms =
    { transform : Mat4
    , perspective : Mat4
    , camera : Mat4
    , shade : Float
    , selected : Bool
    }


type alias TextureUniforms uniforms =
    { uniforms
        | texture : Texture
    }


uniforms : Model -> Bool -> Mat4 -> Uniforms
uniforms model selected transform =
    { transform = transform
    , perspective = perspective
    , camera = camera model.zoom
    , shade = 0.8
    , selected = selected
    }


textureUniforms : Uniforms -> Texture -> TextureUniforms Uniforms
textureUniforms uniforms input =
    { camera = uniforms.camera
    , perspective = uniforms.perspective
    , shade = uniforms.shade
    , transform = uniforms.transform
    , selected = uniforms.selected
    , texture = input
    }


vertexShader : Shader Vertex Uniforms { vcolor : Vec3 }
vertexShader =
    [glsl|
        attribute vec3 position;
        attribute vec3 color;
        uniform mat4 transform;
        uniform mat4 perspective;
        uniform mat4 camera;
        varying vec3 vcolor;
        void main () {
            gl_Position = perspective * camera * transform * vec4(position, 1.0);
            vcolor = color;
        }
    |]


fragmentShader : Shader {} Uniforms { vcolor : Vec3 }
fragmentShader =
    [glsl|

        precision mediump float;
        uniform float shade;
        uniform bool selected;
        varying vec3 vcolor;
        void main () {
            gl_FragColor = shade * vec4(vcolor, 1.0);
            if(selected){
              gl_FragColor = gl_FragColor *  vec4(1, 0.5, 0.5, 1.0);
            }
        }
    |]


textureVertexShader : Shader Vertex (TextureUniforms Uniforms) { vTexturePos : Vec2 }
textureVertexShader =
    [glsl|

    attribute vec3 position;
    uniform mat4 transform;
    uniform mat4 perspective;
    uniform mat4 camera;
    varying vec2 vTexturePos;
    void main () {
        gl_Position = perspective * camera * transform * vec4(position, 1.0);
        vTexturePos = vec2 (position.x, position.y);
    }
|]


textureFragmentShader : Shader {} (TextureUniforms Uniforms) { vTexturePos : Vec2 }
textureFragmentShader =
    [glsl|

  precision mediump float;
  uniform float shade;
  uniform sampler2D texture;
  varying vec2 vTexturePos;
  void main () {
      gl_FragColor = shade * texture2D(texture, vTexturePos);
    }
  |]
