# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/extra.mk)
$(call inherit-product-if-exists, vendor/extras/extras.mk)

# Allow vendor prebuilt repos to exclude themselves from bp scanning
-include $(sort $(wildcard vendor/*/*/exclude-bp.mk))

# Bootanimation
$(call inherit-product, vendor/euclid/config/bootanimation.mk)

PRODUCT_BRAND ?= euclidOS

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# Don't dexpreopt prebuilts
DONT_DEXPREOPT_PREBUILTS := true

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_PRODUCT_PROPERTIES += ro.adb.secure=0
else
ifdef WITH_ADB_INSECURE
# Forcebly disable ADB authentication
PRODUCT_PRODUCT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_PRODUCT_PROPERTIES += ro.adb.secure=1
endif

# Disable extra StrictMode features on all non-engineering builds
PRODUCT_PRODUCT_PROPERTIES += persist.sys.strictmode.disable=true
endif

# Allow OTA downgrades
PRODUCT_PRODUCT_PROPERTIES += \
    ro.ota.allow_downgrade=true

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.sip.voip.xml

# Enable the new fast charging threshold
PRODUCT_PRODUCT_PROPERTIES += \
    charging_string.apply_v2=true

# Enable Material Design 3 Expressive
PRODUCT_PRODUCT_PROPERTIES += \
    is_expressive_design_enabled=true

# Credential storage
PRODUCT_PACKAGES += \
    android.software.credentials.prebuilt.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_PRODUCT)/usr/keylayout/Vendor_045e_Product_0719.kl


# Enforce privapp-permissions whitelist
PRODUCT_PRODUCT_PROPERTIES += \
    ro.control_privapp_permissions=enforce

ART_BUILD_TARGET_NDEBUG := false
ART_BUILD_TARGET_DEBUG := false

# Flags
ifeq ($(TARGET_BUILD_VARIANT), user)
    # Strip the local variable table and the local variable type table to reduce
    # the size of the system image. This has no bearing on stack traces, but will
    # leave less information available via JDWP.
    PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true
    # Disable dexpreopt debug info
    WITH_DEXPREOPT_DEBUG_INFO := false
    # Reduce system server verbosity
    PRODUCT_SYSTEM_SERVER_DEBUG_INFO := false
    # Don't include art debug targets
    PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false
    # Always preopt extracted APKs to prevent extracting out of the APK for gms
    # modules.
    PRODUCT_ALWAYS_PREOPT_EXTRACTED_APK := true
endif

# Enable whole-program R8 Java optimizations for SystemUI and system_server,
# but also allow explicit overriding for testing and development.
SYSTEM_OPTIMIZE_JAVA ?= true
SYSTEMUI_OPTIMIZE_JAVA ?= true

# Disable dex2oat debug
USE_DEX2OAT_DEBUG := false

# Enable whole-program R8 Java optimizations for SystemUI and system_server,
# but also allow explicit overriding for testing and development.
SYSTEM_OPTIMIZE_JAVA ?= true
SYSTEMUI_OPTIMIZE_JAVA ?= true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# APEX
DISABLE_DEXPREOPT_CHECK := true

PRODUCT_PACKAGES += \
    com.google.android.permission

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/apex/com.google.android.permission.apex

# Euclid interfaces
PRODUCT_PACKAGES += \
    framework_compatibility_matrix.euclid.xml

# Config
PRODUCT_PACKAGES += \
    SimpleDeviceConfig

# Extra tools in euclid
PRODUCT_PACKAGES += \
    bash \
    curl \
    getcap \
    htop \
    nano \
    setcap \
    vim

PRODUCT_PACKAGES += \
    nano_recovery

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/curl \
    system/bin/getcap \
    system/bin/setcap \
    system/%/libzstd.so

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.ntfs \
    mkfs.ntfs \
    mount.ntfs

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/fsck.ntfs \
    system/bin/mkfs.ntfs \
    system/bin/mount.ntfs \
    system/%/libfuse-lite.so \
    system/%/libntfs-3g.so

# DeviceAsWebcam
ifeq ($(TARGET_BUILD_DEVICE_AS_WEBCAM), true)
    PRODUCT_PACKAGES += \
        DeviceAsWebcam

    PRODUCT_VENDOR_PROPERTIES += \
        ro.usb.uvc.enabled=true
endif

# Disable async MTE on a few processes
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    persist.arm64.memtag.app.com.android.se=off \
    persist.arm64.memtag.app.com.google.android.bluetooth=off \
    persist.arm64.memtag.app.com.android.nfc=off \
    persist.arm64.memtag.process.system_server=off

# Disable RescueParty due to high risk of data loss
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.disable_rescue=true
    
# Disable default frame rate limit for games
PRODUCT_PRODUCT_PROPERTIES += \
    debug.graphics.game_default_frame_rate.disabled=true

# Disable touch video heatmap to reduce latency, motion jitter, and CPU usage
# on supported devices with Deep Press input classifier HALs and models
PRODUCT_PRODUCT_PROPERTIES += \
    ro.input.video_enabled=false

# FRP
PRODUCT_COPY_FILES += \
    vendor/euclid/prebuilt/common/bin/wipe-frp.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/wipe-frp

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh


# Packages
PRODUCT_PACKAGES += \
    Launcher3QuickStep \
    ThemePicker

# rsync
PRODUCT_PACKAGES += \
    rsync

# Storage manager
PRODUCT_PRODUCT_PROPERTIES += \
    ro.storage_manager.enabled=true

# Gboard side padding
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.ime.kb_pad_port_l=4 \
    ro.com.google.ime.kb_pad_port_r=4 \
    ro.com.google.ime.kb_pad_land_l=64 \
    ro.com.google.ime.kb_pad_land_r=64

# Lineage-specific file
PRODUCT_COPY_FILES += \
    vendor/euclid/config/permissions/privapp-permissions-lineagehw.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-lineagehw.xml

# Skip boot JAR checks.
SKIP_BOOT_JARS_CHECK := true

# Default wifi country code
PRODUCT_PRODUCT_PROPERTIES += \
    ro.boot.wificountrycode?=00

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/procmem
endif

# Root
PRODUCT_PACKAGES += \
    adb_root
ifneq ($(TARGET_BUILD_VARIANT),user)
ifeq ($(WITH_SU),true)
PRODUCT_PACKAGES += \
    su

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/xbin/su
endif
endif

# SystemUI
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI

PRODUCT_PRODUCT_PROPERTIES += \
    dalvik.vm.systemuicompilerfilter=speed

ifneq ($(TARGET_BUILD_VARIANT),eng)
PRODUCT_PRODUCT_PROPERTIES += \
    debug.sf.enable_transaction_tracing=false
endif

PRODUCT_PACKAGE_OVERLAYS += \
    vendor/euclid/overlay/common

PRODUCT_PACKAGES += \
    DocumentsUIOverlay \
    NetworkStackOverlay \
    NfcOverlay \
    PermissionControllerOverlay 

# Translations
CUSTOM_LOCALES += \
    ast_ES \
    gd_GB \
    cy_GB \
    fur_IT

# Use a generic profile based boot image by default
PRODUCT_USE_PROFILE_FOR_BOOT_IMAGE := true
PRODUCT_DEX_PREOPT_BOOT_IMAGE_PROFILE_LOCATION := frameworks/base/boot/boot-image-profile.txt

include vendor/euclid/config/version.mk
include vendor/euclid/config/euclid.mk

# certification
include vendor/certification/config.mk

-include vendor/euclid-priv/keys/keys.mk

-include $(WORKSPACE)/build_env/image-auto-bits.mk
