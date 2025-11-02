const gobject = @import("gobject.zig");
const AppState = @import("../../core/state.zig").AppState;

// GTK-specific wrapper for core state
pub const AppStateObject = gobject.GObjectWrapper(AppState);

pub fn createAppState() *AppStateObject {
    return AppStateObject.create(AppState.init());
}
