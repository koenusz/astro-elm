module Planet.Grid exposing (..)

import Html exposing (Html)
import Html.Attributes
import Html.Events
import List
import WebSocket
import Planet.Codec exposing (decodePlanet, tileRequest)
import Planet.Types exposing (..)


tileWidth : Int
tileWidth =
    100


echoServer : String
echoServer =
    -- "ws://echo.websocket.org"
    "ws://127.0.0.1:8080/websocket"


tileHeight : Int
tileHeight =
    100


getTerrain : Model -> ( Int, Int ) -> TerrainType
getTerrain model position =
    let
        tile =
            List.head (List.filter (\t -> t.position == position) model.tiles)
    in
        case tile of
            Nothing ->
                Debug.crash "no tile"

            Just tile ->
                tile.ttype


emptyModel : Model
emptyModel =
    { planets = [] }


init : ( Model, Cmd Action )
init =
    ( { planets =
            [ { planetSize = Tiny
              , tiles =
                    [ { terrainType = Arctic, specialisation = "None" }
                    , { terrainType = Arctic, specialisation = "None" }
                    , { terrainType = Barren, specialisation = "None" }
                    , { terrainType = Desert, specialisation = "None" }
                    , { terrainType = Forest, specialisation = "None" }
                    , { terrainType = Jungle, specialisation = "None" }
                    , { terrainType = Mountains, specialisation = "None" }
                    , { terrainType = Water, specialisation = "None" }
                    , { terrainType = Arctic, specialisation = "None" }
                    , { terrainType = Arctic, specialisation = "None" }
                    , { terrainType = Arctic, specialisation = "None" }
                    , { terrainType = Arctic, specialisation = "None" }
                    ]
              , selected = ( 0, 0 )
              }
            ]
      }
    , Cmd.none
    )


renderTile : Model -> ( Int, Int ) -> Html Action
renderTile model position =
    let
        color =
            if model.selected == position then
                "red"
            else
                "yellow"

        terrain =
            toString (getTerrain model position)
    in
        Html.img
            [ Html.Attributes.src ("resources/terrain/" ++ terrain ++ ".png")
            , Html.Attributes.width tileWidth
            , Html.Events.onClick (MouseClick position)
            , Html.Attributes.style
                [ ( "position", "absolute" )
                , ( "left", (toString <| Tuple.first position * tileWidth) ++ "px" )
                , ( "top", (toString <| Tuple.second position * tileHeight) ++ "px" )
                , ( "outline-style", "solid" )
                , ( "outline-color", color )
                , ( "outline-offset", "-3px" )
                ]
            ]
            []


type alias Options =
    { preventDefault : Bool, stopPropagation : Bool }


renderRow : Model -> Int -> Html Action
renderRow model y =
    List.range 0 (Tuple.second model.planetSize - 1)
        |> List.map (\x -> renderTile model ( x, y ))
        |> Html.div
            []


view : Model -> Html Action
view model =
    Html.div []
        [ Html.button [ Html.Events.onClick RequestTiles ] [ Html.text "click me" ]
        , List.range 0 (Tuple.first model.planetSize - 1)
            |> List.map (\y -> renderRow model y)
            |> Html.div
                [ Html.Attributes.style
                    [ ( "position", "relative" )
                    , ( "width", "100vw" )
                    , ( "height", "100vh" )
                    ]
                ]
        ]


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        MouseClick position ->
            Debug.log "position"
                ( { model | selected = position }, Cmd.none )

        LoadTiles json ->
            case decodePlanet of
                Result.Ok planet ->
                    Debug.log "planet"
                        ( planet, Cmd.none )

                Result.Err message ->
                    Debug.log ("Grid.elm 227 " ++ message)
                        ( emptyModel, Cmd.none )

        RequestTiles ->
            ( model, WebSocket.send echoServer (tileRequest "1") )


subscriptions : Model -> Sub Action
subscriptions _ =
    WebSocket.listen echoServer LoadTiles
