-- Author: d86leader@mail.com
-- License: GNU GPL v3; you should have received a copy of the license text
--  with this source file; if you haven't, see:
--  https://github.com/d86leader/firefox_image_redirecter/blob/master/LICENSE
module ParseUri
    ( parseFuckingUri
    , GoodUri
    ) where

import Prelude
import Data.Either (either)
import Data.Maybe (Maybe (Just, Nothing), maybe)
import Data.These (These (This, That, Both))
import Data.Tuple (Tuple (..))
import Text.Parsing.Parser (runParser)
import URI.AbsoluteURI (AbsoluteURI (..))
import URI.Authority (Authority (..))
import URI.HierarchicalPart (HierarchicalPart (HierarchicalPartAuth))
import URI.Path (Path (..))
import URI.Path.Segment (segmentToString)

import URI.AbsoluteURI as AbsoluteUri
import URI.Host as Host
import URI.HostPortPair as HostPortPair
import URI.Port as Port
import URI.Query as Query
import URI.Scheme as Scheme

type GoodUri =
    {scheme :: String, host :: String, path :: Array String, query :: String}

-- | Purescript has a big "standard library", by which i mean libraries written
-- | by language contributors themselves. But it's really sad that most of the
-- | libraries are just fucking garbage. Why do I need a module of 50 lines to
-- | just parse a URI into a somewhat workable form? A parser for the output of
-- | the parser?
-- |
-- | And it's not just uris, it's everywhere. The DOM and HTML modules are
-- | unusable because you get lost casting shit back and forth and can't do
-- | anything meaningful; also their docs suck. The prelude is unsusable
-- | because all the shit is missing: there isn't even Maybe there!
-- |
-- | Is it because the language contributors themselves write mostly in
-- | haskell, so they forget how it is to write purescript programs?
parseFuckingUri :: String -> Maybe GoodUri
parseFuckingUri str = do
    AbsoluteURI scheme' hier' query' <- runParser' str $
                                            AbsoluteUri.parser options
    let scheme = Scheme.print scheme'
    let query = maybe "" Query.print query'
    (Tuple host' path') <- case hier' of
        HierarchicalPartAuth (Authority Nothing (Just host)) path
            -> pure $ Tuple host path
        _   -> Nothing
    let host = printHost host'
    let path = case path' of Path segs -> map segmentToString segs
    pure {scheme: scheme, host: host, path: path, query: query}
    where
        options =
            { parseUserInfo: pure
            , parseHosts: HostPortPair.parser pure pure
            , parsePath: pure
            , parseHierPath: pure
            , parseQuery: pure
            }
        runParser' s = either (const Nothing) Just <<< runParser s
        printHost (Both host port) = Host.print host <> Port.print port
        printHost (This host) = Host.print host
        printHost (That port) = Port.print port
