module Update exposing (update)

import Browser
import Browser.Navigation as Navigation
import Messages exposing (Msg(..), gaEvent, updateAnalyticsEvent, updateAnalyticsPage)
import Model exposing (Model, pageSlug)
import Route exposing (Page(..), pageFromUrl)
import Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        --
        -- Action messages
        --
        ButtonPress category action label withPage ->
            if withPage then
                ( model
                , updateAnalytics model (updateAnalyticsEvent (gaEvent category action (label ++ "_" ++ pageSlug model.currentPage)))
                )

            else
                ( model
                , updateAnalytics model (updateAnalyticsEvent (gaEvent category action label))
                )

        Consent int ->
            ( { model | consent = int }, Cmd.none )

        --
        -- Navigation messages
        --
        NavigateToString url ->
            ( model
            , Cmd.batch
                [ Navigation.load url
                , updateAnalytics model (updateAnalyticsPage (pageSlug model.currentPage ++ " onClick navigation"))
                ]
            )

        UrlChanged url ->
            let
                newPage =
                    pageFromUrl url
            in
            -- We use Home instead of 404.
            ( { model | url = url, currentPage = Maybe.withDefault Home newPage }
            , Cmd.none
            )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    -- pushUrl will add an entry to browser history.
                    -- use replaceUrl when we don't want a history entry.
                    let
                        page =
                            Maybe.withDefault Home (pageFromUrl url)
                    in
                    ( model
                    , Cmd.batch
                        -- pass a list of commands.
                        [ Navigation.pushUrl model.navKey (Url.toString url)
                        , updateAnalytics model (updateAnalyticsPage (pageSlug page))
                        ]
                    )

                Browser.External href ->
                    ( model, Navigation.load href )


updateAnalytics : Model -> Cmd Msg -> Cmd Msg
updateAnalytics model gaevent =
    case model.consent of
        1 ->
            gaevent

        _ ->
            Cmd.none
