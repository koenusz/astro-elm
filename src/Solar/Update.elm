module Solar.Update exposing (update)

import Solar.Messages exposing (Msg(..))
import Solar.Models exposing (SolarModel)
import Navigation

update : Msg -> SolarModel -> ( SolarModel, Cmd Msg )
update msg model =
    case msg of
        ShowSolar ->
            ( model, Navigation.newUrl "#solar" )
