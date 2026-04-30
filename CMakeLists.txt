cmake_minimum_required(VERSION 3.10)
project(Dr_Quine C)

# ============================================================================
# PROJECT CONFIGURATION
# ============================================================================

set(PROJECT_VERSION "1.0.0")
set(PROJECT_DESCRIPTION "Self-Replicating Quine Programs in C")

# ============================================================================
# COMPILER SETTINGS (École 42 Compliant)
# ============================================================================

# Compiler flags
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra -Werror -g")

# Add include directories
include_directories(${PROJECT_SOURCE_DIR}/hdr)

# ============================================================================
# SOURCE FILES AND DIRECTORIES
# ============================================================================

# Define source directory
set(SRCDIR ${PROJECT_SOURCE_DIR}/src)
set(HDRDIR ${PROJECT_SOURCE_DIR}/hdr)
set(OBJDIR ${PROJECT_BINARY_DIR}/obj)
set(OUTDIR ${PROJECT_BINARY_DIR}/output)

# Create output directory
file(MAKE_DIRECTORY ${OUTDIR})

# ============================================================================
# COLLEEN PROGRAM
# ============================================================================

add_executable(Colleen ${SRCDIR}/colleen.c)
target_include_directories(Colleen PRIVATE ${HDRDIR})
target_compile_options(Colleen PRIVATE -Wall -Wextra -Werror -g)

# ============================================================================
# GRACE PROGRAM
# ============================================================================

add_executable(Grace ${SRCDIR}/grace.c)
target_include_directories(Grace PRIVATE ${HDRDIR})
target_compile_options(Grace PRIVATE -Wall -Wextra -Werror -g)

# ============================================================================
# SULLY PROGRAM
# ============================================================================

add_executable(Sully ${SRCDIR}/sully.c)
target_include_directories(Sully PRIVATE ${HDRDIR})
target_compile_options(Sully PRIVATE -Wall -Wextra -Werror -g)

# ============================================================================
# CUSTOM TARGETS
# ============================================================================

# Custom target for norm checking
add_custom_target(norm
	COMMAND ${CMAKE_COMMAND} -P ${PROJECT_SOURCE_DIR}/cmake/Norm.cmake
	WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
	COMMENT "Checking École 42 norm compliance..."
)

# Custom target for cppcheck
add_custom_target(cppcheck
	COMMAND cppcheck --enable=all --inconclusive --std=c99 --force
		--suppress=missingIncludeSystem --suppress=unusedFunction
		-I${HDRDIR} --quiet ${SRCDIR}
	WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
	COMMENT "Running cppcheck static analysis..."
)

# Custom target for tests
add_custom_target(test_quines
	COMMAND ${CMAKE_COMMAND} -P ${PROJECT_SOURCE_DIR}/cmake/Tests.cmake
	WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
	COMMENT "Running quine verification tests..."
	DEPENDS Colleen Grace Sully
)

# ============================================================================
# BUILD CONFIGURATION
# ============================================================================

# Set output directories
set_target_properties(Colleen Grace Sully PROPERTIES
	RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}
)

# ============================================================================
# PROJECT SUMMARY
# ============================================================================

message(STATUS "")
message(STATUS "╔════════════════════════════════════════════════════════╗")
message(STATUS "║           Dr_Quine - Self-Replicating Programs         ║")
message(STATUS "║                  CMake v${PROJECT_VERSION}                           ║")
message(STATUS "╚════════════════════════════════════════════════════════╝")
message(STATUS "")
message(STATUS "Project: ${PROJECT_NAME}")
message(STATUS "Version: ${PROJECT_VERSION}")
message(STATUS "Description: ${PROJECT_DESCRIPTION}")
message(STATUS "")
message(STATUS "Build Configuration:")
message(STATUS "  Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "  C Standard: ${CMAKE_C_STANDARD}")
message(STATUS "  Compiler: ${CMAKE_C_COMPILER}")
message(STATUS "  CFLAGS: ${CMAKE_C_FLAGS}")
message(STATUS "")
message(STATUS "Directories:")
message(STATUS "  Source: ${SRCDIR}")
message(STATUS "  Headers: ${HDRDIR}")
message(STATUS "  Build: ${PROJECT_BINARY_DIR}")
message(STATUS "  Objects: ${OBJDIR}")
message(STATUS "  Output: ${OUTDIR}")
message(STATUS "")
message(STATUS "Targets:")
message(STATUS "  Executable: Colleen (stdout quine)")
message(STATUS "  Executable: Grace (file writing quine)")
message(STATUS "  Executable: Sully (parametric quine)")
message(STATUS "")
message(STATUS "Custom Targets:")
message(STATUS "  make norm - Check norm compliance")
message(STATUS "  make cppcheck - Run static analysis")
message(STATUS "  make test_quines - Run verification tests")
message(STATUS "")
