{-# language OverloadedStrings, ScopedTypeVariables #-}
module Network.Proxy where

import Blaze.ByteString.Builder (fromByteString)
import Data.ByteString.Lazy (toStrict)
import Network.HTTP.Types (status200)
import Network.Wai (requestHeaders)
import Network.Wai.Handler.Warp (run)
import Pipes ((>->), yield)
import Pipes.Wai (Flush(..), responseProducer)
import System.Random (randomRIO)
import qualified Network.Pipes as NP
import qualified Pipes.Prelude as P

server :: Int -> IO ()
server port = do
  let urls = map (\host -> "http://www." ++ host ++ "/") hosts
        where hosts = ["amazon.com", "apple.com", "bing.com"
                      , "duckduckgo.com", "ebay.com", "fotolog.com"
                      , "imgur.com", "netflix.com", "shutterstock.com"
                      , "twitter.com", "zappos.com", "zelda.com"]
  run port $ \req onResponse -> do
    ind <- randomRIO (0, (length urls) - 1)
    let res = do
          yield (urls !! ind) >-> NP.get >-> P.map (Chunk . fromByteString . toStrict)
          yield Flush
    onResponse (responseProducer status200 (requestHeaders req) res)
