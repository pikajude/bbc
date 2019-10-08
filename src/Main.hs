{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE RecursiveDo #-}

module Main where

import           Reflex.Dom
import           Control.Monad
import qualified Data.Text                     as T
import qualified Data.Text.Read                as T
import           Control.Lens
import qualified Data.Map                      as M

import           Character
import           Origin
import           Stats

origins = M.fromDistinctAscList
  [ (o, Origin.name o) | o <- [minBound .. maxBound :: Origin] ]

main :: IO ()
main = mainWidget $ mdo
  nameInput <- el "p" $ textInput def
  origInput <- el "p" $ dropdown Milquetoast (constDyn origins) def

  charStats <- statsInput origin0

  let name0   = fmap nonnull (nameInput ^. textInput_value)
      origin0 = origInput ^. dropdown_value
      char    = Character <$> name0 <*> origin0 <*> pure 0 <*> charStats

  display char
  where nonnull t = guard (not $ T.null t) >> Just t

statsInput origDyn = do
  let base = baseStats <$> origDyn
  vit0 <- statInput (vitality <$> base)
  return $ Stats <$> vit0 <*> pure 0 <*> pure 0 <*> pure 0 <*> pure 0 <*> pure 0
 where
  statInput sdyn = do
    s0 <- textInput
      (  def
      &  textInputConfig_inputType
      .~ "number"
      &  textInputConfig_attributes
      .~ ffor sdyn (\ s -> M.fromList [("min", T.pack (show s)), ("max", "99")])
      )
    return $ do
      v1 <- s0 ^. textInput_value
      v2 <- sdyn
      return $ case T.decimal v1 of
        Right (n, _) -> max v2 $ min 99 n
        _            -> v2
