module Planet.Models exposing (PlanetModel, init)

import Planet.ColonyTypes exposing (..)
import Planet.Grid


type alias PlanetModel =
    { colony : Colony
    , storage : Storage
    , minerals : List Mineral
    , gridModel : Planet.Grid.Model
    }


type alias Mineral =
    { name : String
    , amount : Int
    }


init : PlanetModel
init =
    { colony = Planet.ColonyTypes.init
    , storage = []
    , minerals = []
    , gridModel = Tuple.first Planet.Grid.init
    }
