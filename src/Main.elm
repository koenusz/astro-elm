module Main exposing (..)

import Html exposing (Html, div, text)
import Html.App
import Simulator.Simulator as Simulator



-- MODEL


type alias AppModel =
    {simulatorModel : Simulator.Simulator
    }

initialModel : AppModel
initialModel =
  { simulatorModel = Simulator.initialModel
  }

init : ( AppModel, Cmd Msg )
init =
    ( initialModel, Cmd.none )



-- MESSAGES


type Msg
    = SimulatorMsg Simulator.Msg



-- VIEW


view : AppModel -> Html Msg
view model =
    div[][
    div []
        [ page model ],
      div[][
      Html.hr [] [],
      Html.text <| toString model
      ]
    ]

page : AppModel -> Html Msg
page model =
   Html.App.map SimulatorMsg (Simulator.view model.simulatorModel)

-- UPDATE


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update message model =
    case message of
        SimulatorMsg subMsg ->
            let
              ( updateSimulatorModel, simulatorCmd) =
                  Simulator.update subMsg model.simulatorModel
            in
              ( {model| simulatorModel = updateSimulatorModel }, Cmd.map SimulatorMsg simulatorCmd )



-- SUBSCRIPTIONS


subscriptions : AppModel -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
