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
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href)
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
                    p [ css [] ] [ text error.message ]
    in
    { title = page.title
    , body =
        [ div [ css [ margin (px 20), fontFamily sansSerif ] ]
            [ header [ css [ displayFlex ] ]
                [ a [ css [ color (rgb 0 100 200), textDecoration underline, marginRight (px 20) ] ] [ text headline ]
                , errorLine
                ]
            , div [ css [ marginTop (px 20) ] ] page.body
            ]
        ]
    }
