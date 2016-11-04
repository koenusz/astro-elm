module Fleet.Update exposing (update)

import Fleet.Messages exposing (Msg(..))
import Fleet.Models exposing (FleetModel)
import Navigation

update : Msg -> FleetModel -> ( FleetModel, Cmd Msg )
update msg model =
    case msg of
        ShowFleet ->
            ( model, Navigation.newUrl("#fleet"))
