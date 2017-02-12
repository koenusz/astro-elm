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


type alias Model =
    { planet : PlanetEntity
    }


emptyModel : Model
emptyModel =
    { planet =
        { surface =
            { planetSize = One
            , tiles = []
            , selected = ( 0, 0 )
            }
        , celestialBody =
            { name = ""
            , cbtype = Asteroid
            }
        , position = { x = 0, y = 0, angle = 0, radius = 0, orbiting = -1 }
        }
    }


init : ( Model, Cmd Action )
init =
    ( { planet =
            { surface =
                { planetSize = Tiny
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
            , celestialBody =
                { name = "init"
                , cbtype = Planet
                }
            , position = { x = 0, y = 0, angle = 0, radius = 0, orbiting = -1 }
            }
      }
    , Cmd.none
    )



-- getTerrain : Model -> ( Int, Int ) -> TerrainType
-- getTerrain model position =
--     let
--         tile =
--             List.head (List.filter (\t -> t.position == position) model.planet.surface.tiles)
--     in
--         case tile of
--             Nothing ->
--                 Debug.crash "no tile"
--
--             Just tile ->
--                 tile.ttype


type alias Options =
    { preventDefault : Bool, stopPropagation : Bool }


coordinatesFromIndex : Int -> Size -> ( Int, Int )
coordinatesFromIndex index surfaceSize =
    let
        intSize =
            sizeTypeToInt surfaceSize
    in
        ( rem index (Tuple.first intSize), index // (Tuple.second intSize) )


renderTiles : Surface -> Html Action
renderTiles surface =
    let
        tiles =
            surface.tiles
    in
        Html.div [] (List.indexedMap (\i tile -> renderTile tile surface.planetSize surface.selected i) tiles)


renderTile : TerrainTile -> Size -> ( Int, Int ) -> Int -> Html Action
renderTile tile planetSize selected index =
    let
        position =
            coordinatesFromIndex index planetSize

        color =
            if selected == position then
                "red"
            else
                "yellow"

        terrain =
            toString tile.terrainType
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



-- renderRow : Model -> Int -> Html Action
-- renderRow model y =
--     List.range 0 (Tuple.second (sizeTypeToInt model.planet.surface.planetSize) - 1)
--         |> List.map  (\x -> renderTile model.planet.surface.tiles.map model.selected == ( x, y ))
--         |> Html.div
--             []


view : Model -> Html Action
view model =
    Html.div []
        [ Html.button [ Html.Events.onClick RequestTiles ] [ Html.text "click me" ]
        , renderTiles model.planet.surface
          -- , List.range 0 (Tuple.first (sizeTypeToInt model.planet.surface.planetSize) - 1)
          --     |> List.map (\y -> renderRow model y)
          --     |> Html.div
          --         [ Html.Attributes.style
          --             [ ( "position", "relative" )
          --             , ( "width", "100vw" )
          --             , ( "height", "100vh" )
          --             ]
          --         ]
        ]


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        MouseClick position ->
            let
                planet =
                    model.planet

                surface =
                    model.planet.surface
            in
                Debug.log "position"
                    ( { model | planet = { planet | surface = { surface | selected = position } } }, Cmd.none )

        LoadTiles json ->
            case decodePlanet json of
                Result.Ok updatedplanet ->
                    Debug.log "planet"
                        ( { model | planet = updatedplanet }, Cmd.none )

                Result.Err message ->
                    Debug.log ("Grid.elm 227 " ++ message)
                        ( emptyModel, Cmd.none )

        RequestTiles ->
            ( model, WebSocket.send echoServer (tileRequest "1") )


subscriptions : Model -> Sub Action
subscriptions _ =
    WebSocket.listen echoServer LoadTiles
