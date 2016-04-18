module Monkey where

-- import Debug
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode exposing ((:=))
import Task exposing (Task, andThen)
import Html.Events exposing (onClick)
import StartApp.Simple as StartApp

main =
  StartApp.start
    { model = model
    , update = update
    , view = view
    }

type alias Monkey =
  {id: Int
  , name: String
  }

-- monkey : Monkey
-- monkey = {id = 1, name = "monkey1"}

monkey : Json.Decode.Decoder Monkey
monkey =
  Json.Decode.object2 Monkey
    ("id" := Json.Decode.int)
    ("name" := Json.Decode.string)

request : Task Http.Error (List Monkey)
request =
  Http.get (Json.Decode.list monkey) "http://mockapi.dev:9090/wallets"

port runner : Task Http.Error ()
port runner =
  request `andThen` (SetMonkeys >> Signal.send actions.address)

type alias ID = Int

type Action
  = Add
  | Remove ID
  | Clear
  | SetMonkeys (List Monkey)

-- Model
type alias Model = List Monkey

model : Model
model = []

-- Update
update : Action -> Model -> Model
update action model =
  case action of
    Add ->
      let id = List.length model
      in
        List.append model [{id = id, name = "monkey " ++ toString id}]

    Remove id ->
      List.filter (\m -> m.id /= id) model

    SetMonkeys model' ->
      model'

    Clear ->
      []

-- View
view : Signal.Address Action -> Model -> Html
view address model =
  let id = 0
      th' field = th [] [text field]
      tr' monkey = tr [] [ td [] [text <| toString monkey.id]
                         , td [] [text <| monkey.name]
                         , button [ onClick address (Remove monkey.id)] [ text "X" ]
                         ]
  in
    div [class "content"]
    [div [] [button [ onClick address Add] [ text "Add" ]
            , button [ onClick address Clear] [ text "Clear"]
            ]
    ,table [class "table table-striped table-bordered"]
        [ thead [] [tr [] (List.map th' ["ID", "Name"])]
        , tbody [] (List.map tr' model)
        ]
    ]
