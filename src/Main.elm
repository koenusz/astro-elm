module Main exposing (..)

import Navigation
import Routing exposing (Route)
import Models exposing (AppModel, initialModel)
import Messages exposing (Msg(..))
import View exposing (view)
import Update exposing (update)

init : Result String Route -> ( AppModel, Cmd Msg )
init result =
    let
        currentRoute =
            Routing.routeFromResult result
    in
    ( initialModel currentRoute, Cmd.none )



subscriptions : AppModel -> Sub Msg
subscriptions model =
    Sub.none


urlUpdate : Result String Route -> AppModel -> ( AppModel, Cmd Msg )
urlUpdate result model =
    let
        currentRoute =
            Routing.routeFromResult result
    in
        ( { model | route = currentRoute }, Cmd.none )


main : Program Never
main =
    Navigation.program Routing.parser
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = subscriptions
        }
