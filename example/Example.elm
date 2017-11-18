module Example exposing (main)

import Geoip as Geoip exposing (Geoip)
import Html exposing (Html, dd, div, dl, dt, h1, text)
import Task


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { geoip : Geoip }


init : ( Model, Cmd Msg )
init =
    ( { geoip = Geoip.empty }, Task.perform SetGeoip Geoip.detect )



-- UPDATE


type Msg
    = SetGeoip Geoip


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetGeoip geoip ->
            ( { model | geoip = geoip }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Html Msg
view { geoip } =
    div
        []
        [ h1 [] [ text "Detected information" ]
        , dl []
            [ dt [] [ text "IP" ]
            , dd [] [ geoip.ip |> Maybe.withDefault "UNKNOWN" |> text ]
            , dt [] [ text "Country Code" ]
            , dd [] [ geoip.countryCode |> Maybe.withDefault "UNKNOWN" |> text ]
            , dt [] [ text "Country Name" ]
            , dd [] [ geoip.countryName |> Maybe.withDefault "UNKNOWN" |> text ]
            , dt [] [ text "Region Code" ]
            , dd [] [ geoip.regionCode |> Maybe.withDefault "UNKNOWN" |> text ]
            , dt [] [ text "Region Name" ]
            , dd [] [ geoip.regionName |> Maybe.withDefault "UNKNOWN" |> text ]
            , dt [] [ text "City" ]
            , dd [] [ geoip.city |> Maybe.withDefault "UNKNOWN" |> text ]
            , dt [] [ text "ZIP Code" ]
            , dd [] [ geoip.zipCode |> Maybe.withDefault "UNKNOWN" |> text ]
            , dt [] [ text "Time Zone" ]
            , dd [] [ geoip.timeZone |> Maybe.withDefault "UNKNOWN" |> text ]
            , dt [] [ text "Latitude" ]
            , dd [] [ geoip.latitude |> Maybe.map toString |> Maybe.withDefault "UNKNOWN" |> text ]
            , dt [] [ text "Longitude" ]
            , dd [] [ geoip.longitude |> Maybe.map toString |> Maybe.withDefault "UNKNOWN" |> text ]
            , dt [] [ text "Metro Code" ]
            , dd [] [ geoip.metroCode |> Maybe.map toString |> Maybe.withDefault "UNKNOWN" |> text ]
            ]
        ]
