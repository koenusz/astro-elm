port module Stylesheets exposing (..)

import Css.File exposing (..)
import Css.PlanetCss
import Css.GeneralCss
import Css.SolarCss


port files : CssFileStructure -> Cmd msg


fileStructure : CssFileStructure
fileStructure =
    Css.File.toFileStructure
        [ ( "styles.css"
          , compile
                [ Css.GeneralCss.css
                , Css.SolarCss.css
                , Css.PlanetCss.css
                ]
          )
        ]


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure
