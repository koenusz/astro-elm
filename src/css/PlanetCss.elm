module Css.PlanetCss exposing (CssClasses(..), CssIds(..), css)

import Css exposing (..)
import Css.Elements exposing (body, li)
import Css.Namespace exposing (namespace)


type CssClasses
    = Key
    | Value


type CssIds
    = Page


css : Stylesheet
css =
    (stylesheet << namespace "planet")
        [ body
            [ overflowX auto
            , minWidth (px 1280)
            ]
        , id Page
            [ backgroundColor (rgb 200 128 64)
            , color (hex "CCFFFF")
            , width (pct 100)
            , height (pct 100)
            , boxSizing borderBox
            , padding (px 8)
            , margin zero
            ]
        , class Key
            [ float Css.left
            , Css.width (Css.pct 50)
            , Css.maxHeight (Css.em 1)
            , Css.whiteSpace Css.noWrap
            ]
        ]


primaryAccentColor : Color
primaryAccentColor =
    hex "ccffaa"
