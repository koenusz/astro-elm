module Models exposing (..)

import Routing
import Simulator.Simulator exposing (Simulator)
import Solar.Models
import Planet.Models
import Research.Models
import Fleet.Models


type alias AppModel =
    { simulatorModel : Simulator
    , solarModel : Solar.Models.Model
    , planetModel : Planet.Models.PlanetModel
    , researchModel : Research.Models.ResearchModel
    , fleetModel : Fleet.Models.FleetModel
    , route : Routing.Route
    }


initialModel : Routing.Route -> AppModel
initialModel route =
    { simulatorModel = Simulator.Simulator.initSimModel
    , solarModel = Solar.Models.init
    , planetModel = Planet.Models.init
    , researchModel = Research.Models.init
    , fleetModel = Fleet.Models.init
    , route = route
    }
