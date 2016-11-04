module Research.View exposing (..)

import Html exposing (Html, div, text, button, i)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Html exposing (Html, div, text)
import Research.Models exposing(ResearchModel)
import Research.Messages exposing(Msg(..))


view : ResearchModel -> Html Msg
view model =
    div []
        [ text model ]

researchBtn : Html Research.Messages.Msg
researchBtn =
    button
        [ class "btn regular"
        , onClick ShowResearch
        ]
        [ i [ class "fa mr1" ] [], text "Research" ]
