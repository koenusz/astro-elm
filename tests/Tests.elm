module Tests exposing (..)

import Test exposing (..)
import PlanetCodecTest exposing (planetCodecTest)


all : Test
all =
    describe "Astro Test Suite"
        [ describe "Unit test examples"
            [ planetCodecTest ]
        ]
