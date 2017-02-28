module Planet.ColonyTypes exposing (..)


type ColonyType
    = Mining
    | Industrial
    | Research
    | Capital


type alias Colony =
    { name : String
    , colonyType : ColonyType
    , population : Population
    , districts : List District
    }


type alias Population =
    { popSize : Int
    , operators : Int
    , scientists : Int
    }


type GrowthFactor
    = GrowthFactor
        { description : String
        , percentage : Int
        , composedOf : List GrowthFactor
        }


type alias Installation =
    { name : String
    , amount : Int
    }


type alias District =
    { specialisation : Specialisation
    , installations : List Installation
    }


type Specialisation
    = None
    | Administrative
    | Researching
    | Refining


initDistrict : District
initDistrict =
    { specialisation = None
    , installations = []
    }


type alias Storage =
    List StoredItem


type alias StoredItem =
    { itemName : String
    , amount : Int
    }


init : Colony
init =
    { name = "init"
    , colonyType = Capital
    , population =
        { popSize = 100
        , operators = 0
        , scientists = 0
        }
    , districts = []
    }
