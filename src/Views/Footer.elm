-- Views/Footer.elm


module Views.Footer exposing (footerContent)

import Html exposing (Html, a, div, footer, text)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import I18n.Keys exposing (Key(..))
import I18n.Translate exposing (Language, translate)
import Messages exposing (Msg(..))


footerContent : Language -> Html Msg
footerContent language =
    let
        t =
            translate language
    in
    footer [ class "section section--footer text-center text-small" ]
        [ div [ class "footer--item" ]
            [ text (t FooterSupportersText ++ " ")
            , a [ class "link link--plain", href "#/supporters" ]
                [ text (t FooterSupportersLink) ]
            ]
        , div [ class "footer--item" ]
            [ text (t FooterPrivacyText ++ " ")
            , a [ class "link link--plain", href "#/privacy-policy" ]
                [ text (t FooterPrivacyLink) ]
            ]
        , div [ class "footer--item" ]
            [ text "© 2019 - "
            , a
                [ class "link link--plain"
                , href "http://www.neontribe.co.uk/"
                , onClick (ButtonPress "contact" "website" "neontribe-website-footer" True)
                ]
                [ text (t FooterCopyrightLink) ]
            ]
        , div [ class "footer--item" ]
            [ text (t FooterRegisteredText) ]
        ]
