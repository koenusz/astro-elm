module Messages exposing (..)

import Simulator.Simulator as Simulator
import Solar.Messages as Solar
import Planet.Messages as Planet
import Research.Messages as Research
import Fleet.Messages as Fleet
import Navigation exposing (Location)


type Msg
    = SimulatorMsg Simulator.Msg
    | SolarMsg Solar.Msg
    | PlanetMsg Planet.Msg
    | ResearchMsg Research.Msg
    | FleetMsg Fleet.Msg
    | OnLocationChange Location
