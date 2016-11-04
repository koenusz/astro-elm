module Fleet.View exposing (..)

import Html exposing (Html, div, text, button, i)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Html exposing (Html, div, text)
import Fleet.Models exposing(FleetModel)
import Fleet.Messages exposing(Msg(..))


view : FleetModel -> Html Msg
view model =
    div []
        [ text model ]

fleetBtn : Html Fleet.Messages.Msg
fleetBtn =
    button
        [ class "btn regular"
        , onClick ShowFleet
        ]
        [ i [ class "fa mr1" ] [], text "Fleet" ]
