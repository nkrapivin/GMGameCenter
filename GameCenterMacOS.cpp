/* GameCenterMacOS.cpp */
#include <cstddef>
#include <cstdint>
#define  GMExport __attribute__((visibility("default")))

typedef void(*GMCreateAsyncEventWithDSMap_t)(
    int         iDSMapIndex,
    int         iEventSubtype
);

typedef int (*GMCreateDSMap_t)(
    int         iNumElements /* = 0 */,
    ... /*
    const char* pcszNameStringN,
    double      dValueN,
    const char* pcszValueStringN */
);

typedef bool(*GMDSMapAddDouble_t)(
    int         iDSMapIndex,
    const char* pcszKeyString,
    double      dValue
);

typedef bool(*GMDSMapAddString_t)(
    int         iDSMapIndex,
    const char* pcszKeyString,
    const char* pcszValueString
);

GMExport GMCreateAsyncEventWithDSMap_t GMCreateAsyncEventWithDSMap = NULL;
GMExport GMCreateDSMap_t               GMCreateDSMap               = NULL;
GMExport GMDSMapAddDouble_t            GMDSMapAddDouble            = NULL;
GMExport GMDSMapAddString_t            GMDSMapAddString            = NULL;

GMExport void RegisterCallbacks(
    GMCreateAsyncEventWithDSMap_t pGMF1,
    GMCreateDSMap_t               pGMF2,
    GMDSMapAddDouble_t            pGMF3,
    GMDSMapAddString_t            pGMF4) {
    /* just assign the function pointers to static variables. */
    /* the actual exported implementation is below */
    GMCreateAsyncEventWithDSMap = pGMF1;
    GMCreateDSMap               = pGMF2;
    GMDSMapAddDouble            = pGMF3;
    GMDSMapAddString            = pGMF4;
}

GMExport int CreateDsMap(
    int _num,
    ... /* :) */) {
    /* let's hope this will work correctly... */
    return GMCreateDSMap(_num /* :) */);
}

GMExport void CreateAsynEventWithDSMap(
    int dsmapindex,
    int event_index) {
    GMCreateAsyncEventWithDSMap(dsmapindex, event_index);
}

GMExport extern "C" void dsMapAddDouble(
    int _dsMap,
    char* _key,
    double _value) {
    GMDSMapAddDouble(_dsMap, _key, _value);
}

GMExport extern "C" void dsMapAddString(
    int _dsMap,
    char* _key,
    char* _value
) {
    GMDSMapAddString(_dsMap, _key, _value);
}


