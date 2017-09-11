module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Navigation exposing (Location)
import Markdown
import UrlParser as Url exposing (Parser, top, (</>))


markdown : String -> Html Msg
markdown =
    Markdown.toHtml []


main : Program Flags Model Msg
main =
    Navigation.programWithFlags
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
    , flags : Flags
    }


type alias Link =
    { label : String
    , url : String
    }


type Page
    = Homepage
    | Thoughts
    | ThoughtDetail ThoughtDetailFlags
    | Projects
    | NotFound


type Msg
    = SetPage Location


type alias Flags =
    Maybe ThoughtDetailFlags


type alias ThoughtDetailFlags =
    { title : String
    , description : String
    , post : String
    }


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    ( Model
        (Link "ryan" "/")
        [ Link "Thoughts" "/thoughts"
        , Link "Projects" "/projects"
        ]
        location
        [ Link "Github" "https://www.github.com/ryannhg"
        , Link "Twitter" "https://www.twitter.com/ryan_nhg"
        ]
        flags
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


getPage : Flags -> Location -> Page
getPage flags location =
    case Url.parsePath (route flags) location of
        Just page ->
            page

        _ ->
            NotFound


route : Flags -> Parser (Page -> a) a
route flags =
    let
        tdFlags =
            Maybe.withDefault (ThoughtDetailFlags "" "" "") flags
    in
        Url.oneOf
            [ Url.map Homepage top
            , Url.map Thoughts (Url.s "thoughts")
            , Url.map (getThoughtDetailPageMsg tdFlags) (Url.s "thoughts" </> Url.string)
            , Url.map Projects (Url.s "projects")
            ]


getThoughtDetailPageMsg : ThoughtDetailFlags -> String -> Page
getThoughtDetailPageMsg flags _ =
    ThoughtDetail flags


getThoughtDetailPage : Flags -> Page
getThoughtDetailPage flags =
    case flags of
        Just thoughtDetailFlags ->
            ThoughtDetail thoughtDetailFlags

        Nothing ->
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
    case getPage model.flags model.location of
        Homepage ->
            viewHomepage model

        Thoughts ->
            viewThoughtsPage model

        ThoughtDetail flags ->
            viewThoughtDetailPage flags model

        Projects ->
            viewProjectsPage model

        NotFound ->
            viewNotFoundPage model


viewHomepage : Model -> Html Msg
viewHomepage model =
    div [ class "page page--home" ]
        [ viewPageHeader
            "Ryan Haskell-Glatz"
            "A web developer with no social skills."
        , section [ class "section" ]
            [ h3 [ class "section__title" ] [ text "About me" ]
            , div [ class "section__content rich-text" ]
                [ markdown "Hey there. My name is Ryan, and I like coding things. Sometimes I code things in [elm](http://www.elm-lang.org), my favorite programming language ever." ]
            ]
        , div [ class "view-more__section" ]
            [ viewViewMoreLink (Link "Here are some thoughts" "/thoughts")
            , viewViewMoreLink (Link "Here are some projects" "/projects")
            ]
        ]


viewThoughtsPage : Model -> Html Msg
viewThoughtsPage model =
    div [ class "page page--thoughts" ]
        [ viewPageHeader
            "Thoughts"
            "I don't know about __thought _leadership___, but these are all definitely thoughts."
        , viewLinkListingSection "latest thoughts"
            [ ( Link "Elm is Nice" "/thoughts/elm-is-nice", "I like to code with it from time to time." )
            ]
        ]


viewThoughtDetailPage : ThoughtDetailFlags -> Model -> Html Msg
viewThoughtDetailPage flags model =
    div [ class "page page--thoughts rich-text" ]
        [ markdown flags.post
        ]


viewProjectsPage : Model -> Html Msg
viewProjectsPage model =
    div [ class "page page--projects" ]
        [ viewPageHeader
            "Projects"
            "I've done some things, man. Things I'm not proud of. Most of those involved jQuery."
        , viewLinkListingSection "latest projects"
            [ ( Link "Kicksharp" "https://github.com/RyanNHG/kicksharp"
              , "An attempt at unifying frontend and backend C# development. With .NET Core, both Mac and Windows users can collaborate together."
              )
            , ( Link "Jangle" "https://github.com/RyanNHG/jangle-api"
              , "A simple CMS written in Typescript and Elm that generates RESTful API endpoints for any application."
              )
            , ( Link "Baroot" "https://github.com/RyanNHG/baroot"
              , "A goofy name for a goofy social network, written with Elm and Typescript for anonymous posts called 'squiggs'."
              )
            ]
        , div [ class "view-more__section" ]
            [ viewViewMoreLink (Link "Check out more projects here" "https://www.github.com/ryannhg") ]
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


viewLinkListingSection : String -> List ( Link, String ) -> Html Msg
viewLinkListingSection title links =
    div [ class "section" ]
        [ h3 [ class "section__title" ] [ text title ]
        , div [ class "section__content" ] (List.map viewLinkListing links)
        ]


viewLinkListing : ( Link, String ) -> Html Msg
viewLinkListing ( link, description ) =
    div [ class "link-listing__section" ]
        [ a [ class "link-listing__link", href link.url, target link.url ]
            [ text link.label ]
        , p [ class "link-listing__description" ] [ text description ]
        ]


viewViewMoreLink : Link -> Html Msg
viewViewMoreLink link =
    a
        [ class "view-more__link"
        , href link.url
        , target (linkTarget link)
        ]
        [ text link.label
        , span [] [ text link.label ]
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
