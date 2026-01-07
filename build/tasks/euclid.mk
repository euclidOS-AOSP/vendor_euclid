# Copyright (C) 2017 Unlegacy-Android
# Copyright (C) 2017,2020 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# -----------------------------------------------------------------
# euclid OTA update package

EUCLID_TARGET_PACKAGE := $(PRODUCT_OUT)/euclidOS-$(EUCLID_BUILD_VERSION).zip

SHA256 := prebuilts/build-tools/path/$(HOST_PREBUILT_TAG)/sha256sum

BUILD_START := $(shell date +%s)
$(EUCLID_TARGET_PACKAGE): $(INTERNAL_OTA_PACKAGE_TARGET)
	$(hide) ln -f $(INTERNAL_OTA_PACKAGE_TARGET) $(EUCLID_TARGET_PACKAGE)
	$(hide) $(SHA256) $(EUCLID_TARGET_PACKAGE) > $(EUCLID_TARGET_PACKAGE).sha256sum
	$(hide) BUILD_END=$$(date +%s); \
	BUILD_DIFF=$$((BUILD_END - $(BUILD_START))); \
	echo -e ${CL_BLD}${CL_GRN}"==========================================================="${CL_RST}; \
	echo -e ${CL_BLD}${CL_GRN}"            🚀 BUILD COMPLETED SUCCESSFULLY 🚀             "${CL_RST}; \
	echo -e ${CL_BLD}${CL_GRN}"==========================================================="${CL_RST}; \
	./vendor/euclid/build/tasks/ascii_output.sh; \
	echo -e ${CL_BLD}${CL_RED}"🏷️   Version       : "${CL_GRN} $(EUCLID_VERSION)${CL_RST}; \
	echo -e ${CL_BLD}${CL_RED}"📱  Device         : "${CL_GRN} $(PRODUCT_DEVICE)${CL_RST}; \
	echo -e ${CL_BLD}${CL_RED}"👨‍💻  Maintainer     : "${CL_GRN} $(EUCLID_MAINTAINER)${CL_RST}; \
	echo -e ${CL_BLD}${CL_RED}"⏳   Build Start    : "$(shell date -d @$(BUILD_START))${CL_RST}; \
	echo -e ${CL_BLD}${CL_RED}"✅   Build End      : "$(shell date -d @$$BUILD_END)${CL_RST}; \
	echo -e ${CL_BLD}${CL_YLW}"⏱️   Duration       : $$(printf "%02d:%02d:%02d" $$((BUILD_DIFF/3600)) $$(((BUILD_DIFF/60)%60)) $$((BUILD_DIFF%60)))"${CL_RST}; \
	echo -e ${CL_BLD}${CL_RED}"💾  Package Size   : "${CL_GRN} $$(du -h $(EUCLID_TARGET_PACKAGE) | cut -f1)${CL_RST}; \
	echo -e ${CL_BLD}${CL_RED}"📦  ROM PATH       : "${CL_GRN} $(EUCLID_TARGET_PACKAGE)${CL_RST}; \
	echo -e ${CL_BLD}${CL_RED}"🔒  SHA256 File    : "${CL_GRN} $(EUCLID_TARGET_PACKAGE).sha256sum${CL_RST}; \
	echo -e ${CL_BLD}${CL_GRN}"==========================================================="${CL_RST}; \
	echo -e ${CL_BLD}${CL_GRN}"🎉           Thanks for building EuclidOS-AOSP           ❤️"${CL_RST}; \
	echo -e ${CL_BLD}${CL_GRN}"==========================================================="${CL_RST}; \
	echo ""

.PHONY: euclid
euclid: $(EUCLID_TARGET_PACKAGE)
