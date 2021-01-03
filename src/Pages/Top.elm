module Pages.Top exposing (Model, Msg, Params, page)

import Browser.Navigation exposing (Key)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import List
import Shared
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)
import Tuple
import Utils.Route
import Validate exposing (Validator, validate)


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
    , key : Key
    , newPlayer : String
    , password : String
    , errors : List ErrorMessage
    }


init : Shared.Model -> Url Params -> ( Model, Cmd Msg )
init shared { params } =
    ( { player = shared.player
      , key = shared.key
      , newPlayer = ""
      , password = ""
      , errors = []
      }
    , Cmd.none
    )


type alias ErrorMessage =
    ( Field, String )



-- VALIDATION


type Field
    = Player
    | Password


modelValidator : Validator ( Field, String ) Model
modelValidator =
    Validate.all
        [ Validate.ifBlank .newPlayer
            ( Player, "Please type your name" )
        , Validate.firstError
            [ Validate.ifBlank .password
                ( Password, "Please enter the password" )
            , Validate.ifFalse (\model -> model.password == "sekrit")
                ( Password, "Password does not match" )
            ]
        ]


fieldErrors : Field -> List ( Field, String ) -> List String
fieldErrors field errors =
    errors
        |> List.filter (\e -> Tuple.first e == field)
        |> List.map Tuple.second


trimAndValidate : Model -> Result (List ErrorMessage) Model
trimAndValidate model =
    let
        trimmedModel =
            { model | newPlayer = String.trim model.newPlayer }

        result =
            validate modelValidator trimmedModel
    in
    case result of
        Ok trimmed ->
            Ok (Validate.fromValid trimmed)

        Err errors ->
            Err errors



-- UPDATE


type Msg
    = Login
    | PlayerChanged String
    | PasswordChanged String
    | Solitaire


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PlayerChanged newPlayer ->
            ( { model | newPlayer = newPlayer }, Cmd.none )

        PasswordChanged password ->
            ( { model | password = password }, Cmd.none )

        Login ->
            case trimAndValidate model of
                Ok newModel ->
                    ( { newModel | player = Just newModel.newPlayer, errors = [] }, Cmd.none )

                Err errors ->
                    ( { model | errors = errors }, Cmd.none )

        Solitaire ->
            ( model, Utils.Route.navigate model.key Route.Game )


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


errorsFor : Field -> List ErrorMessage -> Html msg
errorsFor field errors =
    div [ class "error-message" ]
        (errors
            |> fieldErrors field
            |> List.map (\s -> text s)
            |> List.intersperse (br [] [])
        )


view : Model -> Document Msg
view model =
    { title = "Quarantine Dice"
    , body =
        [ div []
            [ p []
                [ input
                    [ placeholder "Your name"
                    , value model.newPlayer
                    , onInput PlayerChanged
                    ]
                    []
                , errorsFor Player model.errors
                , input
                    [ type_ "password"
                    , placeholder "Password"
                    , value model.password
                    , onInput PasswordChanged
                    ]
                    []
                , errorsFor Password model.errors
                , br [] []
                , button [ onClick Login ] [ text "Login" ]
                ]
            , hr [] []
            , p []
                [ button [ onClick Solitaire ] [ text "Solitaire" ] ]
            ]
        ]
    }
