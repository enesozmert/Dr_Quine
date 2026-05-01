cmake_minimum_required(VERSION 3.10)
# C as the only mandatory language; NASM is opt-in (Linux only).
project(Dr_Quine C)

# ============================================================================
# WINDOWS: refuse non-ASCII paths with mingw32-make (UTF-8 mojibake bug)
# ============================================================================

if(WIN32 AND CMAKE_GENERATOR STREQUAL "MinGW Makefiles")
    string(REGEX MATCH "[^A-Za-z0-9_/:.\\\\ -]" _has_nonascii "${PROJECT_SOURCE_DIR}")
    if(_has_nonascii)
        message(FATAL_ERROR
            "\n"
            "  ┌─ Path contains non-ASCII characters ──────────────────────────┐\n"
            "  │  ${PROJECT_SOURCE_DIR}\n"
            "  │\n"
            "  │  mingw32-make cannot handle UTF-8 paths and will fail with\n"
            "  │  'No rule to make target ...' garbled errors.\n"
            "  └────────────────────────────────────────────────────────────────┘\n"
            "\n"
            "  Pick ONE of these fixes:\n"
            "\n"
            "  ▶ A) Use Ninja generator (recommended — Ninja handles UTF-8):\n"
            "       choco install ninja\n"
            "       rmdir /S /Q build && mkdir build && cd build\n"
            "       cmake -G \"Ninja\" ..\n"
            "       cmake --build . --target c\n"
            "\n"
            "  ▶ B) Move the project to an ASCII path:\n"
            "       robocopy . C:\\\\dev\\\\Dr_Quine /E\n"
            "       cd C:\\\\dev\\\\Dr_Quine\n"
            "\n"
            "  ▶ C) Use Docker (full Linux toolchain incl. ASM):\n"
            "       docker run --rm -v \"%cd%\":/app dr_quine:latest make all\n"
            "\n"
        )
    endif()
endif()

# ============================================================================
# PROJECT CONFIGURATION
# ============================================================================

set(PROJECT_VERSION "2.0.0")
set(PROJECT_DESCRIPTION "Self-Replicating Quine Programs (C + Assembly)")

# ============================================================================
# COMPILER SETTINGS (École 42 Compliant)
# ============================================================================

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra -Werror -O2 -Wno-format-security")

# ============================================================================
# NASM (optional — Linux x86-64 only)
# ============================================================================

set(BUILD_ASM FALSE)
if(UNIX AND NOT APPLE)
    find_program(NASM_EXECUTABLE nasm)
    if(NASM_EXECUTABLE)
        set(BUILD_ASM TRUE)
        set(CMAKE_ASM_NASM_OBJECT_FORMAT elf64)
        set(CMAKE_ASM_NASM_FLAGS "-f elf64")
        message(STATUS "NASM found: ${NASM_EXECUTABLE} — ASM targets enabled")
    else()
        message(STATUS "NASM not found — ASM targets will be skipped")
    endif()
else()
    message(STATUS "Non-Linux platform — ASM targets disabled (use Docker)")
endif()

# ============================================================================
# DIRECTORIES
# ============================================================================

set(CDIR ${PROJECT_SOURCE_DIR}/C)
set(ASMDIR ${PROJECT_SOURCE_DIR}/ASM)
set(TESTDIR ${PROJECT_SOURCE_DIR}/tests)

# All build outputs go to output/C and output/ASM at project root
set(OUTPUT_C   ${PROJECT_SOURCE_DIR}/output/C)
set(OUTPUT_ASM ${PROJECT_SOURCE_DIR}/output/ASM)

file(MAKE_DIRECTORY ${OUTPUT_C})
file(MAKE_DIRECTORY ${OUTPUT_ASM})

# ============================================================================
# C QUINE PROGRAMS (C -> output/C)
# ============================================================================

add_executable(Colleen ${CDIR}/Colleen.c)
target_compile_options(Colleen PRIVATE -Wall -Wextra -Werror -Wno-format-security)
set_target_properties(Colleen PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_C}
)
add_custom_command(TARGET Colleen POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy ${CDIR}/Colleen.c ${OUTPUT_C}/Colleen.c
)

add_executable(Grace ${CDIR}/Grace.c)
target_compile_options(Grace PRIVATE -Wall -Wextra -Werror -Wno-format-security)
set_target_properties(Grace PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_C}
)
add_custom_command(TARGET Grace POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy ${CDIR}/Grace.c ${OUTPUT_C}/Grace.c
)

add_executable(Sully ${CDIR}/Sully.c)
target_compile_options(Sully PRIVATE -Wall -Wextra -Werror -Wno-format-security)
set_target_properties(Sully PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_C}
)
add_custom_command(TARGET Sully POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy ${CDIR}/Sully.c ${OUTPUT_C}/Sully.c
)

# ============================================================================
# ASSEMBLY QUINE PROGRAMS (ASM -> output/ASM)
# CMake's NASM support is unreliable for raw _start binaries with `ld`.
# We delegate to the existing ASM/Makefile which is already correct.
# ============================================================================

if(BUILD_ASM)
    add_custom_target(asm ALL
        COMMAND $(MAKE) -C ${ASMDIR} all
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        COMMENT "Building Assembly quines via ASM/Makefile"
    )
endif()

# ============================================================================
# AGGREGATE TARGETS
# ============================================================================

add_custom_target(c DEPENDS Colleen Grace Sully)

# `cmake --build . --target all_quines` builds C + ASM
if(BUILD_ASM)
    add_custom_target(all_quines DEPENDS Colleen Grace Sully asm)
else()
    add_custom_target(all_quines DEPENDS Colleen Grace Sully)
endif()

# ============================================================================
# QA TARGETS — invoke project shell scripts (cross-platform via bash)
# ============================================================================

if(WIN32)
    # On Windows: prefer Git Bash / MSYS2; AVOID WSL's bash.exe (mojibake on UTF-8 paths)
    find_program(BASH_EXECUTABLE NAMES bash
        PATHS
            "C:/Program Files/Git/bin"
            "C:/Program Files/Git/usr/bin"
            "C:/Program Files (x86)/Git/bin"
            "C:/msys64/usr/bin"
            "C:/cygwin64/bin"
        NO_DEFAULT_PATH
    )
    # If still not found anywhere, fallback to default search
    if(NOT BASH_EXECUTABLE)
        find_program(BASH_EXECUTABLE NAMES bash)
    endif()
    # Reject WSL's bash.exe if that's all we have — it doesn't handle Windows UTF-8 paths
    if(BASH_EXECUTABLE MATCHES "System32" OR BASH_EXECUTABLE MATCHES "WindowsApps")
        message(WARNING
            "WSL bash detected (${BASH_EXECUTABLE}). It mojibakes UTF-8 paths.\n"
            "  Install Git for Windows: choco install git -y\n"
            "  Then re-run: rm -rf build && cmake -G Ninja .."
        )
        set(BASH_EXECUTABLE "BASH_NOTFOUND")
    endif()
else()
    find_program(BASH_EXECUTABLE NAMES bash sh)
endif()

if(NOT BASH_EXECUTABLE OR BASH_EXECUTABLE STREQUAL "BASH_NOTFOUND")
    message(WARNING "Usable bash not found — QA targets (norm/cppcheck/test) won't run")
    set(BASH_EXECUTABLE "bash")  # placeholder
else()
    message(STATUS "bash:    ${BASH_EXECUTABLE}")
endif()

# Norminette (école 42 norm check)
add_custom_target(norm
    COMMAND ${BASH_EXECUTABLE} ${PROJECT_SOURCE_DIR}/scripts/check_norm.sh
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    COMMENT "Running norminette (école 42 norm check)..."
)

# Cppcheck (static analysis)
add_custom_target(cppcheck
    COMMAND ${BASH_EXECUTABLE} ${PROJECT_SOURCE_DIR}/scripts/check_cppcheck.sh
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    COMMENT "Running cppcheck static analysis..."
)

# PDF spec validation tests
add_custom_target(test_quines
    COMMAND ${BASH_EXECUTABLE} ${TESTDIR}/test_quines.sh
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    DEPENDS Colleen Grace Sully
    COMMENT "Running PDF spec validation (test_quines.sh)..."
)

# Crash & error-handling tests (PDF §IV)
add_custom_target(test_errors
    COMMAND ${BASH_EXECUTABLE} ${TESTDIR}/test_errors.sh
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    DEPENDS Colleen Grace Sully
    COMMENT "Running crash/error handling tests (PDF §IV)..."
)

# Master test runner
add_custom_target(test_all
    COMMAND ${BASH_EXECUTABLE} ${TESTDIR}/test_all.sh
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    DEPENDS Colleen Grace Sully
    COMMENT "Running all test suites (test_all.sh)..."
)

# Full QA pipeline: build + norm + cppcheck + tests + relink check
add_custom_target(qa
    COMMAND ${BASH_EXECUTABLE} ${PROJECT_SOURCE_DIR}/scripts/check_all.sh
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    COMMENT "Running full QA pipeline (scripts/check_all.sh)..."
)

# ============================================================================
# SUMMARY
# ============================================================================

message(STATUS "")
message(STATUS "╔════════════════════════════════════════════════════════╗")
message(STATUS "║      Dr_Quine v${PROJECT_VERSION}                              ║")
message(STATUS "╚════════════════════════════════════════════════════════╝")
message(STATUS "  Source:  ${CDIR}, ${ASMDIR}")
message(STATUS "  Outputs: ${OUTPUT_C}, ${OUTPUT_ASM}")
message(STATUS "  CFLAGS:  ${CMAKE_C_FLAGS}")
message(STATUS "")
