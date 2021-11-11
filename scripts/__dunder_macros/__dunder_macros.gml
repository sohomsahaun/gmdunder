#macro DUNDER_VERSION "v0.9.9"

// This is the name of the global var used to facilitate init room injection
#macro DUNDER_FIRST_ROOM_GLOBAL "__dunder_first_room_callback__"

// This is used to make it easier to register inheritence
#macro REGISTER_SUBTYPE static __bases__ = __bases_add__

/// ******
/// ****** Logging macros
/// ******

// Log severity levels. These match the sentry level macros. so are interchangeable
#macro LOG_FATAL "fatal"
#macro LOG_ERROR "error"
#macro LOG_WARNING "warning"
#macro LOG_INFO "info"
#macro LOG_DEBUG "debug"

// Setting this to True globally disables logging, causing the logger to do nothing when called
// NOTE: this includes not sending sentry reports, or adding values to the sentry breadcrumbs.
// If you want to turn off log outputs, but still send sentry reports, use set_levels() with
// no arguments
#macro LOGGING_DISABLED false

// Width of the padding used in the output
#macro LOGGING_PAD_WIDTH 48