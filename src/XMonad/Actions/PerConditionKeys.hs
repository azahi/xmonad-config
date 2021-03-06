-- |
-- Module      : XMonad.Actions.PerConditionKeys
-- Copyright   : (c) 2018-2020 Azat Bahawi <azahi@teknik.io>
-- License     : BSD3-style (see LICENSE)
-- Maintainer  : Azat Bahawi <azahi@teknik.io>
-- Stability   : unstable
-- Portability : unportable
--

module XMonad.Actions.PerConditionKeys
  ( XCond(..)
  , chooseAction
  , bindOn
  ) where

import           Data.List
import           XMonad
import qualified XMonad.StackSet               as S

data XCond = WS | LD

chooseAction :: XCond -> (String -> X ()) -> X ()
chooseAction WS f = withWindowSet (f . S.currentTag)
chooseAction LD f =
  withWindowSet (f . description . S.layout . S.workspace . S.current)

bindOn :: XCond -> [(String, X ())] -> X ()
bindOn xc bindings = chooseAction xc chooser
 where
  chooser x = case find ((x ==) . fst) bindings of
    Just (_, action) -> action
    Nothing          -> case find (("" ==) . fst) bindings of
      Just (_, action) -> action
      Nothing          -> return ()
