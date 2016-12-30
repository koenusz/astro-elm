module Planet.View exposing (..)

import Html exposing (Html, div, text, button, i, Attribute, span, canvas)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, style, id, width, height)
import Html exposing (Html, div, text)
import Planet.Models exposing (PlanetModel)
import Planet.Messages exposing (Msg(..))
import Planet.Grid


view : PlanetModel -> Html Msg
view model =
    div [ class "planetview clearfix" ]
        [ div [ class "col" ]
            [ contextMenu ]
        , div [ class "col" ]
            [ Html.map GridMsg (Planet.Grid.view model.gridModel) ]
        , button [ onClick Init ] [ Html.text "Init" ]
        , button [ onClick Tile ] [ Html.text "Tile" ]
        ]


contextStyle : Attribute msg
contextStyle =
    style
        [ ( "max-width", "8rem" )
        ]


contextMenu : Html Planet.Messages.Msg
contextMenu =
    div
        [ class "context-menu p1 overflow-hidden"
        , contextStyle
        ]
        [ button
            [ class "btn regular" ]
            [ Html.text "Designate" ]
        , button
            [ class "btn regular" ]
            [ Html.text "Construct" ]
        , button
            [ class "btn regular" ]
            [ Html.text "Space Port" ]
        ]


planetBtn : Html Planet.Messages.Msg
planetBtn =
    button
        [ class "btn regular"
        , onClick ShowPlanet
        ]
        [ i [ class "fa mr1" ] [], Html.text "Planet" ]
