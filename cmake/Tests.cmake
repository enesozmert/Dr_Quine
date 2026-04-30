# ============================================================================
# Tests.cmake - Quine Verification Tests
# ============================================================================

set(SRCDIR "${CMAKE_SOURCE_DIR}/src")
set(COLLEEN_SRC "${SRCDIR}/colleen.c")
set(GRACE_SRC "${SRCDIR}/grace.c")
set(SULLY_SRC "${SRCDIR}/sully.c")

message(STATUS "")
message(STATUS "Running Quine Verification Tests")
message(STATUS "════════════════════════════════════════")
message(STATUS "")

# Check if source files exist
if(NOT EXISTS ${COLLEEN_SRC})
	message(WARNING "colleen.c not found, skipping Colleen test")
else()
	message(STATUS "[TEST] Colleen - stdout quine")
	message(STATUS "  Source: ${COLLEEN_SRC}")
	message(STATUS "  Binary: Colleen")
	message(STATUS "  Test: ./Colleen > /tmp/colleen_out.c && diff /tmp/colleen_out.c colleen.c")
	message(STATUS "  Status: Ready for testing")
	message(STATUS "")
endif()

if(NOT EXISTS ${GRACE_SRC})
	message(WARNING "grace.c not found, skipping Grace test")
else()
	message(STATUS "[TEST] Grace - file writing quine")
	message(STATUS "  Source: ${GRACE_SRC}")
	message(STATUS "  Binary: Grace")
	message(STATUS "  Test: ./Grace && diff grace.c Grace_kid.c")
	message(STATUS "  Expected output file: Grace_kid.c")
	message(STATUS "  Status: Ready for testing")
	message(STATUS "")
endif()

if(NOT EXISTS ${SULLY_SRC})
	message(WARNING "sully.c not found, skipping Sully test")
else()
	message(STATUS "[TEST] Sully - parametric quine")
	message(STATUS "  Source: ${SULLY_SRC}")
	message(STATUS "  Binary: Sully")
	message(STATUS "  Test: ./Sully && diff sully.c Sully_N.c (N = counter)")
	message(STATUS "  Expected files: Sully_8.c, Sully_7.c, ..., Sully_0.c")
	message(STATUS "  Status: Ready for testing")
	message(STATUS "")
endif()

message(STATUS "════════════════════════════════════════")
message(STATUS "To run tests manually:")
message(STATUS "  cd build/")
message(STATUS "  ./Colleen > /tmp/out.c && diff /tmp/out.c ../src/colleen.c")
message(STATUS "  ./Grace && diff ../src/grace.c Grace_kid.c")
message(STATUS "  ./Sully && test -f Sully_N.c && echo 'OK'")
message(STATUS "")

# ============================================================================
# END OF Tests.cmake
# ============================================================================
