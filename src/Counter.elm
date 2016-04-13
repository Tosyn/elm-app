module Counter(..) where

{-| The counter module description goes here

# Definition
@docs Action, Model, countStyle, update, view

-}

import Html exposing (..)
import Html.Attributes exposing (style, class)
import Html.Events exposing (onClick)

-- import StartApp.Simple exposing (start)
--
-- main =
--   start
--     { model = 0
--     , update = update
--     , view = view
--     }

--
{-| MODEL -}
type alias Model = Int

{-| Init -}
init : Int -> Model
init count = count


{-| ACTION -}
type Action = Increment | Decrement

{-| update -}
update : Action -> Model -> Model

update action model =
  case action of
    Increment -> model + 1
    Decrement -> model - 1

{-| VIEW -}
view : Signal.Address Action -> Model -> Html
view address model =
  div [class "content"]
    [ button [ onClick address Decrement ] [ text "-" ]
    , div [ countStyle ] [ text (toString model) ]
    , button [ onClick address Increment ] [ text "+" ]
    ]

{-| countStyle -}
countStyle : Attribute
countStyle =
  style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("width", "50px")
    , ("text-align", "center")
    ]
