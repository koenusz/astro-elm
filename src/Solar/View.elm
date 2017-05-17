module Solar.View exposing (..)

import Html exposing (Html, div, text, button, i, input, hr)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (class, value, type_, width, height, style)
import Solar.Models exposing (Model)
import Solar.Messages exposing (Msg(..))
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Solar.Starsystem exposing (uniforms, spaceObjectLocation)
import Solar.SceneGraph as SceneGraph
import Solar.Starsystem as Starsystem exposing (viewToClipspace, width_, height_)
import WebGL
import Json.Decode


view : Model -> Html Msg
view model =
    starsystem model


solarBtn : Html Solar.Messages.Msg
solarBtn =
    button
        [ class "btn regular"
        , onClick ShowSolar
        ]
        [ i [ class "fa mr1" ] [], text "Solar" ]


starsystem : Model -> Html Msg
starsystem model =
    let
        mouseX =
            Vec3.getX model.mouse

        mouseY =
            Vec3.getY model.mouse

        translation =
            Mat4.makeTranslate (vec3 1 0 0)

        defaultuniforms =
            (uniforms model False Mat4.identity)

        spaceObjects =
            List.concatMap
                (SceneGraph.walk (spaceObjectLocation model))
                model.starsystem.stars
    in
        div []
            [ div
                []
                [ div []
                    [ button [] [ text "zoom" ]
                    , input [ type_ "number", value (toString model.zoom), onInput SetZoom ] []
                    ]
                , div []
                    [ button [] [ text "rotate" ]
                    , input [ type_ "number", value (toString model.rotate), onInput SetRotate ] []
                    ]
                , div []
                    [ button [] [ text "translate" ]
                    , input [ type_ "number", value (toString model.translateX), onInput SetTranslateX ] []
                    , input [ type_ "number", value (toString model.translateY), onInput SetTranslateY ] []
                    ]
                , div []
                    [ button [ Html.Events.onClick (Tick 200) ] [ text "tick" ]
                    ]
                , div []
                    [ text ("mouse " ++ toString model.mouse)
                    , text ("clipspace " ++ toString (viewToClipspace (vec3 mouseX mouseY 0)))
                    ]
                  --, div []
                  --    spaceObjects
                ]
            , WebGL.toHtml
                [ width width_
                , height height_
                , Html.Events.on "click" (Json.Decode.map MouseClick Starsystem.offsetPosition)
                , style
                    [ ( "display", "block" )
                    , ( "margin-left", "50px" )
                    , ( "background-color", "#ccccff" )
                    ]
                ]
                (Starsystem.prepareScene model)
            ]
