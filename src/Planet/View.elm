module Planet.View exposing (..)

import Html exposing (Html, div, text, button, i)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Html exposing (Html, div, text)
import Planet.Models exposing(PlanetModel)
import Planet.Messages exposing(Msg(..))


view : PlanetModel -> Html Msg
view model =
    div []
        [ text model ]

planetBtn : Html Planet.Messages.Msg
planetBtn =
    button
        [ class "btn regular"
        , onClick ShowPlanet
        ]
        [ i [ class "fa mr1" ] [], text "Planet" ]
