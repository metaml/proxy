{-# language OverloadedStrings, ScopedTypeVariables #-}
module Network.Pipes where

import Control.Exception (try, throwIO)
import Control.Lens ((^.))
import Control.Monad (unless)
import Control.Concurrent.Cache (Cache, fetch)
import Data.ByteString.Lazy (ByteString, toStrict)
import Pipes (Consumer, Pipe, (>->), (>~), await, lift, yield)
import Network.Wreq (Response, defaults, getWith, responseBody)
import Network.Wreq.Types (redirects)
import qualified GHC.IO.Exception as G


get :: Pipe (String, Cache (Response ByteString)) ByteString IO ()
get = do
  (url, cache) <- await
  let opts = defaults {redirects = 3}
  res <- lift $ fetch cache (getWith opts url)
  yield $ res ^. responseBody

printc :: Consumer ByteString IO ()
printc = do
  bstr <- await
  e <- lift $ try (print bstr)
  case e of
    -- gracefully terminate if we got a broken pipe error
    Left e@(G.IOError { G.ioe_type = t}) -> lift $ unless (t == G.ResourceVanished) $ throwIO e
    -- otherwise loop
    Right () -> return ()
