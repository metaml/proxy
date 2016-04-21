module Main where

import Network.Proxy (server)

main :: IO ()
main = server 8080
