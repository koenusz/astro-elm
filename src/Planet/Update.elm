module Planet.Update exposing (update)

import Planet.Messages exposing (Msg(..))
import Planet.Models exposing (PlanetModel)
import Navigation

update : Msg -> PlanetModel -> ( PlanetModel, Cmd Msg )
update msg model =
    case msg of
        ShowPlanet ->
            ( model, Navigation.newUrl("#planet"))
