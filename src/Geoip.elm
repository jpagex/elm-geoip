module Geoip exposing (Geoip, detect, empty)

{-| This is a library to detect the user location based on its IP address.


# Definition

@docs Geoip, empty


# Detection

@docs detect

-}

import Http
import HttpBuilder
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline
import Task exposing (Task)


{-| User location detected information.
-}
type alias Geoip =
    { ip : Maybe String
    , countryCode : Maybe String
    , countryName : Maybe String
    , regionCode : Maybe String
    , regionName : Maybe String
    , city : Maybe String
    , zipCode : Maybe String
    , timeZone : Maybe String
    , latitude : Maybe Float
    , longitude : Maybe Float
    , metroCode : Maybe Int
    }


{-| No information on user location yet.
-}
empty : Geoip
empty =
    { ip = Nothing
    , countryCode = Nothing
    , countryName = Nothing
    , regionCode = Nothing
    , regionName = Nothing
    , city = Nothing
    , zipCode = Nothing
    , timeZone = Nothing
    , latitude = Nothing
    , longitude = Nothing
    , metroCode = Nothing
    }


nonEmptyStringDecoder : Decoder String
nonEmptyStringDecoder =
    Decode.string
        |> Decode.andThen
            (\str ->
                case String.trim str of
                    "" ->
                        Decode.fail "Empty string"

                    _ ->
                        Decode.succeed str
            )


decoder : Decoder Geoip
decoder =
    Pipeline.decode Geoip
        |> Pipeline.optional "ip" (Decode.maybe nonEmptyStringDecoder) Nothing
        |> Pipeline.optional "country_code" (Decode.maybe nonEmptyStringDecoder) Nothing
        |> Pipeline.optional "country_name" (Decode.maybe nonEmptyStringDecoder) Nothing
        |> Pipeline.optional "region_code" (Decode.maybe nonEmptyStringDecoder) Nothing
        |> Pipeline.optional "region_name" (Decode.maybe nonEmptyStringDecoder) Nothing
        |> Pipeline.optional "city" (Decode.maybe nonEmptyStringDecoder) Nothing
        |> Pipeline.optional "zip_code" (Decode.maybe nonEmptyStringDecoder) Nothing
        |> Pipeline.optional "time_zone" (Decode.maybe nonEmptyStringDecoder) Nothing
        |> Pipeline.optional "latitude" (Decode.maybe Decode.float) Nothing
        |> Pipeline.optional "longitude" (Decode.maybe Decode.float) Nothing
        |> Pipeline.optional "metro_code" (Decode.maybe Decode.int) Nothing


{-| Detect the user location.
-}
detect : Task Never Geoip
detect =
    let
        url =
            "https://freegeoip.net/json/"

        expect =
            Http.expectJson decoder
    in
    HttpBuilder.get url
        |> HttpBuilder.withExpect expect
        |> HttpBuilder.toTask
        |> Task.onError (\_ -> Task.succeed empty)
