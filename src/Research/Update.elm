module Research.Update exposing (update)

import Research.Messages exposing (Msg(..))
import Research.Models exposing (ResearchModel)
import Navigation

update : Msg -> ResearchModel -> ( ResearchModel, Cmd Msg )
update msg model =
    case msg of
        ShowResearch ->
            ( model, Navigation.newUrl "#research" )
