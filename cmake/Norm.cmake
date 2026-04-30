# ============================================================================
# Norm.cmake - École 42 Norm Compliance Checker
# ============================================================================

find_program(NORMINETTE norminette)

if(NOT NORMINETTE)
	message(FATAL_ERROR "norminette not found. Install it using: pip3 install norminette")
endif()

# Get source directory
set(SRCDIR "${CMAKE_SOURCE_DIR}/src")
set(HDRDIR "${CMAKE_SOURCE_DIR}/hdr")

# Find all .c and .h files
file(GLOB_RECURSE C_FILES "${SRCDIR}/*.c")
file(GLOB_RECURSE H_FILES "${HDRDIR}/*.h")

# Combine files to check
set(FILES_TO_CHECK ${C_FILES} ${H_FILES})

if(NOT FILES_TO_CHECK)
	message(WARNING "No source files found to check")
	return()
endif()

message(STATUS "Running norminette on source files...")

# Run norminette
execute_process(
	COMMAND ${NORMINETTE} -R CheckForbiddenSourceHeader ${FILES_TO_CHECK}
	RESULT_VARIABLE NORM_RESULT
	OUTPUT_VARIABLE NORM_OUTPUT
	ERROR_VARIABLE NORM_ERROR
)

# Print output
if(NORM_OUTPUT)
	message("${NORM_OUTPUT}")
endif()

if(NORM_ERROR)
	message("${NORM_ERROR}")
endif()

# Check result
if(NORM_RESULT EQUAL 0)
	message(STATUS "✓ Norm check passed!")
else()
	message(STATUS "✗ Norm check failed with code ${NORM_RESULT}")
endif()

# ============================================================================
# END OF Norm.cmake
# ============================================================================
