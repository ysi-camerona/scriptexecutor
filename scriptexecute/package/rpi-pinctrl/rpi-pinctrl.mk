################################################################################
#
# rpi-pinctrl
#
################################################################################

RPI_PINCTRL_VERSION = 2a79d719687d5cea097927069434b8075df06850
RPI_PINCTRL_SITE = $(call github,raspberrypi,utils,$(RPI_PINCTRL_VERSION))
RPI_PINCTRL_LICENSE = BSD-3-Clause
RPI_PINCTRL_LICENSE_FILES = LICENSE
RPI_PINCTRL_INSTALL_TARGET = YES
RPI_PINCTRL_SUBDIR = pinctrl

$(eval $(cmake-package))