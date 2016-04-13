module Main where

-- import Counter exposing (update, view)
-- import CounterPair exposing (init, update, view)
import CounterList exposing (init, update, view)
import StartApp.Simple exposing (start)

main =
  start
    { model = init
    , update = update
    , view = view
    }
