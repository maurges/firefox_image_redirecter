module Main (main) where

import Prelude
import Browser.Event (addListener)
import Data.Array (uncons, null)
import Data.HashSet (HashSet, member, insert, delete)
import Data.Maybe (Maybe (Just, Nothing))
import Data.Options (Options, (:=))
import Data.String (toLower)
import Data.String.CodeUnits (drop, dropRight)
import Data.String.Utils (startsWith, endsWith)
import Data.Traversable (for_)
import Effect (Effect)
import Effect.Ref (Ref)
import ParseUri (parseFuckingUri)
import Browser.WebRequest
    ( onBeforeRequestBlocking
    , BeforeRequestDetails (..), BeforeRequestResponse
    , onHeadersReceivedBlocking
    , HeadersReceivedDetails (..), HeadersReceivedResponse
    , requestFilter, redirectUrl
    )

import Effect.Console as Console
import Effect.Ref as Ref
import Data.HashSet as Set


main :: Effect Unit
main = do
    Console.log "main running!"
    avar <- Ref.new Set.empty
    let firstReqFilter = requestFilter ["https://imgur.com/*"] mempty
    addListener onBeforeRequestBlocking firstReqFilter $ beforeRequst avar
    let headerFilter = requestFilter ["https://i.imgur.com/*"] mempty
    addListener onHeadersReceivedBlocking headerFilter $ processHeaders avar

beforeRequst
    :: Ref (HashSet String)
    -> BeforeRequestDetails
    -> Effect (Options BeforeRequestResponse)
beforeRequst avar (BeforeRequestDetails details) = do
    Console.log $ "url is " <> details.url
    urls <- Ref.read avar
    if details.url `member` urls
    then Ref.write (delete details.url urls) avar
      *> pure mempty
    else case redirectTo details.url of
      Nothing -> pure mempty
      Just newUrl -> do
        Console.log ("redirect to " <> newUrl)
        pure $ (redirectUrl := newUrl)

redirectTo :: String -> Maybe String
redirectTo url = do
    parsed <- parseFuckingUri url
    {head: path, tail: rest} <- uncons parsed.path
    case unit of
      _ | startsWith "i." parsed.host -> Nothing
        | path == "favicon.ico" -> Nothing
        | not $ null rest  -> Nothing
      _ -> Just $ parsed.scheme <> "//i." <> parsed.host <> "/" <> path <> ".png"

parseExtensionBuiltUrl :: String -> Maybe String
parseExtensionBuiltUrl url = do
    parsed <- parseFuckingUri url
    {head: path, tail: rest} <- uncons parsed.path
    case unit of
      _ | not $ startsWith "i." parsed.host -> Nothing
        | not $ null rest -> Nothing
        | not $ endsWith ".png" path -> Nothing
      _ -> let host = drop 2 parsed.host
               path' = dropRight 4 path
           in Just $ parsed.scheme <> "//" <> host <> "/" <> path'

processHeaders
    :: Ref (HashSet String)
    -> HeadersReceivedDetails
    -> Effect (Options HeadersReceivedResponse)
processHeaders avar (HeadersReceivedDetails details) =
    if details.statusCode == 404
    then redirectBack
    else checkIfRedirects
  where
    -- if the page redirects us somewhere, tell the beforeRequest handler to
    -- not redirect from it; it's a fix to avoid circular redirects between
    -- site and extension
    checkIfRedirects = do
        for_ details.responseHeaders \header -> do
            case toLower header.name of
                "location" -> do
                    urls <- Ref.read avar
                    Ref.write (insert header.value urls) avar
                _ -> pure unit
        pure mempty
    -- if it's an error page or something else, and the extension recently
    -- redirected, redirect back to hopefully avoid the error
    redirectBack = case parseExtensionBuiltUrl details.url of
        Nothing -> pure mempty -- a bad url was not constructed by us
        Just newUrl -> do
            Console.log ("redirect back to " <> newUrl)
            urls <- Ref.read avar
            Ref.write (insert newUrl urls) avar
            pure $ redirectUrl := newUrl
