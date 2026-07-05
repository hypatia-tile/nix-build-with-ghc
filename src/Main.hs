module Main where

import System.Console.ANSI
  ( Color (Green)
  , ColorIntensity (Vivid)
  , ConsoleLayer (Foreground)
  , SGR (Reset, SetColor)
  , setSGR
  )
import Tiny
  ( double
  , greeting
  , square
  )

main :: IO ()
main = do
  setSGR [SetColor Foreground Vivid Green]
  putStrLn greeting
  print (double 21)
  print (square 12)
  setSGR [Reset]
