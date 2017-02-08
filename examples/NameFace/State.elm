module NameFace.State exposing (Event (ChooseName, ChooseFace, ShuffledFaces), update)

import NameFace.Domain exposing (..)

type Event
    = ChooseName PersonId
    | ChooseFace PersonId
    | ShuffledFaces (List Person)


update : Event -> NameFaceGame -> ( NameFaceGame, Cmd Event )
update msg model =
    case msg of
        ShuffledFaces people ->
            ( { model | shuffledPeople = people }, Cmd.none )

        ChooseName personId ->
            (selectName personId model |> handleMatch, Cmd.none)

        ChooseFace personId ->
            (selectFace personId model |> handleMatch, Cmd.none)


-- UNEXPOSED


handleMatch : NameFaceGame -> NameFaceGame
handleMatch model =
    nameFaceMatchId model
        |> Maybe.map (addMatch model)
        |> Maybe.withDefault model


addMatch : NameFaceGame -> PersonId -> NameFaceGame
addMatch model personId =
    { model
        | matches = List.append [ personId ] model.matches
        , selectedName = Nothing
        , selectedFace = Nothing
    }


nameFaceMatchId : NameFaceGame -> Maybe PersonId
nameFaceMatchId model =
    if (Maybe.map2 (==) model.selectedFace model.selectedName) |> Maybe.withDefault False then
        model.selectedFace
    else
        Nothing


matchesFace : PersonId -> NameFaceGame -> Bool
matchesFace id model =
    Just id == model.selectedFace


selectName : PersonId -> NameFaceGame -> NameFaceGame
selectName selected model =
    if List.any ((==) selected) model.matches then
        model
    else if Just selected == model.selectedName then
        { model | selectedName = Nothing }
    else
        { model | selectedName = Just selected }


selectFace : PersonId -> NameFaceGame -> NameFaceGame
selectFace selected model =
    if List.any ((==) selected) model.matches then
        model
    else if Just selected == model.selectedFace then
        { model | selectedFace = Nothing }
    else
        { model | selectedFace = Just selected }


selectedName : NameFaceGame -> Maybe String
selectedName model =
    model.people
        |> List.filter (\person -> Just person.id == model.selectedName)
        |> List.map (\person -> person.name)
        |> List.head


