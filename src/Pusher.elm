port module Pusher exposing (connect)

{-| Pusher module.

@docs connect

-}


{-| Connect to Pusher server. This is the basic connection — subscribing to a channel
is a different operation.
-}
port connect : () -> Cmd msg
