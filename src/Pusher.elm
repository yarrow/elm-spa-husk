port module Pusher exposing (connect, gotError, ConnectionError)

{-| Pusher module.

@docs connect, gotError, ConnectionError

-}

import Json.Decode as Decode exposing (Decoder, int, string)
import Json.Decode.Pipeline exposing (required)


{-| Connect to Pusher
-}
port connect : () -> Cmd msg


port connectionError : (String -> msg) -> Sub msg


{-| Receive a Pusher error
-}
gotError : (ConnectionError -> msg) -> Sub msg
gotError f =
    connectionError (\s -> f (toConnectionError s))


tryToConnectionError : Decoder ConnectionError
tryToConnectionError =
    Decode.succeed ConnectionError
        |> required "code" int
        |> required "message" string


toConnectionError : String -> ConnectionError
toConnectionError s =
    case Decode.decodeString tryToConnectionError s of
        Ok error ->
            error

        Err _ ->
            { code = 0, message = s }


{-| Pusher connection errors. See <https://pusher.com/docs/channels/library_auth_reference/pusher-websockets-protocol#connection-closure>
-}
type alias ConnectionError =
    { code : Int
    , message : String
    }
