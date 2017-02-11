module Main exposing (main)

import NameFace.Domain exposing (..)
import NameFace.State exposing (..)
import NameFace.Rendering exposing (view)


--

import Random
import Random.List
import Html exposing (Html)


type alias UnorderedPerson =
    { name : String, faceUrl : String }


main =
    Html.programWithFlags
        { init = initialize
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


initialize : { people : List UnorderedPerson } -> ( NameFaceGame, Cmd Event )
initialize flags =
    ( { people = []
      , names = []
      , faces = []
      , selectedName = Nothing
      , selectedFace = Nothing
      , matches = []
      , matchesRequired = 6
      }
    , Random.generate PeopleShuffled (Random.List.shuffle (withOrder flags.people))
    )


withOrder : List UnorderedPerson -> List Person
withOrder people =
    people |> List.indexedMap addIndex


addIndex : Int -> UnorderedPerson -> Person
addIndex index person =
    { id = index
    , name = person.name
    , faceUrl = person.faceUrl
    }
