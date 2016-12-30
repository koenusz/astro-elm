module Subscriptions exposing (subscriptions)

import Models exposing (AppModel)
import Messages exposing (Msg(..))
import Planet.Subscriptions


subscriptions : AppModel -> Sub Messages.Msg
subscriptions model =
    Sub.map PlanetMsg (Planet.Subscriptions.subscriptions model.planetModel)
