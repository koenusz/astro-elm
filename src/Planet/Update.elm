port module Planet.Update exposing (update)

import Planet.Messages exposing (Msg(..))
import Planet.Models exposing (PlanetModel)
import Navigation
import Canvas.Ports exposing (initCanvas, createTile)


update : Msg -> PlanetModel -> ( PlanetModel, Cmd Msg )
update msg model =
    case msg of
        ShowPlanet ->
            ( model, Navigation.newUrl("#planet"))
        Init ->
            ( model, initCanvas "myCanvas" )
        Tile ->
            ( model, createTile "myCanvas"  )
