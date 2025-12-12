# BtHelper
PRODUCT_PACKAGES += \
    BtHelper

# Extra Packages
PRODUCT_PACKAGES += \
    GameSpace

# Enable blur
TARGET_ENABLE_BLUR ?= true
ifeq ($(TARGET_ENABLE_BLUR),true)
PRODUCT_SYSTEM_PROPERTIES += \
    ro.custom.blur.enable=true \
    persist.sysui.disableBlur=false \
    ro.surface_flinger.supports_background_blur=1
else
PRODUCT_SYSTEM_PROPERTIES += \
    ro.custom.blur.enable=false \
    persist.sysui.disableBlur=true \
    ro.surface_flinger.supports_background_blur=0
endif

# FaceUnlock
ifneq ($(TARGET_FACE_UNLOCK_SUPPORTED),false)
PRODUCT_PACKAGES += \
    FaceUnlock

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.face.sense_service=true

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/android.hardware.biometrics.face.xml
endif

# Pixel Clocks
WITH_GMS := true
$(call inherit-product, vendor/pixel/clocks/products/clocks.mk)

# Pixel Sounds
$(call inherit-product, vendor/pixel/sounds/products/sounds.mk)

# Pixel GMS
$(call inherit-product, vendor/pixel/gms/products/gms.mk)

# Pixel Launcher
ifeq ($(TARGET_INCLUDE_PIXEL_LAUNCHER),true)
$(call inherit-product, vendor/pixel/launcher/products/launcher.mk)
$(call inherit-product, vendor/pixel/themepicker/products/themepicker.mk)
endif
