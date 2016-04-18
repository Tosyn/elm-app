module Wallet where

import Debug
import Html exposing (..)
import Html.Attributes exposing (class)
import Http
import Http.Extra as HttpExtra exposing (..)
import Json.Decode exposing ((:=))
import Task exposing (Task, andThen)


-- MODEL

type alias Wallet =
  { id: Int
  , name: String
  , bulkAccountId: String
  }

type alias Model =
  List Wallet

init : Model
init =
  []


-- UPDATE

type Action
  = NoOp
  | SetWallets (List Wallet)


update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

    SetWallets model' ->
      model'

-- SIGNALS

main : Signal Html
main =
  Signal.map view model


model : Signal Model
model = Signal.foldp update init actions.signal


actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp


wallet : Json.Decode.Decoder Wallet
wallet =
  Json.Decode.object3 Wallet
    ("id" := Json.Decode.int)
    ("name" := Json.Decode.string)
    ("bulk_account_id" := Json.Decode.string)

request : Task Http.Error (List Wallet)
request =
  Http.get (Json.Decode.list wallet) "http://mockapi.dev:9090/wallets"

port runner : Task Http.Error ()
port runner =
  request `andThen` (SetWallets >> Signal.send actions.address)


-- VIEW

view : Model -> Html
view model =
  let th' field = th [] [text field]
      tr' wallet = tr [] [ td [] [text <| toString wallet.id]
                         , td [] [text <| wallet.name]
                         , td [] [text <| wallet.bulkAccountId]
                         ]
  in
    div [class "container"]
    [ table [class "table table-striped table-bordered"]
      [ thead [] [tr [] (List.map th' ["Wallet ID", "Wallet Name", "Bulk Account Id"])]
      , tbody [] (List.map tr' model)
      ]
    ]
