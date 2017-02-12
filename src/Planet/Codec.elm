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


decodePlanet : Decoder PlanetEntity
decodePlanet =
    decode PlanetEntity
        |> required "Surface" decodeSurface
        |> required "CelestialBody" decodeCelestialBody
        |> required "Position" decodePosition


decodeCelestialBody : Decoder CelestialBody
decodeCelestialBody =
    decode CelestialBody
        |> required "name" string
        |> required "type" celestialBodyTypeDecoder


decodePosition : Decoder Position
decodePosition =
    decode Position
        |> required "x" int
        |> required "y" int
        |> required "angle" float
        |> required "radius" float
        |> required "orbiting" int


decodeSurface : Decoder Surface
decodeSurface =
    decode Surface
        |> required "size" sizeDecoder
        |> required "terrainTiles" (list decodeTerrainTile)
        |> hardcoded ( 0, 0 )


decodeTerrainTile : Decoder TerrainTile
decodeTerrainTile =
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
