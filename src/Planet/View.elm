module Planet.View exposing (..)

import Html exposing (Html, div, text, button, i, Attribute, span, label)
import Html.Events exposing (onClick)
import Html.Attributes
import Html.CssHelpers
import Css.PlanetCss


-- import Planet.ColonyTypes exposing (..)

import Planet.Models exposing (..)
import Planet.Messages exposing (Msg(..))
import Planet.Grid
import Css exposing (marginLeft, maxWidth, position, height, padding)


{ id, class, classList } =
    Html.CssHelpers.withNamespace "planet"


styles : List Css.Mixin -> Attribute Msg
styles =
    Css.asPairs >> Html.Attributes.style


view : PlanetModel -> Html Msg
view model =
    div
        [ Html.Attributes.class "planetview"
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
            [ Html.Attributes.class "content"
            , styles
                [ marginLeft (Css.rem 8)
                ]
            ]
            [ colonySymmary model
            , grid 4
                3
                [ [ ( "test1", "value" )
                  , ( "test2 long one", "value 2" )
                  , ( "test3", "value" )
                  ]
                , [ ( "col 2", "value" ) ]
                , [ ( "col 3", "value" )
                  , ( "col 3", "value" )
                  , ( "col 3", "value" )
                  ]
                ]
            , Html.map GridMsg (Planet.Grid.view model.gridModel)
            ]
          -- , button [ onClick Init ] [ Html.text "Init" ]
          -- , button [ onClick Tile ] [ Html.text "Tile" ]
        ]


grid : Int -> Int -> List (List ( String, String )) -> Html Planet.Messages.Msg
grid x y columns =
    let
        column : List ( String, String ) -> Html Planet.Messages.Msg
        column list =
            div
                [ Html.Attributes.class "column"
                , styles
                    [ Css.height (Css.em (toFloat y * 1.5))
                    , Css.float Css.left
                    , Css.width (Css.pct (100 / toFloat x))
                    ]
                ]
                (List.map
                    (\keyValue ->
                        cell x (Tuple.first keyValue) (Tuple.second keyValue)
                    )
                    list
                )
    in
        div
            [ Html.Attributes.class "key-value-grid"
            , styles
                [ position Css.relative
                , Css.overflow Css.auto
                , Css.overflowY Css.hidden
                ]
            ]
            (List.map column columns)


cell : Int -> String -> String -> Html Planet.Messages.Msg
cell x key value =
    div
        [ Html.Attributes.class ("cell ")
        , styles
            [ Css.maxHeight (Css.em 1)
            ]
        ]
        [ div
            [ class [ Css.PlanetCss.Key ]
            ]
            [ text (key) ]
        , div
            [ Html.Attributes.class "value"
            , styles
                [ Css.float Css.right
                , Css.width (Css.pct 50)
                , Css.maxHeight (Css.em 1)
                , Css.whiteSpace Css.noWrap
                ]
            ]
            [ text (value) ]
        ]


contextMenu : Html Planet.Messages.Msg
contextMenu =
    div
        [ Html.Attributes.class "context-menu p1 overflow-hidden"
        , styles
            [ maxWidth (Css.rem 8)
            ]
        ]
        [ button
            [ Html.Attributes.class "btn regular" ]
            [ Html.text "Designate" ]
        , button
            [ Html.Attributes.class "btn regular" ]
            [ Html.text "Construct" ]
        , button
            [ Html.Attributes.class "btn regular" ]
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
            [ Html.Attributes.class "colony-info border"
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
            [ Html.Attributes.class "population"
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
        [ Html.Attributes.class "btn regular"
        , onClick ShowPlanet
        ]
        [ i [ Html.Attributes.class "fa mr1" ] [], Html.text "Planet" ]
