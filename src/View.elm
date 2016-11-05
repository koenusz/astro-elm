module View exposing (..)

import Html exposing (Html, div, text, span)
import Html.Attributes exposing (class)
import Html.App
import Messages exposing (..)
import Models exposing (AppModel)
import Simulator.Simulator
import Solar.View exposing (solarBtn)
import Planet.View exposing (planetBtn)
import Research.View exposing (researchBtn)
import Fleet.View exposing (fleetBtn)
import Routing exposing (Route(..))

view : AppModel -> Html Msg
view model =
    div[]
      [
      div [class "overflow-hidden white bg-blue"]
        [navBar model],
      div []
        [ page model ],
      div []
        [
        Html.hr [] [],
        Html.text <| toString model
        ]
    ]


navBar : AppModel -> Html Msg
navBar model =
  span [] [
  div[class "left pt1"] [Html.App.map SolarMsg solarBtn
        ,Html.App.map PlanetMsg  planetBtn
        ,Html.App.map ResearchMsg  researchBtn
        ,Html.App.map FleetMsg  fleetBtn],
  div [class "right"] [Html.App.map SimulatorMsg (Simulator.Simulator.view model.simulatorModel)]
          ]

page : AppModel -> Html Msg
page model =
      case model.route of
        SolarRoute ->
          Html.App.map SolarMsg (Solar.View.view model.solarModel)
        PlanetRoute ->
          Html.App.map PlanetMsg (Planet.View.view model.planetModel)
        ResearchRoute ->
          Html.App.map ResearchMsg (Research.View.view model.researchModel)
        FleetRoute ->
          Html.App.map FleetMsg (Fleet.View.view model.fleetModel)
        NotFoundRoute ->
          div[][text "Not found"]


      --
