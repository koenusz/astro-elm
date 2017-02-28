port module Stylesheets exposing (..)

import Css.File exposing (..)
import Css.PlanetCss


port files : CssFileStructure -> Cmd msg


fileStructure : CssFileStructure
fileStructure =
    Css.File.toFileStructure [ ( "styles.css", compile [ Css.PlanetCss.css ] ) ]


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure
