{-# LANGUAGE DerivingStrategies #-}

module Stats where

type Stat = Int

data Stats = Stats
  { vitality :: Stat
  , endurance :: Stat
  , strength :: Stat
  , skill :: Stat
  , bloodtinge :: Stat
  , arcane :: Stat
  } deriving (Show, Eq, Ord)

characterLevel (Stats a b c d e f) = a + b + c + d + e + f - 50
