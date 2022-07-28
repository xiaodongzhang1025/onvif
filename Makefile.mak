CROSS_COMPILE = #arm-openwrt-linux-muslgnueabi-
CC = $(CROSS_COMPILE)gcc
C++ = $(CROSS_COMPILE)g++
LINK = $(CROSS_COMPILE)g++
AR = $(CROSS_COMPILE)ar
STRIP = $(CROSS_COMPILE)strip

# user modify here
LIB_PATHS = ./ ../
#
INC_PATHS = ./ ../ ../custom ../import ../plugin
#
SRC_PATHS = ./ 
#
TARGET = sample_test
TARGET_LIB = 

TARGET_STATIC = $(TARGET)_static
TARGET_DYNAMIC = #$(TARGET)_dynamic
CFILES =  $(foreach n, $(SRC_PATHS), $(wildcard $(n)/*.c)) 
C++FILES = $(foreach n, $(SRC_PATHS), $(wildcard $(n)/*.cc $(n)/*.cpp)) 

DYNAMIC_LIBS_WITH_PATH = $(foreach n, $(LIB_PATHS), $(wildcard $(n)/*.so))
STATIC_LIBS_WITH_PATH = $(foreach n, $(LIB_PATHS), $(wildcard $(n)/*.a))
DYNAMIC_LIBS = $(foreach n, $(DYNAMIC_LIBS_WITH_PATH), -l$(patsubst lib%,%,$(patsubst %.so,%,$(notdir $(n)))))
STATIC_LIBS  = $(foreach n, $(STATIC_LIBS_WITH_PATH), -l$(patsubst lib%,%,$(patsubst %.a,%,$(notdir $(n)))))

INCLUDES = $(foreach n, $(INC_PATHS), -I$(n))
LDFLAGS = $(foreach n, $(LIB_PATHS), -L$(n))

STATIC_LDFLAGS = $(LDFLAGS) -Wl,-Bstatic -Wl,--start-group $(STATIC_LIBS) -Wl,--end-group -Wl,-Bdynamic -ldl  -lrt  -lpthread 
DYNAMIC_LDFLAGS = $(LDFLAGS) -Wl,-Bdynamic -Wl,--start-group $(DYNAMIC_LIBS) -Wl,--end-group -ldl  -lrt  -lpthread 

CCFLAGS = -c -g -fPIC  $(INCLUDES)
C++FLAGS = -c -g -fPIC $(INCLUDES)
OBJS = $(CFILES:%=%.o) $(C++FILES:%=%.o)
DEPS = $(OBJS:%=%.d)


all:$(TARGET_STATIC) $(TARGET_DYNAMIC)  # $(TARGET_LIB).so  $(TARGET_LIB).a

$(TARGET_LIB).so : $(OBJS)
	$(CXX) -shared -o $@ $^
$(TARGET_LIB).a : $(OBJS) 
	$(AR) -rcs -o $@  $^ 

$(TARGET_STATIC): $(OBJS)
	@echo "==> build static..."
	$(LINK) -o $@  $^  $(STATIC_LDFLAGS)
	$(STRIP) $(TARGET_STATIC)

$(TARGET_DYNAMIC): $(OBJS)
	@echo "==> build dynamic..."
	$(LINK) -o $@  $^  $(DYNAMIC_LDFLAGS)
	$(STRIP) $(TARGET_DYNAMIC)

$(filter %.c.o , $(OBJS)): %.o:%
	$(CC) $(CCFLAGS) -o $@  $< -MD -MP -MF $(@:%=%.d)

$(filter %.cpp.o %.cc.o, $(OBJS)): %.o:%
	$(C++) $(C++FLAGS) -o $@  $< -MD -MP -MF $(@:%=%.d)

clean:
	rm -rf $(TARGET_STATIC)
	rm -rf $(TARGET_DYNAMIC)
	rm -rf $(OBJS)
	rm -rf $(DEPS)
	rm -rf *.o
	rm -rf *.d

-include $(DEPS)