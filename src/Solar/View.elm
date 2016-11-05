module Solar.View exposing (..)


import Html exposing (Html, div, text, button, i)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Solar.Models exposing(SolarModel)
import Solar.Messages exposing(Msg(..))


view : SolarModel -> Html Msg
view model =
    div []
        [ text model ]

solarBtn : Html Solar.Messages.Msg
solarBtn =
    button
        [ class "btn regular"
        , onClick ShowSolar
        ]
        [ i [ class "fa mr1" ] [], text "Solar" ]