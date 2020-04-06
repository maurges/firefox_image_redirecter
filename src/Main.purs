module Main (main) where

import Prelude
import Browser.Event (addListener)
import Data.Options ((:=))
import Effect (Effect)
import Browser.WebRequest
    ( onBeforeRequestBlocking, OnBeforeRequestDetails (..)
    , requestFilter, redirectUrl
    )

import Effect.Console as Console

main :: Effect Unit
main = Console.log "main running!" *>
    let filter = requestFilter ["*://localhost/*"] mempty
    in addListener onBeforeRequestBlocking filter $
        \ (OnBeforeRequestDetails details) -> do
            Console.log "woo"
            Console.log $ "url is " <> details.url
            if details.url == "http://localhost:9999/base"
            then pure $ redirectUrl := "http://localhost:9999/base.jpg"
            else pure mempty
