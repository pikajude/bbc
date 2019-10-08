{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Stats where

import           Numeric.Natural
import           Control.Exception

newtype Stat = Stat { unStat :: Natural }
  deriving newtype (Show, Eq, Ord, Enum, Real, Integral)

bound :: (Ord p, Num p, Show p) => p -> p
bound n | n < 0     = error $ "underflow: " ++ show n
        | n > 99    = error $ "overflow: " ++ show n
        | otherwise = n

instance Bounded Stat where
  minBound = Stat 0
  maxBound = Stat 99

instance Num Stat where
  fromInteger x = Stat $ fromInteger $ bound x

  Stat x + Stat y = Stat $ bound (x + y)
  Stat x * Stat y = Stat $ bound (x * y)
  abs = id
  negate _ = throw Underflow
  signum _ = 1
  Stat x - Stat y = Stat $ bound (x - y)

data Stats = Stats
  { vit :: Stat
  , end :: Stat
  , str :: Stat
  , skl :: Stat
  , bt :: Stat
  , arc :: Stat
  } deriving (Show, Eq, Ord)

level (Stats a b c d e f) = a + b + c + d + e + f - 50
