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

RESET  := \033[0m
BOLD   := \033[1m
WHITE  := \033[97m
BLUE   := \033[34m
PURPLE := \033[35m
CLBLD  := \033[1m
CLGRN  := \033[32m
CL_RST := \033[0m

BUILD_START := $(shell date +%s)

$(EUCLID_TARGET_PACKAGE): $(INTERNAL_OTA_PACKAGE_TARGET)
	$(hide) ln -f $(INTERNAL_OTA_PACKAGE_TARGET) $(EUCLID_TARGET_PACKAGE)
	$(hide) $(SHA256) $(EUCLID_TARGET_PACKAGE) > $(EUCLID_TARGET_PACKAGE).sha256sum
	$(hide) BUILD_END=$$(date +%s); \
	BUILD_DIFF=$$((BUILD_END - $(BUILD_START))); \
	DURATION_FORMAT="$$(printf "%02d:%02d (mm:ss)" $$((BUILD_DIFF/60)) $$((BUILD_DIFF%60)))"; \
	FILE_SIZE="$$(du -h $(EUCLID_TARGET_PACKAGE) | cut -f1)"; \
	ZIP_PATH="$(EUCLID_TARGET_PACKAGE)"; \
	./vendor/euclid/build/tools/generate_build_json.py "$${ZIP_PATH}"; \
	./vendor/euclid/build/tasks/ascii_output.sh; \
	echo -e "${WHITE}${RESET} ${BOLD}Version${RESET}     ${WHITE}: $(EUCLID_VERSION)${RESET}"; \
	echo -e "${WHITE}${RESET} ${BOLD}Device${RESET}      ${WHITE}: $(PRODUCT_DEVICE)${RESET}"; \
	echo -e "${WHITE}${RESET} ${BOLD}Maintainer${RESET}  ${WHITE}: $(EUCLID_MAINTAINER)${RESET}"; \
	echo -e "${WHITE}${RESET} ${BOLD}File Size${RESET}   ${WHITE}: $${FILE_SIZE}${RESET}"; \
	echo -e "${WHITE}${RESET} ${BOLD}Build Time${RESET}  ${WHITE}: $${DURATION_FORMAT}${RESET}"; \
	echo -e "${WHITE}${RESET} ${BOLD}Zip File${RESET}    ${WHITE}: $$(basename "$${ZIP_PATH}")${RESET}"; \
	echo -e "${BLUE} Output ${RESET}      ${WHITE}: $${ZIP_PATH}${RESET}"; \
	echo -e "${PURPLE}===========================================================${CL_RST}"; \
	echo -e "${CLBLD}${CLGRN}            🚀 BUILD COMPLETED SUCCESSFULLY 🚀             ${CL_RST}"; \
	echo -e "${PURPLE}===========================================================${CL_RST}"; \
	echo -e ""

.PHONY: euclid
euclid: $(EUCLID_TARGET_PACKAGE) $(DEFAULT_GOAL)
