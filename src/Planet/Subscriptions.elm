module Planet.Subscriptions exposing (subscriptions)

import Planet.Models exposing (PlanetModel)
import Planet.Messages exposing (Msg(..))
import Planet.Grid exposing (subscriptions)


subscriptions : PlanetModel -> Sub Planet.Messages.Msg
subscriptions model =
    Sub.map GridMsg (Planet.Grid.subscriptions model.gridModel)
