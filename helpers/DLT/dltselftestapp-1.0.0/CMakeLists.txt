#######
# SPDX license identifier: MPL-2.0
#
# Copyright (C) 2011-2015, BMW AG
#
# This file is part of GENIVI Project DLT - Diagnostic Log and Trace.
#
# This Source Code Form is subject to the terms of the
# Mozilla Public License (MPL), v. 2.0.
# If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.
#
# For further information see http://www.genivi.org/.
#######

#
# DLT example implementation
#

cmake_minimum_required( VERSION 2.6 )
project( automotive-dlt-DLTSelfTestApp )

#
# find dependency packages
#

find_package(PkgConfig)
pkg_check_modules(DLT REQUIRED automotive-dlt)

#
# include directories
#

include_directories(
    ${DLT_INCLUDE_DIRS}
)

#
# build project
#

set(DLTSelfTestApp_SRCS DLTSelfTestApp.c)
add_executable(DLTSelfTestApp ${DLTSelfTestApp_SRCS})
target_link_libraries(DLTSelfTestApp ${DLT_LIBRARIES})
set_target_properties(DLTSelfTestApp PROPERTIES LINKER_LANGUAGE C)

install(TARGETS DLTSelfTestApp
	RUNTIME DESTINATION /opt/bosch/robfw/dlt
	COMPONENT base)
