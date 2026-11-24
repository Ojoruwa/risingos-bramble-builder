#!/bin/bash
set -e

cd ~/rising

# 1. Fail early if Lineage file is missing
if [ ! -f device/google/bramble/lineage_bramble.mk ]; then
  echo "ERROR: lineage_bramble.mk not found, sync failed"
  exit 1
fi

# 2. Recreate from scratch every time, so no duplicate append
cp device/google/bramble/lineage_bramble.mk device/google/bramble/rising_bramble.mk

# 3. Rename product inside the file
sed -i 's/lineage_bramble/rising_bramble/g' device/google/bramble/rising_bramble.mk

# 4. Add your maintainer info and first-build settings
cat >> device/google/bramble/rising_bramble.mk << 'EOF'

# RisingOS - Ojoruwa - bramble - Vanilla first build
RISING_MAINTAINER := Ojoruwa
PRODUCT_BUILD_PROP_OVERRIDES += \
    RisingChipset="Snapdragon 765G" \
    RisingMaintainer="Ojoruwa"

# Keep first build fast and smooth on 6GB RAM / 60Hz panel
TARGET_ENABLE_BLUR := false

# Vanilla build - no Google apps in this build
WITH_GMS := false
EOF

# 5. Make sure AndroidProducts.mk knows about rising_bramble
if ! grep -q "rising_bramble" device/google/bramble/AndroidProducts.mk; then
  echo 'PRODUCT_MAKEFILES += $(LOCAL_DIR)/rising_bramble.mk' >> device/google/bramble/AndroidProducts.mk
fi

echo "rising_bramble.mk ready for Ojoruwa"
cat device/google/bramble/rising_bramble.mk
