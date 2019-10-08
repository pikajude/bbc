{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE RecursiveDo #-}

module Main where

import           Reflex.Dom
import           Control.Monad
import           Data.Text                      ( Text )
import qualified Data.Text                     as T
import qualified Data.Text.Read                as T
import           Numeric.Natural
import           Control.Lens
import           Control.Applicative            ( liftA2 )
import qualified Data.Map                      as M

import           Stats

data Character = Character
  { name :: Maybe Text
  , origin :: Origin
  , insight :: Natural
  , stats :: Stats
  } deriving Show

data Origin
  = Milquetoast | LoneSurvivor | TroubledChildhood
  | ViolentPast | Professional | MilitaryVeteran
  | NobleScion | CruelFate | WasteOfSkin
  deriving (Eq, Bounded, Ord, Show, Enum)

originStats Milquetoast       = Stats 11 10 12 10 9 8
originStats LoneSurvivor      = Stats 14 11 11 10 7 7
originStats TroubledChildhood = Stats 9 14 9 13 6 9
originStats ViolentPast       = Stats 12 11 15 9 6 7
originStats Professional      = Stats 9 12 9 15 7 8
originStats MilitaryVeteran   = Stats 10 10 14 13 7 6
originStats NobleScion        = Stats 7 8 9 13 14 9
originStats CruelFate         = Stats 10 12 10 9 5 14
originStats WasteOfSkin       = Stats 10 9 10 9 7 9

origins = M.fromDistinctAscList
  [ (o, T.pack (show o)) | o <- [minBound .. maxBound :: Origin] ]

main :: IO ()
main = mainWidget $ mdo
  nameInput <- el "p" $ textInput def
  origInput <- el "p" $ dropdown Milquetoast (constDyn origins) def
  el "p"
    $ elDynAttr
        "input"
        (ffor oStats $ \o' -> M.fromList
          [("value", T.pack (show $ level o')), ("disabled", "disabled")]
        )
    $ return ()

  vit0 <- el "p" $ do
    el "label" $ text "Vitality"
    integralInput (constDyn (1, 99)) (vit <$> updated oStats)

  let o      = origInput ^. dropdown_value
      oStats = originStats <$> o

  let
    char =
      Character
        <$> (nonnull <$> nameInput ^. textInput_value)
        <*> o
        <*> pure 0
        <*> (Stats <$> vit0 <*> pure 0 <*> pure 0 <*> pure 0 <*> pure 0 <*> pure
              0
            )

  display $ liftA2 (,) char vit0
  where nonnull t = guard (not $ T.null t) >> Just t

integralInput
  :: ( Integral a
     , Show a
     , DomBuilder t m
     , PostBuild t m
     , DomBuilderSpace m ~ GhcjsDomSpace
     )
  => Dynamic t (a, a)
  -> Event t a
  -> m (Dynamic t a)
integralInput b0 setval = do
  ti <- textInput
    (  def
    &  textInputConfig_inputType
    .~ "number"
    &  textInputConfig_setValue
    .~ fmap (T.pack . show) setval
    &  textInputConfig_attributes
    .~ ffor
         b0
         (\(min0, max0) -> M.fromList
           [("max", T.pack (show max0)), ("min", T.pack (show min0))]
         )
    )
  return $ do
    txt          <- ti ^. textInput_value
    (min0, max0) <- b0
    return $ case T.decimal txt of
      Right (n, _) -> max min0 $ min max0 n
      _            -> min0
