{ name = "my-project"
, dependencies =
  [ "effect"
  , "web-extensions"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
