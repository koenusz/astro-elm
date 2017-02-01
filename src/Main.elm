module Main exposing (..)

import Navigation
import Routing exposing (Route)
import Models exposing (AppModel, initialModel)
import Messages exposing (Msg(..))
import View exposing (view)
import Update exposing (update)
import Navigation exposing (Location)
import Subscriptions exposing (subscriptions)


init : Location -> ( AppModel, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location
    in
        ( initialModel currentRoute, Cmd.none )


main : Program Never AppModel Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
