module Simulator.Simulator exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import WebSocket
import Planet.Grid
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, hardcoded, optional)
import Json.Encode exposing (encode, object)


-- MODEL


type alias Simulator =
    { speed : Int
    , play : Bool
    , pending : Bool
    }


initSimModel : Simulator
initSimModel =
    { speed = 0
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
        , span [] [ text (toString simulator.speed) ]
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
            let
                newSimulator =
                    { simulator | speed = min 4 simulator.speed + 1 }
            in
                ( newSimulator
                , WebSocket.send Planet.Grid.echoServer (simulatorRequest simulator.play newSimulator.speed)
                )

        Decrease ->
            let
                newSimulator =
                    { simulator | speed = max 1 simulator.speed - 1 }
            in
                ( newSimulator
                , WebSocket.send Planet.Grid.echoServer (simulatorRequest simulator.play newSimulator.speed)
                )

        Play ->
            ( { simulator | pending = True }
            , WebSocket.send Planet.Grid.echoServer (simulatorRequest True (playSpeed simulator.speed))
            )

        Pause ->
            ( { simulator | pending = True }
            , WebSocket.send Planet.Grid.echoServer (simulatorRequest False 0)
            )

        ReceiveMessage received ->
            case decodeString (simulatorDecoder simulator.speed) received of
                Result.Ok newSimulator ->
                    ( { newSimulator | pending = False }, Cmd.none )

                Result.Err message ->
                    Debug.log ("Error" ++ message)
                        ( { simulator | pending = False }, Cmd.none )


playSpeed : Int -> Int
playSpeed speed =
    if speed == 0 then
        1
    else
        speed


simulatorRequest : Bool -> Int -> String
simulatorRequest start speed =
    let
        data =
            Json.Encode.object
                [ ( "start", Json.Encode.bool start )
                , ( "speed", Json.Encode.int speed )
                ]
    in
        Json.Encode.object
            [ ( "type", Json.Encode.string "simulator" )
            , ( "data", data )
            ]
            |> encode 0


simulatorDecoder : Int -> Decoder Simulator
simulatorDecoder speed =
    decode Simulator
        |> hardcoded speed
        |> required "play" bool
        |> required "pending" bool


subscriptions : Simulator -> Sub Msg
subscriptions _ =
    WebSocket.listen Planet.Grid.echoServer ReceiveMessage
