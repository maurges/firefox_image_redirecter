{ name = "my-project"
, dependencies =
  [ "effect"
  , "avar"
  , "parsing"
  , "psci-support"
  , "refs"
  , "stringutils"
  , "unordered-collections"
  , "uri"
  , "web-extensions"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
