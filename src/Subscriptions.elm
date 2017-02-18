module Subscriptions exposing (subscriptions)

import Models exposing (AppModel)
import Messages exposing (Msg(..))
import Planet.Subscriptions
import Simulator.Simulator


subscriptions : AppModel -> Sub Messages.Msg
subscriptions model =
    Sub.batch
        [ Sub.map PlanetMsg (Planet.Subscriptions.subscriptions model.planetModel)
        , Sub.map SimulatorMsg (Simulator.Simulator.subscriptions model.simulatorModel)
        ]
