module Update exposing (..)

import Messages exposing (Msg(..))
import Models exposing (AppModel)
import Simulator.Simulator
import Solar.Update
import Planet.Update
import Research.Update
import Fleet.Update
import Routing exposing (parseLocation)


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update message model =
    case message of
        SimulatorMsg subMsg ->
            let
                ( updateSimulatorModel, simulatorCmd ) =
                    Simulator.Simulator.update subMsg model.simulatorModel
            in
                ( { model | simulatorModel = updateSimulatorModel }, Cmd.map SimulatorMsg simulatorCmd )

        SolarMsg subMsg ->
            let
                ( updateSolarModel, solarCmd ) =
                    Solar.Update.update subMsg model.solarModel
            in
                ( { model | solarModel = updateSolarModel }, Cmd.map SolarMsg solarCmd )

        PlanetMsg subMsg ->
            let
                ( updatePlanetModel, planetCmd ) =
                    Planet.Update.update subMsg model.planetModel
            in
                ( { model | planetModel = updatePlanetModel }, Cmd.map PlanetMsg planetCmd )

        ResearchMsg subMsg ->
            let
                ( updateResearchModel, researchCmd ) =
                    Research.Update.update subMsg model.researchModel
            in
                ( { model | researchModel = updateResearchModel }, Cmd.map ResearchMsg researchCmd )

        FleetMsg subMsg ->
            let
                ( updateFleetModel, fleetCmd ) =
                    Fleet.Update.update subMsg model.fleetModel
            in
                ( { model | fleetModel = updateFleetModel }, Cmd.map FleetMsg fleetCmd )

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )
