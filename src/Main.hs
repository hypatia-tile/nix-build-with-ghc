module Main where

import Tiny
  ( double
  , greeting
  , square
  )

main :: IO ()
main = do
  putStrLn greeting
  print (double 21)
  print (square 12)
