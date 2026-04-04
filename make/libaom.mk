# Prebuilt static libaom (AV1) for libheif AVIF encode/decode.
# Generate artifacts with: ./scripts/build-libaom-android.sh

ifeq ($(LIBHEIF_ENABLED),true)

AOM_PREBUILT := $(LOCAL_PATH)/prebuilt-libaom/$(TARGET_ARCH_ABI)/libaom.a
ifeq ($(wildcard $(AOM_PREBUILT)),)
    $(error Missing $(AOM_PREBUILT). Run: ./scripts/build-libaom-android.sh (needs cmake, ninja, NDK))
endif

include $(CLEAR_VARS)
LOCAL_MODULE := libaom
LOCAL_SRC_FILES := prebuilt-libaom/$(TARGET_ARCH_ABI)/libaom.a
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/prebuilt-libaom/include
include $(PREBUILT_STATIC_LIBRARY)

endif
