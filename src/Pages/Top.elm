module Pages.Top exposing (Model, Msg, Params, page)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Shared
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)


page : Page Params Model Msg
page =
    Page.application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        , save = save
        , load = load
        }



-- INIT


type alias Params =
    ()


type alias Model =
    { player : Maybe String
    , newPlayer : String
    }


init : Shared.Model -> Url Params -> ( Model, Cmd Msg )
init shared { params } =
    ( { player = shared.player, newPlayer = "" }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Login
    | PlayerChanged String
    | Practice


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PlayerChanged newPlayer ->
            ( { model | newPlayer = newPlayer }, Cmd.none )

        Login ->
            ( { model | player = Just model.newPlayer }, Cmd.none )

        Practice ->
            ( model, Cmd.none )


save : Model -> Shared.Model -> Shared.Model
save model shared =
    { shared | player = model.player }


load : Shared.Model -> Model -> ( Model, Cmd Msg )
load shared model =
    ( { model | player = shared.player }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Quarantine Dice"
    , body =
        [ div []
            [ section []
                [ button [ onClick Practice ] [ text "Just Me" ]
                , input
                    [ placeholder "Your name"
                    , onInput PlayerChanged
                    , value model.newPlayer
                    ]
                    []
                , button [ onClick Login ] [ text "Login" ]
                ]
            ]
        ]
    }
