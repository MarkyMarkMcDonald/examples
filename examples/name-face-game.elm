module Main exposing (..)

import Html exposing (Html, button, div, text, img, br)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { people : List Person
    , selectedName : Maybe PersonId
    , selectedFace : Maybe PersonId
    }


type alias Person =
    { name : String, faceUrl : String, id : Int }


type alias PersonId =
    Int


model : Model
model =
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
    }



-- UPDATE


type Msg
    = ChooseName PersonId
    | ChooseFace PersonId


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChooseName personId ->
            if Just personId == model.selectedName then
                { model | selectedName = Nothing}
            else
                { model | selectedName = Just personId }

        ChooseFace personId ->
            if Just personId == model.selectedName then
                { model | selectedFace = Nothing }
            else
                { model | selectedFace = Just personId }



-- VIEW


view : Model -> Html Msg
view model =
    div []
    [ div [] (List.map nameSelect model.people)
    , br [] []
    , br [] []
    , text ("selectedName: " ++ (toString model.selectedName) ++ ", selectedFace: " ++ (toString model.selectedFace))
    , br [] []
    , br [] []
    , div [] (List.map faceSelect model.people)
    ]


nameSelect : Person -> Html Msg
nameSelect person =
    button [ onClick (ChooseName person.id) ] [ text person.name ]


faceSelect : Person -> Html Msg
faceSelect person =
    img [ onClick (ChooseFace person.id), src person.faceUrl ] []
