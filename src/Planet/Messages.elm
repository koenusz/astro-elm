module Planet.Messages exposing (Msg(..))

import Planet.Types


type Msg
    = ShowPlanet
    | Init
    | Tile
    | GridMsg Planet.Types.Action
