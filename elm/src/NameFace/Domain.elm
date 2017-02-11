module NameFace.Domain exposing (..)


type alias NameFaceGame =
    { people : List Person
    , matchesRequired : Int
    , faces : List (WithFace {})
    , names : List (WithName {})
    , selectedName : Maybe PersonId
    , selectedFace : Maybe PersonId
    , matches : Matches
    , combo : Int
    }


type alias WithName person =
    { person | name : String, id : Int }


type alias WithFace person =
    { person | faceUrl : String, id : Int }


type alias Person =
    { name : String, faceUrl : String, id : Int }


toFace : Person -> WithFace {}
toFace { faceUrl, id } =
    { faceUrl = faceUrl, id = id }


toName : Person -> WithName {}
toName { name, id } =
    { name = name, id = id }


type alias PersonId =
    Int


type alias Matches =
    List PersonId
