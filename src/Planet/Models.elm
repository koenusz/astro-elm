module Planet.Models exposing (PlanetModel, init)

type Size
  = Tiny   --4x3
  | Small  --5x4
  | Medium --6x5
  | Large  --7x6
  | Huge   --8x7

type Biome
  = Ocean
  | Barren
  | Arctic
  | Plains
  | Desert
  | Tundra
  | TemperateForest
  | TropicalForest
  | Space

type Designation
  = SpaceElevator
  | Empty
  | Research
  | Refinery
  | Mining
  | Housing
  | Logistics
  | SpacePort
  | MassDriver
  | Warf
  | Hangar

type alias Installation =
  { name : String
  , amount : Int
  }


type alias District =
  { id : Int
  , biome : Biome
  , designation : Designation
  , installations : List Installation
  }

initDistrict : District
initDistrict =
    { id = 0
    , biome = Plains
    , designation = Empty
    , installations = []
    }

type alias StoredItem =
  { itemName : String
  , amount : Int
  }

type alias Mineral  = { name : String
                      , amount : Int
                      }

type alias PlanetModel =
  { district : District
  , storage : List StoredItem
  , minerals : List Mineral
  }


init : (PlanetModel)
init =
  {district = initDistrict
  , storage = []
  , minerals = []
  }
