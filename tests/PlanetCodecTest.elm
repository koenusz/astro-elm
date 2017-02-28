module PlanetCodecTest exposing (..)

import Test exposing (..)
import Planet.Codec exposing (..)
import Json.Decode exposing (decodeString)
import Expect
import Dict
import Planet.Types


-- import Expect
-- import Fuzz exposing (list, int, tuple, string)
-- import String


planetCodecTest : Test
planetCodecTest =
    describe "Testing the codec of the planet functionality"
        [ decodeTerrainTileTest
        , decodeSurfaceTest
        , decodeCelestialBodyTest
        , decodePositionTest
        , decodePlanetTest
        , responseDecoderTest
        ]


responseDecoderTest : Test
responseDecoderTest =
    test "Response" <|
        \() ->
            let
                input =
                    """
{
  "entities" : {
    "1" : {
      "Position" : {
        "x" : 0,
        "y" : 0,
        "angle" : 0,
        "radius" : 10,
        "orbiting" : 0
      },
      "Surface" : {
        "size" : "Small",
        "terrainTiles" : [{
            "terrainType" : "Forest",
            "specialisation" : "Research"
          }, {
            "terrainType" : "Forest",
            "specialisation" : "None"
          }, {
            "terrainType" : "Forest",
            "specialisation" : "None"
          }
        ]
      },
      "CelestialBody" : {
        "name" : "planet_Forest_0",
        "type" : "Planet"
      },
      "Subscription" : {
        "updateFrontend" : false
      }
    }
  }
}
                """

                decodedOutput =
                    decodeString
                        responseDecoder
                        input
            in
                Expect.equal decodedOutput
                    (Ok
                        { entities =
                            Dict.fromList
                                [ ( "1"
                                  , Planet.Types.PlanetRecord
                                        ({ surface =
                                            { planetSize = Planet.Types.Small
                                            , tiles =
                                                [ { terrainType = Planet.Types.Forest
                                                  , specialisation = "Research"
                                                  }
                                                , { terrainType = Planet.Types.Forest
                                                  , specialisation = "None"
                                                  }
                                                , { terrainType = Planet.Types.Forest
                                                  , specialisation = "None"
                                                  }
                                                ]
                                            , selected = ( 0, 0 )
                                            }
                                         , celestialBody =
                                            { name = "planet_Forest_0"
                                            , cbtype = Planet.Types.Planet
                                            }
                                         , position =
                                            { x = 0
                                            , y = 0
                                            , angle = 0
                                            , radius = 10
                                            , orbiting = 0
                                            }
                                         }
                                        )
                                  )
                                ]
                        }
                    )


decodePlanetTest : Test
decodePlanetTest =
    test "Planet" <|
        \() ->
            let
                input =
                    """
{
      "Position" : {
        "x" : 0,
        "y" : 0,
        "angle" : 0,
        "radius" : 10,
        "orbiting" : 0
      },
      "Surface" : {
        "size" : "Small",
        "terrainTiles" : [{
            "terrainType" : "Forest",
            "specialisation" : "Research"
          }, {
            "terrainType" : "Forest",
            "specialisation" : "None"
          }, {
            "terrainType" : "Forest",
            "specialisation" : "None"
          }
        ]
      },
      "CelestialBody" : {
        "name" : "planet_Forest_0",
        "type" : "Planet"
      },
      "Subscription" : {
        "updateFrontend" : false
      }
    }
              """

                decodedOutput =
                    decodeString
                        planetDecoder
                        input
            in
                Expect.equal decodedOutput
                    (Ok
                        { surface =
                            { planetSize = Planet.Types.Small
                            , tiles =
                                [ { terrainType = Planet.Types.Forest
                                  , specialisation = "Research"
                                  }
                                , { terrainType = Planet.Types.Forest
                                  , specialisation = "None"
                                  }
                                , { terrainType = Planet.Types.Forest
                                  , specialisation = "None"
                                  }
                                ]
                            , selected = ( 0, 0 )
                            }
                        , celestialBody =
                            { name = "planet_Forest_0"
                            , cbtype = Planet.Types.Planet
                            }
                        , position =
                            { x = 0
                            , y = 0
                            , angle = 0
                            , radius = 10
                            , orbiting = 0
                            }
                        }
                    )


decodePositionTest : Test
decodePositionTest =
    test "decodePositionTest" <|
        \() ->
            let
                input =
                    """
      {
        "x" : 0,
        "y" : 0,
        "angle" : 0,
        "radius" : 10,
        "orbiting" : 0
      }
              """

                decodedOutput =
                    decodeString
                        positionDecoder
                        input
            in
                Expect.equal decodedOutput
                    (Ok
                        { x = 0
                        , y = 0
                        , angle = 0
                        , radius = 10
                        , orbiting = 0
                        }
                    )


decodeCelestialBodyTest : Test
decodeCelestialBodyTest =
    test "decodeCelestialBodyTest" <|
        \() ->
            let
                input =
                    """
                {
                  "name" : "planet_Forest_0",
                  "type" : "Planet"
                }
              """

                decodedOutput =
                    decodeString
                        celestialBodyDecoder
                        input
            in
                Expect.equal decodedOutput
                    (Ok
                        { name = "planet_Forest_0"
                        , cbtype = Planet.Types.Planet
                        }
                    )


decodeTerrainTileTest : Test
decodeTerrainTileTest =
    test "terrainTile" <|
        \() ->
            let
                input =
                    """
                { "terrainType" : "Forest",
                  "specialisation" : "Research"
                }
              """

                decodedOutput =
                    decodeString
                        terraintileDecoder
                        input
            in
                Expect.equal decodedOutput
                    (Ok
                        { terrainType = Planet.Types.Forest
                        , specialisation = "Research"
                        }
                    )


decodeSurfaceTest : Test
decodeSurfaceTest =
    test "surface" <|
        \() ->
            let
                input =
                    """
                {
                  "size" : "Small",
                  "terrainTiles" : [{
                      "terrainType" : "Forest",
                      "specialisation" : "Research"
                    }, {
                      "terrainType" : "Forest",
                      "specialisation" : "None"
                    }, {
                      "terrainType" : "Forest",
                      "specialisation" : "None"
                    }
                  ]
                }
                """

                decodedOutput =
                    Json.Decode.decodeString
                        surfaceDecoder
                        input
            in
                Expect.equal decodedOutput
                    (Ok
                        { planetSize = Planet.Types.Small
                        , tiles =
                            [ { terrainType = Planet.Types.Forest
                              , specialisation = "Research"
                              }
                            , { terrainType = Planet.Types.Forest
                              , specialisation = "None"
                              }
                            , { terrainType = Planet.Types.Forest
                              , specialisation = "None"
                              }
                            ]
                        , selected = ( 0, 0 )
                        }
                    )
