module Planet.Grid exposing (..)

import Html exposing (Html)
import Html.Attributes
import Html.Events
import List
import WebSocket
import Json.Decode exposing (int, string, float, Decoder, field, map2, andThen, list, decodeString)
import Json.Decode.Pipeline exposing (decode, required, hardcoded)
import Json.Encode exposing (encode, object)


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


type Action
    = MouseClick ( Int, Int )
    | LoadTiles String
    | RequestTiles



-- | BackendMsg Backend.Msg


type TerrainType
    = Arctic
    | Barren
    | Desert
    | Forest
    | Jungle
    | Mountains
    | Water


terrainString : TerrainType -> String
terrainString ttype =
    case ttype of
        Arctic ->
            "arctic"

        Barren ->
            "barren"

        Desert ->
            "desert"

        Forest ->
            "forest"

        Jungle ->
            "jungle"

        Mountains ->
            "mountains"

        Water ->
            "water"


stringTerrain : String -> TerrainType
stringTerrain string =
    case string of
        "Arctic" ->
            Arctic

        "Barren" ->
            Barren

        "Desert" ->
            Desert

        "Forest" ->
            Forest

        "Jungle" ->
            Jungle

        "Mountains" ->
            Mountains

        "Water" ->
            Water

        _ ->
            Debug.crash string


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


type alias Tile =
    { position : ( Int, Int )
    , ttype : TerrainType
    }


type alias Model =
    { planetSize : ( Int, Int )
    , tiles : List Tile
    , selected : ( Int, Int )
    }


init : ( Model, Cmd Action )
init =
    ( { planetSize = ( 3, 3 )
      , tiles =
            [ { position = ( 0, 0 ), ttype = Arctic }
            , { position = ( 1, 0 ), ttype = Arctic }
            , { position = ( 2, 0 ), ttype = Barren }
            , { position = ( 0, 1 ), ttype = Desert }
            , { position = ( 1, 1 ), ttype = Forest }
            , { position = ( 2, 1 ), ttype = Jungle }
            , { position = ( 0, 2 ), ttype = Mountains }
            , { position = ( 1, 2 ), ttype = Water }
            , { position = ( 2, 2 ), ttype = Arctic }
            ]
      , selected = ( 0, 0 )
      }
    , Cmd.none
    )


emptyPlanet : Model
emptyPlanet =
    { planetSize = ( 0, 0 )
    , tiles = []
    , selected = ( 0, 0 )
    }


renderTile : Model -> ( Int, Int ) -> Html Action
renderTile model position =
    let
        color =
            if model.selected == position then
                "red"
            else
                "yellow"

        terrain =
            terrainString (getTerrain model position)
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

        LoadTiles newModel ->
            case decodeString decodePlanet newModel of
                Result.Ok planet ->
                    Debug.log "planet"
                        ( planet, Cmd.none )

                Result.Err message ->
                    Debug.log ("Grid.elm 227 " ++ message)
                        ( emptyPlanet, Cmd.none )

        RequestTiles ->
            ( model, WebSocket.send echoServer (tileRequest "1") )


tileRequest : String -> String
tileRequest planet =
    let
        data =
            object
                [ ( "entityType", Json.Encode.string "planet" )
                , ( "components", Json.Encode.list [ Json.Encode.string "surface" ] )
                , ( "entityId", Json.Encode.string planet )
                ]
    in
        object
            [ ( "type", Json.Encode.string "datarequest" )
            , ( "data", data )
            ]
            |> encode 0


decodePlanet : Decoder Model
decodePlanet =
    let
        coordinates =
            decode (,)
                |> required "x" int
                |> required "y" int
    in
        decode Model
            |> required "size" coordinates
            |> required "tiles" (list tileDecoder)
            |> hardcoded ( 0, 0 )


tileDecoder : Decoder Tile
tileDecoder =
    let
        coordinates =
            decode (,)
                |> required "x" int
                |> required "y" int
    in
        decode Tile
            |> required "position" coordinates
            |> required "type" (andThen terrainTypeDecoder string)


terrainTypeDecoder : String -> Decoder TerrainType
terrainTypeDecoder ttype =
    decode (stringTerrain ttype)


subscriptions : Model -> Sub Action
subscriptions _ =
    WebSocket.listen echoServer LoadTiles
