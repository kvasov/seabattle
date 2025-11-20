//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <qr_bar_code/qr_bar_code_plugin_c_api.h>
#include <rive_native/rive_native_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  QrBarCodePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("QrBarCodePluginCApi"));
  RiveNativePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("RiveNativePlugin"));
}
