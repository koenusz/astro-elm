module Planet.View exposing (..)

import Html exposing (Html, div, text, button, i, Attribute, span, label)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, style)
import Planet.ColonyTypes exposing (..)
import Planet.Models exposing (..)
import Planet.Messages exposing (Msg(..))
import Planet.Grid
import Css exposing (marginLeft, maxWidth, position, height, padding)


styles =
    Css.asPairs >> Html.Attributes.style


view : PlanetModel -> Html Msg
view model =
    div
        [ class "planetview"
        , styles [ position Css.relative ]
        ]
        [ div
            [ styles
                [ position Css.absolute
                , maxWidth (Css.rem 8)
                , height (Css.pct 100)
                ]
            ]
            [ contextMenu ]
        , div
            [ class "content"
            , styles
                [ marginLeft (Css.rem 8)
                ]
            ]
            [ colonySymmary model
            , Html.map GridMsg (Planet.Grid.view model.gridModel)
            ]
          -- , button [ onClick Init ] [ Html.text "Init" ]
          -- , button [ onClick Tile ] [ Html.text "Tile" ]
        ]


contextMenu : Html Planet.Messages.Msg
contextMenu =
    div
        [ class "context-menu p1 overflow-hidden"
        , styles
            [ maxWidth (Css.rem 8)
            ]
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


colonySymmary : PlanetModel -> Html Planet.Messages.Msg
colonySymmary model =
    div
        [ styles
            [ height (Css.px 100)
            ]
        ]
        [ div
            [ class "colony-info border"
            , styles
                [ Css.margin (Css.px 1)
                , Css.padding (Css.px 3)
                , maxWidth (Css.rem 9)
                , position Css.absolute
                ]
            ]
            [ div
                []
                [ text ("Name  " ++ model.colony.name) ]
            , div
                []
                [ text ("Capital   " ++ (toString model.colony.colonyType)) ]
            ]
        , div
            [ class "population"
            , styles
                [ padding (Css.px 5)
                , marginLeft (Css.rem 9)
                ]
            ]
            [ div
                []
                [ text ("Population  " ++ (toString model.colony.population.popSize)) ]
            , div
                []
                [ text ("Operators   " ++ (toString model.colony.population.operators)) ]
            , div
                []
                [ text ("scientists  " ++ (toString model.colony.population.scientists)) ]
            ]
        ]


planetBtn : Html Planet.Messages.Msg
planetBtn =
    button
        [ class "btn regular"
        , onClick ShowPlanet
        ]
        [ i [ class "fa mr1" ] [], Html.text "Planet" ]
