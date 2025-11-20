//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <qr_bar_code/qr_bar_code_plugin.h>
#include <rive_native/rive_native_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) qr_bar_code_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "QrBarCodePlugin");
  qr_bar_code_plugin_register_with_registrar(qr_bar_code_registrar);
  g_autoptr(FlPluginRegistrar) rive_native_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "RiveNativePlugin");
  rive_native_plugin_register_with_registrar(rive_native_registrar);
}
