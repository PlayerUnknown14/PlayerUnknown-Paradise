/// Helper to figure out if an organ is organic
#define IS_ORGANIC_ORGAN(organ) (organ.organ_flags & ORGAN_ORGANIC)
/// Helper to figure out if an organ is robotic
#define IS_ROBOTIC_ORGAN(organ) (organ.organ_flags & ORGAN_ROBOTIC)

/// List of organ flags that can not be bioscrambled
#define ORGAN_BIOSCRAMBLE_INCOMPATIBLE (ORGAN_ROBOTIC | ORGAN_MINERAL)
/// Check to see if an organ can be bioscrambled
#define ORGAN_CAN_BE_BIOSCRAMBLED(organ) (!(organ.organ_flags & ORGAN_BIOSCRAMBLE_INCOMPATIBLE) && !(organ.flags_1 & HOLOGRAM_1))

// Flags for the organ_flags var on /obj/item/organ
/// Organic organs, the default. Don't get affected by EMPs.
#define ORGAN_ORGANIC (1<<0)
/// Synthetic organs, or cybernetic organs. Reacts to EMPs and don't deteriorate or heal
#define ORGAN_ROBOTIC (1<<1)
/// Mineral organs. Snowflakey.
#define ORGAN_MINERAL (1<<2)
/// Frozen organs, don't deteriorate
#define ORGAN_FROZEN (1<<3)
/// Failing organs perform damaging effects until replaced or fixed, and typically they don't function properly either
#define ORGAN_FAILING (1<<4)
/// Synthetic organ affected by an EMP. Deteriorates over time.
#define ORGAN_EMP (1<<5)
/// Currently only the brain - Removing this organ KILLS the owner
#define ORGAN_VITAL (1<<6)
/// Can be eaten
#define ORGAN_EDIBLE (1<<7)
/// Can't be removed using surgery or other common means
#define ORGAN_UNREMOVABLE (1<<8)
/// Can't be seen by scanners, doesn't anger body purists
#define ORGAN_HIDDEN (1<<9)
/// Has the organ already been inserted inside someone
#define ORGAN_VIRGIN (1<<10)
/// ALWAYS show this when scanned by advanced scanners, even if it is totally healthy
#define ORGAN_PROMINENT (1<<11)
/// An organ that is ostensibly dangerous when inside a body
#define ORGAN_HAZARDOUS (1<<12)
/// This is an external organ, not an inner one. Used in several checks.
#define ORGAN_EXTERNAL (1<<13)
/// This is a ghost organ, which can be used for wall phasing.
#define ORGAN_GHOST (1<<14)
/// This is a mutant organ, having this makes you a -derived mutant to health analyzers.
#define ORGAN_MUTANT (1<<15)
/// The organ has been chomped or otherwise rendered unusable.
#define ORGAN_UNUSABLE (1<<16)

/// Organ flags that correspond to bodytypes
#define ORGAN_TYPE_FLAGS (ORGAN_ORGANIC | ORGAN_ROBOTIC | ORGAN_MINERAL | ORGAN_GHOST)

/// Scarring on the right eye
#define RIGHT_EYE_SCAR (1<<0)
/// Scarring on the left eye
#define LEFT_EYE_SCAR (1<<1)

/// Helper to figure out if a limb is organic
#define IS_ORGANIC_LIMB(limb) (limb.bodytype & BODYTYPE_ORGANIC)
/// Helper to figure out if a limb is robotic
#define IS_ROBOTIC_LIMB(limb) (limb.bodytype & BODYTYPE_ROBOTIC)
/// Helper to figure out if a limb is a peg limb
#define IS_PEG_LIMB(limb) (limb.bodytype & BODYTYPE_PEG)

/// Is the bodypart a stump
#define IS_STUMP(limb) (limb.bodypart_flags & BODYPART_STUMP)

// Flags for the bodypart_flags var on /obj/item/bodypart
/// Bodypart cannot be dismembered or amputated
#define BODYPART_UNREMOVABLE (1<<0)
/// Bodypart is a pseudopart (like a chainsaw arm)
#define BODYPART_PSEUDOPART (1<<1)
/// Bodypart did not match the owner's default bodypart limb_id when surgically implanted
#define BODYPART_IMPLANTED (1<<2)
/// Bodypart never displays as a husk
#define BODYPART_UNHUSKABLE (1<<3)
/// Bodypart has never been added to a mob
#define BODYPART_VIRGIN (1<<4)
/// Not a full bodypart, but in fact is part of a missing limb
#define BODYPART_STUMP (1<<5)

// Bodypart change blocking flags
///Bodypart does not get replaced during set_species()
#define BP_BLOCK_CHANGE_SPECIES (1<<0)


// Used in surgery step to determine how blood should be spread to the doc
/// Don't splash any blood.
#define SURGERY_BLOODSPREAD_NONE 0
/// Cover the surgeon's hands in blood.
#define SURGERY_BLOODSPREAD_HANDS 1
/// Cover the surgeon's body in blood.
#define SURGERY_BLOODSPREAD_FULLBODY 2

// The type of surgeries that an initiator can start.
// Note that this doesn't apply for surgeries applied on missing organs.
/// An initiator with this can start surgeries on organic organs. Make sure that anything that can be sharp gets this as well.
#define SURGERY_INITIATOR_ORGANIC (1<<0)
/// An initiator with this can start surgeries on robotic organs.
#define SURGERY_INITIATOR_ROBOTIC (1<<1)

// How "open" an organ is.

/// Closed up.
#define ORGAN_CLOSED 0

// Different defines for different organ types, though both can still reference ORGAN_CLOSED
/// An organic limb that's been opened, at least once.
#define ORGAN_ORGANIC_OPEN 1
/// An organ that's encased, probably with bone, where that casing has been cut through.
#define ORGAN_ORGANIC_ENCASED_OPEN 2

/// Synthetic organ that's been unscrewed.
#define ORGAN_SYNTHETIC_LOOSENED 3
/// Synthetic organ that's had its panel opened.
#define ORGAN_SYNTHETIC_OPEN 4

// Return defines for surgery steps

/// Return this from begin_step() to abort the step and not try the surgery.
#define SURGERY_BEGINSTEP_ABORT (-1)

/// Return this from begin_step() to skip the current step entirely and proceed to the next one.
/// Use this if you would end up leaving someone in an invalid state.
#define SURGERY_BEGINSTEP_SKIP (1)

// Return these from end_step/fail_step to indicate the next move

/// The surgery step was not completed for some reason, and the next action will again be on this step.
#define SURGERY_STEP_INCOMPLETE 0
/// The surgery step was completed, and the surgery should continue to the next step.
#define SURGERY_STEP_CONTINUE 1
/// This step will automatically be retried without question as long as this is returned.
/// Be very cautious with this one! Make sure that any flow where this is used has an exit condition where something else will be returned.
/// Otherwise, the user will be stuck in a loop!
#define SURGERY_STEP_RETRY_ALWAYS 2
/// This surgery step will be conditionally retried, so long as the surgery step's can_repeat() proc returns TRUE.
/// Otherwise, it'll behave just like SURGERY_STEP_INCOMPLETE.
#define SURGERY_STEP_RETRY 3

// Return values for surgery_step.initiate().
// Before you ask, yes, we need another definition for surgery steps here, since these control how we will act on the attack-chain
// side of things.
// Unless you're changing the mechanics of the surgery attack chain, you almost surely don't want to use these, and should
// instead be using the above SURGERY_STEP_X defines.

/// The surgery initiation isn't even going to be started. If you're working with the attack chain, this is probably what you'll be using.
#define SURGERY_INITIATE_CONTINUE_CHAIN 0

/// The surgery initiaition was a success. We're advancing the current surgery.
#define SURGERY_INITIATE_SUCCESS 1

/// The surgery initiation was interrupted, or for some reason never completed. We don't want to return FALSE to the attack chain, though.
#define SURGERY_INITIATE_FAILURE 2

/// The surgery never reached (or finished) the do_after. Go back to the state we were in before this even happened.
#define SURGERY_INITIATE_INTERRUPTED 3

/// Damage above this value must be repaired with surgery.
#define ROBOLIMB_SELF_REPAIR_CAP 60

// Defib stats
/// Past this much time the patient is unrecoverable (in deciseconds).
#define DEFIB_TIME_LIMIT (300 SECONDS)
/// Brain damage starts setting in on the patient after some time left rotting.
#define DEFIB_TIME_LOSS (60 SECONDS)
