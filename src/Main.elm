module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Navigation exposing (Location)
import Markdown


markdown : String -> Html Msg
markdown =
    Markdown.toHtml []


main : Program Never Model Msg
main =
    Navigation.program
        SetPage
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { brand : Link
    , navbarLinks : List Link
    , location : Location
    , footerLinks : List Link
    }


type alias Link =
    { label : String
    , url : String
    }


type Page
    = Homepage
    | Thoughts
    | NotFound


type Msg
    = SetPage Location


init : Location -> ( Model, Cmd Msg )
init location =
    ( Model
        (Link "ryan" "/")
        [ Link "Thoughts" "/thoughts"
        , Link "Work" "/work"
        ]
        location
        [ Link "Github" "https://www.github.com/ryannhg"
        , Link "Twitter" "https://www.twitter.com/ryan_nhg"
        ]
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


getPage : Location -> Page
getPage location =
    case location.pathname of
        "/" ->
            Homepage

        "/thoughts" ->
            Thoughts

        _ ->
            NotFound


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetPage location ->
            ( { model | location = location }, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "app" ]
        [ viewNavbar model
        , viewPage model
        , viewFooter model
        ]


viewNavbar : Model -> Html Msg
viewNavbar model =
    header
        [ class "navbar" ]
        [ viewNavLink model.location.pathname model.brand
        , viewNavlinks model
        ]


viewNavlinks : { a | navbarLinks : List Link, location : Location } -> Html Msg
viewNavlinks { navbarLinks, location } =
    nav [ class "navlinks" ]
        (List.map (viewNavLink location.pathname) navbarLinks)


viewNavLink : String -> Link -> Html Msg
viewNavLink pathname link =
    a
        [ class "navlink link"
        , classList [ ( "link--active", pathname == link.url ) ]
        , href link.url
        , target (linkTarget link)
        ]
        [ text link.label ]


viewPage : Model -> Html Msg
viewPage model =
    case getPage model.location of
        Homepage ->
            viewHomepage model

        Thoughts ->
            viewThoughtsPage model

        NotFound ->
            viewNotFoundPage model


viewHomepage : Model -> Html Msg
viewHomepage model =
    div [ class "page page--home" ]
        [ viewPageHeader
            "Ryan Haskell-Glatz"
            "A web developer with no social skills."
        , section [ class "intro section" ]
            [ h3 [ class "section__title" ] [ text "About me" ]
            , div [ class "section__content rich-text" ]
                [ markdown """
Hey there. My name is Ryan, and I like coding things. Sometimes I code things in [elm](http://www.elm-lang.org), my favorite programming language ever.
            """ ]
            ]
        ]


viewThoughtsPage : Model -> Html Msg
viewThoughtsPage model =
    div [ class "page page--thoughts" ]
        [ viewPageHeader
            "Thoughts"
            "I don't know about __thought _leadership___, but these are all definitely thoughts."
        ]


viewNotFoundPage : Model -> Html Msg
viewNotFoundPage model =
    div [ class "page page--not-found" ]
        [ h1 [] [ text "Not found" ] ]


viewPageHeader : String -> String -> Html Msg
viewPageHeader title subtitle =
    div [ class "page__header" ]
        [ h1 [ class "page__title" ] [ text title ]
        , div [ class "page__subtitle" ] [ markdown subtitle ]
        ]


viewFooter : Model -> Html Msg
viewFooter model =
    footer [ class "footer" ]
        [ p [ class "footer__copyright" ] [ text "" ]
        , viewFooterLinks model
        ]


viewFooterLinks : { a | footerLinks : List Link } -> Html Msg
viewFooterLinks { footerLinks } =
    nav [ class "footer__links" ]
        (List.map viewFooterLink footerLinks)


viewFooterLink : Link -> Html Msg
viewFooterLink link =
    a
        [ class "footer__link link"
        , href link.url
        , target (linkTarget link)
        ]
        [ text link.label ]


linkTarget : { a | url : String } -> String
linkTarget { url } =
    if String.startsWith "http" url then
        "_blank"
    else
        "_self"
