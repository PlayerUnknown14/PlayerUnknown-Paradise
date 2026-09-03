// Defines for the construction component
#define FORWARD -1
#define BACKWARD 1

#define CONSTRUCTION_TOOL_BEHAVIOURS list(TOOL_CROWBAR, TOOL_SCREWDRIVER, TOOL_WELDER, TOOL_WRENCH)

//default_unfasten_wrench() return defines
/// Return if unfasten failed, but allow attack chain to continue
#define CANT_UNFASTEN 0
/// Return if unfasten failed, and stop attack chain
#define FAILED_UNFASTEN 1
/// Return if unfasten succeeded
#define SUCCESSFUL_UNFASTEN 2
