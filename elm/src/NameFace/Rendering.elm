module NameFace.Rendering exposing (view)

import NameFace.Domain exposing (..)
import NameFace.State exposing (..)


--

import Html exposing (Html, button, div, text, img, br, span)
import Html.Attributes exposing (src, height, width, class, classList, id)
import Html.Events exposing (onClick)


view : NameFaceGame -> Html Event
view model =
    div [ id "wrapper", wrapperClasses model ]
        [ div [] (List.map (faceSelect model model.selectedFace) model.faces)
        , br [] []
        , br [] []
        , messageToUser model
        , br [] []
        , br [] []
        , div [] [ text <| "Combo: " ++ (toString model.combo) ]
        , br [] []
        , br [] []
        , button [ onClick (NewGame model.people) ] [ text "New People" ]
        , br [] []
        , br [] []
        , div [] (List.map (nameSelect model) model.names)
        , div [ class "fire" ] []
        ]



-- UNEXPOSED


messageToUser : NameFaceGame -> Html Event
messageToUser model =
    text <|
        if finished model then
            "Nice Job!"
        else if incorrectMatch model then
            "Not a match, try again!"
        else
            ""


incorrectMatch : NameFaceGame -> Bool
incorrectMatch model =
    Maybe.withDefault False <|
        Maybe.map2 (/=) model.selectedName model.selectedFace


finished : NameFaceGame -> Bool
finished model =
    List.length model.matches == model.matchesRequired


matches : NameFaceGame -> Html Event
matches model =
    text (toString model.matches)


nameSelect : NameFaceGame -> WithName a -> Html Event
nameSelect model person =
    div
        [ onClick (ChooseName person.id)
        , nameClasses model person.id
        ]
        [ text person.name ]


nameClasses : NameFaceGame -> PersonId -> Html.Attribute msg
nameClasses model id =
    classList
        [ ( "option", True )
        , ( "selected", Just id == model.selectedName )
        , ( "matched", List.any ((==) id) model.matches )
        ]


wrapperClasses : NameFaceGame -> Html.Attribute msg
wrapperClasses model =
    classList
        [ ( "has-combo", model.combo >= model.matchesRequired )
        ]


faceSelect : NameFaceGame -> Maybe PersonId -> WithFace a -> Html Event
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
        [ ( "option", True )
        , ( "matched", List.any ((==) id) matches )
        , ( "selected", Just id == selectedFace )
        ]
