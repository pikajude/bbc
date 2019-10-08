{-# LANGUAGE OverloadedStrings #-}

module Origin where

import           Stats

data Origin
  = Milquetoast | LoneSurvivor | TroubledChildhood
  | ViolentPast | Professional | MilitaryVeteran
  | NobleScion | CruelFate | WasteOfSkin
  deriving (Eq, Bounded, Ord, Show, Enum)

name Milquetoast       = "Milquetoast"
name LoneSurvivor      = "Lone Survivor"
name TroubledChildhood = "Troubled Childhood"
name ViolentPast       = "Violent Past"
name Professional      = "Professional"
name MilitaryVeteran   = "Military Veteran"
name NobleScion        = "Noble Scion"
name CruelFate         = "Cruel Fate"
name WasteOfSkin       = "Waste of Skin"

baseStats Milquetoast       = Stats 11 10 12 10 9 8
baseStats LoneSurvivor      = Stats 14 11 11 10 7 7
baseStats TroubledChildhood = Stats 9 14 9 13 6 9
baseStats ViolentPast       = Stats 12 11 15 9 6 7
baseStats Professional      = Stats 9 12 9 15 7 8
baseStats MilitaryVeteran   = Stats 10 10 14 13 7 6
baseStats NobleScion        = Stats 7 8 9 13 14 9
baseStats CruelFate         = Stats 10 12 10 9 5 14
baseStats WasteOfSkin       = Stats 10 9 10 9 7 9
