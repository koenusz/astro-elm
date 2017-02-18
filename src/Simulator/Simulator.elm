module Simulator.Simulator exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import WebSocket
import Planet.Grid
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, hardcoded)


-- MODEL


type alias Simulator =
    { count : Int
    , play : Bool
    , pending : Bool
    }


initSimModel : Simulator
initSimModel =
    { count = 0
    , play = False
    , pending = False
    }



-- MESSAGES


type Msg
    = Increase
    | Decrease
    | Play
    | Pause
    | ReceiveMessage String



-- VIEW


view : Simulator -> Html Msg
view simulator =
    div [ class "py1" ]
        [ btnActive simulator
        , btnSpeedIncrease
        , span [] [ text (toString simulator.count) ]
        , btnSpeedDecrease
        ]


btnActive : Simulator -> Html Msg
btnActive simulator =
    if simulator.play then
        btnPause
    else
        btnPlay


btnPlay : Html Msg
btnPlay =
    a [ class "btn ml1 h2", onClick Play ] [ i [ class "fa fa-play" ] [] ]


btnPause : Html Msg
btnPause =
    a [ class "btn ml1 h2", onClick Pause ] [ i [ class "fa fa-pause" ] [] ]


btnSpeedDecrease : Html Msg
btnSpeedDecrease =
    a [ class "btn ml1 h2", onClick Increase ] [ i [ class "fa fa-plus-circle" ] [] ]


btnSpeedIncrease : Html Msg
btnSpeedIncrease =
    a [ class "btn ml1 h2", onClick Decrease ] [ i [ class "fa fa-minus-circle" ] [] ]



-- UPDATE


update : Msg -> Simulator -> ( Simulator, Cmd Msg )
update message simulator =
    case message of
        Increase ->
            ( { simulator | count = min 4 simulator.count + 1 }, Cmd.none )

        Decrease ->
            ( { simulator | count = max 1 simulator.count - 1 }, Cmd.none )

        Play ->
            ( { simulator | pending = True }, WebSocket.send Planet.Grid.echoServer """{"type":"simulator", "data":true }""" )

        Pause ->
            ( { simulator | pending = True }, WebSocket.send Planet.Grid.echoServer """{"type":"simulator", "data":false }""" )

        ReceiveMessage received ->
            case decodeString simulatorDecoder received of
                Result.Ok newSimulator ->
                    ( { newSimulator | pending = False }, Cmd.none )

                Result.Err message ->
                    Debug.log ("Error" ++ message)
                        ( { simulator | pending = False }, Cmd.none )


simulatorDecoder : Decoder Simulator
simulatorDecoder =
    decode Simulator
        |> required "count" int
        |> required "play" bool
        |> required "pending" bool


subscriptions : Simulator -> Sub Msg
subscriptions _ =
    WebSocket.listen Planet.Grid.echoServer ReceiveMessage
