module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)


type Route
    = SolarRoute
    | PlanetRoute
    | ResearchRoute
    | FleetRoute
    | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map SolarRoute (s "")
        , map SolarRoute (s "solar")
        , map PlanetRoute (s "planet")
        , map ResearchRoute (s "research")
        , map FleetRoute (s "fleet")
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
