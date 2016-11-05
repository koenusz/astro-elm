module Planet.View exposing (..)

import Html exposing (Html, div, text, button, i, Attribute)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, style)
import Html exposing (Html, div, text)
import Planet.Models exposing(PlanetModel)
import Planet.Messages exposing(Msg(..))


view : PlanetModel -> Html Msg
view model =
    div [class "planetview"]
        [
        div []
          [contextMenu],
        div []
            []

        ]

contextStyle : Attribute msg
contextStyle =
   style
    [
     ("max-width", "8rem")
    ]


contextMenu : Html Planet.Messages.Msg
contextMenu =
  div [ class "context-menu p1",
        contextStyle
      ]
    [
      button
        [class "btn regular"]
        [ text "Designate"],
      button
        [class "btn regular"]
        [ text "Construct"],
      button
        [class "btn regular"]
        [ text "Space Port"]
    ]



planetBtn : Html Planet.Messages.Msg
planetBtn =
    button
        [ class "btn regular"
        , onClick ShowPlanet
        ]
        [ i [ class "fa mr1" ] [], text "Planet" ]
