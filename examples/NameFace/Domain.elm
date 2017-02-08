module NameFace.Domain exposing (..)

type alias NameFaceGame =
    { people : List Person
    , shuffledPeople : List Person
    , selectedName : Maybe PersonId
    , selectedFace : Maybe PersonId
    , matches : Matches
    }


type alias Person =
    { name : String, faceUrl : String, id : Int }


type alias PersonId =
    Int


type alias Matches =
    List PersonId


