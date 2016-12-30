module Planet.Messages exposing (Msg(..))

import Planet.Grid


type Msg
    = ShowPlanet
    | Init
    | Tile
    | GridMsg Planet.Grid.Action
