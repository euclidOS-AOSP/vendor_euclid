# Bootanimation
ifeq ($(TARGET_BOOT_ANIMATION_RES),1080)
    PRODUCT_COPY_FILES += \
        vendor/euclid/bootanimation/bootanimation_1080.zip:$(TARGET_COPY_OUT_PRODUCT)/media/bootanimation.zip
else ifeq ($(TARGET_BOOT_ANIMATION_RES),720)
    PRODUCT_COPY_FILES += \
        vendor/euclid/bootanimation/bootanimation_720.zip:$(TARGET_COPY_OUT_PRODUCT)/media/bootanimation.zip
else
    ifeq ($(TARGET_BOOT_ANIMATION_RES),)
        $(warning TARGET_BOOT_ANIMATION_RES is undefined, defaulting to 1080p)
    else
        $(warning Current bootanimation resolution "$(TARGET_BOOT_ANIMATION_RES)" not supported, forcing 1080p)
    endif
    PRODUCT_COPY_FILES += \
        vendor/euclid/bootanimation/bootanimation_1080.zip:$(TARGET_COPY_OUT_PRODUCT)/media/bootanimation.zip
endif
