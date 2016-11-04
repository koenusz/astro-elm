module Routing exposing (..)

import String
import Navigation
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
        [ format SolarRoute (s "")
        , format SolarRoute (s "solar")
        , format PlanetRoute (s "planet")
        , format ResearchRoute (s "research")
        , format FleetRoute (s "fleet")
        ]

hashParser : Navigation.Location -> Result String Route
hashParser location =
    location.hash
        |> String.dropLeft 1
        |> parse identity matchers

parser : Navigation.Parser (Result String Route)
parser =
    Navigation.makeParser hashParser

routeFromResult : Result String Route -> Route
routeFromResult result =
    case result of
        Ok route ->
            route

        Err string ->
            NotFoundRoute
