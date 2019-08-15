module Copy.Render exposing (toHtml, toHtmlWithContext, toString)

import CallToAction exposing (callToActionButton, callToActionNav)
import Copy.BrandCopy exposing (brandCopy)
import Copy.Keys exposing (CallToActionType(..), Copy(..), Key(..))
import Html exposing (Html, a, div, li, p, span, text, ul)
import Html.Attributes exposing (class, href)
import Messages exposing (Msg(..))


filterContext : String -> String
filterContext context =
    -- Anything passing a string containing "button" will be a class for us.
    -- They all get same markup with different classes.
    if String.contains "button" context then
        "button"
        -- All other contexts can be used as they are. They need different markup.

    else
        context


copyToHtml : Copy -> Maybe String -> Html Msg
copyToHtml copy context =
    case copy of
        CallToAction cta ->
            let
                value =
                    Maybe.withDefault "" context
                        |> filterContext
            in
            case value of
                -- The button ones are passed in as classes
                "button" ->
                    callToActionButton cta (Maybe.withDefault "" context)

                -- The nav item is construsted for desktop or mobile
                "desktop-nav" ->
                    div [] [ callToActionNav cta value ]

                "mobile-nav" ->
                    div [] [ callToActionNav cta value ]

                _ ->
                    text ""

        CopyText string ->
            text string

        CopyList list ->
            ul [ class "ul--disc" ]
                (List.map (\item -> li [] [ copyToHtml item Nothing ]) list)

        CopySection list ->
            let
                needsParagraph item =
                    case item of
                        CopyText _ ->
                            True

                        _ ->
                            False
            in
            div []
                (List.map
                    (\item ->
                        if needsParagraph item then
                            p [] [ copyToHtml item Nothing ]

                        else
                            copyToHtml item Nothing
                    )
                    list
                )

        CopyWithLink textLink ->
            p []
                [ text (textLink.textBefore ++ " ")
                , a [ class "link link--plain", href textLink.destination ] [ text textLink.linkText ]
                , text (" " ++ textLink.textAfter)
                ]


toHtml : Key -> Html Msg
toHtml key =
    copyToHtml (brandCopy key) Nothing


toHtmlWithContext : Key -> Maybe String -> Html Msg
toHtmlWithContext key context =
    copyToHtml (brandCopy key) context


toString : Key -> String
toString key =
    case brandCopy key of
        CopyText string ->
            string

        CopyWithLink textLink ->
            textLink.textBefore ++ " " ++ textLink.linkText ++ " " ++ textLink.textAfter

        -- This is a hack - we don't use, but have to output something.
        _ ->
            ""
