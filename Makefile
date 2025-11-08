NVCC       := nvcc
NVCCFLAGS  := -O3 -Iinclude --fmad=false -DMEASURE_TIME -std=c++17

SRC_DIR    := src
BUILD_DIR  := build
TARGET     := t1

C_SRCS     := $(shell find $(SRC_DIR) -name '*.c') \
			$(shell find $(SRC_DIR) -name '*.cu')

OBJS       := \
    $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(C_SRCS)) \
    $(patsubst $(SRC_DIR)/%.cu,$(BUILD_DIR)/%.o,$(CU_SRCS))

.PHONY: all clean dirs

all: dirs $(TARGET)

$(TARGET): $(OBJS)
	$(NVCC) $(NVCCFLAGS) $(OBJS) -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(NVCC) $(NVCCFLAGS) -x cu -c $< -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cu
	@mkdir -p $(dir $@)
	$(NVCC) $(NVCCFLAGS) -c $< -o $@

dirs:
	@mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)
