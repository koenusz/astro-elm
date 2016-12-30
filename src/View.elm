module View exposing (..)

import Html exposing (Html, div, text, span)
import Html.Attributes exposing (class)
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
    div []
        [ div [ class "overflow-hidden white bg-blue" ]
            [ navBar model ]
        , div []
            [ page model ]
        , div []
            [ Html.hr [] []
            , Html.text <| toString model
            ]
        ]


navBar : AppModel -> Html Msg
navBar model =
    span []
        [ div [ class "left pt1" ]
            [ Html.map SolarMsg solarBtn
            , Html.map PlanetMsg planetBtn
            , Html.map ResearchMsg researchBtn
            , Html.map FleetMsg fleetBtn
            ]
        , div [ class "right" ] [ Html.map SimulatorMsg (Simulator.Simulator.view model.simulatorModel) ]
        ]


page : AppModel -> Html Msg
page model =
    case model.route of
        SolarRoute ->
            Html.map SolarMsg (Solar.View.view model.solarModel)

        PlanetRoute ->
            Html.map PlanetMsg (Planet.View.view model.planetModel)

        ResearchRoute ->
            Html.map ResearchMsg (Research.View.view model.researchModel)

        FleetRoute ->
            Html.map FleetMsg (Fleet.View.view model.fleetModel)

        NotFoundRoute ->
            div [] [ text "Not found" ]



--
