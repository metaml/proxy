{-# language OverloadedStrings, ScopedTypeVariables #-}
module Network.Pipes where

import Control.Exception (try, throwIO)
import Control.Lens ((^.))
import Control.Monad (unless)
import Data.ByteString.Lazy (ByteString, toStrict)
import Pipes (Consumer, Pipe, (>->), (>~), await, lift, yield)
import qualified GHC.IO.Exception as G
import qualified Network.Wreq as W

get :: Pipe String ByteString IO ()
get = do
  url <- await
  res <- lift $ W.get url
  yield $ res ^. W.responseBody

printc :: Consumer ByteString IO ()
printc = do
  bstr <- await
  e <- lift $ try (print bstr)
  case e of
    -- gracefully terminate if we got a broken pipe error
    Left e@(G.IOError { G.ioe_type = t}) -> lift $ unless (t == G.ResourceVanished) $ throwIO e
    -- otherwise loop
    Right () -> return ()
