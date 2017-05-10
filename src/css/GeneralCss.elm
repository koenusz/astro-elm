module Css.GeneralCss exposing (CssClasses(..), CssIds(..), css)

import Css exposing (..)
import Css.Elements exposing (body, li)


type CssClasses
    = Key
    | Value


type CssIds
    = Page


css : Stylesheet
css =
    (stylesheet)
        [ body
            [ boxSizing borderBox
            ]
        ]


primaryAccentColor : Color
primaryAccentColor =
    hex "ccffaa"
