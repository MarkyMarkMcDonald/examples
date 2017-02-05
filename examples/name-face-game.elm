module Main exposing (..)

import Html exposing (Html, button, div, text, img, br, span)
import Html.Attributes exposing (src, height, width, class, classList)
import Html.Events exposing (onClick)


main =
    Html.programWithFlags
        { init = initialModel
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    { people : List Person
    , selectedName : Maybe PersonId
    , selectedFace : Maybe PersonId
    , matches : List PersonId
    }


type alias Matches =
    List PersonId


type alias Person =
    { name : String, faceUrl : String, id : Int }


type alias UnorderedPerson =
    { name : String, faceUrl : String }


addIndex : Int -> UnorderedPerson -> Person
addIndex index person =
    { id = index
    , name = person.name
    , faceUrl = person.faceUrl
    }


withOrder : List UnorderedPerson -> List Person
withOrder people =
    people |> List.indexedMap addIndex


type alias PersonId =
    Int


initialModel : { people : List UnorderedPerson } -> ( Model, Cmd msg )
initialModel flags =
    ( { people = flags.people |> withOrder
      , selectedName = Nothing
      , selectedFace = Nothing
      , matches = []
      }
    , Cmd.none
    )


type Msg
    = ChooseName PersonId
    | ChooseFace PersonId


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( afterSelection msg model |> handleMatch, Cmd.none )


afterSelection : Msg -> Model -> Model
afterSelection msg model =
    case msg of
        ChooseName personId ->
            selectName personId model

        ChooseFace personId ->
            selectFace personId model


handleMatch : Model -> Model
handleMatch model =
    matchId model
        |> Maybe.map (addMatch model)
        |> Maybe.withDefault model


addMatch : Model -> PersonId -> Model
addMatch model personId =
    { model
        | matches = List.append [ personId ] model.matches
        , selectedName = Nothing
        , selectedFace = Nothing
    }


matchId : Model -> Maybe PersonId
matchId model =
    if (Maybe.map2 (==) model.selectedFace model.selectedName) |> Maybe.withDefault False then
        model.selectedFace
    else
        Nothing


matchesFace : PersonId -> Model -> Bool
matchesFace id model =
    Just id == model.selectedFace


selectName : PersonId -> Model -> Model
selectName selected model =
    if List.any ((==) selected) model.matches then
        model
    else if Just selected == model.selectedName then
        { model | selectedName = Nothing }
    else
        { model | selectedName = Just selected }


selectFace : PersonId -> Model -> Model
selectFace selected model =
    if List.any ((==) selected) model.matches then
        model
    else if Just selected == model.selectedFace then
        { model | selectedFace = Nothing }
    else
        { model | selectedFace = Just selected }


selectedName : Model -> Maybe String
selectedName model =
    model.people
        |> List.filter (\person -> Just person.id == model.selectedName)
        |> List.map (\person -> person.name)
        |> List.head



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [] (List.map (nameSelect model) model.people)
        , br [] []
        , br [] []
        , messageToUser model
        , br [] []
        , br [] []
        , div [] (List.map (faceSelect model model.selectedFace) model.people)
        ]


messageToUser : Model -> Html Msg
messageToUser model =
    text <|
        if finished model then
            "Good Job!"
        else if incorrectMatch model then
            "Not a match, try again!"
        else
            ""


incorrectMatch : Model -> Bool
incorrectMatch model =
    Maybe.withDefault False <|
        Maybe.map2 (/=) model.selectedName model.selectedFace


finished : Model -> Bool
finished model =
    List.length model.matches == List.length model.people


matches : Model -> Html Msg
matches model =
    text (toString model.matches)


nameSelect : Model -> Person -> Html Msg
nameSelect model person =
    div
        [ onClick (ChooseName person.id)
        , nameClasses model person.id
        ]
        [ text person.name ]


nameClasses : Model -> PersonId -> Html.Attribute msg
nameClasses model id =
    classList
        [ ( "name-option", True )
        , ( "selected", Just id == model.selectedName )
        , ( "matched", List.any ((==) id) model.matches )
        ]


faceSelect : Model -> Maybe PersonId -> Person -> Html Msg
faceSelect model selectedId person =
    img
        [ onClick (ChooseFace person.id)
        , src person.faceUrl
        , faceClasses model.matches selectedId person.id
        ]
        []


faceClasses : Matches -> Maybe PersonId -> PersonId -> Html.Attribute msg
faceClasses matches selectedFace id =
    classList
        [ ( "face-option", True )
        , ( "matched", List.any ((==) id) matches )
        , ( "selected", Just id == selectedFace )
        ]
