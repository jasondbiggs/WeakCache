
#include "mathlink.h"
#include "WolframLibrary.h"
#include "string"

#include <cstdlib>

namespace {

std::string functionSymbol = "iCleanup";

}

void callCleanupFunction(WolframLibraryData libData, mint wlid) {
	MLINK link = libData->getMathLink(libData);
	MLPutFunction(link, "EvaluatePacket", 1);
		MLPutFunction(link, functionSymbol.c_str(), 1);
			MLPutInteger(link, wlid);
	libData->processMathLink(link);
	int pkt = MLNextPacket(link);
	if (pkt == RETURNPKT) {
		MLNewPacket(link);
	}
}


extern "C" DLLEXPORT int setFunctionName(WolframLibraryData libData, mint Argc, MArgument * Args, MArgument Res) {
	const char* name = MArgument_getUTF8String(Args[0]);
	functionSymbol = name;
	return LIBRARY_NO_ERROR;
}


DLLEXPORT void manage_ExpressionCleanup(WolframLibraryData libData, mbool mode, mint id)
{
	if (mode == 0) {
		// creation, do nothing
	} else {
		callCleanupFunction(libData, id );
	}
}


/* Initialize Library */
EXTERN_C DLLEXPORT int WolframLibrary_initialize( WolframLibraryData libData) {
	return (*libData->registerLibraryExpressionManager)("ExpressionCleanup", &manage_ExpressionCleanup);
}

/* Uninitialize Library */
EXTERN_C DLLEXPORT void WolframLibrary_uninitialize( WolframLibraryData libData) {
	int err = (*libData->unregisterLibraryExpressionManager)("ExpressionCleanup");
}

EXTERN_C DLLEXPORT mint WolframLibrary_getVersion() {
	return WolframLibraryVersion;
}
