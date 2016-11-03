module Simulator.Simulator exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


-- MODEL


type alias Simulator =
    { count : Int,
      play : Bool

    }


initialModel : Simulator
initialModel =
    { count = 0,
      play = False
    }



-- MESSAGES


type Msg
    = Increase | Decrease | Play | Pause


-- VIEW



view : Simulator -> Html Msg
view simulator =
    div [ class "py1"]
        [ btnActive simulator,
        btnSpeedIncrease
        , span [] [ text (toString simulator.count) ]
        , btnSpeedDecrease
        ]

btnActive : Simulator -> Html Msg
btnActive simulator =
  if simulator.play then btnPause else btnPlay


btnPlay : Html Msg
btnPlay =
  a [ class "btn ml1 h2", onClick Play ] [i [ class "fa fa-play" ] [] ]

btnPause : Html Msg
btnPause =
  a [ class "btn ml1 h2", onClick Pause ] [i [ class "fa fa-pause" ] [] ]

btnSpeedDecrease : Html Msg
btnSpeedDecrease  =
    a [ class "btn ml1 h2", onClick Increase ] [i [ class "fa fa-plus-circle" ] [] ]


btnSpeedIncrease :  Html Msg
btnSpeedIncrease =
    a [ class "btn ml1 h2", onClick Decrease ] [i [ class "fa fa-minus-circle" ] [] ]

-- UPDATE


update : Msg -> Simulator -> ( Simulator, Cmd Msg )
update message model =
    case message of
        Increase ->
            ( { model | count = min 4 model.count + 1 }, Cmd.none )

        Decrease ->
            ( { model | count = max 1 model.count - 1 }, Cmd.none )

        Play ->
            ( { model | play = True }, Cmd.none )

        Pause ->
            ( { model | play = False }, Cmd.none )
