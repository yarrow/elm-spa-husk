module Shared exposing
    ( Flags
    , Model
    , Msg
    , init
    , subscriptions
    , update
    , view
    )

import Browser.Navigation exposing (Key)
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Pusher
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import Url exposing (Url)



-- INIT


type alias Flags =
    ()


type alias Model =
    { url : Url
    , key : Key
    , player : Maybe String
    , error : Maybe Pusher.ConnectionError
    }


init : Flags -> Url -> Key -> ( Model, Cmd msg )
init flags url key =
    ( Model url key Nothing Nothing
    , Pusher.connect ()
    )



-- UPDATE


type Msg
    = SaveError Pusher.ConnectionError
    | ReplaceMe


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Cmd.none )

        SaveError error ->
            ( { model | error = Just error }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Pusher.gotError (\error -> SaveError error)



-- VIEW


view :
    { page : Document msg, toMsg : Msg -> msg }
    -> Model
    -> Document msg
view { page, toMsg } model =
    let
        headline =
            "Quarantine Dice"
                ++ (case model.player of
                        Just player ->
                            " — " ++ player

                        Nothing ->
                            ""
                   )

        errorLine =
            case model.error of
                Nothing ->
                    text ""

                Just error ->
                    p [ class "error" ] [ text error.message ]
    in
    { title = page.title
    , body =
        [ div [ class "layout" ]
            [ header [] [ h1 [] [ text headline ] ]
            , errorLine
            , div [ class "page" ] page.body
            ]
        ]
    }
