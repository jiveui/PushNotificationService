#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "Utils.h"

static void pushnotificationservice_initialize()
{
    pushnotificationservice::Initialize();
}
DEFINE_PRIM(pushnotificationservice_initialize, 0);


extern "C" void pushnotificationservice_main () {

    val_int(0); // Fix Neko init

}
DEFINE_ENTRY_POINT (pushnotificationservice_main);
extern "C" int pushnotificationservice_register_prims () { return 0; }