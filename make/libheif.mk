# libheif static library with built-in libde265 HEIC decode (no dynamic plugins)

include $(CLEAR_VARS)

LOCAL_MODULE := libheif
LOCAL_ARM_MODE := arm

HEIF_TOP := $(LOCAL_PATH)/libheif-1.23.6
HEIF_SRC := $(HEIF_TOP)/libheif
HEIF_API := $(HEIF_SRC)/api
HEIF_INC := $(LOCAL_PATH)/make/include

LOCAL_CPPFLAGS := -std=c++20 -frtti -fexceptions \
    -DLIBHEIF_EXPORTS \
    -DHAVE_VISIBILITY \
    -DHAVE_ZLIB=1 \
    -DHAVE_LIBDE265=1 \
    -DHAVE_AOM_DECODER=1 \
    -DHAVE_AOM_ENCODER=1 \
    -DPLUGIN_AOM_DECODER=0 \
    -DPLUGIN_AOM_ENCODER=0 \
    -DENABLE_MULTITHREADING_SUPPORT=1 \
    -DENABLE_PARALLEL_TILE_DECODING=0 \
    -DENABLE_PLUGIN_LOADING=0 \
    -DIS_BIG_ENDIAN=0 \
    -DHAVE_UNISTD_H \
    -Wno-unused-parameter -Wno-sign-compare -Wno-deprecated-declarations

LOCAL_C_INCLUDES := \
    $(HEIF_INC) \
    $(HEIF_SRC) \
    $(HEIF_API) \
    $(LOCAL_PATH)/prebuilt-libaom/include \

LOCAL_EXPORT_C_INCLUDES := \
    $(HEIF_INC) \
    $(HEIF_API) \

# libheif internal includes use "libheif/heif.h" from api tree
LOCAL_SRC_FILES := \
    libheif-1.23.6/libheif/bitstream.cc \
    libheif-1.23.6/libheif/box.cc \
    libheif-1.23.6/libheif/error.cc \
    libheif-1.23.6/libheif/context.cc \
    libheif-1.23.6/libheif/file.cc \
    libheif-1.23.6/libheif/file_layout.cc \
    libheif-1.23.6/libheif/image/pixelimage.cc \
    libheif-1.23.6/libheif/image/image_description.cc \
    libheif-1.23.6/libheif/plugin_registry.cc \
    libheif-1.23.6/libheif/nclx.cc \
    libheif-1.23.6/libheif/security_limits.cc \
    libheif-1.23.6/libheif/init.cc \
    libheif-1.23.6/libheif/logging.cc \
    libheif-1.23.6/libheif/compression.cc \
    libheif-1.23.6/libheif/compression_brotli.cc \
    libheif-1.23.6/libheif/compression_zlib.cc \
    libheif-1.23.6/libheif/common_utils.cc \
    libheif-1.23.6/libheif/region.cc \
    libheif-1.23.6/libheif/brands.cc \
    libheif-1.23.6/libheif/id_creator.cc \
    libheif-1.23.6/libheif/text.cc \
    libheif-1.23.6/libheif/api/libheif/heif.cc \
    libheif-1.23.6/libheif/api/libheif/heif_library.cc \
    libheif-1.23.6/libheif/api/libheif/heif_image.cc \
    libheif-1.23.6/libheif/api/libheif/heif_color.cc \
    libheif-1.23.6/libheif/api/libheif/heif_regions.cc \
    libheif-1.23.6/libheif/api/libheif/heif_plugin.cc \
    libheif-1.23.6/libheif/api/libheif/heif_properties.cc \
    libheif-1.23.6/libheif/api/libheif/heif_items.cc \
    libheif-1.23.6/libheif/api/libheif/heif_sequences.cc \
    libheif-1.23.6/libheif/api/libheif/heif_tai_timestamps.cc \
    libheif-1.23.6/libheif/api/libheif/heif_brands.cc \
    libheif-1.23.6/libheif/api/libheif/heif_metadata.cc \
    libheif-1.23.6/libheif/api/libheif/heif_aux_images.cc \
    libheif-1.23.6/libheif/api/libheif/heif_entity_groups.cc \
    libheif-1.23.6/libheif/api/libheif/heif_security.cc \
    libheif-1.23.6/libheif/api/libheif/heif_encoding.cc \
    libheif-1.23.6/libheif/api/libheif/heif_decoding.cc \
    libheif-1.23.6/libheif/api/libheif/heif_image_handle.cc \
    libheif-1.23.6/libheif/api/libheif/heif_context.cc \
    libheif-1.23.6/libheif/api/libheif/heif_tiling.cc \
    libheif-1.23.6/libheif/api/libheif/heif_components.cc \
    libheif-1.23.6/libheif/api/libheif/heif_uncompressed.cc \
    libheif-1.23.6/libheif/api/libheif/heif_text.cc \
    libheif-1.23.6/libheif/api/libheif/heif_omaf.cc \
    libheif-1.23.6/libheif/codecs/decoder.cc \
    libheif-1.23.6/libheif/codecs/encoder.cc \
    libheif-1.23.6/libheif/image-items/hevc.cc \
    libheif-1.23.6/libheif/codecs/hevc_boxes.cc \
    libheif-1.23.6/libheif/codecs/hevc_dec.cc \
    libheif-1.23.6/libheif/codecs/hevc_enc.cc \
    libheif-1.23.6/libheif/image-items/avif.cc \
    libheif-1.23.6/libheif/codecs/avif_enc.cc \
    libheif-1.23.6/libheif/codecs/avif_dec.cc \
    libheif-1.23.6/libheif/codecs/avif_boxes.cc \
    libheif-1.23.6/libheif/image-items/jpeg.cc \
    libheif-1.23.6/libheif/codecs/jpeg_boxes.cc \
    libheif-1.23.6/libheif/codecs/jpeg_dec.cc \
    libheif-1.23.6/libheif/codecs/jpeg_enc.cc \
    libheif-1.23.6/libheif/image-items/jpeg2000.cc \
    libheif-1.23.6/libheif/codecs/jpeg2000_dec.cc \
    libheif-1.23.6/libheif/codecs/jpeg2000_enc.cc \
    libheif-1.23.6/libheif/codecs/jpeg2000_boxes.cc \
    libheif-1.23.6/libheif/image-items/vvc.cc \
    libheif-1.23.6/libheif/codecs/vvc_dec.cc \
    libheif-1.23.6/libheif/codecs/vvc_enc.cc \
    libheif-1.23.6/libheif/codecs/vvc_boxes.cc \
    libheif-1.23.6/libheif/image-items/avc.cc \
    libheif-1.23.6/libheif/codecs/avc_boxes.cc \
    libheif-1.23.6/libheif/codecs/avc_dec.cc \
    libheif-1.23.6/libheif/codecs/avc_enc.cc \
    libheif-1.23.6/libheif/image-items/mask_image.cc \
    libheif-1.23.6/libheif/image-items/image_item.cc \
    libheif-1.23.6/libheif/image-items/grid.cc \
    libheif-1.23.6/libheif/image-items/overlay.cc \
    libheif-1.23.6/libheif/image-items/iden.cc \
    libheif-1.23.6/libheif/image-items/tiled.cc \
    libheif-1.23.6/libheif/color-conversion/colorconversion.cc \
    libheif-1.23.6/libheif/color-conversion/rgb2yuv.cc \
    libheif-1.23.6/libheif/color-conversion/rgb2yuv_sharp.cc \
    libheif-1.23.6/libheif/color-conversion/yuv2rgb.cc \
    libheif-1.23.6/libheif/color-conversion/rgb2rgb.cc \
    libheif-1.23.6/libheif/color-conversion/monochrome.cc \
    libheif-1.23.6/libheif/color-conversion/hdr_sdr.cc \
    libheif-1.23.6/libheif/color-conversion/alpha.cc \
    libheif-1.23.6/libheif/color-conversion/chroma_sampling.cc \
    libheif-1.23.6/libheif/color-conversion/bayer_bilinear.cc \
    libheif-1.23.6/libheif/sequences/seq_boxes.cc \
    libheif-1.23.6/libheif/sequences/chunk.cc \
    libheif-1.23.6/libheif/sequences/track.cc \
    libheif-1.23.6/libheif/sequences/track_visual.cc \
    libheif-1.23.6/libheif/sequences/track_metadata.cc \
    libheif-1.23.6/libheif/mini.cc \
    libheif-1.23.6/libheif/omaf_boxes.cc \
    libheif-1.23.6/libheif/plugins_unix.cc \
    libheif-1.23.6/libheif/plugins/decoder_libde265.cc \
    libheif-1.23.6/libheif/plugins/decoder_aom.cc \
    libheif-1.23.6/libheif/plugins/encoder_aom.cc \
    libheif-1.23.6/libheif/plugins/encoder_mask.cc \
    libheif-1.23.6/libheif/plugins/nalu_utils.cc \

LOCAL_STATIC_LIBRARIES := libde265 libaom
LOCAL_LDLIBS := -llog -lz

ifeq ($(LIBHEIF_ENABLED),true)
    include $(BUILD_STATIC_LIBRARY)
endif
