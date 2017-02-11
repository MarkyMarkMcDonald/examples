module NameFace.State exposing (Event(ChooseName, ChooseFace, NewGame), update)

import NameFace.Domain exposing (..)
import Random
import Random.List


type Event
    = ChooseName PersonId
    | ChooseFace PersonId
    | NewGame (List Person)
    | PeopleShuffled (List Person)
    | FacesShuffled (List (WithFace {}))
    | NamesShuffled (List (WithName {}))


update : Event -> NameFaceGame -> ( NameFaceGame, Cmd Event )
update msg model =
    case msg of
        NewGame people ->
            ( { model | people = people, matches = [] }, Random.generate PeopleShuffled <| (Random.List.shuffle people) )

        PeopleShuffled people ->
            ( { model | people = people }, Random.generate FacesShuffled <| Random.List.shuffle (people |> List.take model.matchesRequired |> List.map toFace) )

        FacesShuffled faces ->
            ( { model | faces = faces }, Random.generate NamesShuffled <| Random.List.shuffle (model.people |> List.take model.matchesRequired |> List.map toName) )

        NamesShuffled names ->
            ( { model | names = names }, Cmd.none )

        ChooseName personId ->
            ( selectName personId model |> handleMatch |> handleMisMatch, Cmd.none )

        ChooseFace personId ->
            ( selectFace personId model |> handleMatch |> handleMisMatch, Cmd.none )



-- UNEXPOSED


handleMatch : NameFaceGame -> NameFaceGame
handleMatch model =
    nameFaceMatchId model
        |> Maybe.map (addMatch model)
        |> Maybe.withDefault model


handleMisMatch : NameFaceGame -> NameFaceGame
handleMisMatch model =
    if matchAttempted model && (model.selectedFace /= model.selectedName) then
        { model | combo = max 0 (model.combo - 1) }
    else
        model


matchAttempted : NameFaceGame -> Bool
matchAttempted model =
    (Maybe.map2 (\_ _ -> True) model.selectedFace model.selectedName) |> Maybe.withDefault False


addMatch : NameFaceGame -> PersonId -> NameFaceGame
addMatch model personId =
    { model
        | matches = List.append [ personId ] model.matches
        , selectedName = Nothing
        , selectedFace = Nothing
        , combo = model.combo + 1
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
