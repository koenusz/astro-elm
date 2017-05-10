module Css.SolarCss exposing (CssClasses(..), CssIds(..), css)

import Css exposing (..)
import Css.Elements exposing (body, li)
import Css.Namespace exposing (namespace)


type CssClasses
    = Galaxy


type CssIds
    = Page


css : Stylesheet
css =
    (stylesheet << namespace "solar")
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
        , class Galaxy
            [ backgroundColor (rgb 3 51 153)
            , width (Css.pct 100)
            , height (Css.pct 100)
            , margin zero
            ]
        ]


primaryAccentColor : Color
primaryAccentColor =
    hex "ccffaa"
