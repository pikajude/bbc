{-# LANGUAGE TemplateHaskell #-}

module Character where

import           Data.Text                      ( Text )
import           Data.Aeson.TH

import           Origin
import           Stats

data Character = Character
  { name :: Maybe Text
  , origin :: Origin
  , insight :: Int
  , stats :: Stats
  } deriving (Show, Ord, Eq)

characterLevel Character { stats = Stats a b c d e f } =
  a + b + c + d + e + f - 50

deriveJSON defaultOptions ''Character
