module Main exposing (..)

import Html exposing (Html, button, div, text, img, br, span)
import Html.Attributes exposing (src, height, width, class, classList)
import Html.Events exposing (onClick)


main =
    Html.beginnerProgram
        { model = initialModel
        , view = view
        , update = update
        }



-- MODEL


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


type alias PersonId =
    Int


initialModel : Model
initialModel =
    { people =
        [ { name = "Mark"
          , faceUrl = "https://s3.amazonaws.com/parklet/public/system/production/icons/medium/b16cbb2cc5ceed6dfe2f0b6adac81758648a4bcc.?1482347071"
          , id = 1
          }
        , { name = "Tim"
          , faceUrl = "http://images.moc-pages.com/user_images/24014/1276371870m_SPLASH.jpg"
          , id = 2
          }
        ]
    , selectedName = Nothing
    , selectedFace = Nothing
    , matches = []
    }



-- UPDATE


type Msg
    = ChooseName PersonId
    | ChooseFace PersonId


update : Msg -> Model -> Model
update msg model =
    afterSelection msg model |> handleMatch


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
        , finishedMessage model
        , br [] []
        , br [] []
        , div [] (List.map (faceSelect model model.selectedFace) model.people)
        ]


finishedMessage : Model -> Html Msg
finishedMessage model =
    text <|
        case finished model of
            True ->
                "Good Job!"

            False ->
                ""


finished : Model -> Bool
finished model =
    List.length model.matches == List.length initialModel.people


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
