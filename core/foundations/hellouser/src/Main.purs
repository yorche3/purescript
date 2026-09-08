module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Node.ReadLine ( createConsoleInterface, noCompletion, question, close)

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion
  interface # question "Enter your name: " \name -> do
    log $ "Hello, " <> name <> "!"
    close interface
