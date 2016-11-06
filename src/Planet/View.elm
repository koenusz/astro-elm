module Planet.View exposing (..)

import Html exposing (Html, div, text, button, i, Attribute, span, canvas)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, style, id, width, height)
import Html exposing (Html, div, text)
import Planet.Models exposing(PlanetModel)
import Planet.Messages exposing(Msg(..))






view : PlanetModel -> Html Msg
view model =
    div [class "planetview clearfix"]
        [
        div [class "col"]
            [contextMenu],
        div [class "col"]
            [canvas[id "myCanvas", width 200, height 100][]],
        button [ onClick Init ][ Html.text "Init"]
        ]




contextStyle : Attribute msg
contextStyle =
   style
    [
     ("max-width", "8rem")
    ]


contextMenu : Html Planet.Messages.Msg
contextMenu =
  div [ class "context-menu p1 overflow-hidden",
        contextStyle
      ]
    [
      button
        [class "btn regular"]
        [ Html.text "Designate"],
      button
        [class "btn regular"]
        [ Html.text "Construct"],
      button
        [class "btn regular"]
        [ Html.text "Space Port"]
    ]



planetBtn : Html Planet.Messages.Msg
planetBtn =
    button
        [ class "btn regular"
        , onClick ShowPlanet
        ]
        [ i [ class "fa mr1" ] [], Html.text "Planet" ]
