module Planet.Types exposing (..)


type alias TerrainTile =
    { terrainType : TerrainType
    , specialisation : String
    }


type alias PlanetEntity =
    { surface : Surface
    , celestialBody : CelestialBody
    , position : Position
    }


type alias Surface =
    { planetSize : Size
    , tiles : List TerrainTile
    , selected : ( Int, Int )
    }


type alias CelestialBody =
    { name : String
    , cbtype : CelestialBodyType
    }


type alias Position =
    { x : Int
    , y : Int
    , angle : Float
    , radius : Float
    , orbiting : Int
    }


type CelestialBodyType
    = Star
    | Planet
    | Moon
    | Asteroid


type Size
    = One
    | Tiny
    | Small
    | Medium
    | Large
    | Huge


type Action
    = MouseClick ( Int, Int )
    | LoadTiles String
    | RequestTiles


type TerrainType
    = Arctic
    | Barren
    | Desert
    | Forest
    | Jungle
    | Mountains
    | Water


stringToCelestialBodyType : String -> CelestialBodyType
stringToCelestialBodyType input =
    case input of
        "Star" ->
            Star

        "Planet" ->
            Planet

        "Moon" ->
            Moon

        "Asteroid" ->
            Asteroid

        _ ->
            Debug.crash input


stringToSize : String -> Size
stringToSize input =
    case input of
        "One" ->
            One

        "Tiny" ->
            Tiny

        "Small" ->
            Small

        "Medium" ->
            Medium

        "Large" ->
            Large

        "Huge" ->
            Huge

        _ ->
            Debug.crash input


sizeTypeToInt : Size -> ( Int, Int )
sizeTypeToInt size =
    case size of
        One ->
            ( 1, 1 )

        Tiny ->
            ( 4, 3 )

        Small ->
            ( 5, 4 )

        Medium ->
            ( 6, 4 )

        Large ->
            ( 7, 6 )

        Huge ->
            ( 8, 7 )



--
--terrainString : TerrainType -> String
--terrainString ttype =
--    case ttype of
--        Arctic ->
--            "arctic"
--
--        Barren ->
--            "barren"
--
--        Desert ->
--            "desert"
--
--        Forest ->
--            "forest"
--
--        Jungle ->
--            "jungle"
--
--        Mountains ->
--            "mountains"
--
--        Water ->
--            "water"


stringToTerrain : String -> TerrainType
stringToTerrain string =
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
