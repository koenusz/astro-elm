module Planet.Codec exposing (..)

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, hardcoded)
import Json.Encode exposing (encode, object)
import Planet.Types exposing (..)


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


responseDecoder : Decoder PlanetResponse
responseDecoder =
    decode PlanetResponse
        |> required "entities" (dict entityDecoder)


entityDecoder : Decoder Entity
entityDecoder =
    map PlanetRecord planetDecoder


planetDecoder : Decoder PlanetEntity
planetDecoder =
    decode PlanetEntity
        |> required "Surface" surfaceDecoder
        |> required "CelestialBody" celestialBodyDecoder
        |> required "Position" positionDecoder


celestialBodyDecoder : Decoder CelestialBody
celestialBodyDecoder =
    decode CelestialBody
        |> required "name" string
        |> required "type" celestialBodyTypeDecoder


positionDecoder : Decoder Position
positionDecoder =
    decode Position
        |> required "x" int
        |> required "y" int
        |> required "angle" float
        |> required "radius" float
        |> required "orbiting" int


surfaceDecoder : Decoder Surface
surfaceDecoder =
    decode Surface
        |> required "size" sizeDecoder
        |> required "terrainTiles" (list terraintileDecoder)
        |> hardcoded ( 0, 0 )


terraintileDecoder : Decoder TerrainTile
terraintileDecoder =
    decode TerrainTile
        |> required "terrainType" terrainTypeDecoder
        |> required "specialisation" string



-- encodeTerrainTile : TerrainTile -> Json.Encode.Value
-- encodeTerrainTile tile =
--     Json.Encode.object
--         [ ( "terrainType", string <| tile.terrainType )
--         , ( "specialisation", string <| tile.specialisation )
--         ]


terrainTypeDecoder : Decoder TerrainType
terrainTypeDecoder =
    map stringToTerrain string


sizeDecoder : Decoder Size
sizeDecoder =
    map stringToSize string


celestialBodyTypeDecoder : Decoder CelestialBodyType
celestialBodyTypeDecoder =
    map stringToCelestialBodyType string
