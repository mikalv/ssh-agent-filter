# Copyright (C) 2013 Timo Weingärtner <timo@tiwe.de>
#
# This file is part of ssh-agent-filter.
#
# ssh-agent-filter is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ssh-agent-filter is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with ssh-agent-filter.  If not, see <http://www.gnu.org/licenses/>.


CXXFLAGS ?= -g -O2 -Wall -Wold-style-cast

CXXFLAGS += -std=c++11
LDFLAGS += -lboost_program_options -lboost_filesystem -lboost_system -lnettle

all: ssh-agent-filter.1 afssh.1

%.1: %.1.md
	pandoc -s -w man $< -o $@

ssh-agent-filter.1: ssh-agent-filter
	help2man -n $< -o $@ -N ./$<

ssh-agent-filter: ssh-agent-filter.o

ssh-agent-filter.o: ssh-agent-filter.C rfc4251.h ssh-agent.h version.h

version.h:
	test ! -d .git || git describe | sed 's/^.*$$/#define SSH_AGENT_FILTER_VERSION "ssh-agent-filter \0"/' > $@

clean:
	$(RM) *.1 ssh-agent-filter *.o

.PHONY: version.h
