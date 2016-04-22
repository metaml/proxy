{-# LANGUAGE OverloadedStrings #-}
module Echo (server) where

import Blaze.ByteString.Builder (fromByteString)
import Network.HTTP.Types (Status(..))
import Network.Wai.Handler.Warp
import Pipes
import Pipes.Wai
import qualified Pipes.Prelude as Pipes

server = run 8000 $ \request onResponse -> do
  let p = do
        producerRequestBody request >-> Pipes.map (Chunk . fromByteString)
        yield Flush
  onResponse (responseProducer (Status 200 "") [] p)
