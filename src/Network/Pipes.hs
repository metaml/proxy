{-# language OverloadedStrings, ScopedTypeVariables #-}
module Network.Pipes where

import Blaze.ByteString.Builder (copyByteString, fromByteString)
import Control.Exception (try, throwIO)
import Control.Lens ((^.))
import Control.Monad (forever, unless)
import Data.ByteString.Lazy (ByteString, toStrict)
import Network.HTTP.Types (status200)
import Network.Wai (Application, pathInfo, requestHeaders, responseBuilder)
import Pipes (Consumer, Pipe, Producer, (>->), (>~), await, cat, lift, runEffect, yield)
import qualified GHC.IO.Exception as G
import qualified Network.Wreq as W
import qualified Pipes as P
import qualified Pipes.Prelude as P

get :: Pipe String ByteString IO ()
get = do
  url <- await
  res <- lift $ W.get url
  yield $ res ^. W.responseBody

ret :: Pipe ByteString ByteString IO ()
ret = do
  bs <- await
  yield bs

printc :: Consumer ByteString IO ()
printc = do
  bstr <- await
  e <- lift $ try (print bstr)
  case e of
    -- gracefully terminate if we got a broken pipe error
    Left e@(G.IOError { G.ioe_type = t}) -> lift $ unless (t == G.ResourceVanished) $ throwIO e
    -- otherwise loop
    Right () -> return ()
