let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.13.6-20200404/packages.dhall sha256:f239f2e215d0cbd5c203307701748581938f74c4c78f4aeffa32c11c131ef7b6

let overrides = {=}

let additions =
  { web-extensions = ./lib/web-extensions/spago.dhall as Location
  , undefined-or =
    { dependencies = [ "maybe" ]
    , repo = "https://github.com/d86leader/purescript-undefined-or"
    , version = "15709a1eb7efdefc1f79f18f1c390b53ba33fd5f"
    }
  }

in  upstream // overrides // additions
