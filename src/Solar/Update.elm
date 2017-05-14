module Solar.Update exposing (update)

import Solar.Messages exposing (Msg(..))
import Solar.Models exposing (Model)
import Solar.Types exposing (StarSystem)
import Navigation
import Solar.SceneGraph exposing (updateMatrix)
import Dict
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
import Solar.Starsystem as Starsystem exposing (select)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShowSolar ->
            ( model, Navigation.newUrl "#solar" )

        SetZoom zoom ->
            ( { model | zoom = stringToFloat zoom }, Cmd.none )

        SetRotate rotate ->
            ( { model | rotate = stringToFloat rotate }, Cmd.none )

        SetTranslateX x ->
            ( { model | translateX = stringToFloat x }, Cmd.none )

        SetTranslateY y ->
            ( { model | translateY = stringToFloat y }, Cmd.none )

        TextureLoaded key textureResult ->
            case textureResult of
                Result.Ok val ->
                    ( { model | textures = Dict.insert key val model.textures }, Cmd.none )

                Result.Err err ->
                    ( model, Cmd.none )

        MouseClick position ->
            ( select { model | mouse = tuple2ToVec3 position }
            , Cmd.none
            )

        Tick time ->
            let
                theta_ =
                    model.theta + time / 5000

                newStars =
                    List.map (updateMatrix theta_ Nothing) model.starsystem.stars
            in
                ( { model | theta = theta_, starsystem = StarSystem newStars }, Cmd.none )


tuple2ToVec3 : ( Int, Int ) -> Vec3
tuple2ToVec3 tuple =
    vec3 (toFloat (Tuple.first tuple)) (toFloat (Tuple.second tuple)) 0


stringToFloat : String -> Float
stringToFloat string =
    case String.toFloat string of
        Ok val ->
            val

        Err err ->
            0
