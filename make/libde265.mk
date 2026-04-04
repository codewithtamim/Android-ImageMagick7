# libde265 static library (HEVC decode for libheif / HEIC)
# LOCAL_PATH = Android-ImageMagick7 repo root (set by Android.mk before include)

include $(CLEAR_VARS)

LOCAL_MODULE := libde265
LOCAL_ARM_MODE := arm

DE265_TOP := $(LOCAL_PATH)/libde265-1.0.15
DE265_ROOT := $(DE265_TOP)/libde265

LOCAL_CPPFLAGS := -std=c++11 -frtti -fexceptions \
    -DLIBDE265_EXPORTS \
    -DHAVE_MALLOC_H \
    -Wno-unused-parameter -Wno-sign-compare

LOCAL_C_INCLUDES := \
    $(DE265_TOP) \
    $(DE265_ROOT)

LOCAL_EXPORT_C_INCLUDES := $(DE265_TOP)

LOCAL_SRC_FILES := \
    libde265-1.0.15/libde265/alloc_pool.cc \
    libde265-1.0.15/libde265/bitstream.cc \
    libde265-1.0.15/libde265/cabac.cc \
    libde265-1.0.15/libde265/configparam.cc \
    libde265-1.0.15/libde265/contextmodel.cc \
    libde265-1.0.15/libde265/de265.cc \
    libde265-1.0.15/libde265/deblock.cc \
    libde265-1.0.15/libde265/decctx.cc \
    libde265-1.0.15/libde265/dpb.cc \
    libde265-1.0.15/libde265/en265.cc \
    libde265-1.0.15/libde265/fallback-dct.cc \
    libde265-1.0.15/libde265/fallback-motion.cc \
    libde265-1.0.15/libde265/fallback.cc \
    libde265-1.0.15/libde265/image-io.cc \
    libde265-1.0.15/libde265/image.cc \
    libde265-1.0.15/libde265/intrapred.cc \
    libde265-1.0.15/libde265/md5.cc \
    libde265-1.0.15/libde265/motion.cc \
    libde265-1.0.15/libde265/nal-parser.cc \
    libde265-1.0.15/libde265/nal.cc \
    libde265-1.0.15/libde265/pps.cc \
    libde265-1.0.15/libde265/quality.cc \
    libde265-1.0.15/libde265/refpic.cc \
    libde265-1.0.15/libde265/sao.cc \
    libde265-1.0.15/libde265/scan.cc \
    libde265-1.0.15/libde265/sei.cc \
    libde265-1.0.15/libde265/slice.cc \
    libde265-1.0.15/libde265/sps.cc \
    libde265-1.0.15/libde265/threads.cc \
    libde265-1.0.15/libde265/transform.cc \
    libde265-1.0.15/libde265/util.cc \
    libde265-1.0.15/libde265/visualize.cc \
    libde265-1.0.15/libde265/vps.cc \
    libde265-1.0.15/libde265/vui.cc \
    libde265-1.0.15/libde265/encoder/encoder-core.cc \
    libde265-1.0.15/libde265/encoder/encoder-types.cc \
    libde265-1.0.15/libde265/encoder/encoder-params.cc \
    libde265-1.0.15/libde265/encoder/encoder-context.cc \
    libde265-1.0.15/libde265/encoder/encoder-syntax.cc \
    libde265-1.0.15/libde265/encoder/encoder-intrapred.cc \
    libde265-1.0.15/libde265/encoder/encoder-motion.cc \
    libde265-1.0.15/libde265/encoder/encpicbuf.cc \
    libde265-1.0.15/libde265/encoder/sop.cc \
    libde265-1.0.15/libde265/encoder/algo/algo.cc \
    libde265-1.0.15/libde265/encoder/algo/cb-intra-inter.cc \
    libde265-1.0.15/libde265/encoder/algo/cb-interpartmode.cc \
    libde265-1.0.15/libde265/encoder/algo/cb-intrapartmode.cc \
    libde265-1.0.15/libde265/encoder/algo/cb-mergeindex.cc \
    libde265-1.0.15/libde265/encoder/algo/cb-skip.cc \
    libde265-1.0.15/libde265/encoder/algo/cb-split.cc \
    libde265-1.0.15/libde265/encoder/algo/coding-options.cc \
    libde265-1.0.15/libde265/encoder/algo/ctb-qscale.cc \
    libde265-1.0.15/libde265/encoder/algo/pb-mv.cc \
    libde265-1.0.15/libde265/encoder/algo/tb-intrapredmode.cc \
    libde265-1.0.15/libde265/encoder/algo/tb-rateestim.cc \
    libde265-1.0.15/libde265/encoder/algo/tb-split.cc \
    libde265-1.0.15/libde265/encoder/algo/tb-transform.cc \

LOCAL_LDLIBS := -llog -lz

ifeq ($(LIBHEIF_ENABLED),true)
    include $(BUILD_STATIC_LIBRARY)
endif
